level = gideros.class(Sprite)

function level:wall(x, y, width, height)
	local wall = Shape.new()
	wall:beginPath()
	wall:moveTo(x,y)
	wall:lineTo(x + width, y)
	wall:lineTo(x + width, y + height)
	wall:lineTo(x, y + height)
	wall:lineTo(x, y)
	wall:endPath()
	wall:setPosition(x,y)
	physicsAddBody(world, wall, {type = "static", density = 1.0, friction = 0.1, bounce = 0.2})
	wall.body.type = "wall"
	return wall
end

function level:init()
	self:load(1)
	self.player = Nick.new()

	self:addChild(self.player)
	
	self.controllerType = 1
	self.controller = Controller.new(self)
	
	self.bottomBg = Bitmap.new(Texture.new("images/bottom_bg.png", true))
	self.bottomBg:setPosition(0, conf.screenHeight - self.bottomBg:getHeight())
	self:addChild(self.bottomBg)
	
	if self.controllerType == 1 then
		self.controllerBg = Bitmap.new(Texture.new("images/controller_bg.png", true))
		self.controllerBg:setAnchorPoint(0.5, 0.5)
		self.controllerBg:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)
		self:addChild(self.controllerBg)
		
		self.control = Bitmap.new(Texture.new("images/controller.png", true))
		self.control:setAnchorPoint(0.5, 0.5)
		self.control:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)
		self:addChild(self.control)
		
		self.deltaMaxController = math.pow(((self.controllerBg:getWidth() - self.control:getWidth())) / 2, 2)
	end
	
	--debug drawing
	local debugDraw = b2.DebugDraw.new()
	world:setDebugDraw(debugDraw)
	self:addChild(debugDraw)
	
	world:setGravity(0, 0)
	
	world:addEventListener(Event.BEGIN_CONTACT, self.onBeginContact, self)
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	
	self.deltaMaxController = math.pow(((self.controllerBg:getWidth() - self.control:getWidth())) / 2, 2)
	
--	self:addChild(self:wall(0,0,10,application:getContentHeight()))
--	self:addChild(self:wall(0,0,application:getContentWidth(),10))
--	self:addChild(self:wall(application:getContentWidth()-10,0,10,application:getContentHeight()))
--	self:addChild(self:wall(0,application:getContentHeight()-10,application:getContentWidth(),10))
	
	--debug drawing
	--local debugDraw = b2.DebugDraw.new()
	--world:setDebugDraw(debugDraw)
	--self:addChild(debugDraw)
end

function level:load(number)
	-- create map
	local mapData = require("level_map/level_map_" .. number)
	self.map = Map.new(mapData)
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
			Map.speed)
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
	
	-- add spawn listener
	self.map:addEventListener(Map.EVENT_SPAWN_OBJECT, 
		function(event)
			self.policepools[event.id]:make(event.Xpos,event.firerate,Map.speed)
		end
	)
	self.map:addEventListener(Map.EVENT_SPAWN_OBSTACLE, 
		function(event)
			self.obstaclespools[event.id]:make(event.Xpos,event.direction,Map.speed)
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
	local xPos, yPos = self.player.body:getPosition()
	self.player:checkPosition()
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
	
	-- update all obstacles
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
	if (bodyA.type == "Nick" and bodyB.type == "Projectile") or (bodyA.type == "Projectile" and bodyB.type == "Nick") then
		print("getShoot")
	end
end

function level:resetControl()
	self.control:setPosition(conf.screenWidth / 2, conf.screenHeight - self.controllerBg:getHeight() / 2 - 15)

	
	

end