local UI = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

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

	local Open = Instance.new("TextButton", gui)
	Open.Size = UDim2.new(0,52,0,42)
	Open.Position = UDim2.new(0,32,0,16)
	Open.Text = "P"
	Open.BackgroundColor3 = Color3.fromRGB(55,55,55)
	Open.TextColor3 = Color3.fromRGB(255,255,255)
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

	function Window:AddTab(tabCfg)
		local Tab = {}
		local index = #Tabs

		local Button = Instance.new("TextButton", TabsFrame)
		Button.Size = UDim2.new(0,90,0,36)
		Button.Position = UDim2.new(0.5, -45, 0, index*42 + 6)
		Button.Text = tabCfg.TabName or "Tab"
		Button.BackgroundColor3 = Color3.fromRGB(133,133,133)
		Button.TextColor3 = Color3.fromRGB(255,255,255)
		Button.Font = Enum.Font.SourceSansBold
		Button.TextSize = 18
		Button.BorderSizePixel = 0
		Instance.new("UICorner", Button).CornerRadius = UDim.new(0,5)

		updateCanvas(TabsFrame)

		local Page = Instance.new("ScrollingFrame", Wind)
		Page.Size = UDim2.new(0,410,0,272)
		Page.Position = UDim2.new(0,120,0,40)
		Page.BackgroundColor3 = Color3.fromRGB(55,55,55)
		Page.ScrollBarThickness = 0
		Page.BorderSizePixel = 0
		Page.Visible = false
		Instance.new("UICorner", Page).CornerRadius = UDim.new(0,5)

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
			btn.Position = UDim2.new(0.5, -199, 0, offsetY)
			btn.Text = cfg.Name .. " : OFF"
			btn.BackgroundColor3 = Color3.fromRGB(133,133,133)
			btn.TextColor3 = Color3.fromRGB(255,255,255)
			btn.Font = Enum.Font.SourceSansBold
			btn.TextSize = 18
			btn.BorderSizePixel = 0
			Instance.new("UICorner", btn)

			offsetY += 44
			updateCanvas(Page)

			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = cfg.Name .. " : " .. (state and "ON" or "OFF")
				if cfg.Callback then
					cfg.Callback(state)
				end
			end)
		end

		function Tab:AddSlider(cfg)
			local value = cfg.Min or 0

			local frame = Instance.new("Frame", Page)
			frame.Size = UDim2.new(0,398,0,50)
			frame.Position = UDim2.new(0.5, -199, 0, offsetY)
			frame.BackgroundColor3 = Color3.fromRGB(70,70,70)
			frame.BorderSizePixel = 0
			Instance.new("UICorner", frame)

			local bar = Instance.new("Frame", frame)
			bar.Size = UDim2.new(1,-10,0,6)
			bar.Position = UDim2.new(0,5,1,-12)
			bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
			Instance.new("UICorner", bar)

			local fill = Instance.new("Frame", bar)
			fill.Size = UDim2.new(0,0,1,0)
			fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Instance.new("UICorner", fill)

			local label = Instance.new("TextLabel", frame)
			label.Size = UDim2.new(1,0,0,20)
			label.BackgroundTransparency = 1
			label.Text = cfg.Name .. ": " .. value
			label.TextColor3 = Color3.fromRGB(255,255,255)

			offsetY += 56
			updateCanvas(Page)

			local dragging = false

			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			UIS.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UIS.InputChanged:Connect(function(input)
				if dragging then
					local pos = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
					pos = math.clamp(pos,0,1)

					fill.Size = UDim2.new(pos,0,1,0)

					value = math.floor((cfg.Min or 0) + (cfg.Max or 100 - (cfg.Min or 0)) * pos)
					label.Text = cfg.Name .. ": " .. value

					if cfg.Callback then
						cfg.Callback(value)
					end
				end
			end)
		end

		function Tab:AddColorPicker(cfg)
			local frame = Instance.new("Frame", Page)
			frame.Size = UDim2.new(0,398,0,120)
			frame.Position = UDim2.new(0.5, -199, 0, offsetY)
			frame.BackgroundColor3 = Color3.fromRGB(70,70,70)
			frame.BorderSizePixel = 0
			Instance.new("UICorner", frame)

			local preview = Instance.new("Frame", frame)
			preview.Size = UDim2.new(0,40,0,40)
			preview.Position = UDim2.new(0,5,0,5)
			preview.BackgroundColor3 = Color3.new(1,0,0)

			local r,g,b = 255,0,0

			local function update()
				local color = Color3.fromRGB(r,g,b)
				preview.BackgroundColor3 = color
				if cfg.Callback then
					cfg.Callback(color)
				end
			end

			local function makeSlider(y,name,val,set)
				local s = Instance.new("TextBox", frame)
				s.Size = UDim2.new(0,120,0,25)
				s.Position = UDim2.new(0,50,0,y)
				s.Text = name..":"..val
				s.BackgroundColor3 = Color3.fromRGB(100,100,100)

				s.FocusLost:Connect(function()
					local num = tonumber(s.Text:match("%d+")) or val
					num = math.clamp(num,0,255)
					set(num)
					update()
				end)
			end

			makeSlider(5,"R",r,function(v) r=v end)
			makeSlider(35,"G",g,function(v) g=v end)
			makeSlider(65,"B",b,function(v) b=v end)

			offsetY += 126
			updateCanvas(Page)
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