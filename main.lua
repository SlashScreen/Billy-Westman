--main.lua
function love.load()
  love.graphics.setBackgroundColor(255,255,255);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  
  player = require "modules/player_module";
  testenemy = require "modules/enemy_module";
  
  --jsonfile = require "assets/billywestman.json";
  player.init(love.graphics.newImage("assets/billywestman.png"), nil, 300, 300);
  testenemy.init(love.graphics.newImage("assets/billywestman.png"), nil, 200, 150);
  
  crosshair = love.graphics.newImage("assets/crosshair.png");
  
  playerWalkTimer = 0;
  zoom = 1;
end

function love.update(dt)
  --player.animate("walk");
  testenemy.decideMovement(player.x,player.y,dt);
  playerWalkTimer = playerWalkTimer + dt
  if playerWalkTimer > .5 then
    player.animate("walk");
    testenemy.animate("walk");

    playerWalkTimer = 0;
  end

if love.keyboard.isDown("w") then
  player.decideMovement(0,1);
end
if love.keyboard.isDown("s") then
  player.decideMovement(0,-1);
end
if love.keyboard.isDown("a") then
  player.decideMovement(-1,0);
end
if love.keyboard.isDown("d") then
  player.decideMovement(1,0);
end
if love.mouse.isDown(1) then
  testenemy.isHit(love.mouse.getX(), love.mouse.getY(), player.x, player.y, window.x, window.y);
end

end
function love.draw()
  --window.y/2,window.x/2
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16,window.y/2-16,0,zoom);
  if testenemy.alive == 1 then
  love.graphics.draw(testenemy.icon,testenemy.frames[testenemy.increment],testenemy.x-16-player.x+window.x/2,testenemy.y-16-player.y+window.y/2,0,zoom);
  end
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2))
end
