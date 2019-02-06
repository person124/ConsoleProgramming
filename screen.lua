screen = {}

function screen.load()
	screen.baseWidth = 960
	screen.baseHeight = 640

	screen.canvas = love.graphics.newCanvas(screen.baseWidth, screen.baseHeight)

	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()

	local scaler = screenHeight / screen.baseHeight

	if screen.baseWidth > screenWidth then
		scaler = screenWidth / screen.baseWidth
	end

	screen.width = screen.baseWidth * scaler
	screen.height = screen.baseHeight * scaler
	screen.scaler = scaler

	love.graphics.setBlendMode("alpha")
end

function screen.start()
	love.graphics.setColor(255, 255, 255)
	love.graphics.setLineWidth(10)

	love.graphics.setCanvas(screen.canvas)
	love.graphics.clear()
	love.graphics.rectangle('line', 0, 0, screen.baseWidth, screen.baseHeight)
end

function screen.stop()
	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(screen.canvas, 0, 0, 0, screen.scaler, screen.scaler)
end