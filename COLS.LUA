-- Collisions class
-- Used to do hit detection between 2 x and 2 y postitions

collision = {}

function collision:init()
    -- Do nothing here
end

function collision:checkHitboxes(box1LeftX, box1LeftY, playerX, playerY)
    local hit = false
    local playerSpace = 3
    local objectSpace = 2
    -- Make the hitboxes smaller than 16px! (14px)
    local eLeft = box1LeftX + objectSpace
    local eRight = box1LeftX + 16 - objectSpace
    local eTop = box1LeftY + objectSpace
    local eBtm = box1LeftY + 16 - objectSpace
    local pLeft = playerX + playerSpace
    local pRight = playerX + 16 - playerSpace
    local pTop = playerY + playerSpace
    local pBtm = playerY + 16 - playerSpace

    -- Top left of player is inside enemy
    if pLeft > eLeft and pLeft < eRight then
        if pTop > eTop and pTop < eBtm then
            hit = true
        end
    end

    -- Top right of player inside enemy
    if pRight > eLeft and pRight < eRight then
        if pTop > eTop and pTop < eBtm then
            hit = true
        end
    end

    -- Btm left of player inside enemy
    if pLeft > eLeft and pLeft < eRight then
        if pBtm > eTop and pBtm < eBtm then
            hit = true
        end
    end

    -- Btm right of player inside enemy
    if pRight > eLeft and pRight < eRight then
        if pBtm > eTop and pBtm < eBtm then
            hit = true
        end
    end

    return hit
end