-- Intro screen stuff

intro = {}

function intro:init()
    intro.bjlogo = love.graphics.newImage(path:getGraphicsPath() .. 'bjlogo.png')
    intro.cabin = love.graphics.newImage(path:getGraphicsPath() .. 'cabin.png')
    intro.text = text:getIntroText()
    intro.textTimerMax = 0 -- Scroll speed
    intro.textTimer = 0 -- start timer
    intro.textCurrentPos = love.graphics.getWidth() + 1
    intro.endTextPos = -love.graphics.getWidth() * 2.2
    intro.hasTextDisplayed = false
end

-- Change position of text (text scroll)
function intro:textUpdate()
    intro.textTimer = intro.textTimer + 1
    if intro.textCurrentPos > intro.endTextPos then
        if intro.textTimer > intro.textTimerMax then
            intro.textCurrentPos = intro.textCurrentPos - 30 * dt
            intro.textTimer = 0
        end
    else
        intro.textCurrentPos = love.graphics.getWidth() + 1
        intro.hasTextDisplayed = true
    end
end

function intro:draw()
    love.graphics.draw(intro.cabin, (love.graphics.getWidth() - intro.cabin:getWidth()) / 2, 30)
    love.graphics.setColor(0, 0, 255)
    love.graphics.print(intro.text, intro.textCurrentPos, 150)
end

function intro:isTextFinished()
    return intro.hasTextDisplayed
end

function intro:reset()
    intro.textCurrentPos = love.graphics.getWidth() + 1
    intro.hasTextDisplayed = false
end