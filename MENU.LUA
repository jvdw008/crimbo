-- Menu screen stuff

menu = {}

function menu:init()
    menu.logo = love.graphics.newImage(path:getGraphicsPath() .. 'logo.png')
    menu.footer = love.graphics.newImage(path:getGraphicsPath() .. 'menubtm.png')
end

function menu:draw()
    love.graphics.draw(menu.logo, (love.graphics.getWidth() - menu.logo:getWidth()) / 2, 30)
    love.graphics.draw(menu.footer, (love.graphics.getWidth() - menu.footer:getWidth()) / 2, love.graphics.getHeight() - menu.footer:getHeight())
end