local screen = getScreenInstance()
local width = love.graphics.getWidth()
local height = love.graphics.getHeight()
local lineCount = 10

-- Canvas setup
local screenFiller = love.graphics.newCanvas(width, height)
love.graphics.setBlendMode("alpha")
love.graphics.setCanvas(screenFiller)
love.graphics.clear(54, 35, 54) -- Dark Dark Purple

-- Lines running across the screen
love.graphics.setColor(196, 151, 48) -- Gold-ish
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

-- Outer border
love.graphics.setColor(196, 151, 48) -- Gold-ish
love.graphics.setLineWidth(8)
love.graphics.rectangle('line', screen.drawX, screen.drawY, screen.width, screen.height)

-- Inner border
love.graphics.setColor(114, 15, 88) -- Lighter-Dark Purple
love.graphics.setLineWidth(5)
love.graphics.rectangle('line', screen.drawX, screen.drawY, screen.width, screen.height)

love.graphics.setCanvas()
return screenFiller