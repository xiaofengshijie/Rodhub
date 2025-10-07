local everyClipboard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
function Lib()
local library = {}
local libalive = true
local holdingmouse = false

-- 17,856 pastebin views
-- as of 1/29/2023 @ 6:30 CST

local plr = game:GetService("Players").LocalPlayer
local mouse = plr:GetMouse()
local runs = game:GetService("RunService")
local us = game:GetService("UserInputService")
local screengui = Instance.new("ScreenGui",game.CoreGui)
local windowsopened = 0

local elementsize = 24

local font = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.Regular,
    Enum.FontStyle.Normal 
    )
    
local titlefont = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.Bold,
    Enum.FontStyle.Normal 
    )
    
local medfont = Font.new(
    "rbxassetid://11702779517",
    Enum.FontWeight.Medium,
    Enum.FontStyle.Normal 
    )

us.InputBegan:Connect(function(key,pro)
    if key.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingmouse = true 
    end
end)

us.InputEnded:Connect(function(key,pro)
    if key.UserInputType == Enum.UserInputType.MouseButton1 then
        holdingmouse = false 
    end
end)

function draggable(obj) -- https://devforum.roblox.com/t/draggable-property-is-hidden-on-gui-objects/107689/4
    local UserInputService = game:GetService("UserInputService")
    local gui = obj

    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
    	local delta = input.Position - dragStart
    	gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    gui.InputBegan:Connect(function(input)
    	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    		dragging = true
    		dragStart = input.Position
    		startPos = gui.Position
    		
    		input.Changed:Connect(function()
    			if input.UserInputState == Enum.UserInputState.End then
    				dragging = false
    			end
    		end)
    	end
    end)
    
    gui.InputChanged:Connect(function(input)
    	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
    		dragInput = input
    	end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
    	if input == dragInput and dragging then
    		update(input)
    	end
    end) 
end

function hovercolor(b,idle,hover,clicked,included)
    local hovering = false
    local holding = false
    
    b.MouseEnter:Connect(function()
        hovering = true
    end)
    
    b.MouseLeave:Connect(function()
        hovering = false
    end)
    
    b.MouseButton1Down:Connect(function()
        holding = true
    end)
    
    b.MouseButton1Up:Connect(function()
        holding = false
    end)
    
    if included and typeof(included) == "table" and #included > 0 then
        for i,v in pairs(included) do
            b.Changed:Connect(function()
                v.BackgroundColor3 = b.BackgroundColor3
            end) 
        end
    end
    
    runs.RenderStepped:Connect(function()
        if hovering then
            if holding then
                b.BackgroundColor3 = clicked
            else
                b.BackgroundColor3 = hover
            end
        else
            b.BackgroundColor3 = idle
        end
    end)
end

library.window = function(text)
    local windowalive = true
    local frame = Instance.new("TextLabel",screengui)
    frame.Position = UDim2.new(0.016+windowsopened/12,0,0.009,0)
    frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
    --frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BorderSizePixel = 0
    --frame.Active = true
    --frame.Draggable = true
    local list = Instance.new("UIListLayout",frame)
    list.HorizontalAlignment = "Center"
    list.Padding = UDim.new(0,3)
    list.SortOrder = Enum.SortOrder.LayoutOrder
	draggable(frame)
    
	windowsopened = windowsopened + 1
    
    local header = Instance.new("Frame",frame)
    header.BackgroundColor3 = Color3.fromRGB(55,55,60)
    header.Size = UDim2.new(1,0,0,32)
    header.BorderSizePixel = 0
    
    local separator = Instance.new("Frame",header)
    separator.BackgroundColor3 = Color3.fromRGB(55,55,60)
    separator.Size = UDim2.new(1,0,0.4,0)
    separator.Position = UDim2.new(0,0,0.6,0)
    separator.BorderSizePixel = 0
    
    Instance.new("UICorner",frame)
    Instance.new("UICorner",header)
    
    local title = Instance.new("TextLabel",header)
    title.TextScaled = true
    title.Text = tostring(text)
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Size = UDim2.new(1,0,1,0)
    title.FontFace = titlefont
    title.BorderSizePixel = 0
    title.BackgroundTransparency = 1
    
    frame.Size = UDim2.new(0.08,0,0.0335,0)
    local gui = {}

    local elements = 0
    gui.label = function(text,extrasize)
        extrasize = extrasize or 0
        
        local b = Instance.new("TextLabel",frame)
        b.LayoutOrder = 0
        b.TextScaled = true
        b.BackgroundTransparency = 1
        b.Text = tostring(text)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Size = UDim2.new(0.96,0,0,elementsize+extrasize)
        b.FontFace = font
        b.BorderSizePixel = 0
        
        elements = elements + 1
        frame.Size = frame.Size + UDim2.new(0,0,0,elementsize+3+extrasize)
        
        local subgui = {}
        
        subgui.changetext = function(txt)
            b.Text = tostring(txt)
        end
        
        return subgui
    end
    gui.copy = function(text,extrasize)
        extrasize = extrasize or 0
        local b = Instance.new("TextButton",frame)
        b.LayoutOrder = 0
        b.TextScaled = true
        b.BackgroundColor3 = Color3.fromRGB(35,35,40)
        b.Text = tostring(text)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Size = UDim2.new(0.96,0,0,elementsize+extrasize)
        b.FontFace = font
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 10
        elements = elements + 1
        frame.Size = frame.Size + UDim2.new(0,0,0,elementsize+3+extrasize)
        
        local subgui = {}
        b.MouseButton1Down:Connect(function()
        if everyClipboard and b.Text == tostring(text) then
            everyClipboard("UID:3546671562623445")
            b.Text = "Copyed!"
            task.wait(1)
            b.Text = tostring(text)
            end
        end)
        subgui.changetext = function(txt)
            b.Text = tostring(txt)
        end
        return subgui
    end
    
    gui.button = function(text,onclick)
        local el = Instance.new("Frame",frame)
        el.LayoutOrder = 0
        el.Size = UDim2.new(0.96,0,0,elementsize)
        el.BorderSizePixel = 0
        el.BackgroundTransparency = 1
        
        local b = Instance.new("TextButton",el)
        b.LayoutOrder = 0
        b.TextScaled = true
        b.BackgroundColor3 = Color3.fromRGB(35,35,40)
        b.Text = tostring(text)
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Size = UDim2.new(1,0,1,0)
        b.FontFace = font
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 10
        
        local top = Instance.new("Frame",el)
        top.Size = UDim2.new(1,0,0.4,0)
        top.Position = UDim2.new(0,0,0,0)
        top.BorderSizePixel = 0
        
        local bot = Instance.new("Frame",el)
        bot.Size = UDim2.new(1,0,0.4,0)
        bot.Position = UDim2.new(0,0,0.6,0)
        bot.BorderSizePixel = 0
        
        local thiselement = elements+1
        hovercolor(b,Color3.fromRGB(35,35,40),Color3.fromRGB(45,45,50),Color3.fromRGB(25,25,30),{top,bot})
        elements = elements + 1
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,5)
        
        spawn(function()
            while b do
                bot.Visible = (elements>thiselement)
                task.wait() 
            end
        end)
        
        frame.Size = frame.Size + UDim2.new(0,0,0,elementsize+3)
        b.MouseButton1Down:Connect(onclick)
    end
    
    gui.toggle = function(text,default,onclick)
        local enabled = default or false
        local el = Instance.new("Frame",frame)
        el.LayoutOrder = 0
        el.Size = UDim2.new(0.96,0,0,elementsize)
        el.BorderSizePixel = 0
        el.BackgroundTransparency = 1
        
        local b = Instance.new("TextButton",el)
        b.LayoutOrder = 0
        b.TextScaled = true
        b.BackgroundColor3 = Color3.fromRGB(35,35,40)
        b.Text = tostring(text)
        b.TextColor3 = enabled and Color3.new(0,1,0) or Color3.new(1,0,0)
        b.Size = UDim2.new(1,0,1,0)
        b.FontFace = font
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 10
        
        local top = Instance.new("Frame",el)
        top.Size = UDim2.new(1,0,0.4,0)
        top.Position = UDim2.new(0,0,0,0)
        top.BorderSizePixel = 0
        
        local bot = Instance.new("Frame",el)
        bot.Size = UDim2.new(1,0,0.4,0)
        bot.Position = UDim2.new(0,0,0.6,0)
        bot.BorderSizePixel = 0
        
        local thiselement = elements+1
        hovercolor(b,Color3.fromRGB(35,35,40),Color3.fromRGB(45,45,50),Color3.fromRGB(25,25,30),{top,bot})
        elements = elements + 1
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,5)
        
        spawn(function()
            while b do
                bot.Visible = (elements>thiselement)
                task.wait() 
            end
        end)
        
        frame.Size = frame.Size + UDim2.new(0,0,0,elementsize+3)
        b.MouseButton1Down:Connect(function()
            enabled = not enabled
            b.TextColor3 = enabled and Color3.new(0,1,0) or Color3.new(1,0,0)
            onclick(enabled)
        end)
        
        local subgui = {}
        
        subgui.set = function(bool)
            enabled = bool
            b.TextColor3 = enabled and Color3.new(0,1,0) or Color3.new(1,0,0)
            onclick(enabled)
        end
        
        return subgui
    end
    
    gui.textbox = function(text,unfocused)
        local el = Instance.new("Frame",frame)
        el.LayoutOrder = 0
        el.Size = UDim2.new(0.96,0,0,elementsize)
        el.BorderSizePixel = 0
        el.BackgroundTransparency = 1
        
        local b = Instance.new("TextBox",el)
        b.LayoutOrder = 0
        b.TextScaled = true
        b.BackgroundColor3 = Color3.fromRGB(35,35,40)
        b.PlaceholderText = tostring(text)
        b.PlaceholderColor3 = Color3.fromRGB(80,80,80)
        b.Text = ""
        b.TextColor3 = Color3.fromRGB(125,200,255)
        b.Size = UDim2.new(1,0,1,0)
        b.FontFace = font
        b.BorderSizePixel = 0
        b.ZIndex = 10
        
        local top = Instance.new("Frame",el)
        top.Size = UDim2.new(1,0,0.4,0)
        top.Position = UDim2.new(0,0,0,0)
        top.BorderSizePixel = 0
        top.BackgroundColor3 = b.BackgroundColor3
        
        local bot = Instance.new("Frame",el)
        bot.Size = UDim2.new(1,0,0.4,0)
        bot.Position = UDim2.new(0,0,0.6,0)
        bot.BorderSizePixel = 0
        bot.BackgroundColor3 = b.BackgroundColor3
        
        local thiselement = elements+1
        elements = elements + 1
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,5)
        
        task.spawn(function()
            while b do
                bot.Visible = (elements>thiselement)
                task.wait() 
            end
        end)

        frame.Size = frame.Size + UDim2.new(0,0,0,elementsize+3)
        b.FocusLost:Connect(function()
            unfocused(b.Text) 
        end)

		local subgui = {}
        
        subgui.text = function()
            return b.Text 
        end
        
        subgui.changetext = function(newtext)
            b.Text = newtext
        end
        
        return subgui
    end
    
    local coldropdown = nil
    gui.dropdown = function(text,contents)
        local el = Instance.new("Frame",frame)
        el.LayoutOrder = 0
        el.Size = UDim2.new(0.96,0,0,elementsize)
        el.BorderSizePixel = 0
        el.BackgroundTransparency = 1
        el.ZIndex = 2
        
        local b = Instance.new("TextButton",el)
        b.LayoutOrder = 0
        b.TextScaled = true
        b.BackgroundColor3 = Color3.fromRGB(35,35,40)
        b.Text = tostring(text) .." >"
        b.TextColor3 = Color3.fromRGB(255,255,255)
        b.Size = UDim2.new(1,0,1,0)
        b.FontFace = font
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.ZIndex = 2
        local d = Instance.new("Frame",b)
        d.AnchorPoint = Vector2.new(0.5,0)
        d.Position = UDim2.new(0.5,0,0.72,0)
        d.Size = UDim2.new(1.04,0,0,9)
        d.BackgroundColor3 = Color3.fromRGB(15,15,20)
        d.AutomaticSize = Enum.AutomaticSize.Y
        d.BorderSizePixel = 0
        d.Visible = false
        d.ZIndex = 2
        local dlist = Instance.new("UIListLayout",d)
        dlist.HorizontalAlignment = "Center"
        dlist.Padding = UDim.new(0,3)
        dlist.SortOrder = Enum.SortOrder.LayoutOrder
        
        local separator = Instance.new("Frame",d)
        separator.BackgroundTransparency = 1
        separator.Size = UDim2.new(1,0,0,6)
        
        local top = Instance.new("Frame",el)
        top.Size = UDim2.new(1,0,0.4,0)
        top.Position = UDim2.new(0,0,0,0)
        top.BorderSizePixel = 0
        
        local bot = Instance.new("Frame",el)
        bot.Size = UDim2.new(1,0,0.4,0)
        bot.Position = UDim2.new(0,0,0.6,0)
        bot.BorderSizePixel = 0
        
        local thiselement = elements+1
        hovercolor(b,Color3.fromRGB(35,35,40),Color3.fromRGB(45,45,50),Color3.fromRGB(25,25,30),{top,bot})
        elements = elements + 1
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,5)
        Instance.new("UICorner",d)
        
        spawn(function()
            while b do
                bot.Visible = (elements>thiselement)
                task.wait() 
            end
        end)
        
        frame.Size = frame.Size + UDim2.new(0,0,0,elementsize+3)
        
        local search = ""
        local selected = nil
        local function addcontent(name)
            if typeof(name) == "Instance" then
                name = name.Name 
            end
            
            local e = Instance.new("TextButton",d)
            e.LayoutOrder = 0
            e.TextScaled = true
            e.BackgroundColor3 = Color3.fromRGB(75,75,80)
            e.Text = tostring(name)
            e.TextColor3 = Color3.fromRGB(255,255,255)
            e.Size = UDim2.new(0.96,0,0,elementsize)
            e.FontFace = font
            e.BorderSizePixel = 0
            e.Name = name
            e.ZIndex = 35-elements
            
            Instance.new("UICorner",e)
            d.Size = d.Size + UDim2.new(0,0,0,25)
            
            e.MouseButton1Down:Connect(function()
                d.Visible = false
                b.ZIndex = 2
                b.Text = tostring(name).." >"
                b.TextColor3 = Color3.fromRGB(200,255,200)
                selected = name
            end)
            
            spawn(function()
                while task.wait() do
                    local s = search:lower()
                    
                    if s ~= "" then
                        if tostring(name):lower():find(s) then
                            e.Visible = true
                        else
                            e.Visible = false
                        end
                    else
                        e.Visible = true
                    end
                end
            end)
        end
        
        for i,v in pairs(contents) do
            addcontent(v) 
        end
        
        b.MouseButton1Down:Connect(function()
            d.Visible = not d.Visible 
            el.ZIndex = d.Visible and 10 or 12
            b.ZIndex = d.Visible and 22 or 10
            coldropdown = d.Visible and el or nil
            
            if not selected then
                b.Text = d.Visible and tostring(text).." <" or tostring(text).." >"
            else
                b.Text = d.Visible and tostring(selected).." <" or tostring(selected).." >"
            end
            
            repeat task.wait() until coldropdown ~= el
            
            d.Visible = false
            el.ZIndex = d.Visible and 10 or 12
            b.ZIndex = d.Visible and 22 or 10
        end)
        
        local subgui = {}
        
        subgui.get = function()
            return selected
        end
        
        subgui.add = function(txt)
            addcontent(txt) 
        end
        
        subgui.search = function(txt)
            search = tostring(txt)
            
            d.Size = UDim2.new(1.04,0,0,0)
            task.wait()
            local items = 0
            for i,v in pairs(d:GetChildren()) do
                if v:IsA("TextButton") and v.Visible then
                    i = i + 1
                    d.Size = d.Size + UDim2.new(0,0,0,25)
                end
            end
        end
        
        subgui.delete = function(txt)
            if d:FindFirstChild(txt) then
                d:FindFirstChild(txt):Destroy()
                d.Size = d.Size - UDim2.new(0,0,0,25)
                
                if selected == txt then
                    b.TextColor3 = Color3.fromRGB(255,255,255)
                    b.Text = tostring(text).." >"
                    selected = nil
                end
            end
        end
        
        subgui.clear = function()
            for i,v in pairs(d:GetChildren()) do
                if v:IsA("TextButton") then
                    v:Destroy() 
                    d.Size = d.Size - UDim2.new(0,0,0,25)
                end
            end
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.Text = tostring(text).." >"
            selected = nil
        end
        
        return subgui
    end

    gui.slider = function(text,min,max,roundto,default,onchange)
        local el = Instance.new("Frame",frame)
        el.LayoutOrder = 0
        el.Size = UDim2.new(0.96,0,0,elementsize+5)
        el.BorderSizePixel = 0
        el.BackgroundTransparency = 1
        
        local b = Instance.new("Frame",el)
        b.LayoutOrder = 0
        b.BackgroundColor3 = Color3.fromRGB(35,35,40)
        b.Size = UDim2.new(1,0,1,0)
        b.BorderSizePixel = 0
        b.ZIndex = 10
        
        local txtholder = Instance.new("TextLabel",b)
        txtholder.TextScaled = true
        txtholder.BackgroundColor3 = Color3.fromRGB(35,35,40)
        txtholder.Text = tostring(text).." [".. tostring(default).."]"
        txtholder.TextColor3 = Color3.fromRGB(255,255,255)
        txtholder.Size = UDim2.new(1,0,0.7,0)
        txtholder.FontFace = medfont
        txtholder.BorderSizePixel = 0
        txtholder.ZIndex = 10
        
        local slidepart = Instance.new("Frame",b)
        slidepart.BackgroundColor3 = Color3.fromRGB(255,255,255)
        slidepart.Size = UDim2.new(0.9,0,0.05,0)
        slidepart.Position = UDim2.new(0.05,0,0.8,0)
        slidepart.BorderSizePixel = 0
        slidepart.ZIndex = 10
        
        local slideball = Instance.new("ImageLabel",slidepart)
        slideball.AnchorPoint = Vector2.new(0.5,0.5)
        slideball.BackgroundTransparency = 1
        slideball.Size = UDim2.new(0.055,0,5,0)
        slideball.Position = UDim2.new(0,0,0.5,0)
        slideball.Image = "rbxassetid://6755657357"
        slideball.BorderSizePixel = 0
        slideball.ZIndex = 12
        
        local button = Instance.new("TextButton",b)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Size = UDim2.new(1,0,1,0)
        button.ZIndex = 35
        
        local top = Instance.new("Frame",el)
        top.Size = UDim2.new(1,0,0.4,0)
        top.Position = UDim2.new(0,0,0,0)
        top.BorderSizePixel = 0
        top.BackgroundColor3 = b.BackgroundColor3
        
        local bot = Instance.new("Frame",el)
        bot.Size = UDim2.new(1,0,0.4,0)
        bot.Position = UDim2.new(0,0,0.6,0)
        bot.BorderSizePixel = 0
        bot.BackgroundColor3 = b.BackgroundColor3
        
        local thiselement = elements+1
        elements = elements + 1
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,5)
        
        task.spawn(function()
            while b do
                bot.Visible = (elements>thiselement)
                task.wait() 
            end
        end)
        
        local slidervalue
        local function setslider(value)
            local trueval = math.floor(value/roundto)*roundto
            local norm = (trueval-min)/(max-min)
            slideball.Position = UDim2.new(norm,0,0.5,0)
            txtholder.Text = tostring(text).." [".. tostring(math.floor(trueval*100)/100).."]"
        
            slidervalue = trueval
            onchange(trueval)
        end
        
        local holding = false
        button.MouseButton1Down:Connect(function()
            holdingmouse = true
            
            task.spawn(function()
                while holdingmouse and windowalive and libalive do
                    local abpos = slidepart.AbsolutePosition
                    local absize = slidepart.AbsoluteSize
                    local x = mouse.X
                    
                    local p = math.clamp((x-abpos.X)/(absize.X),0,1)
                    local value = p*max+(1-p)*min
                    
                    setslider(value)
                    task.wait() 
                end 
            end)
        end)
        
        button.MouseButton1Up:Connect(function()
            holding = false
            holdingmouse = false
        end)
        game:GetService("UserInputService").TouchEnded:Connect(function()
            if holdingmouse or holding then
                holding = false
                holdingmouse = false
            end
        end)
        frame.Size = frame.Size + UDim2.new(0,0,0,elementsize+3+5)
        setslider(default)
        
        local subgui = {}
        
        subgui.get = function(val)
            return slidervalue
        end
        
        subgui.setvalue = function(val)
            setslider(val)
        end
        
        subgui.setmin = function(val)
            min = val
            setslider(slidervalue)
        end
        
        subgui.setmax = function(val)
            max = val
            setslider(slidervalue)
        end
        
        return subgui
    end

    gui.hide = function()
        frame.Visible = false
    end
    
    gui.show = function()
        frame.Visible = true 
    end

    gui.delete = function()
        windowalive = false
        gui:Destroy() 
    end

    return gui
end

library.delete = function()
    libalive = false
	screengui:Destroy()
end

return library
end
function randomstring()
local a = math.random(10,40)
local args = {}
    for i=1,a do
        args[i] = string.char(math.random(16,128))
    end
    return table.concat(args)
end
local library = Lib()
local originalNC
function message(text)
    local msg = Instance.new("Message",workspace)
    msg.Text = tostring(text)
    task.wait(2)
    msg:Destroy()
end
function message2(text)
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Notify";
	Text = tostring(text);
	Icon = "";
	Duration = 4;
})
end
local function printerror(error)
    print("error print: "..tostring(error))
end
local esptable = {zombies={},runner={},barrel={},sapper={},shambler={},players={},Igniter={},friends={}}
local Folder = Instance.new("Folder", game:GetService("Workspace"))
Folder.Name = randomstring()
local speed = Instance.new("NumberValue",Folder)
speed.Name = randomstring()
speed.Value = 16.2
function textesp(color,core,name,offset)
local bill
if core and name then
        bill = Instance.new("BillboardGui",game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0,400,0,100)
        bill.Adornee = core
        bill.MaxDistance = 2000
        
        local mid = Instance.new("Frame",bill)
        mid.AnchorPoint = Vector2.new(0.5,0.5)
        mid.BackgroundColor3 = color
        mid.Size = UDim2.new(0,8,0,8)
        mid.Position = UDim2.new(0.5+offset,0,0.5+offset,0)
        Instance.new("UICorner",mid).CornerRadius = UDim.new(1,0)
        Instance.new("UIStroke",mid)
        
        local txt = Instance.new("TextLabel",bill)
        txt.AnchorPoint = Vector2.new(0.5,0.5)
        txt.BackgroundTransparency = 1
        txt.BackgroundColor3 = color
        txt.TextColor3 = color
        txt.Size = UDim2.new(1,0,0,20)
        txt.Position = UDim2.new(0.5,0,0.7,0)
        txt.Text = name
        Instance.new("UIStroke",txt)
        
        task.spawn(function()
            while bill do
                if bill.Adornee == nil or not bill.Adornee:IsDescendantOf(workspace) then
                    bill.Enabled = false
                    bill.Adornee = nil
                    bill:Destroy() 
                end  
                task.wait()
            end
        end)
    end
    
    local ret = {}
    
    ret.delete = function()
        
        if bill then
            bill.Enabled = false
            bill.Adornee = nil
            bill:Destroy() 
        end
    end
    
    return ret
end
function esp(what, color, core, name, offset)
    local parts
    
    if typeof(what) == "Instance" then
        if what:IsA("Model") then
            parts = what:GetChildren()
        elseif what:IsA("BasePart") then
            parts = {what, table.unpack(what:GetChildren())}
        end
    elseif typeof(what) == "table" then
        parts = what
    end
    
    local bill
    local boxes = {}
    
    for i, v in pairs(parts) do
        if v:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Size
            box.AlwaysOnTop = true
            box.ZIndex = 1
            box.AdornCullingMode = Enum.AdornCullingMode.Never
            box.Color3 = color
            box.Transparency = 0.8
            box.Adornee = v
            box.Parent = game.CoreGui
            
            table.insert(boxes, box)
            
            -- 使用事件监听替代循环检查
            local connection
            connection = v.AncestryChanged:Connect(function()
                if not v:IsDescendantOf(workspace) then
                    box.Adornee = nil
                    box.Visible = false
                    box:Destroy()
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end
    end

    if core and name then
        bill = Instance.new("BillboardGui", game.CoreGui)
        bill.AlwaysOnTop = true
        bill.Size = UDim2.new(0, 400, 0, 100)
        bill.Adornee = core
        bill.MaxDistance = 2000
        
        local mid = Instance.new("Frame", bill)
        mid.AnchorPoint = Vector2.new(0.5, 0.5)
        mid.BackgroundColor3 = color
        mid.Size = UDim2.new(0, 8, 0, 8)
        mid.Position = UDim2.new(0.5 + offset, 0, 0.5 + offset, 0)
        Instance.new("UICorner", mid).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", mid)
        
        local txt = Instance.new("TextLabel", bill)
        txt.AnchorPoint = Vector2.new(0.5, 0.5)
        txt.BackgroundTransparency = 1
        txt.BackgroundColor3 = color
        txt.TextColor3 = color
        txt.Size = UDim2.new(1, 0, 0, 20)
        txt.Position = UDim2.new(0.5, 0, 0.7, 0)
        txt.Text = name
        Instance.new("UIStroke", txt)
        
        -- 使用事件监听替代循环检查
        local connection
        connection = core.AncestryChanged:Connect(function()
            if not core:IsDescendantOf(workspace) then
                bill.Enabled = false
                bill.Adornee = nil
                bill:Destroy()
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
    
    local ret = {}
    
    ret.delete = function()
        for i, v in pairs(boxes) do
            v.Adornee = nil
            v.Visible = false
            v:Destroy()
        end
        
        if bill then
            bill.Enabled = false
            bill.Adornee = nil
            bill:Destroy() 
        end
    end
    
    return ret 
end
if not hookmetamethod then
if not hookmetamethod then
library.delete()
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Notification";
	Text = "Missing hookmetamethod";
	Icon = "";
	Duration = 4;
})
else
    library.delete()
    game:GetService("StarterGui"):SetCore("SendNotification", {
    	Title = "Notification";
    	Text = "e";
    	Icon = "";
    	Duration = 4;
    })
end
return
end
local plr = game:GetService("Players").LocalPlayer
local char
local connect
connect = plr.CharacterAdded:Connect(function(c)
char = c
end)
local flags = {
    esp = false,
    doors = false,
    hide_open = false,
    Lookman = false,
    loopspeed = false,
    key_esp = false
}
local esptable = {Doors={},Lookmans={},WardrobeDoors={},keys={}}

local windos_main = library.window("主要功能")
local windos_esp = library.window("esp功能")

windos_main.button("显示/隐藏", function()   
    if flags.hide_open then
        windos_esp.show()
        flags.hide_open = false
    else
        windos_esp.hide()
        flags.hide_open = true
    end
end)

windos_esp.toggle("Doors", false, function(val)
    flags.Doors = val  -- 这里应该是赋值给flags，而不是从flags读取
    if val then
        local CurrentRooms = workspace:WaitForChild("CurrentRooms")  -- 移除了多余的"workspace."
        local function door(v)
            if v:IsA("Model") then  -- 修正了 IsA 的大小写
                local root = v:WaitForChild("Door")
                task.wait()
                local h = esp(v, Color3.fromRGB(255, 128, 0), root, v.Name, 0.0)
                table.insert(esptable.Doors, h)
            end
        end

        local addconnect = CurrentRooms.ChildAdded:Connect(function(s)
            local dog = s:WaitForChild("Door")
            door(dog)
        end)
        
        for i, v in pairs(CurrentRooms:GetChildren()) do
            local dog = v:WaitForChild("Door")
            door(dog)
        end
        
        repeat task.wait() until not flags.Doors  -- 修正了变量名
        
        addconnect:Disconnect()   
        for i, v in pairs(esptable.Doors) do
            v.delete()
        end
    end
end)
windos_esp.toggle("Lookman", false, function(val)  -- 添加了缺失的逗号
    flags.Lookman = val
    if val then
        local function Lookman(v)
            if v:IsA("Model") then
                local h = esp(v, Color3.fromRGB(0, 128, 0), v, v.Name, 0.0)
                table.insert(esptable.Lookmans, h)  -- 需要将ESP实例存入表格
            end
        end
        
        local addconnect = workspace.ChildAdded:Connect(function(s)
            Lookman(s)
        end)
        
        for i, v in pairs(workspace:GetChildren()) do
            Lookman(v)
        end
        
        repeat task.wait() until not flags.Lookman
        
        addconnect:Disconnect()   
        for i, v in pairs(esptable.Lookmans) do
            v.delete()
        end
    end
end)
windos_esp.toggle("Wardrobe_Hidden_Doors", false, function(val)
    flags.wardrobe_hide_door = val
    if val then
        local CurrentRooms = workspace.CurrentRooms
        local function addedroom(room)
            local assets = room:FindFirstChild("Assets")
            if assets == nil then
                return
            end
            for i,v in pairs(assets:GetChildren()) do
                if v.Name == "Wardrobe" then
                    local h = esp(v, Color3.fromRGB(45,0,45), v, v.Name, 0.0)
                    table.insert(esptable.WardrobeDoors, h)
                end
            end
        end
        local addconnect = CurrentRooms.ChildAdded:Connect(function(s)
            wait(0.5)
            addedroom(s)
        end)
        for i,v in pairs(CurrentRooms:GetChildren()) do
            addedroom(v)
        end
        repeat task.wait() until not flags.wardrobe_hide_door
        addconnect:Disconnect()   
        for i, v in pairs(esptable.WardrobeDoors) do
            v.delete()
        end
    end
end)
windos_main.toggle("ESP_Key", false, function(val)
    flags.key_esp = val
    if val then
        local CurrentRooms = workspace:WaitForChild("CurrentRooms")

        local function keys(room)
            print("began")
            local assets = room:FindFirstChild("Assets")
            if assets == nil then
                print("aa")
                return
            end
            local Alternate = assets:FindFirstChild("Alternate")
            if Alternate == nil then
                print("bb")
                return
            end
            print("need")
            for i, v in pairs(Alternate:GetDescendants()) do
                if v.Name == "KeyHitbox" then
                    print("esp")
                    local h = esp(v, Color3.fromRGB(0, 0, 255), v, v.Name, 0.0)
                    table.insert(esptable.keys, h)
                end
            end
        end
        
        for i, v in pairs(CurrentRooms:GetChildren()) do
            keys(v)
        end
        
        local addconnect = CurrentRooms.ChildAdded:Connect(function(s)
            wait(0.5)
            keys(s)
        end)
        
        repeat task.wait() until not flags.key_esp
        addconnect:Disconnect()
        for i, v in pairs(esptable.keys) do
            v.delete()
        end
    end
end)



windos_main.toggle("Loop speed",false,function(val)
    flags.loopspeed = val
        if val then
        local ch
        ch = speed.Changed:Connect(function()
            pcall(function()
                if char then
                    char.Humanoid.WalkSpeed = speed.Value
                end
            end)
        end)
        local change
        local characteradded
        characteradded = plr.CharacterAdded:Connect(function()
            repeat task.wait() until char:FindFirstChild("Humanoid")
            char.Humanoid.WalkSpeed = speed.Value
            change = char.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                char.Humanoid.WalkSpeed = speed.Value
            end)
        end)
        if char then
        char.Humanoid.WalkSpeed = speed.Value
            change = char:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            char.Humanoid.WalkSpeed = speed.Value
            end)
        end
        repeat task.wait() until not flags.loopspeed
         if change then
         change:Disconnect()
         end
         if ch then
         ch:Disconnect()
         end
         characteradded:Disconnect()
     end
end)
windos_main.slider("Loop Speed Value",16,30,1,16,function(val)
    speed.Value = val
end)
char = plr.Character or plr.CharacterAdded:Wait()
print("good")