const express = require("express");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: "2mb" }));

const rules = [
  {
    id: "infinite-yield",
    test: /infinite yield|waitforchild/i,
    report: `## Infinite yield / WaitForChild

A scripted vár egy objektumra, ami lehet hogy nem létezik, rossz helyen van, vagy rosszul van elnevezve.

Javaslat:
- Ellenőrizd a pathot.
- Hozd létre ReplicatedStorage/Events mappát.
- Remote neve egyezzen pontosan.
`,
    actions: [
      { type: "create_folder", service: "ReplicatedStorage", name: "Events" },
      { type: "create_folder", service: "ReplicatedStorage", name: "Modules" }
    ]
  },
  {
    id: "remote",
    test: /remoteevent|remotefunction|fireserver|onserverevent/i,
    report: `## Remote problem

Valószínűleg hiányzik egy RemoteEvent / RemoteFunction, vagy rossz a neve.

Javaslat:
- RemoteEvent: FireServer + OnServerEvent
- RemoteFunction: InvokeServer + OnServerInvoke
`,
    actions: [
      { type: "create_remote", name: "UpdateCurrency" },
      { type: "create_remote", name: "NotifyPlayer" }
    ]
  },
  {
    id: "leaderstats",
    test: /leaderstats|coins|cash|gems/i,
    report: `## Leaderstats / currency problem

Lehet, hogy hiányzik a leaderstats vagy a currency IntValue.

Javaslat:
- Hozz létre Leaderstats.server.lua-t.
- A currency neve egyezzen a scriptekben.
`,
    actions: [
      { type: "create_leaderstats" }
    ]
  },
  {
    id: "localplayer",
    test: /localplayer/i,
    report: `## LocalPlayer problem

A Players.LocalPlayer csak LocalScriptben létezik.

Ezt a backend nem javítja automatikusan, mert át kell nézni a script helyét.
`,
    actions: []
  }
];

function analyze(log) {
  const matches = rules.filter(rule => rule.test.test(log || ""));

  let report = `# K3D Studio Doctor API Report\n\n`;
  report += `Detected issues: ${matches.length}\n\n`;

  const actions = [];

  for (const match of matches) {
    report += match.report + "\n";
    actions.push(...match.actions);
  }

  if (matches.length === 0) {
    report += `No known issue detected.

General checklist:
- Nézd meg az első piros hibát.
- Keresd meg a script nevét és sor számát.
- Ellenőrizd a ReplicatedStorage / ServerScriptService / StarterGui pathokat.
`;
  }

  report += `\n## Mit NE törölj?\n`;
  report += `- DataStore / ProfileStore\n`;
  report += `- Main.server.lua\n`;
  report += `- ModuleScript, amit require-elnek\n`;
  report += `- RemoteEvent, amit több script használ\n`;

  return { report, actions };
}

app.get("/", (req, res) => {
  res.json({
    name: "K3D Roblox Studio Doctor API",
    version: "0.1.0",
    status: "online"
  });
});

app.post("/analyze", (req, res) => {
  const { log } = req.body || {};
  res.json(analyze(log || ""));
});

app.listen(PORT, () => {
  console.log(`K3D Studio Doctor API running on http://localhost:${PORT}`);
});
