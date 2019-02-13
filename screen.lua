screen = {}

-- This function generates the sub screen and does necessary math
-- to set it up
function screen.load()
	-- This is the resolution of the subscreen
	screen.baseWidth = 960
	screen.baseHeight = 640

	-- This controls the camera offset of the map
	screen.offset = {}
	screen.offset.x = 0
	screen.offset.y = 0

	-- a canvas to draw the subscreen to
	screen.canvas = love.graphics.newCanvas(screen.baseWidth, screen.baseHeight)

	-- Get the screen width and height, necessary for math
	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	-- attempt to make a scaler value based on height
	local scaler = screenHeight / screen.baseHeight

	-- Check to see if it works for width as well
	if screen.baseWidth > screenWidth then
		-- if not make scaler value on width
		scaler = screenWidth / screen.baseWidth
	end

	-- Apply whichever scaler value was used
	screen.width = screen.baseWidth * scaler
	screen.height = screen.baseHeight * scaler
	screen.scaler = scaler

	-- Calculate the center point of the screen to figure out where to draw
	-- the subscreen to center it
	local centerX = screenWidth / 2
	local centerY = screenHeight / 2

	-- Calculate the draw point including offsets
	screen.drawX = centerX - (screen.width / 2)
	screen.drawY = centerY - (screen.height / 2)

	-- set the blendmode, shouldn't need to be changed ever
	love.graphics.setBlendMode("alpha")
end

-- This function enables drawing to the subscreen
function screen.start()
	-- Setting the color is NECESSARY
	love.graphics.setColor(255, 255, 255)

	-- Swap the draw canvas to the subscreen and clear it to get it ready
	-- to be drawn too
	love.graphics.setCanvas(screen.canvas)
	love.graphics.clear()

	-- Both of these things AREN'T needed, but for debug purposes are here
	love.graphics.setLineWidth(10)
	love.graphics.rectangle('line', 0, 0, screen.baseWidth, screen.baseHeight)
end

-- The function stops drawing to the subscreen as well as draws the subscreen
-- centered. If a parameter is given then it WON'T draw the subscreen
function screen.stop(draw)
	-- Reset the canvas to the main one
	love.graphics.setCanvas()

	-- Change the draw color. This is NEEDED
	love.graphics.setColor(255, 255, 255)

	-- As long as nothing is passed, then draw away!
	if draw == nil then
		love.graphics.draw(screen.canvas, screen.drawX, screen.drawY, 0, screen.scaler)
	end
end

-- Sets the screen's offset to specified numbers
function screen.setOffset(x, y)
	screen.offset.x = x
	screen.offset.y = y
end

-- Adds the specified numbers to the offset
function screen.addOffset(dx, dy)
	screen.offset.x = screen.offset.x + dx
	screen.offset.y = screen.offset.y + dy
end

function screen.screenToSubScreen(inX, inY)
	outX = 0
	outY = 0

	return outX, outY
end