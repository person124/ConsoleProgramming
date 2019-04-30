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
local currentAnim = nil

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
					currentAnim = v.anim
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
					currentAnim = v.anim
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
	game.start("test_map")

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

function editor.tapTile(tileX, tileY)
	print(tileX, tileY)
end

function editor.render(screen)
	map.render(screen)

	love.graphics.setNewFont(64)
	love.graphics.print(currentMode[2])

	love.graphics.setNewFont(32)
	love.graphics.print("Currently Selected: ", 0, 64)
	if currentAnim ~= nil then
		love.graphics.draw(getTexture(currentAnim.info.sheet),
			currentAnim:getFrame(), 308, 66, 0, 0.5, 0.5)
	end
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then return end

	-- Switch current mode
	for i,v in pairs(MODES) do
		if v[1] == key then
			currentMode = v
			currentAnim = nil
			return
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