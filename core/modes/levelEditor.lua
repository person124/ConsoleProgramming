local MODES = {
	TILE = {"q", "Place Tiles"},
	ENTITY = {"w", "Place Entity"},
	DEL_ENTITY = {"e", "Remove Entity"}
}

local editor = {}

local game = {}
local map = {}

local currentMode = MODES.TILE

function editor.start()
	currentMode = MODES.TILE

	game = require("core/modes/game")
	game.start("test_map")
	
	map = game.map
	map.getMinMaxOffset()
end

function editor.update(dt)

	-- Switch current mode
	for i,v in pairs(MODES) do
		if love.keyboard.isDown(v[1]) then
			currentMode = v
			break
		end
	end
end

function editor.render(screen)
	map.render(screen)

	love.graphics.setNewFont(64)
	love.graphics.print(currentMode[2])
end

return editor