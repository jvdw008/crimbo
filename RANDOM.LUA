-- Random number generator since there is no such thing in LoveDOS
-- Usage:
-- set the max value first outside of a loop with setRandomMax(value)
-- Then in a loop or whatever, call getRandom()

random = {}

function random:init()
    random.max = 10
    random.last = 10
    random.val = 10
end

function random:setRandomMax(val)
    random.max = val
    random.last = love.timer.getTime() % random.max
end

function random:getRandom()
    random.last = (random.last * 32719 + 3) % 32749
    return random.last % random.max
end