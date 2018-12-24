--main.lua
function love.load()
  testworld = require "testworld"
  gdqs = require "gdqs"
  west = require "westham-map"
  menu = require "mainmenu"
  loadingscreen = require "modules/loadscreen"
  currentworld = menu;
  loadingscreen:load("assets/loadingscreenv1.json","assets/loadingscreenv1.png")
  currentworld:load();
  
end
main = {}
function main:reset()
  currentworld:load();
end

function main:changeLevel(lvl)
  --print("changelevel")
  print(lvl)
  if lvl == "westham" then
    loadingscreen:loadscreen(west)
  elseif lvl == "mines" then
    loadingscreen:loadscreen(gdqs)
  end
  --main:reset()
end

function main:setWorld(lvl)
  currentworld = lvl;
end

function love.update(dt)
  currentworld:update(dt);
  loadingscreen:update(dt)
end


function love.draw()
  currentworld:draw();
  loadingscreen:draw()
end

return main
