input = {}

--[[
	TOUCH SCREEN RELATED THINGS!!!!!!
]]--

function input.load()
	input.count = 0 -- Keeps track of the number of touches

	input.mouse = {}
	for i=1,3 do
		input.mouse[i] = false
	end
	input.mouse.x = 0
	input.mouse.y = 0
end

-- Built in function that is called on touch start
function love.touchpressed(id, x, y, dx, dy, pressure)
	input.count = input.count + 1
end


-- Built in function that is called on touch release
function love.touchreleased(id, x, y, dx, dy, pressure)
	input.count = input.count - 1
end

-- Built in function that is called when a current touch moves
function love.touchmoved(id, x, y, dx, dy, pressure)
	if input.count == 2 then 
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
	end
end

-- Built in function that has the position and button of a mouse click
function love.mousepressed(x, y, button)
	input.mouse.x = x
	input.mouse.y = y
	input.mouse[button] = true
end


-- Built in function that has the position and button of a released mouse click
function love.mousereleased(x, y, button)
	input.mouse[button] = false
	input.mouse.x = x
	input.mouse.y = y
end

-- Built in function that has the position of a moved mouse click
function love.mousemoved(x, y, dx, dy)
	input.mouse.x = x
	input.mouse.y = y

	if input.mouse[2] then
		screen.addOffset(dx, dy)
	end
end