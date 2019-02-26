--[[
	Returns the A* found path between two points
	Takes two points as input
--]]

local function node(x, y, prevousNode)
	local temp = {}
	temp.x = x
	temp.y = y
	temp.prev = prevousNode
	temp.cost = 0
	return temp
end

local function isGoal(point, finish)
	return point.x == finish.x and point.y == finish.y
end

local function containsValue(map, value)
	for i=1,table.getn(map) do
		if map[i].x == value.x and map[i].y == value.y then
			return map[i]
		end
	end
	
	return nil
end

local function removeValue(map, value)
	for i=1,table.getn(map) do
		if map[i] == value then
			table.remove(map, i)
			return
		end
	end
end

local function getPath(finishNode)
	local path = {}
	local current = finishNode
	
	while current.prev ~= nil do
		table.insert(path, 1, getPoint(current.x, current.y))
		current = current.prev
	end
	
	return path
end

-- TODO ADD HEURISTIC!!!!
function AStar(map, start, finish)
	-- Init open and closed lists
	local open = {}
	local closed = {}
	
	-- Enqueue start point
	table.insert(open, node(start.x, start.y, nil))
	
	-- As long as open list isn't empty
	while table.getn(open) > 0 do
		-- Get point with lowest cost
		local lowestCost = 10000
		local point = nil
		for i=1,table.getn(open) do
			if open[i].cost < lowestCost then
				lowestCost = open[i].cost
				point = open[i]
			end
		end
		
		local successors = {}
		-- Generate successors and check if is goal
		table.insert(successors, node(point.x, point.y - 1, point))
		table.insert(successors, node(point.x, point.y + 1, point))
		table.insert(successors, node(point.x - 1, point.y, point))
		table.insert(successors, node(point.x + 1, point.y, point))
		
		-- For each successor
		for i=1,table.getn(successors) do
			local temp = successors[i]
			temp.cost = point.cost + 1
			
			-- Don't go if it is solid
			if not map.isSolid(temp.x, temp.y) then

			-- Check if its the goal
			if isGoal(temp, finish) then
				return getPath(temp)
			end
			
			-- Otherwise see if its in the open list, and compare cost
			local other = containsValue(open, temp)
			if other ~= nil and other.cost > temp.cost then
				table.insert(open, temp)
			else
				-- Otherwise check if its in the closed list
				other = containsValue(closed, temp)
				
				if other ~= nil then
					-- Compare cost, and add to open if lower
					if other.cost > temp.cost then
						table.insert(open, temp)
						removeValue(closed, temp)
					end
				else
					-- If its not in any list than add it to the open one
					table.insert(open, temp)
				end
			end
			
			-- end of isSolid
			end
		end
		
		removeValue(open, point)
		table.insert(closed, point)
	end
	
	-- If pathing failed then return nil
	return nil
end

return AStar