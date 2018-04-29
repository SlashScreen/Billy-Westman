--main.lua
function love.load()
  love.graphics.setBackgroundColor(255,255,255);
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  
  player = require "modules/player_module";
  baseenemy = require "modules/enemy_module";
  
  --jsonfile = require "assets/billywestman.json";
  player:init(love.graphics.newImage("assets/billywestman.png"), nil, 300, 300);
  --testenemy.init(love.graphics.newImage("assets/billywestman.png"), nil, 200, 150);
  
  enemies = {};
  --enemies[2] = baseenemy;
  --enemies[1] = baseenemy;
  local function makeObj(class)
    local mt = { __index = class }
    local obj = setmetatable({}, mt)
    return obj;
  end

  enemies[2] = makeObj(baseenemy)
  enemies[1] = makeObj(baseenemy)
  enemies[3] = makeObj(baseenemy)
  --setmetatable(enemies[1], {__index = testenemy});
  --setmetatable(enemies[2], {__index = testenemy});
  enemies[2]:init(love.graphics.newImage("assets/billywestman.png"), nil, 200, 150, "Enemy2");
  enemies[1]:init(love.graphics.newImage("assets/billywestman.png"), nil, -100, 150, "Enemy1");
  enemies[3]:init(love.graphics.newImage("assets/billywestman.png"), nil, 100, 0, "Enemy3");
  
  crosshair = love.graphics.newImage("assets/crosshair.png");
  
  playerWalkTimer = 0;
  zoom = 1;
end

function love.update(dt)
  --player.animate("walk");
  --testenemy.decideMovement(player.x,player.y,dt);
  
  
  playerWalkTimer = playerWalkTimer + dt
  if playerWalkTimer > .5 then
    player:animate("walk");
    --testenemy.animate("walk");
    for i = 1, #enemies do
      enemies[i]:animate("walk");
    end
    playerWalkTimer = 0;
  end
for i = 1, #enemies do -- main interaction IG
    print (#enemies);
    enemies[i]:decideMovement(player.x,player.y,dt);
    if love.mouse.isDown(1) then
  
    if enemies[i].alive == 1 then
      enemies[i]:isHit(love.mouse.getX(), love.mouse.getY(), player.x, player.y, window.x, window.y);
  end
  


end
  end
if love.keyboard.isDown("w") then
  player:decideMovement(0,1);
end
if love.keyboard.isDown("s") then
  player:decideMovement(0,-1);
end
if love.keyboard.isDown("a") then
  player:decideMovement(-1,0);
end
if love.keyboard.isDown("d") then
  player:decideMovement(1,0);
end

end

function love.draw()
  --window.y/2,window.x/2
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16,window.y/2-16,0,zoom);
  for i = 1, #enemies do
    print (enemies[i].alive, enemies[i].id);
    if enemies[i].alive == 1 then
  --love.graphics.draw(testenemy.icon,testenemy.frames[testenemy.increment],testenemy.x-16-player.x+window.x/2,testenemy.y-16-player.y+window.y/2,0,zoom);
  love.graphics.draw(enemies[i].icon,enemies[i].frames[enemies[i].increment],enemies[i].x-16-player.x+window.x/2,enemies[i].y-16-player.y+window.y/2,0,zoom);
  end
    
  end
  
  
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2))
end
