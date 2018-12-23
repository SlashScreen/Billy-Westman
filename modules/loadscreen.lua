--loadscreen.lua
loadscreen = {}
local utils = require ("modules/utils");

function loadscreen:load(json,img)
  self.state = 0
  main = require ("main");
  self.img = love.graphics.newImage(img); --fix later with actual path here
  self.destination = nil

  --TODO: FIGURE OUT JSON AND STOP HARDCODING THIS. maybe utils function?
  self.frames = utils:getQuads(json,img)
  self.currentframe = 0
  --0 idle,1 intro,2 load,3 outro
  timer = 0
  tmax = .5
end

function loadscreen:loadscreen(dest)
  --print("loadscreen")
  self.destination = dest --must me world object
  self.state = 1
  print(self.state)
end

function loadscreen:update(dt)
  if self.state ~= 0 then
    timer = timer+dt
    --print(self.state)
  end
  --STATE 1
  if self.state == 1 then
    if timer >= tmax then
      timer = 0
      self.currentframe = self.currentframe + 1
      print(self.currentframe)
    end
    if self.currentframe == 4 then
      self.destination:load()
      main:setWorld(self.destination)
      main:reset()
    end
    if self.currentframe == #self.frames then
      self.currentframe = 0
      self.state = 0
    end
  end
end

function loadscreen:draw()
  --print(self.currentframe)
  love.graphics.draw(self.img,self.frames[self.currentframe],0,0)
end

return loadscreen
