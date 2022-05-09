local colorScheme = require(Game.ReplicatedStorage.ColorScheme)

local baseFrame = Instance.new("Frame")
baseFrame.BackgroundColor3 = colorScheme.Primary
baseFrame.BorderColor3 = colorScheme.Secondary

local baseText = Instance.new("TextLabel")
baseText.BackgroundTransparency = 1
baseText.TextStrokeTransparency = 0
baseText.TextColor3 = colorScheme.Text
baseText.TextScaled = true

local baseButton = Instance.new("TextButton")
baseButton.BackgroundColor3 = colorScheme.Tertiary
baseButton.BorderColor3 = colorScheme.Quaternary
baseButton.TextStrokeTransparency = 0
baseButton.TextColor3 = colorScheme.Text
baseButton.TextScaled = true

return {baseFrame, baseText, baseButton}