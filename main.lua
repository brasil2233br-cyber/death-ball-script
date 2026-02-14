-- main.lua - Script Death Ball AUTO PARRY OTIMIZADO
print("🔥 Script Death Ball com Auto Parry OTIMIZADO carregado!")

-- Variáveis principais
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")
local userInputService = game:GetService("UserInputService")

-- Configurações do Auto Parry
local autoParryAtivado = true
local distanciaParry = 25
local teclaParry = Enum.KeyCode.F
local tempoUltimoParry = 0
local intervaloParry = 0.3 -- 300ms entre defesas (evita spam)

-- Criar interface (versão simplificada)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeathBallGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Text = "⚡ AUTO PARRY OTIMIZADO"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

local statusParry = Instance.new("TextLabel")
statusParry.Size = UDim2.new(1, 0, 0, 30)
statusParry.Position = UDim2.new(0, 0, 0, 45)
statusParry.Text = "🤖 ATIVADO"
statusParry.TextColor3 = Color3.fromRGB(0, 255, 0)
statusParry.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusParry.Font = Enum.Font.GothamBold
statusParry.Parent = frame

local botaoToggle = Instance.new("TextButton")
botaoToggle.Size = UDim2.new(0, 280, 0, 35)
botaoToggle.Position = UDim2.new(0, 10, 0, 85)
botaoToggle.Text = "🔘 DESLIGAR"
botaoToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
botaoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoToggle.Font = Enum.Font.Gotham
botaoToggle.Parent = frame

local distanciaLabel = Instance.new("TextLabel")
distanciaLabel.Size = UDim2.new(1, 0, 0, 20)
distanciaLabel.Position = UDim2.new(0, 0, 0, 125)
distanciaLabel.Text = "📏 DISTÂNCIA: " .. distanciaParry
distanciaLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
distanciaLabel.BackgroundTransparency = 1
distanciaLabel.Font = Enum.Font.Gotham
distanciaLabel.Parent = frame

-- FUNÇÃO MELHORADA DO AUTO PARRY
local function verificarBola()
    if not autoParryAtivado then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    local bolaEncontrada = false
    
    -- Procurar apenas por objetos que parecem bolas (mais específico)
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Filtro mais rigoroso: só objetos do tipo Part com nomes específicos
        if obj:IsA("Part") and obj ~= player.Character.HumanoidRootPart then
            local nome = obj.Name:lower()
            -- Lista de nomes comuns para bolas no jogo
            if nome:find("ball") or nome:find("bola") or nome:find("projectile") or nome:find("spike") then
                local ballPos = obj.Position
                local distance = (playerPos - ballPos).Magnitude
                
                -- Se está dentro da distância e NÃO é o próprio jogador
                if distance < distanciaParry and obj.Velocity.Magnitude > 5 then
                    bolaEncontrada = true
                    break
                end
            end
        end
    end
    
    -- Se encontrou bola, defende
    if bolaEncontrada then
        local agora = tick()
        if agora - tempoUltimoParry > intervaloParry then
            tempoUltimoParry = agora
            virtualInput:SendKeyEvent(true, teclaParry, false, game)
            task.wait(0.03)
            virtualInput:SendKeyEvent(false, teclaParry, false, game)
            
            -- Feedback visual (opcional)
            frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
            task.spawn(function()
                task.wait(0.1)
                frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            end)
        end
    end
end

-- Loop principal usando Heartbeat (mais eficiente)
runService.Heartbeat:Connect(verificarBola)

-- Botão toggle
botaoToggle.MouseButton1Click:Connect(function()
    autoParryAtivado = not autoParryAtivado
    if autoParryAtivado then
        statusParry.Text = "🤖 ATIVADO"
        statusParry.TextColor3 = Color3.fromRGB(0, 255, 0)
        botaoToggle.Text = "🔘 DESLIGAR"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        statusParry.Text = "⏸️ DESATIVADO"
        statusParry.TextColor3 = Color3.fromRGB(255, 0, 0)
        botaoToggle.Text = "🔘 LIGAR"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)

-- Tecla INSERT para esconder/mostrar
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

-- Notificação
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Auto Parry OTIMIZADO",
    Text = "Script carregado! INSERT para esconder",
    Duration = 3
})

print("✅ Script otimizado carregado!")
