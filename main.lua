require("screen")
require("textures")
require("tiles")

function love.load()
	screen.load()
	textures.load()
	tiles.load()
end

function love.draw()
	love.graphics.print('Hello World', 400, 300)

	screen.start()
	tiles.render("test", 0, 0)
	screen.stop()
end