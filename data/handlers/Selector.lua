local selector = {}

function selector:init()
	self.sx = 0
	self.sy = 0
	self.ex = 0
	self.ey = 0
	self.w = 0
	self.h = 0

	self.timer = 10
	self.placing = nil
end

function selector:update(dt)
	if not self.placing then
		self.timer = self.timer + dt
	end

	local mx, my = love.mouse.getPosition()
	if love.mouse.isDown("l") and self.sx ~= 0 and self.sy ~= 0 and not self.placing then
		self.ex = mx
		self.ey = my
		self.w = (self.ex-self.sx) / MainCam.scale
		self.h = (self.ey-self.sy) / MainCam.scale
		for i,v in pairs(EntityHandler.entities) do
			local dx, dy = MainCam:worldCoords(self.sx, self.sy)
			if v.x > dx and v.x < dx+self.w and v.y > dy and v.y < dy+self.h then v.selected = true
			elseif v.x < dx and v.x > dx+self.w and v.y < dy and v.y > dy+self.h then v.selected = true
			elseif v.x > dx and v.x < dx+self.w and v.y < dy and v.y > dy+self.h then v.selected = true
			elseif v.x < dx and v.x > dx+self.w and v.y > dy and v.y < dy+self.h then v.selected = true
			else
				v.selected = false
			end
		end
	end

	if self.placing then
		self.sx = 0
		self.sy = 0
	end

end

function selector:draw()
	local mx, my = MainCam:worldCoords(love.mouse.getPosition())
	local dx, dy = MainCam:worldCoords(self.sx, self.sy)
	g.setColor(255, 0, 0)
	g.rectangle("line", dx, dy, self.w, self.h)
	g.setColor(255, 255, 255)


	if self.placing then
		g.draw(self.placing.image, mx-self.placing.image:getWidth()/2, my-self.placing.image:getHeight()/2)
		local s, u = self:Colliding(love.mouse.getPosition())
		if s or u then
			g.setColor(255, 0, 0)
			local w = self.placing.image:getWidth()
			local h = self.placing.image:getHeight()
			g.rectangle("line", mx-w/2, my-h/2, w, h)
		end
	end
end

function selector:mousepressed(x, y, b)
	if b == "r" and self.placing then
		self.placing = nil
	end

	if b == "l" and not self.placing then
		self.sx = x
		self.sy = y
	end

	if b == "l" and self.placing then
		-- Make sure there isn't a building in the way
		local c = self:Colliding(x, y)
		if c == false then
			local dx, dy = MainCam:worldCoords(x, y)
			self.placing.x = dx - self.placing.image:getWidth()/2
			self.placing.y = dy - self.placing.image:getHeight()/2
			self.placing:place()
			EntityHandler:addEntity(self.placing)
			Player.resources = Player.resources - self.placing.bcost
			self.placing = nil
		end
	end
end

function selector:mousereleased(x, y ,b)
	if b == "l" and not self.placing then
		self:init()
	end
end

function selector:Colliding(x, y)
	local collide = false

	local dx, dy = MainCam:worldCoords(x, y)
	dx = dx - self.placing.image:getWidth()/2
	dy = dy - self.placing.image:getHeight()/2

	for i,v in pairs(EntityHandler.entities) do
		if v.actor then
			local w2 = self.placing.image:getWidth()
			local h2 = self.placing.image:getHeight()

			if CheckCollision(dx, dy, w2, h2, v.x-v.w/2, (v.y-v.h/2), v.w, v.h/2) then
				collide = true
			end
		else
			local w = v.w or v.image:getWidth()
			local h = v.h or v.image:getHeight()
			local w2 = self.placing.w or self.placing.image:getWidth()
			local h2 = self.placing.h or self.placing.image:getHeight()

			local b1 = {x = dx, y = dy, w=w2, h=h2}
			local b2 = {x = v.x, y = v.y, w=w, h=h}
			if CheckCollision(dx, dy, w2, h2, v.x, v.y, w, h) then
				collide = true
			end
		end

	end

	if Player.resources - self.placing.bcost < 0 then
		collide = true
	end

	return collide
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

return selector
