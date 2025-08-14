local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = workspace

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera


local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")
local defaultWalk = Humanoid.WalkSpeed


local mods = {
    ["Speed"] = false,
    ["Jump"] = false,
    ["Air Freeze"] = false,
    ["ESP"] = false,
    ["ESP Box"] = false,
    ["Breadcrumbs"] = false,
    ["Bullet Track Display"] = false,
    ["Soft Aimbot"] = false,
    ["Visual Feedback"] = false,
    ["No Reload"] = false,
    ["Auto Heal"] = false,
    ["Jump Boost"] = false,
    ["Freeze in Air"] = false
}

local airFreezeY = nil
local ESPObjects = {}
local Breadcrumbs = {}
local aimPartName = "Head"
local aimbotRange = 1000
local aimSpeed = 0.15
local healThreshold = 50
local healAmount = 100
local jumpPowerBoost = 150
local normalJumpPower = 50
local isFrozen = false
local jumpPressed = false


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 350)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0,200,255)
UIStroke.Thickness = 4
UIStroke.Transparency = 0.3

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "SEPEHR"
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.TextScaled = true
Title.Font = Enum.Font.Arcade
Title.TextStrokeTransparency = 0.5

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -10, 1, -40)
ScrollFrame.Position = UDim2.new(0,5,0,40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollFrame.ScrollBarThickness = 8
local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)


do
    local dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragInput = input
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragInput = nil
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input == dragInput then
            update(input)
        end
    end)
end


local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0.5, 130, 0.5, -180)
ToggleButton.Text = "▼"
ToggleButton.BackgroundTransparency = 0.5
ToggleButton.BackgroundColor3 = Color3.fromRGB(30,30,40)
ToggleButton.BorderSizePixel = 0
ToggleButton.TextScaled = true
ToggleButton.TextColor3 = Color3.fromRGB(0,200,255)
ToggleButton.AnchorPoint = Vector2.new(0.5,0.5)

local isOpen = true -- منو اول باز هست
ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    if isOpen then
        MainFrame:TweenSize(UDim2.new(0,240,0,350), "Out", "Quad", 0.3, true)
        ToggleButton.Text = "▼"
    else
        MainFrame:TweenSize(UDim2.new(0,240,0,50), "Out", "Quad", 0.3, true)
        ToggleButton.Text = "▶"
    end
end)


local function CreateToggle(name)
    local Button = Instance.new("TextButton", ScrollFrame)
    Button.Size = UDim2.new(1,0,0,45)
    Button.BackgroundColor3 = Color3.fromRGB(35,35,45)
    Button.BorderSizePixel = 0
    Button.TextScaled = true
    Button.TextColor3 = Color3.fromRGB(0,200,255)
    Button.Text = name.." [OFF]"

    local glow = Instance.new("UIStroke", Button)
    glow.Color = Color3.fromRGB(0,200,255)
    glow.Thickness = 2
    glow.Transparency = 0.5

    local particle = Instance.new("ParticleEmitter", Button)
    particle.Color = ColorSequence.new(Color3.fromRGB(0,200,255))
    particle.LightEmission = 0.7
    particle.Size = NumberSequence.new(2)
    particle.Rate = 0
    particle.Lifetime = NumberRange.new(0.3)

    Button.MouseEnter:Connect(function()
        TweenService:Create(glow, TweenInfo.new(0.2), {Transparency=0}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {Size=UDim2.new(1,5,0,50)}):Play()
        particle.Rate = 30
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(glow, TweenInfo.new(0.2), {Transparency=0.5}):Play()
        TweenService:Create(Button, TweenInfo.new(0.2), {Size=UDim2.new(1,0,0,45)}):Play()
        particle.Rate = 0
    end)

    Button.MouseButton1Click:Connect(function()
        mods[name] = not mods[name]
        Button.Text = name.." ["..(mods[name] and "ON" or "OFF").."]"
        if name == "Air Freeze" and mods[name] then airFreezeY = HRP.Position.Y end
        if name == "Speed" and not mods[name] then Humanoid.WalkSpeed = defaultWalk end
    end)
end

for k,_ in pairs(mods) do
    CreateToggle(k)
end
ScrollFrame.CanvasSize = UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y + 5)


local function SetupCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
    defaultWalk = Humanoid.WalkSpeed
    if mods["Air Freeze"] then airFreezeY = HRP.Position.Y end
end
LocalPlayer.CharacterAdded:Connect(SetupCharacter)
SetupCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())


RunService.RenderStepped:Connect(function()
    if not Character or not Humanoid or not HRP then return end

    
    if mods["Speed"] then Humanoid.WalkSpeed = 120 else Humanoid.WalkSpeed = defaultWalk end
    if mods["Jump"] then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    if mods["Air Freeze"] and airFreezeY then HRP.CFrame = CFrame.new(HRP.Position.X, airFreezeY, HRP.Position.Z) end

    
    if mods["Jump Boost"] then
        Humanoid.UseJumpPower = true
        Humanoid.JumpPower = jumpPowerBoost
    else
        Humanoid.JumpPower = normalJumpPower
    end

    
    if mods["Auto Heal"] and Humanoid and Humanoid.Health < healThreshold then
        Humanoid.Health = healAmount
    end

    
    if mods["No Reload"] and Character then
        for _, tool in ipairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                tool.Ammo.Value = math.huge
            end
        end
    end

    
    if mods["Freeze in Air"] and jumpPressed and not isFrozen then
        isFrozen = true
        HRP.Anchored = true
    elseif (not mods["Freeze in Air"] or not jumpPressed) and isFrozen then
        isFrozen = false
        HRP.Anchored = false
    end

    
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = p.Character.HumanoidRootPart
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if mods["ESP"] or mods["ESP Box"] or mods["Breadcrumbs"] then
                if not ESPObjects[p] then
                    local line = Drawing.new("Line")
                    local box = Drawing.new("Square")
                    local nameLabel = Drawing.new("Text")
                    ESPObjects[p] = {Line=line, Box=box, NameLabel=nameLabel}
                    Breadcrumbs[p] = {}
                end
                local color = (p.Team == LocalPlayer.Team) and Color3.fromRGB(0,150,255) or Color3.fromRGB(255,0,0)
                local obj = ESPObjects[p]
                obj.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                obj.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                obj.Line.Color = color
                obj.Line.Visible = mods["ESP"]

                obj.NameLabel.Text = p.Name
                obj.NameLabel.Position = Vector2.new(screenPos.X, screenPos.Y - 20)
                obj.NameLabel.Color = color
                obj.NameLabel.Visible = mods["ESP"]

                obj.Box.Size = Vector2.new(40,60)
                obj.Box.Position = Vector2.new(screenPos.X-20, screenPos.Y-30)
                obj.Box.Color = color
                obj.Box.Visible = mods["ESP Box"]

                if mods["Breadcrumbs"] then
                    table.insert(Breadcrumbs[p], Vector2.new(screenPos.X, screenPos.Y))
                    if #Breadcrumbs[p] > 20 then table.remove(Breadcrumbs[p],1) end
                end
            end

            
            if mods["Bullet Track Display"] then
                local obj = ESPObjects[p]
                obj.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                obj.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                obj.Line.Visible = true
            end
        end
    end

    
    if mods["Soft Aimbot"] then
        local closest, shortest = nil, math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(aimPartName) then
                local dist = (HRP.Position - p.Character[aimPartName].Position).Magnitude
                if dist < shortest and dist <= aimbotRange then
                    closest = p
                    shortest = dist
                end
            end
        end
        if closest and closest.Character then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closest.Character[aimPartName].Position), aimSpeed)
        end
    end

  
    if mods["Visual Feedback"] then
        local nearEnemy = false
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (HRP.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist < 50 then nearEnemy = true break end
            end
        end
        Camera.BackgroundColor3 = nearEnemy and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,0,0)
    end
end)

print("SEPEHR MOD MENU READY!")
