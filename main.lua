require("textures")

function love.load()
	textures.load()
end

function love.draw()
	love.graphics.print('Hello World', 400, 300)

	love.graphics.draw(textures["test"], 40, 40)
end