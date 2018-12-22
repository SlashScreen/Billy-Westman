--loadscreen.lua
loadscreen = {}

function loadscreen:load()
  self.state = 0
  main = require ("../main");
  self.destination = nil
  --0 idle,1 intro,2 load,3 outro
end

function loadscreen:loadscreen(dest)
  self.destination = dest --must me world object
end

function loadscreen:update()
end

function loadscreen:draw()

end

return loadscreen
