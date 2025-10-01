if game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == true then
    repeat task.wait() until game.Players.LocalPlayer.PlayerGui.LoadingUI.Enabled == false
end

-- 初始化变量
Screech, ClutchHeart, AutoUseCrouch = false, false, false
local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local args = {...}
    local method = getnamecallmethod()
    if tostring(self) == "Screech" and method == "FireServer" and Screech == true then
        args[1] = true
        return old(self,unpack(args))
    end
    if tostring(self) == "ClutchHeartbeat" and method == "FireServer" and ClutchHeart == true then
        args[2] = true
        return old(self,unpack(args))
    end
    if self.Name == "Crouch" and method == "FireServer" and AutoUseCrouch == true then
        args[1] = true
        return old(self,unpack(args))
    end
    return old(self,...)
end))

workspace.DescendantAdded:Connect(function(v)
    if v:IsA("Model") and v.Name == "Screech" then
        v:Destroy()
    end
end)

------ 游戏数据 --------

local EntityModules = game:GetService("ReplicatedStorage").ModulesClient.EntityModules
local gameData = game.ReplicatedStorage:WaitForChild("GameData")
local floor = gameData:WaitForChild("Floor")
local isMines = floor.Value == "Mines"
local isHotel = floor.Value == "Hotel"
local isBackdoor = floor.Value == "Backdoor"
local isGarden = floor.Value == "Garden"

function Distance(pos)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude
    end
    return math.huge
end

_G.GetOldBright = {
    Brightness = game.Lighting.Brightness,
    ClockTime = game.Lighting.ClockTime,
    FogEnd = game.Lighting.FogEnd,
    GlobalShadows = game.Lighting.GlobalShadows,
    OutdoorAmbient = game.Lighting.OutdoorAmbient
}

---- UI库初始化 ----

-- 使用Linoria UI库
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "星光作弊菜单",
    Footer = "星光中心 v1.0",
    Icon = 95816097006870,
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("主要功能", "user"),
    Misc = Window:AddTab("杂项功能", "settings"),
    Esp = Window:AddTab("透视功能", "eye"),
    Cheats = Window:AddTab("作弊功能", "shield"),
    Information = Window:AddTab("信息", "info"),
    Settings = Window:AddTab("界面设置", "settings"),
}

-- 主要功能标签页
local MainGroup = Tabs.Main:AddLeftGroupbox("视觉设置")
MainGroup:AddToggle("Fullbright", {
    Text = "全亮模式",
    Default = false,
    Tooltip = "启用全亮模式，让整个地图变亮",
    Callback = function(Value)
        _G.FullBright = Value
        if Value then
            spawn(function()
                while _G.FullBright do
                    game.Lighting.Brightness = 2
                    game.Lighting.ClockTime = 14
                    game.Lighting.FogEnd = 100000
                    game.Lighting.GlobalShadows = false
                    game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
                    task.wait()
                end
            end)
        else
            for i, v in pairs(_G.GetOldBright) do
                game.Lighting[i] = v
            end
        end
    end
})

MainGroup:AddToggle("NoFog", {
    Text = "无雾效果",
    Default = false,
    Tooltip = "移除所有雾气效果",
    Callback = function(Value)
        _G.Nofog = Value
        if Value then
            spawn(function()
                while _G.Nofog do
                    game:GetService("Lighting").FogStart = 100000
                    game:GetService("Lighting").FogEnd = 200000
                    for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
                        if v.ClassName == "Atmosphere" then
                            v.Density = 0
                            v.Haze = 0
                        end
                    end
                    task.wait()
                end
            end)
        else
            game:GetService("Lighting").FogStart = 0
            game:GetService("Lighting").FogEnd = 1000
            for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
                if v.ClassName == "Atmosphere" then
                    v.Density = 0.3
                    v.Haze = 1
                end
            end
        end
    end
})

MainGroup:AddToggle("InstantPrompt", {
    Text = "即时互动",
    Default = false,
    Tooltip = "所有互动无需等待时间",
    Callback = function(Value)
        _G.NoCooldownProximity = Value
        if _G.NoCooldownProximity then
            for i, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                end
            end
            _G.CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
                if _G.NoCooldownProximity and Cooldown:IsA("ProximityPrompt") then
                    Cooldown.HoldDuration = 0
                end
            end)
        else
            if _G.CooldownProximity then
                _G.CooldownProximity:Disconnect()
                _G.CooldownProximity = nil
            end
        end
    end
})

MainGroup:AddDivider()

local MainMiscGroup = Tabs.Main:AddRightGroupbox("主要功能")
MainMiscGroup:AddToggle("AntiScreech", {
    Text = "防尖叫怪物",
    Default = false,
    Tooltip = "防止尖叫怪物影响你",
    Callback = function(Value)
        _G.AntiScreech = Value
        Screech = Value
    end
})

MainMiscGroup:AddToggle("AutoClutchHeart", {
    Text = "自动心跳胜利",
    Default = false,
    Tooltip = "自动赢得心跳小游戏",
    Callback = function(Value)
        ClutchHeart = Value
    end
})

MainMiscGroup:AddToggle("AntiHalt", {
    Text = "防停止",
    Default = false,
    Tooltip = "防止被实体停止移动",
    Callback = function(Value)
        _G.NoHalt = Value
        local HaltShade = EntityModules:FindFirstChild("Shade") or EntityModules:FindFirstChild("_Shade")
        if HaltShade then
            HaltShade.Name = _G.NoHalt and "_Shade" or "Shade"
        end
    end
})

MainMiscGroup:AddToggle("AntiEyes", {
    Text = "防眼睛/观察者",
    Default = false,
    Tooltip = "防止眼睛和观察者实体影响你",
    Callback = function(Value)
        _G.NoEyes = Value
        if Value then
            spawn(function()
                while _G.NoEyes do
                    if workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman") then
                        if game:GetService("ReplicatedStorage"):FindFirstChild("RemotesFolder") then
                            game:GetService("ReplicatedStorage"):WaitForChild("RemotesFolder"):WaitForChild("MotorReplication"):FireServer(-649)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

if isMines then
    MainMiscGroup:AddToggle("AntiEggGloom", {
        Text = "防阴郁蛋",
        Default = false,
        Tooltip = "防止阴郁蛋触碰到你",
        Callback = function(Value)
            _G.AntiEggGloom = Value
            if Value then
                spawn(function()
                    while _G.AntiEggGloom do
                        for i, v in pairs(workspace.CurrentRooms:GetChildren()) do
                            if v:IsA("Model") then
                                for _, v1 in pairs(v:GetChildren()) do
                                    if v1.Name:find("GloomPile") and v1:FindFirstChild("GloomEgg") and v1.GloomEgg:FindFirstChild("Egg") then
                                        v1.GloomEgg.Egg.CanTouch = false
                                    end
                                end
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end
    })
end

MainMiscGroup:AddToggle("AutoUseCrouch", {
    Text = "自动蹲下",
    Default = false,
    Tooltip = "自动保持蹲下状态",
    Callback = function(Value)
        AutoUseCrouch = Value
    end
})

MainMiscGroup:AddToggle("GetJumpButton", {
    Text = "无限跳跃",
    Default = false,
    Tooltip = "允许无限跳跃",
    Callback = function(Value)
        _G.JumpButton = Value
        if Value then
            spawn(function()
                while _G.JumpButton do
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("CanJump") then
                        game.Players.LocalPlayer.Character:SetAttribute("CanJump", true)
                    end
                    task.wait(0.1)
                end
            end)
        else
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("CanJump") then
                game.Players.LocalPlayer.Character:SetAttribute("CanJump", false)
            end
        end
    end
})

MainMiscGroup:AddToggle("InfOxygen", {
    Text = "无限氧气",
    Default = false,
    Tooltip = "拥有无限的氧气",
    Callback = function(Value)
        _G.ActiveInfOxygen = Value
        if Value then
            spawn(function()
                while _G.ActiveInfOxygen do
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
                        game.Players.LocalPlayer.Character:SetAttribute("Oxygen", 99999)
                    end
                    task.wait(0.1)
                end
            end)
        else
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("Oxygen") then
                game.Players.LocalPlayer.Character:SetAttribute("Oxygen", 100)
            end
        end
    end
})

-- 杂项功能标签页
local MiscGroup = Tabs.Misc:AddLeftGroupbox("实体通知")
local EntityOptions = MiscGroup:AddDropdown("EntityChoose", {
    Values = {"Rush", "Seek", "Eyes", "Window", "LookMan", "Gloombat", "Ambush", "A-60", "A-120"},
    Default = 1,
    Multi = true,
    Text = "选择实体",
    Tooltip = "选择要接收通知的实体",
})

MiscGroup:AddToggle("NotifyEntity", {
    Text = "实体通知",
    Default = false,
    Tooltip = "当选择的实体生成时通知你",
    Callback = function(Value)
        _G.NotifyEntity = Value
        if Value then
            _G.EntityChild = workspace.ChildAdded:Connect(function(child)
                for _, v in ipairs(EntityOptions.Value) do
                    if child:IsA("Model") and child.Name:find(v) then
                        repeat task.wait() until not child:IsDescendantOf(workspace) or (game.Players.LocalPlayer:DistanceFromCharacter(child:GetPivot().Position) < 1000)
                        if child:IsDescendantOf(workspace) then
                            Library:Notify({
                                Title = v.." 生成!!",
                                Content = v.." 在附近生成了!",
                                Time = 5
                            })
                            if _G.NotifyEntityChat then
                                local text = _G.ChatNotify or ""
                                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text..v.." 生成!!")
                            end
                        end
                    end
                end
            end)
        else
            if _G.EntityChild then
                _G.EntityChild:Disconnect()
                _G.EntityChild = nil
            end
        end
    end
})

if isHotel then
    MiscGroup:AddToggle("AutoGetCodeLibrary", {
        Text = "自动获取图书馆密码",
        Default = false,
        Tooltip = "自动解密图书馆密码",
        Callback = function(Value)
            _G.AutoGetCode = Value
            if Value then
                local function Deciphercode(v)
                    local Hints = game.Players.LocalPlayer.PlayerGui:WaitForChild("PermUI"):WaitForChild("Hints")
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
                
                local function CodeAll(v)
                    if v:IsA("Tool") and v.Name == "LibraryHintPaper" then
                        local code = table.concat(Deciphercode(v))
                        if code then
                            Library:Notify({
                                Title = "找到密码",
                                Content = "密码: "..code,
                                Time = 15
                            })
                            if _G.NotifyEntityChat then
                                if not _G.ChatNotify then
                                    TextChat = ""
                                else
                                    TextChat = _G.ChatNotify
                                end
                                if TextChat then
                                    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(TextChat..code)
                                end
                            end
                        end
                    end
                end
                
                _G.Getpaper = game.Players.LocalPlayer.Character.ChildAdded:Connect(function(v)
                    CodeAll(v)
                end)
            else
                if _G.Getpaper then
                    _G.Getpaper:Disconnect()
                    _G.Getpaper = nil
                end
            end
        end
    })
end

local MiscChatGroup = Tabs.Misc:AddRightGroupbox("聊天设置")
MiscChatGroup:AddInput("ChatNotifyInput", {
    Default = "",
    Numeric = false,
    Finished = false,
    Text = "输入聊天前缀",
    Tooltip = "输入你的聊天前缀",
    Placeholder = "你的聊天前缀...",
    Callback = function(Value)
        _G.ChatNotify = Value
    end
})

MiscChatGroup:AddToggle("NotifyEntityChat", {
    Text = "聊天通知",
    Default = false,
    Tooltip = "在聊天中发送实体通知",
    Callback = function(Value)
        _G.NotifyEntityChat = Value
    end
})

MiscChatGroup:AddDivider()

local MiscHidingGroup = Tabs.Misc:AddRightGroupbox("隐藏设置")
MiscHidingGroup:AddSlider("TransparencyHide", {
    Text = "隐藏透明度",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Suffix = "",
    Tooltip = "设置隐藏时的透明度",
    Callback = function(Value)
        _G.TransparencyHide = Value
    end
})

MiscHidingGroup:AddToggle("HidingTransparency", {
    Text = "透明隐藏",
    Default = false,
    Tooltip = "隐藏时使藏身点透明",
    Callback = function(Value)
        _G.HidingTransparency = Value
        if Value then
            spawn(function()
                while _G.HidingTransparency do
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("Hiding") then
                        for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
                            if v:IsA("ObjectValue") and v.Name == "HiddenPlayer" then
                                if v.Value == game.Players.LocalPlayer.Character then
                                    local hidePart = {}
                                    for _, i in pairs(v.Parent:GetChildren()) do
                                        if i:IsA("BasePart") then
                                            i.Transparency = _G.TransparencyHide or 0.5
                                            table.insert(hidePart, i)
                                        end
                                    end
                                    repeat task.wait()
                                        for _, h in pairs(hidePart) do
                                            h.Transparency = _G.TransparencyHide or 0.5
                                        end
                                    until not game.Players.LocalPlayer.Character:GetAttribute("Hiding") or not _G.HidingTransparency
                                    for _, n in pairs(hidePart) do
                                        n.Transparency = 0
                                    end
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

local MiscAutoGroup = Tabs.Misc:AddLeftGroupbox("自动功能")
_G.Aura = {
    "ActivateEventPrompt",
    "AwesomePrompt",
    "FusesPrompt",
    "HerbPrompt",
    "LeverPrompt",
    "LootPrompt",
    "ModulePrompt",
    "SkullPrompt",
    "UnlockPrompt",
    "ValvePrompt",
}

MiscAutoGroup:AddToggle("AutoLoot", {
    Text = "自动拾取",
    Default = false,
    Tooltip = "自动拾取附近的物品",
    Callback = function(Value)
        _G.AutoLoot = Value
        if Value then
            _G.lootables = {}
            local function LootCheck(v)
                if v:IsA("ProximityPrompt") and table.find(_G.Aura, v.Name) then
                    table.insert(_G.lootables, v)
                end
            end
            for _, v in ipairs(workspace:GetDescendants()) do
                LootCheck(v)
            end
            _G.ChildAllNext = workspace.DescendantAdded:Connect(function(v)
                LootCheck(v)
            end)
            _G.RemoveChild = workspace.DescendantRemoving:Connect(function(v)
                for i = #_G.lootables, 1, -1 do
                    if _G.lootables[i] == v then
                        table.remove(_G.lootables, i)
                        break
                    end
                end
            end)
            
            spawn(function()
                while _G.AutoLoot do
                    for i, v in pairs(_G.lootables) do
                        if v and v.Parent and v:IsA("ProximityPrompt") and table.find(_G.Aura, v.Name) and v:GetAttribute("Interactions"..game.Players.LocalPlayer.Name) == nil then
                            if v.Parent.Name:find("Mandrake") then return end
                            if Distance(v.Parent:GetPivot().Position) <= 12 then
                                fireproximityprompt(v)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            if _G.ChildAllNext then
                _G.ChildAllNext:Disconnect()
                _G.ChildAllNext = nil
            end
            if _G.RemoveChild then
                _G.RemoveChild:Disconnect()
                _G.RemoveChild = nil
            end
            _G.lootables = nil
        end
    end
})

MiscAutoGroup:AddSlider("WalkSpeedTp", {
    Text = "移动速度",
    Default = 16,
    Min = 16,
    Max = 50,
    Rounding = 0,
    Suffix = "",
    Tooltip = "设置移动速度",
    Callback = function(Value)
        _G.WalkSpeedTp = Value
    end
})

MiscAutoGroup:AddToggle("SpeedWalk", {
    Text = "启用移动速度",
    Default = false,
    Tooltip = "启用自定义移动速度",
    Callback = function(Value)
        _G.SpeedWalk = Value
        if Value then
            spawn(function()
                while _G.SpeedWalk do
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedTp
                    end
                    task.wait(0.1)
                end
            end)
        else
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

-- 透视功能标签页
local EspMainGroup = Tabs.Esp:AddLeftGroupbox("透视设置")

if not isGarden then
    EspMainGroup:AddToggle("EspKey", {
        Text = (((isHotel or isBackdoor) and "透视钥匙/开关") or (isMines and "透视保险丝")),
        Default = false,
        Tooltip = "显示钥匙、开关或保险丝的位置",
        Callback = function(Value)
            _G.EspKey = Value
            if not Value then
                if _G.KeySpawn then _G.KeySpawn:Disconnect() end
                if _G.KeyRemove then _G.KeyRemove:Disconnect() end
                _G.KeyAdd = {}
            end
        end
    })
end

EspMainGroup:AddToggle("EspDoor", {
    Text = "透视门",
    Default = false,
    Tooltip = "显示所有门的位置",
    Callback = function(Value)
        _G.EspDoor = Value
    end
})

if isBackdoor then
    EspMainGroup:AddToggle("EspLeverTime", {
        Text = "透视时间开关",
        Default = false,
        Tooltip = "显示时间开关的位置",
        Callback = function(Value)
            _G.EspLeverTime = Value
        end
    })
end

if isHotel then
    EspMainGroup:AddToggle("EspBook", {
        Text = "透视书籍",
        Default = false,
        Tooltip = "显示书籍的位置",
        Callback = function(Value)
            _G.EspBook = Value
        end
    })

    EspMainGroup:AddToggle("EspBreaker", {
        Text = "透视断路器",
        Default = false,
        Tooltip = "显示断路器的位置",
        Callback = function(Value)
            _G.EspBreaker = Value
        end
    })
end

EspMainGroup:AddToggle("EspItem", {
    Text = "透视物品",
    Default = false,
    Tooltip = "显示所有可拾取物品的位置",
    Callback = function(Value)
        _G.EspItem = Value
    end
})

EspMainGroup:AddToggle("EspEntity", {
    Text = "透视实体",
    Default = false,
    Tooltip = "显示所有实体的位置",
    Callback = function(Value)
        _G.EspEntity = Value
    end
})

EspMainGroup:AddToggle("EspHiding", {
    Text = "透视藏身点",
    Default = false,
    Tooltip = "显示所有藏身点的位置",
    Callback = function(Value)
        _G.EspHiding = Value
    end
})

EspMainGroup:AddToggle("EspPlayer", {
    Text = "透视玩家",
    Default = false,
    Tooltip = "显示其他玩家的位置",
    Callback = function(Value)
        _G.EspPlayer = Value
    end
})

local EspSettingsGroup = Tabs.Esp:AddRightGroupbox("透视显示设置")
EspSettingsGroup:AddToggle("EspGui", {
    Text = "显示GUI",
    Default = false,
    Tooltip = "显示透视的GUI文本",
    Callback = function(Value)
        _G.EspGui = Value
    end
})

EspSettingsGroup:AddToggle("EspHighlight", {
    Text = "显示高亮",
    Default = false,
    Tooltip = "显示透视的高亮效果",
    Callback = function(Value)
        _G.EspHighlight = Value
    end
})

EspSettingsGroup:AddDivider()

EspSettingsGroup:AddToggle("EspName", {
    Text = "显示名称",
    Default = false,
    Tooltip = "在透视中显示名称",
    Callback = function(Value)
        _G.EspName = Value
    end
})

EspSettingsGroup:AddToggle("EspDistance", {
    Text = "显示距离",
    Default = false,
    Tooltip = "在透视中显示距离",
    Callback = function(Value)
        _G.EspDistance = Value
    end
})

EspSettingsGroup:AddToggle("EspHealth", {
    Text = "显示生命值",
    Default = false,
    Tooltip = "在透视中显示生命值",
    Callback = function(Value)
        _G.EspHealth = Value
    end
})

EspSettingsGroup:AddDivider()

EspSettingsGroup:AddSlider("EspGuiTextSize", {
    Text = "文本大小",
    Default = 15,
    Min = 5,
    Max = 50,
    Rounding = 0,
    Suffix = "",
    Tooltip = "设置透视文本的大小",
    Callback = function(Value)
        _G.EspGuiTextSize = Value
    end
})

EspSettingsGroup:AddColorPicker("EspGuiTextColor", {
    Title = "GUI颜色",
    Default = Color3.fromRGB(255, 255, 255),
    Tooltip = "设置透视文本的颜色",
    Callback = function(Value)
        _G.EspGuiTextColor = Value
    end
})

EspSettingsGroup:AddColorPicker("ColorLight", {
    Title = "高亮颜色",
    Default = Color3.fromRGB(255, 255, 255),
    Tooltip = "设置透视高亮的颜色",
    Callback = function(Value)
        _G.ColorLight = Value
    end
})

-- 作弊功能标签页
local CheatsGroup = Tabs.Cheats:AddLeftGroupbox("作弊功能")

-- 无敌模式
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteFolder = ReplicatedStorage:FindFirstChild("EntityInfo") or ReplicatedStorage:FindFirstChild("RemotesFolder") or ReplicatedStorage:FindFirstChild("Bricks")

local GodmodeEnabled = false
local GodmodeConnection

local function EnableGodmode()
    local Character = LocalPlayer.Character
    if not Character then return end
    
    if RemoteFolder and RemoteFolder:FindFirstChild("Crouch") then
        RemoteFolder.Crouch:FireServer(true)
    end
    
    if Character:FindFirstChild("Collision") then
        Character.Collision.Size = Vector3.new(1, 0.001, 5)
        Character.Collision.CanCollide = false
        if Character.Collision:FindFirstChild("CollisionCrouch") then
            Character.Collision.CollisionCrouch.CanCollide = false
        end
    end
    
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.HipHeight = 0.0001
    end
    
    if Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CanCollide = false
    end
end

local function DisableGodmode()
    local Character = LocalPlayer.Character
    if not Character then return end
    
    if Character:FindFirstChild("Collision") then
        Character.Collision.Size = Vector3.new(5.5, 3, 5)
        Character.Collision.CanCollide = true
        if Character.Collision:FindFirstChild("CollisionCrouch") then
            Character.Collision.CollisionCrouch.CanCollide = true
        end
    end
    
    if Character:FindFirstChild("Humanoid") then
        Character.Humanoid.HipHeight = 2.4
    end
    
    if Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CanCollide = true
    end
    
    if RemoteFolder and RemoteFolder:FindFirstChild("Crouch") then
        RemoteFolder.Crouch:FireServer(false)
    end
end

local function InitializeGodmode()
    if LocalPlayer.Character then
        EnableGodmode()
    end
    
    LocalPlayer.CharacterAdded:Connect(function(Character)
        task.wait(1.5)
        if GodmodeEnabled then
            EnableGodmode()
        end
    end)
end

CheatsGroup:AddToggle("Godmode", {
    Text = "无敌模式",
    Default = false,
    Tooltip = "使角色无敌且无碰撞",
    Callback = function(Value)
        GodmodeEnabled = Value
        if Value then
            InitializeGodmode()
            GodmodeConnection = RunService.Heartbeat:Connect(function()
                local Character = LocalPlayer.Character
                if Character and Character:FindFirstChild("Humanoid") and Character.Humanoid.Health > 0 then
                    if Character:FindFirstChild("Collision") then
                        Character.Collision.CanCollide = false
                        if Character.Collision:FindFirstChild("CollisionCrouch") then
                            Character.Collision.CollisionCrouch.CanCollide = false
                        end
                    end
                    if Character:FindFirstChild("HumanoidRootPart") then
                        Character.HumanoidRootPart.CanCollide = false
                    end
                end
            end)
            Library:Notify({
                Title = "无敌模式",
                Content = "无敌模式已启用",
                Time = 3
            })
        else
            if GodmodeConnection then
                GodmodeConnection:Disconnect()
            end
            DisableGodmode()
            Library:Notify({
                Title = "无敌模式",
                Content = "无敌模式已禁用",
                Time = 3
            })
        end
    end
})

-- 无限物品功能
local InfiniteFunctions = {
    Lockpick = false,
    Shears = false,
    Crucifix = false
}

local LockpickParents = { 
    ChestBoxLocked = true, 
    Locker_Small_Locked = true, 
    Toolbox_Locked = true 
}

local LockpickNames = { 
    UnlockPrompt = true, 
    ThingToEnable = true, 
    LockPrompt = true,
    SkullPrompt = true, 
    FusesPrompt = true 
}

local ShearsParents = { 
    Chest_Vine = true, 
    CuttableVines = true, 
    Cellar = true 
}

local ShearsNames = { 
    SkullPrompt = true 
}

local DropTable = {
    RushMoving = 54,
    AmbushMoving = 67,
    A60 = 70
}

local InfStore = {}
local InfSStore = {}

local raycastParms = RaycastParams.new()
raycastParms.FilterType = Enum.RaycastFilterType.Blacklist

local function updateRaycastFilter()
    if LocalPlayer.Character then
        raycastParms.FilterDescendantsInstances = {LocalPlayer.Character}
    end
end

local function addFake(prompt, mode)
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

        if RemoteFolder and RemoteFolder:FindFirstChild("DropItem") then
            RemoteFolder.DropItem:FireServer(tool)
        end

        local con
        con = workspace.Drops.ChildAdded:Connect(function(v)
            local p = v:FindFirstChildOfClass("ProximityPrompt")
            if p then
                if mode == "Lockpick" then
                    fireproximityprompt(p)
                    fireproximityprompt(prompt)
                elseif mode == "Shears" then
                    fireproximityprompt(prompt)
                    fireproximityprompt(p)
                end

                task.wait(0.3)
                if con then con:Disconnect() end
            end
        end)
    end)
end

local function scanPrompts(validParents, validNames)
    local t = {}
    for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
        if v:IsA("ProximityPrompt") and (validParents[v.Parent.Name] or validNames[v.Name]) then
            table.insert(t, v)
        end
    end
    return t
end

local function cleanupEnableReal()
    for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
        if v.Name == "FakePrompt" and v.Parent then
            v:Destroy()
        end
        if v:IsA("ProximityPrompt") and v.Name ~= "FakePrompt" then
            pcall(function()
                v.Enabled = true
                v.ClickablePrompt = true
                if v:GetAttribute("HasFake") == true then
                    v:SetAttribute("HasFake", nil)
                end
            end)
        end
    end
end

-- 初始化存储
InfStore = scanPrompts(LockpickParents, LockpickNames)
InfSStore = scanPrompts(ShearsParents, ShearsNames)

local infiniteItemsConnection

local function StartInfiniteItems()
    infiniteItemsConnection = RunService.RenderStepped:Connect(function()
        local Character = LocalPlayer.Character
        if not Character then return end
        
        updateRaycastFilter()
        
        if InfiniteFunctions.Lockpick then
            local hasTool = Character:FindFirstChild("Lockpick") or Character:FindFirstChild("SkeletonKey")
            if hasTool then
                for _, prompt in ipairs(InfStore) do
                    if prompt and prompt.Parent and not prompt:GetAttribute("HasFake") then
                        addFake(prompt, "Lockpick")
                    end
                end
            end
        end
        
        if InfiniteFunctions.Shears then
            local hasTool = Character:FindFirstChild("Shears")
            if hasTool then
                for _, prompt in ipairs(InfSStore) do
                    if prompt and prompt.Parent and not prompt:GetAttribute("HasFake") then
                        addFake(prompt, "Shears")
                    end
                end
            end
        end
        
        if InfiniteFunctions.Crucifix then
            for _, v in ipairs(workspace:GetChildren()) do
                local Entity = DropTable[v.Name]
                if Entity and v.PrimaryPart then
                    v.PrimaryPart.CanCollide = true
                    v.PrimaryPart.CanQuery = true
                    local origin2 = Character.HumanoidRootPart.Position
                    local direction2 = (v.PrimaryPart.Position - origin2)
                    local result2 = workspace:Raycast(origin2, direction2, raycastParms)

                    if result2 and result2.Instance:IsDescendantOf(v) then
                        if (Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude < Entity then
                            if RemoteFolder and RemoteFolder:FindFirstChild("DropItem") then
                                RemoteFolder.DropItem:FireServer(Character:FindFirstChildOfClass("Tool"))
                                task.wait(0.54)
                                if workspace:FindFirstChild("Drops") and workspace.Drops:FindFirstChild("Crucifix") then
                                    fireproximityprompt(workspace.Drops:WaitForChild("Crucifix"):FindFirstChildOfClass("ProximityPrompt"))
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function StopInfiniteItems()
    if infiniteItemsConnection then
        infiniteItemsConnection:Disconnect()
        infiniteItemsConnection = nil
    end
    cleanupEnableReal()
end

CheatsGroup:AddToggle("InfiniteLockpick", {
    Text = "无限开锁工具",
    Default = false,
    Tooltip = "开锁工具不会被消耗",
    Callback = function(Value)
        InfiniteFunctions.Lockpick = Value
        if not InfiniteFunctions.Lockpick and not InfiniteFunctions.Shears and not InfiniteFunctions.Crucifix then
            StopInfiniteItems()
        elseif Value and not infiniteItemsConnection then
            StartInfiniteItems()
        end
    end
})

CheatsGroup:AddToggle("InfiniteShears", {
    Text = "无限剪刀",
    Default = false,
    Tooltip = "剪刀不会被消耗",
    Callback = function(Value)
        InfiniteFunctions.Shears = Value
        if not InfiniteFunctions.Lockpick and not InfiniteFunctions.Shears and not InfiniteFunctions.Crucifix then
            StopInfiniteItems()
        elseif Value and not infiniteItemsConnection then
            StartInfiniteItems()
        end
    end
})

CheatsGroup:AddToggle("InfiniteCrucifix", {
    Text = "无限十字架",
    Default = false,
    Tooltip = "十字架不会被消耗",
    Callback = function(Value)
        InfiniteFunctions.Crucifix = Value
        if not InfiniteFunctions.Lockpick and not InfiniteFunctions.Shears and not InfiniteFunctions.Crucifix then
            StopInfiniteItems()
        elseif Value and not infiniteItemsConnection then
            StartInfiniteItems()
        end
    end
})

-- 监听新提示的添加
workspace.DescendantAdded:Connect(function(v)
    if v:IsA("ProximityPrompt") then
        if InfiniteFunctions.Lockpick and (LockpickNames[v.Name] or LockpickParents[v.Parent.Name]) then
            table.insert(InfStore, v)
        end
        
        if InfiniteFunctions.Shears and (ShearsNames[v.Name] or ShearsParents[v.Parent.Name]) then
            table.insert(InfSStore, v)
        end
    end
end)

-- 信息标签页
local InfoGroup = Tabs.Information:AddLeftGroupbox("Discord信息")
local InviteCode = "NE4fqyAStd"

InfoGroup:AddLabel("星光作弊菜单")
InfoGroup:AddLabel("版本: 1.0")
InfoGroup:AddLabel("作者: Nova Hoang")

InfoGroup:AddDivider()

InfoGroup:AddButton("复制Discord邀请", function()
    setclipboard("https://discord.gg/" .. InviteCode)
    Library:Notify("Discord邀请已复制到剪贴板!")
end)

InfoGroup:AddButton("加入Discord", function()
    local httpService = game:GetService("HttpService")
    local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if request then
        request({
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com"
            },
            Body = httpService:JSONEncode({
                cmd = "INVITE_BROWSER",
                args = {
                    code = InviteCode
                },
                nonce = httpService:GenerateGUID(false)
            }),
        })
    end
end)

local CreatorGroup = Tabs.Information:AddRightGroupbox("创作者信息")
CreatorGroup:AddLabel("Nova Hoang")
CreatorGroup:AddLabel("Article Hub 和 Nihahaha Hub 的所有者")

CreatorGroup:AddDivider()

CreatorGroup:AddLabel("Giang Hub")
CreatorGroup:AddLabel("Article Hub 和 Nihahaha Hub 的共同所有者")

-- 界面设置标签页
local MenuGroup = Tabs.Settings:AddLeftGroupbox("菜单设置")
MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = false,
    Text = "显示按键绑定菜单",
    Tooltip = "显示或隐藏按键绑定菜单",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "自定义光标",
    Default = true,
    Tooltip = "启用或禁用自定义光标",
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "左侧", "右侧" },
    Default = "右侧",
    Text = "通知位置",
    Tooltip = "选择通知显示的位置",
    Callback = function(Value)
        local side = Value == "左侧" and "Left" or "Right"
        Library:SetNotifySide(side)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI缩放",
    Tooltip = "调整UI的缩放比例",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value) / 100
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("菜单按键绑定"):AddKeyPicker("MenuKeybind", { 
    Default = "RightShift", 
    NoUI = true, 
    Text = "菜单按键绑定" 
})

MenuGroup:AddButton("卸载菜单", function()
    Library:Unload()
    Library:Notify({
        Title = "菜单已卸载",
        Content = "星光作弊菜单已成功卸载",
        Time = 3
    })
end)

-- 设置主题和保存管理器
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("StarLightHub")
SaveManager:SetFolder("StarLightHub/Doors")

SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "星光作弊菜单",
    Content = "菜单加载成功! 按右Shift键打开/关闭菜单",
    Time = 5
})

-- 设置菜单按键
Library.ToggleKeybind = Library.Options.MenuKeybind