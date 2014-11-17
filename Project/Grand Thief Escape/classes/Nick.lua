require "box2d"

Nick = Core.class(Sprite)

function Nick:init()
	self.sprite = Bitmap.new(Texture.new("images/robber.png", true))
	self.sprite:setAnchorPoint(0.5, 0.5)
	self.sprite:setPosition(50, 50)
	self:rotateSprite(180)
	self:setPosition((conf.screenWidth - self.sprite:getWidth()) / 2, conf.screenHeight - self.sprite:getHeight() - 50)
	self:addChild(self.sprite)
	
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	body:setPosition(self:getPosition())
	body.object = self
	body.type = "Nick"
	
	local x, y = self:getPosition()
	x = x + self.sprite:getWidth() / 2
	y = y + self.sprite:getHeight() / 2
	local circle = b2.CircleShape.new(x, y, self.sprite:getWidth())
	local fixture = body:createFixture{shape = circle, density = 1.0, 
	friction = 0.1, restitution = 0.2}
	fixture:setFilterData({categoryBits = NICK_MASK, maskBits = NICK_MASK + PROJECTILE_MASK + POLICE_MASK, groupIndex = 0})
	
	self.body = body
end

function Nick:move(x, y)
	local xPos = 0
	local yPos = 0
	
	if x >= conf.screenWidth - self.sprite:getWidth() then
		xPos = conf.screenWidth - self.sprite:getWidth()
	elseif x > 0 then
		xPos = x
	end
	
	if y >= conf.screenHeight - self.sprite:getHeight() then
		yPos = conf.screenHeight - self.sprite:getHeight()
	elseif y > 0 then
		yPos = y
	end

	self.body:setPosition(xPos, yPos)
end

function Nick:moveBySpeed(speedX, speedY)
	self.body:setLinearVelocity(speedX, speedY)
end

function Nick:rotateSprite(degree)
	self.sprite:setRotation(degree)
end