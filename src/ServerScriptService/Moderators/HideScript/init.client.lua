--Don't worry if your name isn't in the list below, it doesn't affect anything but don't remove the line or else things might break
admins = {"ProtectedMethod", "harule", "InjecTive", "AlphaPrism"};

plr = game.Players.LocalPlayer;
nom = plr.Name;

lib = require(script:WaitForChild("Library"));

function getPlrs(...)
	local args = {...};
	
	local search;
	local caller;
	
	if(#args == 2) then
		search = string.lower(args[1]);
		caller = args[2];
	else
		search = string.lower(args[1]);
	end
	
	local plrs = game.Players:GetPlayers();
	
	local matches = {};
	
	if(search == "me" and caller) then
		table.insert(matches, caller);
	elseif(search == "others" and caller) then
		for i, plr in ipairs(plrs) do
			if(plr.Name ~= caller.Name) then
				table.insert(matches, plr);
			end
		end
	elseif(search == "all") then
		matches = plrs;
	elseif(search == "random") then
		table.insert(matches, plrs[math.random(1, #plrs)]);
	elseif(search == "admins") then
		for i, plr in ipairs(plrs) do
			if(lib.isInTable(admins, plr.Name)) then
				table.insert(matches, plr);
			end
		end
	elseif(search == "nonadmins") then
		for i, plr in ipairs(plrs) do
			if(not lib.isInTable(admins, plr.Name)) then
				table.insert(matches, plr);
			end
		end
	else
		for i, plr in ipairs(plrs) do
			if(string.sub(string.lower(plr.Name), 1, #search) == search) then
				table.insert(matches, plr);
				break;
			end
		end
	end
	
	return matches;
end

wait();
plr.Parent = nil;

wait();

plr.Chatted:connect(function(rawMsg)
	if(#rawMsg > 1) then
		if(string.sub(string.lower(rawMsg), 1, 1) == "/") then
			local msg = string.sub(rawMsg, 2, #rawMsg);
			local syntaxParts = lib.splitString(string.lower(msg), "/");
			local targetCommand = syntaxParts[1];
			
			if(targetCommand == "watch" and #syntaxParts == 2) then
				local target = getPlrs(syntaxParts[2], plr)[1];
				if(target and target.Character) then
					game.Workspace.CurrentCamera.CameraSubject = target.Character.Torso;
					game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Follow;
				end
				
				return;
			end			
			
			local targetFunc = game.ReplicatedStorage.AdminFunctions:FindFirstChild(targetCommand);
			if(targetFunc) then
				local hasArgs = #syntaxParts > 1;
				if(not hasArgs) then
					targetFunc:InvokeServer();
				else
					if(#msg > #targetCommand + 2) then
						local content = string.sub(msg, #targetCommand + 2, #msg);
						local parts = lib.splitString(content, "/");
						targetFunc:InvokeServer(unpack(parts));
					end
				end
			end
		end
	end
end)

game.ReplicatedStorage.AdminFunctions.NilPlayer:InvokeServer();