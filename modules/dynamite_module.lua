--dynamite_module.lua
dynamite = {};

function findDist(x1,y1,x2,y2)
  x3 = x2-x1;
  y3 = y2-y1;
  length = math.sqrt(math.pow(x3,2)+math.pow(y3,2));
  return length;
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function dynamite:init(x,y,sprite)
  self.sprite = sprite;
  self.x = x;
  self.y = y;
end

function dynamite:explode(enemies, player, dynamite)
  for i=1, #enemies do
    if findDist(self.x,enemies[i].x,self.y,enemies[i].y) <= 50 then
      enemies[i]:hurt();
    end
    
  end
  
  --for enemies, dynamite, if distance close enough, hurt/explode them
  --player, hurt player
  --remove self from existence
end

function dynamite:update(bullets,enemies, player, dynamite)
  --if hit by bullet explode
  for i=1, #bullets do
    if CheckCollision(bullets[i].x,bullets[i].y,bullets[i].x+2,bullets[i].y+2,self.x,self.y,self.x+32,self.y+32) then
      self:explode(enemies, player, dynamite);
    end
  end
  
end


return dynamite;