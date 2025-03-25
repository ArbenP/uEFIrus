# UEFI Hello World Application

This is a simple UEFI application that displays "Hello World" on screen when executed from UEFI.

# Work in progress - Doesn't work yet / Not Ready yet!!

## Prerequisites

To build this application, you need:
1. EDK II (UEFI Development Kit)
2. A supported C compiler (like MSVC for Windows)
3. Python 3.x (for EDK II build tools)
4. ASL compiler (optional, for ACPI support)

## Building the Application

1. Set up EDK II:
   ```bash
   git clone https://github.com/tianocore/edk2.git
   cd edk2
   git submodule update --init
   make -C BaseTools
   ```

2. Copy the HelloWorld files:
   - Copy `HelloWorld.c` and `HelloWorld.inf` to `edk2/HelloWorld/`

3. Add the following to your `edk2/Conf/target.txt`:
   ```
   ACTIVE_PLATFORM       = HelloWorld/HelloWorld.inf
   TARGET               = RELEASE
   TARGET_ARCH          = X64
   TOOL_CHAIN_CONF      = Conf/tools_def.txt
   TOOL_CHAIN_TAG       = VS2019  # Or your compiler version
   ```

4. Build the application:
   ```bash
   build
   ```

The compiled UEFI application will be in `Build/HelloWorld/RELEASE_VS2019/X64/HelloWorld.efi`

## Running the Application

1. Copy the `HelloWorld.efi` file to a USB drive formatted as FAT32
2. Boot your computer into UEFI shell
3. Navigate to the USB drive (usually fs0:)
4. Run the application by typing its name: `HelloWorld.efi`

## Notes

- The application will display "Hello World from UEFI!" and wait for a key press before exiting
- Make sure your system's Secure Boot is disabled when testing UEFI applications
- Always test UEFI applications in a safe environment (like a VM) first
