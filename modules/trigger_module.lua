--trigger_module.lua
trigger = {};
function trigger:init(x,y,state,btype,imgs,linkedto)
  trigger.x = x;
  trigger.y = y;
  trigger.state = state;
  trigger.type = btype;
  trigger.linkedto = linkedto;
  trigger.img = imgs;
end
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
function trigger:isHit(x,y,ox,oy,wx,wy,bw,bh)
  if CheckCollision(self.x,self.y,32, 32,x,y,bw,bh) then
    if trigger.type == "ONCE" then
      trigger.state = true;
    end
    if trigger.type == "TOGGLE" then
      trigger.state = not trigger.state;
    end
    return true;
  else
    return false;
    end
end
return trigger;