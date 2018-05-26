--trigger_module.lua
trigger = {};
function trigger:init(x,y,state,btype,imgs,id,linkedto,world)
  self.x = x;
  self.y = y;
  self.state = state;
  self.type = btype;
  self.id = id;
  self.linkedto = linkedto;
  self.imgs = imgs;
  self.World = world
  self.World:add(self, self.x, self.y, 32, 32)
end
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
function trigger:isHit(x,y,ox,oy,wx,wy,bw,bh)
  if CheckCollision(self.x,self.y,32, 32,x,y,bw,bh) then
    if self.type == "ONCE" then
      print("im hit",x,y,ox,oy,wx,wy,bw,bh);
      self.state = 1;
    end
    if self.type == "TOGGLE" then
      self.state = not self.state;
    end
    return true;
  else
    return false;
    end
end
return trigger;