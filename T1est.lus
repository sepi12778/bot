-- SEPEHR Ultimate Mod Menu - With Toggle Button
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local normalSpeed = 16
local maxSpeed = 120
local flySpeed = 75

local speedBoostActive = false
local flyActive = false
local autoGemActive = false
local godModeActive = false
local autoKillActive = false
local espActive = false

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "SEPEHR_ModMenu"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Mod Menu)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 420, 0, 480)
mainFrame.Position = UDim2.new(0, 50, 0.1, 0) -- کنار صفحه، سمت چپ
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.AnchorPoint = Vector2.new(0, 0)
mainFrame.ClipsDescendants = true
mainFrame.ZIndex = 10

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "SEPEHR Ultimate Mod Menu"
title.Font = Enum.Font.Arcade
title.TextSize = 32
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextStrokeColor3 = Color3.fromRGB(0, 100, 150)
title.TextStrokeTransparency = 0
title.TextScaled = true

local tabsFrame = Instance.new("Frame", mainFrame)
tabsFrame.Size = UDim2.new(0, 110, 1, -60)
tabsFrame.Position = UDim2.new(0, 0, 0, 60)
tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabsFrame.BorderSizePixel = 0

local buttonsFrame = Instance.new("ScrollingFrame", mainFrame)
buttonsFrame.Size = UDim2.new(1, -110, 1, -60)
buttonsFrame.Position = UDim2.new(0, 110, 0, 60)
buttonsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
buttonsFrame.BorderSizePixel = 0
buttonsFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
buttonsFrame.ScrollBarThickness = 8
buttonsFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

local tabsLayout = Instance.new("UIListLayout", tabsFrame)
tabsLayout.Padding = UDim.new(0, 6)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder

local buttonsLayout = Instance.new("UIListLayout", buttonsFrame)
buttonsLayout.Padding = UDim.new(0, 6)
buttonsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Toggle Button (مثلث کنار منو)
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 35, 0, 60)
toggleButton.Position = UDim2.new(0, 0, 0.1, 0) -- کنار mainFrame سمت چپ
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleButton.Text = "▶"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 30
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.BorderSizePixel = 0
toggleButton.ZIndex = 20

local isMenuVisible = true

toggleButton.MouseButton1Click:Connect(function()
    if isMenuVisible then
        -- مخفی کردن منو
        mainFrame.Visible = false
        toggleButton.Text = "◀"
        isMenuVisible = false
    else
        -- نمایش منو
        mainFrame.Visible = true
        toggleButton.Text = "▶"
        isMenuVisible = true
    end
end)

-- داده‌ها و توابع قبلی رو می‌تونیم بدون تغییر بذاریم، اینجا کد دکمه‌ها و تب‌هاست:

local tabs = {"Movement", "Auto Farm", "Combat", "Visuals", "Other"}
local buttonsData = {
    Movement = {
        {Name = "Speed Hack", Type = "Toggle", State = false},
        {Name = "Fly Mode", Type = "Toggle", State = false},
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
        {Name = "Close Menu", Type = "Button"},
    }
}

local currentTab = "Movement"
local createdButtons = {}

local tabButtons = {}

local function createTab(name)
    local btn = Instance.new("TextButton", tabsFrame)
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0

    local function update()
        if currentTab == name then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            btn.TextColor3 = Color3.new(1,1,1)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end

    btn.MouseButton1Click:Connect(function()
        currentTab = name
        updateTabs()
        updateButtons()
    end)

    return btn, update
end

function updateTabs()
    for _, t in pairs(tabButtons) do
        t.update()
    end
end

local function clearButtons()
    for _, child in ipairs(buttonsFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    createdButtons = {}
end

local function createToggleButton(name, state)
    local btn = Instance.new("TextButton", buttonsFrame)
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    btn.Text = name .. (state and " : ON" or " : OFF")
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    return btn
end

local function createButton(name)
    local btn = Instance.new("TextButton", buttonsFrame)
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    return btn
end

local function updateButtons()
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

                -- Handle feature toggles here (مثل قبلی)
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
                elseif btnData.Name == "Close Menu" then
                    mainFrame.Visible = false
                    isMenuVisible = false
                    toggleButton.Text = "◀"
                end
            end)
            table.insert(createdButtons, btn)
        end
    end
end

-- ادامه کد ویژگی‌ها (پرواز، اتوجم، گادمود، اتوکیل، ESP، و غیره):

-- Fly Mode variables
local flyBodyVelocity, flyConnection

function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = root

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyActive then return end
        local moveDir = Vector3.new(0, 0, 0)
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
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

-- Auto Gem Implementation
local function findClosestGem()
    local debris = workspace:FindFirstChild("Debris")
    if not debris then return nil end
    local closestGem, closestDist
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart

    for _, gem in ipairs(debris:GetDescendants()) do
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
        task.wait(0.3)
        if autoGemActive then
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if char and humanoid and root then
                local startPos = root.CFrame
                humanoid.WalkSpeed = maxSpeed

                local gem = findClosestGem()
                if gem then
                    root.CFrame = gem.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.3)
                    root.CFrame = startPos
                end
            end
        end
    end
end)

-- God Mode Implementation
local godConnection
function activateGodMode()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    godConnection = RunService.Heartbeat:Connect(function()
        if godModeActive then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

function deactivateGodMode()
    if godConnection then
        godConnection:Disconnect()
        godConnection = nil
    end
end

-- Auto Kill Implementation
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
                    closestEnemy:TakeDamage(15)
                end
            end
        end
    end
end)

-- ESP Implementation
local espBoxes = {}
local espConnection

local function createBox(part)
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = part.Size + Vector3.new(0.2, 0.2, 0.2)
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.4
    box.Parent = gui
    return box
end

function toggleESP(state)
    if state then
        espConnection = RunService.Heartbeat:Connect(function()
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

-- Teleport Home function
function teleportHome()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("SpawnPosition")
    if root and spawn then
        root.CFrame = spawn.CFrame + Vector3.new(0,5,0)
    end
end

-- On character spawn reset speed and god mode
LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = speedBoostActive and maxSpeed or normalSpeed
    if godModeActive then
        activateGodMode()
    end
    if flyActive then
        startFly()
    end
end)

-- Initialize tabs/buttons
for _, tabName in ipairs(tabs) do
    local btn, updater = createTab(tabName)
    tabButtons[tabName] = {button = btn, update = updater}
end
updateTabs()
updateButtons()

print("SEPEHR Ultimate Mod Menu Loaded (with toggle button)")
