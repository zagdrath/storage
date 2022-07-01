# Copyright (c) 2022 Cody L. Wellman. All rights reserved.
# This work is licensed under the terms of the MIT license.

Write-Output "Installing & Configuring Syslinux for ShredOS Disk Wiping"

# Create temporary directory to copy and rename pxeboot.n12 & abortpxe.com

New-Item "C:\RemoteInstall\Temp" -itemType Directory | Out-Null
Copy-Item "C:\RemoteInstall\Boot\x64\pxeboot.n12" -Destination "C:\RemoteInstall\Temp\pxeboot.0" | Out-Null
Copy-Item "C:\RemoteInstall\Boot\x64\abortpxe.com" -Destination "C:\RemoteInstall\Temp\abortpxe.0" | Out-Null

# Copy renamed files back to their original directories

Copy-Item "C:\RemoteInstall\Temp\pxeboot.0" -Destination "C:\RemoteInstall\Boot\x64" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\abortpxe.0" -Destination "C:\RemoteInstall\Boot\x64" | Out-Null

Copy-Item "C:\RemoteInstall\Temp\pxeboot.0" -Destination "C:\RemoteInstall\Boot\x86" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\abortpxe.0" -Destination "C:\RemoteInstall\Boot\x86" | Out-Null

# Download Syslinux 4.07 and unzip

Start-BitsTransfer -Source "https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.07.zip" -Destination "C:\RemoteInstall\Temp" | Out-Null
Expand-Archive -LiteralPath "C:\RemoteInstall\Temp\syslinux-4.07.zip" -DestinationPath "C:\RemoteInstall\Temp\syslinux-4.07" | Out-Null

# Copy files from Syslinux

Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\core\pxelinux.0" -Destination "C:\RemoteInstall\Boot\x64\pxelinux.com" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\com32\menu\vesamenu.c32" -Destination "C:\RemoteInstall\Boot\x64" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\com32\chain\chain.c32" -Destination "C:\RemoteInstall\Boot\x64" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\memdisk\memdisk" -Destination "C:\RemoteInstall\Boot\x64" | Out-Null

Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\core\pxelinux.0" -Destination "C:\RemoteInstall\Boot\x86\pxelinux.com" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\com32\menu\vesamenu.c32" -Destination "C:\RemoteInstall\Boot\x86" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\com32\chain\chain.c32" -Destination "C:\RemoteInstall\Boot\x86" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-4.07\memdisk\memdisk" -Destination "C:\RemoteInstall\Boot\x86" | Out-Null

# Create Linux and pxelinux.cfg directories

New-Item "C:\RemoteInstall\Boot\x64\Linux" -itemType Directory | Out-Null
New-Item "C:\RemoteInstall\Boot\x64\pxelinux.cfg" -itemType Directory | Out-Null

New-Item "C:\RemoteInstall\Boot\x86\Linux" -itemType Directory | Out-Null
New-Item "C:\RemoteInstall\Boot\x86\pxelinux.cfg" -itemType Directory | Out-Null

# Sets WDS to boot from Syslinux

wdsutil /set-server /bootprogram:boot\x64\pxelinux.com /architecture:x64 | Out-Null
wdsutil /set-server /bootprogram:boot\x86\pxelinux.com /architecture:x86 | Out-Null
wdsutil /set-server /N12bootprogram:boot\x64\pxelinux.com /architecture:x64 | Out-Null
wdsutil /set-server /N12bootprogram:boot\x86\pxelinux.com /architecture:x86 | Out-Null

# Download Syslinux configuration files and unzip

Start-BitsTransfer -Source "https://raw.githubusercontent.com/zagdrath/storage/master/syslinux-config.zip" -Destination "C:\RemoteInstall\Temp" | Out-Null
Expand-Archive -LiteralPath "C:\RemoteInstall\Temp\syslinux-config.zip" -DestinationPath "C:\RemoteInstall\Temp\syslinux-config" | Out-Null

# Copy Syslinux configuration files to their directories

Copy-Item "C:\RemoteInstall\Temp\syslinux-config\x64\pxelinux.cfg\default" -Destination "C:\RemoteInstall\Boot\x64\pxelinux.cfg\default" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-config\x86\pxelinux.cfg\default" -Destination "C:\RemoteInstall\Boot\x86\pxelinux.cfg\default" | Out-Null

# Copy ShredOS images to their directories

Copy-Item "C:\RemoteInstall\Temp\syslinux-config\x64\shredos-2021.08.2_21_x86-64_0.32.023_20220126.iso" -Destination "C:\RemoteInstall\Boot\x64" | Out-Null
Copy-Item "C:\RemoteInstall\Temp\syslinux-config\x86\shredos-2021.08.2_21_i586_0.32.023_20220126.iso" -Destination "C:\RemoteInstall\Boot\x86" | Out-Null

Write-Output "Installation & Configuration of Syslinux Complete"
Write-Output "`n"
Read-Host -Prompt "Press Enter to Exit"