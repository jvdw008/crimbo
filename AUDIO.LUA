-- Sound fx!
-- To play a sound use src:play(), ie sound.jump:play()

sound = {}

function sound:init()
    -- Load sounds in
    sound.music = love.audio.newSource(path:getSoundPath() .. 'xmas.wav', 'stream')
    sound.music:setLooping(true)
    sound.jump = love.audio.newSource(path:getSoundPath() .. 'jump.wav')
    sound.dong = love.audio.newSource(path:getSoundPath() .. 'dong2.wav')
    sound.timer = love.audio.newSource(path:getSoundPath() .. 'time.wav')
    sound.die = love.audio.newSource(path:getSoundPath() .. 'die.wav')
    sound.gameover = love.audio.newSource(path:getSoundPath() .. 'win.wav')
end

function sound:menuClick()
    -- No sound
end

function sound:playerJump()
    sound.jump:play()
end

function sound:pickup()
    sound.dong:play()
end

function sound:time()
    sound.timer:play()
end

function sound:playerDie()
    sound.die:play()
end

function sound:gameOver()
    sound.gameover:play()
end

function sound:playMusic()
    sound.music:play()
end

function sound:stopMusic()
    sound.music:stop()
end