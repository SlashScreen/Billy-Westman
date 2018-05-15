--main.lua
function love.load()
  testworld = require "testworld"
  testworld:load();
end
function love.update(dt)
  testworld:update(dt);
end


function love.draw()
  testworld:draw();
end
