-- Mod Menu Delta – Ultra Estilizado e Animado
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Variáveis
local WalkSpeedValue = 16
local JumpPowerValue = 50
local ESPEnabled = true
local drawings = {}

-- Cores
local bgColor = Color3.fromRGB(30,30,40)
local accentColor1 = Color3.fromRGB(0,206,209)
local accentColor2 = Color3.fromRGB(0,255,255)
local btnColor = Color3.fromRGB(45,45,55)

-- Criar GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")

-- Função botão com gradiente e animação
local function createButton(parent, y, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.8,0,0,30)
    btn.Position = UDim2.new(0.1,0,0,y)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = btnColor
    btn.AutoButtonColor = false

    -- Canto arredondado
    local corner = Instance.new("UICorner",btn)
    corner.CornerRadius = UDim.new(0,15)

    -- Gradiente
    local grad = Instance.new("UIGradient",btn)
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, accentColor1), ColorSequenceKeypoint.new(1, accentColor2)})
    grad.Rotation = 45

    -- Hover Animation + brilho pulsante
    local pulseTween = TweenService:Create(grad, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation=grad.Rotation+360})
    pulseTween:Play()

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency=0.2}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency=0}):Play()
    end)

    return btn
end

-- Função Input
local function createInput(parent, y, placeholder)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0.8,0,0,30)
    box.Position = UDim2.new(0.1,0,0,y)
    box.PlaceholderText = placeholder
    box.Font = Enum.Font.GothamBold
    box.TextSize = 16
    box.TextColor3 = Color3.new(1,1,1)
    box.BackgroundColor3 = btnColor
    local corner = Instance.new("UICorner",box)
    corner.CornerRadius = UDim.new(0,15)
    return box
end

-- Menu principal circular
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0,300,0,400)
mainFrame.Position = UDim2.new(0.35,0,0.25,0)
mainFrame.BackgroundColor3 = bgColor
mainFrame.Active = true
mainFrame.Draggable = true
local mainCorner = Instance.new("UICorner",mainFrame)
mainCorner.CornerRadius = UDim.new(0,50)

-- Sombra
local shadow = Instance.new("Frame", mainFrame)
shadow.Size = UDim2.new(1,0,1,0)
shadow.Position = UDim2.new(0,0,0,0)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.5
local shadowCorner = Instance.new("UICorner",shadow)
shadowCorner.CornerRadius = UDim.new(0,50)
shadow.ZIndex = 0

-- Título
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,40)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Mod Menu"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = accentColor1
title.BackgroundTransparency = 1

-- Minimizar / Fixar
local minimizeBtn = Instance.new("TextButton", title)
minimizeBtn.Size = UDim2.new(0,30,1,0)
minimizeBtn.Position = UDim2.new(1,-40,0,0)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundColor3 = btnColor

local fixBtn = Instance.new("TextButton", title)
fixBtn.Size = UDim2.new(0,30,1,0)
fixBtn.Position = UDim2.new(1,-75,0,0)
fixBtn.Text = "📌"
fixBtn.TextColor3 = Color3.new(1,1,1)
fixBtn.BackgroundColor3 = btnColor
local fixed = false
fixBtn.MouseButton1Click:Connect(function()
    fixed = not fixed
    mainFrame.Draggable = not fixed
    fixBtn.Text = fixed and "❌" or "📌"
end)

-- Botão flutuante
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.new(0,60,0,60)
floatBtn.Position = UDim2.new(0.05,0,0.5,0)
floatBtn.BackgroundColor3 = accentColor1
floatBtn.Text = "⚙️"
floatBtn.TextScaled = true
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.Font = Enum.Font.GothamBold
floatBtn.Active = true
floatBtn.Draggable = true
floatBtn.Visible = false

-- Abrir/Fechar Menu com animação bounce
local function openMenu()
    mainFrame.Visible = true
    floatBtn.Visible = false
    mainFrame.Position = UDim2.new(0.35,0,-0.5,0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5,Enum.EasingStyle.Bounce), {Position=UDim2.new(0.35,0,0.25,0)}):Play()
end
local function closeMenu()
    TweenService:Create(mainFrame, TweenInfo.new(0.3,Enum.EasingStyle.Quad), {Position=UDim2.new(0.35,0,-0.5,0)}):Play()
    wait(0.3)
    mainFrame.Visible = false
    floatBtn.Visible = true
end

minimizeBtn.MouseButton1Click:Connect(closeMenu)
floatBtn.MouseButton1Click:Connect(openMenu)

-- Inputs e Botões
local walkInput = createInput(mainFrame,60,"Set WalkSpeed")
walkInput.FocusLost:Connect(function()
    local val = tonumber(walkInput.Text)
    if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

local jumpInput = createInput(mainFrame,110,"Set JumpPower")
jumpInput.FocusLost:Connect(function()
    local val = tonumber(jumpInput.Text)
    if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)

local espBtn = createButton(mainFrame,160,"Toggle Bone ESP")
espBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
end)

local tpInput = createInput(mainFrame,210,"Nome do player")
local tpBtn = createButton(mainFrame,260,"Teleportar")
tpBtn.MouseButton1Click:Connect(function()
    local nome = tpInput.Text
    local alvo = Players:FindFirstChild(nome)
    if alvo and alvo.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and alvo.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.Anchored = true
        hrp.CFrame = alvo.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        wait(0.1)
        hrp.Anchored = false
    end
end)

-- ESP funcional (R15)
local partsR15={"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}
local connectionsR15={{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}

local function createESP(plr)
    if drawings[plr] then return end
    drawings[plr] = {}
    for _, bone in pairs(partsR15) do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 2
        line.Color = accentColor1
        drawings[plr][bone] = line
    end
end

local function removeESP(plr)
    if drawings[plr] then
        for _, line in pairs(drawings[plr]) do line:Remove() end
    end
    drawings[plr] = nil
end

local function updateESP(plr)
    local char = plr.Character
    local cam = workspace.CurrentCamera
    if not char or not cam then return end
    local positions = {}
    for _, bone in pairs(partsR15) do
        local part = char:FindFirstChild(bone)
        if part and part:IsA("BasePart") then
            local vec, onScreen = cam:WorldToViewportPoint(part.Position)
            if onScreen then
                positions[bone] = Vector2.new(vec.X, vec.Y)
            end
        end
    end
    for _, conn in pairs(connectionsR15) do
        local p1, p2 = positions[conn[1]], positions[conn[2]]
        local line = drawings[plr][conn[1]]
        if line and p1 and p2 then
            line.From = p1
            line.To = p2
            line.Visible = true
        elseif line then
            line.Visible = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                createESP(plr)
                updateESP(plr)
            end
        end
    else
        for _, plr in pairs(Players:GetPlayers()) do
            removeESP(plr)
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if ESPEnabled then createESP(plr) end
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

-- Label do player
local playerLabel = Instance.new("TextLabel", mainFrame)
playerLabel.Size = UDim2.new(1, -20, 0, 30)
playerLabel.Position = UDim2.new(0, 10, 0, 370)
playerLabel.Text = "Você: "..LocalPlayer.Name
playerLabel.TextColor3 = Color3.fromRGB(0,255,0)
playerLabel.BackgroundTransparency = 1
playerLabel.Font = Enum.Font.GothamBold
playerLabel.TextSize = 16
