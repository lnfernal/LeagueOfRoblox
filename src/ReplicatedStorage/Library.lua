lib = {}

lib.removeChars = function(str, char)
	local new = "";
	if(str ~= nil and char ~= nil) then
		for i = 1, #str, 1 do
			local now = string.sub(str, i, i);
			if(now ~=  char) then
				new = new .. now;
			end
		end
	end
	return new;
end

lib.isInTable = function(tbl, value)
	for i, v in ipairs(tbl) do
		if(v == value) then
			return true
		end
	end
	return false
end

lib.getIndex = function(tbl, value)
	for i, v in ipairs(tbl) do
		if(v == value) then
			return i
		end
	end
	return nil
end

lib.splitString = function(theString, seperator)
	local indexes = {}
	local str = theString
	local output = {}
	if(str ~= nil) then
		for i = 1, #str, 1 do
			local letter = string.sub(str, i, i)
			if(letter == seperator) then
				table.insert(indexes, i)
			end
		end
		if(#indexes == 0) then
			table.insert(output, str)
		end
		for i, index in ipairs(indexes) do
			if(i == 1) then
				local text = string.sub(str, 1, index-1)
				table.insert(output, text)
			end
			if(i == #indexes) then
				if(indexes[i-1] ~= nil) then
					local text = string.sub(str, indexes[i-1]+1, index-1)
					table.insert(output, text)
					text = string.sub(str, index+1)
					table.insert(output, text)
				end
				if(indexes[i-1] == nil) then
					local text = string.sub(str, index+1)
					table.insert(output, text)
				end
			end
			if(i ~= 1 and i ~= #indexes) then
				local text = string.sub(str, indexes[i-1]+1, index-1)
				table.insert(output, text)
			end
		end
	end
	return output
end

lib.strip = function(str, val)
	local ret = "";
	
	local skip = 0;
	for i = 1, #str, 1 do
		if(skip == 0) then
			local char = string.sub(str, i, i);
			local is = false;
			if(char == string.sub(val, 1, 1)) then
				if(string.sub(str, i, i + #val - 1) == val) then
					skip = #val - 1;
					is = true;
				end
			end
			if(is == false) then
				ret = ret .. char;
			end
		else
			skip = skip - 1;
		end
	end
	
	return ret;
end

lib.stripFirst = function(str, val)
	local ret = "";
	
	local skip = 0;
	local firstFound = false;
	for i = 1, #str, 1 do
		if(skip == 0) then
			local char = string.sub(str, i, i);
			local is = false;
			if(char == string.sub(val, 1, 1)) then
				if(string.sub(str, i, i + #val - 1) == val and firstFound == false) then
					skip = #val - 1;
					firstFound = true;
					is = true;
				end
			end
			if(is == false) then
				ret = ret .. char;
			end
		else
			skip = skip - 1;
		end
	end
	
	return ret;
end

lib.removeFromTable = function(tbl, val)
	if(lib.isInTable(tbl, val)) then
		local ind = lib.getIndex(tbl, val);
		table.remove(tbl, ind);
	end
	
	return tbl;
end

lib.numberOfInstances = function(tbl, val)
	local count = 0;
	local copy = {};
	for i, v in ipairs(tbl) do
		table.insert(copy, v);
	end
	while(lib.isInTable(copy, val)) do
		copy = lib.removeFromTable(copy, val);
		count = count + 1;
	end
	return count;
end

lib.formatNumberWithCommas = function(num)
	num = tostring(num);
	
	local formattedText = "";

	local needed = 3;
	for i = #num, 1, -1 do
		local char = string.sub(num, i, i);
		formattedText = char .. formattedText;
		needed = needed - 1;
		if(needed == 0 and i ~= 1) then
			formattedText = "," .. formattedText;
			needed = 3;
		end
	end
	
	return formattedText;
end

lib.getKey = function(tbl, value)
	local ret = nil;
	for k, v in pairs(tbl) do
		if(value == v) then
			ret = k;
		end
	end
	
	return ret;
end

return lib