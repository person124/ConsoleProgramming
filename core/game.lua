local game = {}

function game.load()
	game.map = require("core/map")
	game.map.load()
end

function game.tapTile(tileX, tileY)
	game.map.tapTile(tileX, tileY)
end

function game.render(screen)
	game.map.render(screen)
end

return game