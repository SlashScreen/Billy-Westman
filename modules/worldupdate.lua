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
      mouseX = body.x + x
      mouseY = body.y + y 
    end
    
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

return worldupdate