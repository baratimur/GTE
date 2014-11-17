require "accelerometer"

Controller = gideros.class()

local controlCanMove = false
local touchDeltaX = 0
local touchDeltaY = 0
local isDecelerating = true

function Controller:init(caller)
	self.caller = caller
	self.type = 0
	self.filter = 0.999
	self.fx = 0
	self.fy = 0
end

function Controller:attachController(type)
	if type == 1 then --Touch
		self.caller.control:addEventListener(Event.TOUCHES_BEGIN, self.onTouchBegin, self)
		self.caller.control:addEventListener(Event.TOUCHES_MOVE, self.onTouchMove, self)
		self.caller.control:addEventListener(Event.TOUCHES_END, self.onTouchEnd, self)
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
	isDecelerating = false
	local x = event.touch.x
	local y = event.touch.y
	
	local xCenter, yCenter = self.caller.control:getPosition()
	
	if math.pow(x - xCenter, 2) + math.pow(y - yCenter, 2) <= math.pow(self.caller.control:getWidth() / 2, 2) then
		controlCanMove = true
		touchDeltaX = x - xCenter
		touchDeltaY = y - yCenter
	else
		controlCanMove = false
	end
end

function Controller:onTouchMove(event)
	if controlCanMove then
		local x = event.touch.x
		local y = event.touch.y
		self.caller:moveControl(x - touchDeltaX, y - touchDeltaY)
	end
end

function Controller:onTouchEnd(event)
	isDecelerating = true
	controlCanMove = false
	self.caller.control:setPosition(conf.screenWidth / 2, conf.screenHeight - self.caller.controllerBg:getHeight() / 2 - 15)
	self:movePlayer(0, 0)
end

function Controller:moveByAnalog()
	if isDecelerating then
		self:movePlayer(0, 0)
	end
end

function Controller:moveByAccelerator()
	-- get accelerometer values
	local x, y = accelerometer:getAcceleration()
	
	self:movePlayer(x, -y)
end

function Controller:movePlayer(speedX, speedY)
	local xPos, yPos = self.caller.player.body:getPosition()
	
	if xPos < 0 then
		self.fx = 0
		xPos = 0
	elseif xPos > conf.screenWidth - self.caller.player.sprite:getWidth() then
		self.fx = 0
		xPos = conf.screenWidth - self.caller.player.sprite:getWidth()
	else
		-- apply IIR filter
		self.fx = 50 * (speedX * self.filter + self.fx * (1 - self.filter))
	end
	
	if yPos < 0 then
		self.fy = 0
		yPos = 0
	elseif yPos > conf.screenHeight - self.caller.player.sprite:getHeight() - 280 then
		self.fy = 0
		yPos = conf.screenHeight - self.caller.player.sprite:getHeight() - 280
	else
		-- apply IIR filter
		self.fy = 100 * (speedY * self.filter + self.fy * (1 - self.filter))
	end
	
	if xPos == 0 or yPos == 0 or
		xPos >= conf.screenWidth - self.caller.player.sprite:getWidth() or
		yPos >= conf.screenHeight - self.caller.player.sprite:getHeight() - 280 then
		self.caller.player.body:setPosition(xPos, yPos)
	end
	
	self.caller.player:move(self.fx, self.fy)
end