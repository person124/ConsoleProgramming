--[[
	This file is HEAVILY subject to change, in the current state exists
	only to get an idea of what rendering would look like
--]]

map = {}

-- Currently this function loads in the example map data
-- Will be replaced by a better more versatile map loader
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
			map.movementTiles[i][j] = nil
		end
	end

	map.entities = {}

	-- Test entity one
	map.addEntity(entity["unit"])
	map.entities[1].x = 2
	map.entities[1].y = 2

	-- Test Entity two
	map.addEntity(entity["unit"])
	map.entities[2].x = 2
	map.entities[2].y = 4
	map.entities[2].sp = 1

	-- This represents the currently selected entity
	map.currentlySelected = nil

	map.clearMovement()
	map.getMinMaxOffset()
end


-- Draws the map and entities to the screen
function map.render()
	for x=1,map.width do
		for y=1,map.height do
			tiles.render(map.tiles[x][y], (x - 1) * 64, (y - 1) * 64)

			if map.movementTiles[x][y] == true then
				love.graphics.draw(textures["movement"],
				(x - 1) * 64 - screen.offset.x,
				(y - 1) * 64 - screen.offset.y)
			end
		end
	end

	for i=1,table.getn(map.entities) do
		entity.render(map.entities[i])
	end
end

-- Makes a copy of the given entity and adds it to the
-- List of entities
function map.addEntity(ent)
	table.insert(map.entities, entity.copy(ent))
end

-- When the player taps a tile call this function with the tile X and Y
function map.tapTile(tileX, tileY)
	if map.currentlySelected == nil then
		for i=1,table.getn(map.entities) do
			if map.entities[i].x == tileX and map.entities[i].y == tileY then
				map.currentlySelected = map.entities[i]
				map.getMovement(map.entities[i], true)
				return
			end
		end
	else
		if tileX <= map.width and tileY <= map.height and map.movementTiles[tileX][tileY] then
			map.currentlySelected.x = tileX
			map.currentlySelected.y = tileY

			map.currentlySelected = nil

			map.clearMovement()
		end
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
					if map.movementTiles[adjustedX][adjustedY] == nil then
						map.movementTiles[adjustedX][adjustedY] = true
					end

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
	map.clearMovement()

	spreadFromTile(ent.x, ent.y, ent.x, ent.y, ent.sp)
end

-- Clears the list of movement tiles
function map.clearMovement()
	for i=1,map.width do
		for j=1,map.height do
			map.movementTiles[i][j] = nil
		end
	end

	for i=1,table.getn(map.entities) do
		map.movementTiles[map.entities[i].x][map.entities[i].y] = false	
	end
end

-- Using the current map width and height
-- Calculate/Get the max/min offsets to make sure
-- the level can't be scrolled off screen
-- Returns two the min then the max both with two members
-- x and y.
function map.getMinMaxOffset()
	-- If the calculation has already been done, return the result
	if map.offsetLimit ~= nil then
		return map.offsetLimit.min, map.offsetLimit.max
	end
	
	--Otherwise, calculate it
	map.offsetLimit = {}
	map.offsetLimit.min = {}
	map.offsetLimit.min.x = 0
	map.offsetLimit.min.y = 0
	map.offsetLimit.max = {}
	map.offsetLimit.max.x = 0
	map.offsetLimit.max.y = 0
	
	-- If the level doesn't fit on one screen
	if map.width * 64 > screen.baseWidth then
		map.offsetLimit.max.x = (map.width * 64) - screen.baseWidth
	else
		-- This is if the level fits on one screen
		local centerX = screen.baseWidth * 0.5
		local xOff = centerX - (map.width * 32) -- 32 is because 64/2
	
		map.offsetLimit.min.x = -xOff
		map.offsetLimit.max.x = -xOff
	end
	
	-- The same setup as before but with y
	if map.height * 64 > screen.baseHeight then
		map.offsetLimit.max.y = (map.height * 64) - screen.baseHeight
	else
		local centerY = screen.baseHeight * 0.5
		local yOff = centerY - (map.height * 32)
	
		map.offsetLimit.min.y = -yOff
		map.offsetLimit.max.y = -yOff
	end
end