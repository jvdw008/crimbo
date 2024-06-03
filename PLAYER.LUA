-- Player stuff

player = {}

function player:init()
    player.lives = 5
    player:reset()
    player.framePace = 0 -- used in conjunction with the below
    player.framePaceMax = 0.1 -- animation frame speed between frames (to slow/speed up anim)
    player.jumpHeight = 42 -- pixels of jump height
    player.currentJumpY = 0
    player.spriteSize = 16
    player.keyboardTimer = 0
    player.deathCounter = 0 -- used to pause the game on the level when player dies
    player.deathCounterMax = 2

    -- Load the player jump timer
    player.jumpTimer = 0.8  -- to time how long to keep player in the air (default)
    player.jumpTimerMax = player.jumpTimer
    player.fallTimer = 40  -- to slow player fall
    player.upTimer = 30

    -- load player sprite sheet
    player.spriteSheet = love.graphics.newImage(path:getGraphicsPath() .. 'psheet.png') -- modify the path for real DOS, ie. remove subfolder name?!
    
    -- Walk
    player.walkFrames = {}
    player.walkFrames[0] = love.graphics.newQuad(48, 0, 16, player.spriteSheet:getHeight(), player.spriteSheet)
    player.walkFrames[1] = love.graphics.newQuad(64, 0, 16, player.spriteSheet:getHeight(), player.spriteSheet)
    player.walkFrames[2] = love.graphics.newQuad(80, 0, 16, player.spriteSheet:getHeight(), player.spriteSheet)
    
    -- Stand
    player.standFrame = love.graphics.newQuad(0, 0, 16, player.spriteSheet:getHeight(), player.spriteSheet)
    
    -- Jump
    player.jumpFrames = {}
    player.jumpFrames[0] = love.graphics.newQuad(16, 0, 16, player.spriteSheet:getHeight(), player.spriteSheet)
    player.jumpFrames[1] = love.graphics.newQuad(32, 0, 16, player.spriteSheet:getHeight(), player.spriteSheet)
end

-- Take a string and split it by seperator
function player:mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
        table.insert(t, str)
    end
    return t
end

-- Reset player pos and state each level
function player:reset()
    player.x = 50
    player.y = love.graphics.getHeight() - 40 --33
    player.direction = false -- player facing left or right
    player.speed = 50 -- player x movement speed
    player.currentFrame = 0 -- current anim frame
    player.hasLanded = true
    player.jumpState = false -- player not jumping
    player.jumpDirection = 0 -- 0 for up, 1 for down directions
    player.jumpTimerMax = player.jumpTimer
end

-- Check player fall state
function player:checkFall()
    if player.jumpState == false then
        player.hasLanded = false
        for i = 1, 2 do
            local nextYPos = player.y + player.spriteSize + i
            local btmLeft = levelData:getPixel(player.x, nextYPos)
            local btmMiddle = levelData:getPixel(player.x + 8, nextYPos)
            local btmRight = levelData:getPixel(player.x + 16, nextYPos)
            if btmLeft == -1 and btmMiddle == -1 and btmRight == -1 then
                player.y = player.y + (player.fallTimer * dt)
            else
                player.hasLanded = true
                break
            end
        end
    end
end

function player:update(keyState, keyJumpState)
    -- Is player trying to move right
    if keyState == 'right' then
        player.direction = true
        if player.y > 32 then
            local hit = false
            for i = 1, 14 do
                local pixelCheck = levelData:getPixel(player.x + 18, player.y + i)
                if pixelCheck ~= -1 then
                    hit = true
                    break
                end
            end
            if hit == false then
                player.x = player.x + (player.speed * dt)
            end
        end
    end
    -- Is player trying to move left
    if keyState == 'left' then
        player.direction = false
        if player.y > 32 then
            local hit = false
            for i = 1, 14 do
                local pixelCheck = levelData:getPixel(player.x - 2, player.y + i)
                if pixelCheck ~= -1 then
                    hit = true
                    break
                end
            end
            if hit == false then
                player.x = player.x - (player.speed * dt)
            end
        end
    end
    player:checkFall()

    -- Animate player sprite
    if player.framePace < player.framePaceMax then
        player.framePace = player.framePace + (1 * dt)
    else
        player.framePace = 0
        player.currentFrame = player.currentFrame + 1
        if player.currentFrame > 2 then
            player.currentFrame = 0
        end
    end

    if keyJumpState == 'notjump' then
        player.jumpState = false 
        player.jumpTimer = player.jumpTimerMax
    end
    
    if keyJumpState == 'jump' then
        if player.hasLanded == true then
            if player.keyboardTimer < 10 then
                -- Has player hit spike?
                local left = levelData:getPlayerPixel(player.x + 4, player.y + player.spriteSize + 2)
                local middle = levelData:getPlayerPixel(player.x + 8, player.y + player.spriteSize + 2)
                local right = levelData:getPlayerPixel(player.x + 12, player.y + player.spriteSize + 2)
                if left or middle or right then
                    -- player has hit spike
                else
                    player.jumpState = true
                    player.currentJumpY = player.y
                    if not sound.jump:isPlaying() then
                        sound:playerJump()
                    end
                end
            end
        end
    end

    -- Check player Y for falling through level from bottom to go to the top of the level
    if player.y > love.graphics.getHeight() - 16 then
        player.y = 28
    end

    -- Currently jumping
    if player.jumpState == true then
        player.hasLanded = false
        for i = 1, 2 do
            local nextYPos = player.y - 1
            local topLeft = levelData:getPixel(player.x, nextYPos)
            local topRight = levelData:getPixel(player.x + 16, nextYPos)
            if topLeft == -1 and topRight == -1 then
                player.y = player.y - (player.upTimer * dt)
                if player.y < player.currentJumpY - player.jumpHeight then
                    player.jumpState = false
                end
            else
                if player.jumpTimer > 0 then
                    player.jumpTimer = player.jumpTimer - (player.jumpTimerMax * dt)
                else
                    player.jumpState = false
                    player.jumpTimer = player.jumpTimerMax
                end
            end
        end
    end

    -- Check player not stuck in the level (thanks to png level image instead of tiles!)
    if player.hasLanded then
        local btmLeft = levelData:getPixel(player.x, player.y + 16)
        local btmMiddle = levelData:getPixel(player.x + 8, player.y + 16)
        local btmRight = levelData:getPixel(player.x + 16, player.y + 16)
        local topMiddle = levelData:getPixel(player.x + 8, player.y)
        -- Check if platform above player
        if topMiddle == -1 then
            -- Empty so let's'move player up
            if (btmLeft ~= -1 and btmMiddle ~= -1) or (btmMiddle ~= -1 and btmRight ~= -1) then
                player.y = player.y - 1
            end
        end
    end

    -- Adjust fall and jump based on FPS values (approximate)
    -- Manually setting values based on the hardware the game is run on
    local getFPS = love.timer.getFPS()
    -- console:set(getFPS)
    if getFPS <= 20 then
        -- 386 or less
        player.jumpTimerMax = 0.6
        player.fallTimer = 50

    elseif getFPS > 20 and getFPS <= 70 then
        -- 486
        player.jumpTimerMax = 0.8
        player.fallTimer = 40

    elseif getFPS > 70 and getFPS <= 150 then
        -- p(entium)1
        player.jumpTimerMax = 0.9
        player.fallTimer = 36

    elseif getFPS > 150 and getFPS <= 250 then
        -- p2
        player.jumpTimerMax = 1.0
        player.fallTimer = 34

    elseif getFPS > 250 and getFPS <= 400 then
        -- p3
        player.jumpTimerMax = 1.1
        player.fallTimer = 32

    elseif getFPS > 400 and getFPS <= 800 then
        -- p4
        player.jumpTimerMax = 1.2
        player.fallTimer = 30

    else
        -- intel core+
        player.jumpTimerMax = 1.4
        player.fallTimer = 25
    end
end

-- Now check player collisions
function player:isHit(timeFinished)
    local isHit = false
    -- Has player run out of time
    if timeFinished then
        isHit = true
    end
    -- Has player hit enemy?
    if enemies:isHit(player.x, player.y) == true then
        isHit = true
    end
    -- Has player hit spike?
    local left = levelData:getPlayerPixel(player.x + 4, player.y + player.spriteSize + 1)
    local middle = levelData:getPlayerPixel(player.x + (player.spriteSize / 2), player.y + player.spriteSize + 1)
    local right = levelData:getPlayerPixel(player.x + 12, player.y + player.spriteSize + 1)
    if left or middle or right then
        isHit = true
    end
    return isHit
end

function player:draw()
    if player.jumpState == false then
        if keyState == '' then
            imgFrame = player.standFrame
        end
        if keyState == 'left' or keyState == 'right' then
            local btmMiddle = levelData:getPixel(player.x + (player.spriteSize / 2), player.y + player.spriteSize + 1)
            if btmMiddle == -1 then
                imgFrame = player.jumpFrames[1] -- falling
            else
                imgFrame = player.walkFrames[player.currentFrame]
            end
        end
    else
        imgFrame = player.jumpFrames[0]
    end

    -- Override all frame selections above if player died
    if state.current == 'deathPause' then
        imgFrame = player.jumpFrames[1] -- falling
    end

    love.graphics.draw(player.spriteSheet, imgFrame, player.x, player.y, player.direction)
end
