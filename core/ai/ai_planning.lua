local function spreadFromTileMovement(map, tileX, tileY, tilesLeft, moveTiles)
	-- Start an x and y nested for loop
	for x=-1,1 do for y=-1,1 do
		-- Make sure we are only testing x OR y
		if (x ~= 0 and y == 0) or (y ~= 0 and x == 0) then
			local adjX = tileX + x
			local adjY = tileY + y
			
			-- Does boundary checks during solid check
			if not map.isSolid(adjX, adjY) then
				local point = getPoint(adjX, adjY)
			
				if not containsPoint(moveTiles, point) and not map.isEntityOnSpace(adjX, adjY) then
					table.insert(moveTiles, point)
				end
				
				if tilesLeft - 1 > 0 then
					spreadFromTileMovement(map, adjX, adjY, tilesLeft - 1, moveTiles)
				end
			end
		end
	end end
end

local function spreadFromTileAttack(map, tileX, tileY, tilesLeft, moveTiles, attackTiles)
	-- Start an x and y nested for loop
	for x=-1,1 do for y=-1,1 do
		-- Make sure we are only testing x OR y
		if (x ~= 0 and y == 0) or (y ~= 0 and x == 0) then
			local adjX = tileX + x
			local adjY = tileY + y
			
			-- Does boundary checks during solid check
			if map.isSolid(adjX, adjY) then
				local point = getPoint(adjX, adjY)
				
				if not containsPoint(moveTiles, point) then
					-- TODO improve this
					local entity = map.getEntity(adjX, adjY)
					if entity == nil or entity.isEnemy then
						table.insert(attackTiles, point)
					elseif not containsPoint(moveTiles, point) then
						table.insert(attackTiles, point)
					end
				end
				
				if tilesLeft - 1 > 0 then
					spreadFromTileAttack(map, adjX, adjY, tilesLeft - 1, moveTiles, attackTiles)
				end
			end
		end
	end end
end

local function planAttack(map, ent, moveTiles, attackTiles)
	for i=1,table.getn(moveTiles) do
		spreadFromTileAttack(map, moveTiles[i].x, moveTiles[i].y, ent.rn, moveTiles, attackTiles)
	end
end

-- This function will plot out a list of tiles that the specified entity
-- Can move to/attack
function plan(map, ent)
	local moveTiles = {}
	local attackTiles = {}
	
	spreadFromTileMovement(map, ent.x, ent.y, ent.sp, moveTiles)
	planAttack(map, ent, moveTiles, attackTiles)
	
	return moveTiles, attackTiles
end

return plan