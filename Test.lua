-- SEPEHR Ultimate Mod Menu
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Settings
local normalSpeed = 16
local maxSpeed = 100

-- Vars
local isMenuOpen = false
local speedBoostActive = false
local autoGemActive = false
local godModeActive = false
local flyActive = false
local autoKillActive = false
local espActive = false

local flySpeed = 50

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SEPEHR_ModMenu"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 450, 0, 500)
mainFrame.Position = UDim2.new(0.5, -225, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.AnchorPoint = Vector2.new(0.5, 0)

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "SEPEHR"
title.Font = Enum.Font.Arcade
title.TextSize = 36
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
title.TextStrokeTransparency = 0
title.TextScaled = true

-- Tabs container
local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(0, 100, 1, -50)
tabsFrame.Position = UDim2.new(0, 0, 0, 50)
tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabsFrame.BorderSizePixel = 0

-- Buttons container
local buttonsFrame = Instance.new("ScrollingFrame", mainFrame)
buttonsFrame.Size = UDim2.new(1, -100, 1, -50)
buttonsFrame.Position = UDim2.new(0, 100, 0, 50)
buttonsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
buttonsFrame.BorderSizePixel = 0
buttonsFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
buttonsFrame.ScrollBarThickness = 6
buttonsFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

-- UIListLayouts for tabs and buttons
local tabsLayout = Instance.new("UIListLayout", tabsFrame)
tabsLayout.Padding = UDim.new(0, 5)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

local buttonsLayout = Instance.new("UIListLayout", buttonsFrame)
buttonsLayout.Padding = UDim.new(0, 5)
buttonsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Tab names and buttons data
local tabs = {"Movement", "Auto Farm", "Combat", "Visuals", "Other"}
local buttonsData = {
    Movement = {
        {Name = "Speed Hack", Type = "Toggle", State = false},
        {Name = "Fly Mode", Type = "Toggle", State = false, Speed = flySpeed},
    },
    ["Auto Farm"] = {
        {Name = "Auto Gem", Type = "Toggle", State = false},
    },
    Combat = {
        {Name = "Auto Kill", Type = "Toggle", State = false},
        {Name = "God Mode", Type = "Toggle", State = false},
    },
    Visuals = {
        {Name = "ESP", Type = "Toggle", State = false},
    },
    Other = {
        {Name = "Teleport Home", Type = "Button"},
    }
}

-- Track current tab
local currentTab = "Movement"

-- Hold created buttons to update state
local createdButtons = {}

-- Function to create a tab button
local function createTab(name)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.AutoButtonColor = false
    btn.Name = "TabButton"
    btn.BorderSizePixel = 0
    btn.LayoutOrder = #tabs

    -- Highlight if selected
    local function updateButton()
        if currentTab == name then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end
    updateButton()

    btn.MouseButton1Click:Connect(function()
        currentTab = name
        updateTabButtons()
        updateButton()
        refreshButtons()
    end)

    return btn, updateButton
end

local tabButtons = {}
for _, tabName in ipairs(tabs) do
    local btn, updateBtnFunc = createTab(tabName)
    tabButtons[tabName] = {button = btn, update = updateBtnFunc}
end

local function updateTabButtons()
    for _, tab in pairs(tabButtons) do
        tab.update()
    end
end

-- Clear buttonsFrame children
local function clearButtons()
    for _, child in ipairs(buttonsFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    createdButtons = {}
end

-- Helper function to create a toggle button
local function createToggleButton(name, state)
    local btn = Instance.new("TextButton", buttonsFrame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.Text = name .. (state and " : ON" or " : OFF")
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    btn.LayoutOrder = #createdButtons + 1
    return btn
end

-- Helper function to create a normal button
local function createButton(name)
    local btn = Instance.new("TextButton", buttonsFrame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    btn.LayoutOrder = #createdButtons + 1
    return btn
end

-- Update buttons for current tab
function refreshButtons()
    clearButtons()
    local tabData = buttonsData[currentTab]
    if not tabData then return end

    for i, btnData in ipairs(tabData) do
        if btnData.Type == "Toggle" then
            local btn = createToggleButton(btnData.Name, btnData.State)
            btn.MouseButton1Click:Connect(function()
                btnData.State = not btnData.State
                btn.BackgroundColor3 = btnData.State and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
                btn.Text = btnData.Name .. (btnData.State and " : ON" or " : OFF")

                -- Handle specific features here:
                if btnData.Name == "Speed Hack" then
                    speedBoostActive = btnData.State
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = speedBoostActive and maxSpeed or normalSpeed
                    end
                elseif btnData.Name == "Fly Mode" then
                    flyActive = btnData.State
                    if flyActive then
                        startFly()
                    else
                        stopFly()
                    end
                elseif btnData.Name == "Auto Gem" then
                    autoGemActive = btnData.State
                elseif btnData.Name == "God Mode" then
                    godModeActive = btnData.State
                    if godModeActive then
                        activateGodMode()
                    else
                        deactivateGodMode()
                    end
                elseif btnData.Name == "Auto Kill" then
                    autoKillActive = btnData.State
                elseif btnData.Name == "ESP" then
                    espActive = btnData.State
                    toggleESP(espActive)
                end
            end)
            table.insert(createdButtons, btn)

        elseif btnData.Type == "Button" then
            local btn = createButton(btnData.Name)
            btn.MouseButton1Click:Connect(function()
                if btnData.Name == "Teleport Home" then
                    teleportHome()
                end
            end)
            table.insert(createdButtons, btn)
        end
    end
end

-- Initial buttons load
refreshButtons()

-- Toggle menu visibility with M key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.M then
            isMenuOpen = not isMenuOpen
            if isMenuOpen then
                mainFrame.Visible = true
                -- Slide + Fade in animation
                mainFrame.Position = UDim2.new(0.5, -225, -1, 0)
                mainFrame.BackgroundTransparency = 1
                TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -225, 0.1, 0), BackgroundTransparency = 0}):Play()
            else
                -- Slide + Fade out
                TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, -225, -1, 0), BackgroundTransparency = 1}):Play()
                task.delay(0.5, function()
                    mainFrame.Visible = false
                end)
            end
        end
    end
end)

-- ============== Features Implementation ==============

-- Speed Hack (Handled inside refreshButtons toggle)

-- Fly Mode implementation
local flyBodyVelocity, flyConnection

function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Parent = root

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyActive then return end
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end

        flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
    end)
end

function stopFly()
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
end

-- Auto Gem Implementation with Speed Boost and Return
local function findClosestGem()
    local gemsFolder = workspace:FindFirstChild("Debris")
    if not gemsFolder then return nil end
    local closestGem, closestDist
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    for _, gem in ipairs(gemsFolder:GetDescendants()) do
        if gem.Name == "Main" and gem:IsA("BasePart") then
            local dist = (root.Position - gem.Position).Magnitude
            if not closestDist or dist < closestDist then
                closestDist = dist
                closestGem = gem
            end
        end
    end
    return closestGem
end

task.spawn(function()
    while true do
        task.wait(0.2)
        if autoGemActive then
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if char and humanoid and root then
                local startCFrame = root.CFrame
                humanoid.WalkSpeed = maxSpeed

                local gem = findClosestGem()
                if gem then
                    root.CFrame = gem.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.2)
                    root.CFrame = startCFrame
                end
            end
        end
    end
end)

-- God Mode Implementation (Simple health regen)
local godModeConnection
function activateGodMode()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    godModeConnection = RunService.Heartbeat:Connect(function()
        if godModeActive then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

function deactivateGodMode()
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
end

-- Auto Kill (Very basic: attacks nearest enemy humanoid)
task.spawn(function()
    while true do
        task.wait(0.5)
        if autoKillActive then
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if char and humanoid and root then
                local closestEnemy, dist
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local enemyHumanoid = plr.Character:FindFirstChildWhichIsA("Humanoid")
                        local enemyRoot = plr.Character.HumanoidRootPart
                        local d = (root.Position - enemyRoot.Position).Magnitude
                        if not dist or d < dist then
                            dist = d
                            closestEnemy = enemyHumanoid
                        end
                    end
                end
                if closestEnemy and dist < 30 then
                    -- Attack logic (simple damage)
                    closestEnemy:TakeDamage(10)
                end
            end
        end
    end
end)

-- ESP (Boxes + Lines)
local espBoxes = {}
local espConnection

local function createBox(part)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = part.Size + Vector3.new(0.2,0.2,0.2)
    box.Color3 = Color3.new(1, 0, 0)
    box.Transparency = 0.5
    box.Parent = gui
    return box
end

function toggleESP(state)
    if state then
        espConnection = RunService.Heartbeat:Connect(function()
            -- Clean old
            for _, box in pairs(espBoxes) do
                box:Destroy()
            end
            espBoxes = {}

            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local root = plr.Character.HumanoidRootPart
                    local box = createBox(root)
                    table.insert(espBoxes, box)
                end
            end
        end)
    else
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    end
end

-- Teleport Home (Example, teleport to spawn)
function teleportHome()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = workspace:WaitForChild("SpawnLocation").CFrame + Vector3.new(0,5,0)
    end
end

-- Restore walk speed after respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").WalkSpeed = speedBoostActive and maxSpeed or normalSpeed
    if godModeActive then
        activateGodMode()
    end
    if flyActive then
        startFly()
    end
end)

return gui
