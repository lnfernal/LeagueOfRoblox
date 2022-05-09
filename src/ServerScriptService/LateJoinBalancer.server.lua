game.ReplicatedStorage.GetAverageValue.OnInvoke = function(...)
	local args = {...};
	
	local total = 0;
	local num = 0;
	for i, plr in ipairs(game.Players:GetPlayers()) do
		if(plr.Character) then
			if(not args[1] or (args[1] ~= plr.TeamColor and plr.Character:FindFirstChild("CharacterScript"))) then
				local getter = plr.Character.CharacterScript:FindFirstChild("GetTix")
				if(getter) then
					total = total + getter:Invoke();
					num = num + 1;
				end
				
				local inventory = plr.Character.CharacterScript:FindFirstChild("Inventory");
				if(inventory) then
					--get the total cost of the item
					for i, item in ipairs(inventory:GetChildren()) do
						local cost = 0
						
						local function recurse(item)
							if not item then return end
							
							cost = cost + item.Cost.Value
							
							if item:FindFirstChild("Req") then
								for _, itemName in pairs(item.Req:GetChildren()) do
									recurse(game.ReplicatedStorage.Shop:FindFirstChild(itemName.Name))
								end
							end
						end
						recurse(item)
						
						total = total + cost;
					end
				end
			end
		end
	end
	
	--We don't want to run into a dividing by 0 error
	if(num == 0) then
		return 0;
	else
		return math.floor(total/num); --Return the average
	end
end

game.ReplicatedStorage.GetPlayerValue.OnInvoke = function(plr)
	local total = 0;
	
	if(plr.Character) then
		if(plr.Character:FindFirstChild("CharacterScript")) then
			local getter = plr.Character.CharacterScript:FindFirstChild("GetTix")
			if(getter) then
				total = total + getter:Invoke();
			end
			
			local inventory = plr.Character.CharacterScript:FindFirstChild("Inventory");
			if(inventory) then
				--get the total cost of the item
			for i, item in ipairs(inventory:GetChildren()) do
					local cost = 0
					
					local function recurse(item)
						if not item then return end
						
						cost = cost + item.Cost.Value
						
						if item:FindFirstChild("Req") then
							for _, itemName in pairs(item.Req:GetChildren()) do
								recurse(game.ReplicatedStorage.Shop:FindFirstChild(itemName.Name))
							end
						end
					end
					recurse(item)
						
					total = total + cost;
				end
			end
		end
	end
	return total;
end

game.ReplicatedStorage.GetAverageExperience.OnInvoke = function(...)
	local args = {...};
	
	local total = 0;
	local num = 0;
	for i, plr in ipairs(game.Players:GetPlayers()) do
		if(plr.Character) then
			if(not args[1] or (args[1] ~= plr.TeamColor and plr.Character:FindFirstChild("CharacterScript"))) then
				local getter = plr.Character.CharacterScript:FindFirstChild("GetExperience")
				local getter2 = plr.Character.CharacterScript:FindFirstChild("GetLevel");
				if(getter and getter2) then
					local xp = getter:Invoke();
					local level = getter2:Invoke();
					for i = 1, level, 1 do
						xp = xp + (4 * i);
					end
					total = (total + xp)*.9;
					num = num + 1;
				end
			end
		end
	end
	
	--We don't want to run into a dividing by 0 error
	if(num == 0) then
		return 0;
	else
		return math.floor(total/num); --Return the average
	end
end