--[[
    K3D Roblox Studio Doctor Plugin
    Version: 0.1.0
    Author: Kris3DLab / K3D Labs

    Safe Roblox Studio helper plugin.
    - Paste Output logs
    - Detect common Studio errors
    - Create safe missing folders/remotes
    - Generate patch scripts
    - Optional API connection for web/AI backend

    IMPORTANT:
    This plugin avoids destructive actions by default.
    It does NOT delete scripts automatically.
]]

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")

local toolbar = plugin:CreateToolbar("K3D Doctor")
local openButton = toolbar:CreateButton(
	"K3D Studio Doctor",
	"Open K3D Roblox Studio Doctor",
	"rbxassetid://4458901886"
)

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Right,
	false,
	false,
	460,
	620,
	360,
	420
)

local widget = plugin:CreateDockWidgetPluginGui("K3DStudioDoctorWidget", widgetInfo)
widget.Title = "K3D Roblox Studio Doctor"

local state = {
	apiUrl = "http://localhost:3000/analyze",
	lastReport = "",
	lastActions = {},
}

local function make(className, props, parent)
	local obj = Instance.new(className)

	for key, value in pairs(props or {}) do
		obj[key] = value
	end

	obj.Parent = parent
	return obj
end

local root = make("Frame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(10, 14, 22),
	BorderSizePixel = 0,
}, widget)

local padding = make("UIPadding", {
	PaddingTop = UDim.new(0, 14),
	PaddingBottom = UDim.new(0, 14),
	PaddingLeft = UDim.new(0, 14),
	PaddingRight = UDim.new(0, 14),
}, root)

local layout = make("UIListLayout", {
	FillDirection = Enum.FillDirection.Vertical,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
}, root)

local title = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 34),
	BackgroundTransparency = 1,
	Text = "🔧 K3D Roblox Studio Doctor",
	TextColor3 = Color3.fromRGB(235, 255, 242),
	TextSize = 20,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	LayoutOrder = 1,
}, root)

local subtitle = make("TextLabel", {
	Size = UDim2.new(1, 0, 0, 34),
	BackgroundTransparency = 1,
	Text = "Paste Output log → analyze → safe apply fixes.",
	TextColor3 = Color3.fromRGB(150, 165, 185),
	TextSize = 13,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextWrapped = true,
	LayoutOrder = 2,
}, root)

local apiBox = make("TextBox", {
	Size = UDim2.new(1, 0, 0, 34),
	BackgroundColor3 = Color3.fromRGB(18, 25, 38),
	TextColor3 = Color3.fromRGB(230, 240, 255),
	PlaceholderText = "API URL, pl. http://localhost:3000/analyze",
	Text = state.apiUrl,
	TextSize = 13,
	Font = Enum.Font.Code,
	ClearTextOnFocus = false,
	LayoutOrder = 3,
}, root)

local logBox = make("TextBox", {
	Size = UDim2.new(1, 0, 0, 160),
	BackgroundColor3 = Color3.fromRGB(18, 25, 38),
	TextColor3 = Color3.fromRGB(230, 240, 255),
	PlaceholderText = "Paste Roblox Studio Output log ide...",
	Text = "",
	TextSize = 13,
	Font = Enum.Font.Code,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	ClearTextOnFocus = false,
	MultiLine = true,
	LayoutOrder = 4,
}, root)

local buttonRow = make("Frame", {
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundTransparency = 1,
	LayoutOrder = 5,
}, root)

local rowLayout = make("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 8),
}, buttonRow)

local function makeButton(text, order)
	return make("TextButton", {
		Size = UDim2.new(0.5, -4, 1, 0),
		BackgroundColor3 = Color3.fromRGB(25, 180, 90),
		TextColor3 = Color3.fromRGB(5, 12, 8),
		Text = text,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		LayoutOrder = order,
	}, buttonRow)
end

local analyzeButton = makeButton("Analyze Local", 1)
local apiButton = makeButton("Send to API", 2)

local buttonRow2 = make("Frame", {
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundTransparency = 1,
	LayoutOrder = 6,
}, root)

local rowLayout2 = make("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 8),
}, buttonRow2)

local applyButton = make("TextButton", {
	Size = UDim2.new(0.5, -4, 1, 0),
	BackgroundColor3 = Color3.fromRGB(65, 180, 255),
	TextColor3 = Color3.fromRGB(5, 12, 18),
	Text = "Apply Safe Fixes",
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	LayoutOrder = 1,
}, buttonRow2)

local patchButton = make("TextButton", {
	Size = UDim2.new(0.5, -4, 1, 0),
	BackgroundColor3 = Color3.fromRGB(155, 92, 255),
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Text = "Create Patch Script",
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	LayoutOrder = 2,
}, buttonRow2)

local reportBox = make("TextBox", {
	Size = UDim2.new(1, 0, 1, -330),
	BackgroundColor3 = Color3.fromRGB(14, 20, 31),
	TextColor3 = Color3.fromRGB(225, 235, 245),
	Text = "Report itt fog megjelenni.",
	TextSize = 13,
	Font = Enum.Font.Code,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	ClearTextOnFocus = false,
	MultiLine = true,
	LayoutOrder = 7,
}, root)

local function getOrCreateFolder(parent, name)
	local folder = parent:FindFirstChild(name)

	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end

	return folder
end

local function getOrCreateRemoteEvent(folder, name)
	local remote = folder:FindFirstChild(name)

	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
	end

	return remote
end

local function createScript(parent, name, source)
	local existing = parent:FindFirstChild(name)

	if existing then
		return existing, false
	end

	local scriptObj = Instance.new("Script")
	scriptObj.Name = name
	scriptObj.Source = source
	scriptObj.Parent = parent

	return scriptObj, true
end

local function createLocalScript(parent, name, source)
	local existing = parent:FindFirstChild(name)

	if existing then
		return existing, false
	end

	local scriptObj = Instance.new("LocalScript")
	scriptObj.Name = name
	scriptObj.Source = source
	scriptObj.Parent = parent

	return scriptObj, true
end

local function detectLogIssues(text)
	local lower = string.lower(text or "")
	local report = {}
	local actions = {}

	table.insert(report, "# K3D Studio Doctor Plugin Report")
	table.insert(report, "")

	if lower == "" then
		table.insert(report, "Nincs log megadva.")
		return table.concat(report, "\n"), actions
	end

	if string.find(lower, "infinite yield") or string.find(lower, "waitforchild") then
		table.insert(report, "## Infinite yield / WaitForChild")
		table.insert(report, "A script vár egy objektumra, ami lehet hogy hiányzik vagy rossz helyen van.")
		table.insert(report, "Mit nézz meg:")
		table.insert(report, "- Objektum neve pontosan egyezik-e")
		table.insert(report, "- ReplicatedStorage/Events létezik-e")
		table.insert(report, "- RemoteEvent jó néven van-e")
		table.insert(report, "")
		table.insert(actions, { type = "create_folder", service = "ReplicatedStorage", name = "Events" })
		table.insert(actions, { type = "create_folder", service = "ReplicatedStorage", name = "Modules" })
	end

	if string.find(lower, "remoteevent") or string.find(lower, "fireserver") or string.find(lower, "onserverevent") then
		table.insert(report, "## RemoteEvent problem")
		table.insert(report, "Lehet, hogy hiányzik egy RemoteEvent vagy rossz a neve.")
		table.insert(report, "Safe fix: létre lehet hozni ReplicatedStorage/Events mappát és alap remoteokat.")
		table.insert(report, "")
		table.insert(actions, { type = "create_remote", name = "UpdateCurrency" })
		table.insert(actions, { type = "create_remote", name = "NotifyPlayer" })
	end

	if string.find(lower, "leaderstats") or string.find(lower, "coins") then
		table.insert(report, "## Leaderstats / currency problem")
		table.insert(report, "Lehet, hogy hiányzik a leaderstats vagy a Coins IntValue.")
		table.insert(report, "Safe fix: létrehozható egy alap Leaderstats.server.lua.")
		table.insert(report, "")
		table.insert(actions, { type = "create_leaderstats" })
	end

	if string.find(lower, "localplayer") then
		table.insert(report, "## LocalPlayer problem")
		table.insert(report, "A LocalPlayer csak LocalScriptben működik. ServerScriptben nil lesz.")
		table.insert(report, "Ezt nem javítom automatikusan, mert át kell nézni a script helyét.")
		table.insert(report, "")
	end

	if string.find(lower, "datastore") then
		table.insert(report, "## DataStore problem")
		table.insert(report, "DataStore hibánál ne törölj mentő scriptet. Nézd meg a pcall-t és a túl gyakori mentést.")
		table.insert(report, "")
	end

	if #actions == 0 then
		table.insert(report, "Nem találtam automatikusan javítható safe fixet.")
		table.insert(report, "A plugin ilyenkor inkább reportot ad, nem nyúl bele a játékba.")
	end

	table.insert(report, "## Mit NE törölj?")
	table.insert(report, "- Main.server.lua")
	table.insert(report, "- DataStore / ProfileStore modul")
	table.insert(report, "- RemoteEvent, amit több script használ")
	table.insert(report, "- ModuleScript, amit require-el más script")
	table.insert(report, "")

	return table.concat(report, "\n"), actions
end

local function getServiceByName(name)
	if name == "ReplicatedStorage" then return ReplicatedStorage end
	if name == "ServerScriptService" then return ServerScriptService end
	if name == "StarterGui" then return StarterGui end
	if name == "StarterPlayer" then return StarterPlayer end
	return nil
end

local leaderstatsSource = [[local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Coins = Instance.new("IntValue")
	Coins.Name = "Coins"
	Coins.Value = 0
	Coins.Parent = leaderstats
end)
]]

local patchSource = [[-- K3D Studio Doctor Patch Script
-- This script was generated by the plugin.
-- Review before using in live games.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local events = ReplicatedStorage:FindFirstChild("Events")
if not events then
	events = Instance.new("Folder")
	events.Name = "Events"
	events.Parent = ReplicatedStorage
end

local function ensureRemote(name)
	local remote = events:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = events
	end
	return remote
end

ensureRemote("UpdateCurrency")
ensureRemote("NotifyPlayer")

print("K3D Studio Doctor patch applied.")
]]

local function applyActions(actions)
	local applied = {}

	for _, action in ipairs(actions or {}) do
		if action.type == "create_folder" then
			local service = getServiceByName(action.service)
			if service then
				getOrCreateFolder(service, action.name)
				table.insert(applied, "Created/checked folder: " .. action.service .. "/" .. action.name)
			end
		end

		if action.type == "create_remote" then
			local events = getOrCreateFolder(ReplicatedStorage, "Events")
			getOrCreateRemoteEvent(events, action.name)
			table.insert(applied, "Created/checked RemoteEvent: ReplicatedStorage/Events/" .. action.name)
		end

		if action.type == "create_leaderstats" then
			createScript(ServerScriptService, "Leaderstats.server.lua", leaderstatsSource)
			table.insert(applied, "Created/checked ServerScriptService/Leaderstats.server.lua")
		end
	end

	if #applied == 0 then
		return "No safe actions were applied."
	end

	return "Applied safe fixes:\n- " .. table.concat(applied, "\n- ")
end

local function createPatchScript()
	local folder = getOrCreateFolder(ServerScriptService, "K3D_Patches")
	local name = "K3D_StudioDoctor_Patch.server.lua"
	local scriptObj, created = createScript(folder, name, patchSource)

	if created then
		return "Patch script created: ServerScriptService/K3D_Patches/" .. name
	end

	return "Patch script already exists: ServerScriptService/K3D_Patches/" .. name
end

analyzeButton.MouseButton1Click:Connect(function()
	local report, actions = detectLogIssues(logBox.Text)
	state.lastReport = report
	state.lastActions = actions
	reportBox.Text = report
end)

applyButton.MouseButton1Click:Connect(function()
	local result = applyActions(state.lastActions)
	reportBox.Text = state.lastReport .. "\n\n---\n\n" .. result
end)

patchButton.MouseButton1Click:Connect(function()
	local result = createPatchScript()
	reportBox.Text = state.lastReport .. "\n\n---\n\n" .. result
end)

apiButton.MouseButton1Click:Connect(function()
	state.apiUrl = apiBox.Text

	local payload = {
		log = logBox.Text,
		placeName = game.Name,
	}

	local ok, response = pcall(function()
		return HttpService:RequestAsync({
			Url = state.apiUrl,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
			},
			Body = HttpService:JSONEncode(payload),
		})
	end)

	if not ok then
		reportBox.Text = "API request failed.\n\nTippek:\n- Futtasd a local servert.\n- Kapcsold be HTTP Requests-t Studio Game Settingsben.\n- Ellenőrizd az API URL-t.\n\nHiba:\n" .. tostring(response)
		return
	end

	if not response.Success then
		reportBox.Text = "API error: " .. tostring(response.StatusCode) .. "\n" .. tostring(response.Body)
		return
	end

	local decoded
	local decodeOk = pcall(function()
		decoded = HttpService:JSONDecode(response.Body)
	end)

	if not decodeOk then
		reportBox.Text = "API returned invalid JSON:\n" .. tostring(response.Body)
		return
	end

	state.lastReport = decoded.report or "No report returned."
	state.lastActions = decoded.actions or {}
	reportBox.Text = state.lastReport .. "\n\nAPI actions received: " .. tostring(#state.lastActions)
end)

openButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)
