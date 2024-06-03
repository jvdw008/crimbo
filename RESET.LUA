-- Reset all data that needs to be done when game over or esc to menu

reset = {}

function reset:init()
    -- Do nothing
end

function reset:clearAll()
    levelData:resetLevel() -- reset back to level 1 and level items
    intro.hasTextDisplayed = false -- Ensure intro shown again
    text:setScore(0) -- reset player score
    player.lives = 5
    text:resetTimer()
    enemies:reset()
    gifts:reset()
    intro:reset()
end