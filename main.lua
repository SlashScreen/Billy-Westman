--main.lua
function love.load()
  testworld = require "testworld"
  gdqs = require "gdqs"
  west = require "westham-map"
  currentworld = west;
  currentworld:load();
  love.mouse.setVisible(false);
end
main = {}
function main:reset()
  currentworld:load();
end

function main:changeLevel(lvl)
  if lvl == "west" then
    currentworld = west
  elseif lvl == "mines" then
    currentworld = gdqs
  end
  main:reset()
end


function love.update(dt)
  currentworld:update(dt);
  canchange, goToMap = currentworld:canChange();
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
end

return main
