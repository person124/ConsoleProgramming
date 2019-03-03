--[[
	This function will take in the map, entity that is attacking, the target,
	the movement map, and the attacking map. As a result it will attack the specified entity
	while moving the attacker to a suitable space.
--]]

local function getDistance(map, start, finish)
	local path = ai.aStar(map, start, finish)
	return table.getn(path)
end

function basicAttack(map, attacker, target, moveMap)
	-- Steps:
	-- 1) Get range
	-- 2) Get movement tile at specified range
	-- 3) Move unit
	-- 4) Apply damage
	
	-- 1) range is just attacker.rn
	local endPoint = utils.getPoint(target.x, target.y)
	-- 2)
	local toUseID = 0
	local maxDistance = 0
	
	-- Get current distance first
	moveMap[-1] = utils.getPoint(attacker.x, attacker.y)
	maxDistance = getDistance(map, moveMap[-1], endPoint)
	if maxDistance <= attacker.rn then
		toUseID = -1
	else
		maxDistance = 0
	end
	
	for i=1,table.getn(moveMap) do
		-- Go with the tile that is the farthest away
		local dist = getDistance(map, moveMap[i], endPoint)
		if dist <= attacker.rn and dist > maxDistance then
			toUseID = i
			maxDistance = dist
		end
	end
	
	-- If no tile was selected then return false
	if toUseID == 0 then return false end
	
	-- 3)
	map.moveEntity(attacker, moveMap[toUseID].x, moveMap[toUseID].y)
	
	-- 4)
	target.funcs.damage(attacker, target, attacker.at)
	map.refresh()
	
	return true
end

return basicAttack