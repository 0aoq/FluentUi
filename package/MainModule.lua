--[[
================= 0aoq/FluentUi =================
LICENSED UNDER THE MIT LICENSE
OPEN SOURCE AT: https://github.com/0aoq/FluentUi
================= 0aoq/FluentUi =================
--]]

local TweenService = game:GetService("TweenService")

local _0aoq_fluent = {}; do
    _G.FluentUi = {
        name = "FluentUi",
        author = "0a_oq"
    }

    local CLASS_NAME = "FLUENT_UI_CLASS"

    -- types

    export type fluent_interface = { -- allow for auto complete while styling classes
        -- any
        BorderRadius: number,
        sizeX: number,
        sizeY: number,
        Pos: UDim2,
        Background: Color3,
        Opacity: number,
        Name: string,
        hidden: boolean,
        autoColor: boolean,

        -- flex
        isFlex: boolean,
        alignX: string,
        alignY: string,
        flexOrder: string,
        flexPadding: number,

        -- boxshadow
        BoxShadow: boolean,
        boxShadowStyle: number,
        boxShadowAlpha: number,

        -- padding
        Padding: boolean,
        PaddingTop: number,
        PaddingBottom: number,
        PaddingLeft: number,
        PaddingRight: number,

        -- border
        Border: boolean,
        BorderColor: Color3,
        BorderThickness: number,
        BorderOpacity: number,
        BorderJoinMode: string,
        BorderApplyMode: string,

        -- text
        Content: string,
        FontFamily: string | Enum.Font,
        Color: Color3,
        isRichText: boolean,
        ScaledFont: boolean,

        -- events
        onhover: any,
        onunhover: any,
        active: any,
        run: any,

        -- markup
        MARKUP_VALUE: string
    }

    export type fluent_component = {
        Name: string,
        Styles: fluent_interface
    }

    export type fluent_component_config = {
        componentName: string,
        name: string,
        type: string,
        container: any
    }

    -- file types
    export type fluent_file_content = {
        tag: string,
        typ: string,
        par: any, -- containing parent
        opt: any, -- function for extra styling
        con: {fluent_file_content}, -- extra markup within
        MARKUP_VALUE: string
    }

    export type fluent_file = {
        Name: string,
        Contents: {fluent_file_content}
    }

    -- module
    local util = {}; do
        util.PrintLines = function(lines: {string}) for _,x in pairs(lines) do print(x); end end
    end

    util.PrintLines({
        "===== 0aoq/FluentUi =====",
        "Render stream started!   ",
        "Components registered!   ",
        "===== 0aoq/FluentUi ====="
    })

    local internal = {}; do
        internal.styleSheet = {
            FluentButton = {
                Background = Color3.fromRGB(255, 255, 255);
                BorderRadius = 0.15;
                BoxShadow = true;
                ScaledFont = true;

                sizeX = 0.15;
                sizeY = 0.03;

                active = function(self)
                    TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0.2}):Play()
                    wait(0.04); TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0.1}):Play()
                end,

                onhover = function(self)
                    TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0.1}):Play()
                end, onunhover = function(self)
                    TweenService:Create(self, TweenInfo.new(0.05), {BackgroundTransparency = 0}):Play()
                end,
            },
            FluentCenter = {
                Opacity = 1;
                sizeX = 1;
                sizeY = 1;
                isFlex = true;
                alignX = "Center";
                alignY = "Center";
            },
            FluentEmpty = {Opacity = 1}
        }

        -- table of all values WITH A FUNCTION TO CALL
        internal.styles = {"BorderRadius", "isFlex", "BoxShadow", "Padding", "Border"}
        internal.markupStyles = {"<head>", "<title>", "<author>"} -- (render folders/string values)

        -- style functions
        internal.styleValues = {}; do
            internal.styleValues.isFlex = function(component, style) -- @fluent_style:isFlex
                style.flexOrder = style.flexOrder or "Name"; style.alignX = style.alignX or "Left"
                style.alignY = style.alignY or "Top"; style.flexPadding = style.flexPadding or 0

                if (not component:FindFirstChild("FLUENT_LIST_LAYOUT")) then
                    local UiListLayout = Instance.new("UIListLayout", component)
                    UiListLayout.Name = "FLUENT_LIST_LAYOUT"
                    UiListLayout.HorizontalAlignment = Enum.HorizontalAlignment[style.alignX]
                    UiListLayout.VerticalAlignment = Enum.VerticalAlignment[style.alignY]
                    UiListLayout.SortOrder = Enum.SortOrder[style.flexOrder]
                    UiListLayout.Padding = UDim.new(style.flexPadding or 0, 0)
                end
            end; internal.styleValues.BoxShadow = function(component, style) -- @fluent_style:BoxShadow
                local frame = Instance.new("Frame", component.Parent)
                component.Parent = frame
                frame.Name = component.Name
                frame.Size = component.Size
                frame.Position = component.Position
                frame.BackgroundTransparency = 1
                component.Size = UDim2.new(1, 0, 1, 0)
                component.Position = UDim2.new(0, 0, 0, 0)

                local boxshadow = Instance.new("ImageLabel", frame)

                style.boxShadowStyle = style.boxShadowStyle or 1
                if style.boxShadowStyle == 1 then
                    boxshadow.Image = "rbxassetid://6919135242"

                    if frame.Size.Y.Scale > 0.5 then
                        boxshadow.Size = component.Size + UDim2.new(0.3, 0, 0.4, 0)
                        boxshadow.ImageTransparency = style.boxShadowAlpha or 0
                    else -- normal box shadow doesn't look good with objects that are too small
                        boxshadow.Size = component.Size + UDim2.new(0.4, 0, 0.5, 0)
                        boxshadow.ImageTransparency = style.boxShadowAlpha or 0.5
                    end

                    boxshadow.Position = component.Position + UDim2.new(-0.2, 0, -0.2, 0)
                else
                    boxshadow.Image = "rbxassetid://6916236943"

                    if frame.Size.Y.Scale > 0.5 then
                        boxshadow.Size = component.Size + UDim2.new(0.2, 0, 0.2, 0)
                        boxshadow.ImageTransparency = style.boxShadowAlpha or 0
                    else -- normal box shadow doesn't look good with objects that are too small
                        boxshadow.Size = component.Size + UDim2.new(0.2, 0, 0.3, 0)
                        boxshadow.ImageTransparency = style.boxShadowAlpha or 0.65
                    end

                    boxshadow.Position = component.Position + UDim2.new(-0.1, 0, -0.1, 0)
                end

                boxshadow.Name = "BoxShadow"
                boxshadow.BackgroundTransparency = 1
                component.ZIndex = component.ZIndex + 1
                boxshadow.ZIndex = component.ZIndex - 1
                frame.ZIndex = component.ZIndex
            end; internal.styleValues.BorderRadius = function(component, style) -- @fluent_style:BorderRadius
                Instance.new("UICorner", component).CornerRadius = UDim.new(style.BorderRadius or 0, 0)
            end; internal.styleValues.Padding = function(component, style)
                local tempInstance = Instance.new("UIPadding", component); do
                    tempInstance.PaddingTop = UDim.new(style.PaddingTop, 0)
                    tempInstance.PaddingBottom = UDim.new(style.PaddingBottom, 0)

                    tempInstance.PaddingLeft = UDim.new(style.PaddingLeft, 0)
                    tempInstance.PaddingRight = UDim.new(style.PaddingRight, 0)
                end
            end; internal.styleValues.Border = function(component, style)
                local tempInstance = Instance.new("UIStroke", component); do
                    style.BorderApplyMode = style.BorderApplyMode or "Contextual"
                    style.BorderJoinMode = style.BorderJoinMode or "Round"

                    tempInstance.ApplyStrokeMode = Enum.ApplyStrokeMode[style.BorderApplyMode]
                    tempInstance.Thickness = style.BorderThickness or 1
                    tempInstance.Transparency = style.BorderOpacity or 0
                    tempInstance.Color = style.BorderColor or Color3.fromRGB(0, 0, 0)
                    tempInstance.LineJoinMode = Enum.LineJoinMode[style.BorderJoinMode]

                    tempInstance.Name = "FLUENT_UI_STROKE"
                end
            end
        end

        internal.styleComponent = function(component, style: fluent_interface)
            if (style == nil) then return end

            if (table.find(internal.markupStyles, component:GetAttribute(CLASS_NAME))) then
                if (not component:IsA("Folder") and component:IsA("StringValue")) then
                    if (component.Value == "") then 
                        component.Value = style.MARKUP_VALUE or '{"FLUENT_VALUE":"empty_object"}'; end
                end; return
            end

            -- Styles

            component.BackgroundColor3 = style.Background or component.BackgroundColor3
            component.Position = style.Pos or component.Position
            component.Name = style.Name or component.Name
            component.BackgroundTransparency = style.Opacity or component.BackgroundTransparency

            if (style.sizeX and style.sizeY) then -- set size
                component.Size = UDim2.new(style.sizeX , 0, style.sizeY, 0)
            end

            component.Visible = not style.hidden or not false

            for _,x in pairs(internal.styles) do
                if (style[x] == true or
                    typeof(style[x]) == "number")
                then 
                    internal.styleValues[x](component, style) 
                end
            end

            -- @this Handle button specific properties
            if (component:IsA("TextButton")) then
                component.MouseButton1Click:Connect(function()
                    if (style.active) then coroutine.wrap(style.active)(component, style); end
                end)

                component.AutoButtonColor = style.autoColor or false
            end

            -- @this Handle text related properties
            style.FontFamily = style.FontFamily or "SourceSans"
            if (component:IsA("TextLabel") or component:IsA("TextButton")) then
                component.RichText = style.isRichText or component.RichText
                component.Text = style.Content or component.Text
                component.TextScaled = style.ScaledFont or component.TextScaled
                component.TextColor3 = style.Color or component.TextColor3

                if (typeof(style.FontFamily) == "string") then
                    component.Font = Enum.Font[style.FontFamily]
                else
                    component.Font = style.FontFamily
                end
            end

            -- Events

            if (style.onhover) then
                component.MouseEnter:Connect(function()
                    coroutine.wrap(style.onhover)(component)
                end)
            end

            if (style.onunhover) then
                component.MouseLeave:Connect(function()
                    coroutine.wrap(style.onunhover)(component)
                end)
            end

            if (style.run) then
                coroutine.wrap(style.run)(Instance.new("LocalScript", component), component)
            end
        end
    end

    _0aoq_fluent.client = {}; do
        internal.renderedContainers = {}
        internal.components = {}

        _0aoq_fluent.bin = {}; do
            _0aoq_fluent.bin.getStyle = function(name: string)
                return internal.styleSheet[name]
            end
        end

        internal.scanContainer = function(container, styles, isComponent: boolean)
            if (styles ~= internal.styleSheet) then
                -- if (isComponent) then table.insert(internal.styleSheet, 1, styles) end
                table.insert(internal.renderedContainers, 1, container)
            end

            if (container == nil) then return warn("[Fluent]: Components cannot be mounted onto null containers") end
            for _,component in pairs(container:GetDescendants()) do
                if (not component:IsA("LocalScript")) then
                    internal.styleComponent(component, _0aoq_fluent.bin.getStyle(component:GetAttribute(CLASS_NAME)))
                end
            end
        end

        _0aoq_fluent.mount = function(container, styles) 
            styles = styles or {}
            internal.scanContainer(container, styles, false)
        end

        -- @function Returns a table of all elements that match a className
        _0aoq_fluent.getElementsByClassName = function(container, className)
            if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end
            local elements = {}

            for _,component in pairs(container:GetDescendants()) do
                if component:GetAttribute("FLUENT_UI_CLASS") == className then
                    table.insert(elements, 1, component)
                end
            end

            return elements
        end

        -- @function Get the element that is the specific number in the list
        _0aoq_fluent.nthChild = function(container, className, x, style)
            if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end
            for i,v in pairs(_0aoq_fluent.getElementsByClassName(container, className)) do
                if (i == x) then
                    internal.styleComponent(v, style)
                    v:SetAttribute("FLUENT_UI_CLASS", v:GetAttribute("FLUENT_UI_CLASS") .. i)
                end
            end
        end

        -- /// START SECTION: component handling
        _0aoq_fluent.client.components = {}; do
            _0aoq_fluent.client.components.createComponent = function(component: fluent_component)
                if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end

                for _,x in pairs(internal.renderedContainers) do
                    internal.components[component.Name] = component
                    internal.styleSheet[component.Name] = component.Styles

                    internal.scanContainer(x, internal.styleSheet, true)
                end
            end

            _0aoq_fluent.client.components.addComponent = function(
                componentConfig: fluent_component_config,
                interface_function: any,
                MARKUP_VALUE: string
            )
                if (not internal.styleSheet) then return warn("[Fluent]: Styles have not been rendered!") end

                local name = componentConfig.componentName

                if (name == "<head>") then 
                    componentConfig.type = "Folder"
                    componentConfig.name = "<fluent>" .. name .. "</fluent>"
                elseif (table.find(internal.markupStyles, name)) then 
                    componentConfig.type = "StringValue"
                    componentConfig.name = "<fluent>" .. name .. "</fluent>"
                end

                local __ = Instance.new(componentConfig.type, componentConfig.container)
                __.Name = componentConfig.name or "FLUENT_COMPONENT:" .. componentConfig.type
                __:SetAttribute("FLUENT_UI_CLASS", componentConfig.componentName)
                if (interface_function) then interface_function(__); end
                if (__:IsA("StringValue")) then __.Value = MARKUP_VALUE; end

                local style = _0aoq_fluent.bin.getStyle(componentConfig.name)
                internal.scanContainer(componentConfig.container, style, true)
                internal.styleComponent(__, style)

                return __
            end

            _0aoq_fluent.client.components.removeComponent = function(componentName: string)
                for _,x in pairs(internal.components) do
                    if (x == componentName) then
                        internal.components[x] = nil
                    end
                end
            end
        end
    end
    -- /// END SECTION: component handling

    _0aoq_fluent.client.test = function()
        local function ENCODE(json) return game:GetService("HttpService"):JSONEncode(json) end
        return ENCODE(internal.styleSheet), ENCODE(internal.components)
    end

    -- /// START SECTION: Markup

    _0aoq_fluent.file = {}; do
        local files = {}

        _0aoq_fluent.file.load = function(fileName: string)
            local file = files[fileName]; if (not file) then return warn("[Fluent]: File does not exist!"); end

            local pre = nil
            local function __(c)
                for _,x: fluent_file_content in pairs(c) do
                    if (x.par == "^") then x.par = pre; end
                    pre = _0aoq_fluent.client.components.addComponent({ -- create each component
                        componentName = x.tag or "FluentEmpty",
                        type = x.typ or "Frame",
                        container = x.par or nil
                    }, x.opt or function() end, x.MARKUP_VALUE or '{"FLUENT_VALUE":"empty_object"}')

                    if (x.con) then __(x.con); end -- create components for nested markup
                end
            end; __(file.Contents)
        end

        _0aoq_fluent.file.create = function(file: fluent_file) files[file.Name] = file; end
    end

    -- /// END SECTION: Markup
end; return _0aoq_fluent