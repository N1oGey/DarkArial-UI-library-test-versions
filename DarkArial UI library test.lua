local UI = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DarkArialUi library"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- ================= THEMES =================
local Themes = {
	DefaultTheme = {
		Main = Color3.fromRGB(35,35,35),
		Top = Color3.fromRGB(55,55,55),
		Side = Color3.fromRGB(55,55,55),
		Element = Color3.fromRGB(133,133,133),
		Text = Color3.fromRGB(255,255,255),
		SubText = Color3.fromRGB(200,200,200),
		Input = Color3.fromRGB(116,116,116),
		Slider = Color3.fromRGB(100,100,100)
	},

	LightTheme = {
		Main = Color3.fromRGB(235,235,235),
		Top = Color3.fromRGB(255,255,255),
		Side = Color3.fromRGB(220,220,220),
		Element = Color3.fromRGB(180,180,180),
		Text = Color3.fromRGB(0,0,0),
		SubText = Color3.fromRGB(60,60,60),
		Input = Color3.fromRGB(210,210,210),
		Slider = Color3.fromRGB(170,170,170)
	},

	OceanTheme = {
		Main = Color3.fromRGB(15,40,60),
		Top = Color3.fromRGB(25,90,140),
		Side = Color3.fromRGB(25,90,140),
		Element = Color3.fromRGB(60,160,220),
		Text = Color3.fromRGB(255,255,255),
		SubText = Color3.fromRGB(180,220,255),
		Input = Color3.fromRGB(35,110,160),
		Slider = Color3.fromRGB(80,180,240)
	},

	GrapeTheme = {
		Main = Color3.fromRGB(40,20,70),
		Top = Color3.fromRGB(110,50,170),
		Side = Color3.fromRGB(110,50,170),
		Element = Color3.fromRGB(180,100,255),
		Text = Color3.fromRGB(255,255,255),
		SubText = Color3.fromRGB(220,180,255),
		Input = Color3.fromRGB(120,60,180),
		Slider = Color3.fromRGB(200,140,255)
	},

	CherryTheme = {
		Main = Color3.fromRGB(60,20,30),
		Top = Color3.fromRGB(170,50,90),
		Side = Color3.fromRGB(170,50,90),
		Element = Color3.fromRGB(240,90,140),
		Text = Color3.fromRGB(255,255,255),
		SubText = Color3.fromRGB(255,180,200),
		Input = Color3.fromRGB(180,70,100),
		Slider = Color3.fromRGB(255,120,160)
	}
}

local CurrentTheme = Themes.DefaultTheme

function UI:SetTheme(name)
	if Themes[name] then
		CurrentTheme = Themes[name]
	end
end

local function T()
	return CurrentTheme
end

-- ================= DRAG =================
local function makeDraggable(obj)
	local dragging = false
	local dragInput, startPos, startInputPos

	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startInputPos = input.Position
			startPos = obj.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	obj.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - startInputPos
			obj.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

local function updateCanvas(frame)
	local maxY = 0
	for _,v in pairs(frame:GetChildren()) do
		if v:IsA("GuiObject") then
			local bottom = v.Position.Y.Offset + v.Size.Y.Offset
			if bottom > maxY then
				maxY = bottom
			end
		end
	end
	frame.CanvasSize = UDim2.new(0,0,0,maxY + 10)
end

-- ================= WINDOW =================
function UI:CreateWindow(cfg)
	local Window = {}
	local Tabs = {}

	local Wind = Instance.new("Frame", gui)
	Wind.Size = UDim2.new(0, 536, 0, 320)
	Wind.Position = UDim2.new(0, 192, 0, 22)
	Wind.BackgroundColor3 = T().Main
	Wind.BorderSizePixel = 0
	Instance.new("UICorner", Wind).CornerRadius = UDim.new(0,5)

	makeDraggable(Wind)

	local Title = Instance.new("TextLabel", Wind)
	Title.Size = UDim2.new(1,0,0,34)
	Title.BackgroundColor3 = T().Top
	Title.TextColor3 = T().Text
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Text = cfg.Title or "Title"
	Title.Font = Enum.Font.SourceSansBold
	Title.TextSize = 18
	Title.BorderSizePixel = 0
	Instance.new("UICorner", Title).CornerRadius = UDim.new(0,5)

	local pad = Instance.new("UIPadding", Title)
	pad.PaddingLeft = UDim.new(0,7)

	local Close = Instance.new("TextButton", Title)
	Close.Size = UDim2.new(0,24,0,28)
	Close.Position = UDim2.new(1,-30,0,4)
	Close.Text = "X"
	Close.BackgroundTransparency = 1
	Close.TextColor3 = T().Text
	Close.Font = Enum.Font.SourceSansBold
	Close.TextSize = 24

	local TabsFrame = Instance.new("ScrollingFrame", Wind)
	TabsFrame.Size = UDim2.new(0,108,0,272)
	TabsFrame.Position = UDim2.new(0,6,0,40)
	TabsFrame.BackgroundColor3 = T().Side
	TabsFrame.ScrollBarThickness = 0
	TabsFrame.BorderSizePixel = 0
	Instance.new("UICorner", TabsFrame).CornerRadius = UDim.new(0,5)

	local Open = Instance.new("TextButton", gui)
	Open.Size = UDim2.new(0,52,0,42)
	Open.Position = UDim2.new(0,32,0,16)
	Open.Text = "P"
	Open.BackgroundColor3 = T().Side
	Open.TextColor3 = T().Text
	Open.Font = Enum.Font.SourceSansBold
	Open.TextSize = 24
	Instance.new("UICorner", Open).CornerRadius = UDim.new(0,5)

	makeDraggable(Open)
	Open.Visible = false

	Close.MouseButton1Click:Connect(function()
		Wind.Visible = false
		Open.Visible = true
	end)

	Open.MouseButton1Click:Connect(function()
		Wind.Visible = true
		Open.Visible = false
	end)

	-- ================= TAB =================
	function Window:AddTab(tabCfg)
		local Tab = {}
		local index = #Tabs

		local Button = Instance.new("TextButton", TabsFrame)
		Button.Size = UDim2.new(0,90,0,36)
		Button.Position = UDim2.new(0.5, -45, 0, index*42 + 6)
		Button.Text = tabCfg.TabName or "Tab"
		Button.BackgroundColor3 = T().Element
		Button.TextColor3 = T().Text
		Button.Font = Enum.Font.SourceSansBold
		Button.TextSize = 18
		Button.BorderSizePixel = 0
		Instance.new("UICorner", Button)

		local Page = Instance.new("ScrollingFrame", Wind)
		Page.Size = UDim2.new(0,410,0,272)
		Page.Position = UDim2.new(0,120,0,40)
		Page.BackgroundColor3 = T().Side
		Page.ScrollBarThickness = 0
		Page.BorderSizePixel = 0
		Page.Visible = false
		Instance.new("UICorner", Page)

		local offsetY = 6

		Button.MouseButton1Click:Connect(function()
			for _,v in pairs(Tabs) do
				v.Page.Visible = false
			end
			Page.Visible = true
		end)

		-- BUTTON
		function Tab:AddButton(cfg)
			local btn = Instance.new("TextButton", Page)
			btn.Size = UDim2.new(0,398,0,38)
			btn.Position = UDim2.new(0.5, -199, 0, offsetY)
			btn.Text = cfg.Name
			btn.BackgroundColor3 = T().Element
			btn.TextColor3 = T().Text
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 18
			Instance.new("UICorner", btn)

			offsetY += 44
			updateCanvas(Page)

			btn.MouseButton1Click:Connect(function()
				if cfg.Callback then cfg.Callback() end
			end)
		end

		-- LABEL
		function Tab:AddLabel(cfg)
			local lbl = Instance.new("TextLabel", Page)
			lbl.Size = UDim2.new(0,398,0,34)
			lbl.Position = UDim2.new(0.5, -199, 0, offsetY)
			lbl.Text = cfg.Text
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = T().SubText
			lbl.Font = Enum.Font.SourceSansBold
			lbl.TextSize = 18
			lbl.TextXAlignment = Enum.TextXAlignment.Left

			offsetY += 38
			updateCanvas(Page)
		end

		-- BOX
		function Tab:AddBox(cfg)
			local box = Instance.new("TextBox", Page)
			box.Size = UDim2.new(0,398,0,40)
			box.Position = UDim2.new(0.5, -199, 0, offsetY)

			box.BackgroundColor3 = T().Input
			box.TextColor3 = T().Text
			box.Text = ""
			box.PlaceholderText = cfg.Name or "Enter here..."
			box.Font = Enum.Font.SourceSansBold
			box.TextSize = 18

			Instance.new("UICorner", box)

			offsetY += 46
			updateCanvas(Page)

			return box
		end

		-- TOGGLE
		function Tab:AddToggle(cfg)
			local state = false

			local btn = Instance.new("TextButton", Page)
			btn.Size = UDim2.new(0,398,0,38)
			btn.Position = UDim2.new(0.5, -199, 0, offsetY)
			btn.Text = cfg.Name .. " : OFF"
			btn.BackgroundColor3 = T().Element
			btn.TextColor3 = T().Text
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 18
			Instance.new("UICorner", btn)

			offsetY += 44
			updateCanvas(Page)

			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = cfg.Name .. " : " .. (state and "ON" or "OFF")
				if cfg.Callback then cfg.Callback(state) end
			end)
		end

		-- SLIDER
		function Tab:AddSlider(cfg)
			local value = cfg.Min or 0

			local frame = Instance.new("Frame", Page)
			frame.Size = UDim2.new(0,398,0,50)
			frame.Position = UDim2.new(0.5, -199, 0, offsetY)
			frame.BackgroundColor3 = T().Slider
			frame.BorderSizePixel = 0
			Instance.new("UICorner", frame)

			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1,0,0,20)
			label.Text = cfg.Name .. ": " .. value
			label.BackgroundTransparency = 1
			label.TextColor3 = T().Text
			label.Font = Enum.Font.SourceSansBold
			label.TextSize = 18

			local bar = Instance.new("Frame", frame)
			bar.Size = UDim2.new(1,-10,0,6)
			bar.Position = UDim2.new(0,5,1,-12)
			Instance.new("UICorner", bar)

			local fill = Instance.new("Frame", bar)
			fill.Size = UDim2.new(0,0,1,0)
			fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Instance.new("UICorner", fill)

			offsetY += 56
			updateCanvas(Page)

			local dragging = false

			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
			end)

			bar.InputEnded:Connect(function() dragging = false end)

			bar.InputChanged:Connect(function(i)
				if not dragging then return end

				local pos = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
				pos = math.clamp(pos,0,1)

				fill.Size = UDim2.new(pos,0,1,0)
				value = math.floor((cfg.Min or 0) + ((cfg.Max or 100) - (cfg.Min or 0)) * pos)

				label.Text = cfg.Name .. ": " .. value
				if cfg.Callback then cfg.Callback(value) end
			end)
		end

		table.insert(Tabs, Tab)

		if #Tabs == 1 then
			Page.Visible = true
		end

		return Tab
	end

	return Window
end

return UI