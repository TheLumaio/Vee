local shine = require ("lib.shine")

local menu = {}

local function inBounds(mx, my, x, y, w, h)
	if mx > x and mx < x+w and my > y and my < y+h then
		return true
	end
	return false
end

function menu:enter(prev)
	self.click = false
	self.s = 0
end

function menu:init()
	self.items = {}
	table.insert(self.items, {text="Play", r=0, select=false, onpress=function() Gamestate.switch(Play) end})
	table.insert(self.items, {text="Fullscreen", r=0, select=false, onpress=function() love.window.setFullscreen(not love.window.getFullscreen()) end})
	table.insert(self.items, {text="Quit", r=0, select=false, onpress=function() love.event.quit() end})

	self.t = 0

	self.bloom = shine.gaussianblur()
	self.bloom.sigma = 10

	self.click = false

end

function menu:update(dt)
	self.t = self.t + dt

	local mx, my = love.mouse.getPosition()
	local w, h = g.getWidth(), g.getHeight()
	for i,v in pairs(self.items) do
		local tw, th = Option:getWidth(v.text), Option:getHeight(v.text)
		if inBounds(mx, my, w/2-tw/2, (150+i*th)-th/2, tw, th) then
			if love.mouse.isDown("l") then
				self.click = true
				self.s = i
			end

			v.select = true
			if v.r < 10 then
				v.r = v.r + 1
			end

		else
			v.click = false
			v.select = false
			if v.r > 0 then
				v.r = v.r - 1
			end
		end
	end

	for i,v in pairs(self.items) do
		if v.select then
			if love.mouse.isDown("l") then
				self.click = true
				self.s = i
			end
		end
	end

end

function menu:draw()
	g.setFont(Title)
	g.setColor(50, 255, 255)
	self.bloom.sigma = 10
	self.bloom:draw(function()
		g.print("Vee", g.getWidth()/2, 100, 0, 1, 1, Title:getWidth("Vee")/2, Title:getHeight("Vee")/2)
	end)
	g.print("Vee", g.getWidth()/2, 100, 0, 1, 1, Title:getWidth("Vee")/2, Title:getHeight("Vee")/2)

	g.setFont(Option)
	g.setColor(255, 50, 50)
	for i,v in pairs(self.items) do
		self.bloom.sigma = v.r
		self.bloom:draw(function()
				g.print(v.text, g.getWidth()/2, 150+i*Option:getHeight(v.text), 0, 1, 1, Option:getWidth(v.text)/2, Option:getHeight(v.text)/2)
		end)
		g.print(v.text, g.getWidth()/2, 150+i*Option:getHeight(v.text), 0, 1, 1, Option:getWidth(v.text)/2, Option:getHeight(v.text)/2)
	end

end

function menu:mousereleased(x, y, b)
	if b == "l" and self.click then
		self.items[self.s].onpress()
	end
end

return menu
