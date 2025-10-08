if LoadingScriptDoor then return end
LoadingScriptDoor = true
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == true then
repeat task.wait() until game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == false
end

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/ESPLibrary/refs/heads/main/Library.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/Test.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/ThemeManagerCopy.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/SaveManagerCopy.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

Library:SetWatermarkVisibility(true)

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local PFS = game:GetService("PathfindingService")
local Storage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer
local playergui = player:WaitForChild("PlayerGui")
local pack = player:WaitForChild("Backpack")
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart") 
local cam = game:GetService("Workspace").Camera

local MobileOn = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())

_G.GetOldBright = {
	["Old"] = {
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		FogEnd = Lighting.FogEnd,
		FogStart = Lighting.FogStart,
		GlobalShadows = Lighting.GlobalShadows,
		OutdoorAmbient = Lighting.OutdoorAmbient
	},
	["New"] = {
		Brightness = 2,
		ClockTime = 14,
		FogEnd = 200000,
		FogStart = 100000,
		GlobalShadows = false,
		OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	}
}

if not HookLoading then
HookLoading = true
local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if method == "FireServer" then
        if self.Name == "ClutchHeartbeat" and Toggles["心跳胜利"].Value then
            return
        end
        if self.Name == "Crouch" and Toggles["自动使用蹲下"].Value then
            args[1] = true
            return old(self,unpack(args))
        end
    end
    return old(self,...)
end))
end

function Distance(pos)
	if root then
		return (root.Position - pos).Magnitude
	end
end
function Distance2(pos)
	if root then
		return (pos - root.Position).Magnitude
	end
end

function Deciphercode(v)
local Hints = playergui:WaitForChild("PermUI"):WaitForChild("Hints")
local code = {[1] = "_",[2] = "_", [3] = "_", [4] = "_", [5] = "_"}
    for i, v in pairs(v:WaitForChild("UI"):GetChildren()) do
        if v:IsA("ImageLabel") and v.Name ~= "Image" then
            for b, n in pairs(Hints:GetChildren()) do
                if n:IsA("ImageLabel") and n.Visible and v.ImageRectOffset == n.ImageRectOffset then
                    code[tonumber(v.Name)] = n:FindFirstChild("TextLabel").Text 
                end
            end
        end
    end 
    return code
end

function NotifyDoor(Notify)
if MainUi:FindFirstChild("AchievementsHolder") and MainUi.AchievementsHolder:FindFirstChild("Achievement") then
local acheivement = MainUi.AchievementsHolder.Achievement:Clone()
acheivement.Size = UDim2.new(0, 0, 0, 0)
acheivement.Frame.Position = UDim2.new(1.1, 0, 0, 0)
acheivement.Name = "LiveAchievement"
acheivement.Visible = true
acheivement.Frame.TextLabel.Text = Notify.NotificationType or "通知"

if Notify.Color ~= nil then
	acheivement.Frame.TextLabel.TextColor3 = Notify.Color
	acheivement.Frame.UIStroke.Color = Notify.Color
	acheivement.Frame.Glow.ImageColor3 = Notify.Color
end

acheivement.Frame.Details.Desc.Text = tostring(Notify.Description)
acheivement.Frame.Details.Title.Text = tostring(Notify.Title)
acheivement.Frame.Details.Reason.Text = tostring(Notify.Reason or "")

if Notify.Image:match("rbxthumb://") or Notify.Image:match("rbxassetid://") then
	acheivement.Frame.ImageLabel.Image = tostring(Notify.Image or "rbxassetid://0")
else
	acheivement.Frame.ImageLabel.Image = "rbxassetid://" .. tostring(Notify.Image or "0")
end
if Notify.Image ~= nil then acheivement.Frame.ImageLabel.BackgroundTransparency = 1 end
acheivement.Parent = MainUi.AchievementsHolder
acheivement.Sound.SoundId = "rbxassetid://10469938989"
acheivement.Sound.Volume = 1
if Notify.SoundToggle then
	acheivement.Sound:Play()
end

task.spawn(function()
	acheivement:TweenSize(UDim2.new(1, 0, 0.2, 0), "In", "Quad", 0.8, true)
	task.wait(0.8)
	acheivement.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.5, true)
	TweenService:Create(acheivement.Frame.Glow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{ImageTransparency = 1}):Play()
	if Notify.Time ~= nil then
        if typeof(Notify.Time) == "number" then
            task.wait(Notify.Time)
        elseif typeof(Notify.Time) == "Instance" then
            Notify.Time.Destroying:Wait()
        end
    else
        task.wait(5)
    end
	acheivement.Frame:TweenPosition(UDim2.new(1.1, 0, 0, 0), "In", "Quad", 0.5, true)
	task.wait(0.5)
	acheivement:TweenSize(UDim2.new(1, 0, -0.1, 0), "InOut", "Quad", 0.5, true)
	task.wait(0.5)
	acheivement:Destroy()
end)
end
end

_G.EntityTable = {
	Entity = {
		["FigureRig"] = "Figure",
		["SallyMoving"] = "Window",
		["RushMoving"] = "Rush",
		["Eyes"] = "Eyes",
		["Groundskeeper"] = "Skeeper",
		["BackdoorLookman"] = "Lookman",
		["BackdoorRush"] = "Blitz",
		["MandrakeLive"] = "Mandrake",
		["GloomPile"] = "Egg",
		["Snare"] = "Snare",
		["MonumentEntity"] = "Monument",
		["LiveEntityBramble"] = "Bramble",
		["GrumbleRig"] = "Grumble",
		["GiggleCeiling"] = "Giggle",
		["AmbushMoving"] = "Ambush",
		["A60"] = "A-60",
		["A120"] = "A-120"
	},
	EntityNotify = {
		RushMoving = {"Rush", "找个地方躲起来！"},
		AmbushMoving = {"Ambush", "多次躲藏！"},
		A60 = {"A-60", "立即躲藏！"},
		A120 = {"A-120", "找个躲藏点！"},
		JeffTheKiller = {"Jeff", "保持距离并避开。"},
		SeekMovingNewClone = {"Seek", "奔跑并躲避障碍物！"},
		BackdoorRush = {"Blitz", "找个地方躲起来。"},
		GlitchRush = {"GlitchRush", "找个地方躲起来。"},
		GlitchAmbush = {"Glitch Ambush", "找个躲藏点！"},
		GiggleCeiling = {"Giggle", "避开它。"},
		Groundskeeper = {"Skeeper", "不要碰草地"},
		MonumentEntity = {"Monument", "你需要走一段距离并回头检查。"}
	},
	Closet = {
		["A60"] = 190,
		["A120"] = 90,
		["RushMoving"] = 150,
		["AmbushMoving"] = 200,
		["GlitchRush"] = 190,
		["GlitchAmbush"] = 200,
		["BackdoorRush"] = 160
	}
}

function EntityFond()
	for i, v in pairs(workspace:GetChildren()) do
		for j, b in pairs(_G.EntityTable.Closet) do
			if v.Name == j and v.PrimaryPart then
				return v
			end
		end
	end
end

if game.CoreGui:FindFirstChild("Gui Track") == nil then
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Gui Track"
gui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.2, 0, 0.1, 0)
Frame.Position = UDim2.new(0.02, 0, 0.87, 0)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.BorderColor3 = Color3.new(0, 0, 0)
Frame.BorderSizePixel = 1
Frame.Active = true
Frame.BackgroundTransparency = 0 
Frame.Parent = gui

local UICorner = Instance.new("UIStroke")
UICorner.Color = Color3.new(0, 0, 0)
UICorner.Thickness = 2.5
UICorner.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Frame1 = Instance.new("Frame")
Frame1.Size = UDim2.new(1, 0, 1, 0)
Frame1.Position = UDim2.new(0, 0, 0, 0)
Frame1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame1.BorderColor3 = Color3.new(0, 0, 0)
Frame1.BorderSizePixel = 1
Frame1.Active = true
Frame1.BackgroundTransparency = 0.3
Frame1.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame1

local Frame2 = Instance.new("Frame")
Frame2.Name = "Frame1"
Frame2.Size = UDim2.new(1, 0, 1, 0)
Frame2.Position = UDim2.new(0, 0, 0, 0)
Frame2.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
Frame2.BorderColor3 = Color3.new(0, 0, 0)
Frame2.BorderSizePixel = 1
Frame2.Active = true
Frame2.BackgroundTransparency = 0.15
Frame2.Parent = Frame1

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame2

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
TextLabel.BorderColor3 = Color3.new(0, 0, 0)
TextLabel.BorderSizePixel = 1
TextLabel.Text = ""
TextLabel.TextSize = 16
TextLabel.BackgroundTransparency = 1
TextLabel.TextColor3 = Color3.new(0, 0, 0)
TextLabel.Font = Enum.Font.Code
TextLabel.TextWrapped = true
TextLabel.Parent = Frame

local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)
UITextSizeConstraint.MaxTextSize = 35
end

function UpdateTrack(enabled, update)
update.Name = update.Name or "未知"
update.Size = update.Size or 1
if game.CoreGui:FindFirstChild("Gui Track") then
game.CoreGui["Gui Track"].Enabled = enabled or false
game.CoreGui["Gui Track"].Frame:FindFirstChild("TextLabel").Text = update.Name
local TweenService = game:GetService("TweenService")
local TweenBar = TweenService:Create(game.CoreGui["Gui Track"].Frame.Frame:FindFirstChild("Frame1"), TweenInfo.new(1.5), {Size = UDim2.new(update.Size, 0, 1, 0)})
TweenBar:Play()
end
end

local EntityModules = Storage.ModulesClient.EntityModules
gameData = Storage:WaitForChild("GameData")
local RoomLate = gameData.LatestRoom
local floor = gameData:WaitForChild("Floor")
local isMines = floor.Value == "Mines"
local isHotel = floor.Value == "Hotel"
local isBackdoor = floor.Value == "Backdoor"
local isGarden = floor.Value == "Garden"
local isRoom = floor.Value == "Rooms"
local isParty = floor.Value == "Party"

for i, v in pairs(playergui:GetChildren()) do
	if v.Name == "MainUI" and v:FindFirstChild("Initiator") and v.Initiator:FindFirstChild("Main_Game") then
		requireGui = require(v.Initiator.Main_Game)
		MainUi = v
	end
end
playergui.ChildAdded:Connect(function()
	if v.Name == "MainUI" and v:FindFirstChild("Initiator") and v.Initiator:FindFirstChild("Main_Game") then
		requireGui = require(v.Initiator.Main_Game)
		MainUi = v
	end
end)

local FrameTimer = tick()
local CurrentRooms = 0
local FrameCounter = 0
local FPS = 60

-- 优化：减少渲染循环中的计算量
local lastWatermarkUpdate = 0
local watermarkUpdateInterval = 0.5 -- 每0.5秒更新一次水印

game:GetService("RunService").RenderStepped:Connect(function()
    FrameCounter += 1
    
    -- 限制水印更新频率
    local currentTime = tick()
    if (currentTime - lastWatermarkUpdate) >= watermarkUpdateInterval then
        if (tick() - FrameTimer) >= 1 then
            FPS = FrameCounter
            FrameTimer = tick()
            FrameCounter = 0
        end
        
        if isMines then 
            CurrentRooms = 100 + RoomLate.Value 
        elseif isBackdoor then 
            CurrentRooms = -50 + RoomLate.Value 
        else 
            CurrentRooms = RoomLate.Value 
        end
        
        Library:SetWatermark(("%s 当前房间 | %s FPS | %s MS"):format(
            math.floor(CurrentRooms),
            math.floor(FPS),
            math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        ))
        lastWatermarkUpdate = currentTime
    end
    
    -- 优化：只在设置改变时更新光照
    if _G.FullBright then
        for i, v in pairs(_G.GetOldBright.New) do
            Lighting[i] = v
        end
    end
    
    if _G.AntiCheatBruh and char then
        char:PivotTo(char:GetPivot() * CFrame.new(0, 0, 1000))
    end
    
    if game:GetService("Workspace"):FindFirstChild("Camera") then
        local CAM = game:GetService("Workspace").Camera
        if requireGui then
            if _G.ThirdCamera then
                CAM.CFrame = requireGui.finalCamCFrame * CFrame.new(1.5, -0.5, 6.5)
            end
            if _G.NoShake then
                requireGui.csgo = CFrame.new()
            end
        end
        
        if char:FindFirstChild("Head") and not (requireGui and requireGui.stopcam or char.HumanoidRootPart.Anchored and not char:GetAttribute("Hiding")) then
            char:SetAttribute("ShowInFirstPerson", _G.ThirdCamera)
            char.Head.LocalTransparencyModifier = _G.ThirdCamera and 0 or 1
        end
        
        if _G.FovOPCamera then
            if not requireGui then
                CAM.FieldOfView = _G.FovOP or 71
            else
                requireGui.fovtarget = _G.FovOP or 70
            end
        end
    end
end)

if not isHotel then
_G.RemoveLag = {"Leaves", "HidingShrub", "Flowers"}

-- 优化：防卡顿函数，减少不必要的操作
function RemoveLagTo(v)
	if _G.AntiLag == true then
		local Terrain = workspace:FindFirstChildOfClass("Terrain")
		if Terrain then
			Terrain.WaterWaveSize = 0
			Terrain.WaterWaveSpeed = 0
			Terrain.WaterReflectance = 0
			Terrain.WaterTransparency = 1
		end
		
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.FogStart = 9e9
		
		if v:IsA("ForceField") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
			v:Destroy()
		end
		
		for i, n in pairs(_G.RemoveLag) do
			if v.Name == n or v.Name:find("grass") then
				v:Destroy()
			end
		end
		
		if v:IsA("PostEffect") then
			v.Enabled = false
		end
		
		if v:IsA("BasePart") then
			v.Material = "Plastic"
			v.Reflectance = 0
			v.BackSurface = "SmoothNoOutlines"
			v.BottomSurface = "SmoothNoOutlines"
			v.FrontSurface = "SmoothNoOutlines"
			v.LeftSurface = "SmoothNoOutlines"
			v.RightSurface = "SmoothNoOutlines"
			v.TopSurface = "SmoothNoOutlines"
		elseif v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		end
	end
end

-- 优化：防卡顿连接，添加防抖处理
local lastAntiLagProcess = 0
local antiLagCooldown = 0.1
workspace.DescendantAdded:Connect(function(v)
    local currentTime = tick()
    if (currentTime - lastAntiLagProcess) >= antiLagCooldown then
        RemoveLagTo(v)
        lastAntiLagProcess = currentTime
    end
end)
end

if isRoom then
	if workspace:FindFirstChild("PathFindPartsFolder") == nil then
	    local Folder = Instance.new("Folder")
	    Folder.Parent = workspace
	    Folder.Name = "PathFindPartsFolder"
	end
end

---- UiLib ----

function Notification(notifyFu)
if _G.ChooseNotify == "Obsidian" then
Library:Notify({
    Title = notifyFu.title or "",
    Description = notifyFu.content or "",
    Time = notifyFu.duration or 5,
})
elseif _G.ChooseNotify == "Roblox" then
game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = notifyFu.title,
	Text = notifyFu.content,
	Icon = ("rbxassetid://"..notifyFu.icon) or "",
	Duration = notifyFu.duration or 5
})
elseif _G.ChooseNotify == "Door" then
NotifyDoor({
    Title = notifyFu.title or "",
    Description = notifyFu.content or "",
    Time = notifyFu.duration or 5,
    Image = ("rbxassetid://"..notifyFu.icon) or "",
    SoundToggle = true,
})
end
if _G.ChooseNotify ~= "Door" then
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://4590662766"
sound.Volume = _G.VolumeTime or 2
sound.PlayOnRemove = true
sound:Destroy()
end
end

Library:SetDPIScale(85)
local Window = Library:CreateWindow({
    Title = "Nihahaha Hub",
    Center = true,
    AutoShow = true,
    Resizable = true,
	Footer = "by tanhoangvn and gianghub",
	Icon = 134430677550422,
	ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 2,
    MenuFadeTime = 0
})
    
Tabs = {
	Tab = Window:AddTab("主要", "house"),
    Tab1 = Window:AddTab("杂项", "layout-list"),
    Tab2 = Window:AddTab("透视", "house-plus"),
	["UI 设置"] = Window:AddTab("UI 设置", "settings")
}

local Main = Tabs.Tab:AddLeftGroupbox("主要功能")

Main:AddToggle("全亮", {
    Text = "全亮模式",
    Default = false,
    Callback = function(Value)
_G.FullBright = Value
if _G.FullBright then
for i, v in pairs(_G.GetOldBright.New) do
Lighting[i] = v
end
else
for i, v in pairs(_G.GetOldBright.Old) do
Lighting[i] = v
end
end
    end
})

Main:AddToggle("去雾", {
    Text = "去除雾气",
    Default = false,
    Callback = function(Value)
_G.Nofog = Value
-- 优化：减少循环频率
local lastFogUpdate = 0
local fogUpdateInterval = 0.5

while _G.Nofog do
    local currentTime = tick()
    if (currentTime - lastFogUpdate) >= fogUpdateInterval then
        for i, v in pairs(Lighting:GetChildren()) do
            if v.ClassName == "Atmosphere" then
                v.Density = 0
                v.Haze = 0
            end
        end
        lastFogUpdate = currentTime
    end
    task.wait(0.1)
end

for i, v in pairs(Lighting:GetChildren()) do
    if v.ClassName == "Atmosphere" then
        v.Density = 0.3
        v.Haze = 1
    end
end
    end
})

Main:AddToggle("即时提示", {
    Text = "即时交互提示",
    Default = false,
    Callback = function(Value)
_G.NoCooldownProximity = Value
if _G.NoCooldownProximity == true then
for i, v in pairs(workspace:GetDescendants()) do
if v.ClassName == "ProximityPrompt" then
v.HoldDuration = 0
end
end
CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
if _G.NoCooldownProximity == true then
if Cooldown:IsA("ProximityPrompt") then
Cooldown.HoldDuration = 0
end
end
end)
else
if CooldownProximity then
CooldownProximity:Disconnect()
CooldownProximity = nil
end
end
    end
})

Main:AddToggle("第三人称", {
    Text = "第三人称视角",
    Default = false,
    Callback = function(Value)
_G.ThirdCamera = Value
    end
})

Main:AddSlider("视野大小", {
    Text = "视野大小",
    Default = 80,
    Min = 70,
    Max = 150,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.FovOP = Value
    end
})

Main:AddToggle("自定义视野", {
    Text = "自定义视野",
    Default = false,
    Callback = function(Value)
_G.FovOPCamera = Value
    end
})

Main:AddToggle("无相机抖动", {
    Text = "无相机抖动",
    Default = false,
    Callback = function(Value)
_G.NoShake = Value
    end
})

local Main1 = Tabs.Tab:AddRightGroupbox("实体功能")

Main1:AddToggle("防尖叫", {
    Text = "防尖叫怪",
    Default = false,
    Callback = function(Value)
_G.AntiScreech = Value
if MainUi:FindFirstChild("Initiator") and MainUi.Initiator:FindFirstChild("Main_Game") and MainUi.Initiator.Main_Game:FindFirstChild("RemoteListener") and MainUi.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules") then
	local ScreechScript = MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("Screech") or MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("_Screech")
	if ScreechScript then
	    ScreechScript.Name = _G.AntiScreech and "_Screech" or "Screech"
	end
end
    end
})

Main1:AddToggle("心跳胜利", {
    Text = "防心跳胜利",
    Default = false
})

Main1:AddToggle("防停止", {
    Text = "防停止",
    Default = false,
    Callback = function(Value)
_G.NoHalt = Value
local HaltShade = EntityModules:FindFirstChild("Shade") or EntityModules:FindFirstChild("_Shade")
if HaltShade then
    HaltShade.Name = _G.NoHalt and "_Shade" or "Shade"
end
    end
})

Main1:AddToggle("防眼睛", {
    Text = "防眼睛/观察者",
    Default = false,
    Callback = function(Value)
_G.NoEyes = Value
-- 优化：减少循环频率
while _G.NoEyes do
    if workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman") then
        if Storage:FindFirstChild("RemotesFolder") then
            Storage:WaitForChild("RemotesFolder"):WaitForChild("MotorReplication"):FireServer(-649)
        end
    end
    task.wait(0.5) -- 从立即等待改为0.5秒
end
    end
})

Main1:AddToggle("防陷阱", {
    Text = "防陷阱",
    Default = false,
    Callback = function(Value)
for i, v in ipairs(workspace:GetDescendants()) do
	if v.Name == "Snare" then
        if v:FindFirstChild("Hitbox") then
           v.Hitbox:Destroy()
        end
    end
end
    end
})

if isGarden then
Main1:AddToggle("防纪念碑", {
    Text = "防纪念碑",
    Default = false,
    Callback = function(Value)
_G.NoMonument = Value
-- 优化：减少循环频率
while _G.NoMonument do
    for i, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "MonumentEntity" and v:FindFirstChild("Top") then
            for _, x in pairs(v.Top:GetChildren()) do
                if x.Name:find("Hitbox") then
                    x:Destroy()
                end
            end
        end
    end
    task.wait(0.5) -- 从立即等待改为0.5秒
end
    end
})
end

if isRoom or isParty then
Main1:AddToggle("防A90", {
    Text = "防 A-90",
    Default = false,
    Callback = function(Value)
_G.NoA90 = Value
if MainUi:FindFirstChild("Initiator") and MainUi.Initiator:FindFirstChild("Main_Game") and MainUi.Initiator.Main_Game:FindFirstChild("RemoteListener") and MainUi.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules") then
	local A90Script = MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("A90") or MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("_A90")
	if A90Script then
	    A90Script.Name = _G.NoA90 and "_A90" or "A90"
	end
end
    end
})
end

if isMines or isParty then
Main1:AddToggle("防蛋 gloom", {
    Text = "防蛋 gloom",
    Default = false,
    Callback = function(Value)
for _, v in ipairs(workspace:GetDescendants()) do
    if v.Name == "Egg" then
		v.CanTouch = not Value
	end
end
    end
})

Main1:AddToggle("防咯咯笑", {
    Text = "防咯咯笑",
    Default = false,
    Callback = function(Value)
for _, v in ipairs(workspace:GetDescendants()) do
	if v:IsA("Model") and v.Name == "GiggleCeiling" then
		repeat task.wait() until v:FindFirstChild("Hitbox")
		wait(0.1)
		if v:FindFirstChild("Hitbox") then
			v.Hitbox:Destroy()
		end
	end
end
    end
})

Main1:AddToggle("防追逐洪水", {
    Text = "防追逐洪水",
    Default = false,
    Callback = function(Value)
for _, v in ipairs(workspace:GetDescendants()) do
	if v.Name == "_DamHandler" then
		repeat task.wait() until v:FindFirstChild("SeekFloodline")
		wait(0.1)
		if v:FindFirstChild("SeekFloodline") then
			v.SeekFloodline.CanCollide = Value
		end
	end
end
    end
})

Main1:AddToggle("防坠落屏障", {
    Text = "防坠落屏障",
    Default = false,
    Callback = function(Value)
for _, v in ipairs(workspace:GetDescendants()) do
	if v.Name == "PlayerBarrier" and v.Size.Y == 2.75 and (v.Rotation.X == 0 or v.Rotation.X == 180) then
		local CLONEBARRIER = v:Clone()
		CLONEBARRIER.CFrame = CLONEBARRIER.CFrame * CFrame.new(0, 0, -5)
		CLONEBARRIER.Color = Color3.new(1, 1, 1)
		CLONEBARRIER.Name = "CLONEBARRIER_ANTI"
		CLONEBARRIER.Size = Vector3.new(CLONEBARRIER.Size.X, CLONEBARRIER.Size.Y, 11)
		CLONEBARRIER.Transparency = 0
		CLONEBARRIER.Parent = v.Parent
	end
end
    end
})

Main1:AddToggle("引导路径", {
    Text = "引导路径",
    Default = false,
    Callback = function(Value)
_G.GuideNah = Value
if _G.GuideNah then
local function PathLights()
	if workspace:FindFirstChild("PathLights") then
		local function GuideMine(v)
			if v:IsA("Part") then
				local CLONEGUIDE = v:Clone()
	            CLONEGUIDE.CFrame = CLONEGUIDE.CFrame
	            CLONEGUIDE.Color = Color3.fromRGB(0, 255, 0)
	            CLONEGUIDE.Name = "GuideClone"
	            CLONEGUIDE.Shape = Enum.PartType.Ball
	            CLONEGUIDE.Size = Vector3.new(1, 1, 1)
			    CLONEGUIDE.Transparency = 0
				CLONEGUIDE.Anchored = true
			    CLONEGUIDE.Parent = v
				for i, n in pairs(CLONEGUIDE:GetChildren()) do
					n:Destroy()
				end
			end
		end
		for _, v in ipairs(workspace.PathLights:GetChildren()) do
			GuideMine(v)
		end
		GuideMineReal = workspace.PathLights.ChildAdded:Connect(function(v)
			GuideMine(v)
		end)
	end
end
for _, v in ipairs(workspace:GetChildren()) do
	PathLights()
end
GoLightPath = workspace.ChildAdded:Connect(function(v)
	PathLights()
end)
else
if GuideMineReal then
GuideMineReal:Disconnect()
GuideMineReal = nil
end
if GoLightPath then
GoLightPath:Disconnect()
GoLightPath = nil
end
if workspace:FindFirstChild("PathLights") then
	for i, v in pairs(workspace:FindFirstChild("PathLights"):GetChildren()) do
		if v:IsA("Part") then
			for _, d in pairs(v:GetChildren()) do
				if d.Name == "GuideClone" then
					d:Destroy()
				end
			end
		end
	end
end
end
    end
})
end

if not isHotel then
Main1:AddToggle("防卡顿", {
    Text = "防卡顿",
    Default = false,
    Callback = function(Value)
_G.AntiLag = Value
if _G.AntiLag == true then
for i,v in pairs(workspace:GetDescendants()) do
	RemoveLagTo(v)
end
end
    end
})
end

if isHotel then
Main1:AddToggle("防追逐障碍", {
    Text = "防追逐障碍",
    Default = false,
    Callback = function(Value)
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
	if v.Name == "ChandelierObstruction" or v.Name == "Seek_Arm" then
        for b, h in pairs(v:GetDescendants()) do
            if h:IsA("BasePart") then 
				h.CanTouch = not Value
			end
        end
    end
end
    end
})
end

if not isGarden and not isRoom then
Main1:AddToggle("防假门", {
    Text = "防假门",
    Default = false,
    Callback = function(Value)
for _, v in ipairs(workspace:GetDescendants()) do
	if v.Name == "DoorFake" then
		local CollisionFake = v:FindFirstChild("Hidden", true)
		local Prompt = v:FindFirstChild("UnlockPrompt", true)
		if CollisionFake then
			CollisionFake.CanTouch = not Value
		end
		if Prompt then
			Prompt:Destroy()
		end
	end
end
    end
})
end

Main1:AddDivider()

Main1:AddToggle("自动使用蹲下", {
    Text = "自动使用蹲下",
    Default = false
})

Main1:AddToggle("使用跳跃", {
    Text = "使用跳跃",
    Default = false,
    Callback = function(Value)
_G.ButtonJump = Value 
-- 优化：减少循环频率
while _G.ButtonJump do 
    if char then
        char:SetAttribute("CanJump", true)
    end
    task.wait(0.1) -- 从立即等待改为0.1秒
end 
if char then
    char:SetAttribute("CanJump", false)
end
    end
})

Main1:AddToggle("检查状态", {
    Text = "检查 "..(isBackdoor and "急速时钟" or "氧气"),
    Default = false,
    Callback = function(Value)
_G.ActiveCheck = Value
if _G.ActiveCheck then
if isBackdoor then
	if Storage:FindFirstChild("FloorReplicated") and game:GetService("ReplicatedStorage").FloorReplicated:FindFirstChild("DigitalTimer") and game:GetService("ReplicatedStorage").FloorReplicated:FindFirstChild("ScaryStartsNow") then
		local function getTimeFormat(sec)
		    local min = math.floor(sec / 60)
		    local remSec = sec % 60
		    return string.format("%02d:%02d", min, remSec)
		end
		getCheck = Storage.FloorReplicated.DigitalTimer:GetPropertyChangedSignal("Value"):Connect(function()
		    if _G.ActiveCheck and game:GetService("ReplicatedStorage").FloorReplicated.ScaryStartsNow.Value then
			    if Storage.FloorReplicated.DigitalTimer.Value <= 60 then
					SizeTime = (Storage.FloorReplicated.DigitalTimer.Value / 60)
				else
					SizeTime = 1
				end
		        UpdateTrack(true, {Name = "时钟: "..getTimeFormat(Storage.FloorReplicated.DigitalTimer.Value), Size = SizeTime or 1})
		    end
		end)
	end
else
	getCheck = char:GetAttributeChangedSignal("Oxygen"):Connect(function()
		if char:GetAttribute("Oxygen") < 100 then
			UpdateTrack(true, {
				Name = string.format("氧气: %.1f", char:GetAttribute("Oxygen")),
				Size = (char:GetAttribute("Oxygen") / 100)
			})
		else
			UpdateTrack(false, {Name = "氧气: 100", Size = 1})
		end
	end)
end
else
if getCheck then
	getCheck:Disconnect()
	getCheck = nil
end
UpdateTrack(false, {Name = "正常", Size = 1})
end
    end
})

local Misc = Tabs.Tab1:AddLeftGroupbox("通知设置")

local EntityName = {}
for i, v in pairs(_G.EntityTable.EntityNotify) do
	table.insert(EntityName, v[1])
end

Misc:AddDropdown("实体通知", {
    Text = "实体通知",
    Values = EntityName,
    Default = {"Rush"},
    Multi = true,
    Callback = function(Value)
_G.EntityNotifyNow = {}
for i, v in next, Options.实体通知.Value do
	table.insert(_G.EntityNotifyNow, i)
end
    end
})

Misc:AddToggle("实体通知", {
    Text = "实体通知",
    Default = false,
    Callback = function(Value)
_G.NotifyEntity = Value
if _G.NotifyEntity then
    EntityChild = workspace.DescendantAdded:Connect(function(child)
	    for i, v in pairs(_G.EntityNotifyNow or {"Rush"}) do
            if child:IsA("Model") and child.Name:find(v) then
	            repeat task.wait() until not child:IsDescendantOf(workspace) or Distance(child:GetPivot().Position) < 10000
				local EntityName = _G.EntityTable.EntityNotify[child.Name][1]
				local EntityWa = _G.EntityTable.EntityNotify[child.Name][2]
				if child:IsDescendantOf(workspace) then
					child.AncestryChanged:Connect(function()
					  if not child.Parent then
						if _G.GoodbyeBro then
						    Notification({title = "Arona", content = "实体: 再见 "..EntityName.."!!", duration = 5, icon = "82357489459031"})
			                if _G.NotifyEntityChat then
			                    local text = _G.ChatNotifyGoodBye or "再见 "
			                    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text..EntityName)
			                end
						end
					  end
					end)
                    Notification({title = "Arona", content = "实体: "..EntityName.." 已生成! "..EntityWa, duration = 5, icon = "82357489459031"})
                    if _G.NotifyEntityChat then
                        local text = _G.ChatNotify or " 生成!!"
                        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(EntityName..text)
                    end
                end
            end
		end
	end)
else
    if EntityChild then
        EntityChild:Disconnect()
        EntityChild = nil
    end
end
    end
})

Misc:AddInput("告别聊天", {
    Text = "输入告别聊天内容",
    Default = "再见!!",
    Numeric = false,
    Finished = true,
    Placeholder = "你的告别聊天内容...",
    Callback = function(Value)
_G.ChatNotifyGoodBye = Value
    end
})

Misc:AddInput("实体聊天", {
    Text = "输入实体聊天内容",
    Default = "生成!!",
    Numeric = false,
    Finished = true,
    Placeholder = "你的聊天内容...",
    Callback = function(Value)
_G.NotifyEntityChat = Value
    end
})

Misc:AddToggle("聊天通知", {
    Text = "聊天通知实体",
    Default = false,
    Callback = function(Value)
_G.NotifyEntityChat = Value
    end
})

Misc:AddToggle("告别通知", {
    Text = "告别通知",
    Default = false,
    Callback = function(Value)
_G.GoodbyeBro = Value
    end
})

Misc:AddDivider()

if isGarden then
Misc:AddToggle("荆棘灯通知", {
    Text = "荆棘灯通知",
    Default = false,
    Callback = function(Value)
_G.BrambleLight = Value
if _G.BrambleLight then
local function BrambleLight(v)
	if v.Name == "LiveEntityBramble" and v:FindFirstChild("Head") and v.Head:FindFirstChild("LanternNeon") then
		for i, x in pairs(v.Head.LanternNeon:GetChildren()) do
			if x.Name == "Attachment" and x:FindFirstChild("PointLight") then
				LightningNotifyBr = x.PointLight:GetPropertyChangedSignal("Enabled"):Connect(function()
					if x.PointLight.Enabled then turn = "开" else turn = "关" end
					Notification({title = "Arona", content = "荆棘灯 ("..turn..")", duration = 3, icon = "82357489459031"})
					if _G.NotifyEntityChat then
						game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(TextChat.." 荆棘灯 ("..turn..")")
					end
				end)
			end
		end
	end
end
for _, v in ipairs(workspace:GetDescendants()) do
	BrambleLight(v)
end
BrambleSpawn = workspace.DescendantAdded:Connect(function(v)
	BrambleLight(v)
end)
else
if LightningNotifyBr then
LightningNotifyBr:Disconnect()
LightningNotifyBr = nil
end
if BrambleSpawn then
BrambleSpawn:Disconnect()
BrambleSpawn = nil
end
end
    end
})
end

if isHotel then
Misc:AddToggle("自动获取图书馆代码", {
    Text = "自动获取图书馆代码",
    Default = false,
    Callback = function(Value)
_G.NotifyEntity = Value
if _G.NotifyEntity then
local function CodeAll(v)
	if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
        code = table.concat(Deciphercode(v))
        if code then
	        Notification({title = "Arona", content = "代码: "..code, duration = 15, icon = "82357489459031"})
			if _G.NotifyEntityChat then
				game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("图书馆代码: "..code)
			end
			if _G.AutoUnlockPadlock then
				game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("PL"):FireServer(code)
			end
		end
    end
end
Getpaper = char.ChildAdded:Connect(function(v)
CodeAll(v)
end)
else
if Getpaper then
Getpaper:Disconnect()
Getpaper = nil
end
end
    end
})

Misc:AddToggle("自动解锁挂锁", {
    Text = "自动解锁挂锁",
    Default = false,
    Callback = function(Value)
_G.AutoUnlockPadlock = Value
    end
})
end

Misc:AddToggle("聊天通知", {
    Text = "聊天通知",
    Default = false,
    Callback = function(Value)
_G.NotifyChat = Value
    end
})

local Misc1 = Tabs.Tab1:AddRightGroupbox("自动化")

if isHotel then
Misc1:AddButton({
    Text = "瞬间立方体故障",
    Func = function()
LoadingInstant = true
spawn(function()
	Toggles["绕过速度"]:SetValue(false)
	wait(0.3)
	repeat task.wait() until not LoadingInstant
	wait(0.5)
	Toggles["绕过速度"]:SetValue(true)
end)
local OldCollision = char:FindFirstChild("CollisionPart").CFrame 
for i = 1, 6 do
	repeat task.wait()
		if root and root.Position.Y > -5 and char:FindFirstChild("CollisionPart") then
			char:FindFirstChild("CollisionPart").CFrame = OldCollision * CFrame.new(0, 90, 0)
		end
	until cam and cam:FindFirstChild("Glitch")
	wait(0.3)
	repeat task.wait() until cam and not cam:FindFirstChild("Glitch")
	wait(0.4)
	Notification({title = "Arona", content = "故障次数 "..i.." / 6", duration = 3, icon = "82357489459031"})
end
wait(0.7)
local Cube = workspace:FindFirstChild("GlitchCube", true)
if not Cube then
	Notification({title = "Arona", content = "你可以去找它。", duration = 5, icon = "82357489459031"})
end
for _, v in ipairs(workspace:GetDescendants()) do
	if v:IsA("Model") and v.Name == "GlitchCube" then
		Notification({title = "Arona", content = "哦看！故障立方体在这里生成", duration = 5, icon = "82357489459031"})
		ESPLibrary:AddESP({Object = v, Text = "故障立方体", Color = Color3.fromRGB(151, 50, 168)})
		break
	end
end
LoadingInstant = false
    end
})
end

if isMines then
Misc1:AddToggle("自动矿场锚点", {
    Text = "自动矿场锚点",
    Default = false,
    Callback = function(Value)
_G.MinesAnchorOh = Value
-- 优化：减少循环频率
while _G.MinesAnchorOh do
    if _G.AddedGet then
        if MainUi:FindFirstChild("AnchorHintFrame") and MainUi.AnchorHintFrame:FindFirstChild("Code") then
            for i, v in pairs(_G.AddedGet) do
                if v.Name == "MinesAnchor" and v:FindFirstChild("AnchorRemote") and Distance(v:GetPivot().Position) <= 15 then
                    v.AnchorRemote:InvokeServer(MainUi.AnchorHintFrame.Code.Text)
                end
            end
        end
    end
    task.wait(0.5) -- 从立即等待改为0.5秒
end
    end
})
end

Misc1:AddSlider("躲藏透明度", {
    Text = "躲藏透明度",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.TransparencyHide = Value
    end
})

Misc1:AddToggle("透明躲藏", {
    Text = "透明躲藏",
    Default = false,
    Callback = function(Value)
_G.HidingTransparency = Value
-- 优化：减少循环频率
while _G.HidingTransparency do
    if char:GetAttribute("Hiding") then
        for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
            if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
                if v.Value == char then
                    local hidePart = {}
                    for _, i in pairs(v.Parent:GetChildren()) do
                        if i:IsA("BasePart") then
                            i.Transparency = _G.TransparencyHide or 0.5
                            table.insert(hidePart, i)
                        end
                    end
                    repeat task.wait(0.1) -- 从立即等待改为0.1秒
                        for _, h in pairs(hidePart) do
                            h.Transparency = _G.TransparencyHide or 0.5
                        end
                    until not char:GetAttribute("Hiding") or not _G.HidingTransparency
                    for _, n in pairs(hidePart) do
                        n.Transparency = 0
                    end
                    break
                end
            end
        end
    end
    task.wait(0.1) -- 从立即等待改为0.1秒
end
    end
})

if not isRoom then
Misc1:AddToggle("自动躲藏", {
    Text = "自动躲藏",
    Default = false,
    Callback = function(Value)
_G.AutoCloset = Value
-- 优化：减少循环频率
while _G.AutoCloset do
    local EntityCl = EntityFond()
    if EntityCl and EntityCl.PrimaryPart then
        local distanceCloset = _G.EntityTable.Closet[EntityCl.Name]
        local distance = Distance2(EntityCl.PrimaryPart.Position)
        if distanceCloset and distance then
            if distance <= distanceCloset then
                if not char:GetAttribute("Hiding") then
                    for i, v in pairs(_G.AddedGet) do
                        if v:FindFirstChild("HiddenPlayer") and v:FindFirstChildWhichIsA("BasePart") and v:FindFirstChild("Main") and not v.Main:FindFirstChild("HideEntityOnSpot") then
                            if Distance2(v:FindFirstChildWhichIsA("BasePart").Position) <= 20 then
                                local Pro = v:FindFirstChild("HidePrompt", true)
                                if Pro and Pro.Enabled == true then
                                    fireproximityprompt(Pro)
                                end
                            end
                        end
                    end
                end
            elseif distance > distanceCloset + 10 then
                if char:GetAttribute("Hiding") then
                    Storage:WaitForChild("RemotesFolder"):WaitForChild("CamLock"):FireServer()
                end
            end
        end
    end
    task.wait(0.3) -- 从立即等待改为0.3秒
end
    end
})
end

Misc1:AddToggle("反作弊操纵", {
    Text = "反作弊操纵",
    Default = false,
    Callback = function(Value)
_G.AntiCheatBruh = Value
if _G.BypassSpeed then
	Toggles["绕过速度"]:SetValue(false)
	wait(0.3)
	repeat task.wait() until not _G.AntiCheatBruh
	wait(0.5)
	Toggles["绕过速度"]:SetValue(true)
end
    end
}):AddKeyPicker("反作弊操纵", {
   Default = "U",
   Text = "反作弊操纵",
   Mode = "Toggle",
   SyncToggleState = true
})

if isRoom then
Misc1:AddToggle("自动房间", {
    Text = "自动房间",
    Default = false,
    Callback = function(Value)
_G.AutoRoom = Value
if _G.AutoRoom then
	if MainUi:FindFirstChild("Initiator") and MainUi.Initiator:FindFirstChild("Main_Game") and MainUi.Initiator.Main_Game:FindFirstChild("RemoteListener") and MainUi.Initiator.Main_Game.RemoteListener:FindFirstChild("Modules") then
		local A90Script = MainUi.Initiator.Main_Game.RemoteListener.Modules:FindFirstChild("A90")
		if A90Script then
		    A90Script.Name = "_A90"
		end
	end
	function Locker()
		local LockerRooms
		for i,v in pairs(workspace.CurrentRooms:GetDescendants()) do
	        if v.Name == "Rooms_Locker" then
	            if v:FindFirstChild("Door") and v:FindFirstChild("HiddenPlayer") then
	                if v.HiddenPlayer.Value == nil and v.Door.Position.Y > -3 then
                        if LockerRooms == nil then
                            LockerRooms = v.Door
                        else
                            if Distance(v.Door.Position) < (LockerRooms.Position - root.Position).Magnitude then
                                LockerRooms = v.Door
                            end
                        end
	                end
	            end
	        end
	    end
		return LockerRooms
	end
	function getPathRooms()
	    local Part
	    local Entity = (workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120"))
	    if Entity and Entity.Main.Position.Y > -6.5 then
	        Part = Locker()
	    else
			if RoomLate.Value ~= 1000 then
				if char:GetAttribute("Hiding") then
		           Storage:WaitForChild("RemotesFolder"):WaitForChild("CamLock"):FireServer()	
				end
		        Part = workspace.CurrentRooms[RoomLate.Value].Door.Door
			end
	    end
	    return Part
	end
	function getHide()
		local Path = getPathRooms()
	    local Entity = (workspace:FindFirstChild("A60") or workspace:FindFirstChild("A120"))
	    if Entity then
	        if Path then
	            if Path.Parent.Name:find("Rooms_Locker") and Entity:FindFirstChild("Main") and Entity.Main.Position.Y > -6.5 then
                    if (root.Position - Path.Position).Magnitude <= 30 then
                        if not char:GetAttribute("Hiding") then
                            fireproximityprompt(Path.Parent:FindFirstChild("HidePrompt"))
                        end
                    end
	            end
	        end
		end
	end
end
spawn(function() 
while _G.AutoRoom do 
	getHide()
	_G.SpeedWalk = false
	_G.BypassSpeed = false
	char:SetAttribute("CanJump", false)
	if char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = 21.5
	end
	if char:FindFirstChild("CloneCollisionPart1") then
		char:FindFirstChild("CloneCollisionPart1"):Destroy()
	end
	task.wait() 
end 
end)
while _G.AutoRoom do 
	Destination = getPathRooms()
	local path = PFS:CreatePath({WaypointSpacing = 0.25, AgentRadius = 1.55, AgentCanJump = false})
	path:ComputeAsync(root.Position - Vector3.new(0, 2.5, 0), Destination.Position)
	if path and path.Status == Enum.PathStatus.Success then
		local Waypoints = path:GetWaypoints()
	    workspace:FindFirstChild("PathFindPartsFolder"):ClearAllChildren()
	    for _, Waypoint in pairs(Waypoints) do
	        local part = Instance.new("Part")
	        part.Size = Vector3.new(0.5, 0.5, 0.5)
	        part.Position = Waypoint.Position
	        part.Shape = "Cylinder"
	        part.Material = "SmoothPlastic"
			part.Shape = Enum.PartType.Ball
	        part.Anchored = true
	        part.CanCollide = false
	        part.Parent = workspace:FindFirstChild("PathFindPartsFolder")
	    end
		for _, Waypoint in pairs(Waypoints) do
	        if not char:GetAttribute("Hiding") then
	            char.Humanoid:MoveTo(Waypoint.Position)
	            char.Humanoid.MoveToFinished:Wait()
	        end
	    end
	end
end
wait(0.3)
workspace:FindFirstChild("PathFindPartsFolder"):ClearAllChildren()
    end
})
end

Misc1:AddDropdown("自动拾取类型", {
    Text = "不拾取",
    Multi = true,
    Values = {"解锁锁具", "Jeff商店", "黄金", "光源物品", "头骨提示"}
})

_G.Aura = {
	["AuraPrompt"] = {
		"ActivateEventPrompt",
		"HerbPrompt",
		"LootPrompt",
		"SkullPrompt",
		"ValvePrompt",
		"LongPushPrompt",
		"LeverPrompt",
		"FusesPrompt",
		"UnlockPrompt",
		"AwesomePrompt",
		"ModulePrompt",
		"PartyDoorPrompt",
	},
	["AutoLootInteractions"] = {
		"ActivateEventPrompt",
		"HerbPrompt",
		"LootPrompt",
		"SkullPrompt",
		"ValvePrompt"
	},
	["AutoLootNotInter"] = {
		"LongPushPrompt",
		"LeverPrompt",
		"FusesPrompt",
		"UnlockPrompt",
		"AwesomePrompt",
		"ModulePrompt",
		"PartyDoorPrompt",
	}
}
Misc1:AddToggle("自动拾取", {
    Text = "自动拾取",
    Default = false,
    Callback = function(Value)
_G.AutoLoot = Value
-- 优化：减少循环频率
while _G.AutoLoot do
    for i, v in pairs(_G.AddedGet) do
        if v:IsA("ProximityPrompt") and v.Enabled == true then
            if Distance(v.Parent:GetPivot().Position) <= 12 then
                if Options["自动拾取类型"].Value["解锁锁具"] and (v.Name == "UnlockPrompt" or v.Parent:GetAttribute("Locked")) and char:FindFirstChild("Lockpick") then continue end
                if Options["自动拾取类型"].Value["黄金"] and v.Name == "LootPrompt" then continue end
                if Options["自动拾取类型"].Value["光源物品"] and v.Parent:GetAttribute("Tool_LightSource") and not v.Parent:GetAttribute("Tool_CanCutVines") then continue end
                if Options["自动拾取类型"].Value["头骨提示"] and v.Name == "SkullPrompt" then continue end
                if Options["自动拾取类型"].Value["Jeff商店"] and v.Parent:GetAttribute("JeffShop") then continue end
                
                if v.Parent:GetAttribute("PropType") == "Battery" and ((char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool"):GetAttribute("RechargeProp") ~= "Battery") or char:FindFirstChildOfClass("Tool") == nil) then continue end 
                if v.Parent:GetAttribute("PropType") == "Heal" and char:FindFirstChild("Humanoid") and char.Humanoid.Health == char.Humanoid.MaxHealth then continue end
                if v.Parent.Name == "MinesAnchor" then continue end
                
                if table.find(_G.Aura["AutoLootNotInter"], v.Name) then
                    fireproximityprompt(v)
                end
                if table.find(_G.Aura["AutoLootInteractions"], v.Name) and not v:GetAttribute("Interactions"..game.Players.LocalPlayer.Name) then
                    fireproximityprompt(v)
                end
            end
        end
    end
    task.wait(0.1) -- 从立即等待改为0.1秒
end
    end
})

Misc1:AddSlider("移动速度", {
    Text = "移动速度",
    Default = 20,
    Min = 16,
    Max = (isParty and 80 or 21),
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.WalkSpeedTp = Value
    end
})

if isMines or isParty then
Misc1:AddSlider("梯子速度", {
    Text = "梯子速度",
    Default = 20,
    Min = 16,
    Max = 75,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.LadderSpeed = Value
    end
})
end

Misc1:AddSlider("维生素速度", {
    Text = "维生素速度",
    Default = 3,
    Min = 1,
    Max = 6,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.VitaminSpeed = Value
    end
})

Misc1:AddDropdown("移动速度类型", {
    Text = "移动速度类型",
    Multi = false,
    Values = {"维生素", "速度破解"},
    Callback = function(Value)
_G.WalkSpeedChose = Value
if Value ~= "维生素" then
if char then
char:SetAttribute("SpeedBoost", 0)
end
end
    end
})

if not isParty then
Misc1:AddToggle("绕过速度", {
    Text = "绕过速度限制",
    Default = false,
    Callback = function(Value)
_G.BypassSpeed = Value
if not _G.BypassSpeed then
	if char:FindFirstChild("CloneCollisionPart1") then
		char:FindFirstChild("CloneCollisionPart1"):Destroy()
	end
	if not _G.AntiCheatBruh and not LoadingInstant then
		Options.移动速度:SetMax(21)
		Options.维生素速度:SetMax(6)
	end
else
	Options.移动速度:SetMax(60)
	Options.维生素速度:SetMax(40)
end
-- 优化：减少循环频率
while _G.BypassSpeed do
    if char:FindFirstChild("CollisionPart") then
        if not char:FindFirstChild("CloneCollisionPart1") then
            local ClonedCollision = char.CollisionPart:Clone()
            ClonedCollision.Parent = char
            ClonedCollision.Name = "CloneCollisionPart1"
            ClonedCollision.Massless = true
            ClonedCollision.CanCollide = false
        end
    end
    if char:FindFirstChild("HumanoidRootPart") then
        local CloneColl = char:FindFirstChild("CloneCollisionPart1")
        if CloneColl then
            CloneColl.Anchored = false
            CloneColl.Massless = not CloneColl.Massless
            wait(0.23)
        end
    end
    task.wait(0.1) -- 从立即等待改为0.1秒
end
    end
})
end

Misc1:AddToggle("移动速度", {
    Text = "移动速度",
    Default = false,
    Callback = function(Value)
_G.SpeedWalk = Value
-- 优化：减少循环频率
while _G.SpeedWalk do
    if _G.WalkSpeedChose == "速度破解" then
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = (char:GetAttribute("Climbing") and (_G.LadderSpeed or 30) or _G.WalkSpeedTp)
        end
    elseif _G.WalkSpeedChose == "维生素" then
        if char then
            if not char:GetAttribute("Climbing") then
                char:SetAttribute("SpeedBoost", _G.VitaminSpeed or 3)
            else
                char:SetAttribute("SpeedBoost", 0)
                char.Humanoid.WalkSpeed = _G.LadderSpeed or 30
            end
        end
    end
    task.wait(0.1) -- 从立即等待改为0.1秒
end
if char then
    char:SetAttribute("SpeedBoost", 0)
end
    end
})

local Esp = Tabs.Tab2:AddLeftGroupbox("透视设置")

if not isGarden and not isRoom and not isParty then
Esp:AddToggle("钥匙透视", {
    Text = "透视"..(((isHotel or isBackdoor) and "钥匙/杠杆") or (isMines and "保险丝")),
    Default = false,
    Callback = function(Value)
_G.EspKey = Value
if not _G.EspKey then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name:find("Key") or v.Name == "LeverForGate" or v.Name:find("FuseObtain") then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率，只在需要时更新
local lastKeyUpdate = 0
local keyUpdateInterval = 1
while _G.EspKey do
    local currentTime = tick()
    if (currentTime - lastKeyUpdate) >= keyUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name:find("Key") or v.Name == "LeverForGate" or v.Name:find("FuseObtain") then
                    local ObjectsKey = ((v.Name == "LeverForGate" and "杠杆") or (v.Name:find("Key") and "钥匙") or (v.Name:find("FuseObtain") and "保险丝"))
                    if ObjectsKey then
                        ESPLibrary:AddESP({
                            Object = v,
                            Text = ObjectsKey,
                            Color = _G.ColorEsp1 or Color3.fromRGB(240, 196, 77)
                        })
                        ESPLibrary:UpdateObjectText(v, ObjectsKey)
                        ESPLibrary:UpdateObjectColor(v, _G.ColorEsp1 or Color3.fromRGB(240, 196, 77))
                        ESPLibrary:SetOutlineColor(_G.ColorEsp1 or Color3.fromRGB(240, 196, 77))
                    end
                end
            end
        end
        lastKeyUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("钥匙透视颜色", {
    Default = Color3.fromRGB(240, 196, 77),
    Callback = function(Value)
        _G.ColorEsp1 = Value
    end
})
end

Esp:AddToggle("门透视", {
    Text = "透视 "..(isRoom and "房间" or "门"),
    Default = false,
    Callback = function(Value)
_G.EspDoor = Value
if not _G.EspDoor then
	for i, v in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Door") and v.Door:FindFirstChild("Door") then
			if not v.Door:GetAttribute("Opened") then
				ESPLibrary:RemoveESP(v.Door)
			end
		end
	end
end

-- 优化：修复门ESP，只显示门的可视模型部分
local lastDoorUpdate = 0
local doorUpdateInterval = 1
while _G.EspDoor do
    local currentTime = tick()
    if (currentTime - lastDoorUpdate) >= doorUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(game.Workspace:FindFirstChild("CurrentRooms"):GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("Door") and v.Door:FindFirstChild("Door") then
                    if not v.Door:GetAttribute("Opened") then
                        -- 修复：只ESP门的可视部分，而不是整个碰撞范围
                        local doorModel = v.Door.Door
                        if doorModel then
                            local DoorE = (isRoom and "房间 " or "门 ")..((v.Door:FindFirstChild("Sign") and v.Door.Sign:FindFirstChild("Stinker") and v.Door.Sign.Stinker.Text) or (v.Door.Sign:FindFirstChild("SignText") and v.Door.Sign.SignText.Text)):gsub("^0+", "")..(v.Door:FindFirstChild("Lock") and " (上锁)" or "")
                            if DoorE then
                                ESPLibrary:AddESP({
                                    Object = doorModel, -- 只使用门的可视模型
                                    Text = DoorE,
                                    Color = _G.ColorEsp5 or Color3.fromRGB(245, 160, 12)
                                })
                                ESPLibrary:UpdateObjectText(doorModel, DoorE)
                                ESPLibrary:UpdateObjectColor(doorModel, _G.ColorEsp5 or Color3.fromRGB(245, 160, 12))
                                ESPLibrary:SetOutlineColor(_G.ColorEsp5 or Color3.fromRGB(245, 160, 12))
                            end
                        end
                    elseif v.Door:GetAttribute("Opened") then
                        ESPLibrary:RemoveESP(v.Door.Door) -- 移除门的可视模型
                    end
                end
            end
        end
        lastDoorUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("门透视颜色", {
    Default = Color3.fromRGB(245, 160, 12),
    Callback = function(Value)
        _G.ColorEsp5 = Value
    end
})

if isBackdoor then
Esp:AddToggle("时间杠杆透视", {
    Text = "透视时间杠杆",
    Default = false,
    Callback = function(Value)
_G.EspTimeLever = Value
if not _G.EspTimeLever then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name:find("TimerLever") then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastLeverUpdate = 0
local leverUpdateInterval = 1
while _G.EspTimeLever do
    local currentTime = tick()
    if (currentTime - lastLeverUpdate) >= leverUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name:find("TimerLever") then
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = "时间杠杆",
                        Color = _G.ColorEsp9 or Color3.fromRGB(66, 245, 152)
                    })
                    ESPLibrary:UpdateObjectText(v, "时间杠杆")
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp9 or Color3.fromRGB(66, 245, 152))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp9 or Color3.fromRGB(66, 245, 152))
                end
            end
        end
        lastLeverUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("时间杠杆透视颜色", {
    Default = Color3.fromRGB(66, 245, 152),
    Callback = function(Value)
        _G.ColorEsp9 = Value
    end
})
end

Esp:AddToggle("宝箱透视", {
    Text = "透视宝箱",
    Default = false,
    Callback = function(Value)
_G.EspChest = Value
if not _G.EspChest then
	for i, v in pairs(_G.AddedEsp) do
		if v:GetAttribute("Storage") == "ChestBox" or v.Name == "Toolshed_Small" then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastChestUpdate = 0
local chestUpdateInterval = 1
while _G.EspChest do
    local currentTime = tick()
    if (currentTime - lastChestUpdate) >= chestUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v:GetAttribute("Storage") == "ChestBox" or v.Name == "Toolshed_Small" then
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = v.Name:gsub("Box", ""):gsub("_Vine", ""):gsub("_Small", ""):gsub("Locked", "")..(v:GetAttribute("Locked") and " (上锁)" or ""),
                        Color = _G.ColorEsp10 or Color3.fromRGB(235, 140, 16)
                    })
                    ESPLibrary:UpdateObjectText(v, v.Name:gsub("Box", ""):gsub("_Vine", ""):gsub("_Small", ""):gsub("Locked", "")..(v:GetAttribute("Locked") and " (上锁)" or ""))
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp10 or Color3.fromRGB(235, 140, 16))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp10 or Color3.fromRGB(235, 140, 16))
                end
            end
        end
        lastChestUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("宝箱透视颜色", {
    Default = Color3.fromRGB(235, 140, 16),
    Callback = function(Value)
        _G.ColorEsp10 = Value
    end
})

if isHotel then
Esp:AddToggle("书籍透视", {
    Text = "透视书籍",
    Default = false,
    Callback = function(Value)
_G.EspBook = Value
if not _G.EspBook then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name:find("LiveHintBook") then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastBookUpdate = 0
local bookUpdateInterval = 1
while _G.EspBook do
    local currentTime = tick()
    if (currentTime - lastBookUpdate) >= bookUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name:find("LiveHintBook") then
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = "书籍",
                        Color = _G.ColorEsp12 or Color3.fromRGB(199, 85, 44)
                    })
                    ESPLibrary:UpdateObjectText(v, "书籍")
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp12 or Color3.fromRGB(199, 85, 44))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp12 or Color3.fromRGB(199, 85, 44))
                end
            end
        end
        lastBookUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("书籍透视颜色", {
    Default = Color3.fromRGB(199, 85, 44),
    Callback = function(Value)
        _G.ColorEsp12 = Value
    end
})

Esp:AddToggle("断路器透视", {
    Text = "透视断路器",
    Default = false,
    Callback = function(Value)
_G.EspBreaker = Value
if not _G.EspBreaker then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name:find("LiveBreakerPolePickup") then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastBreakerUpdate = 0
local breakerUpdateInterval = 1
while _G.EspBreaker do
    local currentTime = tick()
    if (currentTime - lastBreakerUpdate) >= breakerUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name:find("LiveBreakerPolePickup") then
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = "断路器",
                        Color = _G.ColorEsp13 or Color3.fromRGB(216, 235, 9)
                    })
                    ESPLibrary:UpdateObjectText(v, "断路器")
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp13 or Color3.fromRGB(216, 235, 9))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp13 or Color3.fromRGB(216, 235, 9))
                end
            end
        end
        lastBreakerUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("断路器透视颜色", {
    Default = Color3.fromRGB(216, 235, 9),
    Callback = function(Value)
        _G.ColorEsp13 = Value
    end
})
end

if isGarden then
Esp:AddToggle("断头台透视", {
    Text = "透视断头台",
    Default = false,
    Callback = function(Value)
_G.EspGuillotine = Value
if not _G.EspBook then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name == "VineGuillotine" then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastGuillotineUpdate = 0
local guillotineUpdateInterval = 1
while _G.EspGuillotine do
    local currentTime = tick()
    if (currentTime - lastGuillotineUpdate) >= guillotineUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name == "VineGuillotine" then
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = "断头台",
                        Color = _G.ColorEsp2 or Color3.fromRGB(143, 240, 70)
                    })
                    ESPLibrary:UpdateObjectText(v, "断头台")
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp2 or Color3.fromRGB(143, 240, 70))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp2 or Color3.fromRGB(143, 240, 70))
                end
            end
        end
        lastGuillotineUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("断头台透视颜色", {
    Default = Color3.fromRGB(143, 240, 70),
    Callback = function(Value)
        _G.ColorEsp2 = Value
    end
})
end

if isMines then
Esp:AddToggle("发电机透视", {
    Text = "透视发电机",
    Default = false,
    Callback = function(Value)
_G.EspGenerator = Value
if not _G.EspBreaker then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name == "MinesGenerator" then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastGeneratorUpdate = 0
local generatorUpdateInterval = 1
while _G.EspGenerator do
    local currentTime = tick()
    if (currentTime - lastGeneratorUpdate) >= generatorUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name == "MinesGenerator" then
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = "发电机",
                        Color = _G.ColorEsp3 or Color3.fromRGB(250, 75, 75)
                    })
                    ESPLibrary:UpdateObjectText(v, "发电机")
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp3 or Color3.fromRGB(250, 75, 75))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp3 or Color3.fromRGB(250, 75, 75))
                end
            end
        end
        lastGeneratorUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("发电机透视颜色", {
    Default = Color3.fromRGB(250, 75, 75),
    Callback = function(Value)
        _G.ColorEsp3 = Value
    end
})

Esp:AddToggle("矿场锚点透视", {
    Text = "透视矿场锚点",
    Default = false,
    Callback = function(Value)
_G.EspMinesAnchor = Value
if not _G.EspMinesAnchor then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name == "MinesAnchor" then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastAnchorUpdate = 0
local anchorUpdateInterval = 1
while _G.EspMinesAnchor do
    local currentTime = tick()
    if (currentTime - lastAnchorUpdate) >= anchorUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name == "MinesAnchor" and v:FindFirstChild("Sign") and v.Sign:FindFirstChild("TextLabel") then
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = "矿场锚点 ("..(v:FindFirstChild("Sign") and v.Sign:FindFirstChild("TextLabel") and v.Sign.TextLabel.Text)..")",
                        Color = _G.ColorEsp4 or Color3.fromRGB(148, 242, 220)
                    })
                    ESPLibrary:UpdateObjectText(v, "矿场锚点 ("..(v:FindFirstChild("Sign") and v.Sign:FindFirstChild("TextLabel") and v.Sign.TextLabel.Text)..")")
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp4 or Color3.fromRGB(148, 242, 220))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp4 or Color3.fromRGB(148, 242, 220))
                end
            end
        end
        lastAnchorUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("矿场锚点透视颜色", {
    Default = Color3.fromRGB(148, 242, 220),
    Callback = function(Value)
        _G.ColorEsp4 = Value
    end
})

Esp:AddToggle("水泵透视", {
    Text = "透视水泵",
    Default = false,
    Callback = function(Value)
_G.EspMinesAnchor = Value
if not _G.EspMinesAnchor then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name == "WaterPump" and v:FindFirstChild("Wheel") then
			ESPLibrary:RemoveESP(v)
		end
	end
end
-- 优化：减少循环频率
local lastPumpUpdate = 0
local pumpUpdateInterval = 1
while _G.EspMinesAnchor do
    local currentTime = tick()
    if (currentTime - lastPumpUpdate) >= pumpUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name == "WaterPump" and v:FindFirstChild("Wheel") then
                    if v:FindFirstChild("ScreenUI") and v.ScreenUI:FindFirstChild("OnFrame") and v.ScreenUI.OnFrame.Visible then PumpsOnOff = "开" elseif v:FindFirstChild("ScreenUI") and v.ScreenUI:FindFirstChild("OffFrame") and v.ScreenUI.OffFrame.Visible then PumpsOnOff = "关" end
                    ESPLibrary:AddESP({
                        Object = v,
                        Text = "水泵 ("..(PumpsOnOff or "未知")..")",
                        Color = _G.ColorEsp7 or Color3.fromRGB(79, 91, 255)
                    })
                    ESPLibrary:UpdateObjectText(v, "水泵 ("..(PumpsOnOff or "未知")..")")
                    ESPLibrary:UpdateObjectColor(v, _G.ColorEsp7 or Color3.fromRGB(79, 91, 255))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp7 or Color3.fromRGB(79, 91, 255))
                end
            end
        end
        lastPumpUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("水泵透视颜色", {
    Default = Color3.fromRGB(79, 91, 255),
    Callback = function(Value)
        _G.ColorEsp7 = Value
    end
})
end

Esp:AddToggle("物品透视", {
    Text = "透视物品",
    Default = false,
    Callback = function(Value)
_G.EspItem = Value
if not _G.EspItem then
	for i, v in pairs(_G.AddedEsp) do
		if v.Name == "Handle" and v.Parent:FindFirstChildOfClass("ProximityPrompt") then
			ESPLibrary:RemoveESP(v.Parent)
		end
	end
end
-- 优化：减少循环频率
local lastItemUpdate = 0
local itemUpdateInterval = 1
while _G.EspItem do
    local currentTime = tick()
    if (currentTime - lastItemUpdate) >= itemUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v.Name == "Handle" and v.Parent:FindFirstChildOfClass("ProximityPrompt") then
                    ESPLibrary:AddESP({
                        Object = v.Parent,
                        Text = v.Parent.Name,
                        Color = _G.ColorEsp9 or Color3.fromRGB(0, 255, 0)
                    })
                    ESPLibrary:UpdateObjectText(v.Parent, v.Parent.Name)
                    ESPLibrary:UpdateObjectColor(v.Parent, _G.ColorEsp9 or Color3.fromRGB(0, 255, 0))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp9 or Color3.fromRGB(0, 255, 0))
                end
            end
        end
        lastItemUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("物品透视颜色", {
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(Value)
        _G.ColorEsp9 = Value
    end
})

Esp:AddToggle("实体透视", {
    Text = "透视实体",
    Default = false,
    Callback = function(Value)
_G.EspEntity = Value
if not _G.EspEntity then
	for i, v in pairs(_G.AddedEsp) do
		for x, z in pairs(_G.EntityTable.Entity) do
			if v:IsA("Model") and v.Name == x then
				ESPLibrary:RemoveESP(v)
			end
		end
	end
end
-- 优化：减少循环频率
local lastEntityUpdate = 0
local entityUpdateInterval = 1
while _G.EspEntity do
    local currentTime = tick()
    if (currentTime - lastEntityUpdate) >= entityUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                for x, z in pairs(_G.EntityTable.Entity) do
                    if v:IsA("Model") and v.Name == x then
                        ESPLibrary:AddESP({
                            Object = v,
                            Text = _G.EntityTable.Entity[v.Name],
                            Color = _G.ColorEsp6 or Color3.fromRGB(230, 14, 25)
                        })
                        ESPLibrary:UpdateObjectText(v, _G.EntityTable.Entity[v.Name])
                        ESPLibrary:UpdateObjectColor(v, _G.ColorEsp6 or Color3.fromRGB(230, 14, 25))
                        ESPLibrary:SetOutlineColor(_G.ColorEsp6 or Color3.fromRGB(230, 14, 25))
                    end
                end
            end
        end
        lastEntityUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("实体透视颜色", {
    Default = Color3.fromRGB(230, 14, 25),
    Callback = function(Value)
        _G.ColorEsp6 = Value
    end
})

Esp:AddToggle("躲藏点透视", {
    Text = "透视躲藏点",
    Default = false,
    Callback = function(Value)
_G.EspHidden = Value
if not _G.EspHidden then
	for i, v in pairs(_G.AddedEsp) do
		if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
			ESPLibrary:RemoveESP(v.Parent)
		end
	end
end
-- 优化：减少循环频率
local lastHiddenUpdate = 0
local hiddenUpdateInterval = 1
while _G.EspHidden do
    local currentTime = tick()
    if (currentTime - lastHiddenUpdate) >= hiddenUpdateInterval then
        if _G.AddedEsp then
            for i, v in pairs(_G.AddedEsp) do
                if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
                    ESPLibrary:AddESP({
                        Object = v.Parent,
                        Text = v.Parent.Name:gsub("Rooms_", ""):gsub("Backdoor_", ""):gsub("Locker_", ""),
                        Color = _G.ColorEsp15 or Color3.fromRGB(52, 67, 235)
                    })
                    ESPLibrary:UpdateObjectText(v.Parent, v.Parent.Name:gsub("Rooms_", ""):gsub("Backdoor_", ""):gsub("Locker_", ""))
                    ESPLibrary:UpdateObjectColor(v.Parent, _G.ColorEsp15 or Color3.fromRGB(52, 67, 235))
                    ESPLibrary:SetOutlineColor(_G.ColorEsp15 or Color3.fromRGB(52, 67, 235))
                end
            end
        end
        lastHiddenUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("躲藏点透视颜色", {
    Default = Color3.fromRGB(52, 67, 235),
    Callback = function(Value)
        _G.ColorEsp15 = Value
    end
})

Esp:AddToggle("玩家透视", {
    Text = "透视玩家",
    Default = false,
    Callback = function(Value)
_G.EspPlayer = Value
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
		ESPLibrary:RemoveESP(v.Character)
	end
end
-- 优化：减少循环频率
local lastPlayerUpdate = 0
local playerUpdateInterval = 1
while _G.EspPlayer do
    local currentTime = tick()
    if (currentTime - lastPlayerUpdate) >= playerUpdateInterval then
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                ESPLibrary:AddESP({
                    Object = v.Character,
                    Text = v.Name,
                    Color = _G.ColorEsp14 or Color3.fromRGB(1, 1, 1)
                })
                ESPLibrary:UpdateObjectText(v.Character, v.Name)
                ESPLibrary:UpdateObjectColor(v.Character, _G.ColorEsp14 or Color3.fromRGB(1, 1, 1))
                ESPLibrary:SetOutlineColor(_G.ColorEsp14 or Color3.fromRGB(1, 1, 1))
            end
        end
        lastPlayerUpdate = currentTime
    end
    task.wait(0.1)
end
    end
}):AddColorPicker("玩家透视颜色", {
    Default = Color3.fromRGB(1, 1, 1),
    Callback = function(Value)
        _G.ColorEsp14 = Value
    end
})

local Esp1 = Tabs.Tab2:AddRightGroupbox("透视设置")

local Font = {}
for _, v in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(Font, v.Name)
end
Esp1:AddDropdown("字体", {
    Text = "设置字体",
    Values = Font,
    Default = "Code",
    Multi = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFont(Value)
end
    end
})

Esp1:AddToggle("显示距离", {
    Text = "显示距离",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetShowDistance(Value)
end
    end
})

Esp1:AddToggle("显示彩虹", {
    Text = "显示彩虹效果",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetRainbow(Value)
end
    end
})

Esp1:AddToggle("显示追踪线", {
    Text = "显示追踪线",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracers(Value)
end
    end
})

Esp1:AddDropdown("追踪线起点", {
    Text = "追踪线起点",
    Multi = false,
    Values = {"底部", "顶部", "中心", "鼠标"},
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracerOrigin(Value)
end
    end
})

Esp1:AddToggle("显示箭头", {
    Text = "显示箭头",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrows(Value)
end
    end
})

Esp1:AddSlider("箭头大小", {
    Text = "设置箭头半径",
    Default = 300,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrowRadius(Value)
end
    end
})

Esp1:AddSlider("设置文本大小", {
    Text = "设置文本大小",
    Default = 15,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTextSize(Value)
end
    end
})

Esp1:AddSlider("设置填充透明度", {
    Text = "设置填充透明度",
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFillTransparency(Value)
end
    end
})

Esp1:AddSlider("设置轮廓透明度", {
    Text = "设置轮廓透明度",
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetOutlineTransparency(Value)
end
    end
})

-----------------------------------
local MenuGroup = Tabs["UI 设置"]:AddLeftGroupbox("菜单")
local Info = Tabs["UI 设置"]:AddRightGroupbox("信息")

MenuGroup:AddDropdown("通知位置", {
    Text = "通知位置",
    Values = {"左侧", "右侧"},
    Default = "右侧",
    Multi = false,
    Callback = function(Value)
Library.NotifySide = Value
    end
})

_G.ChooseNotify = "Door"
MenuGroup:AddDropdown("通知选择", {
    Text = "通知选择",
    Values = {"Obsidian", "Roblox", "Door"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ChooseNotify = Value
    end
})

MenuGroup:AddSlider("通知音量", {
    Text = "通知音量",
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.VolumeTime = Value
    end
})

MenuGroup:AddToggle("键位绑定菜单", {Default = false, Text = "打开键位绑定菜单", Callback = function(Value) Library.KeybindFrame.Visible = Value end})
MenuGroup:AddToggle("显示自定义光标", {Text = "自定义光标", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddToggle("水印", {Text = "显示水印", Default = true, Callback = function(Value) Library:SetWatermarkVisibility(Value) end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("菜单绑定"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "菜单绑定"})
_G.LinkJoin = loadstring(game:HttpGet("https://pastefy.app/2LKQlhQM/raw"))()
MenuGroup:AddButton("复制 Discord 链接", function()
    if setclipboard then
        setclipboard(_G.LinkJoin["Discord"])
        Library:Notify("已复制 Discord 链接到剪贴板！")
    else
        Library:Notify("Discord 链接: ".._G.LinkJoin["Discord"], 10)
    end
end):AddButton("复制 Zalo 链接", function()
    if setclipboard then
        setclipboard(_G.LinkJoin["Zalo"])
        Library:Notify("已复制 Zalo 链接到剪贴板！")
    else
        Library:Notify("Zalo 链接: ".._G.LinkJoin["Zalo"], 10)
    end
end)
MenuGroup:AddButton("卸载", function()
Library:Unload() 
ESPLibrary:Unload()
end)

Info:AddLabel("国家/地区 [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true)
Info:AddLabel("执行器 [ "..identifyexecutor().." ]", true)
Info:AddLabel("手机/电脑 [ "..(MobileOn and "手机" or "电脑").." ]", true)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI 设置"])
ThemeManager:ApplyToTab(Tabs["UI 设置"])
SaveManager:LoadAutoloadConfig()

----- 脚本 -------

_G.AddedGet = {}
_G.AddedEsp = {}

-- 优化：添加防抖处理
local lastAddedProcess = 0
local addedCooldown = 0.05

local function Added(v)
    local currentTime = tick()
    if (currentTime - lastAddedProcess) < addedCooldown then
        return
    end
    lastAddedProcess = currentTime
    
	if v.Name == "Snare" then
        if v:FindFirstChild("Hitbox") then
	        if Toggles["防陷阱"].Value then
		        v.Hitbox:Destroy()
			end
        end
    end
	if v.Name == "Egg" then
		v.CanTouch = not Toggles["防蛋 gloom"].Value
	end
	task.spawn(function()
		if v:IsA("Model") and v.Name == "GiggleCeiling" then
			repeat task.wait() until v:FindFirstChild("Hitbox")
			wait(0.1)
			if Toggles["防咯咯笑"].Value and v:FindFirstChild("Hitbox") then
				v.Hitbox:Destroy()
			end
		end
	end)
	task.spawn(function()
		if v.Name == "_DamHandler" then
			repeat task.wait() until v:FindFirstChild("SeekFloodline")
			wait(0.1)
			if v:FindFirstChild("SeekFloodline") then
				v.SeekFloodline.CanCollide = Toggles["防追逐洪水"].Value
			end
		end
	end)
	if v.Name == "PlayerBarrier" and v.Size.Y == 2.75 and (v.Rotation.X == 0 or v.Rotation.X == 180) then
		if Toggles["防坠落屏障"].Value then
			local CLONEBARRIER = v:Clone()
			CLONEBARRIER.CFrame = CLONEBARRIER.CFrame * CFrame.new(0, 0, -5)
			CLONEBARRIER.Color = Color3.new(1, 1, 1)
			CLONEBARRIER.Name = "CLONEBARRIER_ANTI"
			CLONEBARRIER.Size = Vector3.new(CLONEBARRIER.Size.X, CLONEBARRIER.Size.Y, 11)
			CLONEBARRIER.Transparency = 0
			CLONEBARRIER.Parent = v.Parent
		end
	end
	if v.Name == "ChandelierObstruction" or v.Name == "Seek_Arm" then
        for b, h in pairs(v:GetDescendants()) do
            if h:IsA("BasePart") then 
				h.CanTouch = not Toggles["防追逐障碍"].Value
			end
        end
    end
    if v.Name == "DoorFake" then
		local CollisionFake = v:FindFirstChild("Hidden", true)
		local Prompt = v:FindFirstChild("UnlockPrompt", true)
		if CollisionFake then
			CollisionFake.CanTouch = not Toggles["防假门"].Value
		end
		if Prompt and Toggles["防假门"].Value then
			Prompt:Destroy()
		end
	end
	--------- 添加提示 -----------
	if not table.find(_G.AddedGet, v) then
		if v:IsA("Model") and v.Name == "MinesAnchor" then
			table.insert(_G.AddedGet, v)
		end
		if v:IsA("ProximityPrompt") and table.find(_G.Aura["AuraPrompt"], v.Name) then
		    table.insert(_G.AddedGet, v)
		end
		if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
	        table.insert(_G.AddedGet, v.Parent)
	    end
	end
	--------- 添加透视 -----------
	if not table.find(_G.AddedEsp, v) then
		if ((v.Name:find("Key") or v.Name:find("FuseObtain")) and v:FindFirstChild("Hitbox")) or (v.Name == "LeverForGate" and v.PrimaryPart) then
	        table.insert(_G.AddedEsp, v)
		end
		if (v.Name == "VineGuillotine" or v.Name == "MinesGenerator" or v.Name == "MinesAnchor" or v.Name == "WaterPump" or v.Name:find("TimerLever") or v.Name == "LiveBreakerPolePickup" or v.Name:find("LiveHintBook")) or (v:GetAttribute("Storage") == "ChestBox" or v.Name == "Toolshed_Small") then
			table.insert(_G.AddedEsp, v)
		end
		if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
			table.insert(_G.AddedEsp, v)
		end
		if v.Name == "Handle" then
			table.insert(_G.AddedEsp, v)
		end
		for x, z in pairs(_G.EntityTable.Entity) do
			if v:IsA("Model") and v.Name == x then
				if v.Name == "Snare" and v.Parent and v.Parent:IsA("Model") and v.Parent.Name == "Snare" then return end			
				table.insert(_G.AddedEsp, v)
			end
		end
    end
end

-- 优化：分批处理现有后代，避免一次性处理过多导致卡顿
local function ProcessExistingDescendants()
    local descendants = workspace:GetDescendants()
    local batchSize = 50 -- 每批处理50个对象
    local totalBatches = math.ceil(#descendants / batchSize)
    
    for batch = 1, totalBatches do
        local startIndex = (batch - 1) * batchSize + 1
        local endIndex = math.min(batch * batchSize, #descendants)
        
        for i = startIndex, endIndex do
            Added(descendants[i])
        end
        
        if batch < totalBatches then
            wait(0.05) -- 批次间等待，避免卡顿
        end
    end
end

-- 使用分批处理替代直接循环
ProcessExistingDescendants()

-- 优化：添加防抖的连接
local lastDescendantAdded = 0
local descendantCooldown = 0.05
workspace.DescendantAdded:Connect(function(v)
    local currentTime = tick()
    if (currentTime - lastDescendantAdded) >= descendantCooldown then
        Added(v)
        lastDescendantAdded = currentTime
    end
end)

workspace.DescendantRemoving:Connect(function(v)
    for i = #_G.AddedGet, 1, -1 do
        if _G.AddedGet[i] == v then
            table.remove(_G.AddedGet, i)
            break
        end
    end
end)

workspace.DescendantRemoving:Connect(function(v)
    for i = #_G.AddedEsp, 1, -1 do
        if _G.AddedEsp[i] == v then
            table.remove(_G.AddedEsp, i)
            break
        end
    end
end)