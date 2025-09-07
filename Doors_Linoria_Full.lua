local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = true
Library.NotifySide = "Right"

local Window = Library:CreateWindow({
	Title = 'DOORS - 完整增强菜单',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	NotifySide = "Right",
	TabPadding = 8,
	MenuFadeTime = 0.2
})
local Tabs = {
	Main = Window:AddTab('主要'),
	Visuals = Window:AddTab('怪物/物品'),
	Exploits = Window:AddTab('移除/功能'),
	['界面设置'] = Window:AddTab('界面设置'),
}

-- Orion compatibility for MakeNotification calls
local OrionCompat = {}
function OrionCompat:MakeNotification(arg)
    if type(arg) ~= "table" then
        Library:Notify(tostring(arg or "通知"))
        return
    end
    local title = tostring(arg.Name or arg.Title or "通知")
    local content = tostring(arg.Content or arg.Description or "")
    local timeSec = tonumber(arg.Time) or tonumber(arg.Duration) or 5
    local text = title .. (content ~= "" and (": " .. content) or "")
    Library:Notify(text, timeSec)
end
OrionLib = OrionCompat
OrionLib.MakeNotification = function(tbl) return OrionCompat:MakeNotification(tbl) end

-- Basic UI (preserved from earlier conversion)
local mainLeft = Tabs.Main:AddLeftGroupbox('玩家 & 基本')
mainLeft:AddToggle('EnableMain', {
    Text = '启用脚本',
    Default = true,
    Tooltip = '启用/禁用大多数功能',
    Callback = function(v) Library:Notify('脚本已' .. (v and '启用' or '禁用')) end
})
mainLeft:AddSlider('WalkSpeed', {
    Text = '行走速度',
    Default = 16,
    Min = 8,
    Max = 75,
    Rounding = 1,
    Callback = function(v) pcall(function() shared and shared.LocalPlayer and (shared.LocalPlayer.Character and (shared.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and (shared.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').WalkSpeed = v))) end) end
})
mainLeft:AddButton({
    Text = '重置角色',
    Func = function() Library:Notify('尝试重置角色'); pcall(function() shared.LocalPlayer:LoadCharacter() end) end,
    Tooltip = '重置（复活）'
})

-- End header. Now insert extracted DOORS-related block.

-- ===== Extracted DOORS block from original SM.txt =====

ClosureBindings = {
    function()local wax,script,require=ImportGlobals(1)local ImportGlobals return (function(...)if getgenv().mspaint_loading then print("[mspaint] Loading stopped. (ERROR: Loading)"); return end
if getgenv().mspaint_loaded then print("[mspaint] Loading stopped. (ERROR: Already loaded)"); return end

getgenv().mspaint_loading = true

--// Loading Wait \\--
if not game:IsLoaded() then game.Loaded:Wait() end

--// Services \\--
local Services = require("Utils/Services")
Services:GetServices({
    "Players",
    "UserInputService",
    "TextChatService",
    "ProximityPromptService",
    "PathfindingService",

    "CoreGui",
    "StarterGui",

    "Workspace",
    "Lighting",
    "ReplicatedStorage",

    "HttpService",
    "RunService",
    "SoundService",
    "TeleportService",
    "TweenService",
    "MarketplaceService"
})

--// Utils \\--
if not wax.shared.ExecutorSupport then
    wax.shared.ExecutorSupport = require("Utils/ExecutorSupport")
end

if not wax.shared.BloxstrapRPC then
    wax.shared.BloxstrapRPC = require("Utils/BloxstrapRPC")
end

if not wax.shared.FileHelper then
    wax.shared.FileHelper = require("Utils/FileHelper")
end

--// mspaint Loader \\--
if not wax.shared.GotPlace then
    wax.shared.GotPlace = true

    shared.ScriptName = "Universal"
    shared.ScriptLoader = "Universal"
    
    local Mappings = require("Mappings")
    
    local MappingID = Mappings[game.GameId]
    if MappingID then
        local Folder = MappingID["Folder"]
        local Name = MappingID["Name"] or Folder
        local GameExclusions = MappingID["Exclusions"] or {}
        local Exclusion = GameExclusions[game.PlaceId]
        
        shared.ScriptName = Name
        shared.ScriptLoader = Folder .. "/" .. MappingID["Main"]

        shared.Mapping = MappingID
        shared.ScriptFolder = Folder
        shared.ScriptExclusion = Exclusion
    
        if Exclusion then
            shared.ScriptName = Name .. " (" .. Exclusion .. ")"
            shared.ScriptLoader = Folder .. "/" .. Exclusion
        end
    end
end

--// Global functions \\--
shared.Script = {
    Functions = {}
}
shared.Hooks = {}

shared.Script.Functions.EnforceTypes = function(args, template)
    args = if typeof(args) == "table" then args else {}

    for key, value in pairs(template) do
        local argValue = args[key]

        if argValue == nil or (value ~= nil and typeof(argValue) ~= typeof(value)) then
            args[key] = value
        elseif typeof(value) == "table" then
            args[key] = shared.Script.Functions.EnforceTypes(argValue, value)
        end
    end

    return args
end

shared.Load = require("Utils/Loader")
shared.Logs = require("Utils/Logs")
shared.Connect = require("Utils/Connections")

--// Player Variables \\--
shared.Camera = workspace.CurrentCamera

shared.LocalPlayer = shared.Players.LocalPlayer
shared.PlayerGui = shared.LocalPlayer.PlayerGui
shared.PlayerScripts = shared.LocalPlayer.PlayerScripts

shared.Fly = require("Utils/Universal/Fly")
shared.Twerk = require("Utils/Universal/Twerk")
shared.ControlModule = require("Utils/Universal/ControlModule")

local TextChannels = shared.TextChatService:FindFirstChild("TextChannels")
if TextChannels and TextChannels:FindFirstChild("RBXGeneral") then
    shared.RBXGeneral = TextChannels.RBXGeneral
end

--// Load \\--
local UICreator = require("Utils/GUI/Creator")
shared.Window = UICreator:CreateWindow()

require("Places/Loaders/" .. shared.ScriptLoader)

UICreator:CreateSettingsTab()
require("Utils/GUI/Addons")

getgenv().mspaint_loading = false
end)() end,
    function()local wax,script,require=ImportGlobals(2)local ImportGlobals return (function(...)return {
    [2440500124] = {
        ["Folder"] = "Doors",
        ["Main"] = "Doors",
        ["Name"] = "DOORS",
        ["Exclusions"] = {
            [6516141723] = "Lobby",
            [12308344607] = "Lobby"
        }
    },

    -- Regular 3008
    [1000233041] = {
        ["Folder"] = "3008",
        ["Main"] = "3008",
        ["Name"] = "3008"
    },

    -- 100 Players 3008
    [3462404408] = {
        ["Folder"] = "3008",
        ["Main"] = "3008",
        ["Name"] = "3008"
    }
}
end)() end,
    [6] = function()local wax,script,require=ImportGlobals(6)local ImportGlobals return (function(...)--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script

Script.DidGodmode = false

Script.DefaultFogEnd = shared.Lighting.FogEnd

Script.CurrentAmbient = shared.Lighting.Ambient
Script.CurrentColorShift_Bottom = shared.Lighting.ColorShift_Bottom
Script.CurrentColorShift_Top = shared.Lighting.ColorShift_Top
if shared.Lighting:FindFirstChild("FoggyDay_Atmosphere") then
    Script.CurrentFoggyDayDensity = shared.Lighting["FoggyDay_Atmosphere"].Density
end

Script.Physical = workspace:WaitForChild("GameObjects"):WaitForChild("Physical")
Script.Map = Script.Physical:WaitForChild("Map")
Script.Items = Script.Physical:WaitForChild("Items")
Script.Employees = Script.Physical:WaitForChild("Employees")

Script.FeatureConnections = {
    Item = {},
    Employee = {},
    Player = {},
    ESPTemp = {}
}

Script.ESPTable = {
    Item = {},
    Employee = {},
    Player = {}
}

Script.InteractableItems = {
	"Medkit",
	"Pizza",
	"Beans",
	"Meatballs",
	"Apple",
	"Lemon",
	"Lemon Slice",
	"Burger",
	"Banana",
	"Hotdog",
	"Striped Donut",
	"Chips",
	"Ice Cream",
	"Chocolate",
	"Cookie",
	"Bloxy Soda",
	"2 Litre Dr. Bob",
    "Dr. Bob Soda",
	"Water",
	"Jeff"
}
--// Player Variables \\--
shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()
shared.Humanoid = nil

Script.System = shared.Character:WaitForChild("System")
Script.Event = Script.System:WaitForChild("Event")
Script.Action = Script.System:WaitForChild("Action")

Script.DeathScreen = shared.PlayerGui:WaitForChild("DeathScreen")
Script.Settings = shared.PlayerGui:WaitForChild("PlayerInfo"):WaitForChild("Settings")
Script.MainGui = shared.PlayerGui:WaitForChild("MainGui")
Script.PlayerStats = Script.MainGui:WaitForChild("PlayerStats")

Script.TopBar = Script.MainGui:WaitForChild("TopBar")
Script.Calendar = Script.TopBar:WaitForChild("Calendar")
Script.CurrentDay = Script.Calendar:WaitForChild("Middle"):WaitForChild("CurrentDay")
Script.TimeLeft = shared.ReplicatedStorage:WaitForChild("ServerSettings"):WaitForChild("TimeSettings"):WaitForChild("TimeLeft")

Script.Source = shared.PlayerScripts:WaitForChild("source")
Script.Client = Script.Source:WaitForChild("client")

Script.ToolSystem = Script.Client:WaitForChild("ToolSystem")
Script.WaypointsMenu = Script.Client:WaitForChild("GUI"):WaitForChild("GuiMenus"):WaitForChild("Extras"):WaitForChild("WaypointsMenu")

Script.GamePassClockVisible = Script.Calendar:WaitForChild("Gamepass_Clock").Visible

--// Functions \\--
Script._mspaint_custom_captions = Instance.new("ScreenGui") do
    local Frame = Instance.new("Frame", Script._mspaint_custom_captions)
    local TextLabel = Instance.new("TextLabel", Frame)
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)

    Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    Script._mspaint_custom_captions.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = shared.Library.MainColor
    Frame.BorderColor3 = shared.Library.AccentColor
    Frame.BorderSizePixel = 2
    Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
    Frame.Size = UDim2.new(0, 200, 0, 75)
    shared.Library:AddToRegistry(Frame, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "AccentColor"
    })

    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = ""
    TextLabel.TextColor3 = shared.Library.FontColor
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
    shared.Library:AddToRegistry(TextLabel, {
        TextColor3 = "FontColor"
    })

    UITextSizeConstraint.MaxTextSize = 35

    function Script.Functions.HideCaptions()
        Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    end

    local CaptionsLastUsed = os.time()
    function Script.Functions.Captions(caption: string)
        CaptionsLastUsed = os.time()

        if Script._mspaint_custom_captions.Parent == shared.ReplicatedStorage then
            local success = pcall(function()
                Script._mspaint_custom_captions.Parent = if gethui then gethui() else shared.CoreGui
            end)

            if not success then
                Script._mspaint_custom_captions.Parent = shared.PlayerGui
            end 
        end
        
        TextLabel.Text = caption

        task.spawn(function()
            task.wait(5)
            if os.time() - CaptionsLastUsed >= 5 then
                Script.Functions.HideCaptions()
            end
        end)
    end
end

function Script.Functions.DistanceFromCharacter(position: Instance | Vector3, getPositionFromCamera: boolean | nil)
    if not position then return 9e9 end
    if typeof(position) == "Instance" then
        position = position:GetPivot().Position
    end

    if getPositionFromCamera and (shared.Camera or workspace.CurrentCamera) then
        local cameraPosition = if shared.Camera then shared.Camera.CFrame.Position else workspace.CurrentCamera.CFrame.Position

        return (cameraPosition - position).Magnitude
    end

    if shared.RootPart then
        return (shared.RootPart.Position - position).Magnitude
    elseif shared.Camera then
        return (shared.Camera.CFrame.Position - position).Magnitude
    end

    return 9e9
end

function Script.Functions.CameraChildAdded(child)
    if Toggles.AutoTPWhistle.Value then
        for playerName, _ in pairs(Options.AutoTPWhistlePlayers.Value) do
            if child.Name == playerName .. "_EchoLocation" then
                shared.Character:PivotTo(child.CFrame)
            end
        end
    end
end

function Script.Functions.IsNaN(x)
    return x ~= x
end

function Script.Functions.UpdateBloxstrapRPC()
    if not wax.shared.BloxstrapRPC then return end
    
    wax.shared.BloxstrapRPC.SetRichPresence({
        details = "Playing 3008 [ mspaint v3 ]",
        state = string.lower(Script.CurrentDay.Text):gsub("^%l", string.upper),
        largeImage = {
            hoverText = "Using mspaint v3"
        },
        smallImage = {
            assetId = 6925817108,
            hoverText = shared.LocalPlayer.Name
        }
    })
end

function Script.Functions.Respawn()
    if shared.Humanoid.Health > 0 or Script.Functions.IsNaN(shared.Humanoid.Health) then
        shared.Character:BreakJoints()
    end

    repeat task.wait(0.1) until Script.DeathScreen.BG.Visible
    
    Script.Event:FireServer("Respawn")

    Script.DeathScreen.DeathSound:Stop()
    Script.DeathScreen.DeathMusic:Stop()
end

shared.Load("Utils", "ConnectionsFuncs")
shared.Load("Utils", "ESP")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("主要的"),
    Exploits = shared.Window:AddTab("移除类"),
    Visuals = shared.Window:AddTab("怪物物品"),
}

shared.Load("Tabs", "Main")
shared.Load("Tabs", "Exploits")
shared.Load("Tabs", "Visuals")
--// Metamethod hooks \\--
if wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"] then
    if wax.shared.ExecutorSupport["require"] then
        Script.ToolGStep = wax.require(Script.ToolSystem).GlobalRenderStep
    end

    shared.Hooks.mtHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        local isAction = method == "InvokeServer" and self.Name == "Action"

        if isAction then
            local actionType = args[1]
            local actionData = args[2]

            if actionType == "Store" and args[3] ~= "_internal_origin_mspaint" then
                if Toggles.InfiniteInventory.Value and wax.shared.ExecutorSupport["require"] then
                    require(Script.ToolSystem).GlobalRenderStep = function() end
                    local parentedTools = {}
                    
                    for _, tool in pairs(shared.LocalPlayer.Backpack:GetChildren()) do
                        table.insert(parentedTools, tool)
                    
                        shared.Humanoid:EquipTool(tool)
                        tool.Parent = workspace
                    end
    
                    task.wait()
                    local modelName = actionData.Model.Name
    
                    Script.Action:InvokeServer("Store", actionData, "_internal_origin_mspaint")
                    
                    local newTool = shared.LocalPlayer.Backpack:WaitForChild(modelName)
    
                    shared.Humanoid:EquipTool(newTool)
    
                    for _, tool in pairs(parentedTools)  do
                        tool.Parent = shared.Character
                        shared.Humanoid:EquipTool(tool)
                    end
                    
                    shared.Humanoid:UnequipTools()
    
                    require(Script.ToolSystem).GlobalRenderStep = Script.ToolGStep

                    return
                end
            end
    
            if actionType == "Drop" then
                if Toggles.ThrowPowerBoost.Value then
                    actionData.ThrowPower = Options.ThrowPower.Value
                    actionData.Throw = true
                    actionData.CameraCFrame = actionData.CameraCFrame * Options.ThrowPower.Value
                end

                if Toggles.DeleteObject.Value then
                    actionData.ThrowPower = 555
                    actionData.Throw = true
                    actionData.CameraCFrame = actionData.CameraCFrame * -1000
                end
            end

            return shared.Hooks.mtHook(self, table.unpack({
                actionType,
                actionData
            }))
        end

        return shared.Hooks.mtHook(self, ...)
    end))
end

--// Function hooks \\--
if wax.shared.ExecutorSupport["hookfunction"] and wax.shared.ExecutorSupport["getcallingscript"] then
    shared.Hooks.instantInteract = hookfunction(TweenInfo.new, newcclosure(function(self, ...)
        if not shared.Library.Unloaded then
            if Toggles.InstantInteract.Value then
                local caller = getcallingscript()
    
                local isInputController = caller and caller.Name == "InputControl"
                local isValidArgument = self and typeof(self) == "number"
    
                if isInputController and isValidArgument then
                    self = 0
                end
            end
        end

        return shared.Hooks.instantInteract(self, ...)
    end))
end

--// Connections \\--
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))

shared.Connect:GiveSignal(shared.Camera.ChildAdded:Connect(Script.Functions.CameraChildAdded))

shared.Connect:GiveSignal(shared.Players.PlayerAdded:Connect(function(player)
    task.spawn(Script.Functions.SetupOtherPlayerConnection, player)
end))

--// Load \\--
task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)
task.spawn(Script.Functions.SetupLightingConnection)
task.spawn(Script.Functions.SetupExploitInfModulesConnection)
task.spawn(Script.Functions.SetupBloxstrapRPCConnection)

task.spawn(Script.Functions.SetupEmployeeConnection)
task.spawn(Script.Functions.SetupItemConnection)
task.spawn(Script.Functions.SetupOtherPlayerConnection)

for _, child in pairs(shared.Camera:GetChildren()) do
    Script.Functions.CameraChildAdded(child)
end

--// Unload \\--
shared.Library:OnUnload(function()
    if wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"] then
        hookmetamethod(game, "__namecall", shared.Hooks.mtHook)
    end

    if wax.shared.BloxstrapRPC then
        wax.shared.BloxstrapRPC.SetRichPresence({
            details = "<reset>",
            state = "<reset>",
            largeImage = {
                reset = true
            },
            smallImage = {
                reset = true
            }
        })
    end
end)

getgenv().mspaint_loaded = true
end)() end,
    [8] = function()local wax,script,require=ImportGlobals(8)local ImportGlobals return (function(...)--// Loading Wait \\--
if shared.LocalPlayer and shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and shared.LocalPlayer.PlayerGui.LoadingUI.Enabled then
    print("[mspaint] Waiting for game to load...")
    repeat task.wait() until not shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and true or not shared.LocalPlayer.PlayerGui.LoadingUI.Enabled
end

--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script
Script.FeatureConnections = {
    Character = {},
    Clip = {},
    Door = {},
    Humanoid = {},
    Player = {},
    Pump = {},
    RootPart = {},
}
Script.ESPTable = {
    Chest = {},
    Door = {},
    Entity = {},
    SideEntity = {},
    Gold = {},
    Guiding = {},
    DroppedItem = {},
    Item = {},
    Objective = {},
    Player = {},
    HidingSpot = {},
    None = {}
}

Script.Functions.Minecart = {}

Script.Temp = {
    AnchorFinished = {},
    AutoWardrobeEntities = {},
    Bridges = {},
    PipeBridges = {},
    CollisionSize = Vector3.new(5.5, 3, 3),
    Guidance = {},
    PaintingDebounce = {},
    UsedBreakers = {},
    VoidGlitchNotifiedRooms = {}
}

Script.FakeRevive = {
    Debounce = false,
    Enabled = false,
    Connections = {}
}

Script.WhitelistConfig = {
    [45] = {firstKeep = 3, lastKeep = 2},
    [46] = {firstKeep = 2, lastKeep = 2},
    [47] = {firstKeep = 2, lastKeep = 2},
    [48] = {firstKeep = 2, lastKeep = 2},
    [49] = {firstKeep = 2, lastKeep = 4},
}

Script.SuffixPrefixes = {
    ["Backdoor"] = "",
    ["Ceiling"] = "",
    ["Moving"] = "",
    ["Ragdoll"] = "",
    ["Rig"] = "",
    ["Wall"] = "",
    ["Clock"] = "警戒表",
    ["Key"] = "钥匙",
    ["Pack"] = "包",
    ["Pointer"] = "(激光笔)",
    ["Swarm"] = "群",
}

Script.PrettyFloorName = {
    ["Fools"] = "Super Hard Mode",
    ["Retro"] = "Retro Mode"
}

Script.FloorImages = {
    ["Hotel"] = 16875079348,
    ["Mines"] = 138779629462354,
    ["Retro"] = 16992279648,
    ["Rooms"] = 16874821428,
    ["Fools"] = 17045908353,
    ["Backdoor"] = 16874352892
}

Script.EntityTable = {
    ["Names"] = {"BackdoorRush", "BackdoorLookman", "RushMoving", "AmbushMoving", "Eyes", "JeffTheKiller", "Dread", "A60", "A120"},
    ["SideNames"] = {"FigureRig", "GiggleCeiling", "GrumbleRig", "Snare"},
    ["ShortNames"] = {
        ["BackdoorRush"] = "Blitz",
        ["JeffTheKiller"] = "Jeff The Killer"
    },
    ["NotifyMessage"] = {
        ["GloombatSwarm"] = "Gloombats in next room!"
    },
    ["Avoid"] = {
        "RushMoving",
        "AmbushMoving"
    },
    ["NotifyReason"] = {
        ["A60"] = {
            ["Image"] = "12350986086",
        },
        ["A120"] = {
            ["Image"] = "12351008553",
        },
        ["BackdoorRush"] = {
            ["Image"] = "11102256553",
        },
        ["RushMoving"] = {
            ["Image"] = "11102256553",
        },
        ["AmbushMoving"] = {
            ["Image"] = "10938726652",
        },
        ["Eyes"] = {
            ["Image"] = "10865377903",
            ["Spawned"] = true
        },
        ["BackdoorLookman"] = {
            ["Image"] = "16764872677",
            ["Spawned"] = true
        },
        ["JeffTheKiller"] = {
            ["Image"] = "98993343",
            ["Spawned"] = true
        },
        ["GloombatSwarm"] = {
            ["Image"] = "79221203116470",
            ["Spawned"] = true
        },
        ["HaltRoom"] = {
            ["Image"] = "11331795398",
            ["Spawned"] = true
        }
    },
    ["NoCheck"] = {
        "Eyes",
        "BackdoorLookman",
        "JeffTheKiller"
    },
    ["InfCrucifixVelocity"] = {
        ["RushMoving"] = {
            threshold = 52,
            minDistance = 55,
        },
        ["RushNew"] = {
            threshold = 52,
            minDistance = 55,
        },    
        ["AmbushMoving"] = {
            threshold = 70,
            minDistance = 80,
        }
    },
    ["AutoWardrobe"] = {
        ["Entities"] = {
            "RushMoving",
            "AmbushMoving",
            "BackdoorRush",
            "A60",
            "A120",
        },
        ["Distance"] = {
            ["RushMoving"] = {
                Distance = 100,
                Loader = 175
            },
            ["BackdoorRush"] = {
                Distance = 100,
                Loader = 175
            },
    
            ["AmbushMoving"] = {
                Distance = 155,
                Loader = 200
            },
            ["A60"] = {
                Distance = 200,
                Loader = 200
            },
            ["A120"] = {
                Distance = 200,
                Loader = 200
            }
        }
    }
}

Script.HidingPlaceName = {
    ["Hotel"] = "柜子",
    ["Backdoor"] = "柜子",
    ["Fools"] = "柜子",
    ["Retro"] = "柜子",

    ["Rooms"] = "柜子",
    ["Mines"] = "柜子"
}

Script.CutsceneExclude = {
    "FigureHotelChase",
    "Elevator1",
    "MinesFinale"
}

Script.SlotsName = {
    "Oval",
    "Square",
    "Tall",
    "Wide"
}

Script.PromptTable = {
    GamePrompts = {},

    Aura = {
        ["ActivateEventPrompt"] = false,
        ["AwesomePrompt"] = true,
        ["FusesPrompt"] = true,
        ["HerbPrompt"] = false,
        ["LeverPrompt"] = true,
        ["LootPrompt"] = false,
        ["ModulePrompt"] = true,
        ["SkullPrompt"] = false,
        ["UnlockPrompt"] = true,
        ["ValvePrompt"] = false,
        ["PropPrompt"] = true
    },
    AuraObjects = {
        "Lock",
        "Button"
    },

    Clip = {
        "AwesomePrompt",
        "FusesPrompt",
        "HerbPrompt",
        "HidePrompt",
        "LeverPrompt",
        "LootPrompt",
        "ModulePrompt",
        "Prompt",
        "PushPrompt",
        "SkullPrompt",
        "UnlockPrompt",
        "ValvePrompt"
    },
    ClipObjects = {
        "LeverForGate",
        "LiveBreakerPolePickup",
        "LiveHintBook",
        "Button",
    },

    Excluded = {
        Prompt = {
            "HintPrompt",
            "InteractPrompt"
        },

        Parent = {
            "KeyObtainFake",
            "Padlock"
        },

        ModelAncestor = {
            "DoorFake"
        }
    }
}

Script.HideTimeValues = {
    {min = 1, max = 5, a = -1/6, b = 1, c = 20},
    {min = 6, max = 19, a = -1/13, b = 6, c = 19},
    {min = 19, max = 22, a = -1/4, b = 19, c = 18},
    {min = 23, max = 26, a = 1/3, b = 23, c = 18},
    {min = 26, max = 30, a = -1/4, b = 26, c = 19},
    {min = 30, max = 35, a = -1/3, b = 30, c = 18},
    {min = 36, max = 60, a = -1/12, b = 36, c = 18},
    {min = 60, max = 90, a = -1/30, b = 60, c = 16},
    {min = 90, max = 99, a = -1/6, b = 90, c = 15}
}

Script.VoidThresholdValues = {
    ["Hotel"] = 3,
    ["Mines"] = 3,
    ["Retro"] = 3,
    ["Rooms"] = 4,
    ["Fools"] = 3,
    ["Backdoor"] = 2,
}

Script.MinecartPathNodeColor = {
    Disabled = nil,
    Red = Color3.new(1, 0, 0),
    Yellow = Color3.new(1, 1, 0),
    Purple = Color3.new(1, 0, 1),
    Green = Color3.new(0, 1, 0),
    Cyan = Color3.new(0, 1, 1),
    Orange = Color3.new(1, 0.5, 0),
    White = Color3.new(1, 1, 1),
}

Script.MinecartPathfind = {
    -- ground chase [41 to 44]
    -- minecart chase [45 to 49]
}

Script.Anims = {}
Script.Anims.HoldAnim = Instance.new("Animation"); Script.Anims.HoldAnim.AnimationId = "rbxassetid://10479585177"
Script.Anims.ThrowAnim = Instance.new("Animation"); Script.Anims.ThrowAnim.AnimationId = "rbxassetid://10482563149"

Script.Tracks = {
    ItemHoldTrack = nil,
    ItemThrowTrack = nil,
}

function Script.Functions.Warn(message: string)
    warn("WARN - mspaint:", message)
end

Script._mspaint_custom_captions = Instance.new("ScreenGui"); do
    local Frame = Instance.new("Frame", Script._mspaint_custom_captions)
    local TextLabel = Instance.new("TextLabel", Frame)
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)

    Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    Script._mspaint_custom_captions.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = shared.Library.MainColor
    Frame.BorderColor3 = shared.Library.AccentColor
    Frame.BorderSizePixel = 2
    Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
    Frame.Size = UDim2.new(0, 200, 0, 75)
    shared.Library:AddToRegistry(Frame, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "AccentColor"
    })

    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = ""
    TextLabel.TextColor3 = shared.Library.FontColor
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
    shared.Library:AddToRegistry(TextLabel, {
        TextColor3 = "FontColor"
    })

    UITextSizeConstraint.MaxTextSize = 35

    local IsCaptionHidden = true
    local CaptionsLastUsed = os.time()
    
    function Script.Functions.HideCaptions()
        IsCaptionHidden = true
        Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    end

    function Script.Functions.Captions(caption: string)
        CaptionsLastUsed = os.time()

        if IsCaptionHidden then
            local success = pcall(function()
                Script._mspaint_custom_captions.Parent = if gethui then gethui() else shared.CoreGui
            end)

            if not success then
                Script._mspaint_custom_captions.Parent = shared.PlayerGui
            end 

            IsCaptionHidden = false
        end
        
        TextLabel.Text = caption

        task.spawn(function()
            task.wait(5)
            if os.time() - CaptionsLastUsed >= 5 then
                Script.Functions.HideCaptions()
            end
        end)
    end
end

function Script.Functions.RandomString()
    local length = math.random(10,20)
    local array = {}
    for i = 1, length do
        array[i] = string.char(math.random(32, 126))
    end
    return table.concat(array)
end

function Script.Functions.NotifyGlitch()
    if Options.NotifyEntity.Value["Void/Glitch"] and Script.LatestRoom.Value > Script.CurrentRoom + Script.VoidThresholdValues[Script.Floor.Value] and Script.Alive and not table.find(Script.Temp.VoidGlitchNotifiedRooms, Script.CurrentRoom) then
        table.insert(Script.Temp.VoidGlitchNotifiedRooms, Script.CurrentRoom)

        local message = "Void/Glitch is coming once the next door is opened."

        if Script.IsRooms then
            local roomsLeft = (6 - (Script.LatestRoom.Value - Script.CurrentRoom))
            message = "Void/Glitch is coming " .. (if roomsLeft == 0 then "once the next door is opened." else "in " .. roomsLeft .. " rooms") .. "."
        end

        shared.Notify:Alert({
            Title = "ENTITIES",
            Description = message,
            Reason = "Go to the next room to avoid it.",

            Warning = true
        })
    end
end

function Script.Functions.UpdateRPC()
    if not wax.shared.BloxstrapRPC then return end

    local roomNumberPrefix = "Room "
    local prettifiedRoomNumber = Script.CurrentRoom

    if Script.IsBackdoor then
        prettifiedRoomNumber = -50 + Script.CurrentRoom
    end

    if Script.IsMines then
        prettifiedRoomNumber += 100
    end

    prettifiedRoomNumber = tostring(prettifiedRoomNumber)

    if Script.IsRooms then
        roomNumberPrefix = "A-"
        prettifiedRoomNumber = string.format("%03d", prettifiedRoomNumber)
    end

    wax.shared.BloxstrapRPC.SetRichPresence({
        details = "Playing DOORS [ mspaint v3 ]",
        state = roomNumberPrefix .. prettifiedRoomNumber .. " (" .. if Script.PrettyFloorName[Script.Floor.Value] then Script.PrettyFloorName[Script.Floor.Value] else ("The " .. Script.Floor.Value)  .. ")",
        largeImage = {
            assetId = Script.FloorImages[Script.Floor.Value] or 16875079348,
            hoverText = "Using mspaint v3"
        },
        smallImage = {
            assetId = 6925817108,
            hoverText = shared.LocalPlayer.Name
        }
    })
end

--// Player Variables \\--
shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()
shared.Humanoid = nil
Script.Collision = nil
Script.CollisionClone = nil

Script.Alive = shared.LocalPlayer:GetAttribute("Alive")

--// DOORS Variables \\--
Script.EntityModules = shared.ReplicatedStorage:WaitForChild("ClientModules"):WaitForChild("EntityModules")

Script.GameData = shared.ReplicatedStorage:WaitForChild("GameData")
Script.Floor = Script.GameData:WaitForChild("Floor")
Script.LatestRoom = Script.GameData:WaitForChild("LatestRoom")

Script.LiveModifiers = shared.ReplicatedStorage:WaitForChild("LiveModifiers")
Script.Voicelines = {}
if shared.ReplicatedStorage:FindFirstChild("VoiceActing") and shared.ReplicatedStorage.VoiceActing:FindFirstChild("Voicelines") then
    for _, voiceline: Sound in pairs(shared.ReplicatedStorage.VoiceActing.Voicelines:GetDescendants()) do
        if not voiceline:IsA("Sound") then continue end
        table.insert(Script.Voicelines, voiceline.SoundId)
    end
end

Script.IsMines = Script.Floor.Value == "Mines"
Script.IsRooms = Script.Floor.Value == "Rooms"
Script.IsHotel = Script.Floor.Value == "Hotel"
Script.IsBackdoor = Script.Floor.Value == "Backdoor"
Script.IsFools = Script.Floor.Value == "Fools"
Script.IsRetro = Script.Floor.Value == "Retro"

Script.FloorReplicated = if not Script.IsFools then shared.ReplicatedStorage:WaitForChild("FloorReplicated") else nil
Script.RemotesFolder = if not Script.IsFools then shared.ReplicatedStorage:WaitForChild("RemotesFolder") else shared.ReplicatedStorage:WaitForChild("EntityInfo")

--// Player DOORS Variables \\--
Script.CurrentRoom = shared.LocalPlayer:GetAttribute("CurrentRoom") or 0

if not workspace.CurrentRooms:FindFirstChild(tostring(Script.CurrentRoom)) then
    Script.CurrentRoom = Script.LatestRoom.Value
    shared.LocalPlayer:SetAttribute("CurrentRoom", Script.CurrentRoom)
end

Script.NextRoom = Script.CurrentRoom + 1

Script.MainUI = shared.PlayerGui:WaitForChild("MainUI")
Script.MainGame = Script.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game")
Script.MainGameSrc = if wax.shared.ExecutorSupport["require"] then wax.require(Script.MainGame) else nil

--// Other Variables \\--
Script.SpeedBypassing = false
Script.LastSpeed = 0
Script.Bypassed = false

--// Functions \\--
shared.Load("Utils", "Player")
shared.Load("Utils", "ESP")
shared.Load("Utils", "Assets")
shared.Load("Utils", "Entities")

shared.Load("Utils", "AutoWardrobe")
shared.Load("Utils", "BreakerBox")
shared.Load("Utils", "Padlock")
shared.Load("Utils", "Minecarts")

shared.Load("Utils", "ConnectionsFuncs")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("主要功能"),
    Exploits = shared.Window:AddTab("移除功能"),
    Visuals = shared.Window:AddTab("透视通知"),
    Floor = shared.Window:AddTab("楼层功能")
}

shared.Load("Tabs", "Main")
shared.Load("Tabs", "Exploits")
shared.Load("Tabs", "Visuals")
task.spawn(shared.Load, "Tabs", "Floor")

--// Code \\--
if wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"] then
    shared.Hooks.mtHook = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local namecallMethod = getnamecallmethod()
    
        if namecallMethod == "FireServer" then
            if self.Name == "ClutchHeartbeat" and Toggles.AutoHeartbeat.Value then
                return
            elseif self.Name == "Crouch" and Toggles.AntiHearing.Value then
                args[1] = true
                return shared.Hooks.mtHook(self, unpack(args))
            end
        elseif namecallMethod == "Destroy" and self.Name == "RunnerNodes" then
            return
        end
    
        return shared.Hooks.mtHook(self, ...)
    end)
end

--// Prompts Connection \\--
shared.Connect:GiveSignal(shared.ProximityPromptService.PromptTriggered:Connect(function(prompt, player)
    if not Toggles.InfItems.Value or player ~= shared.LocalPlayer or not shared.Character or Script.IsFools then return end
    
    local isDoorLock = prompt.Name == "UnlockPrompt" and prompt.Parent.Name == "Lock" and not prompt.Parent.Parent:GetAttribute("Opened")
    local isSkeletonDoor = prompt.Name == "SkullPrompt" and prompt.Parent.Name == "SkullLock" and not (prompt.Parent:FindFirstChild("Door") and prompt.Parent.Door.Transparency == 1)
    local isChestBox = prompt.Name == "ActivateEventPrompt" and prompt.Parent:GetAttribute("Locked") and (prompt.Parent.Name:match("Chest") or prompt.Parent:GetAttribute("LockAttribute") == "CanCutVines" or prompt.Parent.Name == "CuttableVines")
    local isRoomsDoorLock = prompt.Parent.Parent.Parent.Name == "RoomsDoor_Entrance" and prompt.Enabled
    
    if isDoorLock or isSkeletonDoor or isChestBox or isRoomsDoorLock then
        local equippedTool = shared.Character:FindFirstChildOfClass("Tool")
        -- local toolId = equippedTool and equippedTool:GetAttribute("ID")

        if equippedTool and (equippedTool:GetAttribute("UniversalKey") or equippedTool:GetAttribute("CanCutVines")) then
            if not isChestBox then task.wait() end
            Script.RemotesFolder.DropItem:FireServer(equippedTool)

            task.spawn(function()
                workspace.Drops.ChildAdded:Wait()
                task.wait(0.05)

                local itemPickupPrompt = Script.Functions.GetNearestPromptWithCondition(function(prompt)
                    return prompt.Name == "ModulePrompt" and prompt:IsDescendantOf(workspace.Drops)
                end)

                if itemPickupPrompt then
                    if isChestBox then
                        shared.fireproximityprompt(prompt)
                    end

                    shared.fireproximityprompt(itemPickupPrompt)
                end
            end)
        end
    end
end))

--// Entity Handler \\--
shared.Connect:GiveSignal(workspace.ChildAdded:Connect(function(child)
    if not child:IsA("Model") then return end

    task.delay(0.1, function()
        local shortName = Script.Functions.GetShortName(child.Name)

        if table.find(Script.EntityTable.Names, child.Name) then
            task.spawn(function()
                repeat
                    task.wait()
                until Script.Functions.DistanceFromCharacter(child) < 750 or not child:IsDescendantOf(workspace)

                if child:IsDescendantOf(workspace) then
                    if Script.IsHotel and Toggles.AvoidRushAmbush.Value and table.find(Script.EntityTable.Avoid, child.Name) then
                        local oldNoclip = Toggles.Noclip.Value
                        local distance = Script.Functions.DistanceFromCharacter(child)

                        task.spawn(function()
                            repeat 
                                shared.RunService.Heartbeat:Wait()
                                distance = Script.Functions.DistanceFromCharacter(child)
                            until distance <= 150 or not child:IsDescendantOf(workspace)

                            if child:IsDescendantOf(workspace) then
                                Script.Functions.AvoidEntity(true)
                                repeat task.wait() until not child:IsDescendantOf(workspace)
                                Script.Functions.AvoidEntity(false, oldNoclip)
                            end
                        end)
                    end

                    if table.find(Script.EntityTable.AutoWardrobe.Entities, child.Name) then
                        local distance = Script.EntityTable.AutoWardrobe.Distance[child.Name].Loader

                        task.spawn(function()
                            repeat shared.RunService.Heartbeat:Wait() until not child:IsDescendantOf(workspace) or Script.Functions.DistanceFromCharacter(child) <= distance

                            if child:IsDescendantOf(workspace) and Toggles.AutoWardrobe.Value then
                                Script.Functions.AutoWardrobe(child)
                            end
                        end)
                    end
                    
                    if Script.IsFools and child.Name == "RushMoving" then
                        shortName = child.PrimaryPart.Name:gsub("New", "")
                    end

                    if Toggles.EntityESP.Value then
                        Script.Functions.EntityESP(child)  
                    end

                    if Options.NotifyEntity.Value[shortName] then
                        shared.Notify:Alert({
                            Title = "ENTITIES",
                            Description = string.format("%s %s", shortName, Options.NotifyEntityMessage.Value),
                            Reason = (not Script.EntityTable.NotifyReason[child.Name].Spawned and "Go find a hiding place!" or nil),
                            Image = Script.EntityTable.NotifyReason[child.Name].Image,

                            Warning = true
                        })

                        if Toggles.NotifyChat.Value then
                            shared.RBXGeneral:SendAsync(string.format("%s %s", shortName, Options.NotifyEntityMessage.Value))
                        end
                    end
                end
            end)
        elseif Script.EntityTable.NotifyMessage[child.Name] and Options.NotifyEntity.Value[shortName] then
            shared.Notify:Alert({
                Title = "ENTITIES",
                Description = string.format("%s %s", shortName, Options.NotifyEntityMessage.Value),
                Reason = (not Script.EntityTable.NotifyReason[child.Name].Spawned and "Go find a hiding place!" or nil),
                Image = Script.EntityTable.NotifyReason[child.Name].Image,

                Warning = true
            })

            if Toggles.NotifyChat.Value then
                shared.RBXGeneral:SendAsync(Script.EntityTable.NotifyMessage[child.Name])     
            end
        end

        if Script.IsFools then
            if Toggles.AntiBananaPeel.Value and child.Name == "BananaPeel" then
                child.CanTouch = false
            end

            if Toggles.AntiJeffClient.Value and child.Name == "JeffTheKiller" then
                for i, v in pairs(child:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanTouch = false
                    end
                end
            end

            if Toggles.AntiJeffServer.Value and child.Name == "JeffTheKiller" then
                task.spawn(function()
                    repeat task.wait() until shared.isnetworkowner(child.PrimaryPart)
                    child:FindFirstChildOfClass("Humanoid").Health = 0
                end)
            end
        end

        if (child.Name == "RushMoving" or child.Name == "AmbushMoving") and Toggles.InfCrucifix.Value and Script.Alive and shared.Character then
            task.wait(1.5)
            
            local hasStoppedMoving = false --entity has stoped
            local lastPosition = child:GetPivot().Position
            local lastVelocity = Vector3.new(0, 0, 0)

            local frameCount = 0
            local nextTimer = tick()
            local maxSavedFrames = 10 --after that we can ignore velocity by 0
            local currentSavedFrames = 0
            local physicsTickRate = (1 / 60) * 0.90 --usually is stable also wtf roblox why 60 Hz isn't (1 / 60) ????

            local oldFrameHz = 0
            local frameHz = 0
            local frameRate = 1 -- in seconds
            local nextTimerHz = tick()

            local entityName = child.Name

            local crucifixConnection; crucifixConnection = shared.RunService.RenderStepped:Connect(function(deltaTime)
                if not Toggles.InfCrucifix.Value or not Script.Alive or not shared.Character then crucifixConnection:Disconnect() return end

                local currentTimer = tick()
                frameCount += 1 
                frameHz += 1

                -- get the client FPS
                if currentTimer - nextTimerHz >= frameRate then
                    oldFrameHz = frameHz;
                    frameHz = 0
                    nextTimerHz = currentTimer
                    physicsTickRate = (1 / oldFrameHz) * 0.90
                end

                -- refresh rate (client) must be equal to the physics rate (server) for making the calculations properly.
                if physicsTickRate == 0 or not (currentTimer - nextTimer >= physicsTickRate) then
                    return
                end

                frameCount = 0
                nextTimer = currentTimer
            
                local currentPosition = child:GetPivot().Position
                -- Calculate velocity
                local velocity = (currentPosition - lastPosition) / deltaTime
                velocity = Vector3.new(velocity.X, 0, velocity.Z) -- Ignore Y
            
                -- Smooth velocity
                local smoothedVelocity = lastVelocity:Lerp(velocity, 0.3) --we do math stuff
                local entityVelocity = math.floor(smoothedVelocity.Magnitude)
            
                lastVelocity = smoothedVelocity
                lastPosition = currentPosition
            
                local inView = Script.Functions.IsInViewOfPlayer(child, Script.EntityTable.InfCrucifixVelocity[entityName].minDistance)
                local distanceFromPlayer = (child:GetPivot().Position - shared.Character:GetPivot().Position).Magnitude
                local isInRangeOfPlayer = distanceFromPlayer <= Script.EntityTable.InfCrucifixVelocity[entityName].minDistance
                --[[if currentSavedFrames < maxSavedFrames then
                    print(string.format("[In range: %s | In view: %s] [Hz: %d] - Entity velocity is: %.2f | Distance: %.2f | Delta: %.2f", tostring(isInRangeOfPlayer), tostring(inView), oldFrameHz, entityVelocity, distanceFromPlayer, 0))
                end]]
            
                if entityVelocity <= Script.EntityTable.InfCrucifixVelocity[entityName].threshold then
                    if entityVelocity <= 0.5 and currentSavedFrames <= maxSavedFrames then
                        currentSavedFrames += 1
                    end
            
                    --switch and trigger a print
                    if not hasStoppedMoving then
                        --print("Entity has stopped moving!")
                        hasStoppedMoving = true
                    end
            
                    -- --ignore if raycast is false
                    if not inView then
                        return
                    end
            
                    --ignore if distance is greater than X
                    if not isInRangeOfPlayer then
                        return
                    end

                    if shared.Character:FindFirstChild("Crucifix") then
                        workspace.Drops.ChildAdded:Once(function(droppedItem)
                            if droppedItem.Name == "Crucifix" then
                                local targetProximityPrompt = droppedItem:WaitForChild("ModulePrompt", 3) or droppedItem:FindFirstChildOfClass("ProximityPrompt")
                                repeat task.wait()
                                    shared.fireproximityprompt(targetProximityPrompt)
                                until not droppedItem:IsDescendantOf(workspace)
                            end
                        end)

                        Script.RemotesFolder.DropItem:FireServer(shared.Character.Crucifix);
                    end

                    return
                end

                currentSavedFrames = 0
                if hasStoppedMoving then
                    --print("Entity started moving!")
                    hasStoppedMoving = false
                end
            end)
            
            local childRemovedConnection; childRemovedConnection = workspace.ChildRemoved:Connect(function(model: Model)
                if model ~= child then return end

                crucifixConnection:Disconnect()
                childRemovedConnection:Disconnect()
            end)

            shared.Connect:GiveSignal(crucifixConnection)
            shared.Connect:GiveSignal(childRemovedConnection)
        end
    end)

    if shared.CheckToggle("NoVoiceActing", true) and table.find(Script.EntityTable.Names, child.Name) then
        for _, sound in pairs(child:GetDescendants()) do
            if Script.Functions.VoiceCondition(sound) then sound:Destroy() end
        end

        shared.Connect:GiveSignal(child.DescendantAdded:Connect(function(child)
            if Script.Functions.VoiceCondition(child) then child:Destroy() end
        end))
    end
end))

--// Drops Connection \\--
for _, drop in pairs(workspace.Drops:GetChildren()) do
    task.spawn(Script.Functions.SetupDropConnection, drop)
end
shared.Connect:GiveSignal(workspace.Drops.ChildAdded:Connect(function(child)
    task.spawn(Script.Functions.SetupDropConnection, child)
end))

--// Rooms Connection \--
for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
    task.spawn(Script.Functions.SetupRoomConnection, room)

    if Script.IsMines then
        task.spawn(Script.Functions.Minecart.Pathfind, room, tonumber(room.Name))
    end
end
shared.Connect:GiveSignal(workspace.CurrentRooms.ChildAdded:Connect(function(room)
    task.spawn(Script.Functions.SetupRoomConnection, room)
    
    if Script.IsMines then
        task.spawn(Script.Functions.Minecart.Pathfind, room, tonumber(room.Name))
    end
end))

--// Camera Connection \\--
if shared.Camera then task.spawn(Script.Functions.SetupCameraConnection, shared.Camera) end
shared.Connect:GiveSignal(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then
        shared.Camera = workspace.CurrentCamera
        task.spawn(Script.Functions.SetupCameraConnection, shared.Camera)
    end
end))

--// Players Connection \\--
for _, player in pairs(shared.Players:GetPlayers()) do
    if player == shared.LocalPlayer then continue end
    Script.Functions.SetupOtherPlayerConnection(player)
end
shared.Connect:GiveSignal(shared.Players.PlayerAdded:Connect(Script.Functions.SetupOtherPlayerConnection))

--// Local Player Connection \\--
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
    if Script.FakeRevive.Enabled then
        Script.FakeRevive.Enabled = false

        for _, connection in pairs(Script.FakeRevive.Connections) do
            connection:Disconnect()
        end
        
        table.clear(Script.FakeRevive.Connections)

        if Toggles.FakeRevive.Value then
            shared.Notify:Alert({
                Title = "Fake Revive",
                Description = "You have revived, fake revive has stopped working.",
                Reason = "Enable it again to start fake revive",

                LinoriaMessage = "Fake Revive has stopped working, enable it again to start fake revive",
            })
            Toggles.FakeRevive:SetValue(false)
        end

        if Script.IsMines and Toggles.EnableJump.Value then
            Options.WalkSpeed:SetMax((Toggles.TheMinesAnticheatBypass.Value and Script.Bypassed) and 75 or 18)
        else
            Options.WalkSpeed:SetMax((Script.IsMines and Toggles.TheMinesAnticheatBypass.Value and Script.Bypassed) and 75 or 22)
        end

        Options.FlySpeed:SetMax((Script.IsMines and Toggles.TheMinesAnticheatBypass.Value and Script.Bypassed) and 75 or 22)
    end
end))

shared.Connect:GiveSignal(shared.LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
    Script.Alive = shared.LocalPlayer:GetAttribute("Alive")

    if not Script.Alive and Script.IsFools and Toggles.InfRevives.Value then
        task.delay(1.25, function()
            Script.RemotesFolder.Revive:FireServer()
        end)
    end
end))

shared.Connect:GiveSignal(shared.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "MainUI" then
        Script.MainUI = child

        task.delay(1, function()
            if Script.MainUI then
                Script.MainGame = Script.MainUI:WaitForChild("Initiator"):WaitForChild("Main_Game")

                if Script.MainGame then
                    if wax.shared.ExecutorSupport["require"] then Script.MainGameSrc = wax.require(Script.MainGame) end

                    if Script.MainGame:WaitForChild("Health", 5) then
                        if Script.IsHotel and Toggles.NoJammin.Value and Script.LiveModifiers:FindFirstChild("Jammin") then
                            local jamSound = Script.MainGame:FindFirstChild("Jam", true)
                            if jamSound then jamSound.Playing = false end
                        end
                    end

                    if Script.MainGame:WaitForChild("RemoteListener", 5) then
                        local modules = Script.MainGame:FindFirstChild("Modules", true)
                        if not modules then return end
                    
                        if Toggles.AntiDread.Value then
                            local module = modules:FindFirstChild("Dread", true)
    
                            if module then
                                module.Name = "_Dread"
                            end
                        end

                        if Toggles.AntiScreech.Value then
                            local module = modules:FindFirstChild("Screech", true)
    
                            if module then
                                module.Name = "_Screech"
                            end
                        end

                        if Toggles.NoSpiderJumpscare.Value then
                            local module = modules:FindFirstChild("SpiderJumpscare", true)
    
                            if module then
                                module.Name = "_SpiderJumpscare"
                            end
                        end

                        if (Script.IsHotel or Script.IsRooms) and Toggles.AntiA90.Value then
                            local module = modules:FindFirstChild("A90", true)
    
                            if module then
                                module.Name = "_A90"
                            end
                        end
                    end
                end
            end
        end)
    end
end))

--// ESP Handler \\--
shared.Connect:GiveSignal(Script.LatestRoom:GetPropertyChangedSignal("Value"):Connect(function()
    Script.Functions.NotifyGlitch()
end))

shared.Connect:GiveSignal(shared.LocalPlayer:GetAttributeChangedSignal("CurrentRoom"):Connect(function()
    if Script.CurrentRoom == shared.LocalPlayer:GetAttribute("CurrentRoom") then return end

    Script.CurrentRoom = shared.LocalPlayer:GetAttribute("CurrentRoom")
    Script.NextRoom = Script.CurrentRoom + 1
    task.spawn(Script.Functions.UpdateRPC)

    Script.Functions.NotifyGlitch()

    local currentRoomModel = workspace.CurrentRooms:FindFirstChild(Script.CurrentRoom)
    local nextRoomModel = workspace.CurrentRooms:FindFirstChild(Script.NextRoom)

    if Script.IsMines and Script.Bypassed and currentRoomModel:GetAttribute("RawName") == "HaltHallway" then
        Script.Bypassed = false
        shared.Notify:Alert({
            Title = "Anticheat Bypass",
            Description = "Halt has broken anticheat bypass.",
            Reason = "Please go on a ladder again to fix it.",

            LinoriaMessage = "Halt has broken anticheat bypass, please go on a ladder again to fix it.",
        })

        Options.WalkSpeed:SetMax(Toggles.SpeedBypass.Value and 75 or (Toggles.EnableJump.Value and 18 or 22))
        Options.FlySpeed:SetMax(Toggles.SpeedBypass.Value and 75 or 22)
    end

    if Toggles.DoorESP.Value then
        for _, doorEsp in pairs(Script.ESPTable.Door) do
            doorEsp.Destroy()
        end

        if currentRoomModel then
            task.spawn(Script.Functions.DoorESP, currentRoomModel)
        end

        if nextRoomModel then
            task.spawn(Script.Functions.DoorESP, nextRoomModel)
        end
    end
    if Toggles.ObjectiveESP.Value then
        for _, objectiveEsp in pairs(Script.ESPTable.Objective) do
            objectiveEsp.Destroy()
        end
    end
    if Toggles.EntityESP.Value then
        for _, sideEntityESP in pairs(Script.ESPTable.SideEntity) do
            sideEntityESP.Destroy()
        end
    end
    if Toggles.ItemESP.Value then
        for _, itemEsp in pairs(Script.ESPTable.Item) do
            itemEsp.Destroy()
        end
    end
    if Toggles.ChestESP.Value then
        for _, chestEsp in pairs(Script.ESPTable.Chest) do
            chestEsp.Destroy()
        end
    end
    if Toggles.HidingSpotESP.Value then
        for _, hidingSpotEsp in pairs(Script.ESPTable.HidingSpot) do
            hidingSpotEsp.Destroy()
        end
    end
    if Toggles.GoldESP.Value then
        for _, goldEsp in pairs(Script.ESPTable.Gold) do
            goldEsp.Destroy()
        end
    end

    if currentRoomModel then
        for _, asset in pairs(currentRoomModel:GetDescendants()) do
            if Toggles.ObjectiveESP.Value then
                task.spawn(Script.Functions.ObjectiveESP, asset)
            end

            if Toggles.EntityESP.Value and table.find(Script.EntityTable.SideNames, asset.Name) then    
                task.spawn(Script.Functions.SideEntityESP, asset)
            end
    
            if Toggles.ItemESP.Value and Script.Functions.ItemCondition(asset) then
                task.spawn(Script.Functions.ItemESP, asset)
            end

            if Toggles.ChestESP.Value and (asset:GetAttribute("Storage") == "ChestBox" or asset.Name == "Toolshed_Small") then
                task.spawn(Script.Functions.ChestESP, asset)
            end

            if Toggles.HidingSpotESP.Value and (asset:GetAttribute("LoadModule") == "Wardrobe" or asset:GetAttribute("LoadModule") == "Bed" or asset.Name == "Rooms_Locker" or asset.Name == "RetroWardrobe") then
                Script.Functions.HidingSpotESP(asset)
            end

            if Toggles.GoldESP.Value and asset.Name == "GoldPile" then
                Script.Functions.GoldESP(asset)
            end
        end
    end
end))

--// UIS Connection \\--
shared.Connect:GiveSignal(shared.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if shared.UserInputService:GetFocusedTextBox() then return end

    if shared.CheckToggle("GrabBananaJeffToggle", true) and shared.Library.IsMobile and input.UserInputType == Enum.UserInputType.Touch then
        if Script.Temp.HoldingItem then
            return Script.Functions.ThrowBananaJeff()
        end

        local touchPos = input.Position
        local ray = workspace.CurrentCamera:ViewportPointToRay(touchPos.X, touchPos.Y)
        local result = workspace:Raycast(ray.Origin, ray.Direction * 500, RaycastParams.new())
        
        local target = result and result.Instance

        if target and shared.isnetworkowner(target) then
            if target.Name == "BananaPeel" then
                Script.Tracks.ItemHoldTrack:Play()

                if not target:FindFirstChildOfClass("BodyGyro") then
                    Instance.new("BodyGyro", target)
                end

                if not target:GetAttribute("Clip") then target:SetAttribute("Clip", target.CanCollide) end

                target.CanTouch = false
                target.CanCollide = false

                Script.Temp.HoldingItem = target
            elseif target:FindFirstAncestorWhichIsA("Model").Name == "JeffTheKiller" then
                Script.Tracks.ItemHoldTrack:Play()

                local jeff = target:FindFirstAncestorWhichIsA("Model")

                for _, part in ipairs(jeff:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if not part:GetAttribute("Clip") then part:SetAttribute("Clip", target.CanCollide) end

                        part.CanTouch = false
                        part.CanCollide = false
                    end
                end

                if not jeff.PrimaryPart:FindFirstChildOfClass("BodyGyro") then
                    Instance.new("BodyGyro", jeff.PrimaryPart)
                end

                Script.Temp.HoldingItem = jeff.PrimaryPart
            end
        end
    end
end))

--// Main RenderStepped \\--
shared.Connect:GiveSignal(shared.RunService.RenderStepped:Connect(function()
    if not Toggles.ShowCustomCursor.Value and shared.Library.Toggled then
        shared.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        shared.UserInputService.MouseIcon = "rbxassetid://2833720882"
        shared.UserInputService.MouseIconEnabled = true
    end

    local isThirdPersonEnabled = Toggles.ThirdPerson.Value and (shared.Library.IsMobile or Options.ThirdPersonKey:GetState())
    if Script.MainGameSrc then
        if isThirdPersonEnabled then
            shared.Camera.CFrame = Script.MainGameSrc.finalCamCFrame * CFrame.new(1.5, -0.5, 6.5)
        end
        Script.MainGameSrc.fovtarget = Options.FOV.Value

        if Toggles.NoCamBob.Value then
            Script.MainGameSrc.bobspring.Position = Vector3.new()
            Script.MainGameSrc.spring.Position = Vector3.new()
        end

        if Toggles.NoCamShake.Value then
            Script.MainGameSrc.csgo = CFrame.new()
        end
    elseif shared.Camera then
        if isThirdPersonEnabled then
            shared.Camera.CFrame = shared.Camera.CFrame * CFrame.new(1.5, -0.5, 6.5)
        end

        shared.Camera.FieldOfView = Options.FOV.Value
    end

    if shared.Character then
        if shared.Character:FindFirstChild("Head") and 
            not (
                Script.MainGameSrc and Script.MainGameSrc.stopcam or (shared.RootPart and shared.RootPart.Anchored) and not shared.Character:GetAttribute("Hiding")
            ) 
        then
            shared.Character:SetAttribute("ShowInFirstPerson", isThirdPersonEnabled)
            shared.Character.Head.LocalTransparencyModifier = isThirdPersonEnabled and 0 or 1
        end

        if shared.Humanoid and Toggles.EnableSpeedHack.Value then
            shared.Humanoid.WalkSpeed = if shared.Character:GetAttribute("Climbing") then Options.LadderSpeed.Value else Options.WalkSpeed.Value
        end

        if shared.RootPart then
            shared.RootPart.CanCollide = not Toggles.Noclip.Value
        end
        
        if Script.Collision then
            if Toggles.Noclip.Value then
                Script.Collision.CanCollide = not Toggles.Noclip.Value
                if Script.Collision:FindFirstChild("CollisionCrouch") then
                    Script.Collision.CollisionCrouch.CanCollide = not Toggles.Noclip.Value
                end
            end
        end

        if shared.Character:FindFirstChild("UpperTorso") then
            shared.Character.UpperTorso.CanCollide = not Toggles.Noclip.Value
        end
        if shared.Character:FindFirstChild("LowerTorso") then
            shared.Character.LowerTorso.CanCollide = not Toggles.Noclip.Value
        end

        if Toggles.DoorReach.Value and workspace.CurrentRooms:FindFirstChild(Script.LatestRoom.Value) then
            local door = workspace.CurrentRooms[Script.LatestRoom.Value]:FindFirstChild("Door")

            if door and door:FindFirstChild("ClientOpen") then
                door.ClientOpen:FireServer()
            end
        end

        if Toggles.AutoInteract.Value and (shared.Library.IsMobile or Options.AutoInteractKey:GetState()) then
            local prompts = Script.Functions.GetAllPromptsWithCondition(function(prompt)
                if not prompt.Parent then return false end

                if Options.AutoInteractIgnore.Value["Jeff Items"] and prompt.Parent:GetAttribute("JeffShop") then return false end
                if Options.AutoInteractIgnore.Value["Unlock w/ Lockpick"] and (prompt.Name == "UnlockPrompt" or prompt.Parent:GetAttribute("Locked")) and shared.Character:FindFirstChild("Lockpick") then return false end
                if Options.AutoInteractIgnore.Value["Paintings"] and prompt.Name == "PropPrompt" then return false end
                if Options.AutoInteractIgnore.Value["Gold"] and prompt.Name == "LootPrompt" then return false end
                if Options.AutoInteractIgnore.Value["Light Source Items"] and prompt.Parent:GetAttribute("Tool_LightSource") and not prompt.Parent:GetAttribute("Tool_CanCutVines") then return false end
                if Options.AutoInteractIgnore.Value["Skull Prompt"] and prompt.Name == "SkullPrompt" then return false end

                if prompt.Parent:GetAttribute("PropType") == "Battery" and not (shared.Character:FindFirstChildOfClass("Tool") and (shared.Character:FindFirstChildOfClass("Tool"):GetAttribute("RechargeProp") == "Battery" or shared.Character:FindFirstChildOfClass("Tool"):GetAttribute("StorageProp") == "Battery")) then return false end 
                if prompt.Parent:GetAttribute("PropType") == "Heal" and shared.Humanoid and shared.Humanoid.Health == shared.Humanoid.MaxHealth then return false end
                if prompt.Parent.Name == "MinesAnchor" then return false end

                if Script.IsRetro and prompt.Parent.Parent.Name == "RetroWardrobe" then return false end

                return Script.PromptTable.Aura[prompt.Name] ~= nil
            end)

            for _, prompt: ProximityPrompt in pairs(prompts) do
                task.spawn(function()
                    -- checks if distance can interact with prompt and if prompt can be interacted again
                    if Script.Functions.DistanceFromCharacter(prompt.Parent) < prompt.MaxActivationDistance and (not prompt:GetAttribute("Interactions" .. shared.LocalPlayer.Name) or Script.PromptTable.Aura[prompt.Name] or table.find(Script.PromptTable.AuraObjects, prompt.Parent.Name)) then
                        if prompt.Parent.Name == "Slot" and prompt.Parent:GetAttribute("Hint") then
                            if Script.Temp.PaintingDebounce[prompt] then return end

                            local currentPainting = shared.Character:FindFirstChild("Prop")
                            local slotPainting = prompt.Parent:FindFirstChild("Prop")

                            local currentHint = (currentPainting and currentPainting:GetAttribute("Hint"))
                            local slotHint = (slotPainting and slotPainting:GetAttribute("Hint"))
                            local promptHint = prompt.Parent:GetAttribute("Hint")

                            --print(currentHint, slotHint, promptHint)
                            if slotHint ~= promptHint and (currentHint == promptHint or slotPainting) then
                                Script.Temp.PaintingDebounce[prompt] = true
                                shared.fireproximityprompt(prompt)
                                task.wait(0.3)
                                Script.Temp.PaintingDebounce[prompt] = false    
                            end
        
                            return
                        end
                        
                        shared.fireproximityprompt(prompt)
                    end
                end)
            end
        end

        if Toggles.SpamOtherTools.Value and (shared.Library.IsMobile or Options.SpamOtherTools:GetState()) then
            for _, player in pairs(shared.Players:GetPlayers()) do
                if player == shared.LocalPlayer then continue end
                
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    tool:FindFirstChildOfClass("RemoteEvent"):FireServer()
                end
                
                local toolRemote = player.Character:FindFirstChild("Remote", true)
                if toolRemote then
                    toolRemote:FireServer()
                end
            end
        end

        if Toggles.AnticheatManipulation.Value and (shared.Library.IsMobile or Options.AnticheatManipulationKey:GetState()) then
            shared.Character:PivotTo(shared.Character:GetPivot() * CFrame.new(0, 0, 1000))
        end

        if Script.IsMines then
            if Toggles.AutoAnchorSolver.Value and Script.LatestRoom.Value == 50 and Script.MainUI.MainFrame:FindFirstChild("AnchorHintFrame") then
                local prompts = Script.Functions.GetAllPromptsWithCondition(function(prompt)
                    return prompt.Name == "ActivateEventPrompt" and prompt.Parent:IsA("Model") and prompt.Parent.Name == "MinesAnchor" and not prompt.Parent:GetAttribute("Activated")
                end)

                local CurrentGameState = {
                    DesignatedAnchor = Script.MainUI.MainFrame.AnchorHintFrame.AnchorCode.Text,
                    AnchorCode = Script.MainUI.MainFrame.AnchorHintFrame.Code.Text
                }

                for _, prompt in pairs(prompts) do
                    task.spawn(function()
                        local Anchor = prompt.Parent
                        local CurrentAnchor = Anchor.Sign.TextLabel.Text

                        if not (Script.Functions.DistanceFromCharacter(prompt.Parent) < prompt.MaxActivationDistance) then return end
                        if CurrentAnchor ~= CurrentGameState.DesignatedAnchor then return end

                        local result = Anchor:FindFirstChildOfClass("RemoteFunction"):InvokeServer(CurrentGameState.AnchorCode)
                        if result then
                            shared.Notify:Alert({
                                Title = "Auto Anchor Solver",
                                Description = "Solved Anchor " .. CurrentAnchor .. " successfully!",
                                Reason = "Solved anchor with the code " .. CurrentGameState.AnchorCode,
                            })
                        end
                    end)
                end
            end
        elseif Script.IsFools then
            local HoldingItem = Script.Temp.HoldingItem
            if HoldingItem and not shared.isnetworkowner(HoldingItem) then
                shared.Notify:Alert({
                    Title = "Banana/Jeff Throw",
                    Description = "由于网络所有者变更，您不再持有该物品！",
                })
                Script.Temp.HoldingItem = nil
            end
    
            if HoldingItem and Toggles.GrabBananaJeffToggle.Value then
                if HoldingItem:FindFirstChildOfClass("BodyGyro") then
                    HoldingItem.CanTouch = false
                    HoldingItem.CFrame = shared.Character.RightHand.CFrame * CFrame.Angles(math.rad(-90), 0, 0)
                end
            end
            
            if not shared.Library.IsMobile then
                local isGrabbing = Options.GrabBananaJeff:GetState() and Toggles.GrabBananaJeffToggle.Value
                local isThrowing = Options.ThrowBananaJeff:GetState()
                
                if isThrowing and HoldingItem and shared.isnetworkowner(HoldingItem) then
                    Script.Functions.ThrowBananaJeff()
                end
                
                local target = shared.LocalPlayer:GetMouse().Target
                
                if not target then return end
                if isGrabbing and shared.isnetworkowner(target) then
                    if target.Name == "BananaPeel" then
                        Script.Tracks.ItemHoldTrack:Play()
    
                        if not target:FindFirstChildOfClass("BodyGyro") then
                            Instance.new("BodyGyro", target)
                        end
    
                        if not target:GetAttribute("Clip") then target:SetAttribute("Clip", target.CanCollide) end
    
                        target.CanTouch = false
                        target.CanCollide = false
    
                        Script.Temp.HoldingItem = target
                    elseif target:FindFirstAncestorWhichIsA("Model").Name == "JeffTheKiller" then
                        Script.Tracks.ItemHoldTrack:Play()
    
                        local jeff = target:FindFirstAncestorWhichIsA("Model")
    
                        for _, i in ipairs(jeff:GetDescendants()) do
                            if i:IsA("BasePart") then
                                if not i:GetAttribute("Clip") then i:SetAttribute("Clip", target.CanCollide) end
    
                                i.CanTouch = false
                                i.CanCollide = false
                            end
                        end
    
                        if not jeff.PrimaryPart:FindFirstChildOfClass("BodyGyro") then
                            Instance.new("BodyGyro", jeff.PrimaryPart)
                        end
    
                        Script.Temp.HoldingItem = jeff.PrimaryPart
                    end
                end
            end
        end

        if Toggles.AntiEyes.Value and (workspace:FindFirstChild("Eyes") or workspace:FindFirstChild("BackdoorLookman")) then
            if not Script.IsFools then
                -- lsplash meanie for removing other args in motorreplication
                Script.RemotesFolder.MotorReplication:FireServer(-649)
            else
                Script.RemotesFolder.MotorReplication:FireServer(0, -90, 0, false)
            end
        end
    end

    task.spawn(function()
        for guidance, part in pairs(Script.Temp.Guidance) do
            if not guidance:IsDescendantOf(workspace) then continue end
            part.CFrame = guidance.CFrame
        end
    end)
end))

shared.Connect:GiveSignal(shared.RunService.RenderStepped:Connect(function()
    if Toggles["ShowCustomCursor"] and not Toggles.ShowCustomCursor.Value and shared.Library.Toggled then
        shared.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        shared.UserInputService.MouseIcon = "rbxassetid://2833720882"
        shared.UserInputService.MouseIconEnabled = true
    end
end))

--// Load \\--
task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)

shared.Library:OnUnload(function()
    print("Unloading DOORS...")
    if shared.Hooks.mtHook then hookmetamethod(game, "__namecall", shared.Hooks.mtHook) end
    if shared.Hooks._fixDistanceFromCharacter then hookmetamethod(shared.Hooks.LocalPlayer, "__namecall", shared.Hooks._fixDistanceFromCharacter) end

    if Script.FakeRevive.Enabled then
        for _, connection in pairs(Script.FakeRevive.Connections) do
            if connection.Connected then connection:Disconnect() end
        end

        table.clear(Script.FakeRevive.Connections)
    end

    if wax.shared.BloxstrapRPC then
        wax.shared.BloxstrapRPC.SetRichPresence({
            details = "<reset>",
            state = "<reset>",
            largeImage = {
                reset = true
            },
            smallImage = {
                reset = true
            }
        })
    end

    if shared.Character then
        shared.Character:SetAttribute("CanJump", false)

        local speedBoostAssignObj = Script.IsFools and shared.Humanoid or shared.Character
        speedBoostAssignObj:SetAttribute("SpeedBoostBehind", 0)
    end

    if Script.Alive then
        shared.Lighting.Ambient = workspace.CurrentRooms[Script.CurrentRoom]:GetAttribute("Ambient")
    else
        shared.Lighting.Ambient = Color3.new(0, 0, 0)
    end

    if Script.EntityModules then
        local haltModule = Script.EntityModules:FindFirstChild("_Shade")
        local glitchModule = Script.EntityModules:FindFirstChild("_Glitch")
        local voidModule = Script.EntityModules:FindFirstChild("_Void")

        if haltModule then
            haltModule.Name = "Shade"
        end
        if glitchModule then
            glitchModule.Name = "Glitch"
        end
        if voidModule then
            voidModule.Name = "Void"
        end
    end

    local voicelines = shared.ReplicatedStorage:FindFirstChild("_Voicelines", true)
    if voicelines then
        voicelines.Name = "Voicelines"
    end

    if Script.MainGame then
        local modules = Script.MainGame:FindFirstChild("Modules", true)

        local dreadModule = modules and modules:FindFirstChild("_Dread", true)
        local screechModule = modules and modules:FindFirstChild("_Screech", true)
        local spiderModule = modules and modules:FindFirstChild("_SpiderJumpscare", true)

        if dreadModule then
            dreadModule.Name = "Dread"
        end
        if screechModule then
            screechModule.Name = "Screech"
        end
        if spiderModule then
            spiderModule.Name = "SpiderJumpscare"
        end
    end

    if Script.MainGameSrc then
        Script.MainGameSrc.fovtarget = 70
    else
        shared.Camera.FieldOfView = 70
    end

    if shared.RootPart then
        local existingProperties = shared.RootPart.CustomPhysicalProperties
        shared.RootPart.CustomPhysicalProperties = PhysicalProperties.new(Script.Temp.NoAccelValue, existingProperties.Friction, existingProperties.Elasticity, existingProperties.FrictionWeight, existingProperties.ElasticityWeight)
    end

    if Script.Tracks.ItemHoldTrack then Script.Tracks.ItemHoldTrack:Stop() end
    if Script.Tracks.ItemThrowTrack then Script.Tracks.ItemThrowTrack:Stop() end
    shared.Twerk:Disable()

    for _, animation in pairs(Script.Anims) do
        animation:Destroy()
    end

    if Script.IsBackdoor then
        local clientRemote = Script.FloorReplicated.ClientRemote
        local internal_temp_mspaint = clientRemote:FindFirstChild("_mspaint")

        if internal_temp_mspaint and #internal_temp_mspaint:GetChildren() ~= 0 then
            for i,v in pairs(internal_temp_mspaint:GetChildren()) do
                v.Parent = clientRemote.Haste
            end
        end

        internal_temp_mspaint:Destroy()
    end

    if Script.IsMines then
        local acbypasspart = workspace:FindFirstChild("_internal_mspaint_acbypassprogress")
        if acbypasspart then acbypasspart:Destroy() end
    end

    if Script.IsRooms then
        if workspace:FindFirstChild("_internal_mspaint_pathfinding_nodes") then
            workspace:FindFirstChild("_internal_mspaint_pathfinding_nodes"):Destroy()
        end
        if workspace:FindFirstChild("_internal_mspaint_pathfinding_block") then
            workspace:FindFirstChild("_internal_mspaint_pathfinding_block"):Destroy()
        end
    end

    if Script._mspaint_custom_captions then
        Script._mspaint_custom_captions:Destroy()
    end

    if Script.Collision then
        Script.Collision.CanCollide = if Script.MainGameSrc then not Script.MainGameSrc.crouching else not shared.Character:GetAttribute("Crouching")
        if Script.Collision:FindFirstChild("CollisionCrouch") then
            Script.Collision.CollisionCrouch.CanCollide = if Script.MainGameSrc then Script.MainGameSrc.crouching else shared.Character:GetAttribute("Crouching")
        end
    end

    if Script.CollisionClone then Script.CollisionClone:Destroy() end

    for _, antiBridge in pairs(Script.Temp.Bridges) do antiBridge:Destroy() end
    for _, antiBridge in pairs(Script.Temp.PipeBridges) do antiBridge:Destroy() end

    for _, espType in pairs(Script.ESPTable) do
        for _, esp in pairs(espType) do
            esp.Destroy()
        end
    end

    for _, category in pairs(Script.FeatureConnections) do
        for _, connection in pairs(category) do
            connection:Disconnect()
        end
    end
    
    for _, object in pairs(workspace.CurrentRooms:GetDescendants()) do
        if Script.Functions.PromptCondition(object) then
            if not object:GetAttribute("Hold") then object:SetAttribute("Hold", object.HoldDuration) end
            if not object:GetAttribute("Distance") then object:SetAttribute("Distance", object.MaxActivationDistance) end
            if not object:GetAttribute("Clip") then object:SetAttribute("Clip", object.RequiresLineOfSight) end

            object.HoldDuration = object:GetAttribute("Hold")
            object.MaxActivationDistance = object:GetAttribute("Distance")
            object.RequiresLineOfSight = object:GetAttribute("Clip")
        elseif object:IsA("BasePart") then
            if not object:GetAttribute("Material") then object:SetAttribute("Material", object.Material) end
            if not object:GetAttribute("Reflectance") then object:SetAttribute("Reflectance", object.Reflectance) end

            object.Material = object:GetAttribute("Material")
            object.Reflectance = object:GetAttribute("Reflectance")
        elseif object:IsA("Decal") then
            if not object:GetAttribute("Transparency") then object:SetAttribute("Transparency", object.Transparency) end

            if not table.find(Script.SlotsName, object.Name) then
                object.Transparency = object:GetAttribute("Transparency")
            end
        end
    end

    workspace.Terrain.WaterReflectance = 1
    workspace.Terrain.WaterTransparency = 1
    workspace.Terrain.WaterWaveSize = 0.05
    workspace.Terrain.WaterWaveSpeed = 8
    shared.Lighting.GlobalShadows = true

    print("Unloaded DOORS!")
end)

getgenv().mspaint_loaded = true
end)() end,
    [9] = function()local wax,script,require=ImportGlobals(9)local ImportGlobals return (function(...)--// Loading Wait \\--
if shared.LocalPlayer.PlayerGui:FindFirstChild("LoadingUI") and shared.LocalPlayer.PlayerGui.LoadingUI.Enabled then
    repeat task.wait() until not shared.LocalPlayer.PlayerGui.LoadingUI.Enabled
end

shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()

--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script
Script.CurrentBadge = 0
Script.Achievements = {
    "SurviveWithoutHiding",
    "SurviveGloombats",
    "SurviveSeekMinesSecond",
    "TowerHeroesGoblino",
    "EscapeBackdoor",
    "SurviveFiredamp",
    "CrucifixDread",
    "EnterRooms",
    "EncounterVoid",
    "Join",
    "DeathAmt100",
    "UseCrucifix",
    "EncounterSpider",
    "SurviveHalt",
    "SurviveRush",
    "DeathAmt10",
    "Revive",
    "PlayFriend",
    "SurviveNest",
    "CrucifixFigure",
    "CrucifixAmbush",
    "PlayerBetrayal",
    "SurviveEyes",
    "KickGiggle",
    "EscapeMines",
    "GlowstickGiggle",
    "DeathAmt1",
    "SurviveSeek",
    "UseRiftMutate",
    "CrucifixGloombatSwarm",
    "SurviveScreech",
    "SurviveDread",
    "SurviveSeekMinesFirst",
    "CrucifixHalt",
    "TowerHeroesVoid",
    "JoinLSplash",
    "CrucifixDupe",
    "EncounterGlitch",
    "JeffShop",
    "CrucifixScreech",
    "SurviveGiggle",
    "EscapeHotelMod1",
    "SurviveDupe",
    "CrucifixRush",
    "EscapeBackdoorHunt",
    "EscapeHotel",
    "CrucifixGiggle",
    "EscapeFools",
    "UseRift",
    "SpecialQATester",
    "EscapeRetro",
    "TowerHeroesHard",
    "EnterBackdoor",
    "EscapeRooms1000",
    "EscapeRooms",
    "EscapeHotelMod2",
    "EncounterMobble",
    "CrucifixGrumble",
    "UseHerbGreen",
    "CrucifixSeek",
    "JeffTipFull",
    "SurviveFigureLibrary",
    "TowerHeroesHotel",
    "CrucifixEyes",
    "BreakerSpeedrun",
    "SurviveAmbush",
    "SurviveHide",
    "JoinAgain"
}

Script.RemotesFolder = shared.ReplicatedStorage:WaitForChild("RemotesFolder")
Script.CreateElevator = Script.RemotesFolder:WaitForChild("CreateElevator")

Script.MainUI = shared.PlayerGui:WaitForChild("MainUI")
Script.LobbyFrame = Script.MainUI:WaitForChild("LobbyFrame")
Script.AchievementsFrame = Script.LobbyFrame:WaitForChild("Achievements")
Script.CreateElevatorFrame = Script.LobbyFrame:WaitForChild("CreateElevator")

Script.LobbyElevators = workspace:WaitForChild("Lobby"):WaitForChild("LobbyElevators")

--// Functions \\--
function Script.Functions.SetupVariables()
    if wax.shared.ExecutorSupport["require"] then
        for achievementName, _ in pairs(wax.require(shared.ReplicatedStorage.Achievements)) do
            if table.find(Script.Achievements, achievementName) then continue end
    
            table.insert(Script.Achievements, achievementName)
        end
    else
        local badgeList = Script.AchievementsFrame:WaitForChild("List", math.huge)

        if badgeList then
            repeat task.wait(0.5) until #badgeList:GetChildren() ~= 0
            
            shared.Connect:GiveSignal(badgeList.ChildAdded:Connect(function(badge)
                if not badge:IsA("ImageButton") then return end
                if table.find(Script.Achievements, badge.Name) then return end
                table.insert(Script.Achievements, badge.Name)
            end))

            for _, badge in pairs(badgeList:GetChildren()) do
                if not badge:IsA("ImageButton") then continue end
                if table.find(Script.Achievements, badge.Name) then continue end

                table.insert(Script.Achievements, badge.Name)
            end
        end
    end
end

function Script.Functions.LoopAchievements()
    task.spawn(function()
        while Toggles.LoopAchievements.Value and not shared.Library.Unloaded do
            if Script.CurrentBadge >= #Script.Achievements then Script.CurrentBadge = 0 end
            Script.CurrentBadge += 1

            local random = Script.Achievements[Script.CurrentBadge]
            Script.RemotesFolder.FlexAchievement:FireServer(random)

            task.wait(Options.LoopAchievementsSpeed.Value)
        end
    end)
end

function Script.Functions.SetupCharacterConnection(newCharacter)
    shared.Character = newCharacter
    shared.Humanoid = shared.Character:FindFirstChildWhichIsA("Humanoid")
    shared.RootPart = shared.Character:FindFirstChild("HumanoidRootPart") or shared.Character.PrimaryPart

    if shared.Humanoid then
        shared.Twerk:Setup()
        if Toggles.Twerk.Value then
            shared.Twerk:Enable()
        end
    end
end

shared.Load("Utils", "Preset")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("Main")
}

shared.Load("Tabs", "Main")

--// Code \\--
task.spawn(Script.Functions.SetupVariables)
task.spawn(Script.Functions.LoadPresets)

task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))

getgenv().mspaint_loaded = true
end)() end,
    [10] = function()local wax,script,require=ImportGlobals(10)local ImportGlobals return (function(...)--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script

--// Player Variables \\--
shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()
shared.Humanoid = nil

--// Functions \\--
Script._mspaint_custom_captions = Instance.new("ScreenGui") do
    local Frame = Instance.new("Frame", Script._mspaint_custom_captions)
    local TextLabel = Instance.new("TextLabel", Frame)
    local UITextSizeConstraint = Instance.new("UITextSizeConstraint", TextLabel)

    Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    Script._mspaint_custom_captions.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = shared.Library.MainColor
    Frame.BorderColor3 = shared.Library.AccentColor
    Frame.BorderSizePixel = 2
    Frame.Position = UDim2.new(0.5, 0, 0.8, 0)
    Frame.Size = UDim2.new(0, 200, 0, 75)
    shared.Library:AddToRegistry(Frame, {
        BackgroundColor3 = "MainColor",
        BorderColor3 = "AccentColor"
    })

    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.Code
    TextLabel.Text = ""
    TextLabel.TextColor3 = shared.Library.FontColor
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true
    shared.Library:AddToRegistry(TextLabel, {
        TextColor3 = "FontColor"
    })

    UITextSizeConstraint.MaxTextSize = 35

    function Script.Functions.HideCaptions()
        Script._mspaint_custom_captions.Parent = shared.ReplicatedStorage
    end

    local CaptionsLastUsed = os.time()
    function Script.Functions.Captions(caption: string)
        CaptionsLastUsed = os.time()

        if Script._mspaint_custom_captions.Parent == shared.ReplicatedStorage then
            local success = pcall(function()
                Script._mspaint_custom_captions.Parent = if gethui then gethui() else shared.CoreGui
            end)

            if not success then
                Script._mspaint_custom_captions.Parent = shared.PlayerGui
            end 
        end
        
        TextLabel.Text = caption

        task.spawn(function()
            task.wait(5)
            if os.time() - CaptionsLastUsed >= 5 then
                Script.Functions.HideCaptions()
            end
        end)
    end
end

shared.Load("Utils", "ConnectionsFuncs")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("Main"),
}

shared.Load("Tabs", "Main")

--// Metamethod hooks \\--

--// Connections \\--
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))

--// Load \\--
task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)

--// Unload \\--
shared.Library:OnUnload(function()
    print("Unloading " .. shared.ScriptName .. "...")
end)

getgenv().mspaint_loaded = true
end)() end,
    [11] = function()local wax,script,require=ImportGlobals(11)local ImportGlobals return (function(...)--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script
Script.FeatureConnections = {
    Character = {},
    Humanoid = {},
    Player = {},
    RootPart = {},
}
Script.ESPTable = {
    Player = {},
    None = {}
}
Script.AimbotTween = nil

shared.Character = shared.LocalPlayer.Character or shared.LocalPlayer.CharacterAdded:Wait()
Script.GameName = "a roblox experience"

--// Functions \\--
function Script.Functions.UpdateBloxstrapRPC()
    if not wax.shared.BloxstrapRPC then return end

    wax.shared.BloxstrapRPC.SetRichPresence({
        details = "Playing " .. Script.GameName .. " [ mspaint v3 ]",
        state = #shared.Players:GetPlayers() .. " players in the server",
        largeImage = {
            hoverText = "Using mspaint v3"
        },
        smallImage = {
            assetId = 6925817108,
            hoverText = shared.LocalPlayer.Name
        }
    })
end


shared.Load("Utils", "Player")
shared.Load("Utils", "Assets")
shared.Load("Utils", "Aimbot")
shared.Load("Utils", "ESP")

shared.Load("Utils", "ConnectionsFuncs")

--// Tabs \\--
Script.Tabs = {
    Main = shared.Window:AddTab("Main"),
    Exploits = shared.Window:AddTab("Exploits"),
    Visuals = shared.Window:AddTab("Visuals")
}

shared.Load("Tabs", "Main")
shared.Load("Tabs", "Exploits")
shared.Load("Tabs", "Visuals")

--// Code \\--

--// Players Connection \\--
for _, player in pairs(shared.Players:GetPlayers()) do
    if player == shared.LocalPlayer then continue end
    Script.Functions.SetupOtherPlayerConnection(player)
end
shared.Connect:GiveSignal(shared.Players.PlayerAdded:Connect(Script.Functions.SetupOtherPlayerConnection))

--// Local Player Connection \\--
shared.Connect:GiveSignal(shared.LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    task.delay(1, Script.Functions.SetupCharacterConnection, newCharacter)
end))

shared.Connect:GiveSignal(shared.ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if Toggles.InstaInteract.Value then
        shared.fireproximityprompt(prompt)
    end
end))

--// Run Service \\--
shared.Connect:GiveSignal(shared.RunService.RenderStepped:Connect(function()
    if shared.Character then
        if shared.Humanoid then
            if Toggles.SpeedHack.Value then shared.Humanoid.WalkSpeed = Options.WalkSpeed.Value end
            if Toggles.JumpPowerHack.Value then shared.Humanoid.JumpPower = Options.JumpPower.Value end
        end

        if Toggles.Noclip.Value then
            for _, part in pairs(shared.Character:GetDescendants()) do
                if not part:IsA("BasePart") then continue end
                part.CanCollide = false
            end        
        end

        if Toggles.EnableAimbot.Value and (shared.Library.IsMobile or Options.EnableAimbotKey:GetState()) then
            local closest = nil
            if Options.AimbotClosestMethod.Value == "Mouse" then
                closest = Script.Functions.GetClosestFromMouse()
            elseif Options.AimbotClosestMethod.Value == "Character" then
                closest = Script.Functions.GetClosestFromCharacter()
            end

            if closest then
                if Toggles.AimbotSmooth.Value then
                    Script.AimbotTween = shared.TweenService:Create(shared.Camera, TweenInfo.new(Options.AimbotSmoothness.Value / 100, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                        CFrame = CFrame.new(shared.Camera.CFrame.Position, closest[Options.AimbotTargetPart.Value].Position)
                    })
                    Script.AimbotTween:Play()
                else
                    shared.Camera.CFrame = CFrame.new(shared.Camera.CFrame.Position, closest[Options.AimbotTargetPart.Value].Position)
                end
            end
        elseif Script.AimbotTween then
            Script.AimbotTween:Cancel()
            Script.AimbotTween = nil
        end
    end
end))

--// Load \\--
local success, gameName = pcall(function()
    return shared.MarketplaceService:GetProductInfo(game.PlaceId).Name
end)

if success then Script.GameName = gameName end
Script.Functions.UpdateBloxstrapRPC()

task.spawn(Script.Functions.SetupCharacterConnection, shared.Character)
task.spawn(Script.Functions.SetupChildConnection)
task.spawn(Script.Functions.SetupBloxstrapRPCConnection)

--// Unload \\--
shared.Library:OnUnload(function()
    if wax.shared.BloxstrapRPC then
        wax.shared.BloxstrapRPC.SetRichPresence({
            details = "<reset>",
            state = "<reset>",
            largeImage = {
                reset = true
            },
            smallImage = {
                reset = true
            }
        })
    end

    for _, espType in pairs(Script.ESPTable) do
        for _, esp in pairs(espType) do
            esp.Destroy()
        end
    end

    for _, object in pairs(workspace:GetDescendants()) do
        if object:IsA("BasePart") then
            if not object:GetAttribute("Material") then object:SetAttribute("Material", object.Material) end
            if not object:GetAttribute("Reflectance") then object:SetAttribute("Reflectance", object.Reflectance) end

            object.Material = object:GetAttribute("Material")
            object.Reflectance = object:GetAttribute("Reflectance")
        elseif object:IsA("Decal") then
            if not object:GetAttribute("Transparency") then object:SetAttribute("Transparency", object.Transparency) end
            
            object.Transparency = object:GetAttribute("Transparency")
        end
    end

    workspace.Terrain.WaterReflectance = 1
    workspace.Terrain.WaterTransparency = 1
    workspace.Terrain.WaterWaveSize = 0.05
    workspace.Terrain.WaterWaveSpeed = 8
    shared.Lighting.GlobalShadows = true

    shared.Twerk:Disable()
end)

getgenv().mspaint_loaded = true
end)() end,
    [14] = function()local wax,script,require=ImportGlobals(14)local ImportGlobals return (function(...)--// Linoria \\--
local Toggles = shared.Toggles
local Options = shared.Options

--// Variables \\--
local Script = shared.Script
local Tabs = Script.Tabs

--// Exploits \\--
local TrollingGroupBox = Tabs.Exploits:AddLeftGroupbox("Trolling") do
    TrollingGroupBox:AddToggle("ThrowPowerBoost",{
        Text = "Throw Power Boost",
        Default = false,
        Visible = wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"],
    })

    TrollingGroupBox:AddSlider("ThrowPower", {
        Text = "Throw Power",
        Default = 10,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Compact = true,
        Visible = wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"],
    })

    TrollingGroupBox:AddToggle("DeleteObject", {
        Text = "FE Delete Object",
        Default = false,
        Visible = wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"],
    })

    TrollingGroupBox:AddToggle("Twerk",{
        Text = "Twerk",
        Default = false,
    })

    TrollingGroupBox:AddDivider()

    TrollingGroupBox:AddToggle("DeleteAura", {
        Text = "FE Delete Aura",
        Default = false,
        Risky = true,
        Tooltip = "Delete objects within a certain range of your character, this can kick you from the game and i'm too lazy to fix it."
    })

    TrollingGroupBox:AddSlider("DeleteAuraRange", {
        Text = "Delete Aura Range",
        Default = 15,
        Min = 1,
        Max = 30,
        Rounding = 1,
        Compact = true
    })
end

local BypassGroupBox = Tabs.Exploits:AddRightGroupbox("Bypass") do
    BypassGroupBox:AddToggle("Godmode", {
        Text = "Godmode",
        Default = false
    })

    BypassGroupBox:AddToggle("InfiniteHunger", {
        Text = "Disable Hunger",
        Default = false,
        Tooltip = "You will never get hungry, incompatible with Godmode."
    })

    BypassGroupBox:AddToggle("InfiniteEnergy", {
        Text = "Infinite Energy",
        Default = false,
        Tooltip = "You will never get tired, incompatible with Godmode."
    })

    BypassGroupBox:AddToggle("InfiniteInventory", {
        Text = "Infinite Inventory",
        Default = false,
        Visible = wax.shared.ExecutorSupport["require"] and wax.shared.ExecutorSupport["hookmetamethod"] and wax.shared.ExecutorSupport["getnamecallmethod"],
    })
end

Toggles.Godmode:OnChanged(function(value)
    if value then
        Script.DidGodmode = true

        repeat task.wait() until #Script.Map.Floor:GetChildren() > 0

        Script.Event:FireServer("FallDamage", {
            Sliding = false,
            OriginalDamage = (0/0),
            Sound = "LR^SS",
            Softened = true,
            Broken = false,
            Model = Script.Map.Floor:FindFirstChildOfClass("Model"),
            Range = 19,
            Damage = (0/0)
        })

    else
        if not Script.DidGodmode then return end
        Script.DidGodmode = false

        Script.Functions.Respawn()
    end
end)

Toggles.InfiniteHunger:OnChanged(function(value)
    if value and not Toggles.Godmode.Value then
        Script.Event:FireServer("DecreaseStat", {
            Stats = {
                Hunger = -100
            }
        })
    end
end)

Toggles.InfiniteEnergy:OnChanged(function(value)
    if value and not Toggles.Godmode.Value then
        Script.Event:FireServer("DecreaseStat", {
            Stats = {
                Energy = -100
            }
        })
    end
end)

local DeleteAuraParams = OverlapParams.new()
DeleteAuraParams.FilterType = Enum.RaycastFilterType.Exclude
DeleteAuraParams.FilterDescendantsInstances = {shared.Character, shared.Camera}

Toggles.DeleteAura:OnChanged(function(value)
    if value then
        repeat task.wait(0.15)
            local CloseParts = workspace:GetPartBoundsInBox(shared.RootPart.CFrame, Vector3.new(Options.DeleteAuraRange.Value, Options.DeleteAuraRange.Value, Options.DeleteAuraRange.Value), DeleteAuraParams)
            
            for _, part in pairs(CloseParts) do 
                local targetFurniture = part:FindFirstAncestorOfClass("Model") or part.Parent
                if shared.Players:GetPlayerFromCharacter(targetFurniture) then continue end

                if targetFurniture and targetFurniture:IsA("Model") and targetFurniture.PrimaryPart then
                    local isClose = shared.Character and Script.Functions.DistanceFromCharacter(part) <= 9
                    local isAbleToPickup = not targetFurniture:GetAttribute("Busy")
                    
                    if not isClose or not isAbleToPickup then continue end

                    Script.Action:InvokeServer("Pickup", {["Model"] = targetFurniture})
                    
                    Script.Action:InvokeServer("Drop", {
                        EndCFrame = CFrame.new(shared.RootPart.Position + Vector3.new(
                            math.random(1, 5),
                            math.random(5, 8),
                            math.random(1, 5)
                        )),

                        CameraCFrame = Vector3.new(0.9865860342979431, 0.16270768642425537, -0.013206666335463524) * 250,
                        ThrowPower = 555,
                        Throw = true
                    })
                end
 …"
 https://raw.githubusercontent.com/XiaoXuAnZang/XKscript/refs/heads/main/DOORS.txt#:~:text=local%20OrionLib%20%3D%20loadstring,print(%22Re%2DCoded%22)

-- ===== End Extracted Block =====

Library:Notify('已加载 Doors_Linoria_Full.lua（提取版）。如果有缺少模块或错误，请把错误贴给我）。',5)
