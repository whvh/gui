--[[
    Arcanum UI Library - Basic Example
    
    This example demonstrates the basic functionality of Arcanum UI Library.
    Includes window creation, pages, sections, and various UI components.
]]

-- Load the library
local Arcanum = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()

-- Create main window
local Window = Arcanum:Window({
    Name = "Arcanum Example",
    SubName = "v1.0.0",
    Logo = "rbxassetid://120959262762131"
})

-- Create main page
local Main = Window:Page({
    Name = "Main",
    Icon = "rbxassetid://138827881557940"
})

-- Create combat page
local Combat = Window:Page({
    Name = "Combat",
    Icon = "rbxassetid://123944728972740"
})

-- Create visual page
local Visual = Window:Page({
    Name = "Visual",
    Icon = "rbxassetid://100050851789190",
    Columns = 2
})

-- === MAIN PAGE ===

local MainSection = Main:Section({
    Name = "Main Features",
    Side = 1,
    Description = "Basic script features"
})

-- Toggle example
MainSection:Toggle({
    Name = "Auto Farm",
    Flag = "auto_farm",
    Default = false,
    Callback = function(Value)
        print("Auto Farm is now", Value and "enabled" or "disabled")
        if Value then
            -- Start auto farm logic here
        else
            -- Stop auto farm logic here
        end
    end
})

-- Slider example
MainSection:Slider({
    Name = "Walk Speed",
    Flag = "walk_speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Suffix = " studs/s",
    Decimals = 0,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        print("Walk speed set to", Value)
    end
})

-- Dropdown example
MainSection:Dropdown({
    Name = "Teleport Location",
    Flag = "teleport_location",
    Items = {
        "Spawn",
        "Bank",
        "Police Station",
        "Hospital",
        "Airport"
    },
    Multi = false,
    Default = "Spawn",
    Callback = function(Value)
        print("Selected location:", Value)
        -- Add teleport logic here
    end
})

-- Button example
MainSection:Button({
    Name = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer:LoadCharacter()
        Arcanum:Notification({
            Title = "Character Reset",
            Description = "Your character has been reset!",
            Duration = 3
        })
    end
})

-- Textbox example
MainSection:Textbox({
    Name = "Custom Message",
    Flag = "custom_message",
    Placeholder = "Enter your message...",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        print("Custom message:", Value)
        if Value and Value ~= "" then
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Value, "All")
        end
    end
})

-- Keybind example
MainSection:Keybind({
    Name = "Fly Toggle",
    Flag = "fly_toggle",
    Default = Enum.KeyCode.F,
    Mode = "Toggle",
    Callback = function(Value)
        print("Fly is now", Value and "enabled" or "disabled")
        -- Add fly logic here
    end
})

-- Colorpicker example
MainSection:Colorpicker({
    Name = "GUI Color",
    Flag = "gui_color",
    Default = Color3.fromRGB(0, 195, 255),
    Callback = function(Value)
        Arcanum:ChangeTheme("Accent", Value)
        print("GUI color changed to", Value)
    end
})

-- Label example
MainSection:Label("=== Information ===")
MainSection:Label("This is a basic example of Arcanum UI Library")

-- === COMBAT PAGE ===

local CombatSection1 = Combat:Section({
    Name = "Combat Settings",
    Side = 1
})

local CombatSection2 = Combat:Section({
    Name = "Weapon Settings", 
    Side = 2
})

-- Combat toggles
CombatSection1:Toggle({
    Name = "Aimbot",
    Flag = "aimbot",
    Default = false,
    Callback = function(Value)
        print("Aimbot:", Value)
    end
})

CombatSection1:Toggle({
    Name = "Silent Aim",
    Flag = "silent_aim",
    Default = false,
    Callback = function(Value)
        print("Silent Aim:", Value)
    end
})

-- Combat sliders
CombatSection1:Slider({
    Name = "Aimbot FOV",
    Flag = "aimbot_fov",
    Min = 10,
    Max = 360,
    Default = 90,
    Suffix = "°",
    Callback = function(Value)
        print("Aimbot FOV:", Value)
    end
})

CombatSection1:Slider({
    Name = "Smoothness",
    Flag = "smoothness",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Callback = function(Value)
        print("Smoothness:", Value)
    end
})

-- Weapon settings
CombatSection2:Dropdown({
    Name = "Weapon Mode",
    Flag = "weapon_mode",
    Items = {"Auto", "Semi", "Burst"},
    Multi = false,
    Default = "Auto",
    Callback = function(Value)
        print("Weapon mode:", Value)
    end
})

CombatSection2:Slider({
    Name = "Fire Rate",
    Flag = "fire_rate",
    Min = 1,
    Max = 20,
    Default = 10,
    Suffix = " shots/s",
    Callback = function(Value)
        print("Fire rate:", Value)
    end
})

-- === VISUAL PAGE ===

local VisualSection1 = Visual:Section({
    Name = "ESP Settings",
    Side = 1
})

local VisualSection2 = Visual:Section({
    Name = "World Settings",
    Side = 2
})

-- ESP toggles
VisualSection1:Toggle({
    Name = "Player ESP",
    Flag = "player_esp",
    Default = false,
    Callback = function(Value)
        print("Player ESP:", Value)
    end
})

VisualSection1:Toggle({
    Name = "Box ESP",
    Flag = "box_esp",
    Default = false,
    Callback = function(Value)
        print("Box ESP:", Value)
    end
})

VisualSection1:Toggle({
    Name = "Name ESP",
    Flag = "name_esp",
    Default = false,
    Callback = function(Value)
        print("Name ESP:", Value)
    end
})

-- ESP colors
VisualSection1:Colorpicker({
    Name = "Enemy Color",
    Flag = "enemy_color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        print("Enemy color:", Value)
    end
})

VisualSection1:Colorpicker({
    Name = "Team Color",
    Flag = "team_color",
    Default = Color3.fromRGB(0, 255, 0),
    Callback = function(Value)
        print("Team color:", Value)
    end
})

-- World settings
VisualSection2:Toggle({
    Name = "Fullbright",
    Flag = "fullbright",
    Default = false,
    Callback = function(Value)
        if Value then
            game.Lighting.Brightness = 2
            game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            game.Lighting.Brightness = 3
            game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
        print("Fullbright:", Value)
    end
})

VisualSection2:Slider({
    Name = "Time",
    Flag = "time",
    Min = 0,
    Max = 24,
    Default = 12,
    Suffix = ":00",
    Decimals = 0,
    Callback = function(Value)
        game.Lighting.ClockTime = Value
        print("Time set to", Value .. ":00")
    end
})

VisualSection2:Colorpicker({
    Name = "Ambient Color",
    Flag = "ambient_color",
    Default = game.Lighting.Ambient,
    Callback = function(Value)
        game.Lighting.Ambient = Value
        print("Ambient color:", Value)
    end
})

-- === NOTIFICATIONS ===

-- Show welcome notification
Arcanum:Notification({
    Title = "Welcome to Arcanum!",
    Description = "Basic example loaded successfully",
    Duration = 5,
    Icon = "rbxassetid://73789337996373"
})

-- === INITIALIZATION ===

-- Initialize the window
Window:Init()

-- Set up keybind for opening/closing menu
Arcanum.MenuKeybind = tostring(Enum.KeyCode.RightControl)

-- Export for external access
getgenv().Arcanum = Arcanum

print("Arcanum Basic Example loaded successfully!")
print("Press RightControl to open/close the menu")
