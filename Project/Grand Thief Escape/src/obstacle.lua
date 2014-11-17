--[[
Obstacle Class
@Author : Rere
]]

Obstacle = gideros.class(Sprite)

function Obstacle:init(texture)
	local bitmap = Bitmap.new(Texture.new(texture))
	bitmap:setAnchorPoint(0.5,0.5)
	self:addChild(bitmap)
end

function Obstacle:setParameter(direction, speed)
	self.speed = speed
	self:setRotation(direction)
end

function Obstacle:update()
	self:setY(self:getY() + self.speed)
end
