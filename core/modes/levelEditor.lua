local editor = {}

local map = {}

function editor.start()
	map = require("core/modes/game")
	map.start("test_map")
end

function editor.update(dt)
	
end

function editor.render(screen)
	love.graphics.newFont(64)
	love.graphics.print("Still a WIP!", 0, 0)
end

return editor