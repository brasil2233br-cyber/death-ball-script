-- main.lua - Script Death Ball com AUTO PARRY FUNCIONANDO
print("🔥 Script Death Ball com Auto Parry carregado!")

-- Variáveis principais
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")
local userInputService = game:GetService("UserInputService")

-- Configurações do Auto Parry
local autoParryAtivado = true
local distanciaParry = 25  -- Distância para ativar defesa
local teclaParry = Enum.KeyCode.F  -- Tecla de defesa (F)

-- Criar interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeathBallGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Text = "⚡ DEATH BALL AUTO PARRY"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

-- Status do Auto Parry
local statusParry = Instance.new("TextLabel")
statusParry.Size = UDim2.new(1, 0, 0, 30)
statusParry.Position = UDim2.new(0, 0, 0, 45)
statusParry.Text = "🤖 AUTO PARRY: ATIVADO"
statusParry.TextColor3 = Color3.fromRGB(0, 255, 0)
statusParry.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
statusParry.Font = Enum.Font.GothamBold
statusParry.TextSize = 14
statusParry.Parent = frame

-- Botão para ligar/desligar
local botaoToggle = Instance.new("TextButton")
botaoToggle.Size = UDim2.new(0, 280, 0, 40)
botaoToggle.Position = UDim2.new(0, 10, 0, 85)
botaoToggle.Text = "🔘 DESLIGAR AUTO PARRY"
botaoToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
botaoToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
botaoToggle.Font = Enum.Font.Gotham
botaoToggle.Parent = frame

-- Slider de distância
local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(0, 280, 0, 20)
sliderLabel.Position = UDim2.new(0, 10, 0, 135)
sliderLabel.Text = "📏 DISTÂNCIA: " .. distanciaParry
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 12
sliderLabel.Parent = frame

-- Botão de diminuir distância
local btnMenos = Instance.new("TextButton")
btnMenos.Size = UDim2.new(0, 30, 0, 30)
btnMenos.Position = UDim2.new(0, 10, 0, 160)
btnMenos.Text = "-"
btnMenos.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
btnMenos.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMenos.Font = Enum.Font.GothamBold
btnMenos.TextSize = 20
btnMenos.Parent = frame

-- Valor da distância
local valorDistancia = Instance.new("TextLabel")
valorDistancia.Size = UDim2.new(0, 210, 0, 30)
valorDistancia.Position = UDim2.new(0, 45, 0, 160)
valorDistancia.Text = distanciaParry
valorDistancia.TextColor3 = Color3.fromRGB(255, 255, 255)
valorDistancia.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
valorDistancia.Font = Enum.Font.Gotham
valorDistancia.TextSize = 16
valorDistancia.Parent = frame

-- Botão de aumentar distância
local btnMais = Instance.new("TextButton")
btnMais.Size = UDim2.new(0, 30, 0, 30)
btnMais.Position = UDim2.new(0, 260, 0, 160)
btnMais.Text = "+"
btnMais.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
btnMais.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMais.Font = Enum.Font.GothamBold
btnMais.TextSize = 20
btnMais.Parent = frame

-- Status inferior
local statusInferior = Instance.new("TextLabel")
statusInferior.Size = UDim2.new(1, 0, 0, 30)
statusInferior.Position = UDim2.new(0, 0, 1, -35)
statusInferior.Text = "✅ Auto Parry funcionando!"
statusInferior.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
statusInferior.TextColor3 = Color3.fromRGB(150, 255, 150)
statusInferior.Font = Enum.Font.Gotham
statusInferior.TextSize = 12
statusInferior.Parent = frame

-- FUNÇÃO DO AUTO PARRY
local function autoParry()
    while autoParryAtivado do
        task.wait(0.05)  -- Verifica rápido
        
        -- Procurar bolas no jogo
        for _, obj in pairs(workspace:GetDescendants()) do
            -- Verifica se é uma bola (pode ter nomes diferentes no jogo)
            if obj:IsA("Part") and (obj.Name:lower():find("ball") or obj.Name:lower():find("bola")) then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local playerPos = player.Character.HumanoidRootPart.Position
                    local ballPos = obj.Position
                    local distance = (playerPos - ballPos).Magnitude
                    
                    -- Se a bola está na distância configurada
                    if distance < distanciaParry then
                        -- Pressiona a tecla de defesa (F)
                        virtualInput:SendKeyEvent(true, teclaParry, false, game)
                        task.wait(0.03)
                        virtualInput:SendKeyEvent(false, teclaParry, false, game)
                        
                        -- Feedback visual (opcional)
                        frame.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
                        task.wait(0.1)
                        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                        break
                    end
                end
            end
        end
    end
end

-- Iniciar Auto Parry em segundo plano
task.spawn(autoParry)

-- Função para atualizar interface
local function atualizarInterface()
    if autoParryAtivado then
        statusParry.Text = "🤖 AUTO PARRY: ATIVADO"
        statusParry.TextColor3 = Color3.fromRGB(0, 255, 0)
        botaoToggle.Text = "🔘 DESLIGAR AUTO PARRY"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        statusParry.Text = "⏸️ AUTO PARRY: DESATIVADO"
        statusParry.TextColor3 = Color3.fromRGB(255, 0, 0)
        botaoToggle.Text = "🔘 LIGAR AUTO PARRY"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
    valorDistancia.Text = distanciaParry
    sliderLabel.Text = "📏 DISTÂNCIA: " .. distanciaParry
end

-- Botão toggle
botaoToggle.MouseButton1Click:Connect(function()
    autoParryAtivado = not autoParryAtivado
    if autoParryAtivado then
        task.spawn(autoParry)
    end
    atualizarInterface()
end)

-- Botões de distância
btnMenos.MouseButton1Click:Connect(function()
    distanciaParry = math.max(5, distanciaParry - 1)
    atualizarInterface()
end)

btnMais.MouseButton1Click:Connect(function()
    distanciaParry = math.min(50, distanciaParry + 1)
    atualizarInterface()
end)

-- Tecla para esconder/mostrar (INSERT)
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

-- Notificação inicial
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Death Ball Auto Parry",
    Text = "Script carregado! Pressione INSERT para esconder",
    Duration = 5
})

print("✅ Script com Auto Parry carregado com sucesso!")
atualizarInterface()
