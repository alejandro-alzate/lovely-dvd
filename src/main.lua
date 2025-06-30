love.graphics.setDefaultFilter("nearest", "nearest")
local box = require("box")
local dvd = love.graphics.newImage("dvd.png")

local palette = {
	{ 1,   1,   1 },
	{ 0,   1,   1 },
	{ 1,   0,   1 },
	{ 0,   0,   1 },
	{ 1,   0.7, 0.7 },
	{ 0.7, 1,   0.7 },
	{ 0.7, 0.7, 1 },
	{ 0.5, 0.5, 1 },
	{ 1,   0.5, 0.5 },
	{ 0.5, 1,   0.5 },
}

local function changeColorCallback(self)
	local selected = math.random(#palette)
	while self.color == selected and #palette > 1 do
		selected = math.random(#palette)
	end
	self.color = palette[selected]
end

local boxParams = {
	type = "dynamic",
	x = 0,
	y = 0,
	width = 100,
	height = 100,
	xVel = 100,
	yVel = 100,
	drawable = dvd,
	onCollisionCallbacks = { changeColorCallback },
}
local box1 = box.new(boxParams)

function love.load()
	local vw, wh = love.graphics.getDimensions()
	love.resize(vw, wh)
end

function love.update(dt)
	box1:update(dt)
end

function love.draw()
	box1:draw()
end

function love.resize(width, height)
	local factor = 0.35
	local dw, dh = dvd:getDimensions()
	local rw, rh = 0, 0
	rw = math.min(width * factor, height * factor) * dw / math.max(dw, dh)
	rh = math.min(width * factor, height * factor) * dh / math.max(dw, dh)

	box1.width = rw
	box1.height = rh
end
