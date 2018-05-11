--player_module
player = {};
json = require("modules/json");

function player:init(ico, jsondat, x, y)
  player.icon = ico;
  player.json = jsondat;
  --player.data = json.decode(player.jsondat);
  player.increment = 0;
  player.frames = {};
  player.frames[0] = love.graphics.newQuad(0,0,32,32,player.icon:getDimensions())
  player.frames[1] = love.graphics.newQuad(32,0,32,32,player.icon:getDimensions())
  player.x = x;
  player.y = y;
  player.speed = 2;
  player.ammo = 10;
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


function player:decideMovement(x,y)
  player.x = player.x + (x*player.speed);
  player.y = player.y - (y*player.speed);
end

function player:animate(action)
  if action == "walk" then
    --put in the animation thing
    if player.increment == 1 then
      player.increment = 0;
    else
      player.increment = player.increment+1;
    end
    
    
  end
  
end
return player