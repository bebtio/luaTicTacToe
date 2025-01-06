-- entity.lua
local Entity = {}
Entity.__index = Entity

-- Constructor function
function Entity.new(x, y, vx, vy, image)


    -- Create a new “object” that is just a table
    local self = {
        image = image or nil,
        -- pos can be a small table with x, y
        pos = { x = x or 0, y = y or 0 },
        -- vel can be a small table with x, y
        vel = { x = vx or 0, y = vy or 0 },
    }
    setmetatable(self, Entity)
    return self
end

-- Update function: move the entity based on velocity and dt
function Entity:update(dt)
    self.pos.x = self.pos.x + self.vel.x * dt
    self.pos.y = self.pos.y + self.vel.y * dt
end

-- Optionally a function to draw the entity (if you like)
function Entity:draw()
    -- Example: draw a simple rectangle (or sprite) at pos.x, pos.y

    love.graphics.setColor(1,1,1,0.5)
    if self.image == nil then
        love.graphics.circle("fill", self.pos.x, self.pos.y,32)
    else
        love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, 2,2)
    end

    love.graphics.setColor(1,1,1)
end

function createInitialClouds( numClouds, image )

    local image = image or nil
    local rng = love.math.newRandomGenerator()

    local px,py,vx,vy = 0,0,0,0
    
    local clouds = {}
    for i = 0, numClouds do
        px = rng:random(0, love.graphics.getWidth())
        py = rng:random(0, love.graphics.getHeight())

        vx = rng:random(20,50)
        vy = 0

        table.insert(clouds,Entity.new(px,py,vx,vy,image))
    end

    return clouds
end

return Entity
