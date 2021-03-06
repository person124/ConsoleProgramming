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
		done = true
		for i=1,table.getn(tab) do
			if tab[i] ~= nil and tab[i].hp <= 0 then
				table.remove(tab, i)
				done = false
				break
			end
		end
	end
end

-- Returns a table of functions merged from the two tables
-- with the first table acting as a base
function utils.mergeFunctions(funcBase, funcs)
	-- If there is no other list, then just return the base
	if funcs == nil then return funcBase end

	local returnFuncs = {}
	for i in pairs(funcBase) do
		if funcs[i] ~= nil then
			returnFuncs[i] = funcs[i]
		else
			returnFuncs[i] = funcBase[i]
		end
	end

	return returnFuncs
end

-- Returns true if the game is on android or ios
-- False if otherwise
function utils.isMobile()
	if love.system.getOS() == "Android" then return true
	elseif love.system.getOS() == "iOS" then return true
	else return false end
end