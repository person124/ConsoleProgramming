--[[
	This file contains information to use for map handling.
	This file will be altered later to better import map data.
--]]

local map = {}

-- Currently this function loads in the example map data
-- Will be replaced by a better more versatile map loader
function map.load()
	map.width = 5
	map.height = 5

	map.tiles = {}
	for i=1,map.width do
		map.tiles[i] = {}
		for j=1,map.height do
			map.tiles[i][j] = getTile("grass")
		end
	end
	
	map.tiles[3][4] = getTile("wall")
	map.tiles[3][2] = getTile("wall")
	map.tiles[3][3] = getTile("wall")
	map.tiles[2][3] = getTile("wall")
	map.tiles[4][3] = getTile("wall")
	
	map.movementTiles = {}
	map.attackTiles = {}

	map.entities = {}

	-- Test entity one
	map.addEntity("unit")
	map.entities[1].x = 3
	map.entities[1].y = 1

	-- Test Entity two
	map.addEntity("unit")
	map.entities[2].x = 3
	map.entities[2].y = 5
	map.entities[2].sp = 1
	map.entities[2].isEnemy = true

	-- This represents the currently selected entity
	map.currentlySelected = nil

	map.getMinMaxOffset()
	
	-- This is called to center the screen if needed
	getScreenInstance().setOffset(0, 0)
end


-- Draws the map and entities to the screen
function map.render(screen)
	-- Tile rendering
	for x=1,map.width do
		for y=1,map.height do
			getTilesInstance().render(map.tiles[x][y], x, y, screen)
		end
	end
	
	-- Movement grid rendering
	for i=1,table.getn(map.movementTiles) do
		local p = map.movementTiles[i]
		love.graphics.draw(getTexture("movement"),
			(p.x - 1) * 64 - screen.offset.x,
			(p.y - 1) * 64 - screen.offset.y)
	end
	
	-- Attack grid rendering
	for i=1,table.getn(map.attackTiles) do
		local p = map.attackTiles[i]
		love.graphics.draw(getTexture("attack"),
			(p.x - 1) * 64 - screen.offset.x,
			(p.y - 1) * 64 - screen.offset.y)
	end

	-- Entity rendering
	for i=1,table.getn(map.entities) do
		getEntitiesInstance().render(map.entities[i], screen)
	end
	
	-- Entity information rendering
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle("fill", 0, 0, screen.baseWidth, 33)
	love.graphics.setColor(255, 255, 255, 255)
	if map.currentlySelected ~= nil then
		local ent = map.currentlySelected
		
		-- Render selected entity stats
		love.graphics.print("HP: " .. ent.hp .. " / " .. ent.stats.hp .. "          " ..
							"AT: " .. ent.at .. " / " .. ent.stats.at .. "          " ..
							"SP: " .. ent.sp .. " / " .. ent.stats.sp .. "          " ..
							"RN: " .. ent.rn .. " / " .. ent.stats.rn, 0, 0, 0, 2.5)
		-- Render circle around selected entity
		love.graphics.draw(getTexture("selected-" .. tostring(ent.isEnemy)),
			(ent.x - 1) * 64 - screen.offset.x,
			(ent.y - 1) * 64 - screen.offset.y)
	end
end

-- Makes a copy of the given entity and adds it to the
-- List of entities
function map.addEntity(entity)
	local ent = getEntity(entity) -- Converting id to entity
	-- Adding the copy to the table
	table.insert(map.entities, getEntitiesInstance().copy(ent))
end

-- Clears the selected entity
function map.clearSelection()
	map.currentlySelected = nil
	map.movementTiles = {}
	map.attackTiles = {}
end

-- Using the current map width and height
-- Calculate/Get the max/min offsets to make sure
-- the level can't be scrolled off screen
-- Returns two the min then the max both with two members
-- x and y.
function map.getMinMaxOffset()
	local screen = getScreenInstance()

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

-- Returns the solidity of the tiles at the specified location
-- If outside the scope of the level it will return true
function map.isSolid(tileX, tileY)
	if tileX > 0 and tileY > 0 and tileX <= map.width and tileY <= map.height then
		return map.tiles[tileX][tileY].isSolid
	end
	
	return true
end

-- Returns an entity at the specified location, will return nil if nothing is there
function map.getEntity(tileX, tileY)
	for i=1,table.getn(map.entities) do
		if map.entities[i].x == tileX and map.entities[i].y == tileY then
			return map.entities[i]
		end
	end
	
	return nil
end

-- Moves the specified entity to the specified location
function map.moveEntity(ent, tileX, tileY)
	ent.x = tileX
	ent.y = tileY
end

-- Reloads the map, clearing any killed entities
function map.refresh()
	utils.removeDeadEntities(map.entities)
end

return map