-- Enemies
-- Enemy positions are hard-coded for each level etc

enemies = {}

function enemies:init()
    -- Set data
    -- speed: enemy movement
    -- direction: 1(up), 2(down), 3(left), 4(right) - start direction movement
    --            5(left and up), 6(right and up), 7(left and down), 8(right and down) - for icecubes
    -- posX/posY: start positions
    -- type: enemy 1, 2, 3, or 4 (duck, xmas tree, snowman, ice block)
    -- animFrames: frames, speed of each enemy in the same order as above types
    enemies.set = {
        levels = {
            { -- level 1
                moveSpeed = {1, 1, 1, 1},
                direction = {4, 3, 4, 2},
                directionStart = {4, 3, 4, 2},
                posX = {128, 229, 116, 160},
                posY = {168, 168, 112, 80},
                startX = {128, 229, 116, 160},
                startY = {168, 168, 112, 80},
                type = {1, 1, 1, 2}
            },{ -- level 2
                moveSpeed = {1, 1, 1, 1},
                direction = {2, 4, 5, 4},
                directionStart = {2, 4, 5, 4},
                posX = {232, 112, 134, 176},
                posY = {160, 112, 109, 56},
                startX = {232, 112, 134, 176},
                startY = {160, 112, 109, 56},
                type = {2, 1, 4, 1}
            },{ -- level 3
                moveSpeed = {1, 1, 1, 1},
                direction = {2, 4, 8, 4},
                directionStart = {2, 4, 8, 4},
                posX = {69, 158, 248, 168},
                posY = {165, 152, 144, 56},
                startX = {69, 158, 256, 168},
                startY = {165, 152, 144, 56},
                type = {2, 1, 4, 1}
            },{ -- level 4
                moveSpeed = {1, 1, 1, 1, 1, 1, 1, 1, 1},
                direction = {3, 4, 4, 3, 3, 4, 4, 3, 3},
                directionStart = {3, 4, 4, 3, 3, 4, 4, 3, 3},
                posX = {105, 156, 200, 99, 164, 135, 210, 53, 144},
                posY = {136, 112, 112, 88, 88, 64, 64, 40, 40},
                startX = {105, 156, 200, 99, 164, 135, 210, 53, 144},
                startY = {136, 112, 112, 88, 88, 64, 64, 40, 40},
                type = {1, 1, 1, 1, 1, 1, 1, 1, 1}
            },{ -- level 5
                moveSpeed = {1, 1, 1, 1},
                direction = {2, 2, 1, 3},
                directionStart = {2, 2, 1, 3},
                posX = {123, 180, 236, 48},
                posY = {86, 62, 88, 50},
                startX = {123, 180, 236, 48},
                startY = {86, 62, 88, 50},
                type = {2, 2, 2, 1}
            },{ -- level 6
                moveSpeed = {1, 1, 1, 1, 1, 1, 1, 1},
                direction = {3, 2, 1, 2, 3, 3, 4, 3},
                directionStart = {3, 2, 1, 2, 3, 3, 4, 3},
                posX = {216, 113, 161, 208, 56, 216, 108, 120},
                posY = {38, 90, 70, 80, 112, 168, 143, 168},
                startX = {216, 113, 161, 208, 56, 216, 108, 120},
                startY = {38, 90, 70, 80, 112, 168, 143, 168},
                type = {1, 2, 2, 2, 3, 3, 1, 3}
            },{ -- level 7
                moveSpeed = {1, 1, 1, 1},
                direction = {2, 1, 5, 6},
                directionStart = {2, 1, 5, 6},
                posX = {86, 220, 120, 160},
                posY = {98, 80, 110, 98},
                startX = {86, 220, 120, 160},
                startY = {98, 80, 110, 98},
                type = {2, 2, 4, 4}
            },{ -- level 8
                moveSpeed = {1, 1, 1, 1},
                direction = {4, 3, 3, 4},
                directionStart = {4, 3, 3, 4},
                posX = {65, 238, 111, 194},
                posY = {88, 88, 128, 128},
                startX = {65, 238, 111, 194},
                startY = {88, 88, 128, 128},
                type = {1, 1, 1, 1}
            },{ -- level 9
                moveSpeed = {1, 1, 1, 1},
                direction = {1, 2, 4, 5},
                directionStart = {1, 2, 4, 5},
                posX = {75, 224, 160, 177},
                posY = {62, 78, 70, 120},
                startX = {75, 224, 160, 177},
                startY = {62, 78, 70, 120},
                type = {2, 2, 1, 4}
            },{ -- level 10
                moveSpeed = {1, 1, 1, 1},
                direction = {1, 2, 6, 5},
                directionStart = {1, 2, 6, 5},
                posX = {50, 254, 136, 176},
                posY = {100, 132, 112, 112},
                startX = {50, 254, 136, 176},
                startY = {100, 132, 112, 112},
                type = {2, 2, 4, 4}
            }
        },
        animFrames = {
            {   -- Duck
                frames = 2,
                currentFrame = 1,
                speed = 0.5,
                currentSpeed = 0.5
            },{ -- xmas tree
                frames = 3,
                currentFrame = 1,
                speed = 0.2,
                currentSpeed = 0.2
            },{ -- snowman
                frames = 3,
                currentFrame = 1,
                speed = 0.5,
                currentSpeed = 0.5
            },{ -- iceblock
                frames = 6,
                currentFrame = 1,
                speed = 0.1,
                currentSpeed = 0.1
            }
        }
    }

    -- Let's load the sprite sheet in
    enemies.spriteSheet = love.graphics.newImage(path:getGraphicsPath() .. 'enemies.png') -- modify the path for real DOS, ie. remove subfolder name?!

    -- Now the quads for each enemy
    enemies.setFrames = {}
    enemies.animTimer = {}
    local startX = 0
    for i = 1, #enemies.set.animFrames do
        enemies.setFrames[i] = {} -- how many animation frames for this enemy
        -- Remember, this is a horizontal spritesheet
        for j = 1, enemies.set.animFrames[i].frames do
            enemies.setFrames[i][j] = love.graphics.newQuad(startX, 0, 16, enemies.spriteSheet:getHeight(), enemies.spriteSheet) 
            startX = startX + 16
        end
    end
end

-- This should reset enemy values between levels
function enemies:reset()
    local currentLevel = levelData.currentLevel
    for i = 1, #enemies.set.levels[currentLevel].posX do
        -- And x/y positions!
        enemies.set.levels[currentLevel].posX[i] = enemies.set.levels[currentLevel].startX[i]
        enemies.set.levels[currentLevel].posY[i] = enemies.set.levels[currentLevel].startY[i]
        -- And direction!
        enemies.set.levels[currentLevel].direction[i] = enemies.set.levels[currentLevel].directionStart[i]
    end
    -- Reset anim frames
    for i = 1, #enemies.set.animFrames do
        enemies.set.animFrames[i].currentSpeed = enemies.set.animFrames[i].speed
        enemies.set.animFrames[i].currentFrame = 1
    end
end

function enemies:update()
    for i = 1, #enemies.set.levels[levelData.currentLevel].posX do
        -- Animation updates
        local getType = enemies.set.levels[levelData.currentLevel].type[i]
        local getMaxFrames = enemies.set.animFrames[getType].frames
        local currentFrame = enemies.set.animFrames[getType].currentFrame
        local animSpeed = enemies.set.animFrames[getType].speed
        local currentSpeed = enemies.set.animFrames[getType].currentSpeed
        -- Count down animation timer
        if currentSpeed > 0 then
            currentSpeed = currentSpeed - (1 * dt)
        else
            currentSpeed = animSpeed
            -- Then change to new frame
            if currentFrame < getMaxFrames then
                currentFrame = currentFrame + 1
            else
                currentFrame = 1
            end
            enemies.set.animFrames[getType].currentFrame = currentFrame
        end
        enemies.set.animFrames[getType].currentSpeed = currentSpeed

        -- Movement updates
        local direction = enemies.set.levels[levelData.currentLevel].direction[i]
        local moveSpeed = enemies.set.levels[levelData.currentLevel].moveSpeed[i] * 30 * dt
        -- direction: 1(up), 2(down), 3(left), 4(right)
        if direction == 1 then
            local enemyTop = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] + 8, enemies.set.levels[levelData.currentLevel].posY[i] - 1)
            if enemyTop == -1 then
                enemies.set.levels[levelData.currentLevel].posY[i] = enemies.set.levels[levelData.currentLevel].posY[i] - moveSpeed
            else
                direction = 2
            end

        elseif direction == 2 then
            local enemyBtm = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] + 8, enemies.set.levels[levelData.currentLevel].posY[i] + 17)
            if enemyBtm == -1 and enemies.set.levels[levelData.currentLevel].posY[i] < love.graphics.getHeight() - 16 then
                enemies.set.levels[levelData.currentLevel].posY[i] = enemies.set.levels[levelData.currentLevel].posY[i] + moveSpeed
            else
                direction = 1
            end

        elseif direction == 3 then
            local enemyLeft = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] - 1, enemies.set.levels[levelData.currentLevel].posY[i] + 8)
            -- Extra checks for snowmen so they dont go past the edge
            if getType == 3 then
                local enemyBtmLeft = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] - 1, enemies.set.levels[levelData.currentLevel].posY[i] + 17)
                if enemyBtmLeft == -1 or enemies.set.levels[levelData.currentLevel].posX[i] < 50 then
                    direction = 4
                else
                    enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] - moveSpeed
                end
            else
                if enemyLeft == -1 then
                    enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] - moveSpeed
                else
                    direction = 4
                end
            end

        elseif direction == 4 then
            local enemyRight = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] + 17, enemies.set.levels[levelData.currentLevel].posY[i] + 8)
            -- Extra checks for snowmen so they dont go past the edge
            if getType == 3 then
                local enemyBtmRight = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] + 17, enemies.set.levels[levelData.currentLevel].posY[i] + 17)
                if enemyBtmRight == -1 or enemies.set.levels[levelData.currentLevel].posX[i] > (love.graphics.getWidth() - 66) then
                    direction = 3
                else
                    enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] + moveSpeed
                end
            else
                if enemyRight == -1 then
                    enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] + moveSpeed
                else
                    direction = 3
                end
            end
        end

        if getType == 4 then
            -- Left and up
            if direction == 5 then
                enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] - moveSpeed
                enemies.set.levels[levelData.currentLevel].posY[i] = enemies.set.levels[levelData.currentLevel].posY[i] - moveSpeed

            -- right and up
            elseif direction == 6 then
                enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] + moveSpeed
                enemies.set.levels[levelData.currentLevel].posY[i] = enemies.set.levels[levelData.currentLevel].posY[i] - moveSpeed

            -- left and down
            elseif direction == 7 then
                enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] - moveSpeed
                enemies.set.levels[levelData.currentLevel].posY[i] = enemies.set.levels[levelData.currentLevel].posY[i] + moveSpeed

            -- right and down
            elseif direction == 8 then
                enemies.set.levels[levelData.currentLevel].posX[i] = enemies.set.levels[levelData.currentLevel].posX[i] + moveSpeed
                enemies.set.levels[levelData.currentLevel].posY[i] = enemies.set.levels[levelData.currentLevel].posY[i] + moveSpeed
            end

            -- Check if enemy needds to come from top, not level 10!
            if levelData.currentLevel < 10 then
                if enemies.set.levels[levelData.currentLevel].posY[i] > love.graphics.getHeight() then
                    enemies.set.levels[levelData.currentLevel].posY[i] = 28
                end
                if enemies.set.levels[levelData.currentLevel].posY[i] < 28 then
                    enemies.set.levels[levelData.currentLevel].posY[i] = love.graphics.getHeight()
                end
            else
                if enemies.set.levels[levelData.currentLevel].posY[i] > love.graphics.getHeight() - 16 then
                    if direction == 7 then
                        direction = 5
                    else
                        direction = 6
                    end
                end
            end

            -- Now check collisions - using a variable name so as to speed up checking collisions as well as reducing getPixel() overheads
            local enemyTop = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] + 8, enemies.set.levels[levelData.currentLevel].posY[i])
            local enemyLeft = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i], enemies.set.levels[levelData.currentLevel].posY[i] + 8)
            local enemyRight = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] + 16, enemies.set.levels[levelData.currentLevel].posY[i] + 8)
            local enemyBtm = levelData:getPixel(enemies.set.levels[levelData.currentLevel].posX[i] + 8, enemies.set.levels[levelData.currentLevel].posY[i] + 16)

            -- 5(left and up), 6(right and up), 7(left and down), 8(right and down)
            -- Top
            if enemyTop ~= -1 then
                if direction == 5 then
                    if enemyLeft == -1 then
                        direction = 7
                    else
                        direction = 8
                    end
                elseif direction == 6 then
                    if enemyRight == -1 then
                        direction = 8
                    else
                        direction = 7
                    end
                end
            end
            -- Bottom
            if enemyBtm ~= -1 then
                if direction == 7 then
                    if enemyLeft == -1 then
                        direction = 5
                    else
                        direction = 6
                    end
                elseif direction == 8 then
                    if enemyRight == -1 then
                        direction = 6
                    else
                        direction = 5
                    end
                end
            end
            -- Left
            if enemyLeft ~= -1 then
                if direction == 5 then
                    if enemyTop == -1 then
                        direction = 6
                    else
                        direction = 8
                    end
                elseif direction == 7 then
                    if enemyBtm == -1 then
                        direction = 8
                    else
                        direction = 6
                    end
                end
            end

            -- Right
            if enemyRight ~= -1 then
                if direction == 6 then
                    if enemyTop == -1 then
                        direction = 5
                    else
                        direction = 7
                    end
                elseif direction == 8 then
                    if enemyBtm == -1 then
                        direction = 7
                    else
                        direction = 5
                    end
                end
            end
        end

        -- Update direction
        enemies.set.levels[levelData.currentLevel].direction[i] = direction
    end
end

-- Return all the enemy positions to see if player collided
function enemies:isHit(playerX, playerY)
    local isHit = false
    for i = 1, #enemies.set.levels[levelData.currentLevel].posX do
        local boxXLeft = enemies.set.levels[levelData.currentLevel].posX[i]
        local boxYLeft = enemies.set.levels[levelData.currentLevel].posY[i]
        if collision:checkHitboxes(boxXLeft, boxYLeft, playerX, playerY) == true then
            isHit = true
            break
        end
    end
    return isHit
end

function enemies:draw()
    for i = 1, #enemies.set.levels[levelData.currentLevel].posX do
        local posX = enemies.set.levels[levelData.currentLevel].posX[i]
        local posY = enemies.set.levels[levelData.currentLevel].posY[i]
        local getType = enemies.set.levels[levelData.currentLevel].type[i]
        local frame = enemies.set.animFrames[getType].currentFrame
        local direction = enemies.set.levels[levelData.currentLevel].direction[i]
        -- Flip image horizontally if when changing direction
        if direction == 3 then
            direction = true
        elseif direction == 4 then
            direction = false
        end
        love.graphics.draw(enemies.spriteSheet, enemies.setFrames[getType][frame], posX, posY, direction)
    end
end