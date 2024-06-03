-- Gifts, ie collectables, on levels
-- Set level name and collectable x and y positions

gifts = {}

function gifts:init()
    -- Set data
    gifts.info = {
        levels = {
            {
                levelName = 'The Candy Shop',
                posX = {120, 200, 250, 100, 192},
                posY = {40, 50, 40, 96, 96}
            },{
                levelName = 'Santa\'s Outhouse',
                posX = {208, 152, 48, 128, 176},
                posY = {160, 144, 48, 72, 72}
            },{
                levelName = 'The Freezer',
                posX = {144, 240, 104, 168, 61},
                posY = {168, 168, 104, 88, 40}
            },{
                levelName = 'Rockin\' Robins\' Nest',
                posX = {232},
                posY = {168}
            },{
                levelName = 'The Elf Dormitory',
                posX = {65, 65, 120, 177, 233},
                posY = {96, 56, 128, 128, 128}
            },{
                levelName = 'The Frozen Furnace',
                posX = {139, 184, 96, 250, 250},
                posY = {96, 96, 48, 48, 128}
            },{
                levelName = 'Rudolph\'s Bedroom',
                posX = {56, 248, 152, 178, 128},
                posY = {104, 104, 160, 40, 40}
            },{
                levelName = 'Candy Cane Chimney',
                posX = {56, 250, 154, 56, 250},
                posY = {48, 48, 128, 103, 103}
            },{
                levelName = 'The Living Room',
                posX = {56, 248, 56, 154, 248},
                posY = {128, 128, 54, 54, 54}
            },{
                levelName = 'The Games Room',
                posX = {57, 153, 246, 87, 216},
                posY = {42, 48, 42, 97, 97}
            }
        },
        animation = {
            howManyGifts = 5,
            totalFrames = 6,
            giftsSheet = 'gsheet.png'
        }
    } 
    -- Example use: 1. posX = gifts.info.levels[1].posX[1], 2. levelName = gifts.info.levels[1].levelName
    -- gifts.test = gifts.info.animation.giftsSheet

    -- Let's grab spritesheets!
    gifts.spriteSheet = love.graphics.newImage(path:getGraphicsPath() .. gifts.info.animation.giftsSheet)
    gifts.setFrames = {}
    for i = 1, gifts.info.animation.totalFrames do
        gifts.setFrames[i] = {}
        gifts.setFrames[i][0] = love.graphics.newQuad((i - 1) * 16, 0, 16, gifts.spriteSheet:getHeight(), gifts.spriteSheet)
        gifts.setFrames[i][1] = true -- visibility
    end

    gifts.currentFrame = 1
    gifts.frameStart = 1
    gifts.frameEnd = gifts.info.animation.totalFrames - 1
    gifts.frameSpeedMax = 0.05
    gifts.frameSpeed = gifts.frameSpeedMax
end

-- Reset gift visibility for new level
function gifts:reset()
    for i = 1, gifts.info.animation.totalFrames do
        gifts.setFrames[i][1] = true
    end
    levelData:resetItems()
end

function gifts:update()
    -- Check if player has touched a collectable
    for i = 1, #gifts.info.levels[levelData.currentLevel].posX do
        if gifts.setFrames[i][1] == true then
            local boxXLeft = gifts.info.levels[levelData.currentLevel].posX[i]
            local boxYLeft = gifts.info.levels[levelData.currentLevel].posY[i]
            local playerLeft = player.x
            local playerTop = player.y
            local hit = false
            if collision:checkHitboxes(boxXLeft, boxYLeft, playerLeft, playerTop) == true then
                hit = true 
            end
            if hit == true then
                text.score = text.score + 10
                -- Disappear pressie
                gifts.setFrames[i][1] = false
                -- Then remove it from the level to help trigger end of level
                levelData:removeItem()
                if not sound.dong:isPlaying() then
                    sound:pickup()
                end
                break
            end
        end
    end

    -- Animation limits
    local currentSpeed = gifts.frameSpeed
    local animSpeed = gifts.frameSpeedMax
    if currentSpeed > 0 then
        currentSpeed = currentSpeed - (1 * dt)
    else
        currentSpeed = animSpeed
        if gifts.currentFrame < gifts.frameEnd then
            gifts.currentFrame = gifts.currentFrame + 1
        else
            gifts.currentFrame = gifts.frameStart
        end
    end
    gifts.frameSpeed = currentSpeed
end

function gifts:draw()
    for i = 1, #gifts.info.levels[levelData.currentLevel].posX do
        if gifts.setFrames[i][1] == true then
            local posX = gifts.info.levels[levelData.currentLevel].posX[i]
            local posY = gifts.info.levels[levelData.currentLevel].posY[i]
            frameImg = gifts.setFrames[gifts.currentFrame][0]
            love.graphics.draw(gifts.spriteSheet, frameImg, posX, posY)
        end
    end
end