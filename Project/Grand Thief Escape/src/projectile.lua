--[[
Projectile Class
@Author : Rere
]]

Projectile = gideros.class(Sprite)

function Projectile:init(texture, speed, direction)
	local bitmap = Bitmap.new(Texture.new(texture))
	bitmap:setAnchorPoint(0.5,0.5)
	self:setParameter(speed, direction)
	self:addChild(bitmap)
end

function Projectile:setParameter(speed, direction)
	self.speed = speed
	self.direction = direction * math.pi / 180 -- from degree to rad
	self.speedX = speed * math.cos(self.direction)
	self.speedY = speed * math.sin(self.direction)
end

function Projectile:onEnterFrame()
	self:setX(self:getX() - self.speedX)
	self:setY(self:getY() + self.speedY)
end
