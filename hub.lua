repeat task.wait() until game:IsLoaded()

-- =====================
-- RAYFIELD
-- =====================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- =====================
-- KEY SYSTEM
-- =====================
local KEY = "HubUniversal"
local unlocked = false
local input = ""

local KeyWindow = Rayfield:CreateWindow({
    Name = "Hub Universal",
    LoadingTitle = "Hub Universal",
    LoadingSubtitle = "By Guilherme",
    ConfigurationSaving = {Enabled = false}
})

local KeyTab = KeyWindow:CreateTab("Key", 4483362458)

KeyTab:CreateInput({
    Name = "Senha",
    PlaceholderText = "Digite a senha",
    RemoveTextAfterFocusLost = false,
    Callback = function(v)
        input = v
    end
})

KeyTab:CreateButton({
    Name = "Confirmar",
    Callback = function()
        if input == KEY then
            unlocked = true
            KeyWindow:SetVisible(false)
        else
            Rayfield:Notify({
                Title = "Erro",
                Content = "Senha incorreta",
                Duration = 3
            })
        end
    end
})

repeat task.wait() until unlocked

-- =====================
-- HUB
-- =====================
local Window = Rayfield:CreateWindow({
    Name = "Hub Universal - By Guilherme",
    ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("Área", 4483362458)

local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- =====================
-- PLAYER EXTRAS
-- =====================
Tab:CreateToggle({Name="NoClip", Callback=function(v)
    _G.noclip=v
    RS.Stepped:Connect(function()
        if _G.noclip and plr.Character then
            for _,p in pairs(plr.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end
        end
    end)
end})

Tab:CreateButton({Name="Reset Char", Callback=function()
    plr.Character:BreakJoints()
end})

Tab:CreateToggle({Name="Anti Knockback", Callback=function(v)
    _G.akb=v
    while _G.akb do
        task.wait()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Velocity=Vector3.zero
        end
    end
end})

Tab:CreateToggle({Name="Sit Anywhere", Callback=function(v)
    if v and plr.Character then
        plr.Character:FindFirstChildOfClass("Humanoid").Sit=true
    end
end})

-- =====================
-- CLICK TP
-- =====================
Tab:CreateToggle({Name="Click TP", Callback=function(v)
    _G.ctp=v
end})

UIS.InputBegan:Connect(function(i)
    if _G.ctp and i.UserInputType==Enum.UserInputType.MouseButton1 then
        local m=plr:GetMouse()
        if plr.Character then
            plr.Character.HumanoidRootPart.CFrame=CFrame.new(m.Hit.p+Vector3.new(0,3,0))
        end
    end
end)

-- =====================
-- VISUAL
-- =====================
Tab:CreateToggle({Name="FullBright", Callback=function(v)
    if v then
        game.Lighting.Brightness=5
        game.Lighting.ClockTime=14
        game.Lighting.FogEnd=100000
    end
end})

Tab:CreateToggle({Name="Remove Fog", Callback=function(v)
    if v then
        game.Lighting.FogEnd=100000
    end
end})

-- =====================
-- ESP FIXADO
-- =====================
Tab:CreateToggle({Name="ESP Players", Callback=function(v)
    _G.esp=v
    while _G.esp do
        task.wait(1)
        for _,p in pairs(game.Players:GetPlayers()) do
            if p~=plr and p.Character and p.Character:FindFirstChild("Head") then
                if not p.Character.Head:FindFirstChild("ESP") then
                    local g=Instance.new("BillboardGui",p.Character.Head)
                    g.Name="ESP"
                    g.Size=UDim2.new(0,120,0,30)
                    g.AlwaysOnTop=true
                    local t=Instance.new("TextLabel",g)
                    t.Size=UDim2.new(1,0,1,0)
                    t.BackgroundTransparency=1
                    t.Text=p.Name
                    t.TextScaled=true
                    t.TextColor3=Color3.fromRGB(255,0,0)
                end
            end
        end
    end
    for _,p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESP") then
            p.Character.Head.ESP:Destroy()
        end
    end
end})

-- =====================
-- COMBAT
-- =====================
Tab:CreateToggle({Name="Kill Aura", Callback=function(v)
    _G.killaura=v
    while _G.killaura do
        task.wait(0.2)
        for _,m in pairs(workspace:GetDescendants()) do
            if m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart") and m.Humanoid.Health>0 then
                local hrp=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position-m.HumanoidRootPart.Position).Magnitude<12 then
                    firetouchinterest(hrp,m.HumanoidRootPart,0)
                    firetouchinterest(hrp,m.HumanoidRootPart,1)
                end
            end
        end
    end
end})

Tab:CreateToggle({Name="Hitbox Expander", Callback=function(v)
    _G.hitbox=v
    while _G.hitbox do
        task.wait(1)
        for _,p in pairs(game.Players:GetPlayers()) do
            if p~=plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size=Vector3.new(8,8,8)
                p.Character.HumanoidRootPart.Transparency=0.6
                p.Character.HumanoidRootPart.CanCollide=false
            end
        end
    end
end})

-- =====================
-- UTIL
-- =====================
Tab:CreateToggle({Name="Auto Equip Tool", Callback=function(v)
    _G.aet=v
    while _G.aet do
        task.wait()
        for _,t in pairs(plr.Backpack:GetChildren()) do
            if t:IsA("Tool") then
                t.Parent=plr.Character
            end
        end
    end
end})

Tab:CreateButton({Name="Server Hop", Callback=function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end})

Tab:CreateButton({Name="Copy JobId", Callback=function()
    setclipboard(game.JobId)
end})
