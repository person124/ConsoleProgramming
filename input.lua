input = {}

--[[
	TOUCH SCREEN RELATED THINGS!!!!!!
]]--

function input.load()
	input.count = 0 -- Keeps track of the number of touches
	input.x = -1 -- x location of the touch
	input.y = -1 -- y location of the touch

	input.screenX = -1 -- x location of the touch on sub-screen
	input.screenY = -1 -- y location of the touch on sub-screen

	input.mouse = {}
	for i=1,3 do
		input.mouse[i] = false
	end
end

-- Built in function that is called on touch start
function love.touchpressed(id, x, y, dx, dy, pressure)
	input.count = input.count + 1
	input.x = x
	input.y = y
end


-- Built in function that is called on touch release
function love.touchreleased(id, x, y, dx, dy, pressure)
	input.count = input.count - 1
	
	if input.count == 0 then
		input.x = -1
		input.y = -1
	end
end

-- Built in function that is called when a current touch moves
function love.touchmoved(id, x, y, dx, dy, pressure)
	if input.count == 1 then
		input.x = x
		input.y = y
	elseif input.count == 2 then 
		screen.addOffset(dx, dy)
	end
end

--[[
	MOUSE RELATED THINGS!!!!!
]]--

-- Built in function, f will be false if the window has lost focus,
-- will always return true on a mobile device
function love.mousefocus(f)
	if not f then
		for i=1,3 do input.mouse[i] = false end

		input.x = -1
		input.y = -1
	end
end

-- Built in function that has the position and button of a mouse click
function love.mousepressed(x, y, button)
	input.x = x
	input.y = y
	input.mouse[button] = true
end


-- Built in function that has the position and button of a released mouse click
function love.mousereleased(x, y, button)
	input.mouse[button] = false
	input.x = x
	input.y = y
end

-- Built in function that has the position of a moved mouse click
function love.mousemoved(x, y, dx, dy)
	input.x = x
	input.y = y

	if input.mouse[2] then
		screen.addOffset(dx, dy)
	end
end