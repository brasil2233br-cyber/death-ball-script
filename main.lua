-- LOCALIZADOR DE OBJETOS UNIVERSAL - VERSÃO FUNCIONAL
print("🔥 Carregando Localizador de Objetos...")

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local playerGui = player:WaitForChild("PlayerGui")

-- Criar interface
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ObjectLocator"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 550)
frame.Position = UDim2.new(0.5, -225, 0.5, -275)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 45)
titulo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titulo.Text = "🔍 LOCALIZADOR DE OBJETOS"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 18
titulo.Parent = frame

-- Status
local statusBar = Instance.new("TextLabel")
statusBar.Size = UDim2.new(1, 0, 0, 30)
statusBar.Position = UDim2.new(0, 0, 0, 45)
statusBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
statusBar.Text = "✅ Clique em 'BUSCAR' para iniciar"
statusBar.TextColor3 = Color3.fromRGB(150, 255, 150)
statusBar.Font = Enum.Font.Gotham
statusBar.TextSize = 12
statusBar.Parent = frame

-- Controles
local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(0, 80, 0, 30)
distLabel.Position = UDim2.new(0, 10, 0, 80)
distLabel.Text = "Distância:"
distLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
distLabel.BackgroundTransparency = 1
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 12
distLabel.Parent = frame

local distMenos = Instance.new("TextButton")
distMenos.Size = UDim2.new(0, 25, 0, 30)
distMenos.Position = UDim2.new(0, 100, 0, 80)
distMenos.Text = "-"
distMenos.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
distMenos.TextColor3 = Color3.fromRGB(255, 255, 255)
distMenos.Font = Enum.Font.GothamBold
distMenos.TextSize = 16
distMenos.Parent = frame

local distValor = Instance.new("TextLabel")
distValor.Size = UDim2.new(0, 50, 0, 30)
distValor.Position = UDim2.new(0, 130, 0, 80)
distValor.Text = "30"
distValor.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
distValor.TextColor3 = Color3.fromRGB(255, 255, 255)
distValor.Font = Enum.Font.Gotham
distValor.Parent = frame

local distMais = Instance.new("TextButton")
distMais.Size = UDim2.new(0, 25, 0, 30)
distMais.Position = UDim2.new(0, 185, 0, 80)
distMais.Text = "+"
distMais.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
distMais.TextColor3 = Color3.fromRGB(255, 255, 255)
distMais.Font = Enum.Font.GothamBold
distMais.TextSize = 16
distMais.Parent = frame

-- Botão de busca
local btnBuscar = Instance.new("TextButton")
btnBuscar.Size = UDim2.new(0, 200, 0, 35)
btnBuscar.Position = UDim2.new(0.5, -100, 0, 120)
btnBuscar.Text = "🔍 BUSCAR OBJETOS"
btnBuscar.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
btnBuscar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnBuscar.Font = Enum.Font.GothamBold
btnBuscar.TextSize = 14
btnBuscar.Parent = frame

-- Área de resultados
local resultadoFrame = Instance.new("ScrollingFrame")
resultadoFrame.Size = UDim2.new(1, -20, 0, 340)
resultadoFrame.Position = UDim2.new(0, 10, 0, 165)
resultadoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
resultadoFrame.BorderSizePixel = 0
resultadoFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
resultadoFrame.ScrollBarThickness = 8
resultadoFrame.Parent = frame

local resultadoLayout = Instance.new("UIListLayout")
resultadoLayout.Parent = resultadoFrame
resultadoLayout.Padding = UDim.new(0, 2)

-- Rodapé
local rodape = Instance.new("TextLabel")
rodape.Size = UDim2.new(1, 0, 0, 25)
rodape.Position = UDim2.new(0, 0, 1, -25)
rodape.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
rodape.Text = "👆 Clique nos itens para copiar informações"
rodape.TextColor3 = Color3.fromRGB(200, 200, 200)
rodape.Font = Enum.Font.Gotham
rodape.TextSize = 11
rodape.Parent = frame

-- Função para copiar
local function copiarInfo(obj, distancia)
    local info = string.format([[
📌 OBJETO ENCONTRADO
━━━━━━━━━━━━━━━━
📛 Nome: %s
🔤 Classe: %s
📏 Distância: %.1f
📍 Posição: %.1f, %.1f, %.1f
📋 Caminho: %s
    ]], obj.Name, obj.ClassName, distancia, obj.Position.X, obj.Position.Y, obj.Position.Z, obj:GetFullName())
    
    if obj:IsA("Part") then
        info = info .. string.format([[
⚡ Velocidade: %.1f
📐 Tamanho: %.1f x %.1f x %.1f
        ]], obj.Velocity.Magnitude, obj.Size.X, obj.Size.Y, obj.Size.Z)
    end
    
    -- Tentar copiar
    local copiado = false
    if setclipboard then
        setclipboard(info)
        copiado = true
    elseif toclipboard then
        toclipboard(info)
        copiado = true
    end
    
    rodape.Text = copiado and "✅ Informações copiadas!" or "📢 Info no console (sem clipboard)"
    rodape.TextColor3 = copiado and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 0)
    
    if not copiado then
        print(info)
    end
    
    task.wait(2)
    rodape.Text = "👆 Clique nos itens para copiar informações"
    rodape.TextColor3 = Color3.fromRGB(200, 200, 200)
end

-- Criar item na lista
local function criarItem(obj, distancia)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -10, 0, 40)
    item.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    item.BorderSizePixel = 0
    item.Font = Enum.Font.Gotham
    item.TextSize = 12
    item.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Ícone baseado no tipo
    local icone = "📦"
    if obj:IsA("Part") then
        icone = obj.Velocity.Magnitude > 1 and "⚡" or "🧱"
    elseif obj:IsA("Model") then
        icone = "🏗️"
    end
    
    item.Text = string.format("%s %s | 📏 %.1f", icone, obj.Name, distancia)
    item.TextColor3 = Color3.fromRGB(220, 220, 220)
    
    item.MouseButton1Click:Connect(function()
        copiarInfo(obj, distancia)
    end)
    
    return item
end

-- Função de busca
local function buscarObjetos()
    -- Limpar resultados anteriores
    for _, child in pairs(resultadoFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    statusBar.Text = "🔍 Buscando objetos..."
    statusBar.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    task.wait(0.1) -- Pequena pausa para feedback
    
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        statusBar.Text = "❌ Personagem não encontrado"
        statusBar.TextColor3 = Color3.fromRGB(255, 0, 0)
        return
    end
    
    local playerPos = player.Character.HumanoidRootPart.Position
    local distanciaMax = tonumber(distValor.Text) or 30
    local encontrados = {}
    
    -- Buscar objetos
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj ~= player.Character.HumanoidRootPart then
            local dist = (playerPos - obj.Position).Magnitude
            if dist <= distanciaMax then
                table.insert(encontrados, {obj = obj, dist = dist})
            end
        end
    end
    
    -- Ordenar por distância
    table.sort(encontrados, function(a, b) return a.dist < b.dist end)
    
    -- Mostrar resultados
    for i = 1, math.min(#encontrados, 100) do
        local item = criarItem(encontrados[i].obj, encontrados[i].dist)
        item.Parent = resultadoFrame
    end
    
    -- Atualizar canvas
    resultadoFrame.CanvasSize = UDim2.new(0, 0, 0, resultadoLayout.AbsoluteContentSize.Y + 10)
    
    -- Status final
    if #encontrados == 0 then
        statusBar.Text = "❌ Nenhum objeto encontrado"
        statusBar.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        statusBar.Text = string.format("✅ %d objetos encontrados", #encontrados)
        statusBar.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end

-- Eventos
distMenos.MouseButton1Click:Connect(function()
    local val = tonumber(distValor.Text) or 30
    val = math.max(5, val - 5)
    distValor.Text = tostring(val)
end)

distMais.MouseButton1Click:Connect(function()
    local val = tonumber(distValor.Text) or 30
    val = math.min(100, val + 5)
    distValor.Text = tostring(val)
end)

btnBuscar.MouseButton1Click:Connect(buscarObjetos)

-- Tecla INSERT para esconder/mostrar
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

print("✅ Localizador carregado! Pressione INSERT para esconder/mostrar")
