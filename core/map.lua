--[[
	This file is HEAVILY subject to change, in the current state exists
	only to get an idea of what rendering would look like
--]]

map = {}

local movementTile = 3
local attackTile = 5

-- Currently this function loads in the example map data
-- Will be replaced by a better more versatile map loader
function map.load()
	map.width = 3
	map.height = 5

	map.tiles = {}
	for i=1,map.width do
		map.tiles[i] = {}
		for j=1,map.height do
			map.tiles[i][j] = "test"
		end
	end
	
	map.movementTiles = {}

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
	map.entities[2].isEnemy = true

	-- This represents the currently selected entity
	map.currentlySelected = nil

	map.getMinMaxOffset()
	
	-- This is called to center the screen if needed
	screen.setOffset(0, 0)
end


-- Draws the map and entities to the screen
function map.render()
	-- Tile rendering
	for x=1,map.width do
		for y=1,map.height do
			tiles.render(map.tiles[x][y], (x - 1) * 64, (y - 1) * 64)
		end
	end
	
	-- Movement grid rendering
	for i=1,table.getn(map.movementTiles) do
		local p = map.movementTiles[i]
		love.graphics.draw(textures["movement"],
			(p.x - 1) * 64 - screen.offset.x,
			(p.y - 1) * 64 - screen.offset.y)
	end

	-- Entity rendering
	for i=1,table.getn(map.entities) do
		entity.render(map.entities[i])
	end
	
	-- Entity information rendering
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, screen.baseWidth, 33)
	love.graphics.setColor(255, 255, 255, 255)
	if map.currentlySelected ~= nil then
		local ent = map.currentlySelected
		love.graphics.print("HP: " .. ent.hp .. " / " .. ent.stats.hp .. "          " ..
							"AT: " .. ent.at .. " / " .. ent.stats.at .. "          " ..
							"SP: " .. ent.sp .. " / " .. ent.stats.sp .. "          " ..
							"RN: " .. ent.rn .. " / " .. ent.stats.rn, 0, 0, 0, 2.5)
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
			if map.entities[i].x == tileX and map.entities[i].y == tileY 
				and not map.entities[i].isEnemy then
				map.currentlySelected = map.entities[i]
				-- map.getMovement(map.entities[i], true)
				map.movementTiles = ai.plan(map, map.entities[i])
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


-- Returns true if an entity is on a space
-- Otherwise returns false
function map.isEntityOnSpace(xPos, yPos)
	for i=1,table.getn(map.entities) do
		if map.entities[i].x == xPos and map.entities[i].y == yPos then
			return true
		end
	end
	
	return false
end