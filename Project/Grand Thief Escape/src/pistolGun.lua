--[[
Gun Class
@Author : Rere
]]

PistolGun = gideros.class(Sprite)

function PistolGun:init(projectilePool)
	self.projectileSpeed = 1
	self.projectilePool = projectilePool
end

function PistolGun:fire()
	self.projectilePool:make(self:getX(),self:getY(),self.projectileSpeed,self:getRotation())
end
