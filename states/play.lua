local play = {}

function play:init()
	UnitHandler:init()
	Selector:init()
	Player:init()
	Hud:init()

	UnitHandler:addUnit(Grunt:new(100, 100))
	UnitHandler:addUnit(Grunt:new(100, 150))
	UnitHandler:addUnit(Grunt:new(150, 100))
	UnitHandler:addUnit(Grunt:new(150, 150))

	BG = g.newImage("res/images/bg.png")
end

function play:update(dt)
	UnitHandler:update(dt)
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
	MainCam:attach()

	g.draw(BG)

	UnitHandler:draw()
	Selector:draw()

	MainCam:detach()

	Hud:draw()

end

function play:mousepressed(x, y, b)
	UnitHandler:mousepressed(x, y, b)
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
