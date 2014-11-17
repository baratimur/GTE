level = gideros.class(Sprite)

function level:init()
	self.player = Nick.new()
	
	local bg = SeamlessPattern.new("images/level.png", {speedX = 0, speedY = 1.0})
	self:addChild(bg)
	self:addChild(self.player)
	
	self.controllerType = 1
	self.controller = Controller.new(self, self.player)
	self.controller:attachController(self.controllerType)
	
	world:setGravity(0, 0)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

--removing event
function level:onEnterFrame() 
	world:step(1/60, 8, 3)
	if self.controllerType == 2 then
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