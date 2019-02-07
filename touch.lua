touch = {}

function touch.load()
	touch.count = 0 -- Keeps track of the number of touches
end

-- Built in function that is called on touch start
function love.touchpressed(id, x, y, dx, dy, pressure)
	touch.count = touch.count + 1
end


-- Built in function that is called on touch release
function love.touchreleased(id, x, y, dx, dy, pressure)
	touch.count = touch.count - 1
end

-- Built in function that is called when a current touch moves
function love.touchmoved(id, x, y, dx, dy, pressure)
	if touch.count == 2 then 
		screen.addOffset(dx, dy)
	end
end