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
		if map[i].x == value.x and map[i].y == value.y then
			table.removeValue(map, i)
			return
		end
	end
end

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
		
		for i=1,table.getn(successors) do
			local temp = successors[i]
			temp.cost = point.cost + 1

			if isGoal(temp, finish) then
				return getPath(temp)
			end
			
			local other = containsValue(open, temp)
			if other ~= nil and other.cost > temp.cost then
				table.insert(open, temp)
			else
				other = containsValue(closed, temp)
				
				if other ~= nil then
					if other.cost > temp.cost then
						table.insert(open, temp)
						removeValue(closed, temp)
					end
				else
					table.insert(open, temp)
			end
		end
	end
	
	-- If pathing failed then return nil
	return nil
end

return AStar