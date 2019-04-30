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

	if currentMode == MODES.TILE then
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
	elseif key == "down" then -- Make Taller
		
	end
	
	if key == "left" then -- Make Thinner
		
	elseif key == "right" then -- Make fatter
		
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
end

return editor