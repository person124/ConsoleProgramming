screen = {}

function screen.load()
	screen.baseWidth = 960
	screen.baseHeight = 640

	screen.canvas = love.graphics.newCanvas(screen.baseWidth, screen.baseHeight)

	local screenHeight = love.graphics.getHeight()

	local scaler = screenHeight / screen.baseHeight

	screen.width = screen.baseWidth * scaler
	screen.height = screenHeight
	screen.scaler = scaler


	love.graphics.setBlendMode("alpha")
end

function screen.start()
	love.graphics.setColor(255, 255, 255)

	love.graphics.setCanvas(screen.canvas)
	love.graphics.clear()
end

function screen.stop()
	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(screen.canvas, 0, 0, 0, screen.scaler)
end