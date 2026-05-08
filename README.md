<div align="center">

# 🔧 K3D ROBLOX STUDIO DOCTOR PLUGIN

### Roblox Studio plugin + local web/API debug helper

![Roblox Studio](https://img.shields.io/badge/Roblox-Studio-FF0000?style=for-the-badge&logo=roblox&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-Plugin-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-API-22C55E?style=for-the-badge&logo=node.js&logoColor=white)
![Version](https://img.shields.io/badge/Version-0.1.0-35B8FF?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-orange?style=for-the-badge)

<br/>

> Paste log. Analyze. Generate safe patch. Apply with control.

</div>

---

## 🎯 Mi ez?

A **K3D Roblox Studio Doctor Plugin** egy Roblox Studio plugin + local API/web alap, ami segít hibák javításában.

A cél:

- Roblox Studio Output log bemásolása,
- hiba felismerése,
- report generálása,
- safe fixek létrehozása,
- hiányzó mappák / RemoteEventek létrehozása,
- patch script generálása,
- local web/API kapcsolat.

---

## ⚠️ Fontos

Ez a projekt **nem töröl automatikusan fontos scripteket**.

Direkt safe módon készült:

- nem töröl DataStore scriptet,
- nem töröl ModuleScriptet,
- nem ír át random meglévő scriptet,
- safe fixeket alkalmaz,
- patch scriptet generál review-ra.

Egy AI-szerű rendszernek mindig kell jóváhagyás, mert egy rossz automata javítás tönkreteheti a játékot.

---

## 📁 Projekt struktúra

```txt
K3D-Roblox-Studio-Doctor-Plugin/
├── plugin/
│   └── K3D_Studio_Doctor.plugin.lua
│
├── server/
│   ├── server.js
│   └── package.json
│
├── web/
│   └── index.html
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## 🔌 Plugin telepítés Roblox Studio-ba

### 1. Plugin fájl

Másold ezt a fájlt:

```txt
plugin/K3D_Studio_Doctor.plugin.lua
```

Roblox Studio plugin mappába.

Windows alatt általában:

```txt
%LOCALAPPDATA%\Roblox\Plugins
```

Vagy Studio-ban:

```txt
Plugins > Plugins Folder
```

Majd indítsd újra a Roblox Studio-t.

---

## 🌐 Local API indítása

A local API opcionális. A plugin nélküle is tud local analyze-t.

### 1. Menj a server mappába

```bash
cd server
```

### 2. Telepítsd a csomagokat

```bash
npm install
```

### 3. Indítsd el

```bash
npm start
```

API:

```txt
http://localhost:3000/analyze
```

---

## 🧪 Web teszt felület

Nyisd meg:

```txt
web/index.html
```

Ez a local API-t hívja.

---

## 🛠️ Mit tud javítani?

Jelenlegi safe fixek:

| Hiba | Safe fix |
|:---|:---|
| Infinite yield / WaitForChild | ReplicatedStorage/Events és Modules létrehozás |
| RemoteEvent hiba | UpdateCurrency és NotifyPlayer RemoteEvent létrehozás |
| Leaderstats / Coins hiba | Leaderstats.server.lua létrehozás |
| Patch szükséges | K3D_Patches mappa + patch script |

---

## 🚧 Mit NEM csinál automatikusan?

Nem csinál automatikus destructive műveleteket:

- nem töröl scriptet,
- nem ír át meglévő fő scriptet,
- nem töröl RemoteEventet,
- nem töröl ModuleScriptet,
- nem módosít DataStore rendszert.

---

## 🧠 AI-szerű működés

A projekt jelenleg rule-based.  
Később ráköthető saját AI backend úgy, hogy az API ilyen JSON-t ad vissza:

```json
{
  "report": "Mit talált az AI",
  "actions": [
    {
      "type": "create_folder",
      "service": "ReplicatedStorage",
      "name": "Events"
    },
    {
      "type": "create_remote",
      "name": "UpdateCurrency"
    }
  ]
}
```

A plugin csak engedélyezett action típusokat hajt végre.

---

## ✅ Engedélyezett action típusok

Jelenleg:

```txt
create_folder
create_remote
create_leaderstats
```

Ez azért van, hogy ne tudjon egy hibás backend veszélyes dolgokat csinálni a játékban.

---

## 🧩 Roadmap

- script diff preview
- selected script javítás
- patch history
- undo rendszer
- plugin settings save
- több RemoteEvent felismerés log alapján
- Lua parser alap
- AI backend support OpenAI / local model felé
- Roblox place health scanner

---

## 👤 Készítő

**Kris3DLab / K3D Labs**

---

## 📄 License

MIT License
