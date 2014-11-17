--[[
Projectile Class
@Author : Rere
]]

Projectile = gideros.class(Sprite)

function Projectile:init(texture, speed, direction)
	local bitmap = Bitmap.new(Texture.new(texture))
	bitmap:setAnchorPoint(0.5,0.5)
	self.isExploded = false
	self:setParameter(speed, direction)
	self:addChild(bitmap)
end

function Projectile:setParameter(speed, direction, distance, offsetSpeed)
	self.speed = speed
	self.isExploded = false
	self.distanceCounter = 0
	self.distance = distance
	self.direction = direction * math.pi / 180 -- from degree to rad
	self.speedX = speed * math.cos(self.direction)
	self.speedY = speed * math.sin(self.direction)
	self.offsetSpeed = offsetSpeed
end

function Projectile:update()
	if self.distance > self.distanceCounter then
		self:setX(self:getX() + self.speedX)
		self:setY(self:getY() + self.speedY + self.offsetSpeed)
		self.distanceCounter = self.distanceCounter + 1
	else
		self.isExploded = true
	end
end
