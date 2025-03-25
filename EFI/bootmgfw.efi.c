#include <efi.h>
#include <efilib.h>

EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
    // Initialize EFI library
    EFI_STATUS status = uefi_call_wrapper(BS->SetWatchdogTimer, 4, 0, 0, 0, NULL);
    if (EFI_ERROR(status)) {
        return status;
    }

    // Clear screen
    uefi_call_wrapper(ST->ConOut->ClearScreen, 1, ST->ConOut);

    // Print message
    Print(L"\n\n");
    Print(L"========================================\n");
    Print(L"           SYSTEM COMPROMISED!\n");
    Print(L"========================================\n");
    Print(L"\n");
    Print(L"Your system has been pwned by uEFIrus.\n");
    Print(L"\n");
    Print(L"Press any key to continue...\n");
    Print(L"\n");

    // Wait for a keypress
    UINTN index;
    EFI_INPUT_KEY key;
    uefi_call_wrapper(ST->ConIn->Reset, 2, ST->ConIn, FALSE);
    uefi_call_wrapper(BS->WaitForEvent, 3, 1, &ST->ConIn->WaitForKey, &index);
    uefi_call_wrapper(ST->ConIn->ReadKeyStroke, 2, ST->ConIn, &key);

    // Return control to firmware
    return EFI_SUCCESS;
} 