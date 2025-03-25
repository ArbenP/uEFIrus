# uEFIrus - EFI Bootloader Manipulation PoC

# Work in progress - Doesn't work yet / Not Ready yet!!


## **⚠️ Disclaimer**
**This tool is for educational and research purposes only.** It is designed as a **proof-of-concept** for red team assessments and security awareness. **Do not use this on unauthorized systems.**

Modifying EFI bootloaders can render a system **unbootable** and cause data loss. **Use this tool only in controlled environments, such as virtual machines or test systems, where you have explicit permission.**

I am **not responsible** for any misuse of this tool. Engaging in unauthorized system modification may violate laws and terms of service.

---

## **Overview**
This project demonstrates how an attacker with administrator privileges can modify the **EFI System Partition (ESP)** on Windows systems with **Secure Boot disabled**. The proof-of-concept:

- **Mounts the EFI partition**
- **Backs up the original Windows bootloader** (`bootmgfw.efi`)
- **Replaces it with a custom EFI binary** that displays a message ("System Compromised")
- **Crashes the PC** 
- **Upon reboot, the PC boots into our custom EFI application instead of Windows**

This PoC aims to highlight security weaknesses in improperly configured boot environments and emphasize the importance of **Secure Boot and EFI integrity monitoring**.

---

## **Usage**
### **Requirements**
- Windows system (8+) with Secure Boot **disabled**
- Administrator privileges
- PowerShell or Command Prompt with elevated rights
- For building the custom EFI binary:
  - Linux system with GCC and GNU-EFI development tools
  - `gcc`, `make`, `objcopy`, `gnu-efi` development packages

### **Building the Custom EFI Binary**
1. Install required packages on Linux:
   ```bash
   # Debian/Ubuntu
   sudo apt-get install gcc make binutils gnu-efi
   
   # Fedora
   sudo dnf install gcc make binutils gnu-efi-devel
   ```

2. Compile the custom EFI binary:
   ```bash
   cd EFI
   make
   ```
   This will create `bootmgfw.efi` in the EFI directory.

### **Execution (Test Environment Only!)**
1. Copy the entire project directory to the target Windows system
2. Open PowerShell as Administrator
3. Navigate to the project directory
4. Run the script:
   ```powershell
   .\uEFIrus.ps1
   ```

5. The script will:
   - Check if Secure Boot is disabled
   - Mount the EFI partition
   - Backup the original bootloader
   - Replace it with our custom EFI binary
   - Unmount the partition
   - Crash the system

After the BSOD, the system will boot into our custom EFI application that displays the hacked message

### **Recovery**
To restore the original bootloader:
1. Boot from a Windows installation media
2. Open Command Prompt
3. Mount the EFI partition
4. Copy the backup file (`bootmgfw.efi.backup`) back to `bootmgfw.efi`

---

## **Defensive Measures**
To protect against this type of attack:
- **Enable Secure Boot**: Prevents unsigned EFI modifications.
- **Use BitLocker**: Encrypts the bootloader to prevent tampering.
- **Monitor EFI Partition**: Use security tools to detect unauthorized modifications.
- **Restrict Admin Access**: Ensure only trusted users have elevated privileges.

---

## **Legal & Ethical Use**
By using this tool, you agree that:
- It is for **security research and educational purposes only**.
- You will **not use it on systems you do not own or have permission to test**.
- You acknowledge the **risks of modifying EFI firmware** and take full responsibility for any consequences.


---

## **Contributing**
Contributions are welcome! If you'd like to improve this tool or suggest security mitigations, feel free to submit a pull request.

---

## **License**
This project is released under the **Apache License**. See `LICENSE` for details.

**⚠️ WARNING: Use this tool responsibly. Unauthorized use may be illegal.**

