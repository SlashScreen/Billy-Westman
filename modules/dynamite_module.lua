--dynamite_module.lua
testworld = require "testworld"
dynamite = {};

function findDist(x1,y1,x2,y2)
  x3 = x2-x1;
  y3 = y2-y1;
  length = math.sqrt(math.pow(x3,2)+math.pow(y3,2));
  return length;
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  print(x2,x2+w2,y2,y2+h2,"check")
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function dynamite:init(x,y,sprite)
  self.sprite = sprite;
  self.x = x;
  self.y = y;
  self.intact = 1;
  self.explosiondist = 100;
end

function dynamite:explode(enemies, dynamite,x,y)
  print("boom!",x,y,self.x,self.y);
  testworld:shakescreen(40);
  self.intact = 0;
  for i=1, #enemies do
    if findDist(self.x,enemies[i].x,self.y,enemies[i].y) <= self.explosiondist then
      if enemies[i].alive == 1 then
        enemies[i]:die();
      end
      
    end
    
  end
  for i=1, #dynamite do
    if findDist(self.x,dynamite[i].x,self.y,dynamite[i].y) <= self.explosiondist then
      if dynamite[i].intact == 1 then
        dynamite[i]:explode(enemies, player, dynamite,x,y);
      end
      
    end
  
  
end

  --for enemies, dynamite, if distance close enough, hurt/explode them
  --player, hurt player
  --remove self from existence
end

function dynamite:update(bullets,enemies, player, dynamite,bx,by)
  --if hit by bullet explode
  print(player.x,player.y,self.x,self.y)
  if self.intact == 1 then
    for i,v in ipairs(bullets) do
      if CheckCollision(v.x,v.y,2,2,self.x,self.y,32, 32) then
    --if findDist(self.x,dynamite[i].x,self.y,dynamite[i].y) <= 2 then
        self:explode(enemies, dynamite,v.x,v.y,bw,bh);
      end
    end
  end
  
  
end

--bug maybe: coordinate systems different

return dynamite;