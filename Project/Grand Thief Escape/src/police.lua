--[[
Police Class
@Author : Rere
]]

Police = gideros.class(Sprite)

function Police:init(texture)
	local bitmap = Bitmap.new(Texture.new(texture))
	bitmap:setAnchorPoint(0.5,0.5)
	self.gun = nil
	self.fireRate = 100
	self.fireRateCounter = 0
	self:addChild(bitmap)
end

function Police:setFireRate(fireRate)
	self.fireRate = fireRate
end

function Police:turnTo(x, y)
	local dy = (y - self:getY()) * -1
	local dx = x - self:getX()
	local dRotation = 90 - math.atan2(dy,dx) * 180 / math.pi
	self:setRotation(dRotation)
	
end

function Police:equip(gun)
	self.gun = gun
	self.gun:setPosition(self:getPosition())
end

function Police:getEquip()
	return self.gun
end

function Police:fire()
	self.gun:fire()
end

function Police:onEnterFrame()
	self.gun:setRotation(self:getRotation())
	self.fireRateCounter = self.fireRateCounter + 1
	if(self.fireRateCounter > self.fireRate) then
		self.fireRateCounter = 0
		self:fire()
	end
end