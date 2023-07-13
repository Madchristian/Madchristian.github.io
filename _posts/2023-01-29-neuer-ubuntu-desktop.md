---
layout: post
title: Ubuntu VM mit GPU Passthrough
date: 2023-01-29 09:00:00
categories: [Homelab, VMs]
tags: [servers, vm, gpu, ubuntu]     # TAG names should always be lowercase
---

# Linux Ubuntu 22.04 LTS VM mit GPU NVIDIA Georce 1050Ti Unterstützung 
---
Eine virtuelle Maschine mit GPU-Beschleunigung auf einem Server bietet folgende Vorteile:

- Erhöhte Leistung: GPU-Beschleunigung kann eine signifikante Leistungssteigerung für bestimmte Anwendungen bieten, insbesondere bei grafikintensiven Aufgaben wie Video- und Bildbearbeitung, künstlicher Intelligenz und maschinellem Lernen.

- Flexibilität: Durch den Einsatz von virtuellen Maschinen kann ein einziger Server mehrere verschiedene Workloads ausführen, die jeweils GPU-Beschleunigung benötigen, wodurch Ressourcen effizienter genutzt werden.

- Skalierbarkeit: Da virtuelle Maschinen leicht hinzugefügt oder entfernt werden können, kann die GPU-Beschleunigungskapazität des Servers einfach skaliert werden, um den Anforderungen zu entsprechen.

- Kosteneffizienz: Ein Server mit GPU-Beschleunigung kann kosteneffizienter sein als die Bereitstellung einzelner Workstations mit dedizierten GPUs, insbesondere für kleinere Organisationen oder Unternehmen mit begrenztem Budget.
---

# Inhaltsverzeichnis:

1. installiere Proxmox auf Server
2. Setup IOMMU
3. neue Ubuntu VM hinzufügen
4. config Ubuntu VM with PCIE Passthrough

# 1. Proxmox installieren:

Am besten der Anleitung [hier](https://www.proxmox.com/de/proxmox-ve/erste-schritte) folgen.


# 2. Setup IOMMU (I/O Memory Management Unit)

[Hier](https://pve.proxmox.com/wiki/Pci_passthrough) ist die Anleitung um das Durchreichen vom PCIE Komponenten zu ermöglichen.

Das Ergebniss sollte dann so in etwa aussehen:
```
root@pvecm2:~# lspci
00:00.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Renoir Root Complex
00:00.2 IOMMU: Advanced Micro Devices, Inc. [AMD] Renoir IOMMU
00:01.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge
00:01.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Renoir PCIe GPP Bridge
00:02.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge
00:02.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Renoir PCIe GPP Bridge
00:02.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Renoir PCIe GPP Bridge
00:08.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge
00:08.1 PCI bridge: Advanced Micro Devices, Inc. [AMD] Renoir Internal PCIe GPP Bridge to Bus
00:14.0 SMBus: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller (rev 51)
00:14.3 ISA bridge: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge (rev 51)
00:18.0 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 166a
00:18.1 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 166b
00:18.2 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 166c
00:18.3 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 166d
00:18.4 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 166e
00:18.5 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 166f
00:18.6 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1670
00:18.7 Host bridge: Advanced Micro Devices, Inc. [AMD] Device 1671
01:00.0 VGA compatible controller: NVIDIA Corporation GP107 [GeForce GTX 1050 Ti] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GP107GL High Definition Audio Controller (rev a1)
02:00.0 USB controller: Advanced Micro Devices, Inc. [AMD] Device 43ee
02:00.1 SATA controller: Advanced Micro Devices, Inc. [AMD] Device 43eb
02:00.2 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43e9
03:00.0 PCI bridge: Advanced Micro Devices, Inc. [AMD] Device 43ea
04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller (rev 04)
05:00.0 Non-Volatile memory controller: Sandisk Corp WD Black SN850 (rev 01)
06:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Zeppelin/Raven/Raven2 PCIe Dummy Function (rev c9)
06:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Device 1637
06:00.2 Encryption controller: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 10h-1fh) Platform Security Processor
06:00.3 USB controller: Advanced Micro Devices, Inc. [AMD] Renoir USB 3.1
06:00.4 USB controller: Advanced Micro Devices, Inc. [AMD] Renoir USB 3.1
06:00.6 Audio device: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 10h-1fh) HD Audio Controller
```
# 3. neue VM erstellen:

1. Öffne die Proxmox-Web-Oberfläche
2. Klick auf den Reiter "VMs"
3. Wähle "Create VM" im Dropdown-Menü oder klicke auf den grünen "Create VM"-Button
4. Wähle den gewünschten Betriebssystemtyp aus und gib die grundlegenden Einstellungen wie RAM und CPU-Kerne an (Maschinentyp Q35, UEFI)
5. Wähle ein Storage-Ziel für die neue VM aus
6. Lade ein Betriebssystem-Image hoch oder wähle ein bereits vorhandenes Image
7. Klicke auf "Create"

# 4. VM für Passthrough konfigurieren:

Achtung: Die VM ist nach dem hinzufügen der GPU nicht mehr über die Console erreichbar. Vorher sicherstellen das man mit VNC oder RDP auf die Maschine zugreifen kann. Ubuntu 22.04 hat z.B. RDP mit an Bord.

- Gehe zur Proxmox-Web-Oberfläche und öffne den virtuellen  Maschinen-Editor
- Wähle im Reiter "Hardware" den PCIE-Gerätetyp aus und klicke auf "PCI passthrough"
- Markiere das zu übertragende Gerät und klicke auf "Add"
- Setze die Häckchen bei: (X)All Funktions, (X) Primary GPU, (X) ROM   BAR, (X) PCI-Express
- Starte die virtuelle Maschine neu
- Überprüfe im Betriebssystem der virtuellen Maschine, ob das Gerät erkannt wurde


# 5. NVIDIA X-Window Treiber installieren





