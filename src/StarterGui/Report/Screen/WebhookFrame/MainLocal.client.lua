Report = game.ReplicatedStorage.Remotes.Report

local plr = game.Players.LocalPlayer
local Main = script.Parent
local Submit = Main.Submit
local Box = Main.Box
local Left = Main.LeftArrow
local Right = Main.RightArrow
local selected = false
local types = {
	"https://discordapp.com/api/webhooks/253464423060996096/J_lXuMYt26scEPaVQ8RlCW2prCRgqQ99GRo3CPhEanKCHuGqltc2kzHI_7bAdBhlCJaO",
	"https://discordapp.com/api/webhooks/253464142592081920/y_mc-tXwg7oycmGzAplULFURz-UKj8nubHqE3k1TL5WrI0QpEKfzY_QdxtXGvwIlFSGl",
	"https://discordapp.com/api/webhooks/253464485472239617/IZ23o5mjV9271wrdKhwDg_kglqvKkKJxKr01H5yrrwyaL_9rDB9Ye3IXoMqyberHJNt4"
}
local typenames = {"Feedback", "Bug Report", "Hack Report"}
local currently = 1
Main.Parent.Parent.TextButton.MouseButton1Click:connect(function()
	Main.Parent.Visible = not Main.Parent.Visible
end)
Submit.MouseButton1Click:connect(function()
	if Box.Text == "" then return end
	Report:FireServer(types[currently],Box.Text)	
	Box.Text = "Click to type"
	Main.Welcome.Text = "Thanks for the "..typenames[currently].."!"
end)
Right.MouseButton1Click:connect(function()
if selected then return end
currently = currently + 1
if currently > 3 then
	currently = 1
	Main.Title.Text = typenames[currently]
else
Main.Title.Text = typenames[currently]
end
selected = true

Box.Text = "Click to type"

Main.Fancy.Position = UDim2.new(0.25, 0, -0.2, 0)
Main.Fancy.Size = UDim2.new(0, 0, 0, 0)
Main.Fancy.Visible = true
local Event = game:GetService("RunService").RenderStepped:connect(function(dt)
Main.Fancy.Position = UDim2.new(Main.Fancy.Position.X.Scale- dt * 6, 0, 0 , 0)	
Main.Fancy.Size = UDim2.new(Main.Fancy.Size.X.Scale + dt* 10 , 0, Main.Fancy.Size.Y.Scale - dt* 10, 0)
Main.Fancy.BackgroundTransparency = Main.Fancy.BackgroundTransparency + dt * 2
end)

delay(0.5,function()
	Event:Disconnect()
	Main.Fancy.Visible = false
	selected = false
	Main.Fancy.BackgroundTransparency = 0
end)
end)
Left.MouseButton1Click:connect(function()
if selected then return end
currently = currently - 1
if currently < 1 then
	currently = 3
	Main.Title.Text = typenames[currently]
else
	Main.Title.Text = typenames[currently]
end

selected = true
Box.Text = "Click to type"

Main.Fancy.Position = UDim2.new(0.25, 0, -0.2, 0)
Main.Fancy.Size = UDim2.new(0, 0, 0, 0)
Main.Fancy.Visible = true
local Event = game:GetService("RunService").RenderStepped:connect(function(dt)
Main.Fancy.Position = UDim2.new(Main.Fancy.Position.X.Scale- dt * 6, 0, 0 , 0)	
Main.Fancy.Size = UDim2.new(Main.Fancy.Size.X.Scale + dt* 10 , 0, Main.Fancy.Size.Y.Scale - dt* 10, 0)
Main.Fancy.BackgroundTransparency = Main.Fancy.BackgroundTransparency + dt * 2
end)

delay(0.5,function()
	Event:Disconnect()
	Main.Fancy.Visible = false
	selected = false
	Main.Fancy.BackgroundTransparency = 0
end)
end)

