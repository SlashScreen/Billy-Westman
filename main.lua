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
    currentworld.changemapConditionsMet = 0; --style
    if goToMap == "test" then
      currentworld = testworld;
    else if goToMap == "westham" then
      print("westham");
    else if goToMap == "mines" then
      print("mines");
    else if goToMap == "gulch" then
      print("gulch");
    end

  end
end
end

end
end

function love.draw()
  currentworld:draw();
end
