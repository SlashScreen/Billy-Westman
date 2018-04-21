--main.lua
function love.load()
  love.graphics.setBackgroundColor(255,255,255);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  
  player = require "modules/player_module";
  testenemy = require "modules/enemy_module";
  
  --jsonfile = require "assets/billywestman.json";
  player.init(love.graphics.newImage("assets/billywestman.png"), nil, window.x/2, window.y/2);
  testenemy.init(love.graphics.newImage("assets/billywestman.png"), nil, 100, 100);
  
  crosshair = love.graphics.newImage("assets/crosshair.png");
  
  playerWalkTimer = 0;
  zoom = 1;
end

function love.update(dt)
  --player.animate("walk");
  playerWalkTimer = playerWalkTimer + dt
  if playerWalkTimer > .5 then
    player.animate("walk");
    testenemy.animate("walk");
    testenemy.decideMovement(player.x,player.y,dt);

    playerWalkTimer = 0;
  end
end

function love.draw()
  love.graphics.draw(player.icon,player.frames[player.increment],player.x-16,player.y-16,0,zoom);
  love.graphics.draw(testenemy.icon,testenemy.frames[testenemy.increment],testenemy.x-16,testenemy.y-16,0,zoom);
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2))
end
