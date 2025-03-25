#!/usr/bin/env python3
import ctypes
import sys
import subprocess
import os

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def run_as_admin():
    if not is_admin():
        # Re-run the program with admin rights
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
        sys.exit()

def mount_efi():
    try:
        # Mount the EFI partition to Z: drive
        result = subprocess.run(["mountvol", "Z:", "/s"], capture_output=True, text=True)
        
        if result.returncode == 0:
            print("Successfully mounted EFI partition to Z: drive")
        else:
            print(f"Failed to mount EFI partition. Error: {result.stderr}")
            
    except Exception as e:
        print(f"An error occurred: {str(e)}")

def main():
    # Check and request admin privileges
    run_as_admin()
    
    print("EFI Partition Mounter")
    print("====================")
    
    # Check if Z: drive is already mounted
    if os.path.exists("Z:\\"):
        print("Z: drive is already mounted. Do you want to unmount it first? (y/n)")
        response = input().lower()
        
        if response == 'y':
            subprocess.run(["mountvol", "Z:", "/d"])
            print("Z: drive unmounted successfully")
    
    # Mount the EFI partition
    mount_efi()
    
    input("\nPress Enter to exit...")

if __name__ == "__main__":
    main() 