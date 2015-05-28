local grunt = {}

local function distance ( x1, y1, x2, y2 )
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt ( dx * dx + dy * dy )
end

local function boxSegmentIntersection(l,t,w,h, x1,y1,x2,y2)
  local dx, dy  = x2-x1, y2-y1

  local t0, t1  = 0, 1
  local p, q, r

  for side = 1,4 do
    if     side == 1 then p,q = -dx, x1 - l
    elseif side == 2 then p,q =  dx, l + w - x1
    elseif side == 3 then p,q = -dy, y1 - t
    else                  p,q =  dy, t + h - y1
    end

    if p == 0 then
      if q < 0 then return nil end
    else
      r = q / p
      if p < 0 then
        if     r > t1 then return nil
        elseif r > t0 then t0 = r
        end
      else -- p > 0
        if     r < t0 then return nil
        elseif r < t1 then t1 = r
        end
      end
    end
  end

  local ix1, iy1, ix2, iy2 = x1 + t0 * dx, y1 + t0 * dy,
                             x1 + t1 * dx, y1 + t1 * dy

  if ix1 == ix2 and iy1 == iy2 then return ix1, iy1 end
  return ix1, iy1, ix2, iy2
end

function grunt:new(x, y, team)
	local gr = {}
	setmetatable(gr, self)
	self.__index = self

	gr.actor = true

	gr.x = x
	gr.y = y
	gr.to_x = nil
	gr.to_y = nil
	gr.team = team

	gr.z = gr.y

	gr.w = 16
	gr.h = 32

  gr.dx = 0
  gr.dy = 0

  gr.cx1 = 0
  gr.cy1 = 0

  gr.cx2 = 0
  gr.cy2 = 0

  gr.cx3 = 0
  gr.cy3 = 0

	gr.isLeader = false

	gr.body = phys.newBody(World, x, y, "dynamic")
	gr.shape = phys.newCircleShape(gr.w/2)
	gr.fixture = phys.newFixture(gr.body, gr.shape)

	gr.fixture:setRestitution(1)

	gr.body:setLinearDamping(25)
	gr.body:setFixedRotation(false)

	return gr

end

function grunt:update(dt)
	self.z = self.y

	self.x = self.body:getX()
	self.y = self.body:getY()+(self.h/2)/2

	if self.to_x and self.to_y then

    local rot = -(math.atan2((self.y-self.to_y), -(self.x-self.to_x)))
		self.dx = math.cos(rot) * 50
		self.dy = math.sin(rot) * 50

		if self.x > self.to_x-5 and self.x < self.to_x+5 and self.y > self.to_y-5 and self.y < self.to_y+5 then
			self.to_x = nil
			self.to_y = nil
		end

    self.cx1 = math.cos(rot-math.rad(30))*50
    self.cx2 = math.cos(rot+math.rad(30))*50
    self.cx3 = math.cos(rot)*50

    self.cy1 = math.sin(rot-math.rad(30))*50
    self.cy2 = math.sin(rot+math.rad(30))*50
    self.cy3 = math.sin(rot)*25


    for i,v in pairs(EntityHandler.entities) do
      if v ~= self then
        local a = boxSegmentIntersection(v.x, v.y, v.w, v.h, self.x, self.y, self.x+self.cx1, self.y+self.cy1)
        local b = boxSegmentIntersection(v.x, v.y, v.w, v.h, self.x, self.y, self.x+self.cx2, self.y+self.cy2)
        local c = boxSegmentIntersection(v.x, v.y, v.w, v.h, self.x, self.y, self.x+self.cx3, self.y+self.cy3)

        if a then
          rot = rot + 1
        elseif b then
          rot = rot - 1
        elseif c then
          rot = rot + 1
        end

        self.dx = math.cos(rot) * 50
        self.dy = math.sin(rot) * 50

      end
    end

    self.body:applyLinearImpulse(self.dx, self.dy)

	end


end

function grunt:draw()
  if Selector.debug then
    g.line(self.x, self.y, self.x+self.cx1, self.y+self.cy1)
    g.line(self.x, self.y, self.x+self.cx2, self.y+self.cy2)
  end


	if self.to_x and self.to_y then
		g.setColor(100, 100, 150)
		g.ellipse("line", self.to_x, self.to_y, self.w+10, 10)
	end

	if self.selected == true then
		g.setColor(100, 150, 100)
	else
		g.setColor(100, 100, 100)
	end
	g.ellipse("line", self.x, self.y, self.w+10, 10)

	g.setColor(150, 100, 100)
	g.rectangle("fill", self.x-self.w/2, self.y-self.h, self.w, self.h)
	g.setColor(0, 0, 0)
	g.rectangle("line", self.x-self.w/2, self.y-self.h, self.w, self.h)

	g.setColor(255, 255, 255)
	--g.rectangle("line", self.x-self.w/2, self.y-self.h/2, self.w, self.h/2)
end

return grunt
