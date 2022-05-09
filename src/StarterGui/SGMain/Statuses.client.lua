--the player
local Player = game.Players.LocalPlayer
--our screen gui
local ScreenGui = script.Parent
--remotes
local R = game.ReplicatedStorage.Remotes
--game state
local gameState = game.ReplicatedStorage.GameState
--base guis
local Frame, Text, Button = unpack(require(game.ReplicatedStorage.BaseGuis))
--the color scheme
local ColorScheme = require(game.ReplicatedStorage.ColorScheme)
--this container holds all of the gui elements
local Gui = {}
--this global holds a position offset for anything in the bottom-left corner
local BottomLeftOffset = UDim2.new(0, 0, 0, -50)
--this global holds the player state, and remains empty until acquired
local PlayerState
--this global holds the mouse-over box
local MouseOverBox = nil
local MouseOveritem = nil
--this global holds the mouse
local Mouse = Player:GetMouse()
local GUI = {}
--this function returns the thumbnail of an asset
local getThumbnail = require(game.ReplicatedStorage.GetThumbnail)
local Character = Player.Character
local STATUSES = Character:WaitForChild("Statuses")
print("hello")
--this function returns a value from the player state
local function playerGet(key)
	local val = PlayerState:FindFirstChild(key)
	if val then
		return val.Value
	end
	return nil
end
local function trunc(num, places)
	num = num or 0
	places = places or 0
	
	return math.floor(num * 10 ^ places) / 10 ^ places
end
function getTimeString(t)
	local minutes = math.floor(t / 60)
	local seconds = math.floor(t - minutes * 60)
	if seconds < 10 then
		seconds = "0"..seconds
	end
	
	return minutes..":"..seconds
end
local function inset(element, amount)
	element.Position = element.Position + UDim2.new(0, amount, 0, amount)
	element.Size = element.Size + UDim2.new(0, -(amount * 2), 0, -(amount * 2))
end

--this function clears the mouse over box
local function endMouseOver()
	if MouseOverBox then
		MouseOverBox:Destroy()
	end
end

--this function returns whether or not a table contains a value
local function contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end

--this function generates a new mouse over box
local function startMouseOver(x, y, t)
	endMouseOver()
	
	local frame = Frame:Clone()
	frame.Size = UDim2.new(0.3, 0, 0.2, 0)
	local dy = -(ScreenGui.AbsoluteSize.Y * frame.Size.Y.Scale)
	frame.Position = UDim2.new(0, x, 0, y + dy)
	frame.BackgroundColor3 = ColorScheme.Quaternary
	frame.BorderColor3 = ColorScheme.Dark
	frame.ZIndex = 10
	MouseOverBox = frame
	frame.Parent = ScreenGui
	
	local text = Text:Clone()
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Text = t
	text.Size = UDim2.new(1, 0, 1, 0)
	text.ZIndex = 10
	text.Parent = frame
	inset(text, 4)
		
	if frame.AbsolutePosition.X + frame.AbsoluteSize.X > ScreenGui.AbsoluteSize.X then
		frame.Position = frame.Position + UDim2.new(0, -frame.AbsoluteSize.X, 0, 0)
	end
end
local function mouseOver(element, moved)
	element.MouseMoved:connect(moved)
	element.MouseLeave:connect(endMouseOver)
end
local function getData(st)
	local x = ""
	local y = ""
	local z = ""
	local w = ""
	if st:FindFirstChild("Amount") then
		x = st:FindFirstChild("Amount").Value 
	end
	if st:FindFirstChild("MaxTime") then
		y = st:FindFirstChild("MaxTime").Value 
	end
	if st:FindFirstChild("Stat") then
		z = st:FindFirstChild("Stat").Value 
	end
	return st.Name.."\n\n"..tostring(x).."\n\n"..tostring(z).."\n\n"..tostring(y)
end
local function constructStatusGUI()
	local x = -1
	local y = 0
	ScreenGui.StatusesKeeper:ClearAllChildren()
	endMouseOver()
	for i,v in pairs(STATUSES:GetChildren()) do
		x = x + 1
		if x >= 4 then
			y = y + 1
			x = 0
		end
	local frame = Instance.new("ImageLabel")
	frame.Name = v.Name
	frame.Size = UDim2.new(0.025, 0, 0.05, 0)
	frame.Position = UDim2.new(0.8 + x/30, 0, .87 - y/20, 0) + BottomLeftOffset
	frame.BackgroundTransparency = 0
	frame.Parent = ScreenGui.StatusesKeeper
	
	inset(frame, 4)
	mouseOver(frame, function(x, y)
					startMouseOver(x, y, getData(v))
				end)
	
		frame.Image = getThumbnail(v:WaitForChild("Icon").Value)
	
	end
end
local function RemoveStatuses(s)
	local x = -1
	local y = 0
	ScreenGui.StatusesKeeper:ClearAllChildren()
	endMouseOver()
	
	for i,v in pairs(STATUSES:GetChildren()) do
		x = x + 1
		if x >= 3 then
			y = y + 1
			x = 0
		end
	local frame = Instance.new("ImageLabel")
	frame.Name = v.Name
	frame.Size = UDim2.new(0.025, 0, 0.05, 0)
	frame.Position = UDim2.new(0.8 + x/30, 0, .87 - y/20, 0) + BottomLeftOffset
	frame.BackgroundTransparency = 0
	frame.Parent = ScreenGui.StatusesKeeper
	inset(frame, 4)
	mouseOver(frame, function(x, y)
					startMouseOver(x, y, getData(v))
				end)
	
		frame.Image = getThumbnail(v:WaitForChild("Icon").Value)
	

	end
end
STATUSES.ChildAdded:connect(constructStatusGUI)
STATUSES.ChildRemoved:connect(RemoveStatuses)