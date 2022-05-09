

local http = game:GetService("HttpService")


game.ReplicatedStorage.Remotes.Report.OnServerEvent:connect(function(player, webhook,content)
	if content == "Click to type" then return end
local newcontent = game.Chat:FilterStringForBroadcast(content, player)
local HookData = {

['username'] = player.Name, -- This is whatever you want the Bot to be called

['content'] = newcontent, -- this is whatever you want it to say!

['avatar_url'] = "https://www.roblox.com/bust-thumbnail/image?userId="..player.userId.."&width=420&height=420&format=png"
}
HookData = http:JSONEncode(HookData)
http:PostAsync(webhook, HookData) -- And we are done :D
end)

