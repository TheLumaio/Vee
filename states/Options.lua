local options = {}

function options:enter(prev)
end

function options:init()
	self.items = {}
	table.insert(self.items, {text="Fullscreen", r=0, select=false, onpress=function() love.window.toggleFullscreen() end})
end

function options:update(dt)
	local mx, my = love.mouse.getPosition()
	local cx = love.graphics:getWidth()/2
	for i,v in pairs(self.items) do
		if mx > cx-Option:getWidth(v.text)/2 and
			 mx < cx+Option:getWidth(v.text)/2 and
			 my > 100 and my < 100+Option:getWidth(v.text)/2 then
			end
	end
end

function options:draw()
end

return options
