local screenFiller = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight());
love.graphics.setBlendMode("alpha")

love.graphics.setCanvas(screenFiller)
love.graphics.clear(255, 255, 255);

love.graphics.setColor(0, 255, 0, 255)
love.graphics.setLineWidth(2)
for i=1,100 do
	local x = screenFiller:getWidth() / 100 * i
	local y = screenFiller:getHeight() / 100 * i
	print(x, y)
	love.graphics.line(x, 0, 0, y)
end

love.graphics.setCanvas()
return screenFiller;