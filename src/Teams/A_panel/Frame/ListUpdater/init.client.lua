

function addPlayer(Player, pos)
	local frame = script:WaitForChild("FrameDefault"):Clone()
	
	frame.Position = UDim2.new(0,4,0,4+(pos*36))
	frame:WaitForChild("Player").Value = Player
	frame:WaitForChild("TLName").Text = Player.Name
	
	frame.Parent = script.Parent.ScrollingFrame
end


function updateList()
	script.Parent:WaitForChild("ScrollingFrame"):ClearAllChildren()
	local listplace = 0
	for _, player in pairs(game.Players:GetChildren()) do
		addPlayer(player, listplace)
		listplace = listplace+1
	end
	script.Parent.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,8+(#game.Players:GetChildren()*36))
end

updateList()

game.Players.ChildAdded:connect(function()
	updateList()
end)

game.Players.ChildRemoved:connect(function()
	updateList()
end)
