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
    return 
end

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

    Library:Notify("Loading mshax for DOORS",5)

    if Executor == "Xeno" or Executor == "xeno" then Library:Notify("Not Supported Executor",3) return end

    local success, result = pcall(function()
        return RequiredMainGame
    end)
    if not success then
        Library:Notify("Require Is  Not Supported Some Features would be disabled",3)
        Disable1 = true
        print("false require")
    end

    print("true require")
     
    if not isnetworkowner then
        Library:Notify("isnetworkowner  not supported some features would be disabled",3)
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
        Library:Notify("fireproximityprompt is not supported methods would change stillwork but less reliable some will not work will be disabled",4)
        Disable3 = true
        print("false fireproximityprompt")
    end

    print("true fireproximityprompt")
    Prompt:Destroy()

    if not replicatesignal then
        Disable4 = true
        Library:Notify("replicatesignal  not supported methods would change stillwork but less reliable",3)
        print("false replicatesignal")
    end
    print("true replicatesignal")

    if not hookmetamethod or not newcclosure then
        Library:Notify("Hooking not supported some features would be disabled",3)
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

    function GetNearestClosest()
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
        Title = 'mshax v4.5 | DOORS ',
        Center = true,
        AutoShow = true
    })

    Tabs = {
        Main     = Window:AddTab('Main'),
        Player     = Window:AddTab('Player'),
        UISettings = Window:AddTab('Config'),
    }

    local TabBox2 = Tabs.Main:AddLeftTabbox() 
    local MiscBox = TabBox2:AddTab("Miscellaneous")
    local NotifyBox = TabBox2:AddTab("Notifying / ESP")

    local TabBox = Tabs.Player:AddLeftTabbox() 
    local Movement = TabBox:AddTab("Movement")
    local Camera = TabBox:AddTab("Camera")

    local ReachBox = Tabs.Main:AddRightGroupbox('Reach')
    local InfiniteBox = Tabs.Player:AddRightGroupbox('Infinite Items')

    ESP = Tabs.Main:AddRightGroupbox('ESP')
    SettingsESP = Tabs.Main:AddLeftGroupbox('ESP Settings')

    SettingsBox = Tabs.UISettings:AddRightGroupbox('UI')

    SettingsBox:AddToggle('FpsUnlocker',{
        Text = "Fps Unlocker",
        Default = true,
        Callback = function(Value)
            setfpscap(Value and 9999999 or 60)
        end
    })

    SettingsBox:AddToggle('PlaySound',{
        Text = "Play Sound",
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
        Text = "Notify Side",
        Callback = function(Value)
            Library.NotifySide = Value
        end,
    })

    MiscBox:AddToggle('InstantPrompt',{
        Text = "Instant Interacts",
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
        Text = "Prompt Clip",
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
        Text = "Disable AFK",
        Default = false
    })

    table.insert(Connections,LocalPlayer.Idled:Connect(function()
        if Toggles.AntiAfk.Value then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end))

    MiscBox:AddToggle('AntiLag',{
        Text = "Anti Lag",
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
        Text = "Prompt Reach",
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
        Text = "Door Reach",
        Default = false
    })

    ReachBox:AddSlider("DoorReachRange", {
        Text = "Door Reach Range",
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
        Text = "No Cutscenes",
        Default = false
    })

    Camera:AddToggle('Fullbright',{
        Text = "Fullbright",
        Default = false,
        Callback = function(Value)
            if not Value then
                game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            end
        end
    })

    Camera:AddToggle('NoCameraShake',{
        Text = "No Camera Shake",
        Default = false,
        Disabled = Disable1
    })

    local Y = 0
    local Z = 6
    local X = 2

    Camera:AddDivider()
    Camera:AddToggle('ThirdPerson',{
        Text = "Third Person",
        Default = false
    }):AddKeyPicker('ThirdPKeybind', {
        Default = 'T',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Third Person',
        NoUI = false,
        Callback = function(Value) end,
        ChangedCallback = function(New) end
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

    View = 70
    Camera:AddSlider("FieldofViewAdjust", {
        Text = "FOV Slider",
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

    Movement:AddDivider()
    Speed = 15
    Movement:AddSlider("SpeedBoostSlider", {
        Text = "Speed Boost Slider",
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
        Text = "Speed Boost",
        Default = false
    })

    Movement:AddDivider()
    Movement:AddToggle('Noclip',{
        Text = "Noclip",
        Default = false
    }):AddKeyPicker('NoclipKeybind', {
        Default = 'N',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Noclip',
        NoUI = false,
        Callback = function(Value) end,
        ChangedCallback = function(New) end
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
        Text = "Enable Jump",
        Default = false
    })

    Movement:AddToggle('InfiniteJump',{
        Text = "Infinite Jump",
        Default = false
    })

    Movement:AddDivider()
    Movement:AddToggle('Noacceleration',{
        Text = "No Acceleration",
        Default = false
    })

    Movement:AddDivider()
    Movement:AddToggle('NoClosetExitDelay',{
        Text = "No Closet Exit Delay",
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
    }):AddKeyPicker('Fly Keybind', {
        Default = 'F',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Fly',
        NoUI = false,
        Callback = function(Value) end,
        ChangedCallback = function(New) end
    })

    local DoorColor = Color3.new(0,1,1)
    local KeyColor = Color3.new(0, 1, 0)
    local GateLeverColor = Color3.new(0,1,0)
    local TimerLeverColor = Color3.new(0,1,0)
    local PlayersColor = Color3.new(1, 1, 1)
    local HidingSpotColor = Color3.new(0,0.5,0)
    local BooksColor = Color3.new(0,1,0)
    local BreakerColor = Color3.new(0,1,0)
    local ItemsColor = Color3.new(0,0,1)
    local GoldColor = Color3.new(1, 0.8, 0)

    function AddESP(inst,txt,color)
        ESPLibrary:AddESP(inst, txt, color)
    end

    ESP:AddToggle('Door',{
        Text = "Door",
        Default = false,
        Callback = function(Value)
            if Value then
                local Door = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Door.Door
                if not Door:GetAttribute("Used") then
                    AddESP(Door, (Door.Parent:FindFirstChild("Lock") and "Locked  " or "") .. "Door " .. Door.Parent:GetAttribute("RoomID"), DoorColor)
                end
            else
                for _, room in ipairs(workspace.CurrentRooms:GetChildren()) do
                    for _, v in ipairs(room:GetChildren()) do
                        if v.Name == "Door" and v:FindFirstChild("Door") then
                            ESPLibrary:RemoveESP(v.Door)
                        end
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
            if Toggles.Door.Value then
                Toggles.Door:SetValue(false)
                Toggles.Door:SetValue(true)
            end
        end
    })

    ESP:AddToggle('Key',{
        Text = "Key",
        Default = false,
        Callback = function(Value)
            if Value then
                local v = workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value]:FindFirstChild("KeyObtain",true)
                if v and not v:GetAttribute("Used") then
                    AddESP(v,"Key",KeyColor)
                end
            else
                local Key = workspace:FindFirstChild("KeyObtain",true)
                ESPLibrary:RemoveESP(Key)
            end
        end
    }):AddColorPicker('KeyColo', {
        Default = KeyColor,
        Title = 'Key Color',
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
        Wardrobe = "Closet",
        Rooms_Locker = "Locker",
        Backdoor_Wardrobe = "Closet",
        Toolshed = "Closet",
        Locker_Large = "Locker",
        Bed = "Bed",
        CircularVent = "Vent",
        Rooms_Locker_Fridge = "Fridge",
        RetroWardrobe = "Closet",
        Dumpster = "Dump Ster",
        Double_Bed = "Double Bed"
    }

    ESP:AddToggle('HidingSpot',{
        Text = "Closet ESP",
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
        Title = 'Hiding Place Color',
        Transparency = 0,
        Callback = function(Value)
            HidingSpotColor = Value
            if Toggles.HidingSpot.Value then
                Toggles.HidingSpot:SetValue(false)
                Toggles.HidingSpot:SetValue(true)
            end
        end
    })

    ESP:AddToggle('GateLever',{
        Text = "Gate Lever",
        Default = false,
        Callback = function(Value)
            if Value then
                for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
                    if v.Name == "LeverForGate" then
                        AddESP(v,"Gate Lever",GateLeverColor)
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
        Title = 'Gate Lever Color',
        Transparency = 0,
        Callback = function(Value)
            GateLeverColor = Value
            if Toggles.GateLever.Value then
                Toggles.GateLever:SetValue(false)
                Toggles.GateLever:SetValue(true)
            end
        end
    })

    ESP:AddToggle('Players',{
        Text = "Players ESP",
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
        Title = 'Players Color',
        Transparency = 0,
        Callback = function(Value)
            PlayersColor = Value
            if Toggles.Players.Value then
                Toggles.Players:SetValue(false)
                Toggles.Players:SetValue(true)
            end
        end
    })

    ESP:AddToggle('Books',{
        Text = "Books",
        Default = false,
        Callback = function(Value)
            if Value then
                for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
                    if v.Name == "LiveHintBook" then
                        AddESP(v,"Book",BooksColor)
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
        Title = 'Books Color',
        Transparency = 0,
        Callback = function(Value)
            BooksColor = Value
            if Toggles.Books.Value then
                Toggles.Books:SetValue(false)
                Toggles.Books:SetValue(true)
            end
        end
    })

    ESP:AddToggle('Breaker',{
        Text = "Breaker",
        Default = false,
        Callback = function(Value)
            if Value then
                for _, v in ipairs(workspace.CurrentRooms[LocalPlayer:GetAttribute("CurrentRoom")]:GetDescendants()) do
                    if v.Name == "LiveBreakerPolePickup" then
                        AddESP(v,"Breaker",BreakerColor)
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
        Title = 'Breaker Color',
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
        BatteryPack = "Flashlight BatteryPack",
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
        ChestBoxLocked = "[Locked] Chest",
        ChestBox = "Chest",
        StardustPickup = "Star Dust"
    }

    ESP:AddToggle('Items',{
        Text = "Items ESP",
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
        Title = 'Items Color',
        Transparency = 0,
        Callback = function(Value)
            ItemsColor = Value
            if Toggles.Items.Value then
                Toggles.Items:SetValue(false)
                Toggles.Items:SetValue(true)
            end
        end
    })

    ESP:AddToggle('Gold',{
        Text = "Gold ESP",
        Default = false,
        Callback = function(Value)
            if Value then
                for _, v in ipairs(workspace.CurrentRooms:GetDescendants()) do
                    if v and v.Name == "GoldPile" then
                        AddESP(v,"Gold " .. v:GetAttribute("GoldValue"),GoldColor)
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
        Title = 'Gold Color',
        Transparency = 0,
        Callback = function(Value)
            GoldColor = Value
            if Toggles.Gold.Value then
                Toggles.Gold:SetValue(false)
                Toggles.Gold:SetValue(true)
            end
        end
    })

    SettingsESP:AddToggle('EnableShowDistancws',{
        Text = "Enable Show Distances",
        Default = false,
        Callback = function(Value)
            ESPLibrary:ShowDistance(Value)
        end
    })

    table.insert(Connections,UserInputService.JumpRequest:Connect(function()
        task.wait(0.3)
        if Toggles.InfiniteJump.Value then
            if Character then
                Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end))

    table.insert(Connections,LocalPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        Library:Notify("Settings Everything up",4)

        if Toggles.EnableJump.Value then
            LocalPlayer.Character:SetAttribute("CanJump",true)
        end

        task.wait(3)
        MainGame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainUI"):WaitForChild("Initiator").Main_Game
        RequiredMainGame = require(LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)
        RemoteListener = MainGame.RemoteListener
        Modules = RemoteListener.Modules
    end))

    table.insert(Connections,RunService.RenderStepped:Connect(function()
        alive = LocalPlayer:GetAttribute("Alive")
        if alive then
            if Toggles.Fullbright.Value then
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            end

            if Toggles.SpeedBoost.Value then
                Character.Humanoid.WalkSpeed = Speed
            end

            if Toggles.Fieldofview.Value then
                Workspace.CurrentCamera.FieldOfView = View
            end

            if Toggles.Noacceleration.Value then
                Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100,0.5,0.2)
                Character.Collision.CustomPhysicalProperties = PhysicalProperties.new(100,0.5,0.2)
            else
                Character.HumanoidRootPart.CustomPhysicalProperties =  PhysicalProperties.new(0.4,0.2,0.2)
                Character.Collision.CustomPhysicalProperties = PhysicalProperties.new(0.4,0.2,0.2)
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

            if Fog then
                Fog.Density = (Toggles.AntiFog.Value and 0) or 0.94
            end

            if Toggles.AntiFog.Value then
                Lighting.FogEnd = 9e9
            end

            if CollisionClone and CollisionClone.Anchored then
                CollisionClone.Anchored = false
            end
            if CollisionClone2 and CollisionClone2.Anchored then
                CollisionClone2.Anchored = false
            end
        end
    end))

    Toggles.NoCutscenes:OnChanged(function(Value)
        local CutScenes = RemoteListener:FindFirstChild("Cutscenes") or RemoteListener:FindFirstChild("_Cutscenes")
        CutScenes.Name = Value and "_Cutscenes" or "Cutscenes"
    end)

    Toggles.EnableJump:OnChanged(function(Value)
        if Character then
            Character:SetAttribute("CanJump",Value)
        end
    end)

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
        Text = "Show Custom Cursor",
        Default = Library.IsMobile == true and true or false,
        Tooltip = "Toggle the visibility of the Cursor",
    }):OnChanged(function()
        Library.ShowCustomCursor = Toggles.ShowCustomCursor.Value
    end)

    local Contributors = Tabs.UISettings:AddRightGroupbox("Credits")
    Contributors:AddLabel("KardinCat - Creator",true)
    Contributors:AddLabel("notzanocoddz - W Guy Made Auto Load Config",true)

    SettingsBox:AddButton({
        Text = "Unload GUI",
        Func = function()
            Unload()
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

    local folder_path = "Prohax"
    local file_path = "Doors"
    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

    ThemeManager:SetFolder(folder_path)
    SaveManager:SetFolder(folder_path .. '/' .. file_path)

    SaveManager:BuildConfigSection(Tabs['UISettings'])
    ThemeManager:ApplyToTab(Tabs['UISettings'])

    SaveManager:GetAutoloadConfig()
    SaveManager:LoadAutoloadConfig()
    SaveManager:SaveAutoloadConfig(file_path)
end