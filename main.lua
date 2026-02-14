-- AUTO PARRY DEFINITIVO - Death Ball
-- Baseado em análise real do jogo

print("🔥 AUTO PARRY CARREGADO - ANÁLISE REAL")

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")
local userInputService = game:GetService("UserInputService")

-- CONFIGURAÇÕES
local distanciaParry = 35
local teclaParry = Enum.KeyCode.F
local intervaloParry = 0.2
local ultimoParry = 0

-- Criar interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeathBallParry"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0, 10, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 25)
titulo.Text = "⚡ AUTO PARRY"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, 0, 0, 25)
statusText.Position = UDim2.new(0, 0, 0, 25)
statusText.Text = "🟢 ATIVADO"
statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.Gotham
statusText.Parent = frame

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, 0, 0, 25)
infoText.Position = UDim2.new(0, 0, 0, 50)
infoText.Text = "Aguardando ataque..."
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.BackgroundTransparency = 1
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 11
infoText.Parent = frame

-- FUNÇÃO DE DETECÇÃO - Focada no HighestEloPart
local function detectarAtaque()
    if not player.Character then return false, nil end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false, nil end
    
    local playerPos = root.Position
    local ataqueProximo = nil
    local menorDistancia = math.huge
    
    -- Procura especificamente por HighestEloPart na pasta FX
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Foco no objeto que identificamos
        if obj.Name == "HighestEloPart" and obj:IsA("Part") then
            -- Critério principal: está em movimento (velocidade > 2)
            if obj.Velocity.Magnitude > 2 then
                local distancia = (playerPos - obj.Position).Magnitude
                
                if distancia < distanciaParry and distancia < menorDistancia then
                    menorDistancia = distancia
                    ataqueProximo = obj
                end
            end
        end
    end
    
    return ataqueProximo, menorDistancia
end

-- LOOP PRINCIPAL
runService.Heartbeat:Connect(function()
    local ataque, dist = detectarAtaque()
    
    if ataque then
        -- Atualiza interface
        infoText.Text = string.format("⚡ ATAQUE DETECTADO! (%.1f)", dist)
        infoText.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local agora = tick()
        if agora - ultimoParry > intervaloParry then
            ultimoParry = agora
            
            -- Pressiona F
            virtualInput:SendKeyEvent(true, teclaParry, false, game)
            task.wait(0.03)
            virtualInput:SendKeyEvent(false, teclaParry, false, game)
            
            -- Feedback visual
            frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            task.spawn(function()
                task.wait(0.1)
                frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            end)
        end
    else
        infoText.Text = "✅ Nenhum ataque detectado"
        infoText.TextColor3 = Color3.fromRGB(150, 255, 150)
    end
end)

-- FUNÇÃO DE MONITORAMENTO (tecla M)
local function monitorarAtaques()
    print("\n🔍 MONITORANDO OBJETOS EM MOVIMENTO:")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and obj.Velocity.Magnitude > 1 then
            local caminho = obj:GetFullName()
            local vel = obj.Velocity.Magnitude
            print(string.format("📌 %s | Vel: %.1f", caminho, vel))
        end
    end
    
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
end

-- Tecla M para monitorar
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.M then
        monitorarAtaques()
    elseif input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

print("✅ Auto Parry carregado! Pressione M para monitorar, INSERT para esconder")
