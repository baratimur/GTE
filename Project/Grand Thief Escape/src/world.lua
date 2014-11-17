--[[
World Class
@Author : Rere
]]

World = gideros.class(Sprite)

-- static var
World.EVENT_SPAWN_OBJECT = "spobj"
World.EVENT_SPAWN_OBSTACLE = "spobs"
World.EVENT_DESPAWN = "despawn"

function World:init(map)
	self.mapData = map
	self.objects = self.mapData["objects"]
	self.obstacles = self.mapData["obstacles"]
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
	for i = 1 , #self.obstacles do
		local obstacle = self.obstacles[i]
		for j = 1 , #obstacle["positions"] do
			local position = obstacle["positions"][j]
			obstacle["status"] = false -- render status
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
				if not (position[2] + self.yCounter > 0 and position[2] + self.yCounter < conf.screenHeight) then
					position["status"] = false
				end
			else -- not rendered yet
				if position[2] + self.yCounter > 0 and position[2] + self.yCounter < conf.screenHeight then
					position["status"] = true
					local spawnEvent = Event.new(World.EVENT_SPAWN_OBJECT)
					spawnEvent.class = object["class"]
					spawnEvent.firerate = object["firerate"]
					spawnEvent.id = i
					spawnEvent.Xpos = position[1]
					spawnEvent.Ypos = position[2]
					self:dispatchEvent(spawnEvent)
				end
			end			
		end
	end
	
	--check obstacles spawn / despawn within device border
	for i = 1 , #self.obstacles do
		local obstacle = self.obstacles[i]
		for j = 1 , #obstacle["positions"] do
			local position = obstacle["positions"][j]
			if position["status"] then -- rendered
				if not (position[2] + self.yCounter > 0 and position[2] + self.yCounter < conf.screenHeight) then
					position["status"] = false
				end
			else -- not rendered yet
				if position[2] + self.yCounter > 0 and position[2] + self.yCounter < conf.screenHeight then
					position["status"] = true
					local spawnEvent = Event.new(World.EVENT_SPAWN_OBSTACLE)
					spawnEvent.class = obstacle["class"]
					spawnEvent.id = i
					spawnEvent.Xpos = position[1]
					spawnEvent.Ypos = position[2]
					spawnEvent.direction = position[3]
					self:dispatchEvent(spawnEvent)
				end
			end			
		end
	end
end