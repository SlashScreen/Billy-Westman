--main.lua
function love.load()
  love.graphics.setBackgroundColor(255,255,255);
  love.graphics.setColor(0,0,0)
  window = {}
  window.x = love.graphics:getWidth();
  window.y = love.graphics:getHeight();
  
  player = require "modules/player_module";
  baseenemy = require "modules/enemy_module";
  json = require "modules/json"
  --TownSpawnList = json.decode("assets/spawntable.json")
  
  player:init(love.graphics.newImage("assets/billywestman.png"), nil, 300, 300);
  billywestmanimg = love.graphics.newImage("assets/billywestman.png");
  BulletImg = love.graphics.newImage("assets/BillyWestmanBullet.png");
  spawnlist = {
    {name = "Enemy1",x = -100, y=150,image = billywestmanimg, class=baseenemy},
    {name = "Enemy2",x = 200, y=150,image = billywestmanimg, class=baseenemy},
    {name = "Enemy3",x = 100, y=0,image = billywestmanimg, class=baseenemy},
    {name = "Enemy4",x = 0, y=300,image = billywestmanimg, class=baseenemy}
    };
  
  enemies = {};
  local function makeObj(class)
    local mt = { __index = class }
    local obj = setmetatable({}, mt)
    return obj;
  end
  for i=1, #spawnlist do
    enemies[i] = makeObj(spawnlist[i].class);
    enemies[i]:init(spawnlist[i].image,nil,spawnlist[i].x,spawnlist[i].y,spawnlist[i].name);
  end
  crosshair = love.graphics.newImage("assets/crosshair.png");
  
  bulletSpeed = 250
 
	bullets = {}
  
  
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
    --print (#enemies);
    enemies[i]:decideMovement(player.x,player.y,dt);
    if enemies[i].alive == 1 then
      for o,v in ipairs(bullets) do
        if enemies[i]:isHit(v.x, v.y, player.x, player.y, window.x, window.y) then
          table.remove(bullets,o);
        end
      end
      
      
  end
  
for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
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
function love.mousepressed(x, y, button)
	if button == 1 then
		local startX = player.x--window.x / 2
		local startY = player.y--window.y / 2
		local mouseX = x
		local mouseY = y
 
		local angle = math.atan2((mouseY - startY), (mouseX - startX))
 
		local bulletDx = bulletSpeed * math.cos(angle)
		local bulletDy = bulletSpeed * math.sin(angle)
 
		table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy})
	end
end

function love.draw()
  
  --window.y/2,window.x/2
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16,window.y/2-16,0,zoom);
  for i = 1, #enemies do
    --print (enemies[i].alive, enemies[i].id);
    if enemies[i].alive == 1 then
  
  love.graphics.draw(enemies[i].icon,enemies[i].frames[enemies[i].increment],enemies[i].x-16-player.x+window.x/2,enemies[i].y-16-player.y+window.y/2,0,zoom);
  end
    
  end
  for i,v in ipairs(bullets) do
    print(bullets[i].x,bullets[i].y);
		love.graphics.draw(BulletImg, v.x-player.x+window.x/2, v.y-player.y+window.y/2)
	end
  
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2))
end
