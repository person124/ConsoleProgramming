--[[
	This function will determine the closest player unit to attack,
	and will attack it if able, otherwise it will get closer to it
--]]

function enemyBasic(map, ent, playerEnts)
	-- Get the tiles
	local moveTiles, attackTiles = ai.plan(map, ent)

	print(table.getn(attackTiles))
	for i=1,table.getn(attackTiles) do
		local enemy = map.getEntity(attackTiles[i].x, attackTiles[i].y)
		print(attackTiles[i].x, attackTiles[i].y, enemy);
		if enemy ~= nil then
			ai.basicAttack(map, ent, enemy, moveTiles)
			return
		end
	end
	
	-- If not within attacking range then find the next best thing
	local distance = 10000
	local path = nil
	
	-- Get the closest entity
	-- TODO rework so it can't be on the same space as another entity
	local start = utils.getPoint(ent.x, ent.y)
	for i=1,table.getn(playerEnts) do
		local finish = utils.getPoint(playerEnts[i].x, playerEnts[i].y)
		local currentPath = ai.aStar(map, start, finish)
		
		if currentPath ~= nil and table.getn(currentPath) < distance then
			distance = table.getn(currentPath)
			path = currentPath
		end
	end
	
	-- Move towards the closest entity
	if path ~= nil then
		map.moveEntity(ent, path[ent.sp].x, path[ent.sp].y)
	end
end

return enemyBasic