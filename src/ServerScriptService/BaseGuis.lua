local baseFrame = Instance.new("Frame")
baseFrame.BackgroundColor3 = Color3.new(0, 0, 0)
baseFrame.BorderColor3 = Color3.new(0, 0, 0)

local baseText = Instance.new("TextLabel")
baseText.BackgroundTransparency = 1
baseText.TextStrokeTransparency = 0
baseText.TextColor3 = Color3.new(1, 1, 1)
baseText.TextScaled = true

local baseButton = Instance.new("TextButton")
baseButton.BackgroundColor3 = Color3.new(0, 0, 0)
baseButton.BorderColor3 = Color3.new(0, 0, 0)
baseButton.TextStrokeTransparency = 0
baseButton.TextColor3 = Color3.new(1, 1, 1)
baseButton.TextScaled = true

return {baseFrame, baseText, baseButton}