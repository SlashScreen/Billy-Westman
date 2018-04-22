--enemy_module--player_module
enemy = {};
json = require("modules/json");

function lookat(x1,y1,x2,y2)
  local ygo = (y2-y1)/(x2-x1);
  return ygo;
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function enemy.init(ico, jsondat,x,y)
  enemy.icon = ico;
  enemy.json = jsondat;
  --player.data = json.decode(player.jsondat);
  enemy.increment = 0;
  enemy.frames = {};
  enemy.frames[0] = love.graphics.newQuad(0,0,32,32,enemy.icon:getDimensions())
  enemy.frames[1] = love.graphics.newQuad(32,0,32,32,enemy.icon:getDimensions())
  enemy.x = x;
  enemy.y = y;
  enemy.speed = 1;
  enemy.alive = 1;
  --[[
  player.cels = {};
  for i,v in ipairs(player.data.frames) do
    player.frames[i] = player.data.frames[i];
  end
  for o,k in ipairs(player.frames) do
    player.cels[o] = love.graphics.newQuad(player.frames[o].frame,player.icon:getDimensions()) --player.data.frames[i];
  end
  print(player.frames);
  ]]--
end

function enemy.die()
  enemy.alive = 0;
  print ("dead");
end



function lerp (a,b,t)
  return a + (b - a) * t;
end



function enemy.decideMovement(playerx,playery,dt)
  --[[
  local deltax = lerp(enemy.x, player.x, .5);
  local deltay = lerp(enemy.y, player.y, .5);
  enemy.x = enemy.x + deltax;
  enemy.y = enemy.y + deltay;
  ]]--
  local deltax = 0;
  local deltay = 0;
  if (enemy.x < playerx) then
    deltax = 1;
  else if (enemy.x > playerx) then
    deltax = -1;
  end
end

  if (enemy.y < playery) then
    deltay = 1;
  else if (enemy.y > playery) then
    deltay = -1;
  end
  end
  enemy.x = enemy.x + (deltax * enemy.speed);
  enemy.y = enemy.y + (deltay * enemy.speed);
  --print(enemy.x, enemy.y, playerx, playery);
end

function enemy.animate(action)
  if action == "walk" then
    --put in the animation thing
    if enemy.increment == 1 then
      enemy.increment = 0;
    else
      enemy.increment = enemy.increment+1;
    end
    
    
  end
  
end

function enemy.isHit(x,y,ox,oy,wx,wy)
  if CheckCollision(enemy.x-ox+(wx/2),enemy.y-oy+(wy/2),32, 32,x,y,2,2) then  --x < enemy.x-16-ox+(wx/2) and x > enemy.x+16-ox+(wx/2) and y > enemy.y-16-oy+(wy/2) and y < enemy.y+16-oy+(wy/2) then 
    enemy.die();
  end
end


return enemy;