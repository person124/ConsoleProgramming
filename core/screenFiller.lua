local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local lineCount = 10

local screenFiller = love.graphics.newCanvas(width, height);
love.graphics.setBlendMode("alpha")

love.graphics.setCanvas(screenFiller)
love.graphics.clear(54, 35, 54);

love.graphics.setColor(196, 151, 48)
love.graphics.setLineWidth(2)
for i=1,lineCount do
	local x = width / lineCount * i
	local y = height / lineCount * i

	love.graphics.line(x, 0, 0, y)
end

for i=1,lineCount do
	local x = width / lineCount * i
	local y = height / lineCount * i

	love.graphics.line(x, height, width, y)
end

love.graphics.setCanvas()
return screenFiller;