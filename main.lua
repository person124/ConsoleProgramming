require("textures")
require("tiles")

function love.load()
	textures.load()
	tiles.load()
end

function love.draw()
	love.graphics.print('Hello World', 400, 300)

	tiles.render("test", 64, 64)
end