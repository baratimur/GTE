require "accelerometer"

Controller = gideros.class()

local playerCanMove = false
local touchDeltaX = 0
local touchDeltaY = 0

function Controller:init(player)
	self.player = player
	self.type = 0
	self.filter = 0.999
	self.fx = 0
	self.fy = 0
end

function Controller:attachController(type)
	if type == 1 then --Touch
		self.player:addEventListener(Event.TOUCHES_BEGIN, self.onTouchBegin, self)
		self.player:addEventListener(Event.TOUCHES_MOVE, self.onTouchMove, self)
		self.player:addEventListener(Event.TOUCHES_END, self.onTouchEnd)
	elseif type == 2 then --Accelerometer
		accelerometer:start()
	end
end

function Controller:detachController()
	if self.type == 2 then
		accelerometer:stop()
	end
	self.type = 0
end

function Controller:onTouchBegin(event)
	local x = event.touch.x
	local y = event.touch.y
	local x1, y1 = self.player:getPosition()
	local x2 = x1 + self.player.sprite:getWidth()
	local y2 = y1 + self.player.sprite:getHeight()
	if x > x1 and x < x2 and y > y1 and y < y2 then
		playerCanMove = true
		touchDeltaX = x - x1
		touchDeltaY = y - y1
	else
		playerCanMove = false
	end
end

function Controller:onTouchMove(event)
	if playerCanMove then
		local x = event.touch.x
		local y = event.touch.y
		self.player:move(x - touchDeltaX, y - touchDeltaY)
	end
end

function Controller:onTouchEnd()
	playerCanMove = false
end

function Controller:moveByAccelerator()
	local xPos, yPos = self.player.body:getPosition()
	
	-- get accelerometer values
	local x, y = accelerometer:getAcceleration()
	
	if xPos < 0 then
		self.fx = 0
		xPos = 0
	elseif xPos > conf.screenWidth - self.player.sprite:getWidth() then
		self.fx = 0
		xPos = conf.screenWidth - self.player.sprite:getWidth()
	else
		-- apply IIR filter
		self.fx = 25 * (x * self.filter + self.fx * (1 - self.filter))
	end
	
	if yPos < 0 then
		self.fy = 0
		yPos = 0
	elseif yPos > conf.screenHeight - self.player.sprite:getHeight() then
		self.fy = 0
		yPos = conf.screenHeight - self.player.sprite:getHeight()
	else
		-- apply IIR filter
		self.fy = -25 * (y * self.filter + self.fy * (1 - self.filter))
	end
	
	if xPos == 0 or yPos == 0 or
		xPos == conf.screenWidth - self.player.sprite:getWidth() or
		yPos == conf.screenHeight - self.player.sprite:getHeight() then
		self.player.body:setPosition(xPos, yPos)
	end
	
	self.player:moveBySpeed(self.fx, self.fy)
end