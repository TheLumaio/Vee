local hud = {}

function hud:init()
	self.image = g.newImage("res/images/v.png")
	self.drillImage = g.newImage("res/images/drill.png")
	self.factoryImage = g.newImage("res/images/factory.png")
end

function hud:update(dt)
end

function hud:draw()

	g.setColor(100, 100, 120, 100)
	g.rectangle("fill", 0, 0, g:getWidth()-445, 24)

	g.setColor(0, 0, 0)
	g.rectangle("line", 1, 1, g:getWidth()-447, 24)
	g.print("=" .. tostring(Player.resources), 32, 3)
	g.print("| Zoom = " .. tostring(MainCam.scale), 100, 3)

	g.setColor(100, 100, 120, 100)
	g.rectangle("fill", 475, 0, g:getWidth()-475, 85)
	g.setColor(0, 0, 0)
	g.rectangle("line", 475, 0, g:getWidth()-477, 85)

	g.setColor(255, 255, 255)

	g.draw(self.image, 10, 4)

	g.draw(self.drillImage, 500, 5, 0)
	g.draw(self.factoryImage, 575, 5, 0)

end

function hud:mousepressed(x, y, b)
	if b == "l" and not Selector.placing then
		if x > 500 and x < 500+self.drillImage:getWidth() and y > 5 and y < 5+self.drillImage:getHeight() then
			Selector.placing = Drill:new(10, 10)
		end
		if x > 575 and x < 575+self.factoryImage:getWidth() and y > 5 and y < 5+self.factoryImage:getHeight() then
			Selector.placing = Factory:new(10, 10)
		end
	end
end

return hud
