-- For outputting data to the screen for debugging
-- User console:set in the update() stats of includes or loops to set the text/data you want to see

console = {}

function console:init()
    console.x = 0
    console.y = love.graphics.getHeight() - 10
    console.text = ''
end

function console:set(data)
    console.text = data
end

function console:print()
    love.graphics.print(console.text, console.x, console.y)
end