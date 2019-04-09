local function getAnimations(a)
	local anim = {}

	anim["unit"] = a.create("unit", 0, 0, 64, 64, 1, 1, 0)

	anim["tile_grass"] = a.create("tiles", 0, 0, 64, 64, 1, 2, 0)
	anim["tile_wall"] = a.create("tiles", 64, 0, 64, 64, 1, 1, 0)

	return anim
end

return getAnimations