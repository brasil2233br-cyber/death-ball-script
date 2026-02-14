-- AUTO PARRY - VERSÃO ULTRALEVE (0% de impacto no FPS)
print("🔥 Carregando versão ULTRALEVE...")

local player = game.Players.LocalPlayer
local virtualInput = game:GetService("VirtualInputManager")
local userInputService = game:GetService("UserInputService")

-- CONFIGURAÇÕES
local distanciaParry = 8
local teclaParry = Enum.KeyCode.F
local ultimoParry = 0
local intervaloParry = 0.3

-- Interface MÍNIMA (só um texto)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoParryUltraLeve"
screenGui.Parent = player:WaitForChild("PlayerGui")

local texto = Instance.new("TextLabel")
texto.Size = UDim2.new(0, 80, 0, 20)
texto.Position = UDim2.new(0, 5, 0, 5)
texto.Text = "🟢"
texto.TextColor3 = Color3.fromRGB(0, 255, 0)
texto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
texto.BackgroundTransparency = 0.5
texto.Font = Enum.Font.GothamBold
texto.TextSize = 16
texto.Parent = screenGui

-- FUNÇÃO SIMPLES (roda poucas vezes por segundo)
local function verificarDefesa()
    task.wait(0.2) -- Espera 200ms entre verificações (leve!)
    
    if not player.Character then return end
    
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local jogadorPos = root.Position
    
    -- Procura apenas pelo objeto específico
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "HighestEloPart" and obj:IsA("Part") then
            -- Ignora se for do próprio jogador
            if player.Character and obj:IsDescendantOf(player.Character) then
                continue
            end
            
            local distancia = (jogadorPos - obj.Position).Magnitude
            
            -- Se estiver muito perto E em movimento
            if distancia < distanciaParry and obj.Velocity.Magnitude > 2 then
                local agora = tick()
                if agora - ultimoParry > intervaloParry then
                    ultimoParry = agora
                    
                    -- Defende
                    virtualInput:SendKeyEvent(true, teclaParry, false, game)
                    task.wait(0.03)
                    virtualInput:SendKeyEvent(false, teclaParry, false, game)
                    
                    texto.Text = "🔴"
                    texto.TextColor3 = Color3.fromRGB(255, 0, 0)
                    task.wait(0.1)
                    texto.Text = "🟢"
                    texto.TextColor3 = Color3.fromRGB(0, 255, 0)
                end
                break
            end
        end
    end
end

-- Loop principal (mais leve que Heartbeat)
task.spawn(function()
    while true do
        verificarDefesa()
    end
end)

-- Tecla INSERT
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        texto.Visible = not texto.Visible
    end
end)

print("✅ Versão ULTRALEVE carregada!")
print("🟢 Indicador verde no canto superior esquerdo")
