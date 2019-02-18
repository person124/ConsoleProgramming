require("core/screen") -- Handles the subscreen and everything related to it
require("core/textures") -- Handles texture loading and caching
require("core/tiles") -- Handles all the different types of tiles
require("core/entity") -- Handles data for entity creation
require("core/map") -- Contains data of the current tile arragement
require("core/input") -- Handles touch/mouse input

-- Built in function called before the game starts, all data will be loaded in here
function love.load()
	screen.load()
	textures.load()

	tiles.load()
	entity.load()

	map.load()

	input.load()
end

-- Built in function called every frame to have updates
-- dt parameter is the step update time
function love.update(dt)
	input.update()
end

-- Built in function called every frame to render the scene
function love.draw()
	love.graphics.print('Hello World', 400, 300)

	screen.start()
		map.render()
	screen.stop()

	love.graphics.print(input.count, 400, 400)

	love.graphics.circle('fill', input.x, input.y, 20)

	love.graphics.print(input.screenX .. " " .. input.screenY, 450, 400)
end