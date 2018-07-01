--worldupdate.lua
worldupdate = {}

function worldupdate:shoot(body,x,y,coordspace,player,window,bullets)
  player.state = "FIRE";
		local startX = body.x--window.x / 2
		local startY = body.y--window.y / 2
    local dist = 50
    if coordspace == 0 then
      mouseX = body.x + x - window.x / 2
      mouseY = body.y + y - window.y / 2
    else
      mouseX =  x
      mouseY =  y 
    end
    print("moduleshoot",mouseX,mouseY)
		local angle = math.atan2((mouseY - startY), (mouseX - startX))
    print(startX,startY,mouseX,mouseY,angle*180/math.pi)
    
    startX = startX + (math.cos(angle)*50)
    startY = startY + (math.sin(angle)*50)
 
		local bulletDx = bulletSpeed * math.cos(angle)
		local bulletDy = bulletSpeed * math.sin(angle)
    
    local bulletTime = 3;
 
		table.insert(bullets, {x = startX, y = startY, dx = bulletDx, dy = bulletDy, t = bulletTime})
    
    player.ammo = body.ammo - 1;
    print(body.ammo,"ammo");
    return bullets,player
end

function worldupdate:update(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,world,BulletImg)
  map:update(dt)
  if math.abs(sx) > 0 then
    sx,sy = 0,0;
  end
  
  player.playerWalkTimer = player.playerWalkTimer + dt
  if player.playerWalkTimer > .5 then
    player:animate("walk");
    for i = 1, #enemies do
      enemies[i]:animate("walk");
    end
    playerWalkTimer = 0;
  end
for i = 1, #enemies do -- main interaction IG
    if enemies[i].alive == 1 then
      enemies[i]:decideMovement(player.x,player.y,dt);
      enemies[i]:shoot(player,world,dt)
      for o,v in ipairs(bullets) do
        if enemies[i]:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) or player:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          table.remove(bullets,i);
          math.randomseed(player.x);
          world:shakescreen(10);
          --print(sx,sy);
        end
      end
      
      
  end
  for i = 1, #triggers do -- main interaction for Triggers
    if triggers[i].id == "Test 1" then
      world:setChange("westham");
    end
    
      for o,v in ipairs(bullets) do
        if triggers[i]:isHit(v.x, v.y, player.x, player.y, window.x, window.y,BulletImg:getWidth(),BulletImg:getHeight()) then
          print("hit",v.x,v.y);
          table.remove(bullets,o);
          math.randomseed(player.x);
          world:shakescreen(10);
          --print(sx,sy);
        end
      end
  end
for i,v in ipairs(bullets) do --bullet script
    v.t = v.t-dt;
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
    if v.t < 0 then
      table.remove(bullets,i);
    end
    
	end
 for i=1, #dynamite do 
  
  end
  
for i=1, #dynamite do
    dynamite[i]:update(bullets,enemies,player,dynamite,BulletImg:getWidth(),BulletImg:getHeight(),dt);
  end
end
  if player.state == "FIRE" then
    player.rechargetimer = 0;
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

if not love.mouse.isDown(1) then
  player.state = "PLAY";
end
--print(player.state);
if player.state == "PLAY" and player.ammo < 10 then
    player.rechargetimer = player.rechargetimer + dt;
    if player.rechargetimer > player.rechargelimit then
        player.ammo = player.ammo+1;
        print(player.ammo,"ammorecharge", player.rechargetimer);
        player.rechargetimer = 0;
    end
  end
end

function worldupdate:draw(player, enemies, playerWalkTimer,dt,triggers,dynamite,map,world,BulletImg,crosshair, window)
  map:draw(window.x/2-player.x-sx-16,window.y/2-player.y-sy-16);
  --testmap:bump_draw(bumpWorld,window.x/2-player.x-sx-16,window.y/2-player.y-sy-16);
  love.graphics.draw(player.icon,player.frames[player.increment],window.x/2-16-sx,window.y/2-16-sy,0,zoom);
  
  for i = 1, #enemies do
    if enemies[i].alive == 1 then --if alive then
      love.graphics.draw(
        enemies[i].icon,
        enemies[i].frames[enemies[i].increment],
        enemies[i].x-16-player.x+window.x/2-sx,
        enemies[i].y-16-player.y+window.y/2-sy,
        0,
        zoom
        ); --draw enemies
  end
  for i = 1, #triggers do
    love.graphics.draw(
      triggers[i].imgs[bool_to_number(triggers[i].state) + 1],
      triggers[i].x-16-player.x+window.x/2-sx,
      triggers[i].y-16-player.y+window.y/2-sy,
      0,
      zoom
      );
  end
  
end

for i=1, #dynamite do
  if dynamite[i].intact == 1 then
    --love.graphics.rectangle("fill",dynamite[i].x-player.x+window.x/2-sx,dynamite[i].y-player.y+window.y/2-sy,32,32);
    love.graphics.draw(
      dynamite[i].sprite,
      dynamite[i].x-player.x+window.x/2-sx,
      dynamite[i].y-player.y+window.y/2-sy,
      0,
      zoom*2
    );
    love.graphics.draw(dynamite[i].explosionParticles, dynamite[i].x-player.x+window.x/2-sx, dynamite[i].y-player.y+window.y/2-sy,0,0,20,20)
  end
  
end


  for i,v in ipairs(bullets) do
		love.graphics.draw(BulletImg, v.x-player.x+window.x/2-sx, v.y-player.y+window.y/2-sy) --draw bullet
	end
  
  love.graphics.draw(crosshair, love.mouse.getX()-(crosshair:getWidth()/2), love.mouse.getY()-(crosshair:getHeight()/2))
end

return worldupdate