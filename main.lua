--main.lua
function love.load()
  testworld = require "testworld"
  gdqs = require "gdqs"
  west = require "westham-map"
  loadingscreen = require "modules/loadscreen"
  currentworld = gdqs;
  loadingscreen:load("assets/loadingscreenv1.json","assets/loadingscreenv1.png")
  currentworld:load();
  love.mouse.setVisible(false);
end
main = {}
function main:reset()
  currentworld:load();
end

function main:changeLevel(lvl)
  print("changelevel")
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
  canchange, goToMap = currentworld:canChange();
  loadingscreen:update(dt)
  if canchange then
    currentworld.changemapConditionsMet = 0;
    if goToMap == "test" then
      currentworld = testworld;
    elseif goToMap == "westham" then
      print("westham");
    elseif goToMap == "mines" then
      print("mines");
    elseif goToMap == "gulch" then
      print("gulch");
    end

  end
end


function love.draw()
  currentworld:draw();
  loadingscreen:draw()
end

return main
