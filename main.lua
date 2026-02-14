-- AUTO PARRY - SÓ DEFENDE QUANDO O ATAQUE ESTIVER GRUDADO
print("🔥 AUTO PARRY CURTA DISTÂNCIA CARREGADO")

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local virtualInput = game:GetService("VirtualInputManager")
local userInputService = game:GetService("UserInputService")

-- CONFIGURAÇÕES - DISTÂNCIA BEM CURTA!
local distanciaParry = 8  -- Só defende quando estiver muito perto (grudado)
local teclaParry = Enum.KeyCode.F
local intervaloParry = 0.2
local ultimoParry = 0
local anguloMaximo = 60  -- Ângulo mais permissivo

-- Criar interface minimalista
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoParryCurto"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 60)
frame.Position = UDim2.new(0, 10, 0.5, -30)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.Text = "⚡ AUTO PARRY\nATIVADO"
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 12
statusLabel.Parent = frame

local distanciaLabel = Instance.new("TextLabel")
distanciaLabel.Size = UDim2.new(1, 0, 0, 15)
distanciaLabel.Position = UDim2.new(0, 0, 1, -15)
distanciaLabel.Text = "Distância: " .. distanciaParry
distanciaLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distanciaLabel.BackgroundTransparency = 1
distanciaLabel.Font = Enum.Font.Gotham
distanciaLabel.TextSize = 9
distanciaLabel.Parent = frame

-- FUNÇÃO PARA VERIFICAR SE O OBJETO ESTÁ VINDO EM DIREÇÃO AO JOGADOR
local function estaVindoEmDirecao(obj, jogadorPos)
    if not obj:IsA("BasePart") then return false end
    
    -- Se a velocidade for muito baixa, ignora
    if obj.Velocity.Magnitude < 1 then return false end
    
    local direcaoObjeto = obj.Velocity.Unit
    local direcaoJogador = (jogadorPos - obj.Position).Unit
    
    -- Calcula o ângulo entre a direção do objeto e a direção do jogador
    local dotProduct = direcaoObjeto:Dot(direcaoJogador)
    local angulo = math.deg(math.acos(dotProduct))
    
    -- Se o ângulo for pequeno, está vindo em direção ao jogador
    return angulo < anguloMaximo
end

-- FUNÇÃO PARA VERIFICAR SE O OBJETO PERTENCE AO JOGADOR
local function pertenceAoJogador(obj)
    if not player.Character then return false end
    return obj:IsDescendantOf(player.Character)
end

-- FUNÇÃO PRINCIPAL DE DETECÇÃO - FOCADA EM DISTÂNCIA CURTA
local function detectarAtaqueProximo()
    if not player.Character then return nil, nil end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    
    local jogadorPos = root.Position
    local ataquePerigoso = nil
    local menorDistancia = math.huge
    
    -- Procura apenas por HighestEloPart
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Ignora objetos do próprio jogador
        if not pertenceAoJogador(obj) then
            if obj.Name == "HighestEloPart" and obj:IsA("Part") then
                -- Calcula distância
                local distancia = (jogadorPos - obj.Position).Magnitude
                
                -- Só considera se estiver DENTRO da distância curta
                if distancia < distanciaParry then
                    -- Verifica se está vindo em direção ao jogador (opcional, pode remover se quiser)
                    if estaVindoEmDirecao(obj, jogadorPos) then
                        if distancia < menorDistancia then
                            menorDistancia = distancia
                            ataquePerigoso = obj
                        end
                    end
                end
            end
        end
    end
    
    return ataquePerigoso, menorDistancia
end

-- LOOP PRINCIPAL DE DEFESA
runService.Heartbeat:Connect(function()
    local ataque, distancia = detectarAtaqueProximo()
    
    if ataque then
        -- Objeto muito próximo! Defende imediatamente
        statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)  -- Vermelho (perigo!)
        statusLabel.Text = string.format("⚡ DEFENDENDO!\n📏 %.1f", distancia)
        
        local agora = tick()
        if agora - ultimoParry > intervaloParry then
            ultimoParry = agora
            
            -- Pressiona F
            virtualInput:SendKeyEvent(true, teclaParry, false, game)
            task.wait(0.03)
            virtualInput:SendKeyEvent(false, teclaParry, false, game)
            
            -- Feedback visual
            frame.BackgroundColor3 = Color3.fromRGB(100, 0, 0)  -- Vermelho escuro
            task.spawn(function()
                task.wait(0.1)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end)
        end
    else
        -- Sem perigo próximo
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)  -- Verde
        statusLabel.Text = "⚡ AUTO PARRY\nATIVADO"
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end
end)

-- FUNÇÃO PARA AJUSTAR DISTÂNCIA (teclas + e -)
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    elseif input.KeyCode == Enum.KeyCode.Equals then  -- Tecla +
        distanciaParry = math.min(20, distanciaParry + 1)
        distanciaLabel.Text = "Distância: " .. distanciaParry
        print("📏 Distância ajustada para: " .. distanciaParry)
    elseif input.KeyCode == Enum.KeyCode.Minus then  -- Tecla -
        distanciaParry = math.max(3, distanciaParry - 1)
        distanciaLabel.Text = "Distância: " .. distanciaParry
        print("📏 Distância ajustada para: " .. distanciaParry)
    end
end)

print("✅ Auto Parry CURTA DISTÂNCIA carregado!")
print("📏 Distância inicial: " .. distanciaParry)
print("➕ Tecla + para aumentar distância")
print("➖ Tecla - para diminuir distância")
print("🔘 INSERT para esconder/mostrar")
