local main = {}

-- TODOS:
	-- Level Selector
	-- background audio
	-- extend tiles:
		-- On enter
		-- On exit
		-- On die on
		-- On stay
	-- Add abilities to Units
		-- One ability per unit?
	-- Give certain units better AI

-- Both of these are global objects
require("core/utils") -- This contains global public functions
require("core/ai_core") -- Contains AI functions

-- This is used to generate a background so the screen is not
-- Black and empty where the game isn't
local screenFiller = nil

-- Default animations to update
local defaultAnimations = nil

-- Built in function called before the game starts, all data will be loaded in here
function love.load()
	-- Load in the defualt font
	love.graphics.setNewFont(64)

	-- Handles texture loading and caching
	main.textures = require("core/textures")
	main.textures.load()

	-- Handles animation loading and caching
	main.animations = require("core/animations")
	defaultAnimations = main.animations.loadFile("assets/anim")

	-- Handles audio loading and caching
	main.audio = require("core/audio")
	main.audio.load()

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
	
	main.mode = require("core/modes/levelSelect")
	-- Open the map folder
	main.mode.start("maps")

	screenFiller = require("core/screenFiller")
end

-- Built in function called every frame to have updates
-- dt parameter is the step update time
function love.update(dt)
	main.input.update(main.game, main.screen)

	main.animations.update(dt, defaultAnimations)

	main.mode.update(dt)
end

-- Built in function called every frame to render the scene
function love.draw()
	love.graphics.draw(screenFiller)

	main.screen.start()
		main.mode.render(main.screen)
	main.screen.stop()
end

-- Below this point are the getter functions

function getTexturesInstance()
	return main.textures
end

function getTexture(id)
	return main.textures.get(id)
end

function getAnimationsInstance()
	return main.animations
end

function getAnimation(id)
	return main.animations[id]
end

function getAudioInstance()
	return main.audio
end

function getInputInstance()
	return main.input
end

function getScreenInstance()
	return main.screen
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

function getModeInstance()
	return main.mode
end

function getCurrentMap()
	return main.mode.map
end