local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local PFS = game:GetService("PathfindingService")
local Storage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local playerout = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

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

-- 语言切换系统
local LANG = {
    English = {
        -- 主标签
        AutoGeneral = "Auto Generator",
        TeleportGenerator = "Teleport To Generator",
        TeleportMedkid = "Teleport To Medkid",
        TeleportBloxyCola = "Teleport To BloxyCola",
        InfStamina = "Inf Stamina",
        SpeedWalk = "WalkSpeed",
        SetSpeed = "Set Speed",
        Health = "Health",
        AutoEatPizza = "Auto Eat Pizza",
        VoidRushBypass = "Void Rush Bypass",
        VoidRushControl = "Void Rush Control",
        
        -- ESP
        EspGenerator = "Esp Generator",
        EspKiller = "Esp Killer",
        EspSurvivors = "Esp Survivors",
        EspItem = "Esp Item",
        ColorEspGen = "Color Esp Gen",
        ColorEsp1 = "Color Esp1",
        ColorEsp2 = "Color Esp2",
        ColorEsp2Item = "Color Esp2 Item",
        
        -- ESP设置
        SetFont = "Set Font",
        ShowDistance = "Show Distance",
        ShowRainbow = "Show Rainbow",
        ShowTracers = "Show Tracers",
        TracersOrigin = "Tracers Origin",
        ShowArrows = "Show Arrows",
        ArrowsSize = "Set Arrows Radius",
        SetTextSize = "Set TextSize",
        SetFillTransparency = "Set Fill Transparency",
        SetOutlineTransparency = "Set OutLine Transparency",
        
        -- 自动格挡
        AutoBlock = "Auto Block",
        AutoPunch = "Auto Punch",
        AimbotPunch = "Aimbot Punch",
        DetectionRange = "Detection Range (Animation)",
        
        -- 自动眩晕
        Aimbot = "Chance Aimbot Shot",
        Sharpness = "Sharpness",
        
        -- UI设置
        NotifySide = "Notification Side",
        NotifyChoose = "Notification Choose",
        NotifySound = "Notification Sound",
        VolumeNotification = "Volume Notification",
        KeybindMenuOpen = "Open Keybind Menu",
        ShowCustomCursor = "Custom Cursor",
        MenuBind = "Menu bind",
        Unload = "Unload",
        
        -- 信息
        Counter = "Counter",
        Executor = "Executor",
        JobId = "Job Id",
        CopyJobId = "Copy JobId",
        JoinJob = "Join Job",
        JoinJobId = "Join JobId",
        CopyJoinJobId = "Copy Join JobId",
        
        -- 标签名称
        TabMain = "Main",
        TabAuto = "Auto",
        TabUISettings = "UI Settings",
        TabCredit = "Credit / Join",
        
        -- 组框名称
        GroupMain = "Main",
        GroupMisc = "Misc",
        GroupEsp = "Esp",
        GroupSettingsEsp = "Settings Esp",
        GroupAutoBlock = "Auto Block",
        GroupAutoStun = "Auto Stun",
        GroupCredit = "Credit",
        GroupJoinServer = "Join Server",
        GroupMenu = "Menu",
        GroupInfo = "Info",
        
        -- 水印信息
        WatermarkKiller = "Killer",
        WatermarkSpeed = "Speed",
        WatermarkFPS = "FPS",
        WatermarkMS = "MS",
        
        -- 通知
        NotifyCopied = "Copied Success",
        NotifyNowLanguage = "Language changed to: ",
        NotifyLoaded = "Forsake loaded - "
    },
    
    ["Việt Nam"] = {
        -- 主标签
        AutoGeneral = "Tự Động Máy Phát",
        TeleportGenerator = "Dịch Chuyển Đến Máy Phát",
        TeleportMedkid = "Dịch Chuyển Đến Túi Cứu Thương",
        TeleportBloxyCola = "Dịch Chuyển Đến BloxyCola",
        InfStamina = "Thể Lực Vô Hạn",
        SpeedWalk = "Tốc Độ Di Chuyển",
        SetSpeed = "Đặt Tốc Độ",
        Health = "Máu",
        AutoEatPizza = "Tự Động Ăn Pizza",
        VoidRushBypass = "Bỏ Qua Void Rush",
        VoidRushControl = "Điều Khiển Void Rush",
        
        -- ESP
        EspGenerator = "Định Vị Máy Phát",
        EspKiller = "Định Vị Kẻ Sát Nhân",
        EspSurvivors = "Định Vị Người Sống Sót",
        EspItem = "Định Vị Vật Phẩm",
        ColorEspGen = "Màu Máy Phát",
        ColorEsp1 = "Màu Kẻ Sát Nhân",
        ColorEsp2 = "Màu Người Sống Sót",
        ColorEsp2Item = "Màu Vật Phẩm",
        
        -- ESP设置
        SetFont = "Chọn Phông Chữ",
        ShowDistance = "Hiển Thị Khoảng Cách",
        ShowRainbow = "Hiển Thị Cầu Vồng",
        ShowTracers = "Hiển Thị Đường Kẻ",
        TracersOrigin = "Gốc Đường Kẻ",
        ShowArrows = "Hiển Thị Mũi Tên",
        ArrowsSize = "Kích Thước Mũi Tên",
        SetTextSize = "Kích Thước Chữ",
        SetFillTransparency = "Độ Trong Suốt Nền",
        SetOutlineTransparency = "Độ Trong Suốt Viền",
        
        -- 自动格挡
        AutoBlock = "Tự Động Chặn",
        AutoPunch = "Tự Động Đấm",
        AimbotPunch = "Tự Động Ngắm Đấm",
        DetectionRange = "Phạm Vi Phát Hiện (Hoạt Ảnh)",
        
        -- 自动眩晕
        Aimbot = "Tự Động Ngắm Bắn",
        Sharpness = "Độ Sắc Nét",
        
        -- UI设置
        NotifySide = "Vị Trí Thông Báo",
        NotifyChoose = "Chọn Loại Thông Báo",
        NotifySound = "Âm Thanh Thông Báo",
        VolumeNotification = "Âm Lượng Thông Báo",
        KeybindMenuOpen = "Mở Menu Phím Tắt",
        ShowCustomCursor = "Con Trỏ Tùy Chỉnh",
        MenuBind = "Phím Menu",
        Unload = "Tắt",
        
        -- 信息
        Counter = "Quốc Gia",
        Executor = "Trình Thực Thi",
        JobId = "Mã Phòng",
        CopyJobId = "Sao Chép Mã Phòng",
        JoinJob = "Tham Gia Phòng",
        JoinJobId = "Tham Gia Mã Phòng",
        CopyJoinJobId = "Sao Chép Lệnh Tham Gia",
        
        -- 标签名称
        TabMain = "Chính",
        TabAuto = "Tự Động",
        TabUISettings = "Cài Đặt UI",
        TabCredit = "Tín Dụng / Tham Gia",
        
        -- 组框名称
        GroupMain = "Chính",
        GroupMisc = "Khác",
        GroupEsp = "Định Vị",
        GroupSettingsEsp = "Cài Đặt Định Vị",
        GroupAutoBlock = "Tự Động Chặn",
        GroupAutoStun = "Tự Động Choáng",
        GroupCredit = "Tín Dụng",
        GroupJoinServer = "Tham Gia Máy Chủ",
        GroupMenu = "Menu",
        GroupInfo = "Thông Tin",
        
        -- 水印信息
        WatermarkKiller = "Kẻ Sát Nhân",
        WatermarkSpeed = "Tốc Độ",
        WatermarkFPS = "FPS",
        WatermarkMS = "MS",
        
        -- 通知
        NotifyCopied = "Đã Sao Chép Thành Công",
        NotifyNowLanguage = "Đã đổi ngôn ngữ thành: ",
        NotifyLoaded = "Forsake đã tải - "
    },
    
    China = {
        -- 主标签
        AutoGeneral = "自动修机",
        TeleportGenerator = "传送到发电机",
        TeleportMedkid = "传送到医疗包",
        TeleportBloxyCola = "传送到Bloxy可乐",
        InfStamina = "无限体力",
        SpeedWalk = "移动速度",
        SetSpeed = "设置速度",
        Health = "生命值",
        AutoEatPizza = "自动吃披萨",
        VoidRushBypass = "Void Rush绕过",
        VoidRushControl = "Void Rush控制",
        
        -- ESP
        EspGenerator = "透视发电机",
        EspKiller = "透视杀手",
        EspSurvivors = "透视幸存者",
        EspItem = "透视物品",
        ColorEspGen = "发电机颜色",
        ColorEsp1 = "杀手颜色",
        ColorEsp2 = "幸存者颜色",
        ColorEsp2Item = "物品颜色",
        
        -- ESP设置
        SetFont = "设置字体",
        ShowDistance = "显示距离",
        ShowRainbow = "显示彩虹",
        ShowTracers = "显示追踪线",
        TracersOrigin = "追踪线起点",
        ShowArrows = "显示箭头",
        ArrowsSize = "设置箭头半径",
        SetTextSize = "设置文字大小",
        SetFillTransparency = "设置填充透明度",
        SetOutlineTransparency = "设置轮廓透明度",
        
        -- 自动格挡
        AutoBlock = "自动格挡",
        AutoPunch = "自动出拳",
        AimbotPunch = "自动瞄准出拳",
        DetectionRange = "检测范围(动画)",
        
        -- 自动眩晕
        Aimbot = "自动瞄准射击",
        Sharpness = "锐度",
        
        -- UI设置
        NotifySide = "通知位置",
        NotifyChoose = "选择通知类型",
        NotifySound = "通知声音",
        VolumeNotification = "通知音量",
        KeybindMenuOpen = "打开键位设置",
        ShowCustomCursor = "自定义光标",
        MenuBind = "菜单键位",
        Unload = "卸载",
        
        -- 信息
        Counter = "国家",
        Executor = "执行器",
        JobId = "房间ID",
        CopyJobId = "复制房间ID",
        JoinJob = "加入房间",
        JoinJobId = "加入房间ID",
        CopyJoinJobId = "复制加入命令",
        
        -- 标签名称
        TabMain = "主要",
        TabAuto = "自动",
        TabUISettings = "UI设置",
        TabCredit = "信用/加入",
        
        -- 组框名称
        GroupMain = "主要",
        GroupMisc = "杂项",
        GroupEsp = "透视",
        GroupSettingsEsp = "透视设置",
        GroupAutoBlock = "自动格挡",
        GroupAutoStun = "自动眩晕",
        GroupCredit = "信用",
        GroupJoinServer = "加入服务器",
        GroupMenu = "菜单",
        GroupInfo = "信息",
        
        -- 水印信息
        WatermarkKiller = "杀手",
        WatermarkSpeed = "速度",
        WatermarkFPS = "FPS",
        WatermarkMS = "MS",
        
        -- 通知
        NotifyCopied = "复制成功",
        NotifyNowLanguage = "语言已切换为: ",
        NotifyLoaded = "Forsake已加载 - "
    }
}

local CUR_LANG = "English"
function _T(k) return LANG[CUR_LANG][k] or k end

local CTRL = {}
function Reg(ctrl, key)
    if ctrl and ctrl.SetText then
        ctrl:SetText(_T(key))
        table.insert(CTRL, {C = ctrl, K = key})
    end
    return ctrl
end

function RefreshAll()
    for _, v in ipairs(CTRL) do
        if v.C and v.C.SetText then
            v.C:SetText(_T(v.K))
        end
    end
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
if not getgenv()._oldFireServer and hookmetamethod and getnamecallmethod then
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
		["108807732150251"] = true, ["138040001965654"] = true, ["86096387000557"] = true, ["86545133269813"] = true,
		["89448354637442"] = true, ["116618003477002"] = true
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
Library:SetWatermark((_T("WatermarkKiller")..": %s (%s m) | %s ".._T("WatermarkSpeed").." | %s ".._T("WatermarkFPS").." | %s ".._T("WatermarkMS")):format(
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
if _G.VoidRushControl then
	local VoidRush = char and char:GetAttribute("VoidRushState")
	if VoidRush and VoidRush == "Dashing" then
		hum.WalkSpeed = 60
		hum.AutoRotate = false
		
		local Look = root.CFrame.LookVector
		local horizontal = Vector3.new(Look.X, 0, Look.Z)
		if horizontal.Magnitude > 0 then
		    hum:Move(horizontal.Unit)
		end
	else
		if hum then
			hum.AutoRotate = true
		end
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
	Tab = Window:AddTab(_T("TabMain"), "rbxassetid://7734053426"),
	Tab2 = Window:AddTab(_T("TabAuto"), "rbxassetid://7734056608"),
	["UI Settings"] = Window:AddTab(_T("TabUISettings"), "rbxassetid://7733955511")
}

local Main1Group = Tabs.Tab:AddLeftGroupbox(_T("GroupMain"))

Reg(Main1Group:AddToggle("AutoGeneral", {
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
}), "AutoGeneral")

Reg(Main1Group:AddButton("Teleport To Generator", function()
if workspace.Map.Ingame:FindFirstChild("Map") then
	for i, v in ipairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
		if v.Name == "Generator" and v:FindFirstChild("Positions") and v.Positions:FindFirstChild("Center") and v:FindFirstChild("Progress").Value ~= 100 then
			root.CFrame = v.Positions:FindFirstChild("Center").CFrame
			break
		end
	end
end
end), "TeleportGenerator")

local function getItem(itemName)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "ItemRoot" and v.Parent and v.Parent.Name == itemName then
            return v
        end
    end
end

Reg(Main1Group:AddButton("Teleport To Medkid", function()
local Medkid = getItem("Medkid")
if Medkid then
	root.CFrame = Medkid.CFrame + Vector3.new(0, 3, 0)
end
end), "TeleportMedkid")

Reg(Main1Group:AddButton("Teleport To BloxyCola", function()
local BloxyCola = getItem("BloxyCola")
if BloxyCola then
	root.CFrame = BloxyCola.CFrame + Vector3.new(0, 3, 0)
end
end), "TeleportBloxyCola")

Reg(Main1Group:AddToggle("Inf Stamina", {
    Default = false, 
    Callback = function(Value) 
_G.InfStamina = Value
while _G.InfStamina do
local staminaModule = require(Storage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
if staminaModule then
    staminaModule.MaxStamina = 999999
    staminaModule.Stamina = 999999
    staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
end
task.wait()
end
    end
}), "InfStamina")

local speedSlider = Main1Group:AddSlider("Speed", {
    Default = 20,
    Min = 7,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.SpeedWalk = Value
    end
})
Reg(speedSlider, "SpeedWalk")

Reg(Main1Group:AddToggle("SetSpeed", {
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
}), "SetSpeed")

local Main3Group = Tabs.Tab:AddLeftGroupbox(_T("GroupMisc"))

local healthSlider = Main3Group:AddSlider("Health", {
    Default = 20,
    Min = 7,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.HealthPizza = Value
    end
})
Reg(healthSlider, "Health")

Reg(Main3Group:AddToggle("Auto Eat Pizza", {
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
}), "AutoEatPizza")

if hookmetamethod then
Reg(Main3Group:AddToggle("VoidRushBypass", {
    Default = false, 
    Callback = function(Value) 
getgenv()._VoidRushBypass = Value
    end
}), "VoidRushBypass")
end

Reg(Main3Group:AddToggle("VoidRushControl", {
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
}), "VoidRushControl")

local Main2Group = Tabs.Tab:AddRightGroupbox(_T("GroupEsp"))

local espGenToggle = Main2Group:AddToggle("Generator", {
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
			local TextGen = "Generator ("..v.Progress.Value.."%)"
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
})
Reg(espGenToggle, "EspGenerator")
espGenToggle:AddColorPicker("Color Esp Gen", {
     Default = Color3.fromRGB(9, 123, 237),
     Callback = function(Value)
_G.ColorEspGen = Value
     end
})

local espKillerToggle = Main2Group:AddToggle("Killer", {
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
				local TextKiller = z.Name.." ("..z:GetAttribute("Username")..")"
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
})
Reg(espKillerToggle, "EspKiller")
espKillerToggle:AddColorPicker("Color Esp1", {
     Default = Color3.new(255, 0, 0),
     Callback = function(Value)
_G.ColorLightKill = Value
     end
})

local espSurvivorsToggle = Main2Group:AddToggle("Survivors", {
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
				local TextSurvivors = z.Name.." ("..z:GetAttribute("Username")..")"
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
})
Reg(espSurvivorsToggle, "EspSurvivors")
espSurvivorsToggle:AddColorPicker("Color Esp2", {
     Default = Color3.new(0, 255, 0),
     Callback = function(Value)
_G.ColorLightSurvivors = Value
     end
})

local espItemToggle = Main2Group:AddToggle("Item", {
    Default = false, 
    Callback = function(Value) 
_G.EspItem = Value
if _G.EspItem == false then
	if workspace.Map.Ingame:FindFirstChild("Map") then
		for i, v in ipairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
			if v:IsA("Tool") then
				local PartItem = v:FindFirstChildWhichIsA("BasePart")
				if PartItem then
					ESPLibrary:RemoveESP(PartItem)
				end
			end
		end
	end
	if workspace.Map:FindFirstChild("Ingame") then
		for i, v in ipairs(workspace.Map.Ingame:GetChildren()) do
			if v:IsA("Tool") then
				local PartItem = v:FindFirstChildWhichIsA("BasePart")
				if PartItem then
					ESPLibrary:RemoveESP(PartItem)
				end
			end
		end
	end
else
	function EspItem(v)
		if v:IsA("Tool") then
			local PartItem = v:FindFirstChildWhichIsA("BasePart")
			if PartItem then
				local ItemColor = _G.ColorItem or Color3.new(0, 255, 0)
				local TextItem = v.Name
				ESPLibrary:AddESP({
					Object = PartItem,
					Text = TextItem,
					Color = ItemColor
				})
				ESPLibrary:UpdateObjectText(PartItem, TextItem)
				ESPLibrary:UpdateObjectColor(PartItem, ItemColor)
				ESPLibrary:SetOutlineColor(ItemColor)
			end
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
})
Reg(espItemToggle, "EspItem")
espItemToggle:AddColorPicker("Color Esp2 Item", {
     Default = Color3.new(0, 255, 0),
     Callback = function(Value)
_G.ColorItem = Value
     end
})

local Esp1 = Tabs.Tab:AddRightGroupbox(_T("GroupSettingsEsp"))

local Font = {}
for _, v in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(Font, v.Name)
end
Reg(Esp1:AddDropdown("Font", {
    Values = Font,
    Default = "Code",
    Multi = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFont(Value)
end
    end
}), "SetFont")

Reg(Esp1:AddToggle("Show Distance", {
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetShowDistance(Value)
end
    end
}), "ShowDistance")

Reg(Esp1:AddToggle("Show Rainbow", {
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetRainbow(Value)
end
    end
}), "ShowRainbow")

Reg(Esp1:AddToggle("Show Tracers", {
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracers(Value)
end
    end
}), "ShowTracers")

Reg(Esp1:AddDropdown("TracersOrigin", {
    Multi = false,
    Values = {"Bottom", "Top", "Center", "Mouse"},
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracerOrigin(Value)
end
    end
}), "TracersOrigin")

Reg(Esp1:AddToggle("Show Arrows", {
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrows(Value)
end
    end
}), "ShowArrows")

Reg(Esp1:AddSlider("ArrowsSize", {
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
}), "ArrowsSize")

Reg(Esp1:AddSlider("SetTextSize", {
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
}), "SetTextSize")

Reg(Esp1:AddSlider("SetFillTransparency", {
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
}), "SetFillTransparency")

Reg(Esp1:AddSlider("SetOutlineTransparency", {
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
}), "SetOutlineTransparency")

local Anti1Group = Tabs.Tab2:AddLeftGroupbox(_T("GroupAutoBlock"))

Reg(Anti1Group:AddToggle("Auto Block", {
    Default = false, 
    Callback = function(Value) 
_G.AutoBlock = Value
    end
}), "AutoBlock")

Reg(Anti1Group:AddToggle("Auto Punch", {
    Default = false, 
    Callback = function(Value) 
_G.Punch = Value
    end
}), "AutoPunch")

Reg(Anti1Group:AddToggle("Aimbot Punch", {
    Default = false, 
    Callback = function(Value) 
_G.AimbotPunch = Value
    end
}), "AimbotPunch")

local detectionSlider = Anti1Group:AddSlider("Detection Range", {
    Default = 18,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.DetectionRange = Value
    end
})
Reg(detectionSlider, "DetectionRange")

local Anti2Group = Tabs.Tab2:AddRightGroupbox(_T("GroupAutoStun"))

Reg(Anti2Group:AddToggle("Aimbot", {
    Default = false, 
    Callback = function(Value) 
_G.Aimbot = Value
    end
}), "Aimbot")

local sharpnessSlider = Anti2Group:AddSlider("Sharpness", {
    Default = 4,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
_G.Prediction = Value
    end
})
Reg(sharpnessSlider, "Sharpness")

------------------------------------------------------------------------
local Credit = Window:AddTab(_T("TabCredit"), "rbxassetid://7733955511")
local CreditTab = Credit:AddLeftGroupbox(_T("GroupCredit"))
local CreditScript = {
	["Giang Hub"] = {
		Text = '[<font color="rgb(73, 230, 133)">Giang Hub</font>] Co-Owner Of Article Hub and Nihahaha Hub',
		Image = "rbxassetid://138779531145636"
	},
	["Nova Hoang"] = {
		Text = '[<font color="rgb(73, 230, 133)">Nova Hoang (Nguyễn Tn Hoàng)</font>] Owner Of Article Hub and Nihahaha Hub',
		Image = "rbxassetid://77933782593847",
	}
}

if CreditScript then
	for i, v in pairs(CreditScript) do
		CreditTab:AddLabel(CreditScript[i].Text, true)
		CreditTab:AddImage("Image "..i, {Image = CreditScript[i].Image, Height = 200})
	end
else
	CreditTab:AddLabel("[N/A]", true)
end

local CreditTab2 = Credit:AddRightGroupbox(_T("GroupJoinServer"))

local quest = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
local HttpService = game:GetService("HttpService")
local InviteCode = "aD7gjtvPmv"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"
local success, result = pcall(function()
    return HttpService:JSONDecode(quest({
        Url = DiscordAPI,
        Method = "GET",
        Headers = {
            ["User-Agent"] = "RobloxBot/1.0",
            ["Accept"] = "application/json"
        }
    }).Body)
end)

if success and result and result.guild then
	CreditTab2:AddLabel(result.guild.name, true)
	local InfoDiscord = CreditTab2:AddLabel('<font color="#52525b">•</font> Member Count : '..tostring(result.approximate_member_count)..'\n<font color="#16a34a">•</font> Online Count : ' .. tostring(result.approximate_presence_count), true)
	CreditTab2:AddImage("Image Discord", {Image = "rbxassetid://138779531145636", Height = 200})

	CreditTab2:AddButton("Update Info", function()
	    local updated, updatedResult = pcall(function()
            return HttpService:JSONDecode(quest({
                Url = DiscordAPI,
                Method = "GET",
            }).Body)
        end)            
        if updated and updatedResult and updatedResult.guild then
            InfoDiscord:SetText(
                '<font color="#52525b">•</font> Member Count : ' .. tostring(updatedResult.approximate_member_count) ..
                '\n<font color="#16a34a">•</font> Online Count : ' .. tostring(updatedResult.approximate_presence_count)
            )
        end
	end)

    CreditTab2:AddButton("Copy Discord Invite", function()
        setclipboard("https://discord.gg/"..InviteCode)
    end)
else
    CreditTab2:AddLabel("Error fetching Discord Info", true)
    CreditTab2:AddButton("Copy Discord Invite", function()
        setclipboard("https://discord.gg/"..InviteCode)
    end)
end

CreditTab2:AddButton("Copy Zalo", function()
    setclipboard("https://zalo.me/g/qlukiy407")
end)

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox(_T("GroupMenu"))
local Info = Tabs["UI Settings"]:AddRightGroupbox(_T("GroupInfo"))

Reg(MenuGroup:AddDropdown("NotifySide", {
    Values = {"Left", "Right"},
    Default = "Right",
    Multi = false,
    Callback = function(Value)
Library:SetNotifySide(Value)
    end
}), "NotifySide")

_G.ChooseNotify = "Obsidian"
Reg(MenuGroup:AddDropdown("NotifyChoose", {
    Values = {"Obsidian", "Roblox"},
    Default = "Obsidian",
    Multi = false,
    Callback = function(Value)
_G.ChooseNotify = Value
    end
}), "NotifyChoose")

_G.NotificationSound = true
Reg(MenuGroup:AddToggle("NotifySound", {
    Default = true, 
    Callback = function(Value) 
_G.NotificationSound = Value 
    end
}), "NotifySound")

local volumeSlider = MenuGroup:AddSlider("Volume Notification", {
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.VolumeTime = Value
    end
})
Reg(volumeSlider, "VolumeNotification")

Reg(MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = false, 
    Callback = function(Value) 
        Library.KeybindFrame.Visible = Value 
    end
}), "KeybindMenuOpen")

Reg(MenuGroup:AddToggle("ShowCustomCursor", {
    Default = true, 
    Callback = function(Value) 
        Library.ShowCustomCursor = Value 
    end
}), "ShowCustomCursor")

MenuGroup:AddDivider()
local menuBindLabel = MenuGroup:AddLabel("Menu bind")
Reg(menuBindLabel, "MenuBind")
menuBindLabel:AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
Reg(MenuGroup:AddButton("Unload", function() Library:Unload() end), "Unload")

-- 语言选择下拉菜单
Reg(MenuGroup:AddDropdown("Language", {
    Values = {"English", "Việt Nam", "China"},
    Default = CUR_LANG,
    Multi = false,
    Callback = function(Value)
        CUR_LANG = Value
        RefreshAll()
        Library:Notify(_T("NotifyNowLanguage")..Value, 3)
    end
}), "LangTitle")

Reg(Info:AddLabel("Counter [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true), "Counter")
Reg(Info:AddLabel("Executor [ "..identifyexecutor().." ]", true), "Executor")
Reg(Info:AddLabel("Job Id [ "..game.JobId.." ]", true), "JobId")

Info:AddDivider()
Reg(Info:AddButton("Copy JobId", function()
    if setclipboard then
        setclipboard(tostring(game.JobId))
        Library:Notify(_T("NotifyCopied"))
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end), "CopyJobId")

local joinJobInput = Info:AddInput("Join Job", {
    Default = "Nah",
    Numeric = false,
    Placeholder = "UserJobId",
    Callback = function(Value)
_G.JobIdJoin = Value
    end
})
Reg(joinJobInput, "JoinJob")

Reg(Info:AddButton("Join JobId", function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobIdJoin, game.Players.LocalPlayer)
end), "JoinJobId")

Reg(Info:AddButton("Copy Join JobId", function()
    if setclipboard then
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, '..game.JobId..", game.Players.LocalPlayer)")
        Library:Notify(_T("NotifyCopied")) 
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end), "CopyJoinJobId")

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:Notify(_T("NotifyLoaded")..CUR_LANG, 3)