--[[
Obstacle Class
@Author : Rere
]]

Obstacle = gideros.class(Sprite)

function Obstacle:init(texture)
	local bitmap = Bitmap.new(Texture.new(texture))
	bitmap:setAnchorPoint(0.5,0.5)
	--[[
	local body = world:createBody{type = b2.DYNAMIC_BODY}
	local x, y = self:getPosition()
	
	body:setPosition(x,y)
	body.object = self
	body.type = "Obstacle"
	
	local poly = b2.PolygonShape.new()
	poly:setAsBox(bitmap:getWidth() / 2, bitmap:getHeight() / 2,x,y,0)
	local fixture = body:createFixture{shape = poly, density = 0.1, 
	friction = 0.1, restitution = 0.2}
	--fixture:setFilterData({categoryBits = POLICE_MASK, maskBits = NICK_MASK + POLICE_MASK, groupIndex = 0})
	
	--self.body = body
	--]]
	self:addChild(bitmap)
end

function Obstacle:setParameter(direction, speed)
	self.speed = speed
	self:setRotation(direction)
	--self.body:setRotation(direction)
end

function Obstacle:update()
	--self.body:setPosition(self:getPosition())
	self:setY(self:getY() + self.speed)
end
