--main.lua
function love.load()
  testworld = require "testworld"
  gdqs = require "gdqs"
  currentworld = gdqs;
  currentworld:load();
  love.mouse.setVisible(false);
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
