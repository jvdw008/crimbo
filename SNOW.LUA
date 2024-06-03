-- snow config for menu screen
-- Just animate snow movement
require 'random'

snow = {}

function snow:init()
    snow.qty = 30
    snow.x = {}
    snow.y = {}
    snow.speed = {}
    snow.windSpeed = 0
    snow.setRandomWindMax = 100
    snow.setRandomWind = 100
    snow.directionChange = 0
    
    -- Set X values
    for i = 1, snow.qty do
        snow:resetX(i)
    end

    -- Set Y values
    random:setRandomMax(100)
    for j = 1, snow.qty do
        snow.y[j] = -random:getRandom()
    end
    
    -- Set speed values
    for i = 1, snow.qty do
        snow:resetSpeed(i)
    end
end

-- When snow is out of bounds of screen, reset position and speed
-- This way we're not constantly creating and destroying snow particles, but instead re-using existing ones
function snow:resetX(index)
    random:setRandomMax(love.graphics.getWidth())
    snow.x[index] = random:getRandom()
    snow:resetSpeed(index)
end

function snow:resetSpeed(index)
    random:setRandomMax(40)
    snow.speed[index] = random:getRandom() + 10
end

function snow:update()
    for s = 1, snow.qty do
        snow.y[s] = snow.y[s] + (snow.speed[s] * dt)
        if snow.y[s] > love.graphics.getHeight() then
            snow.y[s] = -1
            snow:resetX(s) -- change to new random x pos
        end
        -- Update x with wind speed
        if snow.x[s] < 0 then
            snow.x[s] = love.graphics.getWidth()
        end
        if snow.x[s] > love.graphics.getWidth() then
            snow.x[s] = 0
        end
        snow.x[s] = snow.x[s] + (snow.windSpeed * dt)
    end

    -- Check if wind is going
    if snow.setRandomWind > 0 then
        snow.setRandomWind = snow.setRandomWind - 1
        
        if snow.directionChange < 40 then
            snow.windSpeed = 5
        end
        if snow.directionChange >= 40 and snow.directionChange <= 80 then
            snow.windSpeed = -5
        end
        if snow.directionChange > 80 then
            snow.windSpeed = 0
        end
    else
        snow.setRandomWind = snow.setRandomWindMax -- reset
        snow.windSpeed = 0
        snow.directionChange = random:getRandom()
        random:setRandomMax(100)
    end

end

function snow:draw()
    for s = 1, snow.qty do
        love.graphics.point(snow.x[s], snow.y[s])
    end
end