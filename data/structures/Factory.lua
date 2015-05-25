local factory = {}

function factory:new(x, y)
	local f = {}
	setmetatable(f, self)
	self.__index = self

	f.x = x
	f.y = y
	f.image = g.newImage("res/images/Factory.png")
	f.w = f.image:getWidth()
	f.h = f.image:getHeight()

	f.z = 0

	f.body = phys.newBody(World, x, y, "static")
	f.shape = phys.newRectangleShape(f.image:getWidth(), f.image:getHeight()-20)
	f.fixture = phys.newFixture(f.body, f.shape)

	return f

end

function factory:draw()
	self.z = self.y+25

	self.x = math.floor(self.x)
	self.y = math.floor(self.y)
	self.body:setX(self.x+self.image:getWidth()/2)
	self.body:setY(self.y+self.image:getHeight()/2+10)
	g.setColor(255, 255, 255)
	g.draw(self.image, self.x, self.y)
	--g.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))

end

return factory
