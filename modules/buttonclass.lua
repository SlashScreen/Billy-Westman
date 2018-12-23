--buttonclass.lua
button = {}
local utils = require ("modules/utils");

function button:init(x,y,w,h,text,bg,ev)
  self.x = x
  self.y = y
  self.w = w
  self.h = h
  self.text = text
  self.event = ev
  self.bg = love.graphics.newImage(bg)
  self.rect = love.graphics.rectangle("fill",x,y,w,h)
end

function button:findScale()
  dx,dy = self.bg:getDimensions()
  sx,sy = utils:getRatio(self.w,dx),utils:getRatio(self.y,dy)
  return sx,sy
end

function button:clicked(mx,my)
  return mx > self.x and  mx < self.x+self.w and my > self.y and my < self.y+self.h
end

function button:draw()
  love.graphics.draw(self.bg, self.x, self.y, 0, button:findScale())
  --draw text
end

return button
