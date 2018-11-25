--ammobox.lua
ammobox = {}

function ammobox:init(img,x,y,name,world)
  self.type = "ammo"
  self.taken = false
  self.x = x
  self.y = y
  self.img = img
  self.w = 30
  self.h = 15
  self.frame = 0
  self.increment = 0
  self.animtimer = 0
  self.frames = {}
  self.frames[0] = love.graphics.newQuad(0,0,50,32,self.img:getDimensions())
  self.frames[1] = love.graphics.newQuad(50,0,50,32,self.img:getDimensions())
  print(self.frames)
end

function ammobox:getFrames()
  return self.frames
end

function ammobox:take()
  self.taken = true
end

function ammobox:incrementframe(i)
  self.frame = self.frame + i
end

function ammobox:animate(action,dt) --the animation cycle
  self.animtimer = self.animtimer + dt
  if self.animtimer >= .7 then
    self.animtimer = 0
    if action == "float" then
      if self.increment == 1 then
        self.increment = 0;
      else
        self.increment = self.increment+1;
      end
    end
  end
end

function ammobox:iscolliding(x1,y1,w1,h1)
  return x1 < self.x+self.w and
         self.x < x1+w1 and
         y1 < self.y+self.h and
         self.y < y1+h1
end

return ammobox
