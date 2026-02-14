-- main.lua - Script Death Ball COMPLETO
print("🔥 Script Death Ball carregado!")

-- Criar interface
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeathBallGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 40)
titulo.Text = "⚡ DEATH BALL SCRIPT"
titulo.TextColor3 = Color3.fromRGB(255, 255, 255)
titulo.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

-- Botão de teste
local botao = Instance.new("TextButton")
botao.Size = UDim2.new(0, 280, 0, 40)
botao.Position = UDim2.new(0, 10, 0, 50)
botao.Text = "🔘 SCRIPT FUNCIONANDO!"
botao.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
botao.TextColor3 = Color3.fromRGB(255, 255, 255)
botao.Font = Enum.Font.Gotham
botao.Parent = frame

botao.MouseButton1Click:Connect(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Sucesso!",
        Text = "Script funcionando perfeitamente!",
        Duration = 3
    })
end)

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 1, -30)
status.Text = "✅ Pronto para usar"
status.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame

print("✅ Script carregado com sucesso!")
