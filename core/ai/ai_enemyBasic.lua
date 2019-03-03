--[[
	This function will determine the closest player unit to attack,
	and will attack it if able, otherwise it will get closer to it
--]]

function enemyBasic(map, ent, playerEnts)
	-- Get the tiles
	local moveTiles, attackTiles = ai.plan(map, ent)

	local distance = 10000
	for i=1,table.getn(attackTiles) do
		local enemy = map.getEntity(attackTiles[i].x, attackTiles[i].y)
		if enemy ~= nil then
			ai.basicAttack(map, ent, enemy, moveTiles)
			return
		end
	end
	
	-- TODO add something if no entities within range
end

return enemyBasic