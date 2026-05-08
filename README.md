<div align="center">

# 🛡️ K3D PROCESS GUARDIAN

### Safe Windows process monitor & manager

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Version](https://img.shields.io/badge/Version-1.0.0-22C55E?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)
![Safe Mode](https://img.shields.io/badge/Safe%20Mode-Enabled-brightgreen?style=for-the-badge&logo=shield&logoColor=white)

<br/>

> 🛡️ **List. Search. Kill. Monitor. Export.** — Process control, de biztonságosabban.

</div>

---

## 🎯 Mi ez?

A **K3D PROCESS GUARDIAN** egy PowerShell-alapú Windows folyamatkezelő eszköz, ami segít átlátni és kezelni a futó programokat.

Nem vírus, nem prank, nem agresszív cleaner.  
Egy egyszerű, nyílt forráskódú utility tool, ami kezdőknek is érthető módon kezeli a process listát.

Hasznos lehet, ha:

- egy program beragad,
- egy app többször elindul,
- sok RAM-ot eszik valami,
- logolni akarod a process műveleteket,
- gyorsan szeretnél process reportot exportálni.

---

## ✨ Funkciók

### 📋 PROCESS LIST

Listázza a legtöbb memóriát használó folyamatokat.

| Funkció | Leírás |
|:---|:---|
| Top process lista | Memóriahasználat szerint rendezve |
| PID megjelenítés | Könnyebb azonosítás |
| CPU / RAM info | Gyors áttekintés |
| Path mező | Ha elérhető, mutatja az exe útvonalát |

---

### 🔍 PROCESS SEARCH

Név alapján kereshetsz futó folyamatokat.

Példa:

```txt
chrome
discord
roblox
notepad
```

---

### 💀 SAFE KILL

Process leállítása PID vagy név alapján.

| Mód | Leírás |
|:---|:---|
| Kill by PID | Pontos process ID alapján |
| Kill by Name | Minden azonos nevű process leállítása |
| Safe blocklist | Rendszerfolyamatokat nem enged kilőni |

---

### 🛡️ GUARDIAN MONITOR

Figyeli a megadott process nevet, és ha elindul, automatikusan leállítja.

Példa:

```txt
notepad
someapp
exampleprocess
```

> A monitor módot `CTRL + C`-vel lehet leállítani.

---

### 📦 EXPORT REPORT

CSV fájlba menti a futó process listát.

Kimenet:

```txt
process-report.csv
```

---

### 📜 LOG SYSTEM

Minden művelet naplózva van.

Kimenet:

```txt
guardian-log.txt
```

Log szintek:

| Szint | Jelentés |
|:---|:---|
| `[SYS]` | Program indítás / leállítás |
| `[INFO]` | Általános információ |
| `[OK]` | Sikeres művelet |
| `[WARN]` | Figyelmeztetés |
| `[BLOCK]` | Safe mode által blokkolt művelet |
| `[KILL]` | Process leállítás |

---

## 🚀 Telepítés

### 1. Letöltés

Töltsd le a repót ZIP-ként, vagy klónozd:

```bash
git clone https://github.com/yourname/K3D-Process-Guardian.git
cd K3D-Process-Guardian
```

---

### 2. Futtatás

PowerShellből:

```powershell
powershell -ExecutionPolicy Bypass -File ".\K3D_Process_Guardian.ps1"
```

A script automatikusan kér rendszergazdai jogot, ha szükséges.

---

## ⚡ Gyors Start

```txt
1. Indítsd el a scriptet.
2. Válaszd az 1-es opciót a process lista megtekintéséhez.
3. Keresd meg a célprogramot.
4. Kill by PID vagy Kill by Name.
5. Ha kell, exportálj reportot CSV-be.
```

---

## 🛡️ Protected Process List

A tool alapból blokkolja a fontos Windows folyamatokat, például:

```txt
system
csrss
wininit
winlogon
services
lsass
svchost
explorer
dwm
registry
```

Ez azért van, hogy véletlenül se lőj ki kritikus rendszerfolyamatokat.

---

## 📁 Fájlstruktúra

```txt
K3D-Process-Guardian/
├── K3D_Process_Guardian.ps1
├── README.md
├── LICENSE
└── .gitignore
```

A script futás közben létrehozhatja:

```txt
guardian-log.txt
process-report.csv
```

---

## 🧪 Tesztelt környezet

| Rendszer | Állapot |
|:---|:---|
| Windows 10 | Támogatott |
| Windows 11 | Támogatott |
| PowerShell 5.1+ | Támogatott |
| PowerShell 7 | Részben támogatott |

---

## 📦 Verziótörténet

| Verzió | Változások |
|:---|:---|
| `v1.0.0` | Első kiadás: process lista, keresés, safe kill, monitor mód, log, CSV export |

---

## ⚠️ Figyelmeztetés

> Ez az eszköz **saját gépen futó saját folyamatok kezelésére** készült.  
> Ne használd más gépén engedély nélkül.  
> Ne használj process kill toolokat adatvesztést okozó programokon mentés nélkül.

---

## 👤 Fejlesztő

<div align="center">

### **Kris3DLab / K3D Labs**

*"Control your processes. Don't break your Windows."*

</div>

---

## 📄 Licenc

Nyílt forráskódú, MIT licenc alatt.

<div align="center">

---

⭐ **Ha hasznos volt, dobj egy stárt a repóra!** ⭐

🛡️ *K3D PROCESS GUARDIAN — safe control for Windows processes.*

</div>
