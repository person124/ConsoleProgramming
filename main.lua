require("screen")
require("textures")
require("tiles")
require("map")

function love.load()
	screen.load()
	textures.load()
	tiles.load()

	map.load()
end

function love.draw()
	love.graphics.print('Hello World', 400, 300)

	screen.start()
	--tiles.render("test", 0, 0)
	map.render()
	screen.stop()

	love.graphics.print(screen.scaler, 400, 400)
end