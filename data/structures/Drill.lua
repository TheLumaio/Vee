local drill = {}

function drill:new(x, y)
	local d = {}
	setmetatable(d, self)
	self.__index = self

	d.x = x
	d.y = y
	d.image = g.newImage("res/images/Drill.png")
	d.w = d.image:getWidth()
	d.h = d.image:getHeight()

	d.z = 0

	return d
end

function drill:draw()
	self.z = self.y+20
	g.draw(self.image, self.x, self.y)
end

return drill
