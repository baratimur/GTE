level = gideros.class(Sprite)

function level:init()
	self:load(1)
	self.player = Nick.new()

	self:addChild(self.player)
	
	self.bottomBg = Bitmap.new(Texture.new("images/bottom_bg.png", true))
	self.bottomBg:setPosition(0, conf.screenHeight - self.bottomBg:getHeight())
	self:addChild(self.bottomBg)
	
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
	self:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self.deltaMaxController = math.pow(((self.controllerBg:getWidth() - self.control:getWidth())) / 2, 2)
end

function level:load(number)
	-- create map
	local mapData = require("level_map/level_map_" .. number)
	self.map = World.new(mapData)
	self:addChild(self.map)
	
	--- create pools
	-- obstacle pool
	self.obstaclespools = {}
	local obstacles = mapData["obstacles"]
	for i = 1, #obstacles do
		self.obstaclespools[i] = ObstaclePool.new(obstacles[i]["image"],3)
		self:addChild(self.obstaclespools[i])
	end
	
	-- projectile pool
	self.projectilespools = {}
	self.pistols = {}
	local projectiles = mapData["projectiles"]
	for i = 1, #projectiles do
		self.projectilespools[i] = ProjectilePool.new(
			projectiles[i]["image"],
			20,
			World.speed)
		self:addChild(self.projectilespools[i])
		self.pistols[i] = PistolGun.new(
			self.projectilespools[i],
			projectiles[i]["projectilespeed"],
			projectiles[i]["distance"])
	end
	
	-- police pool
	self.policepools = {}
	local polices = mapData["objects"]
	for i = 1, #projectiles do
		self.policepools[i] = PolicePool.new(
			polices[i]["image"][1],
			polices[i]["image"][2],
			8)
		self.policepools[i]:setGun(self.pistols[polices[i]["weapon"]])
		self:addChild(self.policepools[i])
	end
	
	--[[
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
	--]]
	self.map:addEventListener(World.EVENT_SPAWN_OBJECT, 
		function(event)
			self.policepools[event.id]:make(event.Xpos,event.firerate,World.speed)
		end
	)
	self.map:addEventListener(World.EVENT_SPAWN_OBSTACLE, 
		function(event)
			self.obstaclespools[event.id]:make(event.Xpos,event.direction,World.speed)
		end
	)
	
end

--removing event
function level:onEnterFrame() 
	world:step(1/60, 8, 3)
	if self.controllerType == 1 then
		self.controller:moveByAnalog()
	elseif self.controllerType == 2 then
		self.controller:moveByAccelerator()
	end
	self.player:setPosition(self.player.body:getPosition())
	
	--- update all objects
	self.map:update()
	
	-- update all projectiles
	for i = 1, #self.projectilespools do
		self.projectilespools[i]:update()
	end
	
	-- update all polices
	for i = 1, #self.policepools do
		self.policepools[i]:update(self.player:getX(),self.player:getY())
	end
	
	-- update all obstace
	for i = 1, #self.obstaclespools do
		self.obstaclespools[i]:update()
	end
end

--removing event on exiting scene
function level:onExitBegin()
	self:removeEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end

function level:moveControl(x, y)
	local xPos, yPos = self.controllerBg:getPosition()
	local delta = math.pow(x - xPos, 2) + math.pow(y - yPos, 2)
	local sin = (y - yPos) / math.sqrt(math.pow(x - xPos, 2) + math.pow(y - yPos, 2))
	local cos = (x - xPos) / math.sqrt(math.pow(x - xPos, 2) + math.pow(y - yPos, 2))
	
	if delta < self.deltaMaxController then
		xPos = x
		yPos = y
	else
		xPos = xPos + math.sqrt(self.deltaMaxController) * cos
		yPos = yPos + math.sqrt(self.deltaMaxController) * sin
	end
	
	self.control:setPosition(xPos, yPos)
	self.controller:movePlayer(self.player.maxSpeed * cos, self.player.maxSpeed * sin)
end

function level:onBeginContact(e)
	local fixtureA = e.fixtureA
	local fixtureB = e.fixtureB
	local bodyA = fixtureA:getBody()
	local bodyB = fixtureB:getBody()
	
	if (bodyA.type == "Nick" and bodyB.type == "Police") or (bodyA.type == "Police" and bodyB.type == "Nick") then
		print("colide")
	end
end