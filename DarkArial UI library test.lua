local UI = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "DarkArialUi library"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

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

function UI:CreateWindow(cfg)
	local Window = {}
	local Tabs = {}

	local Wind = Instance.new("Frame", gui)
	Wind.Size = UDim2.new(0, 536, 0, 320)
	Wind.Position = UDim2.new(0, 192, 0, 22)
	Wind.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Wind.BorderSizePixel = 0
	Instance.new("UICorner", Wind).CornerRadius = UDim.new(0,5)

	makeDraggable(Wind)

	local Title = Instance.new("TextLabel", Wind)
	Title.Size = UDim2.new(0,536,0,34)
	Title.BackgroundColor3 = Color3.fromRGB(55,55,55)
	Title.TextColor3 = Color3.fromRGB(255,255,255)
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
	Close.Position = UDim2.new(0,498,0,4)
	Close.Text = "X"
	Close.BackgroundTransparency = 1
	Close.TextColor3 = Color3.fromRGB(255,255,255)
	Close.Font = Enum.Font.SourceSansBold
	Close.TextSize = 24

	local TabsFrame = Instance.new("ScrollingFrame", Wind)
	TabsFrame.Size = UDim2.new(0,108,0,272)
	TabsFrame.Position = UDim2.new(0,6,0,40)
	TabsFrame.BackgroundColor3 = Color3.fromRGB(55,55,55)
	TabsFrame.ScrollBarThickness = 0
	TabsFrame.BorderSizePixel = 0
	Instance.new("UICorner", TabsFrame).CornerRadius = UDim.new(0,5)

	local Open = Instance.new("ImageButton", gui)
	Open.Size = UDim2.new(0,52,0,42)
	Open.Position = UDim2.new(0,32,0,16)
	Open.BackgroundTransparency = 1
	Open.Image = cfg.Icon or ""
	Open.ScaleType = Enum.ScaleType.Stretch
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

	-- PREVIEW
	function Window:AddPreview(cfg)
		local blur = Instance.new("BlurEffect", Lighting)
		blur.Size = 0

		local sg = Instance.new("ScreenGui", player.PlayerGui)

		local preview = Instance.new("Frame", sg)
		preview.Size = UDim2.new(0, 400, 0, 264)
		preview.Position = UDim2.new(0.5,-200,0.5,-132)
		preview.BackgroundColor3 = Color3.fromRGB(54,54,54)
		Instance.new("UICorner", preview)

		local title = Instance.new("TextLabel", preview)
		title.Size = UDim2.new(0,364,0,40)
		title.Position = UDim2.new(0,16,0,58)
		title.Text = ""
		title.TextColor3 = Color3.new(1,1,1)
		title.BackgroundTransparency = 1
		title.Font = Enum.Font.SourceSansBold
		title.TextSize = 24

		local subtitle = Instance.new("TextLabel", preview)
		subtitle.Size = UDim2.new(0,364,0,28)
		subtitle.Position = UDim2.new(0,16,0,96)
		subtitle.Text = ""
		subtitle.TextColor3 = Color3.new(1,1,1)
		subtitle.BackgroundTransparency = 1

		local function typeText(label, text)
			for i = 1, #text do
				label.Text = string.sub(text,1,i)
				task.wait(0.03)
			end
		end

		local function eraseText(label)
			for i = #label.Text,0,-1 do
				label.Text = string.sub(label.Text,1,i)
				task.wait(0.02)
			end
		end

		TweenService:Create(blur,TweenInfo.new(0.3),{Size=20}):Play()

		typeText(title, cfg.Title or "Title")
		typeText(subtitle, cfg.Subtitle or "Subtitle")

		task.wait(2)

		eraseText(subtitle)
		eraseText(title)

		TweenService:Create(blur,TweenInfo.new(0.3),{Size=0}):Play()

		task.wait(0.3)
		sg:Destroy()
		blur:Destroy()
	end

	function Window:AddTab(tabCfg)
		local Tab = {}
		local index = #Tabs

		local Button = Instance.new("TextButton", TabsFrame)
		Button.Size = UDim2.new(0,90,0,36)
		Button.Position = UDim2.new(0.5, -45, 0, index*42 + 6)
		Button.Text = tabCfg.TabName or "Tab"
		Button.BackgroundColor3 = Color3.fromRGB(208,0,0)
		Button.TextColor3 = Color3.fromRGB(255,255,255)
		Button.Font = Enum.Font.SourceSansBold
		Button.TextSize = 18
		Button.BorderSizePixel = 0
		Instance.new("UICorner", Button)

		updateCanvas(TabsFrame)

		local Page = Instance.new("ScrollingFrame", Wind)
		Page.Size = UDim2.new(0,410,0,272)
		Page.Position = UDim2.new(0,120,0,40)
		Page.BackgroundColor3 = Color3.fromRGB(55,55,55)
		Page.ScrollBarThickness = 0
		Page.Visible = false
		Instance.new("UICorner", Page)

		local offsetY = 6

		Button.MouseButton1Click:Connect(function()
			for _,v in pairs(Tabs) do
				v.Page.Visible = false
			end
			Page.Visible = true
		end)

		function Tab:AddToggle(cfg)
			local state = false
			local btn = Instance.new("TextButton", Page)
			btn.Size = UDim2.new(0,398,0,38)
			btn.Position = UDim2.new(0.5,-199,0,offsetY)
			btn.Text = cfg.Name.." : OFF"
			btn.BackgroundColor3 = Color3.fromRGB(208,0,0)
			Instance.new("UICorner", btn)

			offsetY += 44
			updateCanvas(Page)

			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = cfg.Name.." : "..(state and "ON" or "OFF")
				if cfg.Callback then cfg.Callback(state) end
			end)
		end

		function Tab:AddSlider(cfg)
			local value = cfg.Min or 0

			local frame = Instance.new("Frame", Page)
			frame.Size = UDim2.new(0,398,0,50)
			frame.Position = UDim2.new(0.5,-199,0,offsetY)
			frame.BackgroundColor3 = Color3.fromRGB(70,70,70)
			Instance.new("UICorner", frame)

			local bar = Instance.new("Frame", frame)
			bar.Size = UDim2.new(1,-10,0,6)
			bar.Position = UDim2.new(0,5,1,-12)
			bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
			Instance.new("UICorner", bar)

			local fill = Instance.new("Frame", bar)
			fill.Size = UDim2.new(0,0,1,0)
			fill.BackgroundColor3 = Color3.fromRGB(150,0,0)
			Instance.new("UICorner", fill)

			offsetY += 56
			updateCanvas(Page)

			bar.InputChanged:Connect(function(input)
				local pos = (input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X
				pos = math.clamp(pos,0,1)
				fill.Size = UDim2.new(pos,0,1,0)

				value = math.floor((cfg.Min or 0)+((cfg.Max or 100)-(cfg.Min or 0))*pos)
				if cfg.Callback then cfg.Callback(value) end
			end)
		end

		Tab.Page = Page
		table.insert(Tabs, Tab)

		if #Tabs == 1 then
			Page.Visible = true
		end

		return Tab
	end

	return Window
end

return UI