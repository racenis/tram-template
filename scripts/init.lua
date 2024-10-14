print("\n\nHello! This is the Tramway SDK template application.\n")
print("Here's some ideas for what you could do:")
print("- Use the arrow keys or WASD to rotate the teapot.")
print("- Press F1 to quit.")
print("- Press F9 to unlock view.")
print("- Press F12 to take a screenshot.")
print("- Press Tilde (~) for debug menu.")
print("- Press ESC for settings.")

-- Retitling the main window.
tram.ui.SetWindowTitle("Teapot Explorer v1.0")
tram.ui.SetWindowSize(640, 480)

-- Setting up the global lighting.
tram.render.SetSunColor(tram.math.vec3(0.0, 0.0, 0.0))
tram.render.SetSunDirection(tram.math.DIRECTION_FORWARD)
tram.render.SetAmbientColor(tram.math.vec3(0.1, 0.1, 0.1))
tram.render.SetScreenClearColor(tram.render.COLOR_BLACK)

-- Move the camera a bit away from the origin.
tram.render.SetViewPosition(tram.math.DIRECTION_FORWARD * -1.2)

-- Setting up a light so that you can see something.
scene_light = tram.components.Light()
scene_light:SetColor(tram.render.COLOR_WHITE)
scene_light:SetLocation(tram.math.vec3(5.0, 5.0, 5.0))
scene_light:Init()

-- Adding a teapot to the scene.
teapot = tram.components.Render()
teapot:SetModel("teapot")
teapot:Init()



-- This vector here will contain teapot euler angle rotation in radians.
local teapot_modifier = tram.math.vec3(0.0, 0.0, 0.0)

-- This function will be called every tick.
tram.event.AddListener(tram.event.TICK, function()
	if tram.ui.PollKeyboardKey(tram.ui.KEY_LEFT) or tram.ui.PollKeyboardKey(tram.ui.KEY_A) then
		teapot_modifier = teapot_modifier - tram.math.vec3(0.0, 0.01, 0.0)
	end
	
	if tram.ui.PollKeyboardKey(tram.ui.KEY_RIGHT) or tram.ui.PollKeyboardKey(tram.ui.KEY_D) then
		teapot_modifier = teapot_modifier + tram.math.vec3(0.0, 0.01, 0.0)
	end
	
	if tram.ui.PollKeyboardKey(tram.ui.KEY_UP) or tram.ui.PollKeyboardKey(tram.ui.KEY_W) then
		teapot_modifier = teapot_modifier - tram.math.vec3(0.01, 0.0, 0.0)
	end
	
	if tram.ui.PollKeyboardKey(tram.ui.KEY_DOWN) or tram.ui.PollKeyboardKey(tram.ui.KEY_S) then
		teapot_modifier = teapot_modifier + tram.math.vec3(0.01, 0.0, 0.0)
	end
	
	teapot:SetRotation(tram.math.quat(teapot_modifier))
end)
