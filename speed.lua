-- Doors_complete_merged.lua
-- 完整合并 + 优化前导（自动生成）

-- === OPTIMIZER / 管理器 ===
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not _G.__DOORS_MERGED_CONNECTIONS then
    _G.__DOORS_MERGED_CONNECTIONS = {}
end

local function trackConnection(conn)
    if not conn then return conn end
    table.insert(_G.__DOORS_MERGED_CONNECTIONS, conn)
    return conn
end

local function cleanupAllConnections()
    for _, c in ipairs(_G.__DOORS_MERGED_CONNECTIONS) do
        pcall(function() c:Disconnect() end)
    end
    _G.__DOORS_MERGED_CONNECTIONS = {}
end

if _G.__DOORS_MERGED_THROTTLE == nil then
    _G.__DOORS_MERGED_THROTTLE = 0.12
end

local _last_throttle = 0
local function throttle()
    local t = tick()
    if t - _last_throttle < _G.__DOORS_MERGED_THROTTLE then return false end
    _last_throttle = t
    return true
end

local function safeConnect(signal, func)
    local ok, conn = pcall(function() return signal:Connect(func) end)
    if ok and conn then
        return trackConnection(conn)
    end
    return nil
end

local function firePrompt(prompt)
    if not prompt then return end
    if typeof(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
        return
    end
    pcall(function()
        prompt:InputHoldBegin()
        task.wait(math.max(0.05, prompt.HoldDuration or 0.6))
        prompt:InputHoldEnd(prompt.HoldDuration or 0.6)
    end)
end

safeConnect(game:GetService("UserInputService").InputBegan, function(inp, gameProcessed)
    if gameProcessed then return end
    if inp.KeyCode == Enum.KeyCode.U then
        cleanupAllConnections()
        pcall(function()
            if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
                local g = LocalPlayer.PlayerGui:FindFirstChild("DoorsMergedUI")
                if g then g:Destroy() end
            end
        end)
        print("[Doors_complete_merged] Unloaded (U pressed)")
    end
end)

_G.DoorsMerged = _G.DoorsMerged or {}
_G.DoorsMerged.safeConnect = safeConnect
_G.DoorsMerged.trackConnection = trackConnection
_G.DoorsMerged.cleanupAllConnections = cleanupAllConnections
_G.DoorsMerged.throttle = throttle
_G.DoorsMerged.firePrompt = firePrompt

-- END OF OPTIMIZER

-- === BEGIN ORIGINAL SCRIPT (unchanged) ===

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local notifysound = 4590657391
local PlayingSound = true

function Sound()
local sound = Instance.new("Sound",SoundService)
sound.Volume = 2.5
sound.SoundId = "rbxassetid://" .. notifysound 
sound.Playing = PlayingSound and true or false
Debris:AddItem(sound,2)
end
Sound()

function WaitForChildOfClass(Parent , Part)
local Clas = Parent:FindFirstChildOfClass(Part)
while Clas == nil do
task.wait()
Clas = Parent.DescendantAdded:Wait()
if Clas:IsA(Part) then
return Clas
end
end
return Clas
end

if LocalPlayer:GetAttribute("mshaxLoaded") then 
print("mshax already loaded")
return end

if game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") or game.ReplicatedStorage:FindFirstChild("EntityInfo") or game.ReplicatedStorage:FindFirstChild("Bricks") then

repeat task.wait() until workspace.CurrentRooms:FindFirstChildOfClass("Model")

local Disable1 = false
local Disable2 = false
local Disable3 = false
local Disable4 = false
local Disable5 = false
local FakeSurge
local alive 
local Pathnode 

local repo = 'https://raw.githubusercontent.com/mstudio45/Obsidian/main/'
local Executor = identifyexecutor()  or getexecutorname() or "Unknown"
local Library =  loadstring(game:HttpGet(repo..'Library.lua'))()

Library:Notify("正在加载 StarLight for DOORS",5)

if Executor == "Xeno" or Executor == "xeno" then Library:Notify("不支持的执行器",3) return end

local success, result = pcall(function()
return RequiredMainGame
end)
if not success then
Library:Notify("Require不支持 部分功能将被禁用",3)
Disable1 = true
print("false require")
end

print("true require")
 
if not isnetworkowner then
Library:Notify("isnetworkowner 不支持 部分功能将被禁用",3)
Disable2 = true
print("false isnetworkowner")
end

print("true isnetworkowner")
local Prompt = Instance.new("ProximityPrompt",workspace)
Prompt.Name = "TestPrompt"

local success, result = pcall(function()
return fireproximityprompt(Prompt)
end)
if not success then
Prompt:Destroy()
Library:Notify("fireproximityprompt 不支持 方法将改变 仍然工作但不太可靠",4)
Disable3 = true
print("false fireproximityprompt")
end

print("true fireproximityprompt")
Prompt:Destroy()

if not replicatesignal then
Disable4 = true
Library:Notify("replicatesignal 不支持 方法将改变 仍然工作但不太可靠",3)
print("false replicatesignal")
end
print("true replicatesignal")

if not hookmetamethod or not newcclosure then
Library:Notify("Hooking不支持 部分功能将被禁用",3)
print("false hookmetamethod")
Disable5 = true
end
print("true hookmetamethod")

ThemeManager = loadstring(game:HttpGet(repo..'addons/ThemeManager.lua'))()
SaveManager  = loadstring(game:HttpGet(repo..'addons/SaveManager.lua'))()
Options = Library.Options
Toggles = Library.Toggles
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/ESPLibrary"))()

local raycastParms = RaycastParams.new()

function GetNearestCloset()
local closest = nil
local MaxDistance = math.huge
local assets = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]
if assets then
for _, v in ipairs(assets:FindFirstChild("Assets",true):GetChildren()) do
if v.Name == "Wardrobe" or v.Name == "Rooms_Locker" or v.Name == "Rooms_Locker_Fridge" or v.Name == "Toolshed" or v.Name == "Locker_Large" or v.Name == "Backdoor_Wardrobe" or v.Name == "Bed" or v.Name == "Double_Bed" then
if v.PrimaryPart then
local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude
if Distance < MaxDistance then
closest = v
MaxDistance = Distance 
end
end
end
end
end
return closest
end

function GetNearestLocker()
local closest = nil
local MaxDistance = math.huge
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Rooms_Locker" or v.Name == "Rooms_Locker_Fridge" then
if v.PrimaryPart then
local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude
if Distance < MaxDistance then
closest = v
MaxDistance = Distance 
end
end
end
end
return closest
end

function fireInteract(prompt)
if Disable3 == true then
prompt:InputHoldBegin()
prompt:InputHoldEnd(prompt.HoldDuration)
elseif Disable3 == false then
fireproximityprompt(prompt)
end
end

local Finish = nil
Finish = game:GetService("ProximityPromptService").PromptTriggered:Connect(function(v)
if Library.Unloaded == true then
Finish:Disconnect()
Finish = nil
end
if v.Name == "FakePrompt" then
if game.Players.LocalPlayer.Character:FindFirstChild("Lockpick") or game.Players.LocalPlayer.Character:FindFirstChild("SkeletonKey") then
local animator = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):WaitForChild("Animations",9e9).usefinish)
animator:Play()
elseif game.Players.LocalPlayer.Character:FindFirstChild("Shears") then
local animator = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):WaitForChild("Animations",9e9).promptanimend)
animator:Play()
game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):WaitForChild("Handle").sound_promptend:Play()
end
end
end)

local Hold = nil
Hold = game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(v)
if Library.Unloaded == true then
Hold:Disconnect()
Hold = nil
end
if v.Name == "FakePrompt" then
if game.Players.LocalPlayer.Character:FindFirstChild("Lockpick") or game.Players.LocalPlayer.Character:FindFirstChild("SkeletonKey") then
local animator = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):WaitForChild("Animations").use)
animator:Play()
elseif game.Players.LocalPlayer.Character:FindFirstChild("Shears") then
local animator = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):WaitForChild("Animations",9e9).promptanim)
animator:Play()
game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):WaitForChild("Handle").sound_prompt:Play()
end
end
end)

LocalPlayer:SetAttribute("mshaxLoaded",true)

Floor = ReplicatedStorage.GameData.Floor
RemoteFolder = ReplicatedStorage:FindFirstChild("EntityInfo") or ReplicatedStorage:FindFirstChild("RemotesFolder") or ReplicatedStorage:FindFirstChild("Bricks")
MainGame = LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game
RequiredMainGame = require(LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
RemoteListener = MainGame.RemoteListener
Modules = RemoteListener.Modules

ClientModules = game:GetService("ReplicatedStorage"):FindFirstChild("ModulesClient") or game:GetService("ReplicatedStorage"):FindFirstChild("ClientModules") 
if ReplicatedStorage:FindFirstChild("RemotesFolder") then 
Modifiers = ReplicatedStorage:WaitForChild("LiveModifiers")
end
local PlayerGui  = LocalPlayer.PlayerGui 
Fog = Lighting:FindFirstChild("Fog") or Lighting:FindFirstChild("CaveAtmosphere")
CollisionClone = nil
CollisionClone2 = nil

Pathnode = Instance.new("Folder",workspace)
Pathnode.Name = "Path Node"

local JumpConnection 
local CleanUp
local Character = nil

if LocalPlayer.Character then
raycastParms.FilterDescendantsInstances = {LocalPlayer.Character}
raycastParms.FilterType = Enum.RaycastFilterType.Blacklist

if LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
JumpConnection = LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click:Connect(function()
if Toggles and Toggles.InfiniteJump and Toggles.InfiniteJump.Value then
if Character then
Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)
end

Character = LocalPlayer.Character
if Character.Collision:FindFirstChild("CollisionCrouch") then
Character.Collision.CollisionCrouch.Size = Vector3.new(0.5, 0.001, 3)
end
if ReplicatedStorage:FindFirstChild("RemotesFolder") then
CollisionClone = Character.CollisionPart:Clone()
CollisionClone.Parent = Character
CollisionClone.Massless = true
CollisionClone.CanCollide = false
CollisionClone.Name = "_CollisionPart"
if CollisionClone:FindFirstChild("CollisionCrouch") then
CollisionClone.CollisionCrouch:Destroy()
end

CollisionClone2 = Character.CollisionPart:Clone()
CollisionClone2.Parent = Character
CollisionClone2.Massless = true
CollisionClone2.CanCollide = false
CollisionClone2.Name = "_CollisionPart2"
if CollisionClone2:FindFirstChild("CollisionCrouch") then
CollisionClone2.CollisionCrouch:Destroy()
end
end
end

local NewCharacter = LocalPlayer.CharacterAdded:Connect(function()
task.wait(1.5)
if CrouchConnection then
CrouchConnection:Disconnect()
CrouchConnection = nil
end
if JumpConnection then
JumpConnection:Disconnect()
JumpConnection = nil
end

raycastParms.FilterDescendantsInstances = {LocalPlayer.Character}
raycastParms.FilterType = Enum.RaycastFilterType.Blacklist

if LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons:FindFirstChild("JumpButton") then
JumpConnection = LocalPlayer.PlayerGui.MainUI.MainFrame.MobileButtons.JumpButton.MouseButton1Click:Connect(function()
if Toggles.InfiniteJump.Value then
if Character then
Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)
end

MainGame = LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game
RequiredMainGame = require(LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
RemoteListener = MainGame.RemoteListener
Modules = RemoteListener.Modules

Character = LocalPlayer.Character

if Character.Collision:FindFirstChild("CollisionCrouch") then
Character.Collision.CollisionCrouch.Size = Vector3.new(0.5, 0.001, 3)
end

if ReplicatedStorage:FindFirstChild("RemotesFolder") then
CollisionClone = Character.CollisionPart:Clone()
CollisionClone.Parent = Character
CollisionClone.Massless = true
CollisionClone.CanCollide = false
CollisionClone.Name = "_CollisionPart"
CollisionClone2 = Character.CollisionPart:Clone()
CollisionClone2.Parent = Character
CollisionClone2.Massless = true
CollisionClone2.CanCollide = false
CollisionClone2.Name = "_CollisionPart2"
if CollisionClone2:FindFirstChild("CollisionCrouch") then
CollisionClone2.CollisionCrouch:Destroy()
end
end
end)
local LatestRoom = ReplicatedStorage.GameData.LatestRoom.Value

local Connections = {}

Window = Library:CreateWindow({
    Title = 'StarLight | DOORS ',
    Center = true,
    AutoShow = true
})

Tabs = {
	Main     = Window:AddTab('主功能'),
    Player     = Window:AddTab('玩家'),
	Exploits       = Window:AddTab('漏洞'),
	Floor     = Window:AddTab('楼层'),
	UISettings = Window:AddTab('配置'),
Addons = Window:AddTab('插件'),
}

AddonBox = Tabs.Addons:AddLeftGroupbox('插件')
local TabBox2 = Tabs.Main:AddLeftTabbox() 

local MiscBox = TabBox2:AddTab("杂项")
local NotifyBox = TabBox2:AddTab("通知/ESP")

local TabBox = Tabs.Player:AddLeftTabbox() 

local Movement = TabBox:AddTab("移动")
local Camera = TabBox:AddTab("相机")

local TabBox3 = Tabs.Exploits:AddLeftTabbox() 

local Anti = TabBox3:AddTab("实体")
local  Bypass = TabBox3:AddTab("绕过")

Automation = Tabs.Exploits:AddRightGroupbox('自动化')
InfiniteBox = Tabs.Player:AddRightGroupbox('无限物品')

local ReachBox = Tabs.Main:AddRightGroupbox('范围')

FloorAnti = Tabs.Floor:AddLeftGroupbox('实体绕过')

ModifiersBox = Tabs.Floor:AddLeftGroupbox('修改器')

FloorESP = Tabs.Floor:AddRightGroupbox('ESP')

ESPBox = Tabs.Main:AddRightGroupbox('ESP')
SettingsESP = Tabs.Main:AddRightGroupbox('ESP设置')
ClosetTran = Tabs.Main:AddRightGroupbox('透明化')

SettingsBox = Tabs.UISettings:AddRightGroupbox('UI')

if Floor.Value == "Rooms" then
function addpart(position)
local Part = Instance.new("Part",workspace:FindFirstChild("Path Node"))
Part.Name = "Waypoint"
Part.Size = Vector3.new(0.3, 0.3, 0.3)
Part.Position = position
Part.Anchored = true
Part.CanCollide = false
Part.Color = Color3.new(0, 1, 0)
end

function moveto(target)
local path = PathfindingService:CreatePath({
AgentRadius = 2,
AgentHeight = 0.1,
AgentCanClimb = true,
AgentCanJump = true,
WaypointSpacing = 4.5
})

path:ComputeAsync(LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
if path.Status == Enum.PathStatus.Success  then
for _, waypoint in ipairs(path:GetWaypoints()) do
LocalPlayer.Character.Humanoid:MoveTo(waypoint.Position)
LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
end
end
end

function moveto(target)
local activepath = PathfindingService:CreatePath({
AgentRadius = 2,
AgentHeight = 0.1,
AgentCanClimb = false,
AgentCanJump = false,
WaypointSpacing = 5 
})

activepath:ComputeAsync(LocalPlayer.Character.HumanoidRootPart.Position, target.Position)
if activepath.Status == Enum.PathStatus.Success  then
for _, waypoint in ipairs(activepath:GetWaypoints()) do
LocalPlayer.Character.Humanoid:MoveTo(waypoint.Position)
LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
end
end
end

FloorAnti:AddToggle('AutoRooms',{
Text = "自动房间",
Default = false
})
FloorAnti:AddLabel('推荐速度 45-40 , 无穿墙',true)

Toggles.AutoRooms:OnChanged(function(Value)
if not Value then
LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
end
end)
FloorAnti:AddDivider()
end

if Floor.Value == "Hotel" and ReplicatedStorage:FindFirstChild("RemotesFolder") then
Objects = {
DoorNormal = true,
DoorFrame = true,
Luggage_Cart_Crouch = true,
Carpet = true,
CarpetLight = true,
Luggage_Cart = true,
DropCeiling = true,
End_DoorFrame = true,
Start_DoorFrame = true,
TriggerEventCollision = true,
StairCollision = true
}
 
FloorAnti:AddToggle('AutoDoors',{
Text = "自动门 (99门)",
Default = false,
Risky = true
})

function canhit(part)
if part:IsA("BasePart") then
part.CanCollide = false
elseif part:IsA("Model") then
for _, v in pairs(part:GetChildren()) do
if v:IsA("BasePart") then
v.CanCollide = false
end
end
end
end

Toggles.AutoDoors:OnChanged(function(Value)
if Value then
if not Toggles.AntiHear.Value then
Toggles.AntiHear:SetValue(true)
end

if not Toggles.NoCutscenes.Value then
Toggles.NoCutscenes:SetValue(true)
end

Library:Notify("启用自动互动 / 自动图书馆代码 / 自动化上帝模式以使自动门正常工作",5)
for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
if Objects[v.Name] then 
canhit(v)
end

if v.Name == "LiveObstructionNew" or v.Name == "LiveObstructionNewIntro" then
canhit(
v:WaitForChild("Collision")
)
end

if not v:IsA("Part") and v.Name == "SeeThroughGlass" then
canhit(
v
)
end
if v.Name == "Collision" and v.Parent and v.Parent.Name == "Parts" then
v.CanCollide = false 
end

if v.Name == "DoorLattice" then
canhit(v:WaitForChild("Door",9e9))
end
end
end
end)

function moveTo(part)
local pos = part.Position + part.CFrame.LookVector * -2
local path = PathfindingService:CreatePath({
AgentRadius = 0.2,
AgentHeight = 0.1,
AgentCanJump = true,
AgentCanClimb = true,
WaypointSpacing = 3 
})

path:ComputeAsync(LocalPlayer.Character.HumanoidRootPart.Position, pos)

if path.Status == Enum.PathStatus.Success then
for _, waypoint in pairs(path:GetWaypoints()) do
LocalPlayer.Character.Humanoid:MoveTo(waypoint.Position)
LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
end
end
end

local ContinueDoor = true

table.insert(Connections,RunService.Heartbeat:Connect(function()
if Toggles.AutoDoors.Value then
if not alive then return end

if ReplicatedStorage.GameData.LatestRoom.Value < 99 then
local Key = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("KeyObtain", true)
local Gate = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("LeverForGate", true)
local Book = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("LiveHintBook", true)
local Paper = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("LibraryHintPaper", true)
local Door = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door

if  Door.CanCollide then
Door.CanCollide = false
end
if not Key  or LocalPlayer.Character:FindFirstChild("Key") then  
if ContinueDoor then
moveTo(Door)
end
elseif Key and not LocalPlayer.Character:FindFirstChild("Key") then
moveTo(Key.PrimaryPart)
end

if Gate then
local Pris = Gate:FindFirstChild("LeverConstraint")
if Pris then
if Pris.TargetPosition == -1 then
moveTo(Gate:GetPivot())
end
end
end

if ReplicatedStorage.GameData.LatestRoom.Value == 50 then
if Book then
ContinueDoor = false 
moveTo(Book.PrimaryPart)
elseif not Book  then
if not LocalPlayer.Character:FindFirstChild("LibraryHintPaper") or not LocalPlayer.Character:FindFirstChild("LibraryHintPaperHard") or not LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper") or not LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")  then 
if Paper then
moveTo(Paper.PrimaryPart)
end
end
end

if LocalPlayer.Character:FindFirstChild("LibraryHintPaper") or LocalPlayer.Character:FindFirstChild("LibraryHintPaperHard") or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper") or  LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard")  then 
ContinueDoor = true
local LibraryPaper = LocalPlayer.Character:FindFirstChild("LibraryHintPaper") or LocalPlayer.Character:FindFirstChild("LibraryHintPaperHard") or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaperHard") or LocalPlayer.Backpack:FindFirstChild("LibraryHintPaper")

if LibraryPaper then
if (LocalPlayer.Character.CollisionPart.Position - workspace:FindFirstChild("Padlock", true):GetPivot().Position).Magnitude < 45 then 
LibraryPaper.Parent = LocalPlayer.Character 
elseif (LocalPlayer.Character.CollisionPart.Position - workspace:FindFirstChild("Padlock", true):GetPivot().Position).Magnitude > 45 then
LibraryPaper.Parent = LocalPlayer.Backpack
end
end
end
end
end
end
end))
end

ModifiersBox:AddButton({
Text = "死亡农场",
Func = function()
if not replicatesignal or not queue_on_teleport then
Library:Notify("您的执行器不支持replicatesignal或queue_on_teleport，这会破坏功能",3)
return 
end

if queue_on_teleport then
Library:Notify("现在开始 请等待",2)
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Op-Ninja-Simulator-/Main/M1reset"))()
queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Op-Ninja-Simulator-/Main/M1reset"))()')
end
end
})

if ReplicatedStorage:FindFirstChild("EntityInfo") or ReplicatedStorage:FindFirstChild("Bricks") then
FloorAnti:AddToggle('AntiBanana',{
Text = "反香蕉",
Default = false,
Callback = function(Value)
for _, v in ipairs(workspace:GetChildren()) do
if v.Name == "BananaPeel" then
v.CanTouch =  not Value
end
end
end
})
FloorAnti:AddToggle('AntiJeff',{
Text = "反杰夫",
Default = false,
Callback = function(Value)
for _, v in ipairs(workspace:GetChildren()) do
if v.Name == "JeffTheKiller" then
for _, part in ipairs(v:GetChildren()) do
if part:IsA("BasePart") then
part.CanTouch = not Value
end
end
end
end
end
})

workspace.ChildAdded:Connect(function(v)
if v.Name == "BananaPeel" then
v.CanTouch =  not Toggles.AntiBanana.Value 
end
if v.Name == "JeffTheKiller" then
v.ChildAdded:Connect(function()
for _, part in v:GetChildren() do
if part:IsA("BasePart") then
part.CanTouch = not Toggles.AntiJeff.Value 
end
end
end)
for _, part in v:GetChildren() do
if part:IsA("BasePart") then
part.CanTouch = not Toggles.AntiJeff.Value 
end
end
end
end)

if ReplicatedStorage:FindFirstChild("EntityInfo") then 
FloorAnti:AddToggle('DeleteFigureFools',{
Text = "删除Figure (FE)",
Default = false,
Disabled = Disable2
})
end

if ReplicatedStorage:FindFirstChild("Bricks") or ReplicatedStorage:FindFirstChild("EntityInfo") then
FloorAnti:AddToggle('Godmode',{
Text = "上帝模式",
Default = false,
Callback = function(Value)
if Value then
if not Toggles.Noclip.Value then
Toggles.Noclip:SetValue(true)
end
LocalPlayer.Character.Collision.Position = LocalPlayer.Character.Collision.Position - Vector3.new(0, 11, )
else
LocalPlayer.Character.Collision.Position = LocalPlayer.Character.Collision.Position + Vector3.new(0, 11, 0)
end
end
})

FloorAnti:AddToggle('FigureGodmode',{
Text = "Figure上帝模式",
Default = false,
Callback = function(Value)
end
})
end

FloorAnti:AddToggle('DeleteSeek',{
Text = "删除Seek (FE)",
Default = false
})
task.spawn(function()
while task.wait(0.09) do
if Toggles.DeleteSeek.Value then
local SeekCollision = workspace:FindFirstChild("TriggerEventCollision",true)
local Trigger = workspace:FindFirstChild("TriggerSeek",true)

if Trigger then
Trigger:Destroy()
end
if SeekCollision then
SeekCollision:ClearAllChildren()
end
end
end
end)
end

ModifiersBox:AddDivider()

SettingsBox:AddToggle('FpsUnlocker',{
     Text = "FPS解锁",
     Default = true,
Callback = function(Value)
setfpscap(Value and 9999999 or 60)
end
})

local DropTable = {
RushMoving = 54,
AmbushMoving = 67,
A60 = 70
}

InfiniteBox:AddToggle('InfiniteCrucifix', {
	Text = "无限十字架",
	Default = false,
    Risky = true,
    Tooltip = "有风险 您可能会死亡或丢失十字架 推荐低ping和稳定fps"
})

InfiniteBox:AddDivider()

local InfiniteCrucifixConnection

InfiniteCrucifixConnection = RunService.RenderStepped:Connect(function()
if Toggles.InfiniteCrucifix.Value then
for _, v in ipairs(workspace:GetChildren()) do
local Entity = DropTable[v.Name]
if Entity and v.PrimaryPart then
v.PrimaryPart.CanCollide = true
v.PrimaryPart.CanQuery = true
local origin2  = LocalPlayer.Character.CollisionPart.Position
local direction2 = (v.PrimaryPart.Position - origin2)
local result2 = workspace:Raycast(origin2, direction2, raycastParms)

if result2 and result2.Instance:IsDescendantOf(v) then
if (LocalPlayer.Character.CollisionPart.Position - v.PrimaryPart.Position).Magnitude < Entity then
ReplicatedStorage.RemotesFolder.DropItem:FireServer(LocalPlayer.Character:FindFirstChildOfClass("Tool"))
task.wait(0.54)
if Workspace:FindFirstChild("Drops") and Workspace.Drops:FindFirstChild("Crucifix") then
fireproximityprompt(workspace.Drops:WaitForChild("Crucifix"):FindFirstChildOfClass("ProximityPrompt"))
end
end
end 
end
end
end
end)

SettingsBox:AddToggle('PlaySound',{
     Text = "播放声音",
     Default = true,
Callback = function(Value)
PlayingSound = Value
end
})

Library.NotifySide = Library.IsMobile == true and "Right" or "Left"
SettingsBox:AddDropdown("LibraryNotifySide", {
        Values = { "Right","Left"},
        Default = Library.NotifySide,
        Multi = false,
        Text = "通知侧边",
        Callback = function(Value)
               Library.NotifySide = Value
        end,
})

local OptionNotify = "Obsidian"
function Notify(txt,desc,reason)
if OptionNotify then 
Library:Notify(txt,3)
 elseif OptionNotify == "Doors" then
local Achievement = game:GetService("Players").LocalPlayer.PlayerGui.MainUI.AchievementsHolder.Achievement:Clone()
Achievement.Size = UDim2.new(0, 0, 0, 0)
Achievement.Visible = true
Achievement:WaitForChild("Sound",9e9):Play()
Achievement:WaitForChild("Frame"):WaitForChild("Details").Title.Text = txt
Achievement:WaitForChild("Frame"):WaitForChild("Details").Reason.Text = reason
Achievement:WaitForChild("Frame"):WaitForChild("Details").Desc.Text = desc

game:GetService("TweenService"):Create(Achievement,TweenInfo.new(1.5),{Size = UDim2.new(1, 0, 0, 0)}):Play()
task.wait(1)
Achievement:Destroy()
end
end

MiscBox:AddToggle('InstantPrompt',{
     Text = "即时互动",
     Default = false,
    Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v:SetAttribute("Hold",v.HoldDuration)
v.HoldDuration = 0
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.HoldDuration = v:GetAttribute("Hold") or 0.7
end
end
end
end
})

MiscBox:AddToggle('PromptClip',{
     Text = "提示穿透",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.RequiresLineOfSight = false
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.RequiresLineOfSight = true
end
end
end
end
})

MiscBox:AddToggle('AntiAfk',{
     Text = "禁用AFK",
     Default = false
})
table.insert(Connections,LocalPlayer.Idled:Connect(function()
if Toggles.AntiAfk.Value then
VirtualUser:CaptureController()
VirtualUser:ClickButton2(Vector2.new())
end
end))

MiscBox:AddToggle('AntiLag',{
     Text = "反延迟",
     Default = false,
    Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("BasePart") then
v.Material = Enum.Material.Plastic
end
if v.Name == "LightFixture" or v.Name == "Carpet" or v.Name == "CarpetLight" then
v:Destroy()
end
end
end
end
})

ReachBox:AddToggle('PromptReach',{
     Text = "提示范围",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v:SetAttribute("Distance",v.MaxActivationDistance)
v.MaxActivationDistance = v.MaxActivationDistance * 2
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:IsA("ProximityPrompt") then
v.MaxActivationDistance = v:GetAttribute("Distance") or 7
end
end
end
end
})
local Range = 20
ReachBox:AddToggle('DoorReach',{
     Text = "门范围",
     Default = false
})
ReachBox:AddSlider("DoorReachRange", {
        Text = "门范围距离",
        Default = 20,
        Min = 15,
        Max = 30,
        Rounding = 1,
        Compact = true,
        Callback = function(Value)
          Range = Value
     end,      
})

MiscBox:AddToggle('NoCutscenes',{
     Text = "无过场动画",
     Default = false
})

local TransparencyValue = 0.5
ClosetTran:AddSlider("TransparencySlider", {
        Text = "透明度滑块",
        Default = 0.5,
        Min = 0.1,
        Max = 1,
        Rounding = 1,
        Compact = true,
        Callback = function(Value)
        TransparencyValue   = Value
     end,      
})

ClosetTran:AddToggle('TransparencyCloset',{
Text = "衣柜透明",
Default = false
})
ClosetTran:AddDivider()
local CartTransparencyValue = 0.5
ClosetTran:AddSlider("CartTransparencySlider", {
        Text = "透明度滑块",
        Default = 0.5,
        Min = 0.1,
        Max = 1,
        Rounding = 1,
        Compact = true,
        Callback = function(Value)
        CartTransparencyValue   = Value
     end,      
})

ClosetTran:AddToggle('TransparencyCart',{
Text = "矿车透明",
Default = false
})

Camera:AddToggle('Fullbright',{
     Text = "全亮",
     Default = false,
Callback = function(Value)
if Value then
else
game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
end
end
})
Camera:AddToggle('NoCameraShake',{
     Text = "无相机抖动",
     Default = false,
Disabled = Disable1
})

local Y = 0
local Z = 6
local X = 2

Camera:AddDivider()

Camera:AddToggle('ThirdPerson',{
     Text = "第三人称",
     Default = false
}):AddKeyPicker('ThirdPKeybind', {
		Default = 'T',
		SyncToggleState = true,
		Mode = 'Toggle',
		Text = '第三人称',
		NoUI = false,
		Callback = function(Value)
		end,
		ChangedCallback = function(New)
		end
	})

Camera:AddSlider("X", {
        Text = "X",
        Default = X,
        Min = -10,
        Max = 10,
        Rounding = 0,
        Compact = true,
        Callback = function(Value)
          X = Value
     end,      
})
Camera:AddSlider("Y", {
        Text = "Y",
        Default = Y,
        Min = -10,
        Max = 10,
        Rounding = 0,
        Compact = true,
        Callback = function(Value)
          Y = Value
     end,      
})
Camera:AddSlider("Z", {
        Text = "Z",
        Default = Z,
        Min = -10,
        Max = 10,
        Rounding = 0,
        Compact = true,
        Callback = function(Value)
          Z = Value
     end,      
})
Camera:AddDivider()

local SpectateTable = {
RushMoving = true,
AmbushMoving = true,
A60 = true,
A120 = true,
GlitchRush = true,
GlitchAmbush = true
}

Camera:AddToggle('SpectateEntity',{
     Text = "观察实体",
     Default = false
})

NotifyBox:AddDropdown("EntitiesPicker", {
        Values = { "Rush","Ambush","A-60","A-120","Bramble","Grumble","Eyes","Lookman","Blitz","Figure","GlitchRush","GlitchAmbush","Monument","Groundskeeper"},
        Default = 1,
        Multi = true,
        Text = "实体",
        Callback = function(Value)
        end,
})

NotifyBox:AddToggle('EntityNotifys',{
     Text = "实体通知",
     Default = false
})

NotifyBox:AddToggle('EntitesESP',{
     Text = "实体ESP",
     Default = false
})

MiscBox:AddButton({
     Text = "重置",
DoubleClick = true,
     Func = function()
if Disable4 == false then
replicatesignal(LocalPlayer.Kill)
elseif Disable4 == true then
LocalPlayer.Character.Humanoid.Health = 0
end
end
})

MiscBox:AddButton({
     Text = "再玩一次",
DoubleClick = true,
     Func = function()
RemoteFolder.PlayAgain:FireServer()
end
})

MiscBox:AddButton({
     Text = "大厅",
DoubleClick = true,
     Func = function()
RemoteFolder.Lobby:FireServer()
end
})

MiscBox:AddButton({
     Text = "复活",
DoubleClick = true,
     Func = function()
RemoteFolder.Revive:FireServer()
end
})

if ReplicatedStorage:FindFirstChild("RemotesFolder") then
local dropRemote = RemoteFolder:FindFirstChild("DropItem")

function addFake(prompt, mode)
	if not prompt or not prompt:IsA("ProximityPrompt") then return end
	if prompt:GetAttribute("HasFake") then return end
	prompt:SetAttribute("HasFake", true)
	local fake = prompt:Clone()
	fake.Name = "FakePrompt"
	fake.Parent = prompt.Parent
	fake.Enabled = true
	fake.ClickablePrompt = true
	prompt.Enabled = false
	prompt.ClickablePrompt = false

	fake.Triggered:Connect(function()
		local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if not tool then return end
		
			dropRemote:FireServer(tool)
		

		local con
		con = Workspace.Drops.ChildAdded:Connect(function(v)
			local p = v:FindFirstChildOfClass("ProximityPrompt")
			if p then
				if mode == "Lockpick" then
					fireInteract(p)
					fireInteract(prompt)
				elseif mode == "Shears" then
					fireInteract(prompt)
					fireInteract(p)
				end

				task.wait(0.3)
				con:Disconnect()
			end
		end)
	end)
end

local function scanPrompts(validParents, validNames)
	local t = {}
	for _, v in ipairs(Workspace.CurrentRooms:GetDescendants()) do
		if v:IsA("ProximityPrompt") and (validParents[v.Parent.Name] or validNames[v.Name]) then
			table.insert(t, v)
		end
	end
	return t
end

 function cleanupEnableReal()
	for _, v in ipairs(Workspace.CurrentRooms:GetDescendants()) do
		if v.Name == "FakePrompt" and v.Parent then
			v:Destroy()
		end
		if v:IsA("ProximityPrompt") and v.Name ~= "FakePrompt" then
			pcall(function()
				v.Enabled = true
				v.ClickablePrompt = true
if v:GetAttribute("HasFake") == true then
v:SetAttribute("HasFake",nil)
end
			end)
		end
	end
end

 LockpickParents = { ChestBoxLocked = true, Locker_Small_Locked = true, Toolbox_Locked = true }
 LockpickNames = { UnlockPrompt = true, ThingToEnable = true, LockPrompt = true,
SkullPrompt = true, FusesPrompt = true }

 ShearsParents = { Chest_Vine = true, CuttableVines = true, Cellar = true }
 ShearsNames = { SkullPrompt = true }

local InfiniteValue = false
 InfStore = {}
local removed = false
InfiniteBox:AddToggle('InfiniteItems', {
	Text = "无限锁pick                 无限骨架钥匙",
Disabled = Disable3,
	Default = false,
	Callback = function(Value)
		InfiniteValue = Value
		if not InfiniteValue then
			cleanupEnableReal()
			InfStore = {}
			return
		end
		InfStore = scanPrompts(LockpickParents, LockpickNames)
	end
})

local InfiniteSValue = false
 InfSStore = {}
local removed2 = false

InfiniteBox:AddToggle('InfiniteSItems', {
	Text = "无限剪刀",
Disabled = Disable3,
	Default = false,
	Callback = function(Value)
		InfiniteSValue = Value
		if not InfiniteSValue then
			cleanupEnableReal()
			InfSStore = {}
			return
		end
		InfSStore = scanPrompts(ShearsParents, ShearsNames)			
	end
})
end

Movement:AddDivider()
 Speed = 15
Movement:AddSlider("SpeedBoostSlider", {
        Text = "速度提升滑块",
        Default = 15,
        Min = 15,
        Max = 21,
        Rounding = 1,
        Compact = false,
        Callback = function(Value)
           Speed = Value
     end,      
})

Movement:AddToggle('SpeedBoost',{
     Text = "速度提升",
     Default = false
})

Movement:AddDivider()
Movement:AddToggle('Noclip',{
     Text = "穿墙",
     Default = false
}):AddKeyPicker('NoclipKeybind', {
		Default = 'N',
		SyncToggleState = true,
		Mode = 'Toggle',
		Text = '穿墙',
		NoUI = false,
		Callback = function(Value)
		end,
		ChangedCallback = function(New)
		end
	})

Toggles.Noclip:OnChanged(function(Value)
if not Value then 
LocalPlayer.Character.Collision.CanCollide = true 
if Character.Collision:FindFirstChild("CollisionCrouch") then
LocalPlayer.Character.Collision.CollisionCrouch.CanCollide = true
end
LocalPlayer.Character.HumanoidRootPart.CanCollide = true
if LocalPlayer.Character:FindFirstChild("CollisionPart") then
LocalPlayer.Character:FindFirstChild("CollisionPart").CanCollide = true
end
end
end)

Movement:AddDivider()
Movement:AddToggle('EnableJump',{
     Text = "启用跳跃",
     Default = false
})

Movement:AddToggle('InfiniteJump',{
     Text = "无限跳跃",
     Default = false
})
Movement:AddDivider()

SettingsESP:AddToggle('EnableShowDistancws',{
     Text = "显示距离",
     Default = false,
Callback = function(Value)
ESPLibrary:ShowDistance(Value)
end
})

Ignore = {
HidePrompt = true,
RiftPrompt = true,
StarRiftPrompt = true,
InteractPrompt = true,
FakePrompt = true,
PushPrompt = true,
ClimbPrompt = true,
RevivePrompt = true,
PropPrompt = true,
NoHidingLilBro = true,
DonatePrompt = true
}

AutoInteractTable = {}
Automation:AddToggle('AutoInteract',{
     Text = "自动互动",
     Default = false,
 Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if not Ignore[v.Name] then
if v:IsA("ProximityPrompt") then
table.insert(AutoInteractTable,v)
end
end
end
else
table.clear(AutoInteractTable)
end
end
}):AddKeyPicker('AutoInteractKeybind', {
		Default = 'R',
		SyncToggleState = true,
		Mode = 'Toggle',
		Text = '自动互动',
		NoUI = false,
		Callback = function(Value)
		end,
		ChangedCallback = function(New)
		end
	})

Automation:AddDropdown("IgnoreList", {
        Values = {"Jeff物品","黄金","掉落物"},
        Default = 1,
        Multi = true,
        Text = "忽略列表",
        Callback = function(Value)
        end,
})

Automation:AddDivider()

Automation:AddToggle('AutoHeartbeatMiniGame',{
     Text = "自动心跳小游戏",
     Disabled = Disable5,
     Default = false
})

local UnlockDistance = 40

Automation:AddSlider('UnlockPadLockDistance', {
	Text = '解锁挂锁距离',
	Min = 40, Max = 100, Default = 40,
	Rounding = 1,
	Callback = function(v)
		UnlockDistance = v
	end
})
local RepStore = game:GetService("ReplicatedStorage")
local PS = game:GetService("Players")
local PlayerGui = LocalPlayer.PlayerGui

local function findPL()
	return RemoteFolder:FindFirstChild("PL")
end

local PL = findPL()

local function parsePaper(paper, hintsContainer)
	local children = paper:WaitForChild("UI"):GetChildren()
	local map, order = {}, {}
	for i = 1, #children do
		local c = children[i]
		local idx = tonumber(c.Name)
		if idx then
			local key = c.ImageRectOffset.X .. "_" .. c.ImageRectOffset.Y
			map[key] = { idx, "" }
			order[idx] = key
		end
	end
	if hintsContainer then
		for _, ic in ipairs(hintsContainer:GetChildren()) do
			if ic.Name == "Icon" then
				local key = ic.ImageRectOffset.X .. "_" .. ic.ImageRectOffset.Y
				local entry = map[key]
				if entry then
					local lbl = ic:FindFirstChildWhichIsA("TextLabel")
					if lbl then entry[2] = lbl.Text end
				end
			end
		end
	end
	local parts = {}
	for i = 1, #order do
		parts[i] = map[ order[i] ][2]
	end
	return table.concat(parts)
end

local function manageToggle(toggleName, mode,place)
	local seenPapers = {}
	local lastCodes = {}
	local lastFireTimes = {}
	local padPart
	local conns = {}
	local enabled = false

	local function disconnectAll()
		for _, c in ipairs(conns) do
			if c.Disconnect then c:Disconnect() end
		end
		conns = {}
	end

	local function updatePad()
		local idx = RepStore.GameData.LatestRoom.Value
		local roomRoot = workspace.CurrentRooms and workspace.CurrentRooms[idx]
		if roomRoot then
			local pad = roomRoot:FindFirstChild("Padlock", true)
			padPart = pad and (pad.PrimaryPart or pad:FindFirstChildWhichIsA("BasePart"))
		else
			padPart = nil
		end
	end

	local function handleCode(paper)
		local hints = PlayerGui:FindFirstChild("PermUI") and PlayerGui.PermUI:FindFirstChild("Hints")
		local code = parsePaper(paper, hints)
		if lastCodes[paper] ~= code and code ~= "" then
			lastCodes[paper] = code
			if mode == "Fire" then
				if padPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (LocalPlayer.Character.HumanoidRootPart.Position - padPart.Position).Magnitude
					if dist <= UnlockDistance then
						local now = tick()
						if not lastFireTimes[code] or now - lastFireTimes[code] > 1 then
							local ok = pcall(function() if PL then PL:FireServer(code) end end)
							if ok then lastFireTimes[code] = now end
						end
					end
				end
			else
				Library:Notify("图书馆代码是 "..code,3)
			end
		end
	end

	local function addPaper(paper)
		if seenPapers[paper] then return end
		seenPapers[paper] = true
		conns[#conns+1] = paper.DescendantAdded:Connect(function()
			handleCode(paper)
		end)
		conns[#conns+1] = paper.DescendantRemoving:Connect(function()
			handleCode(paper)
		end)
		handleCode(paper)
	end

	local function removePaper(paper)
		seenPapers[paper] = nil
		lastCodes[paper] = nil
	end

	place:AddToggle(toggleName, {
		Text = (mode == "Fire") and "自动图书馆代码" or "通知图书馆代码",
		Default = false,
		Tooltip = (mode == "Fire") and "在范围内自动解锁挂锁" or "显示代码作为通知",
		Callback = function(on)
			enabled = on
			disconnectAll()
			table.clear(seenPapers)
			table.clear(lastCodes)
			table.clear(lastFireTimes)

			if enabled then
				while RepStore.GameData.LatestRoom.Value < 50 do
					task.wait(0.4)
					if not enabled then return end
				end

				updatePad()
				conns[#conns+1] = RepStore.GameData.LatestRoom:GetPropertyChangedSignal("Value"):Connect(updatePad)

				local function scanContainer(container)
					for _, obj in ipairs(container:GetChildren()) do
						if obj.Name == "LibraryHintPaper" or obj.Name == "LibraryHintPaperHard" then
							addPaper(obj)
						end
					end
				end

				scanContainer(LocalPlayer.Character)
				scanContainer(LocalPlayer.Backpack)

				conns[#conns+1] = LocalPlayer.Backpack.ChildAdded:Connect(function(obj)
					if obj.Name == "LibraryHintPaper" or obj.Name == "LibraryHintPaperHard" then
						addPaper(obj)
					end
				end)
				conns[#conns+1] = LocalPlayer.Backpack.ChildRemoved:Connect(removePaper)
				conns[#conns+1] = LocalPlayer.Backpack.ChildAdded:Connect(function(obj)
					if obj.Name == "LibraryHintPaper" or obj.Name == "LibraryHintPaperHard" then
						addPaper(obj)
					end
				end)
				conns[#conns+1] = LocalPlayer.Backpack.ChildRemoved:Connect(removePaper)
			end
		end
	})
end

manageToggle("AutoCodeFire",   "Fire",Automation)
manageToggle("AutoCodeNotify", "Notify",NotifyBox)

Automation:AddDivider()
local Breaker = nil
Automation:AddToggle('AutoBreakerBox',{
Text = "自动断路器盒",
Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "ElevatorBreaker" then
Breaker = v
     end
end
 
while task.wait() do
if not Toggles.AutoBreakerBox.Value then break end
if Breaker then
for _, v in ipairs(Breaker:GetChildren()) do
if v.Name == "BreakerSwitch" then
if v:GetAttribute("ID") == tonumber(Breaker:WaitForChild("SurfaceGui").Frame.Code.Text) then
if  Breaker:WaitForChild("SurfaceGui").Frame.Code.Frame.BackgroundTransparency == 0  then
v:SetAttribute("Enabled",true)
if v:WaitForChild("Sound").Playing == false then
v:WaitForChild("Sound",1e1).Playing = true
end
v.Material = Enum.Material.Neon
v:WaitForChild("Light",1e1).Attachment.Spark:Emit(1)
v:WaitForChild("PrismaticConstraint").TargetPosition = -0.2
else
v:SetAttribute("Enabled",false)
if v:WaitForChild("Sound").Playing == false then
v:WaitForChild("Sound",1e1).Playing = true
end
v:WaitForChild("PrismaticConstraint").TargetPosition = 0.2
v.Material = Enum.Material.Glass
end
end
end
end
end
end
end
end
})

local EntitysTable = {
RushMoving = 85,
AmbushMoving = 144,
GlitchRush = 120,
GlitchAmbush = 155,
A60 = 130,
A120 = 75
}

Automation:AddToggle('AutoCloset',{
     Text = "自动衣柜",
     Default = false
}):AddKeyPicker('AutoClosetKeybind', {
		Default = 'Q',
		SyncToggleState = true,
		Mode = 'Toggle',
		Text = '自动衣柜',
		NoUI = false,
		Callback = function(Value)
		end,
		ChangedCallback = function(New)
		end
	})

Movement:AddDivider()
Movement:AddToggle('Noacceleration',{
     Text = "无加速",
     Default = false
})
Movement:AddDivider()
Movement:AddToggle('NoClosetExitDelay',{
     Text = "无衣柜退出延迟",
     Default = false
})
Movement:AddDivider()
Fly = Fly or {}
	Fly.Enabled = false
	Fly.Speed = 15
	Fly.FlyBody = nil
	Fly.FlyGyro = nil

	local renderConn 
	local charAddedConn = nil

	function Fly.SetupBodies(char)
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then return end

		local bv = Instance.new("BodyVelocity")
		bv.Name = "FlyBodyVelocity"
		bv.MaxForce = Vector3.new(9e99, 9e99, 9e99)
		bv.Velocity = Vector3.zero
		bv.Parent = root
		Fly.FlyBody = bv

		local bg = Instance.new("BodyGyro")
		bg.Name = "FlyBodyGyro"
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		local cam = workspace.CurrentCamera
		if cam then
			bg.CFrame = cam.CFrame
		end
		bg.Parent = root
		Fly.FlyGyro = bg

		local humanoid = char:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.PlatformStand = true
		end
	end

	function Fly.CleanupBodies()
		if Fly.FlyBody then
			Fly.FlyBody:Destroy()
			Fly.FlyBody = nil
		end
		if Fly.FlyGyro then
			Fly.FlyGyro:Destroy()
			Fly.FlyGyro = nil
		end

		if LocalPlayer.Character then
			local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.PlatformStand = false
			end
		end
	end

	local function onRenderStepped()
		if not Fly.Enabled then return end

		local char = LocalPlayer.Character 
		if not char then return end

		local humanoid = char:FindFirstChild("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		local cam = workspace.CurrentCamera
		if not humanoid or not root or not Fly.FlyBody or not Fly.FlyGyro or not cam then
			return
		end

		local dir = Vector3.zero

		if UserInputService.KeyboardEnabled then
			local forward = UserInputService:IsKeyDown(Enum.KeyCode.W)
			local back    = UserInputService:IsKeyDown(Enum.KeyCode.S)
			local left    = UserInputService:IsKeyDown(Enum.KeyCode.A)
			local right   = UserInputService:IsKeyDown(Enum.KeyCode.D)

			local camCFrame = cam.CFrame
			local lookVec = camCFrame.LookVector
			local rightVec = camCFrame.RightVector

			if forward then
				dir = dir + lookVec
			end
			if back then
				dir = dir - lookVec
			end
			if left then
				dir = dir - rightVec
			end
			if right then
				dir = dir + rightVec
			end
		else
			local moveDir = humanoid.MoveDirection
			if moveDir.Magnitude > 0 then
				local camCFrame = cam.CFrame
				local flatLook = Vector3.new(camCFrame.LookVector.X, 0, camCFrame.LookVector.Z)
				local flatRight = Vector3.new(camCFrame.RightVector.X, 0, camCFrame.RightVector.Z)
				if flatLook.Magnitude > 0 then
					flatLook = flatLook.Unit
				end
				if flatRight.Magnitude > 0 then
					flatRight = flatRight.Unit
				end

				local forwardWeight = moveDir:Dot(flatLook)
				local rightWeight = moveDir:Dot(flatRight)
				dir = camCFrame.LookVector * forwardWeight + camCFrame.RightVector * rightWeight
			end
		end

		if dir.Magnitude > 0 then
			Fly.FlyBody.Velocity = dir.Unit * Fly.Speed
		else
			Fly.FlyBody.Velocity = Vector3.zero
		end

		Fly.FlyGyro.CFrame = cam.CFrame

		humanoid.PlatformStand = true
	end

	function Fly.Enable()
		if Fly.Enabled then return end
		Fly.Enabled = true

		local char = LocalPlayer.Character 
		if char then
			Fly.SetupBodies(char)
		end

		if not renderConn then
			renderConn = RunService.RenderStepped:Connect(onRenderStepped)
		end

		if not charAddedConn then
			charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char2)
				if Fly.Enabled then
					char2:WaitForChild("HumanoidRootPart")
					Fly.SetupBodies(char2)
				end
			end)
		end
	end

	function Fly.Disable()
		if not Fly.Enabled then return end
		Fly.Enabled = false

		Fly.CleanupBodies()

		if renderConn then
			renderConn:Disconnect()
			renderConn = nil
		end

		if charAddedConn then
			charAddedConn:Disconnect()
			charAddedConn = nil
		end
	end

	function Fly.Toggle()
		if Fly.Enabled then
			Fly.Disable()
		else
			Fly.Enable()
		end
	end

	function Fly.SetSpeed(newSpeed)
		Fly.Speed = newSpeed or Fly.Speed
	end

	FlySpeed = Movement:AddSlider("FlySpeed", {
		Text = "飞行速度",
		Min = 10,
		Max = 21,
		Default = Fly.Speed,
		Rounding = 0,
		Callback = function(v)
			Fly.SetSpeed(v)
		end
	})

	Movement:AddToggle("Fly", {
		Text = "飞行",
		Default = false,
		Callback = function(enabled)
			if enabled then
				Fly.Enable()
			else
				Fly.Disable()
			end
		end
	}):AddKeyPicker('Fly Keybind', {
		Default = 'F',
		SyncToggleState = true,
		Mode = 'Toggle',
		Text = '飞行',
		NoUI = false,
		Callback = function(Value)
		end,
		ChangedCallback = function(New)
		end
	})

View = 70
Camera:AddSlider("FieldofViewAdjust", {
        Text = "FOV滑块",
        Default = 70,
        Min = View,
        Max = 120,
        Rounding = 1,
        Compact = false,
        Callback = function(Value)
           View = Value
     end,      
})

Camera:AddToggle('Fieldofview',{
     Text = "FOV",
     Default = false
})
Anti:AddToggle('AntiDread',{
     Text = "反恐惧",
     Default = false,
Callback = function(Value)
local Dread = Modules:FindFirstChild("Dread") or Modules:FindFirstChild("_Dread")
if Dread then
Dread.Name = Value and "_Dread" or "Dread"
end
end
})

Anti:AddToggle('AntiScreech',{
     Text = "反尖啸",
     Default = false,
Callback = function(Value)
local Screech = Modules:FindFirstChild("Screech") or Modules:FindFirstChild("_Screech")
Screech.Name = Value and "_Screech" or "Screech"
end
})

Anti:AddToggle('AntiA90',{
     Text = "反A-90",
     Default = false,
Callback = function(Value)
local A90 = Modules:FindFirstChild("A90") or Modules:FindFirstChild("_A90")
if A90 then
A90.Name = Value and "_A90" or "A90"
end
end
})

Anti:AddToggle('AntiEyes',{
     Text = "反眼睛",
     Default = false
})

Anti:AddToggle('AntiSnare',{
     Text = "反陷阱",
     Default = false,
      Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Snare" and v.Parent and v.Parent.Name ~= "Snare" then
v:WaitForChild("Hitbox").CanTouch = false
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Snare" and v.Parent and v.Parent.Name ~= "Snare" then
v:WaitForChild("Hitbox").CanTouch = true
end
end
end
end
})

Anti:AddToggle('AntiDupe',{
     Text = "反复制",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "DoorFake" then
v:WaitForChild("Hidden").CanTouch = false
if v:FindFirstChild("Lock") then
v:FindFirstChild("Lock"):FindFirstChildOfClass("ProximityPrompt").ClickablePrompt = false
end
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "DoorFake" then
v:WaitForChild("Hidden").CanTouch = false
if v:FindFirstChild("Lock") then
v:FindFirstChild("Lock"):FindFirstChildOfClass("ProximityPrompt").ClickablePrompt = false
end
end
end
end
end
)

Anti:AddToggle('AntiHear',{
     Text = "反Figure听力",
     Default = false
})
Toggles.AntiHear:OnChanged(function(Value)
if not Value then
RemoteFolder.Crouch:FireServer(false)
end
end)
Anti:AddToggle('AntiHalt',{
     Text = "反暂停",
     Default = false,
Callback = function(Value)
local Halt = ClientModules.EntityModules:FindFirstChild("Shade") or
ClientModules.EntityModules:FindFirstChild("_Shade") 
Halt.Name = Value and "_Shade" or "Shade"
end
})

local nothitted = false
local direction = Vector3.new(0, -50, 0)
task.spawn(function()
while task.wait(0.35) do
if LocalPlayer.Character and not Library.Unloaded then 
local origin = LocalPlayer.Character.HumanoidRootPart.Position
local result = workspace:Raycast(origin, direction, raycastParms)
if result then
nothitted = false
else
nothitted = true
end
end
end
end)

if ReplicatedStorage:FindFirstChild("RemotesFolder") then
Bypass:AddToggle('SpeedBypass',{
     Text = "速度绕过",
     Default = false,
Callback = function(Value)
Options.SpeedBoostSlider:SetMax(Value and 75 or 21)
Options.SpeedBoostSlider:SetValue(Value and Options.SpeedBoostSlider.Value or 21)
Options.FlySpeed:SetMax(Value and 75 or 21)
Options.FlySpeed:SetValue(Value and Options.FlySpeed.Value or 21)

while true   do
task.wait(0.216)
if alive then
local CollisionClon = LocalPlayer.Character:WaitForChild("_CollisionPart")
local CollisionClon2 = LocalPlayer.Character:WaitForChild("_CollisionPart2")
if not  Toggles.SpeedBypass.Value or Library.Unloaded then
CollisionClon.Massless = true
CollisionClon2.Massless = true
break end

if Character.CollisionPart.Anchored or nothitted or Toggles.AnticheatManipulation and Toggles.AnticheatManipulation.Value then
CollisionClon.Massless = true
CollisionClon2.Massless = true
task.wait(0.35)
else
CollisionClon.Massless = true
CollisionClon2.Massless = true
task.wait(0.216)
CollisionClon2.Massless = false
CollisionClon.Massless = false
end
end
end
end,
})
end

if not ReplicatedStorage:FindFirstChild("RemotesFolder") then
Options.SpeedBoostSlider:SetMax(80)
Options.FlySpeed:SetMax(80)
end

Bypass:AddDivider()
if  ReplicatedStorage:FindFirstChild("RemotesFolder") then 
Bypass:AddDropdown("GMDropdown", {
        Values = { "自动化","切换"},
        Default = 2,
        Multi = false,
        Text = "上帝模式下拉",
        Callback = function(Value)
        end,
})

Bypass:AddToggle('GodMode',{
     Text = "上帝模式",
     Default = false,
     Callback = function(Value)
if Value then
if not Toggles.AntiHear.Value then
Toggles.AntiHear:SetValue(true)
Library:Notify("自动启用反Figure听力 上帝模式工作需要启用",3)
end

Character.Collision.Size = Vector3.new(1, 0.001, 5)
Character.Humanoid.HipHeight = 0.0001
else
LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
Character.Collision.Size = Vector3.new(5.5, 3, 5)
Character.Humanoid.HipHeight = 2.4
end
end
}):AddKeyPicker('GodmodeKeybind', {
		Default = 'G',
		SyncToggleState = true,
		Mode = 'Toggle',
		Text = '上帝模式',
		NoUI = false,
		Callback = function(Value)
		end,
		ChangedCallback = function(New)
		end
	})

Bypass:AddToggle('AnticheatManipulation',{
     Text = "反作弊操纵",
     Default = false
}):AddKeyPicker('AnticheatManipulationKeybind', {
		Default = 'H',
		SyncToggleState = true,
		Mode = 'Toggle',
		Text = '反作弊操纵',
		NoUI = false,
		Callback = function(Value)
		end,
		ChangedCallback = function(New)
		end
	})
end

FloorAnti:AddToggle('RankedAntiBanana',{
     Text = "反香蕉",
     Default = false,
Callback = function(Value)
for _, v in ipairs(workspace:GetChildren()) do
if v.Name == "NannerPeel"  then
v.CanTouch = not Value
v:WaitForChild("Hitbox",9e9).CanTouch = not Value
end
end
end
})
FloorAnti:AddDivider()

FloorAnti:AddToggle('AntiSeekObstructions',{
     Text = "反Seek障碍",
     Default = false,
Callback = function(Value)
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "ChandelierObstruction" or v.Name == "Seek_Arm" then
for _, part in ipairs(v:GetChildren()) do
if part:IsA("BasePart") then part.CanTouch = not Value
end
end
end
end
end
})

if Floor.Value == "Mines" then
local PlayerGui = LocalPlayer.PlayerGui
    local MainUI = PlayerGui.MainUI
    
    local NotifyCodeValue = false

    FloorAnti:AddToggle("NotifyAnchorCode", {
        Text = "通知锚点代码",
        Default = false,
        Callback = function(enabled)
local AnchorHintFrame = MainUI:WaitForChild("AnchorHintFrame")
            NotifyCodeValue = enabled
            while NotifyCodeValue do
                task.wait(0.9)

                local foundAnchor = nil
                local anchorSignText = AnchorHintFrame.AnchorCode.Text
                local currentCode = AnchorHintFrame.Code.Text
                
                for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
                    if v.Name == "MinesAnchor" and v.Sign.TextLabel.Text == anchorSignText then
                        foundAnchor = v
                        break
                    end
                end

                if not foundAnchor then
                    task.wait()
                end

if foundAnchor then
                local noteObj = foundAnchor:FindFirstChild("Note")
                if not noteObj then
                    Library:Notify(("锚点 %s 代码是 %s"):format(foundAnchor.Sign.TextLabel.Text, currentCode), 3)
                else
                    local noteText = noteObj.SurfaceGui.TextLabel.Text
                    local change = tonumber(noteText) or 0
                    local newcode = ""

                    for i = 1, #currentCode do
                        local num = tonumber(currentCode:sub(i, i)) or 0
                        num = (num + change) % 10
                        newcode = newcode .. num
                    end

                    Library:Notify(("锚点 %s 代码是 %s"):format(foundAnchor.Sign.TextLabel.Text, newcode), 1)
                end
            end
        end
end
    })

FloorAnti:AddToggle('DeleteFigure',{
     Text = "移除Figure (FE)",
     Default = false,
Disabled = Disable2
})
FloorAnti:AddDivider()
local clones = {}
		local bridgeConns = {}

		local function makeBarrier(barrier)
			if barrier.Parent:FindFirstChild("AntiBridge") then return end
			local clone = barrier:Clone()
			clone.Name = "AntiBridge"
			clone.Size = Vector3.new(barrier.Size.X, barrier.Size.Y, 30)
			clone.Color = Color3.new(0,0,0.5)
			clone.CFrame = barrier.CFrame * CFrame.new(0, 0, -5)
			clone.Transparency = 0
			clone.Anchored = true
			clone.CanCollide = true
			clone.CanTouch = true
			clone.Parent = barrier.Parent
			table.insert(clones, clone)
		end

		local function processBridge(bridge)
			if bridge:FindFirstChild("AntiBridge") then return end
			for _, part in ipairs(bridge:GetChildren()) do
				if part.Name == "PlayerBarrier" and part.Size.Y == 2.75 and (part.Rotation.X % 180) == 0 then
					makeBarrier(part)
				end
			end
			local conn = bridge.ChildAdded:Connect(function(c)
				if c.Name == "PlayerBarrier" then
					makeBarrier(c)
				end
			end)
			table.insert(bridgeConns, conn)
		end

		FloorAnti:AddToggle("ABF", {
			Text = "反桥梁坠落",
			Default = false,
			Callback = function(on)
				for _, c in ipairs(bridgeConns) do c:Disconnect() end
				bridgeConns = {}
				for _, c in ipairs(clones) do if c and c.Parent then c:Destroy() end end
				clones = {}

				if not on then return end

				task.spawn(function()
					for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
						local parts = room:FindFirstChild("Parts")
						if parts then
							for _, obj in ipairs(parts:GetChildren()) do
								if obj.Name == "Bridge" then
									processBridge(obj)
								end
							end
							local conn = parts.ChildAdded:Connect(function(c)
								if c.Name == "Bridge" then
									processBridge(c)
								end
							end)
							table.insert(bridgeConns, conn)
						end
					end
				end)

				local roomConn = workspace.CurrentRooms.ChildAdded:Connect(function(room)
					task.defer(function()
						local parts = room:WaitForChild("Parts", 3)
						if parts then
							for _, obj in ipairs(parts:GetChildren()) do
								if obj.Name == "Bridge" then
									processBridge(obj)
								end
							end
							local conn = parts.ChildAdded:Connect(function(c)
								if c.Name == "Bridge" then
									processBridge(c)
								end
							end)
							table.insert(bridgeConns, conn)
						end
					end)
				end)
				table.insert(bridgeConns, roomConn)
			end
		})

function showpath(part)
if part.Name == "SeekGuidingLight" then
local Part = Instance.new("Part",Pathnode)
Part.Name = "ShowPath"
Part.Position = part.Position
Part.Size = Vector3.new(2, 1, 2)
Part.Anchored = true
Part.CanCollide = false
Part.CanTouch = false
Part.CanQuery = true
Debris:AddItem(Part, 150)
end
end

FloorAnti:AddToggle("ShowSeekPath", {
			Text = "显示Seek路径",
			Default = false,
			Callback = function(Value)
if Value then
for _, v in ipairs(workspace:GetDescendants()) do
showpath(v)
end
else
Pathnode:ClearAllChildren()
end
end
})

FloorAnti:AddToggle('AnticheatBypass',{
     Text = "反作弊绕过",
     Default = false
})
Toggles.AnticheatBypass:OnChanged(function(Value)
if not Value then
RemoteFolder.ClimbLadder:FireServer()
end
if Value then
Library:Notify("请进入梯子并等待",9)
end
end)

LocalPlayer.Character:GetAttributeChangedSignal("Climbing"):Connect(function()
if LocalPlayer.Character:GetAttribute("Climbing") == true then
if Toggles.AnticheatBypass.Value then 
task.wait(0.4)
LocalPlayer.Character:SetAttribute("Climbing",false)
Library:Notify("绕过了反作弊 这有效直到过场动画或暂停",7)
end
end
end)
end

local RankedAntiBananaConnection = nil
RankedAntiBananaConnection = workspace.ChildAdded:Connect(function(v)
if Toggles.RankedAntiBanana and Toggles.RankedAntiBanana.Value then
if v.Name == "NannerPeel"  then
v.CanTouch = false
v:WaitForChild("Hitbox",9e9).CanTouch = false
end
end
end)

ModifiersBox:AddToggle('AntiLookman',{
     Text = "反Lookman",
     Default = false
})
ModifiersBox:AddDivider()

ModifiersBox:AddToggle('AntiFog',{
     Text = "反雾",
     Default = false
})
if Floor.Value == "Party" then
FloorAnti:AddToggle('AutoGetPowerUps',{
Text = "自动获取能量",
Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "PowerupPad" then
v:WaitForChild("Hitbox",9e9).Size = Vector3.new(90, 90, 90)
end 
end
else 
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "PowerupPad" then
v:WaitForChild("Hitbox",9e9).Size = Vector3.new(5, 5, 5)
end 
end
end
end
})
end

ModifiersBox:AddToggle('AntiGiggle',{
     Text = "反咯咯笑",
     Default = false,
Callback = function(Value)
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GiggleCeiling" then
v:WaitForChild("Hitbox",9e9).CanTouch = not Value
end
end
end 
})

ModifiersBox:AddToggle('AntiJam',{
     Text = "反干扰",
     Default = false,
Callback = function(Value)
		if Modifiers and not Modifiers:FindFirstChild("Jammin") then return end
		local mainTrack = game["SoundService"]:FindFirstChild("Main")
		if mainTrack then
			local jamming = mainTrack:FindFirstChild("Jamming")
			if jamming then
				jamming.Enabled = not Value
			end
		end

		local mainUI = LocalPlayer:FindFirstChild("PlayerGui")
			and LocalPlayer.PlayerGui:FindFirstChild("MainUI")
		if mainUI then
			local healthGui = mainUI:FindFirstChild("Initiator")
				and mainUI.Initiator:FindFirstChild("Main_Game")
				and mainUI.Initiator.Main_Game:FindFirstChild("Health")
			if healthGui then
				local jamSound = healthGui:FindFirstChild("Jam")
				if jamSound then
					jamSound.Playing = not Value
				end
			end
		end
	end
})

ModifiersBox:AddToggle('AntiGloomPile',{
     Text = "反阴暗蛋",
     Default = false,
Callback = function(Value)
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GloomEgg" then
 v:WaitForChild("Egg",9e9).CanTouch = not Value
end
end
end 
})

ModifiersBox:AddToggle('AntiVacuum',{
     Text = "反真空",
     Default = false,
Callback = function(Value)
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "SideroomSpace" then
for _, part in ipairs(v:GetChildren()) do
if part:IsA("BasePart") then
part.CanTouch = not Value
part.CanCollide = Value
end
end
end
end
end 
})

if Floor.Value == "Garden" then
FakeSurge = Instance.new("RemoteEvent",ReplicatedStorage)
FakeSurge.Name = "SurgeRemote"

FloorAnti:AddToggle('AntiSurge',{
     Text = "反浪涌",
     Default = false,
    Callback = function(Value)
if Value then
ReplicatedStorage.RemotesFolder.SurgeRemote.Parent = ReplicatedStorage
FakeSurge.Parent = ReplicatedStorage.RemotesFolder
else
ReplicatedStorage.RemotesFolder.SurgeRemote.Parent = ReplicatedStorage.RemotesFolder
FakeSurge.Parent = ReplicatedStorage
end
end
})
end

function AddESP(inst,txt,color)
ESPLibrary:AddESP(inst, txt, color)
end

local DoorColor = Color3.new(0,1,1)
local KeyColor = Color3.new(0, 1, 0)
local GateLeverColor = Color3.new(0,1,0)
local TimerLeverColor = Color3.new(0,1,0)
local PlayersColor = Color3.new(1, 1, 1)
local GeneratorColor = Color3.new(0,1,0)
local HidingSpotColor = Color3.new(0,0.5,0)
local LeverColor = Color3.new(0,1,0)
local BooksColor = Color3.new(0,1,0)
local BreakerColor = Color3.new(0,1,0)
local ItemsColor = Color3.new(0,0,1)
local GoldColor = Color3.new(1, 0.8, 0)
local FuseColor = Color3.new(0,1,0)
local AnchorColor =  Color3.new(0,0,1)

ESPBox:AddToggle('Door',{
     Text = "门",
     Default = false,
Callback = function(Value)
if Value then
local Door = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door
if not Door:GetAttribute("Used") then
AddESP(Door, (Door.Parent:FindFirstChild("Lock") and "已锁定  " or "") .. "门 " .. Door.Parent:GetAttribute("RoomID"), DoorColor)
end
else
for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
for _, v in ipairs(room:GetChildren())
do
if v.Name == "Door" and v:FindFirstChild("Door") then
ESPLibrary:RemoveESP(v.Door)
end
end
end
end
end
}):AddColorPicker('DoorColo', {
	Default = DoorColor,
	Title = '门颜色',
	Transparency = 0,
	Callback = function(Value)
		DoorColor = Value
if Toggles.Door.Value then
Toggles.Door:SetValue(false)
Toggles.Door:SetValue(true)
end
	end
})
FloorESP:AddToggle('TimerLever',{
     Text = "计时器杠杆ESP",
     Default = false,
Callback = function(Value)
if Value then
local v = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("TimerLever",true)
if v and v.Name == "TimerLever" then
AddESP(v,"计时器杠杆",TimerLeverColor)
end
else
local v = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:FindFirstChild("TimerLever",true)
if v and v.Name == "TimerLever" then
ESPLibrary:RemoveESP(v)
end
end
end
}):AddColorPicker('TimeLeverColo', {
	Default = TimerLeverColor,
	Title = '计时器杠杆颜色',
	Transparency = 0,
	Callback = function(Value)
		TimerLeverColor = Value
if Toggles.TimerLever.Value then
Toggles.TimerLever:SetValue(false)
Toggles.TimerLever:SetValue(true)
end
	end
})

FloorESP:AddDivider()

if Floor.Value == "Garden" then
FloorESP:AddToggle('LeverESP',{
     Text = "杠杆ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v and v.Parent and v.Parent.Name == "VineGuillotine" and v.Name == "Lever" then
AddESP(v,"杠杆",LeverColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v and v.Parent and v.Parent.Name == "VineGuillotine" and v.Name == "Lever" then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('LeverColo', {
	Default = LeverColor,
	Title = '杠杆颜色',
	Transparency = 0,
	Callback = function(Value)
		LeverColor = Value
if Toggles.Lever.Value then
Toggles.Lever:SetValue(false)
Toggles.Lever:SetValue(true)
end
	end
})
end

if Floor.Value == "Mines" then
FloorESP:AddToggle('Generator',{
     Text = "发电机ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GeneratorMain" then
AddESP(v,"发电机",GeneratorColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GeneratorMain" then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('GeneratorColo', {
	Default = GeneratorColor,
	Title = '发电机颜色',
	Transparency = 0,
	Callback = function(Value)
		GeneratorColor = Value
if Toggles.Generator.Value then
Toggles.Generator:SetValue(false)
Toggles.Generator:SetValue(true)
end
	end
})

FloorESP:AddToggle('Ladder',{
     Text = "梯子ESP",
     Default = false,
Callback = function(Value)
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "Ladder" then
AddESP(v,"梯子",Color3.new(0,3,2))
end
end
end
})
end

if Floor.Value == "Mines" then
FloorESP:AddToggle('Fuse',{
     Text = "保险丝ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "FuseObtain" then
AddESP(v,"保险丝",FuseColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "FuseObtain" then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('FuseESP', {
	Default = FuseColor,
	Title = '保险丝颜色',
	Transparency = 0,
	Callback = function(Value)
		FuseColor = Value
if Toggles.Fuse.Value then
Toggles.Fuse:SetValue(false)
Toggles.Fuse:SetValue(true)
end
	end
})
end

if Floor.Value == "Mines" then
FloorESP:AddToggle('Anchor',{
     Text = "锚点ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "MinesAnchor" then
AddESP(v,"锚点 " ..  v:WaitForChild("Sign").TextLabel.Text,AnchorColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "MinesAnchor" then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('AnchorColo', {
	Default = AnchorColor,
	Title = '锚点颜色',
	Transparency = 0,
	Callback = function(Value)
		AnchorColor = Value
if Toggles.Anchor.Value then
Toggles.Anchor:SetValue(false)
Toggles.Anchor:SetValue(true)
end
	end
})
FloorESP:AddToggle('WaterPump',{
     Text = "水泵ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "WaterPump" then
AddESP(v,"水泵",Color3.new(0,1,0))
end
end
end
end
})
end

ESPBox:AddToggle('Key',{
     Text = "钥匙",
     Default = false,
Callback = function(Value)
if Value then
local v = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("KeyObtain",true)
if v and not v:GetAttribute("Used") then
AddESP(v,"钥匙",KeyColor)
end
else
local Key = workspace:FindFirstChild("KeyObtain",true)
ESPLibrary:RemoveESP(Key)
end
end
}):AddColorPicker('KeyColo', {
	Default = KeyColor,
	Title = '钥匙颜色',
	Transparency = 0,
	Callback = function(Value)
		KeyColor = Value
if Toggles.Key.Value then
Toggles.Key:SetValue(false)
Toggles.Key:SetValue(true)
end
	end
})
local HidingSpots = {
Wardrobe = "衣柜",
Rooms_Locker = "储物柜",
Backdoor_Wardrobe = "衣柜",
Toolshed = "衣柜",
Locker_Large = "储物柜",
Bed = "床",
CircularVent = "通风口",
Rooms_Locker_Fridge = "冰箱",
RetroWardrobe = "衣柜",
Dumpster = "垃圾箱",
Double_Bed = "双人床"
}

ESPBox:AddToggle('HidingSpot',{
     Text = "躲藏点ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:FindFirstChild("Assets",true):GetChildren()) do
local TextName = HidingSpots[v.Name]
if TextName and v.PrimaryPart then
AddESP(v,TextName,HidingSpotColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
local TextName = HidingSpots[v.Name]
if TextName and v.PrimaryPart then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('HidingSpot', {
	Default = HidingSpotColor,
	Title = '躲藏点颜色',
	Transparency = 0,
	Callback = function(Value)
		HidingSpotColor = Value
if Toggles.HidingSpot.Value then
Toggles.HidingSpot:SetValue(false)
Toggles.HidingSpot:SetValue(true)
end
	end
})

ESPBox:AddToggle('GateLever',{
     Text = "门杠杆",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v.Name == "LeverForGate" then
AddESP(v,"门杠杆",GateLeverColor)
end
end
else
local Lever = workspace.CurrentRooms:FindFirstChild("LeverForGate",true)
if Lever then 
ESPLibrary:RemoveESP(Lever)
end
end
end
}):AddColorPicker('GateLeverColo', {
	Default = GateLeverColor,
	Title = '门杠杆颜色',
	Transparency = 0,
	Callback = function(Value)
		GateLeverColor = Value
if Toggles.GateLever.Value then
Toggles.GateLever:SetValue(false)
Toggles.GateLever:SetValue(true)
end
	end
})
ESPBox:AddToggle('Players',{
     Text = "玩家ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and plr.Character then
AddESP(plr.Character,plr.Name,PlayersColor)
                   end
            end
else
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and plr.Character then
ESPLibrary:RemoveESP(plr.Character)
end
end
      end
end
}):AddColorPicker('PlayersColo', {
	Default = PlayersColor,
	Title = '玩家颜色',
	Transparency = 0,
	Callback = function(Value)
		PlayersColor = Value
if Toggles.Players.Value then
Toggles.Players:SetValue(false)
Toggles.Players:SetValue(true)
end
	end
})

local PlayersConnection
for _, v in ipairs(Players:GetPlayers()) do
PlayersConnection = v.CharacterAdded:Connect(function()
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= LocalPlayer and plr.Character then
AddESP(plr.Character,plr.Name,PlayersColor)
end
end
end)
end

ESPBox:AddToggle('Books',{
     Text = "书籍",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v.Name == "LiveHintBook" then
AddESP(v,"书籍",BooksColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v.Name == "LiveHintBook" then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('BooksColo', {
	Default = BooksColor,
	Title = '书籍颜色',
	Transparency = 0,
	Callback = function(Value)
		BooksColor = Value
if Toggles.Books.Value then
Toggles.Books:SetValue(false)
Toggles.Books:SetValue(true)
end
	end
})

ESPBox:AddToggle('Breaker',{
     Text = "断路器",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v.Name == "LiveBreakerPolePickup" then
AddESP(v,"断路器",BreakerColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v.Name == "LiveBreakerPolePickup" then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('BreakerColo', {
	Default = BreakerColor,
	Title = '断路器颜色',
	Transparency = 0,
	Callback = function(Value)
		BreakerColor = Value
if Toggles.Breaker.Value then
Toggles.Breaker:SetValue(false)
Toggles.Breaker:SetValue(true)
end
	end
})

 Item = {
Flashlight = "手电筒",
Lockpick = "开锁工具",
Vitamins = "维生素",
Bandage = "绷带",
StarVial = "星星瓶",
StarBottle = "星星瓶",
StarJug = "星星壶",
Shakelight = "摇灯",
Straplight = "带灯",
Bulklight = "大灯",
Battery = "电池",
Candle = "蜡烛",
Crucifix = "十字架",
CrucifixWall = "十字架",
Glowsticks = "荧光棒",
SkeletonKey = "骨架钥匙",
Candy = "糖果",
ShieldMini = "迷你盾牌",
ShieldBig = "大盾牌",
BandagePack = "绷带包",
BatteryPack = "手电筒电池包",
RiftCandle = "月光蜡烛",
LaserPointer = "激光笔",
HolyGrenade = "神圣手榴弹",
Shears = "剪刀",
Smoothie = "冰沙",
Cheese = "奶酪",
Bread = "面包",
AlarmClock = "闹钟",
RiftSmoothie = "月光冰沙",
GweenSoda = "格林苏打水",
GlitchCub = "故障立方体",
RiftJar = "裂缝罐",
Compass = "指南针",
Lantern = "灯笼",
Multitool = "多功能工具",
Lotus = "莲花",
TipJar = "杰夫小费罐",
LotusPetalPickup = "莲花花瓣",
KeyIron = "铁钥匙",
Donut = "甜甜圈",
Toolshed_Small = "剪刀工具棚",
Chest_Vine = "箱子藤蔓",
ChestBoxLocked = "[已锁定]箱子",
ChestBox = "箱子",
StardustPickup = "星尘"
}

ESPBox:AddToggle('Items',{
     Text = "物品ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, i in ipairs(workspace.CurrentRooms:GetDescendants()) do
local name = Item[i.Name]
if name and i.PrimaryPart then
AddESP(i,name,ItemsColor)
end
end
else
for _, i in ipairs(workspace.CurrentRooms:GetDescendants()) do
local name = Item[i.Name]
if name and i.PrimaryPart then
ESPLibrary:RemoveESP(i)
end
end
end
end
}):AddColorPicker('ItemsColo', {
	Default = ItemsColor,
	Title = '物品颜色',
	Transparency = 0,
	Callback = function(Value)
		ItemsColor = Value
if Toggles.Items.Value then
Toggles.Items:SetValue(false)
Toggles.Items:SetValue(true)
end
	end
})

ESPBox:AddToggle('Gold',{
     Text = "黄金ESP",
     Default = false,
Callback = function(Value)
if Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v and v.Name == "GoldPile" then
AddESP(v,"黄金 " .. v:GetAttribute("GoldValue"),GoldColor)
end
end
else
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v.Name == "GoldPile" then
ESPLibrary:RemoveESP(v)
end
end
end
end
}):AddColorPicker('GoldColor', {
	Default = GoldColor,
	Title = '黄金颜色',
	Transparency = 0,
	Callback = function(Value)
		GoldColor = Value
if Toggles.Gold.Value then
Toggles.Gold:SetValue(false)
Toggles.Gold:SetValue(true)
end
	end
})

table.insert(Connections,UserInputService.JumpRequest:Connect(function()
task.wait(0.3)
if Toggles.InfiniteJump.Value then
if Character then
Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)
)

table.insert(Connections,LocalPlayer.CharacterAdded:Connect(function()
task.wait(2)
Library:Notify("设置一切",4)

if Toggles.EnableJump.Value then
LocalPlayer.Character:SetAttribute("CanJump",true)
end

if Toggles.Godmode.Value then
LocalPlayer.Character.Collision.Position = LocalPlayer.Character.Collision.Position - Vector3.new(0, 11, 0)
end
task.wait(3)
MainGame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI"):WaitForChild("Initiator").Main_Game
 RequiredMainGame = require(LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
 RemoteListener = MainGame.RemoteListener
 Modules = RemoteListener.Modules

if Toggles.AntiScreech.Value then
local Screech = Modules:FindFirstChild("Screech") or Modules:FindFirstChild("_Screech")
Screech.Name = "_Screech"
end

if Toggles.AntiA90.Value then
local A90 = Modules:FindFirstChild("A90") or Modules:FindFirstChild("_A90")
if A90 then
A90.Name =   "_A90"
end
end
end))

function addESP(entity,label)
local base 
while entity.PrimaryPart == nil do
base = entity:FindFirstChildWhichIsA("BasePart")
task.wait()
end
base = entity.PrimaryPart

if not entity:FindFirstChildOfClass("Humanoid") then
Instance.new("Humanoid",entity)
end
if base then
base.Transparency = 0.99
end
ESPLibrary:AddESP(entity,label,Color3.new(1, 0, 0))
end

Toggles.EntityNotifys:OnChanged(function(Value)
if Value then
for _, v in ipairs(workspace:GetChildren()) do
if v.Name == "RushMoving" and Options.EntitiesPicker.Value["Rush"] then
Notify("Rush已生成, 寻找躲藏点",3)
Sound()
end
if v.Name == "BackdoorRush" and Options.EntitiesPicker.Value["Blitz"] then
Notify("Blitz已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "AmbushMoving" and Options.EntitiesPicker.Value["Ambush"] then
Notify("Ambush已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "A60" and Options.EntitiesPicker.Value["A-60"] then
Notify("A-60已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "A120" and Options.EntitiesPicker.Value["A-120"] then
Notify("A-120已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "Eyes" and Options.EntitiesPicker.Value["Eyes"] then
Notify("Eyes已生成 避免看它",3)
Sound()
end

if v.Name == "GlitchRush" and Options.EntitiesPicker.Value["GlitchRush"] then
Notify("GlitchRush已生成, 寻找躲藏点",3)
Sound()
end
if v.Name == "GlitchAmbush" and Options.EntitiesPicker.Value["GlitchAmbush"] then
Notify("GlitchAmbush已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "MonumentEntity" and Options.EntitiesPicker.Value["Monument"] then
Notify("Monument已生成, 看它",3)
Sound()
end

end
if Toggles.EntitesESP.Value then
if v.Name == "RushMoving" and Options.EntitiesPicker.Value["Rush"] then
addESP(v,"Rush")
end

if v.Name == "AmbushMoving" and Options.EntitiesPicker.Value["Ambush"] then
addESP(v,"Ambush")
end

if v.Name == "A60" and Options.EntitiesPicker.Value["A-60"] then
addESP(v,"A-60")
end

if v.Name == "A120" and Options.EntitiesPicker.Value["A-120"] then
addESP(v,"A-120")
end

if v.Name == "Eyes" and Options.EntitiesPicker.Value["Eyes"] then
addESP(v,"Eyes")
end

if v.Name == "BackdoorLookman" and Options.EntitiesPicker.Value["Lookman"] then
addESP(v,"Lookman")
end

if v.Name == "MonumentEntity" and Options.EntitiesPicker.Value["Monument"] then
addESP(v:WaitForChild("Top"),"Monument")
end
end
end
end)

table.insert(Connections,workspace.ChildAdded:Connect(function(v)
if  Toggles.EntityNotifys.Value then  
if v.Name == "RushMoving" and Options.EntitiesPicker.Value["Rush"] then
Notify("Rush已生成, 寻找躲藏点",3)
Sound()
end
if v.Name == "BackdoorRush" and Options.EntitiesPicker.Value["Blitz"] then
Notify("Blitz已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "AmbushMoving" and Options.EntitiesPicker.Value["Ambush"] then
Notify("Ambush已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "A60" and Options.EntitiesPicker.Value["A-60"] then
Notify("A-60已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "A120" and Options.EntitiesPicker.Value["A-120"] then
Notify("A-120已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "Eyes" and Options.EntitiesPicker.Value["Eyes"] then
Notify("Eyes已生成,避免看它",3)
Sound()
end

if v.Name == "GlitchRush" and Options.EntitiesPicker.Value["GlitchRush"] then
Notify("GlitchRush已生成, 寻找躲藏点",3)
Sound()
end
if v.Name == "GlitchAmbush" and Options.EntitiesPicker.Value["GlitchAmbush"] then
Notify("GlitchAmbush已生成, 寻找躲藏点",3)
Sound()
end

if v.Name == "MonumentEntity" and Options.EntitiesPicker.Value["Monument"] then
Notify("Monument已生成, 看它",3)
Sound()
end

end
if Toggles.EntitesESP.Value then
if v.Name == "RushMoving" and Options.EntitiesPicker.Value["Rush"] then
addESP(v,"Rush")
end

if v.Name == "AmbushMoving" and Options.EntitiesPicker.Value["Ambush"] then
addESP(v,"Ambush")
end

if v.Name == "A60" and Options.EntitiesPicker.Value["A-60"] then
addESP(v,"A-60")
end

if v.Name == "A120" and Options.EntitiesPicker.Value["A-120"] then
addESP(v,"A-120")
end

if v.Name == "Eyes" and Options.EntitiesPicker.Value["Eyes"] then
addESP(v,"Eyes")
end

if v.Name == "BackdoorLookman" and Options.EntitiesPicker.Value["Lookman"] then
addESP(v,"Lookman")
end
if v.Name == "BackdoorRush" and Options.EntitiesPicker.Value["Blitz"] then
addESP(v,"Blitz")
end

if v.Name == "MonumentEntity" and Options.EntitiesPicker.Value["Monument"] then
addESP(v:WaitForChild("Top"),"Monument")
end
end
end)
)

Toggles.TransparencyCloset:OnChanged(function(Value)
if not Value then
for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
if v:FindFirstChild("HidePrompt") then
for _, base in ipairs(v:GetChildren()) do
if base:IsA("BasePart") and not (base.Name == "PlayerCollision" or base.Name == "Collision") then
base.Transparency = 0 
end
end
end
end
end
end)

table.insert(Connections,Character:GetAttributeChangedSignal("Hiding"):Connect(function()
 Closet = nil
if Character:GetAttribute("Hiding") == true then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v:FindFirstChild("HidePrompt") then
if v:FindFirstChild("HiddenPlayer") and v.HiddenPlayer.Value ~= nil then
Closet = v
end
end
end
else
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
if v:FindFirstChild("HidePrompt") then
for _, base in ipairs(v:GetChildren()) do
if base:IsA("BasePart") and not
(base.Name == "PlayerCollision" or base.Name == "Collision")  then
base.Transparency = 0
end
end
end
end
end
end)
)

print("RenderStepped")

table.insert(Connections,RunService.Heartbeat:Connect(function()
if alive then
if Toggles.AutoRooms and Toggles.AutoRooms.Value then
if ReplicatedStorage.GameData.LatestRoom.Value == 1000 then return end

if Toggles.AutoCloset.Value then
Toggles.AutoCloset:SetValue(false)
Library:Notify("禁用自动衣柜以使自动房间正常工作",4)
end
local entity2 = Workspace:FindFirstChild("A60") or Workspace:FindFirstChild("A120") or Workspace:FindFirstChild("GlitchRush") or Workspace:FindFirstChild("GlitchAmbush")

if entity2 and entity2.PrimaryPart and entity2.PrimaryPart.Position.Y > -6  then
local Locker = GetNearestLocker()

if Locker then
if not Locker:FindFirstChild("Hide") then
local Part = Instance.new("Part",Locker)
Part.Position = Locker.PrimaryPart.Position + Locker.PrimaryPart.CFrame.LookVector * 7
Part.Size = Vector3.new(1, 1, 1)
Part.CanCollide = false
Part.Transparency = 1
Part.Anchored = true
Part.Name = "Hide"
end

moveto(Locker:WaitForChild("Hide"))
if not LocalPlayer.Character.CollisionPart.Anchored then
fireproximityprompt(Locker:WaitForChild("HidePrompt"))
end

end

elseif not entity or entity.PrimaryPart.Position.Y < -9 then
LocalPlayer.Character:SetAttribute("Hiding",false)
moveto(workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door)
end
end
end 
end))

table.insert(Connections,RunService.RenderStepped:Connect(function()
alive = LocalPlayer:GetAttribute("Alive")
if alive then
if Toggles.Fullbright.Value then
Lighting.Ambient = Color3.fromRGB(255, 255, 255)
end

if Options.GMDropdown and Options.GMDropdown.Value == "Automation" then
local Entitys = workspace:FindFirstChild("RushMoving") or workspace:FindFirstChild("AmbushMoving") or workspace:FindFirstChild("GlitchRush") or workspace:FindFirstChild("GlitchAmbush") or workspace:FindFirstChild("BackdoorRush")

if Entitys and not Toggles.GodMode.Value then
Toggles.GodMode:SetValue(true)
elseif not Entitys and Toggles.GodMode.Value then
Toggles.GodMode:SetValue(false)
end
end

if Toggles.TransparencyCloset.Value then
if Closet then
for _, v in ipairs(Closet:GetChildren()) do
if v:IsA("BasePart") and  not (v.Name == "PlayerCollision" or v.Name == "Collision") then
v.Transparency = TransparencyValue
end
end
end
end

if Toggles.SpeedBoost.Value then
Character.Humanoid.WalkSpeed = Speed
end

if Toggles.Fieldofview.Value then
Workspace.CurrentCamera.FieldOfView = View
end

if Toggles.AutoCloset.Value then
local Closet = GetNearestCloset()
for _, v in ipairs(workspace:GetChildren()) do
local range = EntitysTable[v.Name]
if range and v.PrimaryPart then
if (LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <= range then 
if Closet then
if not LocalPlayer.Character.PrimaryPart.Anchored then
fireInteract(Closet:WaitForChild("HidePrompt"))
end
end
elseif (LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude > range then 
LocalPlayer.Character:SetAttribute("Hiding",false)
if not v:GetAttribute("Destroying") then
v:SetAttribute("Destroying",true)
v.Destroying:Connect(function()
LocalPlayer.Character:SetAttribute("Hiding",false)
end)
end
end
end
end
end

if Toggles.NoClosetExitDelay.Value then
if LocalPlayer.Character:GetAttribute("Hiding") == true then
if (Character.Humanoid.MoveDirection.Magnitude > 0.5)  then
RemoteFolder.CamLock:FireServer()
end
end
end 

if Toggles.NoCutscenes.Value then
if (ReplicatedStorage.GameData.LatestRoom.Value > 89) then
Toggles.NoCutscenes:SetValue(false)
end
end

if Toggles.InfiniteItems and Toggles.InfiniteItems.Value then
local hasTool = Character:FindFirstChild("Lockpick") or Character:FindFirstChild("SkeletonKey")
				if hasTool then
					for _, prompt in ipairs(InfStore) do
						if prompt and prompt.Parent and not prompt:GetAttribute("HasFake") == true then
							addFake(prompt, "Lockpick")
						end
					end
				end
			end
if Toggles.InfiniteSItems and Toggles.InfiniteSItems.Value then
local hasTool =  LocalPlayer.Character:FindFirstChild("Shears")
				if hasTool then
					for _, prompt in ipairs(InfSStore) do
						if prompt and prompt.Parent and not prompt:GetAttribute("HasFake") == true then
							addFake(prompt, "Shears")
						end
					end
				end
			end

if Toggles.Noacceleration.Value then
Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100,0.5,0.2)
Character.Collision.CustomPhysicalProperties = PhysicalProperties.new(100,0.5,0.2)
else
Character.HumanoidRootPart.CustomPhysicalProperties =  PhysicalProperties.new(0.4,0.2,0.2)
Character.Collision.CustomPhysicalProperties = PhysicalProperties.new(0.4,0.2,0.2)
end

if Toggles.AntiHear.Value and ReplicatedStorage:FindFirstChild("RemotesFolder") then
RemoteFolder.Crouch:FireServer(true)
end

if Toggles.Noclip.Value then
if alive then
LocalPlayer.Character.Collision.CanCollide = false
if LocalPlayer.Character.Collision:FindFirstChild("CollisionCrouch") then
LocalPlayer.Character.Collision.CollisionCrouch.CanCollide = false
end
if LocalPlayer.Character:FindFirstChild("CollisionPart")  then
LocalPlayer.Character:FindFirstChild("CollisionPart").CanCollide = false
end
LocalPlayer.Character.HumanoidRootPart.CanCollide = false
end
end
if Toggles.NoCameraShake.Value then
if alive then
RequiredMainGame.csgo = CFrame.new()
end
end
if  Toggles.DeleteFigure and Toggles.DeleteFigure.Value then
if alive then
local Figure = workspace.CurrentRooms:FindFirstChild("FigureRig",true)
if Figure and Figure:FindFirstChild("Root") and isnetworkowner(Figure.Root) then
if Figure:FindFirstChild("Root") then
Figure.Root.Size = Vector3.new(0.4, 2000, 0.4)
Figure.Root.CanCollide = false
Figure.Hitbox.CanCollide = false
end
end
end
end

if  Toggles.DeleteFigureFools and Toggles.DeleteFigureFools.Value then
if alive then
local Figure = workspace:FindFirstChild("FigureRagdoll",true)
if Figure and Figure:FindFirstChild("Root") and isnetworkowner(Figure.Root) then
if Figure:FindFirstChild("Root") then
Figure:PivotTo(Figure.Root.CFrame * CFrame.new(30, 900, 300))
Figure.Root.CanCollide = false
end
end
end
end

if Toggles.DoorReach.Value then
if alive then
local Door = workspace.CurrentRooms[ReplicatedStorage.GameData.LatestRoom.Value].Door
if Door and Door:FindFirstChild("ClientOpen") then
if (Character.HumanoidRootPart.Position - Door.Door.Position).Magnitude < Range then
Door.ClientOpen:FireServer()
end
end
end
end

if Toggles.ThirdPerson.Value then
if alive then
Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame * CFrame.new(X, Y, Z)
for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
if part:IsA("BasePart")  and part.Name == "Head" then
part.LocalTransparencyModifier = (Toggles.ThirdPerson.Value and 0) or 1
elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
part.Handle.LocalTransparencyModifier = (Toggles.ThirdPerson.Value and 0) or 1
end
end
end
end

if Toggles.AntiEyes.Value then
if alive then
if Workspace:FindFirstChild("Eyes") then
if RemoteFolder.Name == "Bricks" or RemoteFolder.Name == "EntityInfo" then
RemoteFolder.MotorReplication:FireServer(0, -100, 0, false)
else
RemoteFolder.MotorReplication:FireServer(-890)
end
end
end
end

if Toggles.AnticheatManipulation and Toggles.AnticheatManipulation.Value then
if alive then
Character:PivotTo(LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 10000))
end
end

if Toggles.SpectateEntity.Value then
if alive then
for _, entity in ipairs(workspace:GetChildren()) do
if SpectateTable[entity.Name] then
if entity.PrimaryPart then 
if Character:GetAttribute("Hiding") == true then
Workspace.Camera.CFrame = CFrame.lookAt(Workspace.CurrentCamera.CFrame.Position, entity.PrimaryPart.Position)
           end
      end
end
end
end
end

if Toggles.AntiLookman.Value then
if alive then
if Workspace:FindFirstChild("BackdoorLookman") then
RemoteFolder.MotorReplication:FireServer(-890)
end
end
end

if Fog then
Fog.Density = (Toggles.AntiFog.Value and 0) or 0.94
end
if Toggles.AntiFog.Value then
Lighting.FogEnd = 9e9
end

if Toggles.TransparencyCart.Value then
if Workspace.CurrentCamera and Workspace.CurrentCamera:FindFirstChild("MinecartRig") then
for _, v in ipairs(workspace.CurrentCamera.MinecartRig:GetChildren()) do
if v:IsA("BasePart") then
v.Transparency = CartTransparencyValue
end
end
end
end
if Toggles.FigureGodmode then
local Figure = workspace:FindFirstChild("FigureRagdoll", true)
if Figure then
for _, v in Figure:GetChildren() do
if v:IsA("BasePart") then
v.CanTouch = not Toggles.FigureGodmode.Value
end
end
end
end

if Toggles.AutoInteract.Value then
for _, prompt in ipairs(AutoInteractTable) do
if prompt and prompt.Parent then
local check = prompt:GetAttribute("Interactions")
if not check or check < 1 then
local Base
if prompt.Parent:IsA("BasePart") then
Base = prompt.Parent
elseif prompt.Parent.Parent and  prompt.Parent.Parent:IsA("BasePart") then
Base = prompt.Parent.Parent
elseif prompt.Parent and  prompt.Parent:FindFirstChildWhichIsA("BasePart") then
Base = prompt.Parent:FindFirstChildWhichIsA("BasePart")
else
if prompt.Parent.Parent and prompt.Parent.Parent:FindFirstChildOfClass("BasePart") then
Base = prompt.Parent.Parent:FindFirstChildOfClass("BasePart")
end
end
if Base and (LocalPlayer.Character.HumanoidRootPart.Position - Base.Position).Magnitude < prompt.MaxActivationDistance then
if prompt.Parent and prompt.Parent.Name == "GoldPile" and Options.IgnoreList.Value["黄金"] then return end
if prompt.Parent:GetAttribute("JeffShop")  and Options.IgnoreList.Value["Jeff物品"] then return end
if prompt.Parent.Parent and prompt.Parent.Parent.Name == "Drops" and Options.IgnoreList.Value["掉落物"] then return end
if prompt.Name == "ModulePrompt" and prompt.Parent and prompt.Parent.Name == "Hole" then return end
if prompt.Name == "ModulePrompt" and prompt.Parent and prompt.Parent.Name == "Mandrake" then return end
if prompt.Parent and prompt.Parent.Name == "Padlock" then return end
if prompt.Parent and prompt.Parent.Name == "KeyObtainFake" then return end
if prompt.ClickablePrompt then
fireInteract(prompt)
end
end
end
end
end
end

if CollisionClone and CollisionClone.Anchored then
CollisionClone.Anchored = false
end
if CollisionClone2 and CollisionClone2.Anchored then
CollisionClone2.Anchored = false
end
end
end))

table.insert(Connections,LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
if Toggles.AntiSnare.Value then
if Floor.Value == "Garden" then
for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
if room:FindFirstChild("Snares") then
for _, v in ipairs(room.Snares:GetChildren()) do
if v.Name == "Snare" then
v:WaitForChild("Hitbox",9e9).CanTouch = false
end
end
end
end
else
for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
if room:FindFirstChild("Assets") then
for _, v in ipairs(room.Assets:GetChildren()) do
if v.Name == "Snare" then
v:WaitForChild("Hitbox",9e9).CanTouch = false
end
end
end
end
end
end
if Toggles.AntiDupe.Value then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetChildren()) do
if v and v.Name == "SideroomDupe" then
v:WaitForChild("DoorFake",9e9):WaitForChild("Hidden",9e9).CanTouch = false
end
end

for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetChildren()) do
if v.Name == "SideroomDupe" then
if v:WaitForChild("DoorFake"):FindFirstChild("Lock") then
v:WaitForChild("DoorFake"):FindFirstChild("Lock"):FindFirstChildOfClass("ProximityPrompt").Enabled =  not Toggles.AntiDupe.Value 
end
end
end

if Toggles.AntiGiggle and Toggles.AntiGiggle.Value then
for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetChildren()) do
if v.Name == "GiggleCeiling" then
v:WaitForChild("Hitbox",9e9).CanTouch = false
end
end
end

if Toggles.AntiVacuum.Value then
for _, v in ipairs(workspace.CurrentRooms:GetChildren()) do
if v.Name == "SideroomSpace" then
v:WaitForChild("Collision").CanTouch = false
v:WaitForChild("Collision").CanCollide = true
end
end
end

if Toggles.Door.Value then
local room = LocalPlayer:GetAttribute("CurrentRoom")
local lastroom = room - 1
local Door = workspace.CurrentRooms[lastroom].Door.Door
if Door then
ESPLibrary:RemoveESP(Door)
end

local Door = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")].Door.Door
if not Door:GetAttribute("Used") then
AddESP(Door, (Door.Parent:FindFirstChild("Lock") and "[已锁定] " or "") .. "门 " .. Door.Parent:GetAttribute("RoomID"), DoorColor)
end
end
if Toggles.EntityNotifys.Value then
local v = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:FindFirstChild("Groundskeeper",true)
if v and Options.EntitiesPicker.Value["Groundskeeper"] then
Library:Notify("园丁已生成",3)
Sound()
end
end

if Toggles.Ladder and Toggles.Ladder.Value then
local v = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:FindFirstChild("Ladder",true)
if v then
AddESP(v,"梯子",Color3.new(0,3,2))
end
end

if Toggles.Key.Value then
local v = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("KeyObtain",true)
if v and not v:GetAttribute("Used") then
AddESP(v,"钥匙",KeyColor)
end
end
if Toggles.GateLever.Value then
local Lever = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("Assets"):FindFirstChild("LeverForGate")
if Lever then 
AddESP(Lever,"杠杆 ",GateLeverColor)
end
end
if Toggles.EntitesESP.Value and Options.EntitiesPicker.Value["Figure"] then
local Figure = workspace.CurrentRooms:FindFirstChild("FigureRig",true) or workspace.CurrentRooms:FindFirstChild("FigureRagdoll",true)
if Figure then
addESP(Figure,"Figure")
end
end
if Toggles.EntitesESP.Value and Options.EntitiesPicker.Value["Bramble"] then
local Entity = workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:FindFirstChild("LiveEntityBramble",true)
if Entity then
addESP(Entity,"Bramble")
end
end
if Toggles.Generator and Toggles.Generator.Value then
local v = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("GeneratorMain",true)
if v then 
AddESP(v,"发电机",GeneratorColor)
end
end
if Toggles.TimerLever.Value then
local v = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("TimerLever",true)
if v then
AddESP(v,"计时器杠杆",TimerLeverColor)
end
end
if Toggles.HidingSpot.Value then
if ReplicatedStorage:FindFirstChild("RemotesFolder") then
local room = LocalPlayer:GetAttribute("CurrentRoom")
if room and room > 0 then
local lastroom = room - 1
for _, v in ipairs(workspace.CurrentRooms[lastroom]:GetDescendants()) do
local TextName = HidingSpots[v.Name]
if TextName and v.PrimaryPart then
ESPLibrary:RemoveESP(v)
end
end
end
end

for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:FindFirstChild("Assets",true):GetChildren()) do
local TextName = HidingSpots[v.Name]
if TextName and v.PrimaryPart then
AddESP(v,TextName,HidingSpotColor)
end
end
end
end)
)

Toggles.NoCutscenes:OnChanged(function(Value)
local CutScenes = RemoteListener:FindFirstChild("Cutscenes") or RemoteListener:FindFirstChild("_Cutscenes")
CutScenes.Name = Value and "_Cutscenes" or "Cutscenes"
end)

Toggles.EnableJump:OnChanged(function(Value)
if Character then
Character:SetAttribute("CanJump",Value)
end
end)
print("hi0")

local InfiniteTable = {
    Chest_Vine = true, CuttableVines = true, Cellar = true,
UnlockPrompt = true, ThingToEnable = true, LockPrompt = true, SkullPrompt = true, FusesPrompt = true,
ChestBoxLocked = true, Locker_Small_Locked = true, Toolbox_Locked = true
}

local ImportantNames = {
    LiveObstructionNew = true,
LiveObstructionNewIntro = true,
    ChandelierObstruction = true,
    Seek_Arm = true,
    Egg = true,
    LiveHintBook = true,
    LiveBreakerPolePickup = true,
    Lever = true,
    MinesAnchor = true,
    VineGuillotine = true,
 GoldPile = true,
FuseObtain = true,
    Toolbox = true,
    CuttableVines = true, Cellar = true,
UnlockPrompt = true, ThingToEnable = true, LockPrompt = true, SkullPrompt = true, FusesPrompt = true,
Locker_Small_Locked = true, Toolbox_Locked = true,
    Flashlight = true,
    Lockpick = true,
    Vitamins = true,
    Bandage = true,
    StarVial = true,
    StarBottle = true,
    StarJug = true,
    Shakelight = true,
    Straplight = true,
    Bulklight = true,
    Battery = true,
    Candle = true,
    Crucifix = true,
    CrucifixWall = true,
    Glowsticks = true,
    SkeletonKey = true,
    Candy = true,
    ShieldMini = true,
    ShieldBig = true,
    BandagePack = true,
    BatteryPack = true,
    RiftCandle = true,
    LaserPointer = true,
    HolyGrenade = true,
    Shears = true,
    Smoothie = true,
    Cheese = true,
    Bread = true,
    AlarmClock = true,
    RiftSmoothie = true,
    GweenSoda = true,
    GlitchCub = true,
    RiftJar = true,
    Compass = true,
    Lantern = true,
    Multitool = true,
    Lotus = true,
    TipJar = true,
    LotusPetalPickup = true,
    KeyIron = true,
    Donut = true,
    Toolshed_Small = true,
    Chest_Vine = true,
    ChestBoxLocked = true,
    ChestBox = true,
    StardustPickup = true,
ElevatorBreaker = true,
WaterPump = true,
GrumbleRig = true,
PowerupPad = true,
SeekGuidingLight = true,
DoorNormal = true,
DoorFrame = true,
Luggage_Cart_Crouch = true,
Carpet = true,
Floor = true,
CarpetLight = true,
Luggage_Cart = true,
DropCeiling = true,
End_DoorFrame = true,
SeeThroughGlass = true,
Start_DoorFrame = true,
TriggerEventCollision = true,
DoorLattice = true,
Collision = true
}

 table.insert(Connections,
 workspace.DescendantAdded:Connect(function(v)
local Delay = math.random(200, 270) / 1000
task.wait(Delay)

if   v:IsA("ProximityPrompt") then
if Toggles.AutoInteract.Value then
if v then
if not Ignore[v.Name] then
if v:IsA("ProximityPrompt") then
table.insert(AutoInteractTable,v)
end
end
end
end

if Toggles.PromptReach.Value then
v:SetAttribute("Distance",v.MaxActivationDistance)
v.MaxActivationDistance = v.MaxActivationDistance * 2
end

if Toggles.PromptClip.Value then
v.RequiresLineOfSight = false 
end

if Toggles.InstantPrompt.Value then
v:SetAttribute("Hold",v.HoldDuration)
v.HoldDuration =  0
end
end

if Toggles.AntiLag.Value then
if v:IsA("BasePart") then
v.Material = Enum.Material.Plastic
end
if v.Name == "LightFixture" or v.Name == "Carpet" or v.Name == "CarpetLight" then
v:Destroy()
end
if v:IsA("Texture") then
v:Destroy()
end
end

if not ImportantNames[v.Name] then return end

if Toggles.AutoDoors and Toggles.AutoDoors.Value then
if  Objects[v.Name] then 
canhit(v)
end
if v.Name == "LiveObstructionNew" or v.Name == "LiveObstructionNewIntro"  then
canhit(v:WaitForChild("Collision"))
end
if not v:IsA("Part") and v.Name == "SeeThroughGlass" then
canhit(
v
)
end
if v.Name == "Collision" and v.Parent and v.Parent.Name == "Parts" then
v.CanCollide = false 
end
if v.Name == "DoorLattice" then
canhit(v:WaitForChild("Door",9e9))
end
end

if Toggles.AutoBreakerBox.Value then
if v.Name == "ElevatorBreaker" then 
Breaker = v
end
end
if Toggles.WaterPump and Toggles.WaterPump.Value then
if v.Name == "WaterPump" then
AddESP(v,"水泵",Color3.new(0,1,0))
end
end

if Toggles.InfiniteSItems and Toggles.InfiniteSItems.Value then
if ShearsParents[v.Name] or ShearsNames[v.Name] then
if v:IsA("ProximityPrompt") then
table.insert(InfSStore,v)
else
table.insert(InfSStore,v:FindFirstChildOfClass("ProximityPrompt"))
end
end
end

if Toggles.InfiniteItems and Toggles.InfiniteItems.Value then
if LockpickNames[v.Name] or LockpickParents[v.Name] then
if v:IsA("ProximityPrompt") then
table.insert(InfStore,v)
else
table.insert(InfStore,v:FindFirstChildOfClass("ProximityPrompt"))
end
end
end

if Toggles.ShowSeekPath and Toggles.ShowSeekPath.Value then
showpath(v)
end

if Toggles.AntiSeekObstructions.Value then
if v.Name == "ChandelierObstruction" or v.Name == "Seek_Arm" then
for _, part in ipairs(v:GetChildren()) do
if part:IsA("BasePart") then part.CanTouch = false
end
end
end
end

if Toggles.Books.Value then
if v.Name == "LiveHintBook" then
AddESP(v,"书籍",BooksColor)
end
end

if Toggles.Breaker.Value then
if v.Name == "LiveBreakerPolePickup" then
AddESP(v,"断路器",BreakerColor)
end
end

if Toggles.EntitesESP.Value  and  v.Name == "Groundskeeper" and Options.EntitiesPicker.Value["Groundskeeper"] then
addESP(v,"园丁")
end

if Toggles.AntiGloomPile and Toggles.AntiGloomPile.Value then
if v.Name == "Egg" then v.CanTouch = false
end
end

if Toggles.Anchor and Toggles.Anchor.Value then
if v.Name == "MinesAnchor" then
AddESP(v,"锚点 " ..  v:WaitForChild("Sign").TextLabel.Text,AnchorColor)
end
end

if Toggles.Items.Value then
local name = Item[v.Name]
if name then
AddESP(v,name,ItemsColor)
end
end

if Toggles.Fuse and Toggles.Fuse.Value then
if v.Name == "FuseObtain" then
AddESP(v,"保险丝",FuseColor)
end
end

if v.Name == "GrumbleRig" and Options.EntitiesPicker.Value["Grumble"] then
addESP(v,"Grumble")
end

if Toggles.Gold.Value then
if v.Name == "GoldPile" then
AddESP(v,"黄金 " .. v:GetAttribute("GoldValue"),GoldColor)
end
end

if (Floor.Value == "Garden") and Toggles.LeverESP.Value then
if v and v.Parent and v.Parent.Name == "VineGuillotine" and v.Name == "Lever" then
AddESP(v,"杠杆",Color3.new(0,1,0))
end
end
if Toggles.AutoGetPowerUps and Toggles.AutoGetPowerUps.Value and  v.Name == "PowerupPad" then
v:WaitForChild("Hitbox",9e9).Size = Vector3.new(90, 90, 90)
end
end))

local old
print("Hi1")

if  not Disable5 then
old = hookmetamethod(game,"__namecall",newcclosure(function(self, ...)
local args = { ... }
local method = getnamecallmethod()

if self.Name == "ClutchHeartbeat" and method == "FireServer" and Toggles.AutoHeartbeatMiniGame.Value then
args[1] = true
return old(self,unpack(args()))
end

return old(self, ...)
end))
end

print("hi2")

function Unload()
if AutoDoorsConnection then
AutoDoorsConnection:Disconnect()
AutoDoorsConnection = nil
end
LocalPlayer.Character.Head.PointLight.Brightness = 1
LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)

if workspace:FindFirstChild("Path Node") then
workspace:FindFirstChild("Path Node"):Destroy()
end

LocalPlayer:SetAttribute("mshaxLoaded",false)
Library.Unloaded = true
for i, Toggle in ipairs(Toggles) do
Toggle:SetValue(false)
end
for _, Connection in ipairs(Connections) do
Connection:Disconnect()
end

Library:Unload()
ESPLibrary:Unload()

if Character.HumanoidRootPart:FindFirstChild("FlyBodyVelocity") then
Character.HumanoidRootPart:FindFirstChild("FlyBodyVelocity"):Destroy()
end
if Character.HumanoidRootPart:FindFirstChild("FlyBodyGyro") then
Character.HumanoidRootPart:FindFirstChild("FlyBodyGyro"):Destroy()
end
if RemoteFolder:FindFirstChild("Crouch") then
RemoteFolder.Crouch:FireServer(false)
end

Character.Humanoid.PlatformStand = false 
Character:SetAttribute("CanJump",false)
if FakeSurge then
FakeSurge:Destroy()
end
if ReplicatedStorage:FindFirstChild("SurgeRemote") then
ReplicatedStorage.SurgeRemote.Parent = ReplicatedStorage.RemotesFolder
end
if ClientModules.EntityModules:FindFirstChild("_Shade") then
ClientModules.EntityModules:FindFirstChild("_Shade").Name = "Shade"
end
if Modules:FindFirstChild("_A90") then
Modules:FindFirstChild("_A90").Name = "A90"
end
if Modules:FindFirstChild("_Screech") then
Modules:FindFirstChild("_Screech").Name = "Screech"
end
if Modules:FindFirstChild("_Dread") then
Modules:FindFirstChild("_Dread").Name = "Dread"
end
if RemoteListener:FindFirstChild("_Cutscenes") then
RemoteListener:FindFirstChild("_Cutscenes").Name = "Cutscenes"
end
if Character:FindFirstChild("_CollisionPart") then
Character:FindFirstChild("_CollisionPart"):Destroy()
end
if Character:FindFirstChild("_CollisionPart2") then
Character:FindFirstChild("_CollisionPart2"):Destroy()
end
if Character.Collision:FindFirstChild("CollisionCrouch") then
Character.Collision.CollisionCrouch.Size = Vector3.new(0.5, 1.5, 3)
end
if Character.Collision then
Character.Collision.Size = Vector3.new(5.5, 3, 5)
end
if Character.Humanoid then
Character.Humanoid.HipHeight = 2.4
end
if Character.HumanoidRootPart then
Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.4,0.2,0.2)
end
if Character.Collision then
Character.Collision.CustomPhysicalProperties = PhysicalProperties.new(0.4,0.2,0.2)
end
if Character.Humanoid then
Character.Humanoid.WalkSpeed = 15
end
if Finish then
Finish:Disconnect()
end
if Hold then
Hold:Disconnect()
end
if NewCharacter then
NewCharacter:Disconnect()
end
if JumpConnection then
JumpConnection:Disconnect()
end
if RankedAntiBananaConnection then
RankedAntiBananaConnection:Disconnect()
end
if InfiniteCrucifixConnection then
InfiniteCrucifixConnection:Disconnect()
end
if PlayersConnection then
PlayersConnection:Disconnect()
end
if old then
hookmetamethod(game,"__namecall",old)
end
end

Tabs.UISettings:AddButton("Unload", Unload)

local MenuGroup = Tabs.UISettings:AddRightGroupbox('菜单')

MenuGroup:AddButton('复制 Discord 邀请', function()
    setclipboard('https://discord.gg/obsidian')
    Library:Notify('已复制 Discord 邀请到剪贴板', 5)
end)

MenuGroup:AddButton('复制脚本', function()
    setclipboard('https://raw.githubusercontent.com/mstudio45/Obsidian/main/Doors_complete_merged.lua')
    Library:Notify('已复制脚本链接到剪贴板', 5)
end)

MenuGroup:AddButton('复制 GitHub', function()
    setclipboard('https://github.com/mstudio45/Obsidian')
    Library:Notify('已复制 GitHub 链接到剪贴板', 5)
end)

MenuGroup:AddLabel('菜单键'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = '菜单键' })
Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('Obsidian')
SaveManager:SetFolder('Obsidian/DOORS')
SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)

AddonBox:AddButton('Obby', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/Obby"))()
end)
AddonBox:AddButton('FE Trolling GUI', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/FE%20Trolling%20GUI"))()
end)
AddonBox:AddButton('Animation GUI', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/Animation%20GUI"))()
end)
AddonBox:AddButton('Chat Bypasser', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/Chat%20Bypasser"))()
end)
AddonBox:AddButton('Infinite Yield', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/Infinite%20Yield"))()
end)
AddonBox:AddButton('Fly GUI V3', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/Fly%20GUI%20V3"))()
end)
AddonBox:AddButton('CMD-X', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/CMD-X"))()
end)
AddonBox:AddButton('Reviz Admin', function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/Reviz%20Admin"))()
end)

Library:Notify("StarLight已加载",3)
Sound()
end