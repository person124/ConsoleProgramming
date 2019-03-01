local main = {}

-- Both of these are global objects
require("core/utils") -- This contains global public functions
require("core/ai_core") -- Contains AI functions

-- This is used to generate a background so the screen is not
-- Black and empty where the game isn't
local screenFiller = nil

-- Built in function called before the game starts, all data will be loaded in here
function love.load()
	-- Handles texture loading and caching
	main.textures = require("core/textures")
	main.textures.load()

	-- Handles touch/mouse input
	main.input = require("core/input")
	main.input.load()
	
	-- Handles the subscreen and everything related to it
	main.screen = require("core/screen")
	main.screen.load()

	-- Handles all the different types of tiles
	main.tiles = require("core/tiles")
	main.tiles.load()

	-- Handles data for entity creation
	main.entity = require("core/entities")
	main.entity.load()

	main.game = require("core/game")
	main.game.load()

	screenFiller = require("core/screenFiller")
end

-- Built in function called every frame to have updates
-- dt parameter is the step update time
function love.update(dt)
	main.input.update(main.game, main.screen)
end

-- Built in function called every frame to render the scene
function love.draw()
	love.graphics.draw(screenFiller)

	main.screen.start()
		main.game.render(main.screen)
	main.screen.stop()
end

function getGameInstance()
	return main.game
end

function getCurrentMap()
	return main.game.map
end

function getInputInstance()
	return main.input
end

function getScreenInstance()
	return main.screen
end

function getTexturesInstance()
	return main.textures
end

function getTexture(id)
	return main.textures[id]
end

function getTilesInstance()
	return main.tiles
end

function getTile(id)
	return main.tiles[id]
end

function getEntitiesInstance()
	return main.entity
end

function getEntity(id)
	return main.entity[id]
end