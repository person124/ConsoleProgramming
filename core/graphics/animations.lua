local animations = {}

function animations.create(spriteSheetName, xOff, yOff, width, height, xCount, yCount, updateTime)
	local anim = {}

	anim.info = {}
	anim.info.width = width
	anim.info.height = height
	anim.info.sheet = spriteSheetName
	anim.info.updateTime = updateTime
	anim.info.frameCount = yCount * xCount
	anim.info = utils.protect(anim.info)

	-- Get the reference sprite sheet for its width and height
	local sheetTemp = getTexture(spriteSheetName)
	anim.quads = {}
	for x=1,xCount do
		for y=1,yCount do
			-- Generate the frame of the animation
			anim.quads[x + ((y - 1) * xCount)] = love.graphics.newQuad(
				xOff + ((x - 1) * width), -- Frame x location
				yOff + ((y - 1) * height), -- Frame y location
				width, -- Width of the animation
				height, -- Height of the animation
				sheetTemp:getDimensions() -- Size of the reference sheet
			)
		end
	end
	anim.quads = utils.protect(anim.quads)

	-- Keep track of the timer variable
	anim.currentTime = 0
	anim.currentFrame = 1

	-- Generate the get frame function
	anim.getFrame = function(self)
		return self.quads[self.currentFrame]
	end

	-- Return the resulting animation
	return anim
end

function animations.loadFile(fileName)
	local fileLoaded = require(fileName)
	return fileLoaded(animations)
end

-- Updates the given list of animations
function animations.update(dt, animationList)
	for i,v in pairs(animationList) do
		local anim = v

		if anim.info.updateTime ~= 0 then
			anim.currentTime = anim.currentTime + dt

			-- Update the current frame of the animation
			if anim.currentTime > anim.info.updateTime then
				anim.currentTime = 0
				anim.currentFrame = anim.currentFrame + 1

				if anim.currentFrame > anim.info.frameCount then
					anim.currentFrame = 1
				end
			end
		end
	end
end

return animations