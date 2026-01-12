-- HUB UNIVERSAL FINAL
-- By Guilherme
-- Senha fixa: HubUniversal

--------------------------------------------------
-- KEY SYSTEM SIMPLES
--------------------------------------------------
local CORRECT_KEY = "HubUniversal"

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local KeyWindow = Rayfield:CreateWindow({
    Name = "Hub Universal",
    LoadingTitle = "Hub Universal",
    LoadingSubtitle = "By Guilherme",
    ConfigurationSaving = { Enabled = false }
})

local KeyTab = KeyWindow:CreateTab("Senha", 4483362458)

local typedKey = ""

KeyTab:CreateParagraph({
    Title = "Hub Universal",
    Content = "Bem-vindo\n\nDigite a senha para acessar o hub."
})

KeyTab:CreateInput({
    Name = "Senha",
    PlaceholderText = "Digite a senha",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt)
        typedKey = txt
    end
})

KeyTab:CreateButton({
    Name = "Entrar",
    Callback = function()
        if typedKey == CORRECT_KEY then
            Rayfield:Notify({
                Title = "Acesso liberado",
                Content = "Bem-vindo ao Hub Universal!",
                Duration = 3
            })
            task.wait(1)
            KeyWindow:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SEUUSUARIO/SEUREPO/main/hub.lua"))()
        else
            Rayfield:Notify({
                Title = "Senha incorreta",
                Content = "Digite a senha correta",
                Duration = 3
            })
        end
    end
})

--------------------------------------------------
-- HUB PRINCIPAL
--------------------------------------------------

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local humanoid, hrp
local savedCFrame

local function setupChar(char)
    humanoid = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
end
setupChar(player.Character or player.CharacterAdded:Wait())
player.CharacterAdded:Connect(setupChar)

-- Main Window
local Window = Rayfield:CreateWindow({
    Name = "Hub Universal",
    LoadingTitle = "Hub Universal",
    LoadingSubtitle = "Bem-vindo",
    ConfigurationSaving = { Enabled = false }
})

-- Tabs
local PlayerTab   = Window:CreateTab("Player", 4483362458)
local MoveTab     = Window:CreateTab("Movement", 4483362458)
local WorldTab    = Window:CreateTab("World", 4483362458)
local VisualTab   = Window:CreateTab("Visual", 4483362458)
local CombatTab   = Window:CreateTab("Combat", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local ESPTab      = Window:CreateTab("ESP", 4483362458)
local MiscTab     = Window:CreateTab("Misc", 4483362458)
local FunTab      = Window:CreateTab("Fun/Admin", 4483362458)

--------------------------------------------------
-- PLAYER
--------------------------------------------------
PlayerTab:CreateSlider({
    Name = "Speed",
    Range = {0,200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if humanoid then humanoid.WalkSpeed = v end
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {0,200},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v)
        if humanoid then humanoid.JumpPower = v end
    end
})

local infJump = false
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v) infJump = v end
})

UIS.JumpRequest:Connect(function()
    if infJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--------------------------------------------------
-- MOVEMENT
--------------------------------------------------
local noclip = false
MoveTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v) noclip = v end
})

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

--------------------------------------------------
-- WORLD (AUTO COLETA)
--------------------------------------------------
local magnet = false
local radius = 4

WorldTab:CreateSlider({
    Name = "Raio da Coleta",
    Range = {0,50},
    Increment = 1,
    CurrentValue = 4,
    Callback = function(v) radius = v end
})

WorldTab:CreateToggle({
    Name = "Auto Coletar Itens",
    CurrentValue = false,
    Callback = function(v)
        magnet = v
        task.spawn(function()
            while magnet do
                if hrp then
                    for _,obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("Tool") or obj:IsA("Part") then
                            if obj:IsDescendantOf(player.Character) == false then
                                if (obj.Position - hrp.Position).Magnitude <= radius then
                                    pcall(function()
                                        obj.CFrame = hrp.CFrame
                                    end)
                                end
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
})

--------------------------------------------------
-- VISUAL
--------------------------------------------------
VisualTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Callback = function(v)
        Lighting.Brightness = v and 5 or 2
        Lighting.FogEnd = v and 1e9 or 1000
    end
})

--------------------------------------------------
-- TELEPORT
--------------------------------------------------
TeleportTab:CreateButton({
    Name = "Salvar Posição",
    Callback = function()
        if hrp then savedCFrame = hrp.CFrame end
    end
})

TeleportTab:CreateButton({
    Name = "Voltar para Posição",
    Callback = function()
        if hrp and savedCFrame then
            hrp.CFrame = savedCFrame
        end
    end
})

TeleportTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, player)
    end
})

--------------------------------------------------
-- MISC
--------------------------------------------------
MiscTab:CreateToggle({
    Name = "Anti AFK",
    CurrentValue = false,
    Callback = function(v)
        if v then
            player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

MiscTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if humanoid then humanoid.Health = 0 end
    end
})

--------------------------------------------------
-- FUN / ADMIN
--------------------------------------------------
FunTab:CreateButton({
    Name = "Sit",
    Callback = function()
        if humanoid then humanoid.Sit = true end
    end
})

FunTab:CreateButton({
    Name = "Reload Character",
    Callback = function()
        player:LoadCharacter()
    end
})

--------------------------------------------------
Rayfield:Notify({
    Title = "Hub Universal",
    Content = "Hub carregado com sucesso!",
    Duration = 5
})
