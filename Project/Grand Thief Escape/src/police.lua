--[[
Police Class
@Author : Rere
]]

Police = gideros.class(Sprite)

function Police:init(texture_idle, texture_fire, speed)
	self.bitmap_idle = Bitmap.new(Texture.new(texture_idle))
	self.bitmap_fire = Bitmap.new(Texture.new(texture_fire))
	self.bitmap_idle:setAnchorPoint(0.5,0.5)
	self.bitmap_fire:setAnchorPoint(0.5,0.5)
	self.gun = nil
	self.targetX = 0
	self.targetY = 0
	self.fireRate = 100
	self.fireRateCounter = 0
	self.speed = speed
	self:addChild(self.bitmap_idle)
end

function Police:setParameter(fireRate, speed)
	self.fireRate = fireRate
	self.speed = speed
end

function Police:turnTo(x, y)
	local dy = (y - self:getY()) * -1
	local dx = x - self:getX()
	local dRotation = 90 - math.atan2(dy,dx) * 180 / math.pi
	self:setRotation(dRotation)
end

function Police:setShootTarget(x,y)
	self.targetX = x
	self.targetY = y
end

function Police:equip(gun)
	self.gun = gun
	self.gun:setPosition(self:getPosition())
end

function Police:getEquip()
	return self.gun
end

function Police:fire()
	self.gun:setRotation(self:getRotation() - 90)
	self.gun:setPosition(self:getPosition())
	self.gun:fire()
	self:addChild(self.bitmap_fire)
end

function Police:update(targetX,targetY)
	self:turnTo(self.targetX,self.targetY)
	self:setY(self:getY() + self.speed)
	self.fireRateCounter = self.fireRateCounter + 1
	if(self.fireRateCounter > self.fireRate) then
		self.fireRateCounter = 0
		self:fire()
	end
end