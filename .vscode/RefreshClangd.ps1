# Refresh code-analysis data only; actual UE builds continue to use MSVC.
[CmdletBinding()]
param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$EngineRoot = 'E:\UE\UE_5.8'
)

$ErrorActionPreference = 'Stop'
$databaseDirectory = Join-Path $PSScriptRoot 'clangd'
$projectFile = Join-Path $ProjectRoot 'ProvingGround.uproject'
$cppProperties = Get-Content -LiteralPath (Join-Path $PSScriptRoot 'c_cpp_properties.json') -Raw | ConvertFrom-Json
$compilerPath = $cppProperties.configurations[0].compilerPath
$compilerVersion = (Get-Item -LiteralPath $compilerPath).VersionInfo
$compatibilityVersion = '{0}.{1}' -f $compilerVersion.FileMajorPart, $compilerVersion.FileMinorPart
$dotnet = Join-Path $EngineRoot 'Engine\Binaries\ThirdParty\DotNet\10.0\win-x64\dotnet.exe'
$ubt = Join-Path $EngineRoot 'Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.dll'
$compilerFamily = if ($compilerVersion.FileMinorPart -ge 50) { 'VisualStudio2026' } else { 'VisualStudio2022' }

New-Item -ItemType Directory -Path $databaseDirectory -Force | Out-Null
& $dotnet $ubt '-Mode=GenerateClangDatabase' 'ProvingGroundEditor' 'Win64' 'Development' `
    "-Project=$projectFile" "-Compiler=$compilerFamily" "-OutputDir=$databaseDirectory" `
    "-Include=$ProjectRoot\Source\..." "-Include=$ProjectRoot\Plugins\..." '-NoExecCodeGenActions'
if ($LASTEXITCODE -ne 0) {
    throw "UBT compilation database generation failed ($LASTEXITCODE)."
}

$databaseFile = Join-Path $databaseDirectory 'compile_commands.json'
[object[]]$entries = Get-Content -LiteralPath $databaseFile -Raw | ConvertFrom-Json
if ($entries.Count -eq 0) {
    throw 'UBT produced an empty compilation database.'
}

# clangd otherwise defaults to emulating MSVC 19.33, below UE 5.8's minimum.
# Amend only the JSON analysis commands, never UBT's real compiler response files.
$analysisFlag = '/clang:-fms-compatibility-version=' + $compatibilityVersion
foreach ($entry in $entries) {
    if ($entry.PSObject.Properties['command']) {
        $entry.command = $entry.command.TrimEnd() + ' ' + $analysisFlag
    } elseif ($entry.PSObject.Properties['arguments']) {
        $entry.arguments = @($entry.arguments) + @($analysisFlag)
    } else {
        throw 'Compilation database entry has neither command nor arguments.'
    }
}
$json = ConvertTo-Json -InputObject $entries -Depth 10
[IO.File]::WriteAllText($databaseFile, $json, (New-Object Text.UTF8Encoding($false)))
Write-Output "clangd database ready: $($entries.Count) source files, MSVC compatibility $compatibilityVersion."
