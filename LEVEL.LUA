-- Read in level map data
-- Load in each png level image (I had to do it this way as LoveDOS cannot handle tile images fast enough in DOS)

levelData = {}

function levelData:init()
    levelData.tileWidth = 8
    levelData.levels = 10 -- How many levels in the game
    levelData:resetLevel()

    -- Save r, g, b values for hit detection on player
    levelData.colours = {0, 0, 0}

    -- Load the tilesheets first
    levelData.gfx = {}
    levelData.gfxData = {}
    for i = 1, levelData.levels do
        local img = path:getDataPath() .. 'lvl' .. i .. '.png'
        levelData.gfx[i] = love.graphics.newImage(img)
    end

    levelData.statusBar = love.graphics.newImage(path:getGraphicsPath() .. 'status.png')
end

-- Called on init and when player goes back to menu
function levelData:resetLevel()
    levelData.currentLevel = 1
    levelData:resetItems()
end

-- Reset this seperately so player doesn't get fresh lives each time he dies 
function levelData:resetItems()
    levelData.levelItems = {5, 5, 5, 1, 5, 5, 5, 5, 5, 5}
end

-- Return how many collectables on the relevant level
function levelData:checkLevelItems(level)
    return levelData.levelItems[level]
end

-- Remove qty of items on level
function levelData:removeItem()
    levelData.levelItems[levelData.currentLevel] = levelData.levelItems[levelData.currentLevel] - 1
end

-- This important function is what is used to detect a non-black pixel collision
-- Usually this is done the opposite way where you check for a black/empty pixel, but not in LoveDOS
function levelData:getPixel(x, y)
    local r, g, b = levelData.gfx[levelData.currentLevel]:getPixel(x, y)
    local result = -1
    if r then   -- shorthand for checking if the value exists (ie, is ~= nil)
        result = result + r
    end
    if g then
        result = result + g
    end
    if b then
        result = result + b
    end
    return result
end

-- This one for player with spike collisions
-- So based on above code, we check the collision colours to compare it against
function levelData:getPlayerPixel(x, y)
    local r, g, b = levelData.gfx[levelData.currentLevel]:getPixel(x, y)
    local isHit = false
    levelData.colours = {r, g, b}
    if levelData.currentLevel ==  1 then
        -- light green
        if levelData.colours[1] == 0 and levelData.colours[2] == 255 and levelData.colours[3] == 0 then
            isHit = true
        -- dark green
        elseif levelData.colours[1] == 0 and levelData.colours[2] == 192 and levelData.colours[3] == 0 then
            isHit = true
        end
    elseif levelData.currentLevel ==  3 then
        -- dark green
        if levelData.colours[1] == 0 and levelData.colours[2] == 125 and levelData.colours[3] == 113 then
            isHit = true
        -- red
        elseif levelData.colours[1] == 255 and levelData.colours[2] == 0 and levelData.colours[3] == 0 then
            isHit = true
        end
    elseif levelData.currentLevel ==  5 then
        -- dark green
        if levelData.colours[1] == 0 and levelData.colours[2] == 191 and levelData.colours[3] == 0 then
            isHit = true
        -- light green
        elseif levelData.colours[1] == 0 and levelData.colours[2] == 255 and levelData.colours[3] == 0 then
            isHit = true
        end
    elseif levelData.currentLevel ==  9 then
        -- light green
        if levelData.colours[1] == 0 and levelData.colours[2] == 255 and levelData.colours[3] == 0 then
            isHit = true
        -- red
        elseif levelData.colours[1] == 255 and levelData.colours[2] == 32 and levelData.colours[3] == 0 then
            isHit = true
        end
    elseif levelData.currentLevel ==  10 then
        -- yellow
        if levelData.colours[1] == 255 and levelData.colours[2] == 255 and levelData.colours[3] == 0 then
            isHit = true
        -- green
        elseif levelData.colours[1] == 0 and levelData.colours[2] == 255 and levelData.colours[3] == 32 then
            isHit = true
        end
    end
    return isHit
end

function levelData:draw(level)
    -- Level
    love.graphics.draw(levelData.gfx[level], 0, 0)
    -- Status bar
    love.graphics.draw(levelData.statusBar, 0, 7)
end
