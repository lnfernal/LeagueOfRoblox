script.Parent:WaitForChild("ScreenGui")
local Remotes = game.ReplicatedStorage.Remotes
local RenderStepped = game:GetService("RunService").RenderStepped

local Frame, Text, Button = unpack(require(game.ReplicatedStorage.BaseGuis))
local ColorScheme = require(game.ReplicatedStorage.ColorScheme)
local CloseButton = false
local ScreenGui = script.Parent:FindFirstChild("ScreenGui")

function wslyTrackStacks(char, stackName)
	local statuses = char:WaitForChild("Statuses")
	
	local sizeX = 180
	local sizeY = 32
	
	local stackText = Text:Clone()
	stackText.Size = UDim2.new(0, sizeX, 0, sizeY)
	stackText.Position = UDim2.new(0, 0, 0.5, -stackText.Size.Y.Offset/2)
	stackText.Text = ""
	stackText.Parent = ScreenGui
	
	local stackBarFrame = Frame:Clone()
	stackBarFrame.Size = UDim2.new(0, sizeX, 0, sizeY/2)
	stackBarFrame.Position = stackText.Position + UDim2.new(0, 0, 0, stackText.Size.Y.Offset)
	stackBarFrame.BackgroundColor3 = ColorScheme.Dark
	stackBarFrame.Parent = ScreenGui
	
	local stackBar = Frame:Clone()
	stackBar.Size = UDim2.new(1, 0, 1, 0)
	stackBar.BackgroundColor3 = ColorScheme.Primary
	stackBar.Parent = stackBarFrame
	
	local function countStacks()
		local count = 0
		local maxTime = 0
		local timeLeft = 0
		for _, status in pairs(statuses:GetChildren()) do
			if status.Name == stackName then
				count = count + 1
				timeLeft = status.TimeLeft.Value
				maxTime = status.MaxTime.Value
			end
		end
		return count, timeLeft, maxTime
	end
	
	local function onStep()
		local stacks, timeLeft, maxTime = countStacks()
		
		if stacks > 0 then
			stackText.Text = string.format("Death Run: %d", stacks, timeLeft)
			stackBarFrame.Visible = true
			stackBar.Size = UDim2.new(timeLeft/maxTime, 0, 1, 0)
		else
			stackText.Text = ""
			stackBarFrame.Visible = false
		end
	end
	
	RenderStepped:connect(onStep)
end

--[[function ammoCount(var, current, max)
	print(var, current, max)
		if not ScreenGui:FindFirstChild("AmmoCount") then
			
			local sizeX = 180
			local sizeY = 32
			
			local stackText = Text:Clone()
			stackText.Size = UDim2.new(0, sizeX, 0, sizeY)
			stackText.Position = UDim2.new(0, 0, 0.5, -stackText.Size.Y.Offset/2)
			stackText.Text = ""
			stackText.Name = "AmmoCount"
			stackText.Parent = ScreenGui
		else
			ScreenGui.AmmoCount.Text = var.." / "..current
	end
end]]

function TrackCombo(tabl)
	if not ScreenGui:FindFirstChild("textlel") then
	local sizeX = 180
	local sizeY = 32
	tabl = tabl or {}
	local stackText = Text:Clone()
	stackText.Size = UDim2.new(0, sizeX, 0, sizeY)
	stackText.Position = UDim2.new(0, 0, 0.5, -stackText.Size.Y.Offset/2)
	stackText.Text = ""
	stackText.Parent = ScreenGui
	stackText.Name = "textlel"
	
	local stackBarFrame = Frame:Clone()
	stackBarFrame.Size = UDim2.new(0, sizeX, 0, sizeY/2)
	stackBarFrame.Position = stackText.Position + UDim2.new(0, 0, 0, stackText.Size.Y.Offset)
	stackBarFrame.BackgroundColor3 = ColorScheme.Dark
	stackBarFrame.Parent = ScreenGui
	stackBarFrame.Name = "stack"
	
	local List = Frame:Clone()
	List.Size = UDim2.new(0, sizeX + 50, 0, sizeY + 25)
	List.Position = List.Position + UDim2.new(0.35, 0, 0.5, stackText.Size.Y.Offset)
	List.BackgroundColor3 = ColorScheme.Dark
	List.Parent = ScreenGui
	List.Name = "List"
	List.Visible = false
	
	local ListCombos = Text:Clone()
	ListCombos.Size = UDim2.new(0, sizeX + 50, 0, sizeY + 25)
	ListCombos.Position = ListCombos.Position + UDim2.new(0.35, 0, 0.5, stackText.Size.Y.Offset)
	ListCombos.Text = "p/p/k 		p/p/u 		s/u/k 		p/k/u 		s/p/k/u/p/p"
	ListCombos.Parent = ScreenGui
	ListCombos.Name = "ListCombos"
	ListCombos.Visible = false
	
	local Combos = Button:Clone()
	Combos.Size = UDim2.new(0, sizeX, 0, sizeY/4)
	Combos.Position = stackText.Position + UDim2.new(0, 0, 0, stackText.Size.Y.Offset)
	Combos.BackgroundColor3 = ColorScheme.Dark
	Combos.Parent = ScreenGui
	Combos.Name = "Open"
	Combos.Text = "Combos"
	
	Combos.MouseButton1Click:connect(function()
if CloseButton == false then
CloseButton = true
ScreenGui.ListCombos.Visible = true
ScreenGui.List.Visible = true
		else
CloseButton = false
ScreenGui.ListCombos.Visible = false
ScreenGui.List.Visible = false
	end
end)
	local function onStep()
		if #tabl > 0 then
			stackText.Text = ""
			stackBarFrame.Visible = false
			for i,v in pairs(tabl) do
			stackText.Text = stackText.Text..""..v[1]	
			end
		else
			stackText.Text = ""
			stackBarFrame.Visible = false
		end
	end
	onStep()
	else
		if #tabl > 0 then
			ScreenGui.textlel.Text = ""
			ScreenGui.stack.Visible = false
			for i,v in pairs(tabl) do
			ScreenGui.textlel.Text = ScreenGui.textlel.Text..""..v[1]	
			
			end
		else
			ScreenGui.textlel.Text = ""
			ScreenGui.stack.Visible = false
		end
	end
	
end

function UnlockTrueDJ()
		if not ScreenGui:FindFirstChild("DJ") then
			
			
		local DJ = game.ReplicatedStorage.Items.DJ:Clone()
		DJ.Parent = ScreenGui
		local function moved()
		DJ.Frame:TweenPosition(UDim2.new(0.905, 0, .8, 0), "Out", "Quad", 1)	
		end
		local function moveend()
		DJ.Frame:TweenPosition(UDim2.new(1.09, 0, .8, 0), "Out", "Quad", 1)
		end
		DJ.Frame.MouseMoved:Connect(moved)
		DJ.Frame.MouseLeave:Connect(moveend)
		
		DJ.Frame.ID.FocusLost:Connect(function(enterPressed)
    	if enterPressed then
       	Remotes.UnlockTrueDJ:FireServer(DJ.Frame.ID.Text)
		DJ.Frame.ID.Text = "Place music ID here."
   		 end
		end)
		end
	end


Remotes.WslyTrackStacks.OnClientEvent:connect(wslyTrackStacks)
Remotes.UnlockTrueDJ.OnClientEvent:connect(UnlockTrueDJ)

--Remotes.PlaceBulletCount.OnClientEvent:connect(ammoCount)

Remotes.AverageTrackCOMBO.OnClientEvent:connect(TrackCombo)


