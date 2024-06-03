-- Crimbo for DOS by Sensei of Blackjet 2023
-- To compile, do : love --pack mygame mygame.exe and include cwsdpmi.exe

-- Set up loading state for assets and includes
function love.load()
    -- Load splash path and asset
    local splashPath = 'sprites/'
    splash = love.graphics.newImage(splashPath .. 'splash.png')
    -- Game state
    state = {'loading', 'menu', 'intro', 'play', 'pause', 'gameover'}
    -- state.current is to create a "loading" state while the main loop runs, so as to load in data pleasingly
    -- instead of mkaing the player wait on a black screen and wondering if the game has hung!
    state.current = 'loading'
    state.colours = {
        red = 255,
        green = 255,
        blue = 255
    }
    loadingText = 'Loading, please wait '
    loadFileNo = 0
    dt = 0
end

function love.update()
    dt = love.timer.getDelta()
    keyState = ''
    keyJumpState = ''

    if state.current == 'loading' then
        local files = {'path', 'console', 'random', 'snow', 'player', 'enemies', 'text', 'menu', 'intro', 'audio', 'level', 'reset', 'gifts', 'cols'}
        loadingText = loadingText .. '.'
        loadFileNo = loadFileNo + 1
        if loadFileNo <= #files then
            -- Load lua include files in
            require(files[loadFileNo])
        else
            -- Then init each included class
            path:init()
            console:init()
            random:init()
            snow:init()
            player:init()
            enemies:init()
            sound:init()
            text:init()
            menu:init()
            intro:init()
            levelData:init()
            reset:init()
            gifts:init()
            collision:init()
            gifts:reset()
            state.current = 'menu'
        end
        
    end

    -- The game's menu state
    if state.current == 'menu' then
        if love.keyboard.isDown("g") then
            state.current = 'intro'
        end
        if love.keyboard.isDown('q') then
            love.event.quit()
        end
        if love.keyboard.isDown('k') then
            state.current = 'keys'
        end

        -- Snowflakes
        snow:update()
    end

    -- Shows the in-game keys to play the game
    if state.current == 'keys' then
        snow:update()
        if love.keyboard.isDown('escape') then
            state.current = 'menu'
        end
    end

    if state.current == 'intro' then
        -- Update snowflakes
        snow:update()

        if intro:isTextFinished() == true then
            state.current = 'nextLevel'
            love.graphics.setColor(255, 255, 255)
        end

        intro:textUpdate()
        if love.keyboard.isDown('space') then
            intro.hasTextDisplayed = true
        end
    end

    -- Game in the play loop state now
    if state.current == 'play' then
        -- We're checking for both WASD (D and A only in this case) and arrow keys
        if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
            keyState = 'right'
        end
        if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
            keyState = 'left'
        end
        if love.keyboard.isDown('p') then
            state.current = 'pause'
        end
        -- Clear and reset all parameter states and values
        if love.keyboard.isDown('escape') then
            state.current = 'menu'
            reset:clearAll()
            player:reset()
            gifts:reset()
            sound:stopMusic()
        end
        -- Set the jump state (if not already jumping)
        if love.keyboard.isDown('space') then
            keyJumpState = 'jump'
            player.keyboardTimer = player.keyboardTimer + 1
        else
            keyJumpState = 'notjump'
            if player.keyboardTimer > 0 then
                player.keyboardTimer = 0
            end
        end
        player:update(keyState, keyJumpState)   -- Update player state
        gifts:update()                          -- Update collectables
        enemies:update()                        -- Update enemy states
        -- Also update the timer
        local currentTime = text:getTime()
        local isHit = false                     -- Reset player hit status
        if currentTime ~= text.levelStartTimer then
            if text.levelTimer < 6 and text.levelTimer > 0 then
                sound:time()
            end
            text.levelTimer = text.levelTimer - 1
            text.levelStartTimer = currentTime
            if text.levelTimer <= 0 then
                isHit = true
            end
        end

        -- Check lives
        if player:isHit(isHit) then
            state.current = 'deathPause'
            sound:playerDie()
        else
            -- Check if level complete by seeing how many collectables are left
            if levelData:checkLevelItems(levelData.currentLevel) <=  0 then
                levelData.currentLevel = levelData.currentLevel + 1
                if levelData.currentLevel > 10 then
                    state.current = 'win'
                    sound:gameOver()
                else
                    -- Give player bonus based on time left
                    if text.levelTimer > 0 then
                        text.bonus = text.levelTimer * 100
                        text.score = text.score + text.bonus
                        if text.bonus > 1000 then
                            player.lives = player.lives + 1
                        end
                    end
                    enemies:reset()             -- Reset enemy states for next level
                    player:reset()              -- Reset player to start point
                    gifts:reset()               -- Reset collectables for next level
                    state.current = 'nextLevel'
                end
            end
        end
    end

    -- Pause the game so player can see he died, then check for game over
    if state.current == 'deathPause' then
        if player.deathCounter < player.deathCounterMax then
            player.deathCounter = player.deathCounter + (1 * dt)
        else
            state.current = 'nextLevel'
            player.lives = player.lives - 1
            if player.lives <= 0 then
                sound:gameOver()
                text:setHighscore()
                state.current = 'gameover'
            else
                player.deathCounter = 0
                enemies:reset()
                player:reset()
                gifts:reset()
            end
        end
    end

    if state.current == 'nextLevel' then
        if levelData.currentLevel > 10 then
            player.x = 120 -- set player position for win screen
            keyState = ''
            state.current = 'win'
        else
            -- Wait for player to hit return to start
            if love.keyboard.isDown('return') then                
                text.bonus = 0 -- reset bonus
                text:resetTimer()
                sound:playMusic()
                state.current = 'play'
            end
        end
    end

    -- Wait for player to hit key before resuming paused game
    if state.current == 'pause' then
        if love.keyboard.isDown('return') then
            state.current = 'play'
        end
    end

    -- Player has died
    if state.current == 'gameover' then
        if love.keyboard.isDown('return') then
            reset:clearAll()
            player:reset()
            gifts:reset()
            sound:stopMusic()
            state.current = 'menu'
        end
    end

    -- Player has beat the game
    if state.current == 'win' then
        player.x = 120
        snow:update()
        -- Fun logic to change santa's direction by snow wind direction
        if snow.windSpeed < 0 then
            player.direction = false
        else
            player.direction = true
        end
        if love.keyboard.isDown('return') then
            text:setHighscore(text.score)
            reset:clearAll()
            player:reset()
            gifts:reset()
            sound:stopMusic()
            state.current = 'menu'
        end
    end
end

function love.draw()
    -- Update progress bar visually while loading in assets and includes
    if state.current == 'loading' then
        love.graphics.draw(splash, 0, 0)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 90, 0, 160, 20)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print(loadingText, 100, 0)
        if loadFileNo >= 13 then
            love.graphics.setColor(0, 255, 0)
            love.graphics.print('Initialising', 140, 10)
        end
    end

    -- Display game play buttons
    if state.current == 'keys' then
        love.graphics.draw(menu.footer, (love.graphics.getWidth() - menu.footer:getWidth()) / 2, love.graphics.getHeight() - menu.footer:getHeight())
        -- Snowflakes
        love.graphics.setColor(255, 255, 255)
        snow:draw()

        local keys = text:getKeys()
        local keysY = 40
        for i = 0, #text.keys - 1 do
            love.graphics.print(keys[i], text:getCentered(keys[i]), keysY)
            keysY = keysY + 20
        end
        love.graphics.setColor(255, 0, 0)
        love.graphics.print(keys[#text.keys], text:getCentered(keys[#text.keys]), keysY + 20)
    end

    -- Display game menu
    if state.current == 'menu' then
        -- Snowflakes
        love.graphics.setColor(255, 255, 255)
        snow:draw()
        -- Highscore
        love.graphics.print(text.menu.highscore .. text.highscore, text:getCentered(text.menu.highscore .. text.highscore), 5)
        -- logo
        menu:draw()
        -- text
        love.graphics.setColor(255, 0, 0)
        local menu = text:getMenu()
        local menuY = text.menu.y
        for i = 0, #text.menu.string do
            love.graphics.print(menu[i], text:getCentered(menu[i]), menuY)
            menuY = menuY + 15
        end

        -- BJ logo
        love.graphics.setColor(80, 80, 200)
        love.graphics.print(text.menu.bj, text:getCentered(text.menu.bj), love.graphics.getHeight() - 30)
    end

    -- Display game intro
    if state.current == 'intro' then
        -- cabin
        intro:draw()
        love.graphics.setColor(255, 255, 255)
        -- Snowflakes
        snow:draw()
        -- text
        intro:textUpdate()
        love.graphics.draw(intro.bjlogo, love.graphics.getWidth() - intro.bjlogo:getWidth(), love.graphics.getHeight() - intro.bjlogo:getHeight())
    end

    if state.current == 'play' or state.current == 'deathPause' then
        levelData:draw(levelData.currentLevel)
        gifts:draw()
        enemies:draw()
        player:draw()
        local highscore = 'HI ' .. text.highscore
        local score = 'SC ' .. text.score
        local scoreLen = score: len() * 8
        love.graphics.setColor(state.colours.red, 0, 0)
        love.graphics.print(highscore, 33, 8)
        love.graphics.setColor(state.colours.red, 0, state.colours.blue)
        love.graphics.print(gifts.info.levels[levelData.currentLevel].levelName, text:getCentered(gifts.info.levels[levelData.currentLevel].levelName), 0)
        love.graphics.setColor(0, state.colours.green, 0)
        love.graphics.print(text.levelTimer, 177, 8)
        love.graphics.setColor(state.colours.red, 0, 0)
        love.graphics.print(score, love.graphics.getWidth() - scoreLen - 19, 8)
        love.graphics.setColor(0, state.colours.green, state.colours.blue)
        love.graphics.print('Lives', 3, 25)
        love.graphics.setColor(0, state.colours.green, 0)
        love.graphics.print(player.lives, 12, 35)
        -- Show player lives
        for i = 1, player.lives do
            if i < 9 then
                love.graphics.draw(player.spriteSheet, imgFrame, 8, 28 + (i * 18), player.direction)
            end
        end
        
    end

    -- Display next level's name and get ready..
    if state.current == 'nextLevel' then
        love.graphics.draw(menu.footer, (love.graphics.getWidth() - menu.footer:getWidth()) / 2, love.graphics.getHeight() - menu.footer:getHeight())
        love.graphics.setColor(state.colours.red, state.colours.green, state.colours.blue)
        -- Bonus text
        if text.bonus > 0 then
            love.graphics.print(text.bonusText .. text.bonus .. '!', text:getCentered(text.bonusText .. text.bonus .. '!'), 10)
            if text.bonus > 1000 then
                love.graphics.print('Extra life!', text:getCentered('Extra life!'), 20)
            end
        end
        -- Lives left
        love.graphics.print('Lives left: ' .. player.lives, text:getCentered('Lives left: ' .. player.lives), 30)
        -- Lives left graphic
        local playerImgX = (love.graphics.getWidth() - (player.lives * 16)) / 2
        for i = 1, player.lives do
            love.graphics.draw(player.spriteSheet, player.standFrame, playerImgX, 50)
            playerImgX = playerImgX + 20
        end

        love.graphics.print('Next level:', text:getCentered('Next level:'), 100)
        love.graphics.setColor(0, state.colours.green, 0)
        -- Level name
        love.graphics.print(gifts.info.levels[levelData.currentLevel].levelName, text:getCentered(gifts.info.levels[levelData.currentLevel].levelName), 120)
        love.graphics.setColor(state.colours.red, state.colours.green, state.colours.blue)
        -- Get ready text
        love.graphics.print(text.paused[1], text:getCentered(text.paused[1]), 140)
    end

    if state.current == 'win' then
        love.graphics.setColor(state.colours.red, state.colours.green, state.colours.blue)
        -- Win Text
        local y = 70
        for i = 0, #text.win do
            love.graphics.print(text.win[i], text:getCentered(text.win[i]), y)
            y = y + 20
        end
        -- Footer
        love.graphics.draw(menu.footer, (love.graphics.getWidth() - menu.footer:getWidth()) / 2, love.graphics.getHeight() - menu.footer:getHeight())
        -- Snow
        snow:draw()
        -- Santa
        if player.x > 64 then
            player.x = player.x + snow.windSpeed
        end
        love.graphics.draw(player.spriteSheet, player.standFrame, player.x, love.graphics.getHeight() - 33, player.direction)
    end

    -- Display Pause text
    if state.current == 'pause' then
        local pauseText = text:getPauseText()
        for i = 0, 1 do
            love.graphics.print(pauseText[i], text:getCentered(pauseText[i]), 70 + (i * 20))
        end
    end

    -- Display Game over text
    if state.current == 'gameover' then
        local gameOverText = text:getGameOverText()
        for i = 0, 1 do
            love.graphics.print(gameOverText[i], text:getCentered(gameOverText[i]), 70 + (i * 20))
        end
    end

    -- Used for logging while making game
    if state.current ~= 'loading' then
        console:print()
    end
end

