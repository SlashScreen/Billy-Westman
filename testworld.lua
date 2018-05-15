--testworld.lua
--proof of concept for having multiple worlds without cluttering poor main.lua
testworld = {};
function testworld:draw()
  love.graphics.print("hello",100,100);
end

return testworld;