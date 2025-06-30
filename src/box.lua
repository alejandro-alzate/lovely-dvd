local box = {}
box.__index = box

local instances = {}

local function AABB(box1, box2)
	return
		box1.x < box2.x + box2.width and
		box1.x + box1.width > box2.x and
		box1.y < box2.y + box2.height and
		box1.y + box1.height > box2.y
end

local function AABBcollisionSide(box1, box2)
	if AABB(box1, box2) then
		if box1.x + box1.width > box2.x and box1.x < box2.x + box2.width then
			return "top", box2.y + box2.height - box1.y
		elseif box1.y + box1.height > box2.y and box1.y < box2.y + box2.height then
			return "left", box2.x + box2.width - box1.x
		elseif box1.x + box1.width > box2.x and box1.x < box2.x + box2.width then
			return "bottom", box1.y + box1.height - box2.y
		elseif box1.y + box1.height > box2.y and box1.y < box2.y + box2.height then
			return "right", box1.x + box1.width - box2.x
		end
	end
	return nil, nil
end

function box.new(params)
	params = params or {}
	local obj = setmetatable({}, box)
	obj.width = params.width or 0
	obj.height = params.height or 0
	obj.x = params.x or 0
	obj.y = params.y or 0
	obj.xVel = params.xVel or 0
	obj.yVel = params.yVel or 0
	obj.type = params.type or "static"
	obj.color = params.color or { r = 1, g = 1, b = 1, a = 1 }
	obj.canClipOffscreen = params.canClipOffscreen or false
	obj.drawable = params.drawable or false
	obj.onCollisionCallbacks = params.onCollisionCallbacks or {}
	table.insert(instances, obj)
	return obj
end

function box:onCollision(side, other)
	for _, callback in ipairs(self.onCollisionCallbacks) do
		callback(self, side, other)
	end
end

function box:update(dt)
	if self.type == "static" then return end
	self.x = self.x + self.xVel * dt
	self.y = self.y + self.yVel * dt

	if not self.canClipOffscreen then
		if self.x < 0 then
			self.x = 0
			self.xVel = -self.xVel
			self:onCollision("left", nil)
		elseif self.x + self.width > love.graphics.getWidth() then
			self.x = love.graphics.getWidth() - self.width
			self.xVel = -self.xVel
			self:onCollision("right", nil)
		end
		if self.y < 0 then
			self.y = 0
			self.yVel = -self.yVel
			self:onCollision("top", nil)
		elseif self.y + self.height > love.graphics.getHeight() then
			self.y = love.graphics.getHeight() - self.height
			self.yVel = -self.yVel
			self:onCollision("bottom", nil)
		end
	end
end

function box:draw()
	local color = {
		self.color.r or self.color[1] or 1,
		self.color.g or self.color[2] or 1,
		self.color.b or self.color[3] or 1,
		self.color.a or self.color[4] or 1
	}
	if self.drawable then
		love.graphics.setColor(color)
		love.graphics.draw(
			self.drawable,
			self.x, self.y, 0,
			self.width / self.drawable:getWidth(),
			self.height / self.drawable:getHeight()
		)
	else
		love.graphics.setColor(color)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end
end

return box
