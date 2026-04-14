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

-- DRAG SYSTEM
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

function UI:CreateWindow(cfg)
	local Window = {}
	local Tabs = {}

	-- WINDOW
	local Wind = Instance.new("Frame", gui)
	Wind.Size = UDim2.new(0, 536, 0, 320)
	Wind.Position = UDim2.new(0, 192, 0, 22)
	Wind.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Wind.BorderSizePixel = 0
	Instance.new("UICorner", Wind).CornerRadius = UDim.new(0,5)

	makeDraggable(Wind)

	-- TITLE
	local Title = Instance.new("TextLabel", Wind)
	Title.Size = UDim2.new(1,0,0,34)
	Title.BackgroundColor3 = Color3.fromRGB(55,55,55)
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Text = cfg.Title or "Title"
	Title.Font = Enum.Font.SourceSansBold
	Title.TextSize = 18
	Instance.new("UICorner", Title)

	local pad = Instance.new("UIPadding", Title)
	pad.PaddingLeft = UDim.new(0,7)

	-- CLOSE
	local Close = Instance.new("TextButton", Title)
	Close.Size = UDim2.new(0,24,0,24)
	Close.Position = UDim2.new(1,-30,0,5)
	Close.Text = "X"
	Close.BackgroundTransparency = 1
	Close.TextColor3 = Color3.new(1,1,1)

	-- TABS
	local TabsFrame = Instance.new("ScrollingFrame", Wind)
	TabsFrame.Size = UDim2.new(0,108,0,272)
	TabsFrame.Position = UDim2.new(0,6,0,40)
	TabsFrame.BackgroundColor3 = Color3.fromRGB(55,55,55)
	TabsFrame.ScrollBarThickness = 0
	TabsFrame.BorderSizePixel = 0

	-- OPEN BUTTON
	local Open = Instance.new("ImageButton", gui)
	Open.Size = UDim2.new(0,52,0,42)
	Open.Position = UDim2.new(0,32,0,16)
	Open.BackgroundTransparency = 1
	Open.Image = cfg.Icon or ""
	Open.ScaleType = Enum.ScaleType.Stretch

	makeDraggable(Open)
	Open.Visible = false

	-- OPEN / CLOSE
	Close.MouseButton1Click:Connect(function()
		Wind.Visible = false
		Open.Visible = true
	end)

	Open.MouseButton1Click:Connect(function()
		Wind.Visible = true
		Open.Visible = false
	end)

	------------------------------------------------
	-- PREVIEW FIXED
	------------------------------------------------
	function Window:AddPreview(cfg)
		task.spawn(function()
			local blur = Instance.new("BlurEffect", Lighting)
			blur.Size = 0

			local sg = Instance.new("ScreenGui", player.PlayerGui)

			local frame = Instance.new("Frame", sg)
			frame.Size = UDim2.new(0,400,0,264)
			frame.Position = UDim2.new(0.5,-200,0.5,-132)
			frame.BackgroundColor3 = Color3.fromRGB(54,54,54)
			Instance.new("UICorner", frame)

			local t = Instance.new("TextLabel", frame)
			t.Size = UDim2.new(1,0,0,40)
			t.Position = UDim2.new(0,0,0,60)
			t.Text = cfg.Title or "Title"
			t.BackgroundTransparency = 1
			t.TextColor3 = Color3.new(1,1,1)
			t.Font = Enum.Font.SourceSansBold
			t.TextSize = 24

			local s = Instance.new("TextLabel", frame)
			s.Size = UDim2.new(1,0,0,30)
			s.Position = UDim2.new(0,0,0,100)
			s.Text = cfg.Subtitle or "Subtitle"
			s.BackgroundTransparency = 1
			s.TextColor3 = Color3.new(1,1,1)

			TweenService:Create(blur, TweenInfo.new(0.25), {Size = 20}):Play()

			task.wait(2)

			TweenService:Create(blur, TweenInfo.new(0.25), {Size = 0}):Play()

			task.wait(0.3)

			sg:Destroy()
			blur:Destroy()
		end)
	end

	------------------------------------------------
	-- TAB SYSTEM FIXED
	------------------------------------------------
	function Window:AddTab(tabCfg)
		local Tab = {}
		local index = #Tabs

		local Btn = Instance.new("TextButton", TabsFrame)
		Btn.Size = UDim2.new(1,0,0,36)
		Btn.Text = tabCfg.TabName or "Tab"
		Btn.BackgroundColor3 = Color3.fromRGB(208,0,0)
		Btn.TextColor3 = Color3.new(1,1,1)

		local Page = Instance.new("ScrollingFrame", Wind)
		Page.Size = UDim2.new(0,410,0,272)
		Page.Position = UDim2.new(0,120,0,40)
		Page.BackgroundColor3 = Color3.fromRGB(55,55,55)
		Page.ScrollBarThickness = 0
		Page.Visible = false

		Btn.MouseButton1Click:Connect(function()
			for _,v in pairs(Tabs) do
				v.Page.Visible = false
			end
			Page.Visible = true
		end)

		local y = 6

		------------------------------------------------
		-- BUTTON
		------------------------------------------------
		function Tab:AddButton(cfg)
			local b = Instance.new("TextButton", Page)
			b.Size = UDim2.new(0,398,0,38)
			b.Position = UDim2.new(0,6,0,y)
			b.Text = cfg.Name or "Button"
			b.BackgroundColor3 = Color3.fromRGB(208,0,0)
			b.TextColor3 = Color3.new(1,1,1)

			y += 44

			b.MouseButton1Click:Connect(function()
				if cfg.Callback then cfg.Callback() end
			end)
		end

		------------------------------------------------
		-- LABEL
		------------------------------------------------
		function Tab:AddLabel(cfg)
			local l = Instance.new("TextLabel", Page)
			l.Size = UDim2.new(0,398,0,34)
			l.Position = UDim2.new(0,6,0,y)
			l.Text = cfg.Text or "Label"
			l.BackgroundTransparency = 1
			l.TextColor3 = Color3.new(1,1,1)

			y += 38
		end

		------------------------------------------------
		-- BOX
		------------------------------------------------
		function Tab:AddBox(cfg)
			local box = Instance.new("TextBox", Page)
			box.Size = UDim2.new(0,398,0,40)
			box.Position = UDim2.new(0,6,0,y)
			box.PlaceholderText = cfg.Name or "Enter here..."
			box.BackgroundColor3 = Color3.fromRGB(150,0,0)
			box.TextColor3 = Color3.new(1,1,1)

			y += 46
			return box
		end

		------------------------------------------------
		-- TOGGLE
		------------------------------------------------
		function Tab:AddToggle(cfg)
			local state = false

			local b = Instance.new("TextButton", Page)
			b.Size = UDim2.new(0,398,0,38)
			b.Position = UDim2.new(0,6,0,y)
			b.Text = cfg.Name.." : OFF"
			b.BackgroundColor3 = Color3.fromRGB(208,0,0)
			b.TextColor3 = Color3.new(1,1,1)

			y += 44

			b.MouseButton1Click:Connect(function()
				state = not state
				b.Text = cfg.Name.." : "..(state and "ON" or "OFF")
				if cfg.Callback then cfg.Callback(state) end
			end)
		end

		------------------------------------------------
		-- SLIDER FIXED
		------------------------------------------------
		function Tab:AddSlider(cfg)
			local value = cfg.Min or 0

			local frame = Instance.new("Frame", Page)
			frame.Size = UDim2.new(0,398,0,50)
			frame.Position = UDim2.new(0,6,0,y)
			frame.BackgroundColor3 = Color3.fromRGB(70,70,70)

			local bar = Instance.new("Frame", frame)
			bar.Size = UDim2.new(1,-10,0,6)
			bar.Position = UDim2.new(0,5,1,-12)
			bar.BackgroundColor3 = Color3.fromRGB(100,100,100)

			local fill = Instance.new("Frame", bar)
			fill.Size = UDim2.new(0,0,1,0)
			fill.BackgroundColor3 = Color3.fromRGB(150,0,0)

			y += 56

			local dragging = false

			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			bar.InputEnded:Connect(function()
				dragging = false
			end)

			bar.InputChanged:Connect(function(i)
				if not dragging then return end

				local pos = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
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