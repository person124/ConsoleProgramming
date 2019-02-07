require("screen") -- Handles the subscreen and everything related to it
require("textures") -- Handles texture loading and caching
require("tiles") -- Handles all the different types of tiles
require("map") -- Contains data of the current tile arragement
require("input") -- Handles touch/mouse input

-- Built in function called before the game starts, all data will be loaded in here
function love.load()
	screen.load()
	textures.load()
	tiles.load()

	map.load()

	input.load()
end


-- Built in function called every frame to render the scene
function love.draw()
	love.graphics.print('Hello World', 400, 300)

	screen.start()
		map.render()
	screen.stop()

	love.graphics.print(input.count, 400, 400)
end