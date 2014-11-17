--[[
ProjectilePool Class
@Author : Rere
]]

ProjectilePool = gideros.class(Sprite)

function ProjectilePool:init(texture, capacity)
	self.projectiles = {}
	self.activeList = {}
	self.minX = 0
	self.maxX = 350
	for i = 1 , capacity do
		self.projectiles[i] =  Projectile.new("asset/dummyprojectile.png",0,0)
		self.projectiles[i]:setAlpha(0)
		self:addChild(self.projectiles[i])
		self.activeList[i] = false
	end
end

function ProjectilePool:make(startX, startY, speed, direction)
	i = 1
	while self.activeList[i] and i <= #self.activeList do
		i=i+1
	end
	if i < #self.activeList then
		print(speed)
		self.projectiles[i]:setPosition(startX, startY)
		self.projectiles[i]:setParameter(speed, direction)
		self.projectiles[i]:setAlpha(100)
		
		self.activeList[i] = true
	end
end

--auto release
function ProjectilePool:onEnterFrame()
	for i = 1 , #self.projectiles do
		if(self.activeList[i]) then
			if(self.projectiles[i]:getX() < self.minX or
			   self.projectiles[i]:getX() > self.maxX) then -- hitting side walls
				
				self.projectiles[i]:setAlpha(0)
				self.activeList[i] = false
				print(i)
			else
				self.projectiles[i]:onEnterFrame()
				--print(self.projectiles[i]:getX()  .. self.projectiles[i]:getY() )
			end
		end		
	end
end

