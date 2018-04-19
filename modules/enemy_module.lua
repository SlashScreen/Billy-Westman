--enemy_module--player_module
enemy = {};
json = require("modules/json");

function lookat(x1,y1,x2,y2)
  local ygo = (y2-y1)/(x2-x1);
  return ygo;
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
  enemy.speed = 20;
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


function enemy.decideMovement(playerx,playery)
  local deltay = lookat(enemy.x, enemy.y, playerx, playery);
  print(deltay);
  if enemy.x > playerx then
    enemy.x = enemy.x - 1 * enemy.speed;
    enemy.y = enemy.y + deltay * enemy.speed;
  else
    enemy.x = enemy.x + 1 * enemy.speed;
    enemy.y = enemy.y + deltay * enemy.speed;
  end

  
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
return enemy;