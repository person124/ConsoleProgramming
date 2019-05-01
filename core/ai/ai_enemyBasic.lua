--[[
	This function will determine the closest player unit to attack,
	and will attack it if able, otherwise it will get closer to it
--]]

local function enemyBasic(map, ent, playerEnts)
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

	-- Get the closest entity
	local tilePoint = utils.getPoint(ent.x, ent.y)
	for i=1,table.getn(playerEnts) do
		local finish = utils.getPoint(playerEnts[i].x, playerEnts[i].y)

		for j=1,table.getn(moveTiles) do
			local currentPath = ai.aStar(map, moveTiles[j], finish)

			if currentPath ~= nil and table.getn(currentPath) < distance then
				distance = table.getn(currentPath)
				tilePoint = moveTiles[j]
			end
		end
	end

	-- Move towards the closest entity
	map.moveEntity(ent, tilePoint.x, tilePoint.y)
end

return enemyBasic