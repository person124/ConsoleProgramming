local main = {}

-- TODOS:
	-- background audio
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
	-- Handles texture loading and caching
	main.textures = require("core/graphics/textures")
	main.textures.load()

	-- Handles animation loading and caching
	main.animations = require("core/graphics/animations")
	defaultAnimations = main.animations.loadFile("assets/anim")

	-- Handles audio loading and caching
	main.audio = require("core/audio")
	main.audio.load()

	-- Handles touch/mouse input
	main.input = require("core/input")
	main.input.load()

	-- Handles the subscreen and everything related to it
	main.screen = require("core/graphics/screen")
	main.screen.load()

	-- Handles all the different types of tiles
	main.tiles = require("core/gameplay/tiles")
	main.tiles.load()

	-- Handles data for entity creation
	main.entity = require("core/gameplay/entities")
	main.entity.load()

	-- Load in the main menu
	goToMainMenu()

	screenFiller = require("core/graphics/screenFiller")
end

-- Built in function called every frame to have updates
-- dt parameter is the step update time
function love.update(dt)
	main.input.update(main.mode, main.screen)

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

function goToMainMenu()
	main.mode = {}
	main.mode = require("core/modes/levelSelect")
	-- Open the map folder
	main.mode.start("maps")
end

function loadMap(mapName)
	main.mode = {}
	main.mode = require("core/modes/game")
	main.mode.start(mapName)
end

function endGame(didWin)
	main.mode = {}
	main.mode = require("core/modes/afterLevel")
	main.mode.start(didWin)
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
	return main.tiles.data[id]
end

function getEntitiesInstance()
	return main.entity
end

function getEntity(id)
	return main.entity.data[id]
end

function getModeInstance()
	return main.mode
end

function getCurrentMap()
	return main.mode.map
end