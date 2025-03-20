local notify =
game:GetService("Players");game:GetService("StarterGui"):SetCore("SendNotification",{Title="Vxeze Hub",Text="Wait Loading...",Icon="",Duration=9});
----------------------------------------------------------------------------------------------------------------------------------------------
Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
Window = Fluent:CreateWindow({
    Title = "Vxeze Hub-Blue Lock (Rivals)",
    SubTitle = "| Dex Skibidi",
    TabWidth = 155,
    Size = UDim2.fromOffset(555, 320),
    Acrylic = false, 
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

local Tabs = {
    Info = Window:AddTab({ Title = "Tab Info", Icon = "Home"}),
    Server = Window:AddTab({ Title = "Tab Server", Icon = "Homee"})
    Main = Window:AddTab({ Title = "Tab Main", Icon ="Home"})
    Player = Window:AddTab({ Title = "Tab Player", Icon = "Home"}),
    ESP = Window:AddTab({ Title = "Tab ESP", Icon = "Home"})
    Team = Window:AddTab({ Title = "Tab Team", Icon ="Home"})
    Styles = Window:AddTab({ Title = "Tab Styles", Icon = "Home"}),
    Flow = Window:AddTab({ Title = "Tab Flow", Icon = "Home"})
    Cosmetics = Window:AddTab({ Title = "Tab Cosmetic", Icon ="Home"})
})
----------------------------------------------------------------------------------------------------------------------------------------------
local Discord = Tabs.Info:AddSection("Discord")
Tabs.Info:AddButton({
    Title = "Vxeze Hub",
    Description = "Discord",
    Callback = function()
        setclipboard(tostring("https://discord.gg/vxezehub")) 
    end
})
Tabs.Info:AddButton({
    Title = "Dex Skibidi",
    Description = "Youtube",
    Callback = function()
        setclipboard(tostring("https://www.youtube.com/@dex_bear"))
    end
})
Tabs.Info:AddButton({
    Title = "Thinh Tran(Dex)",
    Description = "Facebook",
    Callback = function()
        setclipboard(tostring("https://www.facebook.com/profile.php?id=100072575529367"))
    end
})
local Credits = Tabs.Info:AddSection("Credits")
Tabs.Info:AddParagraph({
    Title = "Dex x Vortex",
    Content = ""
})
local Client = Tabs.Info:AddSection("Client")
local executorName
if identifyexecutor then
    executorName=identifyexecutor()
elseif getexecutorname then
    executorName=getexecutorname()
end
if executorName then
    Tabs.Info:AddParagraph({
        Title="Client in use",
        Content=executorName
    })
end
Tabs.Info:AddParagraph({
    Title="Vxeze Hub",
    Content="Script supports pc and pe"
})
Tabs.Info:AddParagraph({
    Title="All Clients Android Supported",
    Content=""
})
Tabs.Info:AddParagraph({
    Title="All Clients PC Supported",
    Content=""
})
----------------------------------------------------------------------------------------------------------------------------------------------
Tabs.Server:AddSection("Server")
local Time = Tabs.Server:AddParagraph({
    Title = "Time",
    Content = ""
})
local function UpdateLocalTime()
    local date = os.date("*t")
    local hour = date.hour % 24
    local ampm = hour < 12 and "AM" or "PM"
    local formattedTime = string.format("%02i:%02i:%02i %s", ((hour-1) % 12)+1, date.min, date.sec, ampm)
    local formattedDate = string.format("%02d/%02d/%04d", date.day, date.month, date.year)
    local LocalizationService = game:GetService("LocalizationService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local name = player.Name
    local regionCode = "Unknown"
    local success, code = pcall(function()
        return LocalizationService:GetCountryRegionForPlayerAsync(player)
    end)
    if success then
        regionCode = code
    end
    Time:SetDesc(formattedDate .. "-" .. formattedTime .. " [ " .. regionCode .. " ]")
end
spawn(function()
    while true do
        UpdateLocalTime()
        game:GetService("RunService").RenderStepped:Wait()
    end
end)

local ServerTime = Tabs.Server:AddParagraph({
    Title = "Server Time",
    Content = ""
})
local function UpdateServerTime()
    local GameTime = math.floor(workspace.DistributedGameTime + 0.5)
    local Hour = math.floor(GameTime / (60^2)) % 24
    local Minute = math.floor(GameTime / 60) % 60
    local Second = GameTime % 60
    ServerTime:SetDesc(string.format("%02d Hour-%02d Minute-%02d Second", Hour, Minute, Second))
end
spawn(function()
    while task.wait() do
        pcall(UpdateServerTime)
    end
end)

Tabs.Server:AddButton({
    Title = "Rejoin Server",
    Description = "",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
    end
})

Tabs.Server:AddButton({
    Title = "Hop Server",
    Description = "",
    Callback = function()
        Hop()
    end
})

function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0;
        for i, v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _, Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait()
                end
            end
        end
    end
    function Teleport() 
        while wait() do
            pcall(function()
                TPReturner()
                if foundAnything ~= "" then
                    TPReturner()
                end
            end)
        end
    end
    Teleport()
end
Tabs.Server:AddButton({
    Title = "Fps Boost",
    Description = "",
    Callback = function()
        local a = false
        local b = game
        local c = b.Workspace
        local d = b.Lighting
        local e = c.Terrain
        e.WaterWaveSize = 0
        e.WaterWaveSpeed = 0
        e.WaterReflectance = 0
        e.WaterTransparency = 0
        d.GlobalShadows = false
        d.FogEnd = 9e9
        d.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"
        for _, f in pairs(b:GetDescendants()) do
            if f:IsA("Part") or f:IsA("Union") or f:IsA("CornerWedgePart") or f:IsA("TrussPart") then
                f.Material = "Plastic"
                f.Reflectance = 0
            elseif f:IsA("Decal") or f:IsA("Texture") and a then
                f.Transparency = 1
            elseif f:IsA("ParticleEmitter") or f:IsA("Trail") then
                f.Lifetime = NumberRange.new(0)
            elseif f:IsA("Explosion") then
                f.BlastPressure = 1
                f.BlastRadius = 1
            elseif f:IsA("Fire") or f:IsA("SpotLight") or f:IsA("Smoke") or f:IsA("Sparkles") then
                f.Enabled = false
            elseif f:IsA("MeshPart") then
                f.Material = "Plastic"
                f.Reflectance = 0
                f.TextureID = 10385902758728957
            end
        end
        for _, g in pairs(d:GetChildren()) do
            if g:IsA("BlurEffect") or g:IsA("SunRaysEffect") or g:IsA("ColorCorrectionEffect") or g:IsA("BloomEffect") or g:IsA("DepthOfFieldEffect") then
                g.Enabled = false
            end
        end
    end
})
----------------------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local existingGui = playerGui:FindFirstChild("CustomScreenGui")
if existingGui then
    existingGui:Destroy()
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomScreenGui"
ScreenGui.Parent = playerGui
local Button = Instance.new("ImageButton")
Button.Name = "CustomButton"
Button.Parent = ScreenGui
Button.Size = UDim2.new(0, 50, 0, 50)
Button.Position = UDim2.new(0.015, 0, 0.02, 20)
Button.BackgroundTransparency = 1
Button.Image = "rbxassetid://91347148253026"
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Button
local imageLoaded = false
ContentProvider:PreloadAsync({Button.Image}, function()
    imageLoaded = true
end)
Button.MouseButton1Click:Connect(function()
    if not imageLoaded then
        return
    end
    local VirtualInputManager = game:GetService("VirtualInputManager")
    if VirtualInputManager then
        task.defer(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
        end)
    end
end)
local notify =
game:GetService("Players");game:GetService("StarterGui"):SetCore("SendNotification",{Title="Vxeze Hub",Text="Loading Done..!",Icon="",Duration=9});

