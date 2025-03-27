#include <efi.h>
#include <efilib.h>

EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
    EFI_STATUS status;
    
    // Initialize EFI library
    status = uefi_call_wrapper(BS->SetWatchdogTimer, 4, 0, 0, 0, NULL);
    if (EFI_ERROR(status)) {
        return status;
    }

    // Clear screen
    status = uefi_call_wrapper(ST->ConOut->ClearScreen, 1, ST->ConOut);
    if (EFI_ERROR(status)) {
        return status;
    }

    // Print message
    Print(L"\n\n");
    Print(L"========================================\n");
    Print(L"           SYSTEM COMPROMISED!\n");
    Print(L"========================================\n");
    Print(L"\n");
    Print(L"Your system has been pwned by uEFIrus.\n");
    Print(L"This is a proof-of-concept for educational purposes.\n");
    Print(L"\n");
    Print(L"Press any key to continue...\n");
    Print(L"\n");

    // Wait for a keypress
    UINTN index;
    EFI_INPUT_KEY key;
    
    // Reset keyboard state
    status = uefi_call_wrapper(ST->ConIn->Reset, 2, ST->ConIn, FALSE);
    if (EFI_ERROR(status)) {
        return status;
    }
    
    // Wait for key event
    status = uefi_call_wrapper(BS->WaitForEvent, 3, 1, &ST->ConIn->WaitForKey, &index);
    if (EFI_ERROR(status)) {
        return status;
    }
    
    // Read the key
    status = uefi_call_wrapper(ST->ConIn->ReadKeyStroke, 2, ST->ConIn, &key);
    if (EFI_ERROR(status)) {
        return status;
    }

    // Instead of returning to firmware, we'll exit the application
    uefi_call_wrapper(BS->Exit, 4, ImageHandle, EFI_SUCCESS, 0, NULL);
    
    // This line should never be reached
    return EFI_SUCCESS;
} 