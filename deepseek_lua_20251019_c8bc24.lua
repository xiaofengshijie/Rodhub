[file name]: LOL.lua
[file content begin]
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local PFS = game:GetService("PathfindingService")
local Storage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local playerout = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- 多语言字典
local Translations = {
    ["English"] = {
        ["Main"] = "Main",
        ["Auto"] = "Auto", 
        ["UI Settings"] = "UI Settings",
        ["Auto Generator"] = "Auto Generator",
        ["Teleport To Generator"] = "Teleport To Generator",
        ["Inf Stamina"] = "Inf Stamina",
        ["WalkSpeed"] = "WalkSpeed",
        ["Set Speed"] = "Set Speed",
        ["Misc"] = "Misc",
        ["Health"] = "Health",
        ["Auto Eat Pizza"] = "Auto Eat Pizza",
        ["Void Rush Bypass"] = "Void Rush Bypass",
        ["Void Rush Control"] = "Void Rush Control",
        ["Esp"] = "Esp",
        ["Esp Generator"] = "Esp Generator",
        ["Esp Killer"] = "Esp Killer",
        ["Esp Survivors"] = "Esp Survivors",
        ["Esp Item"] = "Esp Item",
        ["Settings Esp"] = "Settings Esp",
        ["Set Font"] = "Set Font",
        ["Show Distance"] = "Show Distance",
        ["Show Rainbow"] = "Show Rainbow",
        ["Show Tracers"] = "Show Tracers",
        ["Tracers Origin"] = "Tracers Origin",
        ["Show Arrows"] = "Show Arrows",
        ["Set Arrows Radius"] = "Set Arrows Radius",
        ["Set TextSize"] = "Set TextSize",
        ["Set Fill Transparency"] = "Set Fill Transparency",
        ["Set OutLine Transparency"] = "Set OutLine Transparency",
        ["Auto Block"] = "Auto Block",
        ["Auto Punch"] = "Auto Punch",
        ["Aimbot Punch"] = "Aimbot Punch",
        ["Punch Fling Power"] = "Punch Fling Power",
        ["Detection Range (Animation)"] = "Detection Range (Animation)",
        ["Auto Stun"] = "Auto Stun",
        ["Chance Aimbot Shot"] = "Chance Aimbot Shot",
        ["Sharpness"] = "Sharpness",
        ["Menu"] = "Menu",
        ["Notification Side"] = "Notification Side",
        ["Notification Choose"] = "Notification Choose",
        ["Notification Sound"] = "Notification Sound",
        ["Volume Notification"] = "Volume Notification",
        ["Open Keybind Menu"] = "Open Keybind Menu",
        ["Custom Cursor"] = "Custom Cursor",
        ["Menu bind"] = "Menu bind",
        ["Copy Link Discord"] = "Copy Link Discord",
        ["Copy Link Zalo"] = "Copy Link Zalo",
        ["Unload"] = "Unload",
        ["Credits"] = "Credits",
        ["Info"] = "Info",
        ["Counter"] = "Counter",
        ["Executor"] = "Executor",
        ["Job Id"] = "Job Id",
        ["Copy JobId"] = "Copy JobId",
        ["Join Job"] = "Join Job",
        ["Join JobId"] = "Join JobId",
        ["Copy Join JobId"] = "Copy Join JobId",
        ["Language"] = "Language"
    },
    ["Việt Nam"] = {
        ["Main"] = "Chủ yếu",
        ["Auto"] = "Tự động", 
        ["UI Settings"] = "Cài Đặt UI",
        ["Auto Generator"] = "Tự động máy phát điện",
        ["Teleport To Generator"] = "Dịch chuyển đến máy phát điện",
        ["Inf Stamina"] = "Thể lực vô hạn",
        ["WalkSpeed"] = "Tốc độ di chuyển",
        ["Set Speed"] = "Đặt tốc độ",
        ["Misc"] = "Lặt vặt",
        ["Health"] = "Máu",
        ["Auto Eat Pizza"] = "Tự động ăn pizza",
        ["Void Rush Bypass"] = "Bỏ qua Void Rush",
        ["Void Rush Control"] = "Điều khiển Void Rush",
        ["Esp"] = "Định vị",
        ["Esp Generator"] = "Định vị máy phát điện",
        ["Esp Killer"] = "Định vị kẻ săn mồi",
        ["Esp Survivors"] = "Định vị người sống sót",
        ["Esp Item"] = "Định vị vật phẩm",
        ["Settings Esp"] = "Cài đặt định vị",
        ["Set Font"] = "Đặt phông chữ",
        ["Show Distance"] = "Hiển thị khoảng cách",
        ["Show Rainbow"] = "Hiển thị cầu vồng",
        ["Show Tracers"] = "Hiển thị đường kẻ",
        ["Tracers Origin"] = "Gốc đường kẻ",
        ["Show Arrows"] = "Hiển thị mũi tên",
        ["Set Arrows Radius"] = "Đặt bán kính mũi tên",
        ["Set TextSize"] = "Đặt kích thước chữ",
        ["Set Fill Transparency"] = "Đặt độ trong suốt fill",
        ["Set OutLine Transparency"] = "Đặt độ trong suốt viền",
        ["Auto Block"] = "Tự động chặn",
        ["Auto Punch"] = "Tự động đấm",
        ["Aimbot Punch"] = "Tự động ngắm đấm",
        ["Punch Fling Power"] = "Sức mạnh đấm",
        ["Detection Range (Animation)"] = "Phạm vi phát hiện (hoạt ảnh)",
        ["Auto Stun"] = "Tự động choáng",
        ["Chance Aimbot Shot"] = "Tự động ngắm bắn",
        ["Sharpness"] = "Độ sắc nét",
        ["Menu"] = "Trình đơn",
        ["Notification Side"] = "Phía thông báo",
        ["Notification Choose"] = "Chọn thông báo",
        ["Notification Sound"] = "Âm thanh thông báo",
        ["Volume Notification"] = "Âm lượng thông báo",
        ["Open Keybind Menu"] = "Mở menu phím tắt",
        ["Custom Cursor"] = "Con trỏ tùy chỉnh",
        ["Menu bind"] = "Phím menu",
        ["Copy Link Discord"] = "Sao chép link Discord",
        ["Copy Link Zalo"] = "Sao chép link Zalo",
        ["Unload"] = "Dỡ bỏ",
        ["Credits"] = "Ghi công",
        ["Info"] = "Thông tin",
        ["Counter"] = "Quốc gia",
        ["Executor"] = "Trình thực thi",
        ["Job Id"] = "ID phòng",
        ["Copy JobId"] = "Sao chép JobId",
        ["Join Job"] = "Vào phòng",
        ["Join JobId"] = "Vào JobId",
        ["Copy Join JobId"] = "Sao chép lệnh Join JobId",
        ["Language"] = "Ngôn ngữ"
    },
    ["China"] = {
        ["Main"] = "主要",
        ["Auto"] = "自动", 
        ["UI Settings"] = "界面设置",
        ["Auto Generator"] = "自动发电机",
        ["Teleport To Generator"] = "传送到发电机",
        ["Inf Stamina"] = "无限体力",
        ["WalkSpeed"] = "移动速度",
        ["Set Speed"] = "设置速度",
        ["Misc"] = "杂项",
        ["Health"] = "生命值",
        ["Auto Eat Pizza"] = "自动吃披萨",
        ["Void Rush Bypass"] = "绕过虚空冲刺",
        ["Void Rush Control"] = "虚空冲刺控制",
        ["Esp"] = "透视",
        ["Esp Generator"] = "透视发电机",
        ["Esp Killer"] = "透视杀手",
        ["Esp Survivors"] = "透视幸存者",
        ["Esp Item"] = "透视物品",
        ["Settings Esp"] = "透视设置",
        ["Set Font"] = "设置字体",
        ["Show Distance"] = "显示距离",
        ["Show Rainbow"] = "显示彩虹",
        ["Show Tracers"] = "显示追踪线",
        ["Tracers Origin"] = "追踪线原点",
        ["Show Arrows"] = "显示箭头",
        ["Set Arrows Radius"] = "设置箭头半径",
        ["Set TextSize"] = "设置文字大小",
        ["Set Fill Transparency"] = "设置填充透明度",
        ["Set OutLine Transparency"] = "设置轮廓透明度",
        ["Auto Block"] = "自动格挡",
        ["Auto Punch"] = "自动出拳",
        ["Aimbot Punch"] = "自动瞄准出拳",
        ["Punch Fling Power"] = "出拳力量",
        ["Detection Range (Animation)"] = "检测范围（动画）",
        ["Auto Stun"] = "自动眩晕",
        ["Chance Aimbot Shot"] = "自动瞄准射击",
        ["Sharpness"] = "锐度",
        ["Menu"] = "菜单",
        ["Notification Side"] = "通知位置",
        ["Notification Choose"] = "通知选择",
        ["Notification Sound"] = "通知声音",
        ["Volume Notification"] = "通知音量",
        ["Open Keybind Menu"] = "打开键位菜单",
        ["Custom Cursor"] = "自定义光标",
        ["Menu bind"] = "菜单键位",
        ["Copy Link Discord"] = "复制 Discord 链接",
        ["Copy Link Zalo"] = "复制 Zalo 链接",
        ["Unload"] = "卸载",
        ["Credits"] = "致谢",
        ["Info"] = "信息",
        ["Counter"] = "国家",
        ["Executor"] = "执行器",
        ["Job Id"] = "房间ID",
        ["Copy JobId"] = "复制 JobId",
        ["Join Job"] = "加入房间",
        ["Join JobId"] = "加入 JobId",
        ["Copy Join JobId"] = "复制加入 JobId 命令",
        ["Language"] = "语言"
    }
}

-- 当前语言设置
_G.CurrentLanguage = "English"

-- 翻译函数
local function T(key)
    return Translations[_G.CurrentLanguage] and Translations[_G.CurrentLanguage][key] or Translations["English"][key] or key
end

-- 存储UI元素的引用
local UIReferences = {}

-- 更新界面语言的函数
local function UpdateUILanguage()
    -- 更新窗口标题
    if Window then
        Window:SetWindowTitle("Forsake")
    end
    
    -- 更新标签页文本
    if Tabs and Tabs.Tab then
        Tabs.Tab:SetTabText(T("Main"))
        Tabs.Tab2:SetTabText(T("Auto"))
        Tabs["UI Settings"]:SetTabText(T("UI Settings"))
    end
    
    -- 更新分组框标题
    if Main1Group then Main1Group:SetGroupboxTitle(T("Main")) end
    if Main2Group then Main2Group:SetGroupboxTitle(T("Esp")) end
    if Main3Group then Main3Group:SetGroupboxTitle(T("Misc")) end
    if Esp1 then Esp1:SetGroupboxTitle(T("Settings Esp")) end
    if Anti1Group then Anti1Group:SetGroupboxTitle(T("Auto Block")) end
    if Anti2Group then Anti2Group:SetGroupboxTitle(T("Auto Stun")) end
    if MenuGroup then MenuGroup:SetGroupboxTitle(T("Menu")) end
    if CreditsGroup then CreditsGroup:SetGroupboxTitle(T("Credits")) end
    if Info then Info:SetGroupboxTitle(T("Info")) end
    
    -- 更新所有切换按钮文本
    if Toggles then
        if Toggles.AutoGeneral then Toggles.AutoGeneral:SetText(T("Auto Generator")) end
        if Toggles.InfStamina then Toggles.InfStamina:SetText(T("Inf Stamina")) end
        if Toggles.SetSpeed then Toggles.SetSpeed:SetText(T("Set Speed")) end
        if Toggles.AutoEatPizza then Toggles.AutoEatPizza:SetText(T("Auto Eat Pizza")) end
        if Toggles.VoidRushBypass then Toggles.VoidRushBypass:SetText(T("Void Rush Bypass")) end
        if Toggles.VoidRushControl then Toggles.VoidRushControl:SetText(T("Void Rush Control")) end
        if Toggles.Generator then Toggles.Generator:SetText(T("Esp Generator")) end
        if Toggles.Killer then Toggles.Killer:SetText(T("Esp Killer")) end
        if Toggles.Survivors then Toggles.Survivors:SetText(T("Esp Survivors")) end
        if Toggles.Item then Toggles.Item:SetText(T("Esp Item")) end
        if Toggles.AutoBlock then Toggles.AutoBlock:SetText(T("Auto Block")) end
        if Toggles.AutoPunch then Toggles.AutoPunch:SetText(T("Auto Punch")) end
        if Toggles.AimbotPunch then Toggles.AimbotPunch:SetText(T("Aimbot Punch")) end
        if Toggles.Aimbot then Toggles.Aimbot:SetText(T("Chance Aimbot Shot")) end
        if Toggles.NotifySound then Toggles.NotifySound:SetText(T("Notification Sound")) end
        if Toggles.KeybindMenuOpen then Toggles.KeybindMenuOpen:SetText(T("Open Keybind Menu")) end
        if Toggles.ShowCustomCursor then Toggles.ShowCustomCursor:SetText(T("Custom Cursor")) end
        if Toggles.ShowDistance then Toggles.ShowDistance:SetText(T("Show Distance")) end
        if Toggles.ShowRainbow then Toggles.ShowRainbow:SetText(T("Show Rainbow")) end
        if Toggles.ShowTracers then Toggles.ShowTracers:SetText(T("Show Tracers")) end
        if Toggles.ShowArrows then Toggles.ShowArrows:SetText(T("Show Arrows")) end
    end
    
    -- 更新滑块文本
    if Options then
        if Options.Speed then Options.Speed:SetText(T("WalkSpeed")) end
        if Options.Health then Options.Health:SetText(T("Health")) end
        if Options.PunchFlingPower then Options.PunchFlingPower:SetText(T("Punch Fling Power")) end
        if Options.DetectionRange then Options.DetectionRange:SetText(T("Detection Range (Animation)")) end
        if Options.Sharpness then Options.Sharpness:SetText(T("Sharpness")) end
        if Options.VolumeNotification then Options.VolumeNotification:SetText(T("Volume Notification")) end
        if Options.ArrowsSize then Options.ArrowsSize:SetText(T("Set Arrows Radius")) end
        if Options.SetTextSize then Options.SetTextSize:SetText(T("Set TextSize")) end
        if Options.SetFillTransparency then Options.SetFillTransparency:SetText(T("Set Fill Transparency")) end
        if Options.SetOutlineTransparency then Options.SetOutlineTransparency:SetText(T("Set OutLine Transparency")) end
    end
    
    -- 更新下拉菜单文本
    if Options then
        if Options.Font then Options.Font:SetText(T("Set Font")) end
        if Options.TracersOrigin then Options.TracersOrigin:SetText(T("Tracers Origin")) end
        if Options.NotifySide then Options.NotifySide:SetText(T("Notification Side")) end
        if Options.NotifyChoose then Options.NotifyChoose:SetText(T("Notification Choose")) end
        if Options.LanguageSelect then Options.LanguageSelect:SetText(T("Language")) end
    end
    
    -- 更新水印文本
    Library:SetWatermarkVisibility(true)
    
    if Library then
        Library:Notify(T("Language changed to") .. " " .. _G.CurrentLanguage, 3)
    end
end

local Modules = Storage:WaitForChild("Modules")
local Network = Modules and Modules:WaitForChild("Network")
local Remote = Network and Network:WaitForChild("RemoteEvent")

local player = playerout.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local playergui = player:WaitForChild("PlayerGui")
local maingui = playergui:WaitForChild("MainUI")

spawn(function()
	while task.wait() do
		char = player.Character or player.CharacterAdded:Wait()
		root = char:WaitForChild("HumanoidRootPart")
		hum = char:WaitForChild("Humanoid")
	end
end)

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

getgenv()._VoidRushBypass = false
getgenv()._oldFireServer = nil
if not getgenv()._oldFireServer then
    local old
    old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if self == Remote and method == "FireServer" then
            if args[1] == player.Name.."VoidRushCollision" then
                if getgenv()._VoidRushBypass then
                    return 
                end
            end
        end
        return old(self, ...)
    end)
    getgenv()._oldFireServer = old
end

Animations = {
	["KillerAnima"] = {
	    "126830014841198", "126355327951215", "121086746534252", "18885909645",
	    "98456918873918", "105458270463374", "83829782357897", "125403313786645",
	    "118298475669935", "82113744478546", "70371667919898", "99135633258223",
	    "97167027849946", "109230267448394", "139835501033932", "126896426760253",
	    "109667959938617", "126681776859538", "129976080405072", "121293883585738",
	    "81639435858902", "137314737492715", "92173139187970"
	},
	["Shot - Punch"] = {
		["103601716322988"] = true, ["133491532453922"] = true, ["86371356500204"] = true, ["76649505662612"] = true, 
		["81698196845041"] = true,["87259391926321"] = true, ["140703210927645"] = true, ["136007065400978"] = true, 
		["136007065400978"] = true, ["129843313690921"] = true, ["129843313690921"] = true, ["86096387000557"] = true,
		["86709774283672"] = true, ["87259391926321"] = true, ["129843313690921"] = true, ["129843313690921"] = true,
		["108807732150251"] = true, ["138040001965654"] = true, ["86096387000557"] = true
	}
}

local function isFacing(targetRoot)
    local dot = targetRoot.CFrame.LookVector:Dot((root.Position - targetRoot.Position).Unit)
    return dot > -0.3
end

function KillerTarget()
    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if killersFolder then
        for _, v in ipairs(killersFolder:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                return v.HumanoidRootPart
            end
        end
    end
    return nil
end

function PlayingAnimationId()
    local ids = {}
    if hum then
        for _, v in ipairs(hum:GetPlayingAnimationTracks()) do
            if v.Animation and v.Animation.AnimationId then
                local id = v.Animation.AnimationId:match("%d+")
                if id then
                    ids[id] = true
                end
            end
        end
    end
    return ids
end

function CheckWall(Target)
    local Direction = (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).unit * (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, game.Workspace.CurrentCamera}
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local Result = game.Workspace:Raycast(game.Workspace.CurrentCamera.CFrame.Position, Direction, RaycastParams)
    return Result == nil or Result.Instance:IsDescendantOf(Target)
end

local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/ESPLibrary/refs/heads/main/Library.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/Test.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/ThemeManagerCopy.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Library/LinoriaLib/addons/SaveManagerCopy.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

function Notification(Message, Time)
if _G.ChooseNotify == "Obsidian" then
Library:Notify(Message, Time or 5)
elseif _G.ChooseNotify == "Roblox" then
game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = Message,Icon = "rbxassetid://7733658504",Duration = Time or 5})
end
if _G.NotificationSound then
        local sound = Instance.new("Sound", workspace)
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = _G.VolumeTime or 2
            sound.PlayOnRemove = true
            sound:Destroy()
        end
    end

Library:SetDPIScale(85)
Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local CurrentRooms = 0
local FrameCounter = 0
local FPS = 60
_G.PunchFlingPower = 10000

RunService.RenderStepped:Connect(function()
FrameCounter += 1
if (tick() - FrameTimer) >= 1 then
    FPS = FrameCounter
    FrameTimer = tick()
    FrameCounter = 0
end
local Killer
local ClosestDistance
for i, v in pairs(game.Workspace.Players.Killers:GetChildren()) do
	if v:IsA("Model") and v:GetAttribute("Username") ~= player.Name then
		Killer = v.Name
		ClosestDistance = Distance2(v:GetPivot().Position)
	end
end
if hum then SpeedUp = hum.WalkSpeed else SpeedUp = 0 end
Library:SetWatermark(("Killer: %s (%s m) | %s Speed | %s FPS | %s MS"):format(
	Killer or "N/A",
	math.floor(ClosestDistance or 0),
	math.floor(SpeedUp or 0),
    math.floor(FPS),
    math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
))
for i, v in pairs(_G.GetOldBright.New) do
	if _G.FullBright then
		Lighting[i] = v
	end
end
if _G.VoidRushControl and char and char:GetAttribute("VoidRushState") == "Dashing" then
	hum.WalkSpeed = 60
	hum.AutoRotate = false
	
	local horizontal = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
	if horizontal.Magnitude > 0 then
	    hum:Move(horizontal.Unit)
	end
end
if _G.AutoBlock or _G.Punch then
	local Punch = maingui and maingui:FindFirstChild("AbilityContainer") and maingui.AbilityContainer:FindFirstChild("Punch")
    local charges = Punch and Punch:FindFirstChild("Charges")
    local Block = maingui and maingui:FindFirstChild("AbilityContainer") and maingui.AbilityContainer:FindFirstChild("Block")
    local cooldown = Block and Block:FindFirstChild("CooldownTime")
    
	for _, v in ipairs(playerout:GetPlayers()) do
	    if v ~= player and v.Character then
	        local hrp = v.Character:FindFirstChild("HumanoidRootPart")
	        local humplr = v.Character:FindFirstChildOfClass("Humanoid")
	        local animTracks = humplr and humplr:FindFirstChildOfClass("Animator") and humplr:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()
	        if hrp and Distance2(hrp.Position) <= (_G.DetectionRange or 18) then
	            for _, track in ipairs(animTracks or {}) do
	                if table.find(Animations["KillerAnima"], tostring(track.Animation.AnimationId):match("%d+")) then
                        if _G.AutoBlock and Distance2(hrp.Position) <= (_G.DetectionRange or 18) then
                            if isFacing(hrp) then
	                            if cooldown and cooldown.Text == "" then
                                    Remote:FireServer("UseActorAbility", {buffer.fromstring("\"Block\"")})
                                end
                                if _G.Punch and charges and charges.Text == "1" then
                                    Remote:FireServer("UseActorAbility", {buffer.fromstring("\"Punch\"")})
                                end
                            end
                        end
                    end
	            end
	        end
	    end
	end
end
if _G.Aimbot or _G.AimbotPunch then
	local playing = PlayingAnimationId()
    local triggered = false
    for v in pairs(Animations["Shot - Punch"]) do
        if playing[v] then
            triggered = true
            break
        end
    end
    if triggered then
        Time = tick()
        aiming = true
    end
    if aiming and tick() - Time <= 1.7 then
        if not WS then
            WS = hum.WalkSpeed
            JP = hum.JumpPower
            AutoRotate = hum.AutoRotate
        end
        hum.AutoRotate = false
        root.AssemblyAngularVelocity = Vector3.zero
        local targetHRP = KillerTarget()
        local prediction = _G.Prediction or 1
        if targetHRP then
            local predictedPos = targetHRP.Position + (targetHRP.CFrame.LookVector * prediction)
            local direction = (predictedPos - root.Position).Unit
            local yRot = math.atan2(-direction.X, -direction.Z)
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, yRot, 0)
        end
    elseif aiming then
        aiming = false
        if WS and JP and AutoRotate then
            hum.WalkSpeed = WS
            hum.JumpPower = JP
            hum.AutoRotate = AutoRotate
            WS, JP, AutoRotate = nil, nil, nil
        end
    end
end
end)

local Window = Library:CreateWindow({
    Title = "Forsake",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "Omega X Article Hub Version: 1.0.5",
	Icon = 125448486325517,
	AutoLock = true,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 2,
    MenuFadeTime = 0
})

Tabs = {
	Tab = Window:AddTab(T("Main"), "rbxassetid://7734053426"),
	Tab2 = Window:AddTab(T("Auto"), "rbxassetid://7734056608"),
	["UI Settings"] = Window:AddTab(T("UI Settings"), "rbxassetid://7733955511")
}

local Main1Group = Tabs.Tab:AddLeftGroupbox(T("Main"))

Main1Group:AddToggle("AutoGeneral", {
    Text = T("Auto Generator"),
    Default = false, 
    Callback = function(Value) 
_G.AutoGeneral = Value
while _G.AutoGeneral do
if workspace.Map.Ingame:FindFirstChild("Map") then
for i, v in ipairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
if v.Name == "Generator" and v:FindFirstChild("Remotes") and v.Remotes:FindFirstChild("RE") and v:FindFirstChild("Progress").Value ~= 100 then
v.Remotes:FindFirstChild("RE"):FireServer()
end
end
end
task.wait(2)
end
    end
})

Main1Group:AddButton(T("Teleport To Generator"), function()
if workspace.Map.Ingame:FindFirstChild("Map") then
	for i, v in ipairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
		if v.Name == "Generator" and v:FindFirstChild("Positions") and v.Positions:FindFirstChild("Center") and v:FindFirstChild("Progress").Value ~= 100 then
			root.CFrame = v.Positions:FindFirstChild("Center").CFrame
			break
		end
	end
end
end)

Main1Group:AddToggle("InfStamina", {
    Text = T("Inf Stamina"),
    Default = false, 
    Callback = function(Value) 
_G.InfStamina = Value
while _G.InfStamina do
local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
if staminaModule then
    staminaModule.MaxStamina = 999999
    staminaModule.Stamina = 999999
    staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
end
task.wait()
end
    end
})

Main1Group:AddSlider("Speed", {
    Text = T("WalkSpeed"),
    Default = 20,
    Min = 7,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.SpeedWalk = Value
    end
})

Main1Group:AddToggle("SetSpeed", {
    Text = T("Set Speed"),
    Default = false, 
    Callback = function(Value) 
_G.NahSpeed = Value
while _G.NahSpeed do
if hum then
hum:SetAttribute("BaseSpeed", _G.SpeedWalk)
end
task.wait()
end
    end
})

local Main3Group = Tabs.Tab:AddLeftGroupbox(T("Misc"))

Main3Group:AddSlider("Health", {
    Text = T("Health"),
    Default = 20,
    Min = 7,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.HealthPizza = Value
    end
})

Main3Group:AddToggle("AutoEatPizza", {
    Text = T("Auto Eat Pizza"),
    Default = false, 
    Callback = function(Value) 
_G.AutoEatPizza = Value
while _G.AutoEatPizza do
if hum and hum.Health <= _G.HealthPizza then
	local OldCFrame = root.CFrame
	local pizza = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Pizza")
	if pizza and pizza:IsA("BasePart") then
		root.CFrame = pizza.CFrame
		task.wait(0.5)
		root.CFrame = OldCFrame
		wait(0.3)
	end
end
task.wait()
end
    end
})

Main3Group:AddToggle("VoidRushBypass", {
    Text = T("Void Rush Bypass"),
    Default = false, 
    Callback = function(Value) 
getgenv()._VoidRushBypass = Value
    end
})

Main3Group:AddToggle("VoidRushControl", {
    Text = T("Void Rush Control"),
    Default = false, 
    Callback = function(Value) 
_G.VoidRushControl = Value
if Value == false then
	if hum then
        hum.WalkSpeed = 16 
        hum.AutoRotate = true
        hum:Move(Vector3.new(0, 0, 0))
    end
end
    end
})

local Main2Group = Tabs.Tab:AddRightGroupbox(T("Esp"))

Main2Group:AddToggle("Generator", {
    Text = T("Esp Generator"),
    Default = false, 
    Callback = function(Value) 
_G.EspGeneral = Value
if _G.EspGeneral == false then
	if workspace.Map.Ingame:FindFirstChild("Map") then
		for i, v in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
			if v.Name == "Generator" then
				ESPLibrary:RemoveESP(v)
			end
		end
	end
end
while _G.EspGeneral do
if workspace.Map.Ingame:FindFirstChild("Map") then
	for i, v in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
		if v.Name == "Generator" and v:FindFirstChild("Progress") then
			if v.Progress.Value == 100 then
				GeneratorColor = Color3.fromRGB(0, 255, 0)
			else
				GeneratorColor = _G.ColorEspGen or Color3.fromRGB(9, 123, 237)
			end
			local TextGen = "Generator ("..v.Progress.Value..")"
			ESPLibrary:AddESP({
				Object = v,
				Text = TextGen,
				Color = GeneratorColor
			})
			ESPLibrary:UpdateObjectText(v, TextGen)
			ESPLibrary:UpdateObjectColor(v, GeneratorColor)
			ESPLibrary:SetOutlineColor(GeneratorColor)
		end
	end
end
task.wait()
end
    end
}):AddColorPicker("Color Esp Gen", {
     Default = Color3.fromRGB(9, 123, 237),
     Callback = function(Value)
_G.ColorEspGen = Value
     end
})

Main2Group:AddToggle("Killer", {
    Text = T("Esp Killer"),
    Default = false, 
    Callback = function(Value) 
_G.EspKiller = Value
if _G.EspKiller == false then
	for i, v in pairs(game.Workspace.Players:GetChildren()) do
		if v.Name == "Killers" then
			for y, z in pairs(v:GetChildren()) do
				ESPLibrary:RemoveESP(z)
			end
		end
	end
end
while _G.EspKiller do
for i, v in pairs(game.Workspace.Players:GetChildren()) do
	if v.Name == "Killers" then
		for y, z in pairs(v:GetChildren()) do
			if z:GetAttribute("Username") ~= player.Name then
				local KillerColor = _G.ColorLightKill or Color3.new(255, 0, 0)
				local TextKiller = z.Name
				ESPLibrary:AddESP({
					Object = z,
					Text = TextKiller,
					Color = KillerColor
				})
				ESPLibrary:UpdateObjectText(z, TextKiller)
				ESPLibrary:UpdateObjectColor(z, KillerColor)
				ESPLibrary:SetOutlineColor(KillerColor)
			end
		end
	end
end
task.wait()
end
    end
}):AddColorPicker("Color Esp1", {
     Default = Color3.new(255, 0, 0),
     Callback = function(Value)
_G.ColorLightKill = Value
     end
})

Main2Group:AddToggle("Survivors", {
    Text = T("Esp Survivors"),
    Default = false, 
    Callback = function(Value) 
_G.EspSurvivors = Value
if _G.EspSurvivors == false then
	for i, v in pairs(game.Workspace.Players:GetChildren()) do
		if v.Name == "Survivors" then
			for y, z in pairs(v:GetChildren()) do
				ESPLibrary:RemoveESP(z)
			end
		end
	end
end
while _G.EspSurvivors do
for i, v in pairs(game.Workspace.Players:GetChildren()) do
	if v.Name == "Survivors" then
		for y, z in pairs(v:GetChildren()) do
			if z:GetAttribute("Username") ~= player.Name then
				local SurvivorsColor = _G.ColorLightSurvivors or Color3.new(0, 255, 0)
				local TextSurvivors = z.Name
				ESPLibrary:AddESP({
					Object = z,
					Text = TextSurvivors,
					Color = SurvivorsColor
				})
				ESPLibrary:UpdateObjectText(z, TextSurvivors)
				ESPLibrary:UpdateObjectColor(z, SurvivorsColor)
				ESPLibrary:SetOutlineColor(SurvivorsColor)
			end
		end
	end
end
task.wait()
end
    end
}):AddColorPicker("Color Esp2", {
     Default = Color3.new(0, 255, 0),
     Callback = function(Value)
_G.ColorLightSurvivors = Value
     end
})

Main2Group:AddToggle("Item", {
    Text = T("Esp Item"),
    Default = false, 
    Callback = function(Value) 
_G.EspItem = Value
if _G.EspItem == false then
	if workspace.Map.Ingame:FindFirstChild("Map") then
		for i, v in ipairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
			if v:IsA("Tool") then
				ESPLibrary:RemoveESP(v)
			end
		end
	end
	if workspace.Map:FindFirstChild("Ingame") then
		for i, v in ipairs(workspace.Map.Ingame:GetChildren()) do
			if v:IsA("Tool") then
				ESPLibrary:RemoveESP(v)
			end
		end
	end
else
	function EspItem(v)
		if v:IsA("Tool") then
			local ItemColor = _G.ColorItem or Color3.new(0, 255, 0)
			local TextItem = v.Name
			ESPLibrary:AddESP({
				Object = v,
				Text = TextItem,
				Color = ItemColor
			})
			ESPLibrary:UpdateObjectText(v, TextItem)
			ESPLibrary:UpdateObjectColor(v, ItemColor)
			ESPLibrary:SetOutlineColor(ItemColor)
		end
	end
end
while _G.EspItem do
if workspace.Map.Ingame:FindFirstChild("Map") then
	for i, v in ipairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
		EspItem(v)
	end
end
if workspace.Map:FindFirstChild("Ingame") then
	for i, v in ipairs(workspace.Map.Ingame:GetChildren()) do
		EspItem(v)
	end
end
task.wait()
end
    end
}):AddColorPicker("Color Esp2 Item", {
     Default = Color3.new(0, 255, 0),
     Callback = function(Value)
_G.ColorItem = Value
     end
})

local Esp1 = Tabs.Tab:AddRightGroupbox(T("Settings Esp"))

local Font = {}
for _, v in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(Font, v.Name)
end
Esp1:AddDropdown("Font", {
    Text = T("Set Font"),
    Values = Font,
    Default = "Code",
    Multi = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFont(Value)
end
    end
})

Esp1:AddToggle("ShowDistance", {
    Text = T("Show Distance"),
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetShowDistance(Value)
end
    end
})

Esp1:AddToggle("ShowRainbow", {
    Text = T("Show Rainbow"),
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetRainbow(Value)
end
    end
})

Esp1:AddToggle("ShowTracers", {
    Text = T("Show Tracers"),
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracers(Value)
end
    end
})

Esp1:AddDropdown("TracersOrigin", {
    Text = T("Tracers Origin"),
    Multi = false,
    Values = {"Bottom", "Top", "Center", "Mouse"},
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracerOrigin(Value)
end
    end
})

Esp1:AddToggle("ShowArrows", {
    Text = T("Show Arrows"),
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrows(Value)
end
    end
})

Esp1:AddSlider("ArrowsSize", {
    Text = T("Set Arrows Radius"),
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

Esp1:AddSlider("SetTextSize", {
    Text = T("Set TextSize"),
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

Esp1:AddSlider("SetFillTransparency", {
    Text = T("Set Fill Transparency"),
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

Esp1:AddSlider("SetOutlineTransparency", {
    Text = T("Set OutLine Transparency"),
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

local Anti1Group = Tabs.Tab2:AddLeftGroupbox(T("Auto Block"))

Anti1Group:AddToggle("AutoBlock", {
    Text = T("Auto Block"),
    Default = false, 
    Callback = function(Value) 
_G.AutoBlock = Value
    end
})

Anti1Group:AddToggle("AutoPunch", {
    Text = T("Auto Punch"),
    Default = false, 
    Callback = function(Value) 
_G.Punch = Value
    end
})

Anti1Group:AddToggle("AimbotPunch", {
    Text = T("Aimbot Punch"),
    Default = false, 
    Callback = function(Value) 
_G.AimbotPunch = Value
    end
})

Anti1Group:AddSlider("PunchFlingPower", {
    Text = T("Punch Fling Power"),
    Default = 10000,
    Min = 1000,
    Max = 1000000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.PunchFlingPower = Value
    end
})

Anti1Group:AddSlider("DetectionRange", {
    Text = T("Detection Range (Animation)"),
    Default = 18,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.DetectionRange = Value
    end
})

local Anti2Group = Tabs.Tab2:AddRightGroupbox(T("Auto Stun"))

Anti2Group:AddToggle("Aimbot", {
    Text = T("Chance Aimbot Shot"),
    Default = false, 
    Callback = function(Value) 
_G.Aimbot = Value
    end
})

Anti2Group:AddSlider("Sharpness", {
    Text = T("Sharpness"),
    Default = 4,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.Prediction = Value
    end
})

------------------------------------------------------------------------
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox(T("Menu"))
local CreditsGroup = Tabs["UI Settings"]:AddRightGroupbox(T("Credits"))
local Info = Tabs["UI Settings"]:AddRightGroupbox(T("Info"))

-- 语言切换功能
MenuGroup:AddDropdown("LanguageSelect", {
    Text = T("Language"),
    Values = {"English", "Việt Nam", "China"},
    Default = "English",
    Multi = false,
    Callback = function(Value)
        _G.CurrentLanguage = Value
        UpdateUILanguage()
    end
})

MenuGroup:AddDropdown("NotifySide", {
    Text = T("Notification Side"),
    Values = {"Left", "Right"},
    Default = "Right",
    Multi = false,
    Callback = function(Value)
Library:SetNotifySide(Value)
    end
})

_G.ChooseNotify = "Obsidian"
MenuGroup:AddDropdown("NotifyChoose", {
    Text = T("Notification Choose"),
    Values = {"Obsidian", "Roblox"},
    Default = "Obsidian",
    Multi = false,
    Callback = function(Value)
_G.ChooseNotify = Value
    end
})

_G.NotificationSound = true
MenuGroup:AddToggle("NotifySound", {
    Text = T("Notification Sound"),
    Default = true, 
    Callback = function(Value) 
_G.NotificationSound = Value 
    end
})

MenuGroup:AddSlider("VolumeNotification", {
    Text = T("Volume Notification"),
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.VolumeTime = Value
    end
})

MenuGroup:AddToggle("KeybindMenuOpen", {Default = false, Text = T("Open Keybind Menu"), Callback = function(Value) Library.KeybindFrame.Visible = Value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = T("Custom Cursor"), Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel(T("Menu bind")):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = T("Menu bind")})
_G.LinkJoin = loadstring(game:HttpGet("https://pastefy.app/2LKQlhQM/raw"))()
MenuGroup:AddButton(T("Copy Link Discord"), function()
    if setclipboard then
        setclipboard(_G.LinkJoin["Discord"])
        Library:Notify("Copied discord link to clipboard!")
    else
        Library:Notify("Discord link: ".._G.LinkJoin["Discord"], 10)
    end
end):AddButton(T("Copy Link Zalo"), function()
    if setclipboard then
        setclipboard(_G.LinkJoin["Zalo"])
        Library:Notify("Copied Zalo link to clipboard!")
    else
        Library:Notify("Zalo link: ".._G.LinkJoin["Zalo"], 10)
    end
end)
MenuGroup:AddButton(T("Unload"), function() Library:Unload() end)
CreditsGroup:AddLabel("AmongUs - Python / Dex / Script", true)
CreditsGroup:AddLabel("Giang Hub - Script / Dex", true)
CreditsGroup:AddLabel("Vu - Script / Dex", true)

Info:AddLabel(T("Counter") .. " [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true)
Info:AddLabel(T("Executor") .. " [ "..identifyexecutor().." ]", true)
Info:AddLabel(T("Job Id") .. " [ "..game.JobId.." ]", true)
Info:AddDivider()
Info:AddButton(T("Copy JobId"), function()
    if setclipboard then
        setclipboard(tostring(game.JobId))
        Library:Notify("Copied Success")
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Info:AddInput("JoinJob", {
    Default = "Nah",
    Numeric = false,
    Text = T("Join Job"),
    Placeholder = "UserJobId",
    Callback = function(Value)
_G.JobIdJoin = Value
    end
})

Info:AddButton(T("Join JobId"), function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobIdJoin, game.Players.LocalPlayer)
end)

Info:AddButton(T("Copy Join JobId"), function()
    if setclipboard then
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, '..game.JobId..", game.Players.LocalPlayer)")
        Library:Notify("Copied Success") 
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
[file content end]