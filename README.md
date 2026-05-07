# K3D Roblox Dev Toolkit

**K3D Roblox Dev Toolkit** egy kezdőbarát Roblox fejlesztői csomag, ami segít gyorsabban összerakni egy alap Roblox játék rendszerét.

A célja, hogy ne kelljen mindent nulláról újraírni: kapsz kész mintákat RemoteEventekhez, értesítésekhez, shophoz, daily rewardhoz, leaderstatshoz és alap UI animációkhoz.

---

## Mire jó?

Ez a toolkit azoknak készült, akik Roblox Studio-ban fejlesztenek, de szeretnének gyorsabban haladni.

Használhatod például:

* simulator játékokhoz
* obby játékokhoz
* tycoon játékokhoz
* magyar Roblox projektekhez
* teszt rendszerekhez
* kezdő Roblox scripterek tanulásához

---

## Funkciók

* Leaderstats rendszer
* Coins / Gems alap currency példa
* RemoteEvent mappa automatikus létrehozása
* Notification rendszer
* Daily Reward példa
* Shop rendszer példa
* UI tween animációk
* Admin command alap
* Safe server-client kommunikáció
* Egyszerűen bővíthető mappastruktúra

---

## Mappastruktúra

A repó ajánlott felépítése:

```txt
K3D-Roblox-Dev-Toolkit/
│
├── README.md
├── LICENSE
│
├── ServerScriptService/
│   ├── Main.server.lua
│   ├── Leaderstats.server.lua
│   ├── DailyReward.server.lua
│   └── AdminCommands.server.lua
│
├── ReplicatedStorage/
│   ├── Modules/
│   │   ├── Config.lua
│   │   └── NotificationConfig.lua
│   │
│   └── Events/
│       ├── NotifyPlayer
│       ├── ClaimDailyReward
│       └── PurchaseItem
│
├── StarterGui/
│   └── K3D_UI/
│       ├── MainGui
│       └── UIClient.client.lua
│
└── StarterPlayer/
    └── StarterPlayerScripts/
        └── ClientInit.client.lua
```

---

## Telepítés Roblox Studio-ban

### 1. Nyisd meg a Roblox Studio-t

Nyisd meg a játékodat Roblox Studio-ban.

---

### 2. Hozd létre a mappákat

Hozd létre ezeket:

```txt
ReplicatedStorage
└── Events
└── Modules

ServerScriptService
StarterGui
StarterPlayer
└── StarterPlayerScripts
```

---

### 3. Másold be a scripteket

A fájlokat mindig a nevük alapján rakd be a megfelelő helyre.

Példa:

```txt
Leaderstats.server.lua
```

helye:

```txt
ServerScriptService/Leaderstats.server.lua
```

---

### 4. Indítsd el a játékot Play módban

Roblox Studio-ban nyomd meg:

```txt
Play
```

Ha jól raktad be, a játékosnál megjelenik a leaderstats, például:

```txt
Coins: 0
Gems: 0
```

---

## Alap leaderstats példa

```lua
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats

    local gems = Instance.new("IntValue")
    gems.Name = "Gems"
    gems.Value = 0
    gems.Parent = leaderstats
end)
```

Helye:

```txt
ServerScriptService/Leaderstats.server.lua
```

---

## RemoteEvent rendszer

A toolkit RemoteEventeket használ a kliens és szerver közötti kommunikációhoz.

Példa Eventek:

```txt
ReplicatedStorage/Events/NotifyPlayer
ReplicatedStorage/Events/ClaimDailyReward
ReplicatedStorage/Events/PurchaseItem
```

Fontos: amit pénzhez, itemhez vagy rewardhoz használsz, azt mindig szerveren ellenőrizd.

---

## Notification rendszer

A Notification rendszer arra jó, hogy a játékosnak kis üzenetet jeleníts meg.

Példák:

```txt
+100 Coins
Sikeres vásárlás!
Nincs elég pénzed!
Daily reward claimed!
```

---

## Shop rendszer példa

A shop rendszer alap logikája:

1. A játékos megnyom egy vásárlás gombot.
2. A kliens elküldi az item nevét a szervernek.
3. A szerver ellenőrzi az árat.
4. Ha van elég pénz, levonja.
5. A szerver odaadja az itemet vagy unlockolja.
6. A játékos kap egy notificationt.

---

## Daily Reward rendszer

A daily reward rendszer egy napi jutalom példa.

Alap reward:

```txt
1. nap: 100 Coins
2. nap: 150 Coins
3. nap: 250 Coins
4. nap: 1 Gem
5. nap: 500 Coins
```

A végleges verzióban DataStore mentéssel is bővíthető.

---

## Admin Commands

Alap parancs ötletek:

```txt
!coins PlayerName 100
!gems PlayerName 10
!kick PlayerName
!speed PlayerName 32
```

Csak az admin listában lévő user ID-k használhatják.

---

## Config példa

```lua
local Config = {}

Config.Admins = {
    123456789,
}

Config.StartingCoins = 0
Config.StartingGems = 0

Config.ShopItems = {
    SpeedBoost = {
        Price = 250,
        Currency = "Coins"
    },

    VIPSword = {
        Price = 1000,
        Currency = "Coins"
    }
}

return Config
```

Helye:

```txt
ReplicatedStorage/Modules/Config.lua
```

---

## Kiknek ajánlott?

Ez a toolkit főleg kezdőknek és középhaladó Roblox fejlesztőknek ajánlott.

Ha még csak most tanulsz scriptelni, akkor is használhatod, mert minden script mellé kerül magyarázat és pontos hely.

---

## Fontos Roblox szabály

Soha ne bízz meg teljesen a kliensben.

Rossz példa:

```lua
-- kliens mondja meg, hogy kapjon 999999 pénzt
```

Jó példa:

```lua
-- kliens csak kérést küld
-- szerver ellenőrzi és dönt
```

---

## Tervezett frissítések

* Inventory rendszer
* Pet system alap
* Quest system alap
* Save system DataStore-ral
* UI template pack
* Loading screen
* Teleport rendszer
* Gamepass ellenőrzés
* Developer Product példa

---

## Hogyan használd GitHubon?

1. Hozz létre egy új GitHub repót.
2. Neve legyen például:

```txt
K3D-Roblox-Dev-Toolkit
```

3. Töltsd fel a fájlokat.
4. Rakj be képernyőképeket a `screenshots` mappába.
5. A README.md automatikusan meg fog jelenni a GitHub repó főoldalán.

---

## Ajánlott repo leírás

```txt
A beginner-friendly Roblox Dev Toolkit with leaderstats, remotes, notifications, shop, daily rewards and admin command examples.
```

---

## License

Ez a projekt szabadon használható tanulásra és saját Roblox projektekhez.

Ajánlott license:

```txt
MIT License
```

---

## Készítő

Készítette: **Kris3DLab / Kris3Dev**

Roblox, Discord és YouTube projektekhez készült fejlesztői toolkit.
