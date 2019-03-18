local animations = {}

function animations.create(spriteSheetName, width, height, xCount, yCount)
	local anim = {}
	anim.width = width
	anim.height = height
	anim.sheet = spriteSheetName

	-- Get the reference sprite sheet for its width and height
	local sheetTemp = getSprite(spriteSheetName)
	for x=1,xCount do
		for y=1,yCount do
			-- Generate the frame of the aimation
			anim[x + (y - 1) * xCount] = love.graphics.newQuad(
				(x - 1) * width, -- Frame x location
				(y - 1) * height, -- Frame y location
				width, -- Width of the animation
				height, -- Height of the animation
				sheetTemp:getDimenstions() -- Size of the reference sheet
			)
		end
	end
end

function animations.load()
	
end

return animations