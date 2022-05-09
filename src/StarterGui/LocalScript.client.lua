local images = {"rbxasset://textures/ui/Chat/ChatDown@2x.png","rbxasset://textures/ui/Chat/Chat@2x.png"}
local selected = 1
local Chat = script.Parent:WaitForChild("Chat")
local button = Instance.new("ImageButton")
button.Parent = Chat.DestroyGuardFrame
button.BackgroundTransparency = 1
button.Position = UDim2.new(0.01, 0,0.3, 0)
Chat.DestroyGuardFrame.Frame.Position = UDim2.new(0,0,0,0)
button.Size = UDim2.new(0.02, 0,0.04, 0)
button.Image = images[selected]
button.MouseButton1Click:connect(function()
	selected = selected + 1
	if selected > 2 then
		selected = 1
		button.Image = images[selected]
	else
		button.Image = images[selected]
	end
	Chat.DestroyGuardFrame.Frame.Visible = not Chat.DestroyGuardFrame.Frame.Visible
end)