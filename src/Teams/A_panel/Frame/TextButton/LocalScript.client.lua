
local closed = true


script.Parent.MouseButton1Click:connect(function()
	if closed == false then
		script.Parent.Parent.BackgroundTransparency = 1
		script.Parent.Parent.ScrollingFrame.Visible = false
		script.Parent.Text = "+"
		closed = true
	else
		script.Parent.Parent.BackgroundTransparency = 0.5
		script.Parent.Parent.ScrollingFrame.Visible = true
		script.Parent.Text = "X"
		closed = false
	end
end)