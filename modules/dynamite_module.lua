--dynamite_module.lua
testworld = require "testworld"
dynamite = {};

function findDist(x1,y1,x2,y2)
  x3 = x2-x1;
  y3 = y2-y1;
  length = math.abs( math.sqrt(math.pow(x3,2)+math.pow(y3,2)));
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
  self.intact = 1;
  self.explosiondist = 100;
  self.explosionFlame = love.graphics.newImage("/assets/explosionFlame.png")
  self.explosionParticles = love.graphics.newParticleSystem(self.explosionFlame, 1000)
  self.explosionParticles:setParticleLifetime(2, 5) -- Particles live at least 2s and at most 5s.
	self.explosionParticles:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to black.
  --TODO: fix particles, they would be nice
end

function dynamite:explode(enemies, player, dynamite,x,y) --explode enemies
  testworld:shakescreen(40);
  self.explosionParticles:emit(32)
  self.intact = 0;
  for i=1, #enemies do
    if findDist(self.x,enemies[i].x,self.y,enemies[i].y) <= self.explosiondist  then
      if enemies[i].alive == 1 then
        enemies[i]:hurt();
      end

    end

  end
  for i=1, #dynamite do --Loop for chain reactions. Much easier than blick flicker lmao
    if findDist(self.x,dynamite[i].x,self.y,dynamite[i].y) <= self.explosiondist then
      if dynamite[i].intact == 1 then
        dynamite[i]:explode(enemies, player, dynamite,x,y);
      end

    end

end

if findDist(self.x,player.x,self.y,player.y) <= self.explosiondist then --explode player
  player:hurt();
end
end

function dynamite:update(bullets,enemies, player, dynamite,bx,by,dt)
  self.explosionParticles:update(dt)
  if self.intact == 1 then --"intact" here meaning "unexploded"
    for i,v in ipairs(bullets) do
      if CheckCollision(v.x,v.y,2,2,self.x,self.y,32, 32) then
        self:explode(enemies, player, dynamite,v.x,v.y,bw,bh);
      end
    end
  end


end

return dynamite;
