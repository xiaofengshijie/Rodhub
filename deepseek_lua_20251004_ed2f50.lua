local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local PathfindingService = game:GetService("PathfindingService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local repo = 'https://raw.githubusercontent.com/mstudio45/Obsidian/main/'
local Library = loadstring(game:HttpGet(repo..'Library.lua'))()
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheHunterSolo1/Scripts/main/ESPLibrary"))()

local Connections = {}
local alive = false
local Character = LocalPlayer.Character
local Floor = ReplicatedStorage.GameData.Floor
local notifysound = 4590657391
local PlayingSound = true

LocalPlayer:SetAttribute("mshaxLoaded",true)

Window = Library:CreateWindow({
    Title = 'mshax v4.5 | DOORS ',
    Center = true,
    AutoShow = true
})

Tabs = {
    Main = Window:AddTab('Main'),
    Player = Window:AddTab('Player'),
    Exploits = Window:AddTab('Exploits'),
    Visuals = Window:AddTab('Visuals'),
    Floor = Window:AddTab('Floor'),
    UISettings = Window:AddTab('Config')
}

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
local AnchorColor = Color3.new(0,0,1)
local EntityColor = Color3.new(1, 0, 0)

ESP = Tabs.Visuals:AddRightGroupbox('Esp')
SettingsESP = Tabs.Visuals:AddLeftGroupbox('Settings')
FloorESP = Tabs.Floor:AddRightGroupbox('ESP')
NotifyBox = Tabs.Main:AddLeftTabbox():AddTab("Notifying / ESP")
Movement = Tabs.Player:AddLeftTabbox():AddTab("Movement")
Anti = Tabs.Exploits:AddLeftTabbox():AddTab("Entitys")
Bypass = Tabs.Exploits:AddLeftTabbox():AddTab("Bypass")
SettingsBox = Tabs.UISettings:AddRightGroupbox('UI')
ModifiersBox = Tabs.Floor:AddLeftGroupbox('Modifiers')
FloorAnti = Tabs.Floor:AddLeftGroupbox('Entites Bypass')

local ESPObjects = {}
local EntityESPObjects = {}
local ESPEnabled = false

function Sound()
    local sound = Instance.new("Sound",SoundService)
    sound.Volume = 2.5
    sound.SoundId = "rbxassetid://" .. notifysound 
    sound.Playing = PlayingSound
    Debris:AddItem(sound,2)
end

function AddESP(obj, text, color)
    if obj and obj.Parent and not ESPObjects[obj] then
        ESPLibrary:AddESP(obj, text, color)
        ESPObjects[obj] = true
    end
end

function RemoveESP(obj)
    if obj and ESPObjects[obj] then
        ESPLibrary:RemoveESP(obj)
        ESPObjects[obj] = nil
    end
end

function ClearAllESP()
    for obj in pairs(ESPObjects) do
        ESPLibrary:RemoveESP(obj)
    end
    ESPObjects = {}
    
    for obj in pairs(EntityESPObjects) do
        ESPLibrary:RemoveESP(obj)
    end
    EntityESPObjects = {}
end

function UpdatePlayersESP()
    if not Toggles.Players or not Toggles.Players.Value then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            AddESP(plr.Character, plr.Name, PlayersColor)
        end
    end
end

function UpdateDoorESP()
    if not Toggles.Door or not Toggles.Door.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        if room:FindFirstChild("Door") and room.Door:FindFirstChild("Door") then
            local door = room.Door.Door
            if not door:GetAttribute("Used") then
                AddESP(door, (door.Parent:FindFirstChild("Lock") and "Locked " or "") .. "Door " .. door.Parent:GetAttribute("RoomID"), DoorColor)
            end
        end
    end
end

function UpdateKeyESP()
    if not Toggles.Key or not Toggles.Key.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        local key = room:FindFirstChild("KeyObtain", true)
        if key and not key:GetAttribute("Used") then
            AddESP(key, "Key", KeyColor)
        end
    end
end

local HidingSpots = {
    Wardrobe = "Closet",
    Rooms_Locker = "Locker",
    Backdoor_Wardrobe = "Closet",
    Toolshed = "Closet",
    Locker_Large = "Locker",
    Bed = "Bed",
    CircularVent = "Vent",
    Rooms_Locker_Fridge = "Fridge",
    RetroWardrobe = "Closet",
    Dumpster = "Dumpster",
    Double_Bed = "Double Bed"
}

function UpdateHidingSpotESP()
    if not Toggles.HidingSpot or not Toggles.HidingSpot.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        local assets = room:FindFirstChild("Assets", true)
        if assets then
            for _, v in ipairs(assets:GetChildren()) do
                local textName = HidingSpots[v.Name]
                if textName and v.PrimaryPart then
                    AddESP(v, textName, HidingSpotColor)
                end
            end
        end
    end
end

local ItemList = {
    Flashlight = "Flash Light",
    Lockpick = "Lock Pick",
    Vitamins = "Vitamin",
    Bandage = "Bandage",
    StarVial = "Star Vial",
    StarBottle = "Star Bottle",
    StarJug = "Star Jug",
    Shakelight = "Shake Light",
    Straplight = "Strap Light",
    Bulklight = "Bulk Light",
    Battery = "Battery",
    Candle = "Candle",
    Crucifix = "Crucifix",
    CrucifixWall = "Crucifix",
    Glowsticks = "Glow Stick",
    SkeletonKey = "Skeleton Key",
    Candy = "Candy",
    ShieldMini = "Mini Shield",
    ShieldBig = "Big Shield",
    BandagePack = "Bandage Pack",
    BatteryPack = "Battery Pack",
    RiftCandle = "Moonlight Candle",
    LaserPointer = "Laser Pointer",
    HolyGrenade = "Holy Grenade",
    Shears = "Shears",
    Smoothie = "Smoothie",
    Cheese = "Cheese",
    Bread = "Bread",
    AlarmClock = "Alarm Clock",
    RiftSmoothie = "Moonlight Smoothie",
    GweenSoda = "Gween Soda",
    GlitchCub = "Glitch Cube",
    RiftJar = "Rift Jar",
    Compass = "Compass",
    Lantern = "Lantern",
    Multitool = "Multi Tool",
    Lotus = "Lotus",
    TipJar = "Jeff Tip",
    LotusPetalPickup = "Lotus Petal",
    KeyIron = "Iron Key",
    Donut = "Donut",
    Toolshed_Small = "Shears Toolshed",
    Chest_Vine = "Chest Vine",
    ChestBoxLocked = "Locked Chest",
    ChestBox = "Chest",
    StardustPickup = "Star Dust"
}

function UpdateItemsESP()
    if not Toggles.Items or not Toggles.Items.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        for _, obj in ipairs(room:GetDescendants()) do
            local itemName = ItemList[obj.Name]
            if itemName and obj.PrimaryPart then
                AddESP(obj, itemName, ItemsColor)
            end
        end
    end
end

function UpdateGoldESP()
    if not Toggles.Gold or not Toggles.Gold.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        for _, obj in ipairs(room:GetDescendants()) do
            if obj.Name == "GoldPile" then
                AddESP(obj, "Gold " .. (obj:GetAttribute("GoldValue") or "0"), GoldColor)
            end
        end
    end
end

function UpdateBooksESP()
    if not Toggles.Books or not Toggles.Books.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        for _, obj in ipairs(room:GetDescendants()) do
            if obj.Name == "LiveHintBook" then
                AddESP(obj, "Book", BooksColor)
            end
        end
    end
end

function UpdateBreakerESP()
    if not Toggles.Breaker or not Toggles.Breaker.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        for _, obj in ipairs(room:GetDescendants()) do
            if obj.Name == "LiveBreakerPolePickup" then
                AddESP(obj, "Breaker", BreakerColor)
            end
        end
    end
end

function UpdateGateLeverESP()
    if not Toggles.GateLever or not Toggles.GateLever.Value then return end
    
    for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
        for _, obj in ipairs(room:GetDescendants()) do
            if obj.Name == "LeverForGate" then
                AddESP(obj, "Gate Lever", GateLeverColor)
            end
        end
    end
end

function UpdateEntityESP()
    if not Toggles.EntitesESP or not Toggles.EntitesESP.Value then return end
    
    for _, entity in ipairs(workspace:GetChildren()) do
        if entity:IsA("Model") and entity.PrimaryPart then
            local entityName = entity.Name
            if string.find(entityName, "Rush") or string.find(entityName, "Ambush") or string.find(entityName, "A60") or string.find(entityName, "A120") or entityName == "Eyes" or entityName == "FigureRig" or entityName == "GlitchRush" or entityName == "GlitchAmbush" then
                if not EntityESPObjects[entity] then
                    AddESP(entity, entityName, EntityColor)
                    EntityESPObjects[entity] = true
                end
            end
        end
    end
end

function UpdateAllESP()
    if not ESPEnabled then return end
    
    UpdatePlayersESP()
    UpdateDoorESP()
    UpdateKeyESP()
    UpdateHidingSpotESP()
    UpdateItemsESP()
    UpdateGoldESP()
    UpdateBooksESP()
    UpdateBreakerESP()
    UpdateGateLeverESP()
    UpdateEntityESP()
end

ESP:AddToggle('Players',{
    Text = "Players ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    RemoveESP(plr.Character)
                end
            end
        end
    end
}):AddColorPicker('PlayersColo', {
    Default = PlayersColor,
    Title = 'Players Color',
    Transparency = 0,
    Callback = function(Value)
        PlayersColor = Value
    end
})

ESP:AddToggle('Door',{
    Text = "Door",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                if room:FindFirstChild("Door") then
                    RemoveESP(room.Door.Door)
                end
            end
        end
    end
}):AddColorPicker('DoorColo', {
    Default = DoorColor,
    Title = 'Door Color',
    Transparency = 0,
    Callback = function(Value)
        DoorColor = Value
    end
})

ESP:AddToggle('Key',{
    Text = "Key",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                local key = room:FindFirstChild("KeyObtain", true)
                if key then
                    RemoveESP(key)
                end
            end
        end
    end
}):AddColorPicker('KeyColo', {
    Default = KeyColor,
    Title = 'Key Color',
    Transparency = 0,
    Callback = function(Value)
        KeyColor = Value
    end
})

ESP:AddToggle('HidingSpot',{
    Text = "Closet ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                local assets = room:FindFirstChild("Assets", true)
                if assets then
                    for _, v in ipairs(assets:GetChildren()) do
                        if HidingSpots[v.Name] then
                            RemoveESP(v)
                        end
                    end
                end
            end
        end
    end
}):AddColorPicker('HidingSpot', {
    Default = HidingSpotColor,
    Title = 'Hiding Place Color',
    Transparency = 0,
    Callback = function(Value)
        HidingSpotColor = Value
    end
})

ESP:AddToggle('Items',{
    Text = "Items ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                for _, obj in ipairs(room:GetDescendants()) do
                    if ItemList[obj.Name] then
                        RemoveESP(obj)
                    end
                end
            end
        end
    end
}):AddColorPicker('ItemsColo', {
    Default = ItemsColor,
    Title = 'Items Color',
    Transparency = 0,
    Callback = function(Value)
        ItemsColor = Value
    end
})

ESP:AddToggle('Gold',{
    Text = "Gold ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                for _, obj in ipairs(room:GetDescendants()) do
                    if obj.Name == "GoldPile" then
                        RemoveESP(obj)
                    end
                end
            end
        end
    end
}):AddColorPicker('GoldColor', {
    Default = GoldColor,
    Title = 'Gold Color',
    Transparency = 0,
    Callback = function(Value)
        GoldColor = Value
    end
})

ESP:AddToggle('Books',{
    Text = "Books",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                for _, obj in ipairs(room:GetDescendants()) do
                    if obj.Name == "LiveHintBook" then
                        RemoveESP(obj)
                    end
                end
            end
        end
    end
}):AddColorPicker('BooksColo', {
    Default = BooksColor,
    Title = 'Books Color',
    Transparency = 0,
    Callback = function(Value)
        BooksColor = Value
    end
})

ESP:AddToggle('Breaker',{
    Text = "Breaker",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                for _, obj in ipairs(room:GetDescendants()) do
                    if obj.Name == "LiveBreakerPolePickup" then
                        RemoveESP(obj)
                    end
                end
            end
        end
    end
}):AddColorPicker('BreakerColo', {
    Default = BreakerColor,
    Title = 'Breaker Color',
    Transparency = 0,
    Callback = function(Value)
        BreakerColor = Value
    end
})

ESP:AddToggle('GateLever',{
    Text = "Gate Lever",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                for _, obj in ipairs(room:GetDescendants()) do
                    if obj.Name == "LeverForGate" then
                        RemoveESP(obj)
                    end
                end
            end
        end
    end
}):AddColorPicker('GateLeverColo', {
    Default = GateLeverColor,
    Title = 'Gate Lever Color',
    Transparency = 0,
    Callback = function(Value)
        GateLeverColor = Value
    end
})

NotifyBox:AddDropdown("EntitiesPicker", {
    Values = {"Rush","Ambush","A-60","A-120","Bramble","Grumble","Eyes","Lookman","Blitz","Figure","GlitchRush","GlitchAmbush","Monument","Groundskeeper"},
    Default = 1,
    Multi = true,
    Text = "Entities",
    Callback = function(Value) end,
})

NotifyBox:AddToggle('EntityNotifys',{
    Text = "Entity Notifys",
    Default = false
})

NotifyBox:AddToggle('EntitesESP',{
    Text = "Entities ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = true
        if not Value then
            for entity in pairs(EntityESPObjects) do
                RemoveESP(entity)
            end
            EntityESPObjects = {}
        end
    end
}):AddColorPicker('EntityColor', {
    Default = EntityColor,
    Title = 'Entity Color',
    Transparency = 0,
    Callback = function(Value)
        EntityColor = Value
    end
})

local EntityTable = {
    RushMoving = "Rush",
    AmbushMoving = "Ambush", 
    A60 = "A-60",
    A120 = "A-120",
    Eyes = "Eyes",
    GlitchRush = "Glitch Rush",
    GlitchAmbush = "Glitch Ambush",
    MonumentEntity = "Monument",
    Groundskeeper = "Groundskeeper",
    BackdoorRush = "Blitz",
    BackdoorLookman = "Lookman",
    FigureRig = "Figure"
}

table.insert(Connections, workspace.ChildAdded:Connect(function(v)
    if Toggles.EntityNotifys and Toggles.EntityNotifys.Value then
        local entityName = EntityTable[v.Name]
        if entityName and Options.EntitiesPicker.Value[entityName] then
            Library:Notify(entityName .. " Has Spawned", 3)
            Sound()
        end
    end
end))

Anti:AddToggle('AntiDread',{
    Text = "Anti-Dread",
    Default = false,
    Callback = function(Value)
        local Dread = game:GetService("ReplicatedStorage"):FindFirstChild("Dread") or game:GetService("ReplicatedStorage"):FindFirstChild("_Dread")
        if Dread then
            Dread.Name = Value and "_Dread" or "Dread"
        end
    end
})

Anti:AddToggle('AntiScreech',{
    Text = "Anti-Screech",
    Default = false,
    Callback = function(Value)
        local Screech = game:GetService("ReplicatedStorage"):FindFirstChild("Screech") or game:GetService("ReplicatedStorage"):FindFirstChild("_Screech")
        if Screech then
            Screech.Name = Value and "_Screech" or "Screech"
        end
    end
})

Anti:AddToggle('AntiA90',{
    Text = "Anti-A90",
    Default = false,
    Callback = function(Value)
        local A90 = game:GetService("ReplicatedStorage"):FindFirstChild("A90") or game:GetService("ReplicatedStorage"):FindFirstChild("_A90")
        if A90 then
            A90.Name = Value and "_A90" or "A90"
        end
    end
})

Anti:AddToggle('AntiEyes',{
    Text = "Anti-Eyes",
    Default = false
})

Anti:AddToggle('AntiHalt',{
    Text = "Anti-Halt",
    Default = false,
    Callback = function(Value)
        local Halt = game:GetService("ReplicatedStorage").ClientModules.EntityModules:FindFirstChild("Shade") or game:GetService("ReplicatedStorage").ClientModules.EntityModules:FindFirstChild("_Shade")
        if Halt then
            Halt.Name = Value and "_Shade" or "Shade"
        end
    end
})

Anti:AddToggle('AntiSnare',{
    Text = "Anti-Snare",
    Default = false,
    Callback = function(Value)
        for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
            for _, v in ipairs(room:GetDescendants()) do
                if v.Name == "Snare" then
                    local hitbox = v:FindFirstChild("Hitbox")
                    if hitbox then
                        hitbox.CanTouch = not Value
                    end
                end
            end
        end
    end
})

Anti:AddToggle('AntiDupe',{
    Text = "Anti-Dupe",
    Default = false,
    Callback = function(Value)
        for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
            for _, v in ipairs(room:GetDescendants()) do
                if v.Name == "DoorFake" then
                    local hidden = v:FindFirstChild("Hidden")
                    if hidden then
                        hidden.CanTouch = not Value
                    end
                end
            end
        end
    end
})

Anti:AddToggle('AntiHear',{
    Text = "Anti-Figure-Hearing",
    Default = false
})

local Speed = 15
Movement:AddSlider("SpeedBoostSlider", {
    Text = "Speed Boost Slider",
    Default = 15,
    Min = 15,
    Max = 21,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        Speed = Value
    end
})

Movement:AddToggle('SpeedBoost',{
    Text = "Speed Boost",
    Default = false
})

Bypass:AddToggle('SpeedBypass',{
    Text = "Speed Bypass",
    Default = false,
    Callback = function(Value)
        Options.SpeedBoostSlider:SetMax(Value and 75 or 21)
        Options.SpeedBoostSlider:SetValue(Value and math.min(Options.SpeedBoostSlider.Value, 75) or math.min(Options.SpeedBoostSlider.Value, 21))
        Options.FlySpeed:SetMax(Value and 75 or 21)
        Options.FlySpeed:SetValue(Value and math.min(Options.FlySpeed.Value, 75) or math.min(Options.FlySpeed.Value, 21))
    end
})

Fly = {
    Enabled = false,
    Speed = 15,
    FlyBody = nil,
    FlyGyro = nil
}

local renderConn
local charAddedConn

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
    local cam = Workspace.CurrentCamera
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
    local cam = Workspace.CurrentCamera
    if not humanoid or not root or not Fly.FlyBody or not Fly.FlyGyro or not cam then return end

    local dir = Vector3.zero

    if UserInputService.KeyboardEnabled then
        local forward = UserInputService:IsKeyDown(Enum.KeyCode.W)
        local back = UserInputService:IsKeyDown(Enum.KeyCode.S)
        local left = UserInputService:IsKeyDown(Enum.KeyCode.A)
        local right = UserInputService:IsKeyDown(Enum.KeyCode.D)

        local camCFrame = cam.CFrame
        local lookVec = camCFrame.LookVector
        local rightVec = camCFrame.RightVector

        if forward then dir = dir + lookVec end
        if back then dir = dir - lookVec end
        if left then dir = dir - rightVec end
        if right then dir = dir + rightVec end
    else
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            local camCFrame = cam.CFrame
            local flatLook = Vector3.new(camCFrame.LookVector.X, 0, camCFrame.LookVector.Z)
            local flatRight = Vector3.new(camCFrame.RightVector.X, 0, camCFrame.RightVector.Z)
            if flatLook.Magnitude > 0 then flatLook = flatLook.Unit end
            if flatRight.Magnitude > 0 then flatRight = flatRight.Unit end

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

function Fly.SetSpeed(newSpeed)
    Fly.Speed = newSpeed or Fly.Speed
end

FlySpeed = Movement:AddSlider("FlySpeed", {
    Text = "Fly Speed",
    Min = 10,
    Max = 21,
    Default = Fly.Speed,
    Rounding = 0,
    Callback = function(v)
        Fly.SetSpeed(v)
    end
})

Movement:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    Callback = function(enabled)
        if enabled then
            Fly.Enable()
        else
            Fly.Disable()
        end
    end
}):AddKeyPicker('FlyKeybind', {
    Default = 'F',
    SyncToggleState = true,
    Mode = 'Toggle',
    Text = 'Fly',
    NoUI = false,
    Callback = function(Value) end,
    ChangedCallback = function(New) end
})

SettingsESP:AddToggle('EnableShowDistances',{
    Text = "Enable Show Distances",
    Default = false,
    Callback = function(Value)
        ESPLibrary:ShowDistance(Value)
    end
})

ModifiersBox:AddToggle('AntiLookman',{
    Text = "Anti Lookman",
    Default = false
})

ModifiersBox:AddToggle('AntiFog',{
    Text = "Anti Fog",
    Default = false
})

ModifiersBox:AddToggle('AntiGiggle',{
    Text = "Anti Giggle",
    Default = false
})

ModifiersBox:AddToggle('AntiJam',{
    Text = "Anti Jamming",
    Default = false
})

ModifiersBox:AddToggle('AntiGloomPile',{
    Text = "Anti Gloom Egg",
    Default = false
})

ModifiersBox:AddToggle('AntiVacuum',{
    Text = "Anti Vacuum",
    Default = false
})

FloorAnti:AddToggle('AntiBanana',{
    Text = "Anti-Banana",
    Default = false
})

FloorAnti:AddToggle('AntiJeff',{
    Text = "Anti-Jeff",
    Default = false
})

FloorAnti:AddToggle('DeleteFigureFools',{
    Text = "Delete Figure (FE)",
    Default = false
})

FloorAnti:AddToggle('Godmode',{
    Text = "GodMode",
    Default = false
})

FloorAnti:AddToggle('FigureGodmode',{
    Text = "Figure GodMode",
    Default = false
})

FloorAnti:AddToggle('DeleteSeek',{
    Text = "Delete Seek (FE)",
    Default = false
})

FloorAnti:AddToggle('RankedAntiBanana',{
    Text = "Anti Nanner Banana",
    Default = false
})

FloorAnti:AddToggle('AntiSeekObstructions',{
    Text = "Anti Seek-Obstructions",
    Default = false
})

table.insert(Connections, RunService.RenderStepped:Connect(function()
    alive = LocalPlayer:GetAttribute("Alive")
    if alive and Character then
        if Toggles.SpeedBoost and Toggles.SpeedBoost.Value then
            Character.Humanoid.WalkSpeed = Speed
        end
        
        if Toggles.AntiHear and Toggles.AntiHear.Value then
            if ReplicatedStorage:FindFirstChild("RemotesFolder") then
                ReplicatedStorage.RemotesFolder.Crouch:FireServer(true)
            end
        end
        
        if Toggles.AntiEyes and Toggles.AntiEyes.Value then
            if Workspace:FindFirstChild("Eyes") then
                if ReplicatedStorage:FindFirstChild("RemotesFolder") then
                    ReplicatedStorage.RemotesFolder.MotorReplication:FireServer(-890)
                end
            end
        end
        
        if Toggles.AntiLookman and Toggles.AntiLookman.Value then
            if Workspace:FindFirstChild("BackdoorLookman") then
                if ReplicatedStorage:FindFirstChild("RemotesFolder") then
                    ReplicatedStorage.RemotesFolder.MotorReplication:FireServer(-890)
                end
            end
        end
        
        if Toggles.AntiFog and Toggles.AntiFog.Value then
            if Lighting:FindFirstChild("Fog") then
                Lighting.Fog.Density = 0
            end
            Lighting.FogEnd = 9e9
        end
        
        UpdateAllESP()
    end
end))

table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    Character = LocalPlayer.Character
end))

SettingsBox:AddToggle('FpsUnlocker',{
    Text = "Fps Unlocker",
    Default = true,
    Callback = function(Value)
        setfpscap(Value and 999 or 60)
    end
})

SettingsBox:AddToggle('PlaySound',{
    Text = "Play Sound",
    Default = true,
    Callback = function(Value)
        PlayingSound = Value
    end
})

SettingsBox:AddToggle('AntiAfk',{
    Text = "Disable AFK",
    Default = false
})

SettingsBox:AddToggle('NoCutscenes',{
    Text = "No Cutscenes",
    Default = false
})

SettingsBox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind

SettingsBox:AddToggle("ShowKeybinds", {
    Text = "Show Keybinds",
    Default = false,
    Tooltip = "Toggle the visibility of the keybinds menu",
}):OnChanged(function()
    Library.KeybindFrame.Visible = Toggles.ShowKeybinds.Value
end)

SettingsBox:AddToggle("ShowCustomCursor", {
    Text = "Show CustomCursor",
    Default = false,
    Tooltip = "Toggle the visibility of the Cursor",
}):OnChanged(function()
    Library.ShowCustomCursor = Toggles.ShowCustomCursor.Value
end)

SettingsBox:AddButton({
    Text = "Unload GUI",
    Func = function()
        for _, Connection in ipairs(Connections) do
            Connection:Disconnect()
        end
        Fly.Disable()
        ClearAllESP()
        ESPLibrary:Unload()
        Library:Unload()
        LocalPlayer:SetAttribute("mshaxLoaded",false)
    end
})

SettingsBox:AddButton({
    Text = "Join Discord",
    Func = function()
        if toclipboard then
            toclipboard("https://discord.gg/5ANk2PAcK2")
            Library:Notify("Copied Discord Link in Clipboard",3)
        elseif setclipboard then
            setclipboard("https://discord.gg/5ANk2PAcK2")
            Library:Notify("Copied Discord Link in Clipboard",3)
        end
    end
})

local ThemeManager = loadstring(game:HttpGet(repo..'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo..'addons/SaveManager.lua'))()

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder("Prohax")
SaveManager:SetFolder("Prohax/Doors")

SaveManager:BuildConfigSection(Tabs.UISettings)
ThemeManager:ApplyToTab(Tabs.UISettings)

SaveManager:LoadAutoloadConfig()

Library:Notify("mshax Loaded Successfully", 3)