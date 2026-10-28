# Refresh code-analysis data only; actual UE builds continue to use MSVC.
[CmdletBinding()]
param(
    [string]$ProjectRoot,
    [string]$EngineRoot = 'E:\UE\UE_5.8',
    [switch]$IfNeeded
)

$ErrorActionPreference = 'Stop'
# Windows PowerShell 5.1 may not populate PSScriptRoot while evaluating
# parameter defaults when launched through powershell.exe -File.
if ([string]::IsNullOrWhiteSpace($ProjectRoot)) {
    $ProjectRoot = Split-Path -Parent $PSScriptRoot
}
$databaseDirectory = Join-Path $PSScriptRoot 'clangd'
$projectFile = Join-Path $ProjectRoot 'ProvingGround.uproject'
$cppProperties = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'c_cpp_properties.json') -Raw | ConvertFrom-Json
$compilerPath = $cppProperties.configurations[0].compilerPath
$compilerVersion = (Get-Item -LiteralPath $compilerPath).VersionInfo
$compatibilityVersion = '{0}.{1}' -f $compilerVersion.FileMajorPart, $compilerVersion.FileMinorPart
$dotnet = Join-Path $EngineRoot 'Engine\Binaries\ThirdParty\DotNet\10.0\win-x64\dotnet.exe'
$ubt = Join-Path $EngineRoot 'Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.dll'
$compilerFamily = if ($compilerVersion.FileMinorPart -ge 50) { 'VisualStudio2026' } else { 'VisualStudio2022' }

# New files and module/target settings affect compile commands. Editing the body
# of an existing source file does not require regenerating the database.
$fingerprintParts = @($ProjectRoot, $EngineRoot, $compilerPath, $compatibilityVersion)
$fingerprintParts += (Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash
$inputFiles = @()
foreach ($root in @((Join-Path $ProjectRoot 'Source'), (Join-Path $ProjectRoot 'Plugins'))) {
    if (Test-Path -LiteralPath $root) {
        $inputFiles += Get-ChildItem -LiteralPath $root -Recurse -File |
            Where-Object { $_.FullName -notmatch '\\(Intermediate|Binaries|Saved)\\' -and
                ($_.Extension -in @('.cpp', '.c', '.cc', '.cxx', '.h', '.hpp', '.inl', '.uplugin') -or
                 $_.Name -like '*.Build.cs' -or $_.Name -like '*.Target.cs') }
    }
}
foreach ($file in @($inputFiles | Sort-Object FullName)) {
    $fingerprintParts += $file.FullName
    if ($file.Extension -eq '.uplugin' -or $file.Name -like '*.Build.cs' -or $file.Name -like '*.Target.cs') {
        $fingerprintParts += (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
    }
}
$fingerprintParts += (Get-FileHash -LiteralPath $projectFile -Algorithm SHA256).Hash
$hashAlgorithm = [Security.Cryptography.SHA256]::Create()
try {
    $fingerprint = [BitConverter]::ToString($hashAlgorithm.ComputeHash(
        [Text.Encoding]::UTF8.GetBytes(($fingerprintParts -join "`n")))).Replace('-', '')
} finally {
    $hashAlgorithm.Dispose()
}
$databaseFile = Join-Path $databaseDirectory 'compile_commands.json'
$stateFile = Join-Path $databaseDirectory 'refresh-state.json'
if ($IfNeeded -and (Test-Path -LiteralPath $databaseFile) -and (Test-Path -LiteralPath $stateFile)) {
    try {
        $state = Get-Content -LiteralPath $stateFile -Raw | ConvertFrom-Json
        $responsesValid = @($state.ResponseFiles).Count -gt 0
        foreach ($response in @($state.ResponseFiles)) {
            if (!$response -or !(Test-Path -LiteralPath $response.Path) -or
                (Get-FileHash -LiteralPath $response.Path -Algorithm SHA256).Hash -ne $response.Hash) {
                $responsesValid = $false
                break
            }
        }
        if ($state.Fingerprint -eq $fingerprint -and
            $state.DatabaseHash -eq (Get-FileHash -LiteralPath $databaseFile -Algorithm SHA256).Hash -and
            $responsesValid) {
            Write-Output 'clangd database is current; refresh skipped.'
            return
        }
    } catch {
        Write-Warning 'clangd refresh state could not be read; regenerating the database.'
    }
}

New-Item -ItemType Directory -Path $databaseDirectory -Force | Out-Null
& $dotnet $ubt '-Mode=GenerateClangDatabase' 'ProvingGroundEditor' 'Win64' 'Development' `
    "-Project=$projectFile" "-Compiler=$compilerFamily" "-OutputDir=$databaseDirectory" `
    '-OutputFilename=compile_commands.ubt.json' `
    "-Include=$ProjectRoot\Source\..." "-Include=$ProjectRoot\Plugins\..." '-NoExecCodeGenActions'
if ($LASTEXITCODE -ne 0) {
    throw "UBT compilation database generation failed ($LASTEXITCODE)."
}

[object[]]$entries = Get-Content -LiteralPath (Join-Path $databaseDirectory 'compile_commands.ubt.json') -Raw | ConvertFrom-Json
if ($entries.Count -eq 0) {
    throw 'UBT produced an empty compilation database.'
}

# UBT's no-PCH analysis response files share paths with normal MSVC builds.
# Snapshot them so a later real build cannot silently change clangd's flags.
$responseDirectory = Join-Path $databaseDirectory 'responses'
New-Item -ItemType Directory -Path $responseDirectory -Force | Out-Null
$responseSnapshots = @{}
function Save-AnalysisResponse([string]$Reference, [string]$WorkingDirectory) {
    $sourcePath = $Reference.Trim('"')
    if (![IO.Path]::IsPathRooted($sourcePath)) {
        $sourcePath = Join-Path $WorkingDirectory $sourcePath
    }
    $sourcePath = [IO.Path]::GetFullPath($sourcePath)
    if (!$responseSnapshots.ContainsKey($sourcePath)) {
        $contents = [IO.File]::ReadAllText($sourcePath)
        if ($contents -cmatch '(?m)^\s*/(?:Yu|Fp)' -or $contents -match '(?im)^\s*/FI.*SharedPCH') {
            throw "Unexpected MSVC PCH flags in analysis response file: $sourcePath"
        }
        $nameHasher = [Security.Cryptography.SHA256]::Create()
        try {
            $suffix = [BitConverter]::ToString($nameHasher.ComputeHash(
                [Text.Encoding]::UTF8.GetBytes($sourcePath))).Replace('-', '').Substring(0, 12)
        } finally {
            $nameHasher.Dispose()
        }
        $copyPath = Join-Path $responseDirectory ($suffix + '-' + [IO.Path]::GetFileName($sourcePath))
        $responseSnapshots[$sourcePath] = $copyPath.Replace('\', '/')
        foreach ($nested in [regex]::Matches($contents, '(?m)^\s*@("[^"]+"|\S+)')) {
            $nestedCopy = Save-AnalysisResponse $nested.Groups[1].Value $WorkingDirectory
            $contents = $contents.Replace($nested.Value.Trim(), ('@"' + $nestedCopy + '"'))
        }
        [IO.File]::WriteAllText($copyPath, $contents, (New-Object Text.UTF8Encoding($false)))
    }
    return $responseSnapshots[$sourcePath]
}

# clangd otherwise defaults to emulating MSVC 19.33, below UE 5.8's minimum.
# Change analysis commands only; keep the actual MSVC build settings intact.
$analysisFlag = '/clang:-fms-compatibility-version=' + $compatibilityVersion
foreach ($entry in $entries) {
    if ($entry.PSObject.Properties['command']) {
        foreach ($match in [regex]::Matches($entry.command, '@("[^"]+"|\S+)')) {
            $copyPath = Save-AnalysisResponse $match.Groups[1].Value $entry.directory
            $entry.command = $entry.command.Replace($match.Value, ('@"' + $copyPath + '"'))
        }
        $entry.command = $entry.command.TrimEnd() + ' ' + $analysisFlag
    } elseif ($entry.PSObject.Properties['arguments']) {
        $entry.arguments = @($entry.arguments | ForEach-Object {
            if ($_.StartsWith('@')) {
                '@' + (Save-AnalysisResponse $_.Substring(1) $entry.directory)
            } else { $_ }
        })
        $entry.arguments = @($entry.arguments) + @($analysisFlag)
    } else {
        throw 'Compilation database entry has neither command nor arguments.'
    }
}
$json = ConvertTo-Json -InputObject $entries -Depth 10
$pendingDatabase = Join-Path $databaseDirectory 'compile_commands.pending.json'
[IO.File]::WriteAllText($pendingDatabase, $json, (New-Object Text.UTF8Encoding($false)))
if (Test-Path -LiteralPath $databaseFile) {
    [IO.File]::Replace($pendingDatabase, $databaseFile, [System.Management.Automation.Language.NullString]::Value)
} else {
    [IO.File]::Move($pendingDatabase, $databaseFile)
}
$state = [ordered]@{
    Fingerprint = $fingerprint
    DatabaseHash = (Get-FileHash -LiteralPath $databaseFile -Algorithm SHA256).Hash
    ResponseFiles = @($responseSnapshots.Values | Sort-Object | ForEach-Object {
        [ordered]@{ Path = $_; Hash = (Get-FileHash -LiteralPath $_ -Algorithm SHA256).Hash }
    })
}
[IO.File]::WriteAllText($stateFile, ($state | ConvertTo-Json), (New-Object Text.UTF8Encoding($false)))
Write-Output "clangd database ready: $($entries.Count) source files, MSVC compatibility $compatibilityVersion."
