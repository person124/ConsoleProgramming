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

function editor.start()
	-- Reset defaults
	currentMode = MODES.TILE
	currentSelection = {1, 1}

	game = require("core/modes/game")
	game.start("test_map")
	
	map = game.map
	map.getMinMaxOffset()
	
	input = getInputInstance()
end

function editor.update(dt)
	-- Update animations
	getAnimationsInstance().update(dt, game.getAnimations())

	-- On Left Click
	-- Enact the current mode
	if input.count == 1 then
		if currentMode == MODES.TILE then
		print("click!")
		end
	end
end

function editor.render(screen)
	map.render(screen)

	love.graphics.setNewFont(64)
	love.graphics.print(currentMode[2])
end

function love.keypressed(key, scancode, isrepeat)
	if isrepeat then return end

	-- Switch current mode
	for i,v in pairs(MODES) do
		if v[1] == key then
			currentMode = v
			return
		end
	end

	-- Adjust current selection
	if key == "r" then

	elseif key == "f" then

	end
end

return editor