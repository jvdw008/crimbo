-- In-game texts
-- This displays text on the screen on various states and positions

text = {}

function text:init()
    text.score = 0
    text.bonus = 0
    text.highscore = 1000
    text.timerMax = 31
    text:resetTimer()
    text.levelStartTimer = 0

    -- Main screen text
    text.menu = {}
    text.menu.string = {}
    text.menu.y = 100

    text.menu.string[0] = 'K: Keys'
    text.menu.string[1] = 'G: Go!'
    text.menu.string[2] = 'Q: Quit'
    text.menu.highscore = 'Highscore: '

    -- Intro screen text
    text.intro = "On no! It's christmas eve and santa's helpers have gone on strike and have hidden all the presents around the house. Help santa save christmas!"

    -- Pause/next level
    text.paused = {}
    text.paused[0] = 'Game Paused'
    text.paused[1] = 'Press ENTER to start'

    -- Game over
    text.gameover = {}
    text.gameover[0] = 'Game over!'
    text.gameover[1] = 'Press ENTER for Menu'

    -- Keys
    text.keys = {}
    text.keys[0] = 'A or Left Arrow to move left'
    text.keys[1] = 'D or Right Arrow to move right'
    text.keys[2] = 'Space to jump'
    text.keys[3] = 'P to Pause game'
    text.keys[4] = 'Escape to quit to menu'
    text.keys[5] = 'Escape: Menu'

    -- Win
    text.win = {}
    text.win[0] = 'Congratulations!'
    text.win[1] = 'Have a very Merry Christmas'
    text.win[2] = 'from'
    text.win[3] = 'Blackjet'

    -- 'Next' screen
    text.bonusText = 'You got a bonus of '

    -- BJ
    text.menu.bj = 'A game by Blackjet in 2023'
end

-- Use this to see time pass for level time
function text:getTime()
    return tonumber(math.floor(love.timer.getTime()))
end

function text:resetTimer()
    text.levelTimer = text.timerMax
end

function text:getMenu()
    return text.menu.string
end

function text:getPauseText()
    return text.paused
end

function text:getGameOverText()
    return text.gameover
end

function text:getKeys()
    return text.keys
end

function text:setScore(score)
    text.score = score
end

function text:setHighscore()
    if text.score > text.highscore then
        text.highscore = text.score
    end
end

function text:getIntroText()
    return text.intro
end

-- Use this to display text centered on the screen
function text:getCentered(text)
    return (love.graphics.getWidth() - (text:len() * 5)) / 2
end