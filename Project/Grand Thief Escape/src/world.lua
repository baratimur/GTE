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
	self.yCounter = 0 -- y offset counter
	self.bgSpeed = self.mapData["speed"]
	World.speed = self.mapData["speed"] -- global var
	for i = 1 , #self.objects do
		local object = self.objects[i]
		for j = 1 , #object["positions"] do
			local position = object["positions"][j]
			position["status"] = false -- render status
		end
	end
	self.bg = SeamlessPattern.new(map["map"], {speedX = 0, speedY = self.bgSpeed})
	self:addChild(self.bg)
end

function World:getObjects()
	return self.mapData["polices"]
end

function World:update()
	self.yCounter = self.yCounter - self.bgSpeed
	--check object spawn / despawn within device border
	for i = 1 , #self.objects do
		local object = self.objects[i]
		for j = 1 , #object["positions"] do
			local position = object["positions"][j]
			if position["status"] then -- rendered
				if not (position[2] + self.yCounter > 0 and position[2] + self.yCounter < self.mapData["height"]) then
					position["status"] = false
					local despawnEvent = Event.new(World.EVENT_DESPAWN)
					despawnEvent.object = object
					self:dispatchEvent(despawnEvent)
					print("d" .. j)
				end
			else -- not rendered yet
				if position[2] + self.yCounter > 0 and position[2] + self.yCounter < self.mapData["height"] then
					position["status"] = true
					local spawnEvent = Event.new(World.EVENT_SPAWN)
					spawnEvent.Xpos = position[1]
					spawnEvent.Ypos = position[2]
					self:dispatchEvent(spawnEvent)
					print("s" .. j)
				end
			end			
		end
	end
end