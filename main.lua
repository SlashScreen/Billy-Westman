--main.lua
function love.load()
  love.graphics.setBackgroundColor(255,255,255);
  player = require "modules/player_module";
  --jsonfile = require "assets/billywestman.json";
  player.init(love.graphics.newImage("assets/billywestman.png"));
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  playerWalkTimer = 0;
  zoom = 1;
end

function love.update(dt)
  --player.animate("walk");
  playerWalkTimer = playerWalkTimer + dt
  if playerWalkTimer > .5 then
    player.animate("walk");
    playerWalkTimer = 0;
  end
end

function love.draw()
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2,window.y/2,0,zoom);
end
