-- Used to easily change the folder structure for testing on DosBox and real DOS

path = {}

function path:init()
    path.realDOS = false
    if path.realDOS == false then
        path.sounds = 'sounds/'
        path.graphics = 'sprites/'
        path.data = 'data/'
    else
        path.sounds = '.\\sounds\\'
        path.graphics = '.\\sprites\\'
        path.data = '\\data\\'
    end
end

function path:getSoundPath()
    return path.sounds
end

function path:getGraphicsPath()
    return path.graphics
end

function path:getDataPath()
    return path.data
end