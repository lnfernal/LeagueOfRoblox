workspace:WaitForChild("Map")

local DATA = game:GetService("DataStoreService")
local KILLS_LB = DATA:GetOrderedDataStore("KillsLeaderboard")
local WINS_LB = DATA:GetOrderedDataStore("WinsLeaderboard")
local MAP = workspace.Map

function updateSurfaceGui(sg, dataStore, title)
	if not dataStore then return end
	
	for _, child in pairs(sg:GetChildren()) do
		child:Destroy()
	end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextStrokeTransparency = 0
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	
	local entries = 40
	local pages = dataStore:GetSortedAsync(false, entries)
	local data = pages:GetCurrentPage()
	
	local titleLabel = label:clone()
	titleLabel.Text = title
	titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
	titleLabel.Parent = sg
	
	local subFrame = Instance.new("Frame")
	subFrame.BackgroundTransparency = 1
	subFrame.Size = UDim2.new(1, 0, 0.9, 0)
	subFrame.Position = UDim2.new(0, 0, 0.1, 0)
	subFrame.Parent = sg
	
	local x = 0
	local y = 0
	for key, pair in pairs(data) do
		local frame = Instance.new("Frame")
		frame.Style = "RobloxRound"
		frame.Size = UDim2.new(0.5, 0, 1 / (entries / 2), 0)
		frame.Position = UDim2.new(x * frame.Size.X.Scale, 0, y * frame.Size.Y.Scale, 0)
		
		local keyLabel = label:clone()
		keyLabel.Text = "#"..key..": "..tostring(pair.key)
		keyLabel.Parent = frame
		
		local valLabel = label:clone()
		valLabel.Text = tostring(pair.value)
		valLabel.Position = UDim2.new(0.5, 0, 0, 0)
		valLabel.Parent = frame
		
		frame.Parent = subFrame
		
		y = y + 1
		if y >= (entries / 2) then
			y = 0
			x = x + 1
		end
	end
end

function updateLeaderboard(name, dataStore, title)
	for _, child in pairs(MAP:GetChildren()) do
		if child.Name == name then
			updateSurfaceGui(child.SurfaceGui, dataStore, title)
		end
	end
end

while true do
	updateLeaderboard("KillsLeaderboard", KILLS_LB, "Best Kills")
	updateLeaderboard("WinsLeaderboard", WINS_LB, "Best Wins")
	
	wait(30)
end