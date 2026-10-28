// Fill out your copyright notice in the Description page of Project Settings.

#include "ProvingGroundCharacter.h"
#include "Engine/Engine.h"
#include "Engine/LocalPlayer.h"

// Sets default values
AProvingGroundCharacter::AProvingGroundCharacter() {
    // Set this character to call Tick() every frame.  You can turn this off to improve performance if you don't need it.
    PrimaryActorTick.bCanEverTick = true;
}

// Called when the game starts or when spawned
void AProvingGroundCharacter::BeginPlay() {
    Super::BeginPlay();
    if (APlayerController *PlayerController =
            Cast<APlayerController>(Controller)) {
        if (UEnhancedInputLocalPlayerSubsystem *Subsystem =
                ULocalPlayer::GetSubsystem<UEnhancedInputLocalPlayerSubsystem>(PlayerController->GetLocalPlayer())) {
            Subsystem->AddMappingContext(FirstPersonContext, 0);
        }
    }

    GEngine->AddOnScreenDebugMessage(-1, 5, FColor::White, TEXT("Using ProvingGroundCharacter"));
}

// Called every frame
void AProvingGroundCharacter::Tick(float DeltaTime) {
    Super::Tick(DeltaTime);
}

// Called to bind functionality to input
void AProvingGroundCharacter::SetupPlayerInputComponent(UInputComponent *PlayerInputComponent) {
    if (UEnhancedInputComponent *EnhancedInputComponent =
            CastChecked<UEnhancedInputComponent>(PlayerInputComponent)) {
        EnhancedInputComponent->BindAction(MoveAction, ETriggerEvent::Triggered,
                                           this, &AProvingGroundCharacter::Move);
        EnhancedInputComponent->BindAction(JumpAction, ETriggerEvent::Started,
                                           this, &ACharacter::Jump);
        EnhancedInputComponent->BindAction(JumpAction, ETriggerEvent::Completed, this, &ACharacter::StopJumping);
    }
}

void AProvingGroundCharacter::Move(const FInputActionValue &Value) {
    const FVector2D MovementValue = Value.Get<FVector2D>();
    if (Controller) {
        const FVector Right = GetActorRightVector();
        AddMovementInput(Right, MovementValue.X);
        const FVector Forward = GetActorForwardVector();
        AddMovementInput(Forward, MovementValue.Y);
    }
}
