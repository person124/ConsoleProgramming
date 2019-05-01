function love.conf(t)
	t.version = "0.10.2"
	t.console = false

	t.window.title = "Tactical Knockout"

	t.modules.joystick = false
	t.modules.math = false
	t.modules.physics = false
	t.modules.video = false
	t.modules.thread = false
end