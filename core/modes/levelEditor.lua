local MODES = {
	TILE = {"q", "Place Tiles"},
	ENTITY = {"w", "Place Entity"},
	DEL_ENTITY = {"e", "Remove Entity"}
}

local editor = {}

local game = {}
local map = {}
local input = {}

local currentMode = MODES.TILE
local currentSelection = {1, 1}
local oldSelection = {1, 1}
local current = nil

-- Returns the currently selected sprite
local function getCurrentAnim()
	if currentMode == MODES.TILE then
		if oldSelection[1] ~= currentSelection[1] then
			-- Update the old
			oldSelection[1] = currentSelection[1]

			-- Get the new animation
			local counter = 1
			for i,v in pairs(getTilesInstance().data) do
				if counter == currentSelection[1] then
					current = v
					return
				else
					counter = counter + 1
				end
			end
		end
	elseif currentMode == MODES.ENTITY then
		if oldSelection[2] ~= currentSelection[2] then
			-- Update the old
			oldSelection[2] = currentSelection[2]

			-- Get the new animation
			local counter = 1
			for i,v in pairs(getEntitiesInstance().data) do
				if counter == currentSelection[2] then
					current = v
					return
				else
					counter = counter + 1
				end
			end
		end
	end
end

function editor.start()
	-- Reset defaults
	currentMode = MODES.TILE
	currentSelection = {1, 1}

	game = require("core/modes/game")
	game.start("editor_map")

	editor.map = game.map
	map = game.map
	map.getMinMaxOffset()

	input = getInputInstance()
end

function editor.update(dt)
	-- Update animations
	getAnimationsInstance().update(dt, game.getAnimations())
	getCurrentAnim()
end

function editor.render(screen)
	map.render(screen)

	love.graphics.setNewFont(64)
	love.graphics.print(currentMode[2])

	love.graphics.setNewFont(32)
	love.graphics.print("Currently Selected: ", 0, 64)
	if current ~= nil then
		love.graphics.draw(getTexture(current.anim.info.sheet),
			current.anim:getFrame(), 308, 66, 0, 0.5, 0.5)
	end
end

function editor.tapTile(tileX, tileY)
	if tileX > 0 and tileY > 0 and tileX <= map.width and tileY <= map.height then
		if currentMode == MODES.DEL_ENTITY then
			local ent = map.getEntity(tileX, tileY)
			if ent ~= nil then
				ent.hp = 0
				utils.removeDeadEntities(map.entities)
			end
		end

		if current == nil then return end

		if currentMode == MODES.TILE then
			map.tiles[tileX][tileY] = current
		elseif currentMode == MODES.ENTITY then
			if not map.isEntityOnSpace(tileX, tileY) then
				local ent = getEntitiesInstance().copy(current)
				ent.x = tileX
				ent.y = tileY
				table.insert(map.entities, ent)
			end
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then return end

	-- Switch current mode
	for i,v in pairs(MODES) do
		if v[1] == key then
			currentMode = v
			current = nil
			return
		end
	end

	if currentMode == MODES.TILE and current ~= null then
	-- Resize the map
	if key == "up" then -- Make shorter
		local newHeight = map.height - 1
		if newHeight <= 0 then return end

		local newTiles = {}
		for x=1,map.width do
			newTiles[x] = {}
			for y=1,newHeight do
				newTiles[x][y] = map.tiles[x][y]
			end
		end

		map.tiles = newTiles
		map.height = newHeight
		map.clearOutofBoundsEntities()
		map.offsetLimit = nil -- Reset the offset to force it to recalculate
	elseif key == "down" then -- Make Taller
		local newHeight = map.height + 1

		local newTiles = {}
		for x=1,map.width do
			newTiles[x] = {}
			for y=1,map.height do
				newTiles[x][y] = map.tiles[x][y]
			end
			newTiles[x][newHeight] = current
		end

		map.tiles = newTiles
		map.height = newHeight
		map.offsetLimit = nil -- Reset the offset to force it to recalculate
	end
	
	if key == "left" then -- Make Thinner
		local newWidth = map.width - 1
		if newWidth <= 0 then return end

		local newTiles = {}
		for x=1,newWidth do
			newTiles[x] = {}
			for y=1,map.height do
				newTiles[x][y] = map.tiles[x][y]
			end
		end

		map.tiles = newTiles
		map.width = newWidth
		map.clearOutofBoundsEntities()
		map.offsetLimit = nil -- Reset the offset to force it to recalculate
	elseif key == "right" then -- Make fatter
		local newWidth = map.width + 1

		local newTiles = {}
		for x=1,newWidth do
			newTiles[x] = {}
			for y=1,map.height do
				if x>map.width then
					newTiles[x][y] = current
				else
					newTiles[x][y] = map.tiles[x][y]
				end
			end
		end

		map.tiles = newTiles
		map.width = newWidth
		map.offsetLimit = nil -- Reset the offset to force it to recalculate
	end
	end

	-- Adjust current selection
	if key == "r" then -- Move up
		-- Adjust tiles
		if currentMode == MODES.TILE then
			currentSelection[1] = currentSelection[1] + 1

			if currentSelection[1] > getTilesInstance().count then
				currentSelection[1] = 1
			end
		-- Adjust entities
		elseif currentMode == MODES.ENTITY then
			currentSelection[2] = currentSelection[2] + 1

			if currentSelection[2] > getEntitiesInstance().count then
				currentSelection[2] = 1
			end
		end
	elseif key == "f" then -- Move down
		-- Adjust tiles
		if currentMode == MODES.TILE then
			currentSelection[1] = currentSelection[1] - 1

			if currentSelection[1] <= 0 then
				currentSelection[1] = getTilesInstance().count
			end
		-- Adjust entities
		elseif currentMode == MODES.ENTITY then
			currentSelection[2] = currentSelection[2] - 1

			if currentSelection[2] <= 0 then
				currentSelection[2] = getEntitiesInstance().count
			end
		end
	end

	if key == "escape" then
		clearAllLoadedData()
		goToMainMenu()
	end

	if key == "return" then
		editor.saveMap()
	end
end

function editor.saveMap()
	local data = "local map = {}\n" ..
	"-- Map Size\n" ..
	"map.width = " .. map.width .. "\n" .. 
	"map.height = " .. map.height .. "\n" ..

	"-- Tile Setup\n" ..
	"map.tiles = {}\n" ..
	"for x=1,map.width do\n" ..
	"map.tiles[x] = {}\n" ..
	"end\n" ..
	"-- Tile Data\n"
	for x=1,map.width do
		for y=1,map.height do
			data = data .. "map.tiles[" .. x .. "][" .. y .. "] = \"" ..
			map.tiles[x][y].const.id .. "\"\n"
		end
	end

	data = data .. "-- Entity Data\n" ..
	"map.entities = {}\n"
	for i=1,table.getn(map.entities) do
		data = data .. "map.entities[" .. i .. "] = {}\n" ..
		"map.entities[" .. i .. "].id = \"" .. map.entities[i].stats.id .. "\"\n" ..
		"map.entities[" .. i .. "].x = " .. map.entities[i].x .. "\n" ..
		"map.entities[" .. i .. "].y = " .. map.entities[i].y .. "\n"
	end

	data = data .. "-- Return the map data\nreturn map"

	-- Open the file
	local file = love.filesystem.newFile("maps/editor_map/map.lua")
	file:open("w")
	-- Write the data
	file:write(data)
	-- Close the file
	file:close()
end

return editor