local play = {}

function play:init()
	EntityHandler:init()
	Selector:init()
	Player:init()
	Hud:init()

	EntityHandler:addEntity(Grunt:new(100, 100))
	EntityHandler:addEntity(Grunt:new(100, 150))
	EntityHandler:addEntity(Grunt:new(150, 100))
	EntityHandler:addEntity(Grunt:new(150, 150))

	EntityHandler:addEntity(Turret:new(200, 200, Player.team))

	BG = g.newImage("res/images/bg.png")
end

function play:update(dt)
	EntityHandler:update(dt)
	Selector:update(dt)
	Hud:update(dt)

	-- Handle camera movement
	if key.isDown("s") then MainCam.y = MainCam.y + 5 end
	if key.isDown("w") then MainCam.y = MainCam.y - 5 end
	if key.isDown("d") then MainCam.x = MainCam.x + 5 end
	if key.isDown("a") then MainCam.x = MainCam.x - 5 end

	-- Fix camera scale
	if MainCam.scale > 1.5 then MainCam.scale = 1.5 end
	if MainCam.scale < 0.5 then MainCam.scale = 0.5 end


end

function play:draw()
	g.setFont(MainFont)
	MainCam:attach()

	g.draw(BG)

	EntityHandler:draw()
	Selector:draw()

	MainCam:detach()

	Hud:draw()

end

function play:keypressed(key)
	if key == "b" then
		Selector.debug = not Selector.debug
	end
	if key == "escape" then
		Gamestate.switch(Menu)
	end
end

function play:mousepressed(x, y, b)
	EntityHandler:mousepressed(x, y, b)
	Selector:mousepressed(x, y, b)
	Hud:mousepressed(x, y, b)

	-- zoom out
	if b == "wd" then
		if MainCam.scale > 0.5 then
			MainCam.scale = MainCam.scale - 0.1
		end
	elseif b == "wu" then
		if MainCam.scale < 1.5 then
			MainCam.scale = MainCam.scale + 0.1
		end
	end
end

function play:mousereleased(x, y, b)
	Selector:mousereleased(x, y, b)
end

return play
