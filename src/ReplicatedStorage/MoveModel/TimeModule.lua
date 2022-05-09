time = {};

function giveZero(data)
	if string.len(data) <= 1 then
		return "0" .. data
	else
		return data
	end
end
function isInTable(tbl, value)
	for i, v in ipairs(tbl) do
		if(v == value) then
			return true
		end
	end
	return false
end
function hasDecimal(value)
	if not(value == math.floor(value)) then
		return true
	else
		return false
	end
end
function isLeapYear(year)
	if(not hasDecimal(year / 4)) then
		if(hasDecimal(year / 100)) then
			return true
		else
			if(not hasDecimal(year / 400)) then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end
--Year of epoch
eYear = 1970
--Thurdsay is the fifth day of the week
timeStampDayOfWeak = 5
secondsInHour = 3600
secondsInDay = 86400
secondsInYear = 31536000
secondsInLeapYear = 31622400
monthWith28 = 2419200
monthWith29 = 2505600
monthWith30 = 2592000
monthWith31 = 2678400
monthsWith30 = {4, 6, 9, 11}
monthsWith31 = {1, 3, 5, 7, 8, 10, 12}
daysSinceEpoch = 0
--Epoch was on a thursday, so we'll start with thursday
DOWAssociates = {"Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"}

time.stampToTime = function(stamp)
	local now = stamp;
	local year = 1970
	local secs = 0
	local daysSinceEpoch = 0
	while((secs + secondsInLeapYear) < now or (secs + secondsInYear) < now) do
		if(isLeapYear(year+1)) then
			if((secs + secondsInLeapYear) < now) then
				secs = secs + secondsInLeapYear
				year = year + 1
				daysSinceEpoch = daysSinceEpoch + 366
			end
		else
			if((secs + secondsInYear) < now) then
				secs = secs + secondsInYear
				year = year + 1
				daysSinceEpoch = daysSinceEpoch + 365
			end
		end
	end
	local secondsRemaining = now - secs
	local monthSecs = 0
	local yearIsLeapYear = isLeapYear(year)
	local month = 1 -- January
	while((monthSecs + monthWith28) < secondsRemaining or (monthSecs + monthWith30) < secondsRemaining or (monthSecs + monthWith31) < secondsRemaining) do
		if(month == 1) then
			if((monthSecs + monthWith31) < secondsRemaining) then
				month = 2
				monthSecs = monthSecs + monthWith31
				daysSinceEpoch = daysSinceEpoch + 31
			else
				break
			end
		end
		if(month == 2) then
			if(not yearIsLeapYear) then
				if((monthSecs + monthWith28) < secondsRemaining) then
					month = 3
					monthSecs = monthSecs + monthWith28
					daysSinceEpoch = daysSinceEpoch + 28
				else
					break
				end
			else
				if((monthSecs + monthWith29) < secondsRemaining) then
					month = 3
					monthSecs = monthSecs + monthWith29
					daysSinceEpoch = daysSinceEpoch + 29
				else
					break
				end
			end
		end
		if(month == 3) then
			if((monthSecs + monthWith31) < secondsRemaining) then
				month = 4
				monthSecs = monthSecs + monthWith31
				daysSinceEpoch = daysSinceEpoch + 31
			else
				break
			end
		end
		if(month == 4) then
			if((monthSecs + monthWith30) < secondsRemaining) then
				month = 5
				monthSecs = monthSecs + monthWith30
				daysSinceEpoch = daysSinceEpoch + 30
			else
				break			
			end
		end
		if(month == 5) then
			if((monthSecs + monthWith31) < secondsRemaining) then
				month = 6
				monthSecs = monthSecs + monthWith31
				daysSinceEpoch = daysSinceEpoch + 31
			else
				break
			end
		end
		if(month == 6) then
			if((monthSecs + monthWith30) < secondsRemaining) then
				month = 7
				monthSecs = monthSecs + monthWith30
				daysSinceEpoch = daysSinceEpoch + 30
			else
				break
			end
		end
		if(month == 7) then
			if((monthSecs + monthWith31) < secondsRemaining) then
				month = 8
				monthSecs = monthSecs + monthWith31
				daysSinceEpoch = daysSinceEpoch + 31
			else
				break
			end
		end
		if(month == 8) then
			if((monthSecs + monthWith31) < secondsRemaining) then
				month = 9
				monthSecs = monthSecs + monthWith31
				daysSinceEpoch = daysSinceEpoch + 31
			else
				break
			end
		end
		if(month == 9) then
			if((monthSecs + monthWith30) < secondsRemaining) then
				month = 10
				monthSecs = monthSecs + monthWith30
				daysSinceEpoch = daysSinceEpoch + 30
			else
				break
			end
		end
		if(month == 10) then
			if((monthSecs + monthWith31) < secondsRemaining) then
				month = 11
				monthSecs = monthSecs + monthWith31
				daysSinceEpoch = daysSinceEpoch + 31
			else
				break
			end
		end
		if(month == 11) then
			if((monthSecs + monthWith30) < secondsRemaining) then
				month = 12
				monthSecs = monthSecs + monthWith30
				daysSinceEpoch = daysSinceEpoch + 30
			else
				break
			end
		end
	end
	local day = 1 -- 1st
	local daySecs = 0
	local daySecsRemaining = secondsRemaining - monthSecs
	while((daySecs + secondsInDay) < daySecsRemaining) do
		day = day + 1
		daySecs = daySecs + secondsInDay
		daysSinceEpoch = daysSinceEpoch + 1
	end
	local hour = 0 -- Midnight
	local hourSecs = 0
	local hourSecsRemaining = daySecsRemaining - daySecs
	while((hourSecs + secondsInHour) < hourSecsRemaining) do
		hour = hour + 1
		hourSecs = hourSecs + secondsInHour
	end
	local minute = 0 -- Midnight
	local minuteSecs = 0
	local minuteSecsRemaining = hourSecsRemaining - hourSecs
	while((minuteSecs + 60) < minuteSecsRemaining) do
		minute = minute + 1
		minuteSecs = minuteSecs + 60
	end
	local second = math.floor(now % 60)
	local year = giveZero(year)
	local month = giveZero(month)
	local day = giveZero(day)
	local hour = giveZero(hour)
	local minute = giveZero(minute)
	second = giveZero(second)
	local remanderForDOW = daysSinceEpoch % 7
	local DOW = DOWAssociates[remanderForDOW + 1]
	
	local output = {};
	output.year = year;
	output.month = month;
	output.day = day;
	output.hour = hour;
	output.minute = minute;
	output.second = second;
	--Lower and upercase DOW, just for the user's choice
	output.DOW = DOW;
	output.dow = DOW;
	
	return output;
end

time.timeToStamp = function(stuff)
	--Make the stuff easier to access
	local year = stuff.year;
	local month = stuff.month;
	local day = stuff.day;
	local hour = stuff.hour;
	local minute = stuff.minute;
	local second = stuff.second;
	
	--The new unix timestamp
	local stamp = 0;
	
	--Add the seconds from the years
	for i = 1970, year - 1--[[don't calculate the last year]], 1 do
		if(not isLeapYear(i)) then
			stamp = stamp + secondsInYear;
		else
			stamp = stamp + secondsInLeapYear;
		end
	end
	
	--Add the seconds from the months
	for m = 1, month - 1, 1 do
		if(m ~= 2) then
			if(isInTable(monthsWith30, m)) then
				stamp = stamp + monthWith30;
			end
			if(isInTable(monthsWith31, m)) then
				stamp = stamp + monthWith31;
			end
		else
			stamp = stamp + monthWith28;
		end
	end
	
	--Add the seconds from the days
	for d = 1, day - 1, 1 do
		stamp = stamp + secondsInDay;
	end
	
	--Add the seconds from the hours
	for h = 1, hour, 1 do
		stamp = stamp + secondsInHour;
	end
	
	--Add the seconds from the minutes
	for m = 1, minute, 1 do
		stamp = stamp + 60;
	end
	
	--Add the seconds from the seconds
	stamp = stamp + second;
	
	--Return the new stamp
	return stamp;
end

return time;