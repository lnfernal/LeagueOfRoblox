wait()
pcall(function()
	local starterGui = game:GetService('StarterGui')
	starterGui:SetCore("TopbarEnabled", false)
end)
game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage",{
	Text = "Welcome to: League Of ROBLOX!";
	Color = Color3.new(1,1,1); 
	Font = Enum.Font.SourceSans; 
	FontSize = Enum.FontSize.Size24; 
})



local QUEUE = {}
local CURRENT = nil
local SIZE_X = 0.4
local SIZE_Y = 0.06
local DISP_Y = 0

function playAll()
	current = QUEUE[1]
	while current do
		display(current)
		table.remove(QUEUE, 1)
		current = QUEUE[1]
	end
end

function display(data)
	local frame = Instance.new("Frame")
	frame.Style = "RobloxRound"
	frame.Size = UDim2.new(SIZE_X, 0, SIZE_Y, 0)
	frame.Position = UDim2.new(-SIZE_X, 0, -SIZE_Y, 0)
	frame.Parent = script.Parent.ScreenGui
	
	local title = Instance.new("TextLabel")
	title.TextScaled = true
	title.BackgroundTransparency = 1
	title.TextStrokeTransparency = 0
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Size = UDim2.new(1, 0, 0.5, 0)
	title.Text = data.Title
	title.Parent = frame
	
	local content = title:clone()
	content.Size = UDim2.new(1, 0, 0.5, 0)
	content.Position = UDim2.new(0, 0, 0.5, 0)
	content.Text = data.Content
	content.Parent = frame
	
	title.TextColor3 = data.TitleColor
	
	frame:TweenPosition(UDim2.new((1 - SIZE_X) / 2, 0, DISP_Y, 0))
	wait(1)
	wait(data.Duration)
	frame:TweenPosition(UDim2.new(-SIZE_X, 0, DISP_Y, 0))
	wait(1)
	frame:Destroy()
end

local re = game.ReplicatedStorage.Remotes.Message
re.OnClientEvent:connect(function(data)
	table.insert(QUEUE, data)
	if not current then
		playAll()
	end
end)

local me = game.ReplicatedStorage.Remotes.ShowMessage
me.OnClientEvent:connect(function(data)
	game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage",data)
end)