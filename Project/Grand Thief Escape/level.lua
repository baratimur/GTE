level = gideros.class(Sprite)

function level:init()
	self:load(1)
	self.player = Nick.new()
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

function level:load(number)
	-- create map
	self.map = World.new(require("level_map/level_map_" .. number))
	self:addChild(self.map)
	
	
	--- create pools
	-- cop_pistol pool
	self.pool_copPistol_projectile = ProjectilePool.new("images/fire.png",10,World.speed)
	self.pistolGun = PistolGun.new(self.pool_copPistol_projectile,5,200)
	self.pool_copPistol = PolicePool.new(self.map["objects"][1]["image"][1],self.map["objects"][1]["image"][2],10)
	self.pool_copPistol:make(180,80,World.speed,self.pistolGun)
	--self.pool_copPistol_projectile:make(20,20,2,270,550)
	
	self.carPool = ObstaclePool.new("images/crate.png",5)
	self.carPool:make(50,45,World.speed)
	self:addChild(self.carPool)
	self:addChild(self.pool_copPistol_projectile)
	self:addChild(self.pool_copPistol)
	self.map:addEventListener(World.EVENT_SPAWN, 
		function(event)
			print(event.Xpos)
		end
	)
	
	-- create polices
	
end

--removing event
function level:onEnterFrame() 
	world:step(1/60, 8, 3)
	if self.controllerType == 1 then
		
	elseif self.controllerType == 2 then
		self.controller:moveByAccelerator()
	end
	self.player:setPosition(self.player.body:getPosition())
	self.map:update()
	self.pool_copPistol:update(self.player:getX(),self.player:getY())
	self.pool_copPistol_projectile:update()
	self.carPool:update()
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