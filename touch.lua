touch = {}

function touch.load()
	touch.count = 0 -- Keeps track of the number of touches
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	touch.count = touch.count + 1
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	touch.count = touch.count - 1
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	if touch.count == 2 then 
		screen.addOffset(dx, dy)
	end
end