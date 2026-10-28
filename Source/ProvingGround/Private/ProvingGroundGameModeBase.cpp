// Fill out your copyright notice in the Description page of Project Settings.

#include "ProvingGroundGameModeBase.h"
#include "Engine/Engine.h"

void AProvingGroundGameModeBase::StartPlay() {
    Super::StartPlay();
    check(GEngine != nullptr);
    GEngine->AddOnScreenDebugMessage(-1, 5, FColor::Yellow, TEXT("..."));
}