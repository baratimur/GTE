--[[
World Class
@Author : Rere
]]

World = gideros.class(Sprite)

-- static var
World.EVENT_SPAWN = "spawn"
World.EVENT_DESPAWN = "despawn"

function World:init(map)
	self.mapData = map
	self.objects = self.mapData["objects"]
	for i = 1 , #self.objects do
		local object = self.objects[i]
		for j = 1 , #object["positions"] do
			local position = object["positions"][j]
			position["status"] = false -- render status
		end
	end
	local bg = SeamlessPattern.new(map["map"], {speedX = 0, speedY = 1.0})
	self:addChild(bg)
end

function World:getObjects()
	return self.mapData["polices"]
end

function World:onEnterFrame()
	--check object spawn / despawn within device border
	for i = 1 , #self.objects do
		local object = self.objects[i]
		for j = 1 , #object["positions"] do
			local position = object["positions"][j]
			if position["status"] then -- rendered
				if not (position[2] + self:getY() > 0 and position[2] + self:getY() < self.mapData["height"]) then
					position["status"] = false
					local despawnEvent = Event.new(World.EVENT_DESPAWN)
					despawnEvent.object = object
					self:dispatchEvent(despawnEvent)
					print("d")
				end
			else -- not rendered yet
				if position[2] + self:getY() > 0 and position[2] + self:getY() < self.mapData["height"] then
					position["status"] = true
					local spawnEvent = Event.new(World.EVENT_SPAWN)
					spawnEvent.object = object
					self:dispatchEvent(spawnEvent)
					print("s")
				end
			end			
		end
	end
end