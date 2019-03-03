--[[
	This function will determine the closest player unit to attack,
	and will attack it if able, otherwise it will get closer to it
--]]

function enemyBasic(map, ent, playerEnts)
	-- Get the tiles
	local moveTiles, attackTiles = ai.plan(map, ent)

	for i=1,table.getn(attackTiles) do
		local enemy = map.getEntity(attackTiles[i].x, attackTiles[i].y)
		if enemy ~= nil then
			ai.basicAttack(map, ent, enemy, moveTiles)
			return
		end
	end
	
	-- If not within attacking range then find the next best thing
	local distance = 10000
	local path = nil
	
	-- Get the closest entity
	local start = utils.getPoint(ent.x, ent.y)
	for i=1,table.getn(playerEnts) do
		local finish = utils.getPoint(playerEnts[i].x, playerEnts[i].y)
		local currentPath = ai.aStar(map, start, finish)
		
		if table.getn(currentPath) < distance then
			distance = table.getn(currentPath)
			path = currentPath
		end
	end
	
	-- Move towards the closest entity
	map.moveEntity(ent, path[ent.sp].x, path[ent.sp].y)
end

return enemyBasic