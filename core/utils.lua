utils = {}

-- This functions allows the creation of utils.protected tables
-- On use will make a table write only
-- http://andrejs-cainikovs.blogspot.com/2009/05/lua-constants.html
function utils.protect(tbl)
	return setmetatable({}, {
		__index = tbl,
		__newindex = function(t, key, value)
			error("attempting to change constant " ..
				tostring(key) .. " to " .. tostring(value), 2)
		end
	})
end

-- Makes sure num is within min and max inclusive
-- returns the result
function utils.minmax(num, min, max)
	if num < min then return min
	elseif num > max then return max
	else return num end
end

-- Simple point structure
function utils.getPoint(x, y)
	local point = {}
	point.x = x
	point.y = y
	return point
end

-- Returns true if table contains specified point
function utils.containsPoint(tab, value)
	for i=1,table.getn(tab) do
		if tab[i].x == value.x and tab[i].y == value.y then
			return true
		end
	end
	
	return false
end

-- Returns true if table contains copy of specified object
function utils.containsObject(tab, obj)
	for i=1,table.getn(tab) do
		if tab[i] == obj then
			return true
		end
	end
	
	return false
end

-- Scans the table and removes dead entities from it
function utils.removeDeadEntities(tab)
	local done = false
	
	while not done do
		for i=1,table.getn(tab) do
			if tab[i].hp <= 0 then
				table.remove(tab, i)
				done = false
			else
				done = true
			end
		end
	end
end