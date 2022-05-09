local Frame, Text, Button = unpack(require(game.ReplicatedStorage.BaseGuis))
local ColorScheme = require(game.ReplicatedStorage.ColorScheme)
local numupdates = 0.075

local function inset(element, amount)
	element.Position = element.Position + UDim2.new(0, 0, amount, 0)
	element.Size = element.Size + UDim2.new(1, 0, 0.1, 0)
end

local frame = Frame:Clone()
frame.Size = UDim2.new(0.5, 0, 0.5, 0)
frame.Position = UDim2.new(0.215, 0, 0.125, 0)
frame.BackgroundColor3 = ColorScheme.Quaternary
frame.BorderColor3 = ColorScheme.Dark
frame.ZIndex = 10
frame.Parent = script.Parent
frame.Visible = false

local function update(date, msg, dev)
	local text = Text:Clone()
	text.Text = tostring(date)..tostring(msg)..tostring(dev)
	text.ZIndex = 10
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.BackgroundColor3 = ColorScheme.Quaternary
	text.BorderColor3 = ColorScheme.Dark
	text.Parent = frame
	inset(text, numupdates)
	numupdates = numupdates + text.Size.Y.Scale
end


local button = Button:Clone()
button.Size = UDim2.new(0.075, 0, 0.05, 0)
button.Position = UDim2.new(0.925, 0, 0.95, 0)
button.BackgroundColor3 = ColorScheme.Quaternary
button.BorderColor3 = ColorScheme.Dark
button.ZIndex = 2
button.Parent = script.Parent
button.Text = "Update Log"

local title = Text:Clone()
title.Size = UDim2.new(1,0,0.05,0)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Updates: "
title.ZIndex = 10
title.BackgroundColor3 = ColorScheme.Quaternary
title.BorderColor3 = ColorScheme.Dark
title.Parent = frame

update("10/6/16: ", "New items, Shed arena can no longer be escaped out of BUT BUT BUT, projectiles can no longer enter the arena:", "Average")
update("10/7/16: ", "Victory message not showing fixed?, Skins with ultimates not working as supposed to fix, XP ALWAYS AWARDED DESPITE OF GUI NOT SHOWING UP, Golems should no longer be misplaced (Im too lazy to write a new one so, Anti spawn killing, speedy's 2nd is now fixed and should work as intended):", "Average")
update("10/25/16: ", "Halloween stuff, hopeful lag reduction, render distance so any sfx greater than 128 studs wont be seen:", "Average")
update("10/29/16: ", "2 new skins, lag reduction stuff, some items were reworked:", "Average")
update("11/7/16: ", "Gamemodes, appears every third round. Champ lock, char select restructured:", "Average")
update("12/18/16: ", "Reused log meh,Christmas stuff, smol fixes :", "Average")
update("1/14/17: ", "Added 2 new items in the Health category and 1 new comsumable. More items are on their way! :", "The_Immolation")
update("3/07/17: ", "Re-tweaks and some fixes. Chat will be fixed soon. Working on it apologies for the multiple shutdowns. :", "Makumio")
update("3/07/17: ", "Chat fixed. :", "Average")

button.MouseButton1Click:connect(function()
	frame.Visible = not frame.Visible
end)

