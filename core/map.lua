--[[
	This file is HEAVILY subject to change, in the current state exists
	only to get an idea of what rendering would look like
--]]

map = {}

function map.load()
	map.width = 3
	map.height = 5

	map.tiles = {}
	map.movementTiles = {}
	for i=1,map.width do
		map.tiles[i] = {}
		map.movementTiles[i] = {}
		for j=1,map.height do
			map.tiles[i][j] = "test"
			map.movementTiles[i][j] = false
		end
	end

	map.entities = {}
	map.addEntity(entity["unit"])
	map.entities[1].x = 2
	map.entities[1].y = 2
	
	map.getMovement(map.entities[1])
end

function map.render()
	for x=1,map.width do
		for y=1,map.height do
			tiles.render(map.tiles[x][y], (x - 1) * 64, (y - 1) * 64)

			if map.movementTiles[x][y] then
				love.graphics.rectangle('fill', (x - 1) * 64, (y - 1) * 64, 64, 64)
			end
		end
	end

	for i=1,table.getn(map.entities) do
		entity.render(map.entities[i])
	end
end

function map.addEntity(ent)
	table.insert(map.entities, entity.copy(ent))
end

-- When the player taps a tile call this function with the tile X and Y
function map.tapTile(tileX, tileY)
	if tileX <= map.width and tileY <= map.height and map.movementTiles[tileX][tileY] then
		map.entities[1].x = tileX
		map.entities[1].y = tileY

		map.getMovement(map.entities[1])
	end
end

-- Local recursive function to work out which tiles a unit can move to
local function spreadFromTile(startX, startY, tileX, tileY, tilesLeft)
	for x=-1,1 do
		for y=-1,1 do
			if (x ~= 0 and y == 0) or (y ~= 0 and x == 0) then
				local adjustedX = tileX + x
				local adjustedY = tileY + y

				if adjustedX > 0 and adjustedY > 0 and adjustedX <= map.width and adjustedY <= map.height then
				if not (adjustedX == startX and adjustedY == startY) then	
					map.movementTiles[adjustedX][adjustedY] = true

					if tilesLeft - 1 > 0 then
						spreadFromTile(startX, startY, adjustedX, adjustedY, tilesLeft - 1)
					end
				end
				end
			end
		end
	end
end

-- Returns a list of movement/attack tiles that the unit can move/attack to
-- if displayResults is true, it will show the results to the user
function map.getMovement(ent, displayResults)
	for i=1,map.width do
		for j=1,map.height do
			map.movementTiles[i][j] = false
		end
	end

	spreadFromTile(ent.x, ent.y, ent.x, ent.y, ent.sp)
end