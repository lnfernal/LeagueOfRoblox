game.Players.PlayerAdded:connect(function(plr)
	plr.Chatted:connect(function(msg)
		if(msg=="This is for you, Claire.") then 
			game.ServerStorage.ExtraCharacters["Dragon Form"].RequiredLevel.Value = 2
			wait(10)
			game.ServerStorage.ExtraCharacters["Dragon Form"].RequiredLevel.Value = 1	
		end	
	end)
end) --Just keep both



--Meh, too lazy to make a cleaner conditional statement. -Vincent


game.Players.PlayerAdded:connect(function(plr)
	plr.Chatted:connect(function(msg)
		if(msg=="/robbierotten") then 
			game.ServerStorage.ExtraCharacters["Dragon Form"].RequiredLevel.Value = 2
			wait(10)
			game.ServerStorage.ExtraCharacters["Dragon Form"].RequiredLevel.Value = 1	
		end	
	end)
end)

--original phrase was getting out of hand

