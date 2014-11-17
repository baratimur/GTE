level = gideros.class(Sprite)

function level:init()
	self.player = Nick.new()
	
	local bg = SeamlessPattern.new("images/level.png", {speedX = 0, speedY = 1.0})
	self:addChild(bg)
	self:addChild(self.player)
	
	self.controllerBg = Bitmap.new(Texture.new("images/controller_bg.png", true))
	self.controllerBg:setAnchorPoint(0.5, 0.5)
	self.controllerBg:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)
	self:addChild(self.controllerBg)
	
	self.control = Bitmap.new(Texture.new("images/controller.png", true))
	self.control:setAnchorPoint(0.5, 0.5)
	self.control:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)
	self:addChild(self.control)
	
	self.controllerType = 1
	self.controller = Controller.new(self)
	self.controller:attachController(self.controllerType)
	
	world:setGravity(0, 0)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self.deltaMaxController = math.pow(((self.controllerBg:getWidth() - self.control:getWidth())) / 2, 2)
end

--removing event
function level:onEnterFrame() 
	world:step(1/60, 8, 3)
	if self.controllerType == 1 then
		
	elseif self.controllerType == 2 then
		self.controller:moveByAccelerator()
	end
	self.player:setPosition(self.player.body:getPosition())
	
	--[[if not startGame and not pauseGame then
		updatePhysicsObjects(levelSelf.world, levelSelf)
		levelSelf.police:onEnterFrame()
		levelSelf.pistolBullets:onEnterFrame()
		levelSelf.map:setPosition(levelSelf.map:getX(),levelSelf.map:getY()-1)
		levelSelf.map:onEnterFrame()
	end]]
end

--removing event on exiting scene
function level:onExitBegin()
  self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function level:moveControl(x, y)
	local xPos, yPos = self.controllerBg:getPosition()
	local delta = math.pow(x - xPos, 2) + math.pow(y - yPos, 2)
	
	if delta < self.deltaMaxController then
		xPos = x
		yPos = y
	else
		local sin = (y - yPos) / math.sqrt(math.pow(x - xPos, 2) + math.pow(y - yPos, 2))
		local cos = (x - xPos) / math.sqrt(math.pow(x - xPos, 2) + math.pow(y - yPos, 2))
		xPos = xPos + math.sqrt(self.deltaMaxController) * cos
		yPos = yPos + math.sqrt(self.deltaMaxController) * sin
	end

	self.control:setPosition(xPos, yPos)
end