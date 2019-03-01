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
	love.graphics.clear(0, 0, 0, 255)
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

-- Makes sure the current offset aligns with the min and
-- the max that map allows
local function checkOffset()
	-- Make sure the offset is within the map's boundaries
	local offMin, offMax = getGameInstance().map.getMinMaxOffset()
	-- minmax is in utils
	screen.offset.x = minmax(screen.offset.x, offMin.x, offMax.x)
	screen.offset.y = minmax(screen.offset.y, offMin.y, offMax.y)
end

-- Sets the screen's offset to specified numbers
function screen.setOffset(x, y)
	screen.offset.x = x
	screen.offset.y = y
	
	checkOffset()
end

-- Adds the specified numbers to the offset
function screen.addOffset(dx, dy)
	screen.offset.x = screen.offset.x + dx
	screen.offset.y = screen.offset.y + dy
	
	checkOffset()
end

-- Converts a point of the game window to a point in the subscreen
-- Will return -1, -1 if the point isn't on the subscreen
-- Otherwise will return windowX, windowY
function screen.screenToSubScreen(inX, inY)
	-- Check if the pointer is on the screen
	if inX == -1 or inY == -1 then
		return -1, -1
	end

	-- Check to see if the input is in the lower bounds
	if inX < screen.drawX or inY < screen.drawY then
		return -1, -1
	end

	-- Check to see if the input is outside the upper bounds
	if inX > (screen.drawX + screen.width) or
	inY > (screen.drawY + screen.height) then
		return -1, -1
	end

	-- Do some math to put the input in the screen
	outX = (inX - screen.drawX) / screen.scaler
	outY = (inY - screen.drawY) / screen.scaler

	return outX, outY
end