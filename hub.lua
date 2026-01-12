-- Hub Universal
-- By Guilherme
-- Key: HubUniversal

repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ================= KEY SYSTEM =================
local KEY = "HubUniversal"
local unlocked = false
local inputKey = ""

local KeyWindow = Rayfield:CreateWindow({
    Name = "Hub Universal",
    LoadingTitle = "Hub Universal",
    LoadingSubtitle = "By Guilherme",
    ConfigurationSaving = {Enabled = false}
})

local KeyTab = KeyWindow:CreateTab("Key", 4483362458)

KeyTab:CreateParagraph({
    Title = "Bem-vindo",
    Content = "Digite a key para acessar o Hub"
})

KeyTab:CreateInput({
    Name = "Key",
    PlaceholderText = "Digite a key",
    Callback = function(v)
        inputKey = v
    end
})

KeyTab:CreateButton({
    Name = "Entrar",
    Callback = function()
        if inputKey == KEY then
            unlocked = true
            Rayfield:Destroy()
        else
            Rayfield:Notify({
                Title = "Erro",
                Content = "Key incorreta",
                Duration = 3
            })
        end
    end
})

repeat task.wait() until unlocked

-- ================= MAIN WINDOW =================
local Window = Rayfield:CreateWindow({
    Name = "Hub Universal",
    LoadingTitle = "Hub Universal",
    LoadingSubtitle = "Bem vindo",
    ConfigurationSaving = {Enabled = false}
})

-- ================= PLAYER =================
local PlayerTab = Window:CreateTab("Player", 4483362458)

PlayerTab:CreateSlider({
    Name = "Speed",
    Range = {0,200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Jump",
    Range = {0,200},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Gravity",
    Range = {0,196},
    Increment = 1,
    CurrentValue = Workspace.Gravity,
    Callback = function(v)
        Workspace.Gravity = v
    end
})

local infJump = false
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        infJump = v
    end
})

UIS.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end
})

-- ================= VISUAL =================
local VisualTab = Window:CreateTab("Visual", 4483362458)

VisualTab:CreateSlider({
    Name = "FOV",
    Range = {70,120},
    Increment = 1,
    CurrentValue = Workspace.CurrentCamera.FieldOfView,
    Callback = function(v)
        Workspace.CurrentCamera.FieldOfView = v
    end
})

VisualTab:CreateButton({
    Name = "Full Bright",
    Callback = function()
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
        Lighting.FogEnd = 1e9
    end
})

VisualTab:CreateButton({
    Name = "Remove Fog",
    Callback = function()
        Lighting.FogEnd = 1e9
    end
})

-- ================= FARM =================
local FarmTab = Window:CreateTab("Farm", 4483362458)

local autoCollect = false
FarmTab:CreateToggle({
    Name = "Auto Collect",
    CurrentValue = false,
    Callback = function(v)
        autoCollect = v
    end
})

task.spawn(function()
    while task.wait(0.3) do
        if autoCollect and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            for _,obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("TouchTransmitter") and obj.Parent:IsA("BasePart") then
                    if (obj.Parent.Position - hrp.Position).Magnitude <= 4 then
                        firetouchinterest(hrp, obj.Parent, 0)
                        firetouchinterest(hrp, obj.Parent, 1)
                    end
                end
            end
        end
    end
end)

FarmTab:CreateToggle({
    Name = "Auto Prompt",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoPrompt = v
        task.spawn(function()
            while _G.AutoPrompt do
                task.wait(0.2)
                for _,p in pairs(Workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") then
                        fireproximityprompt(p)
                    end
                end
            end
        end)
    end
})

-- ================= ESP =================
local EspTab = Window:CreateTab("ESP", 4483362458)

local ESPEnabled = false
local ESPObjects = {}

local function ClearESP()
    for _,v in pairs(ESPObjects) do
        for _,d in pairs(v) do
            d:Remove()
        end
    end
    ESPObjects = {}
end

local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = player.Character.HumanoidRootPart

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(255,0,0)

    local text = Drawing.new("Text")
    text.Size = 13
    text.Center = true
    text.Outline = true
    text.Color = Color3.fromRGB(255,255,255)

    ESPObjects[player] = {box, text}

    RS.RenderStepped:Connect(function()
        if not ESPEnabled or not player.Character or not hrp then
            box.Visible = false
            text.Visible = false
            return
        end

        local pos, onscreen = Workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
        if onscreen then
            box.Size = Vector2.new(40,60)
            box.Position = Vector2.new(pos.X-20, pos.Y-30)
            box.Visible = true

            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
            text.Text = player.Name.." ["..dist.."]"
            text.Position = Vector2.new(pos.X, pos.Y-40)
            text.Visible = true
        else
            box.Visible = false
            text.Visible = false
        end
    end)
end

EspTab:CreateToggle({
    Name = "ESP Players",
    CurrentValue = false,
    Callback = function(v)
        ESPEnabled = v
        ClearESP()
        if v then
            for _,p in pairs(Players:GetPlayers()) do
                CreateESP(p)
            end
        end
    end
})

Players.PlayerAdded:Connect(function(p)
    task.wait(1)
    if ESPEnabled then
        CreateESP(p)
    end
end)

-- ================= COMBAT =================
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateButton({
    Name = "Auto Equip",
    Callback = function()
        for _,t in pairs(LocalPlayer.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                LocalPlayer.Character.Humanoid:EquipTool(t)
                break
            end
        end
    end
})

CombatTab:CreateToggle({
    Name = "Hitbox",
    CurrentValue = false,
    Callback = function(v)
        _G.Hitbox = v
        task.spawn(function()
            while _G.Hitbox do
                task.wait(0.5)
                for _,p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(8,8,8)
                        hrp.Transparency = 0.5
                        hrp.CanCollide = false
                    end
                end
            end
        end)
    end
})

CombatTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = false,
    Callback = function(v)
        _G.FastAttack = v
        task.spawn(function()
            while _G.FastAttack do
                task.wait(0.1)
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then pcall(function() tool:Activate() end) end
            end
        end)
    end
})

CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(v)
        _G.Aura = v
        task.spawn(function()
            while _G.Aura do
                task.wait(0.2)
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    for _,p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            if (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude < 10 then
                                pcall(function() tool:Activate() end)
                            end
                        end
                    end
                end
            end
        end)
    end
})

-- ================= ÁREA =================
local AreaTab = Window:CreateTab("Área", 4483362458)

AreaTab:CreateButton({Name="fps",Callback=function()
    settings().Rendering.QualityLevel = 1
end})

AreaTab:CreateButton({Name="antiafk",Callback=function()
    LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),Workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),Workspace.CurrentCamera.CFrame)
    end)
end})

AreaTab:CreateButton({Name="rejoin",Callback=function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end})

AreaTab:CreateButton({Name="destroyui",Callback=function()
    Rayfield:Destroy()
end})
