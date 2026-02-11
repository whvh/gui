--[[
    Arcanum UI Library
    Modern, feature-rich GUI library for Roblox exploits
    
    Features:
    - Modern dark theme with customizable accents
    - Smooth animations and transitions
    - Multiple UI components (toggles, sliders, dropdowns, etc.)
    - Config system with save/load functionality
    - Keybind system with multiple modes
    - Color picker with HSV support
    - Responsive design
    - Mobile support
    
    @author: SuvCult
    @version: 1.0.0
]]

local Arcanum = {} do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    local _isfolder = isfolder
    local _makefolder = makefolder
    local _isfile = isfile
    local _writefile = writefile
    local _readfile = readfile
    local _delfile = delfile
    local _listfiles = listfiles
    local _getcustomasset = getcustomasset

    local HasFS = type(_isfolder) == "function" and type(_makefolder) == "function"
    local HasFiles = type(_isfile) == "function" and type(_writefile) == "function"
    local HasCustomAsset = type(_getcustomasset) == "function"
    local HasListFiles = type(_listfiles) == "function"

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    -- Utility functions
    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex
    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new
    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    local Vector3New = Vector3.new
    local MathClamp = math.clamp
    local MathFloor = math.floor
    local MathAbs = math.abs
    local MathSin = math.sin
    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack
    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len
    local InstanceNew = Instance.new
    local RectNew = Rect.new
    local IsMobile = UserInputService.TouchEnabled or false

    -- Initialize Arcanum table
    for k, v in {
        Theme =  { },
        MenuKeybind = tostring(Enum.KeyCode.RightControl), 
        Flags = { },
        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Quad,
            Direction = Enum.EasingDirection.Out
        },
        FadeSpeed = 0.2,
        Folders = {
            Directory = "arcanum",
            Configs = "arcanum/Configs",
            Assets = "arcanum/Assets",
        },
        Pages = { },
        Sections = { },
        Connections = { },
        Threads = { },
        ThemeMap = { },
        ThemeItems = { },
        OpenFrames = { },
        SetFlags = { },
        UnnamedConnections = 0,
        UnnamedFlags = 0,
        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        Font = nil
    } do
        Arcanum[k] = v
    end

    Arcanum.__index = Arcanum
    Arcanum.Sections.__index = Arcanum.Sections
    Arcanum.Pages.__index = Arcanum.Pages

    -- Key mappings
    local Keys = {
        ["Unknown"] = "Unknown",
        ["Backspace"] = "Back",
        ["Tab"] = "Tab",
        ["Clear"] = "Clear",
        ["Return"] = "Return",
        ["Pause"] = "Pause",
        ["Escape"] = "Escape",
        ["Space"] = "Space",
        ["QuotedDouble"] = '"',
        ["Hash"] = "#",
        ["Dollar"] = "$",
        ["Percent"] = "%",
        ["Ampersand"] = "&",
        ["Quote"] = "'",
        ["LeftParenthesis"] = "(",
        ["RightParenthesis"] = " )",
        ["Asterisk"] = "*",
        ["Plus"] = "+",
        ["Comma"] = ",",
        ["Minus"] = "-",
        ["Period"] = ".",
        ["Slash"] = "`",
        ["Three"] = "3",
        ["Seven"] = "7",
        ["Eight"] = "8",
        ["Colon"] = ":",
        ["Semicolon"] = ";",
        ["LessThan"] = "<",
        ["GreaterThan"] = ">",
        ["Question"] = "?",
        ["Equals"] = "=",
        ["At"] = "@",
        ["LeftBracket"] = "LeftBracket",
        ["RightBracket"] = "RightBracked",
        ["BackSlash"] = "BackSlash",
        ["Caret"] = "^",
        ["Underscore"] = "_",
        ["Backquote"] = "`",
        ["LeftCurly"] = "{",
        ["Pipe"] = "|",
        ["RightCurly"] = "}",
        ["Tilde"] = "~",
        ["Delete"] = "Delete",
        ["End"] = "End",
        ["KeypadZero"] = "Keypad0",
        ["KeypadOne"] = "Keypad1",
        ["KeypadTwo"] = "Keypad2",
        ["KeypadThree"] = "Keypad3",
        ["KeypadFour"] = "Keypad4",
        ["KeypadFive"] = "Keypad5",
        ["KeypadSix"] = "Keypad6",
        ["KeypadSeven"] = "Keypad7",
        ["KeypadEight"] = "Keypad8",
        ["KeypadNine"] = "Keypad9",
        ["KeypadPeriod"] = "KeypadP",
        ["KeypadDivide"] = "KeypadD",
        ["KeypadMultiply"] = "KeypadM",
        ["KeypadMinus"] = "KeypadM",
        ["KeypadPlus"] = "KeypadP",
        ["KeypadEnter"] = "KeypadE",
        ["KeypadEquals"] = "KeypadE",
        ["Insert"] = "Insert",
        ["Home"] = "Home",
        ["PageUp"] = "PageUp",
        ["PageDown"] = "PageDown",
        ["RightShift"] = "RightShift",
        ["LeftShift"] = "LeftShift",
        ["RightControl"] = "RightControl",
        ["LeftControl"] = "LeftControl",
        ["LeftAlt"] = "LeftAlt",
        ["RightAlt"] = "RightAlt"
    }

    -- Theme presets
    local Themes = {
        ["Preset"] = {
            ["AccentGradient"] = FromRGB(0, 195, 255),
            ["Background 2"] = FromRGB(10, 10, 12),
            ["Background"] = FromRGB(12, 12, 14),
            ["Text"] = FromRGB(235, 235, 235),
            ["Outline"] = FromRGB(25, 25, 28),
            ["Section Top"] = FromRGB(28, 27, 31),
            ["Section Background"] = FromRGB(10, 10, 12),
            ["Section Background 2"] = FromRGB(14, 14, 16),
            ["Accent"] = FromRGB(0, 116, 224),
            ["Element"] = FromRGB(16, 16, 18)
        }
    }

    Arcanum.Theme = TableClone(Themes["Preset"])

    -- Create folders
    if HasFS then
        for Index, Value in Arcanum.Folders do 
            if not _isfolder(Value) then
                _makefolder(Value)
            end
        end
    end

    -- Tweening system
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Arcanum.Tween.Time, Arcanum.Tween.Style, Arcanum.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()
            setmetatable(NewTween, Tween)
            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 
            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 
            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Arcanum.Tween.Time, Arcanum.Tween.Style, Arcanum.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Arcanum:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end
            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end
            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end
            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end
            Tween:Pause()
            self = nil
        end
    end

    -- Instance management
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end
            Arcanum:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end
            Arcanum:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            if IsMobile then
                if Event == "MouseButton1Down" or Event == "MouseButton1Click" then 
                    Event = "TouchTap"
                elseif Event == "MouseButton2Down" or Event == "MouseButton2Click" then 
                    Event = "TouchLongPress"
                end
            end

            return Arcanum:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end
            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end
            return Arcanum:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end
            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end
        
            local Gui = self.Instance
            local Dragging = false 
            local DragStart
            local StartPosition 
        
            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                local NewX = StartPosition.X.Offset + DragDelta.X
                local NewY = StartPosition.Y.Offset + DragDelta.Y

                local ScreenSize = Gui.Parent.AbsoluteSize
                local GuiSize = Gui.AbsoluteSize
        
                NewX = MathClamp(NewX, 0, ScreenSize.X - GuiSize.X)
                NewY = MathClamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
        
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, NewX, 0, NewY)})
            end
        
            local InputChanged
        
            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = Input.Position
                    StartPosition = Gui.Position
        
                    if InputChanged then 
                        return
                    end
        
                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)
        
            Arcanum:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)
        
            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum, Window)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance
            local Resizing = false 
            local CurrentSide = nil
            local StartMouse = nil 
            local StartPosition = nil 
            local StartSize = nil
            local EdgeThickness = 2

            local MakeEdge = function(Name, Position, Size)
                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Size = Size,
                    Position = Position,
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })  
                Button:AddToTheme({BackgroundColor3 = "Accent"})
                return Button
            end

            local Edges = {
                {Button = MakeEdge("Left", UDim2New(0, 0, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "L"},
                {Button = MakeEdge("Right", UDim2New(1, -EdgeThickness, 0, 0), UDim2New(0, EdgeThickness, 1, 0)), Side = "R"},
                {Button = MakeEdge("Top", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, EdgeThickness)), Side = "T"},
                {Button = MakeEdge("Bottom", UDim2New(0, 0, 1, -EdgeThickness), UDim2New(1, 0, 0, EdgeThickness)), Side = "B"},
            }

            local BeginResizing = function(Side)
                Resizing = true 
                CurrentSide = Side 
                StartMouse = UserInputService:GetMouseLocation()
                StartPosition = Vector2New(Gui.Position.X.Offset, Gui.Position.Y.Offset)
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)
                
                for Index, Value in Edges do 
                    Value.Button:Tween(nil, {BackgroundTransparency = (Value.Side == Side) and 0 or 1})
                end
            end

            local EndResizing = function()
                Resizing = false 
                CurrentSide = nil

                for Index, Value in Edges do 
                    Value.Button.Instance.BackgroundTransparency = 1
                end
            end

            for Index, Value in Edges do 
                Value.Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        BeginResizing(Value.Side)
                    end
                end)
            end

            Arcanum:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Resizing then
                        EndResizing()
                    end
                end
            end)

            Arcanum:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then 
                    return 
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y
            
                local x, y = StartPosition.X, StartPosition.Y
                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    x = StartPosition.X + dx
                    w = StartSize.X - dx
                    if Window then Window.Left.Y = h end
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                    if Window then Window.Right.Y = h end
                elseif CurrentSide == "T" then
                    y = StartPosition.Y + dy
                    h = StartSize.Y - dy
                    if Window then Window.Top.X = w end
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                    if Window then Window.Bottom.X = w end
                end
            
                if w < Minimum.X then
                    if CurrentSide == "L" then x = x - (Minimum.X - w) end
                    w = Minimum.X
                end
                if h < Minimum.Y then
                    if CurrentSide == "T" then y = y - (Minimum.Y - h) end
                    h = Minimum.Y
                end
            
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2FromOffset(x, y)})
                self:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2FromOffset(w, h)})
            end)
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            return Arcanum:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            return Arcanum:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font system
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not (HasFiles and HasCustomAsset) then
                return nil
            end

            if not _isfile(Data.Id) then 
                _writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = _getcustomasset(Data.Id)
                    }
                }
            }

            _writefile(`{Arcanum.Folders.Assets}/{Name}.font`, HttpService:JSONEncode(FontData))
            return _getcustomasset(`{Arcanum.Folders.Assets}/{Name}.font`)
        end

        local SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        local Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        local Light = Font.new("rbxassetid://12187365364", Enum.FontWeight.Light, Enum.FontStyle.Normal)

        Arcanum.Fonts = {
            ["SemiBold"] = SemiBold,
            ["Regular"] = Regular,
            ["Light"] = Light
        }

        Arcanum.Font = SemiBold
    end

    -- Main GUI holders
    Arcanum.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "Arcanum",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Arcanum.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "Arcanum_Unused",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Arcanum.NotifHolder = Instances:Create("Frame", {
        Parent = Arcanum.Holder.Instance,
        Name = "Notifications",
        BackgroundTransparency = 1,
        Size = UDim2New(0, 0, 1, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    Instances:Create("UIListLayout", {
        Parent = Arcanum.NotifHolder.Instance,
        Name = "Layout",
        Padding = UDimNew(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Instances:Create("UIPadding", {
        Parent = Arcanum.NotifHolder.Instance,
        Name = "Padding",
        PaddingTop = UDimNew(0, 12),
        PaddingBottom = UDimNew(0, 12),
        PaddingRight = UDimNew(0, 12),
        PaddingLeft = UDimNew(0, 12)
    })    

    -- Core library functions
    Arcanum.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Arcanum = nil 
        getgenv().Arcanum = nil
    end

    Arcanum.GetImage = function(self, Image)
        local ImageData = self.Images[Image]
        if not ImageData then 
            return
        end
        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Arcanum.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Arcanum.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()
        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Arcanum.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Arcanum.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Arcanum:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Arcanum.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Arcanum.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Arcanum.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Arcanum.ToRich = function(self, Text, Color)
        return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>` 
    end

    Arcanum.GetConfig = function(self)
        local Config = { } 
        local Success, Result = Arcanum:SafeCall(function()
            for Index, Value in Arcanum.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Arcanum.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Arcanum:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Arcanum.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Arcanum.DeleteConfig = function(self, Config)
        if isfile(Arcanum.Folders.Configs .. "/" .. Config) then 
            delfile(Arcanum.Folders.Configs .. "/" .. Config)
        end
    end

    Arcanum.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Arcanum.Folders.Configs, Arcanum.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Arcanum.Folders.Configs) do
            local FileName = StringGSub(Value, Arcanum.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Arcanum.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Arcanum.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Arcanum.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance
        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Arcanum.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    Arcanum.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Arcanum.IsClipped = function(self, Object, Column)
        local Parent = Column
        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize 

        return Arcanum:CompareVectors(Top, BoundryTop) or Arcanum:CompareVectors(BoundryBottom, Bottom)
    end

    Arcanum.GetCalculatedRayPosition = function(self, Position, Normal, Origin, Direction)
        local N = Normal
        local D = Direction
        local V = Origin - Position

        local Number = (N.x * V.x) + (N.y * V.y) + (N.z * V.z)
        local Den = (N.x * D.x) + (N.y * D.y) + (N.z * D.z)
        local A = -Number / Den

        return Origin + (A * Direction)
    end

    Arcanum.UpdateText = function(self)
        for Index, Value in self.UnusedHolder.Instance:GetDescendants() do 
            if Value:IsA("TextLabel") or Value:IsA("TextButton") or Value:IsA("TextBox") then
                Value.FontFace = Arcanum.Font
            end
        end

        for Index, Value in self.Holder.Instance:GetDescendants() do 
            if Value:IsA("TextLabel") or Value:IsA("TextButton") or Value:IsA("TextBox") then
                Value.FontFace = Arcanum.Font
            end
        end
    end

    Arcanum.EscapePattern = function(self, String)
        local ShouldEscape = false 

        if string.match(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]") then
            ShouldEscape = true
        end

        if ShouldEscape then
            return StringGSub(String, "[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
        end

        return String
    end

    -- Window creation method
    Arcanum.Window = function(self, Data)
        Data = Data or {}
        
        local Window = {
            Name = Data.Name or "Window",
            SubName = Data.SubName or "",
            Logo = Data.Logo,
            Pages = {},
            Categories = {},
            IsOpen = false,
            CurrentPage = nil,
            Gui = nil,
            Root = nil,
            Title = nil
        }
        
        local ScreenGui = InstanceNew("ScreenGui")
        ScreenGui.Name = "\0"
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        ScreenGui.DisplayOrder = 2
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = gethui()

        local Root = InstanceNew("Frame")
        Root.Name = "\0"
        Root.Size = UDim2New(0, 520, 0, 340)
        Root.Position = UDim2New(0.5, -260, 0.5, -170)
        Root.BackgroundColor3 = Arcanum.Theme.Background
        Root.BorderSizePixel = 0
        Root.Parent = ScreenGui

        local Corner = InstanceNew("UICorner")
        Corner.CornerRadius = UDimNew(0, 10)
        Corner.Parent = Root

        local Stroke = InstanceNew("UIStroke")
        Stroke.Color = Arcanum.Theme.Outline
        Stroke.Thickness = 1
        Stroke.Parent = Root

        local Top = InstanceNew("Frame")
        Top.Name = "\0"
        Top.Size = UDim2New(1, 0, 0, 42)
        Top.BackgroundColor3 = Arcanum.Theme["Background 2"]
        Top.BorderSizePixel = 0
        Top.Parent = Root

        local TopCorner = InstanceNew("UICorner")
        TopCorner.CornerRadius = UDimNew(0, 10)
        TopCorner.Parent = Top

        local TopFix = InstanceNew("Frame")
        TopFix.Name = "\0"
        TopFix.Size = UDim2New(1, 0, 0, 12)
        TopFix.Position = UDim2New(0, 0, 1, -12)
        TopFix.BackgroundColor3 = Arcanum.Theme["Background 2"]
        TopFix.BorderSizePixel = 0
        TopFix.Parent = Top

        local Title = InstanceNew("TextLabel")
        Title.Name = "\0"
        Title.BackgroundTransparency = 1
        Title.Size = UDim2New(1, -16, 1, 0)
        Title.Position = UDim2New(0, 16, 0, 0)
        Title.FontFace = Arcanum.Font
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.TextSize = 16
        Title.TextColor3 = Arcanum.Theme.Text
        Title.Text = (Window.Name .. (Window.SubName ~= "" and ("  -  " .. Window.SubName) or ""))
        Title.Parent = Top

        Window.Gui = ScreenGui
        Window.Root = Root
        Window.Title = Title
        Root.Visible = false
        
        function Window:Page(Data)
            Data = Data or {}
            
            local Page = {
                Name = Data.Name or "Page",
                Icon = Data.Icon,
                Columns = Data.Columns or 1,
                Sections = {},
                Window = Window
            }
            
            function Page:Section(Data)
                Data = Data or {}
                
                local Section = {
                    Name = Data.Name or "Section",
                    Side = Data.Side or 1,
                    Description = Data.Description,
                    Icon = Data.Icon,
                    Elements = {},
                    Page = Page,
                    Window = Window
                }
                
                -- Component methods
                function Section:Toggle(Data)
                    Data = Data or {}
                    local Toggle = {
                        Name = Data.Name or "Toggle",
                        Flag = Data.Flag or Arcanum:NextFlag(),
                        Default = Data.Default or false,
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    Arcanum.Flags[Toggle.Flag] = Toggle.Default
                    Arcanum.SetFlags[Toggle.Flag] = function(Value)
                        Toggle.Value = Value
                        Arcanum.Flags[Toggle.Flag] = Value
                        if Toggle.Callback then
                            Arcanum:SafeCall(Toggle.Callback, Value)
                        end
                    end
                    
                    table.insert(self.Elements, Toggle)
                    return Toggle
                end
                
                function Section:Slider(Data)
                    Data = Data or {}
                    local Slider = {
                        Name = Data.Name or "Slider",
                        Flag = Data.Flag or Arcanum:NextFlag(),
                        Min = Data.Min or 0,
                        Max = Data.Max or 100,
                        Default = Data.Default or 50,
                        Suffix = Data.Suffix or "",
                        Decimals = Data.Decimals or 0,
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    Arcanum.Flags[Slider.Flag] = Slider.Default
                    Arcanum.SetFlags[Slider.Flag] = function(Value)
                        Slider.Value = Value
                        Arcanum.Flags[Slider.Flag] = Value
                        if Slider.Callback then
                            Arcanum:SafeCall(Slider.Callback, Value)
                        end
                    end
                    
                    table.insert(self.Elements, Slider)
                    return Slider
                end
                
                function Section:Dropdown(Data)
                    Data = Data or {}
                    local Dropdown = {
                        Name = Data.Name or "Dropdown",
                        Flag = Data.Flag or Arcanum:NextFlag(),
                        Items = Data.Items or {},
                        Multi = Data.Multi or false,
                        Default = Data.Default,
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    Arcanum.Flags[Dropdown.Flag] = Dropdown.Default
                    Arcanum.SetFlags[Dropdown.Flag] = function(Value)
                        Dropdown.Value = Value
                        Arcanum.Flags[Dropdown.Flag] = Value
                        if Dropdown.Callback then
                            Arcanum:SafeCall(Dropdown.Callback, Value)
                        end
                    end
                    
                    table.insert(self.Elements, Dropdown)
                    return Dropdown
                end
                
                function Section:Button(Data)
                    Data = Data or {}
                    local Button = {
                        Name = Data.Name or "Button",
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    table.insert(self.Elements, Button)
                    return Button
                end
                
                function Section:Textbox(Data)
                    Data = Data or {}
                    local Textbox = {
                        Name = Data.Name or "Textbox",
                        Flag = Data.Flag or Arcanum:NextFlag(),
                        Placeholder = Data.Placeholder or "",
                        Numeric = Data.Numeric or false,
                        Finished = Data.Finished or false,
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    Arcanum.Flags[Textbox.Flag] = ""
                    Arcanum.SetFlags[Textbox.Flag] = function(Value)
                        Textbox.Value = Value
                        Arcanum.Flags[Textbox.Flag] = Value
                        if Textbox.Callback then
                            Arcanum:SafeCall(Textbox.Callback, Value)
                        end
                    end
                    
                    table.insert(self.Elements, Textbox)
                    return Textbox
                end
                
                function Section:Keybind(Data)
                    Data = Data or {}
                    local Keybind = {
                        Name = Data.Name or "Keybind",
                        Flag = Data.Flag or Arcanum:NextFlag(),
                        Default = Data.Default,
                        Mode = Data.Mode or "Toggle",
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    Arcanum.Flags[Keybind.Flag] = {
                        Key = Keybind.Default,
                        Mode = Keybind.Mode,
                        Toggled = false
                    }
                    
                    table.insert(self.Elements, Keybind)
                    return Keybind
                end
                
                function Section:Colorpicker(Data)
                    Data = Data or {}
                    local Colorpicker = {
                        Name = Data.Name or "Colorpicker",
                        Flag = Data.Flag or Arcanum:NextFlag(),
                        Default = Data.Default or Color3.fromRGB(255, 255, 255),
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    Arcanum.Flags[Colorpicker.Flag] = Colorpicker.Default
                    Arcanum.SetFlags[Colorpicker.Flag] = function(Value)
                        Colorpicker.Value = Value
                        Arcanum.Flags[Colorpicker.Flag] = Value
                        if Colorpicker.Callback then
                            Arcanum:SafeCall(Colorpicker.Callback, Value)
                        end
                    end
                    
                    table.insert(self.Elements, Colorpicker)
                    return Colorpicker
                end
                
                function Section:Label(Data)
                    Data = Data or {}
                    local Label = {
                        Name = Data.Name or "Label",
                        RichText = Data.RichText or false,
                        Section = self
                    }
                    
                    table.insert(self.Elements, Label)
                    return Label
                end
                
                function Section:Listbox(Data)
                    Data = Data or {}
                    local Listbox = {
                        Name = Data.Name or "Listbox",
                        Flag = Data.Flag or Arcanum:NextFlag(),
                        Items = Data.Items or {},
                        Multi = Data.Multi or false,
                        Default = Data.Default,
                        Size = Data.Size or 125,
                        Callback = Data.Callback or function() end,
                        Section = self
                    }
                    
                    Arcanum.Flags[Listbox.Flag] = Listbox.Default
                    Arcanum.SetFlags[Listbox.Flag] = function(Value)
                        Listbox.Value = Value
                        Arcanum.Flags[Listbox.Flag] = Value
                        if Listbox.Callback then
                            Arcanum:SafeCall(Listbox.Callback, Value)
                        end
                    end
                    
                    table.insert(self.Elements, Listbox)
                    return Listbox
                end
                
                table.insert(self.Sections, Section)
                return Section
            end
            
            function Window:Category(Name)
                table.insert(self.Categories, Name)
                return self
            end
            
            table.insert(self.Pages, Page)
            return Page
        end
        
        function Window:Init()
            -- Initialize window
            Window.IsOpen = true
            if Window.Root then
                Window.Root.Visible = true
            end

            Arcanum:Connect(UserInputService.InputBegan, function(Input, GameProcessed)
                if GameProcessed then
                    return
                end

                if tostring(Input.KeyCode) == Arcanum.MenuKeybind then
                    Window.IsOpen = not Window.IsOpen
                    if Window.Root then
                        Window.Root.Visible = Window.IsOpen
                    end
                end
            end, "arcanum_menu_toggle")
        end
        
        return Window
    end
    
    -- Notification method
    Arcanum.Notification = function(self, Data)
        Data = Data or {}
        
        print("Notification:", Data.Title or "No Title", Data.Description or "No Description")
        
        -- Create notification GUI here
        -- This is a placeholder implementation
    end
    
    -- Keybind list method
    Arcanum.KeybindList = function(self, Name)
        local KeybindList = {
            Name = Name or "Keybinds",
            Items = {}
        }
        
        function KeybindList:Add(Name, Key)
            table.insert(self.Items, {Name = Name, Key = Key})
            return self
        end
        
        return KeybindList
    end

    -- Return the library
    return Arcanum
end

-- Return Arcanum for require compatibility
return Arcanum
