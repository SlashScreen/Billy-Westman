--gdjs.lua - test demo
local gdshader = require "modules/shader"
local utils = require('modules/utils')
gdqsworld= {};

function gdqsworld:load()
  local sti = require ("modules/sti");
  local bump = require ("modules/bump");
  map = sti("assets/maps/techdemomap.lua", {"bump"});
  currentmap = map;
  bumpWorld = bump.newWorld();
  bumptiles = map:bump_init(bumpWorld);
  print(love.getVersion());

  gdqsworld.changemapConditionsMet = 0;
  gdqsworld.go_to = "test"

  gradient = gdshader:constructGradient({["r"]=gdshader:toOneBase(255),["g"]=gdshader:toOneBase(255),["b"]=gdshader:toOneBase(255)},{["r"]=gdshader:toOneBase(0),["g"]=gdshader:toOneBase(0),["b"]=gdshader:toOneBase(0)})
  shader = gdshader:gradShader(gradient)

  player = require "modules/player_module";
  json = require "modules/json"
  wu = require("modules/worldupdate")

  bosses = {name = "east",x = 600, y=700,image = "east", class=eastman_boss, world = bumpWorld}

  player,BulletImg,triggers,enemies,dynamite,item,crosshair,zoom,sx,sy,window,bosses = wu:init(350,300,currentmap,bosses,bumpWorld)
  --utils:printTable(item)
end

function gdqsworld:shoot(body,x,y,coordspace)
  bullets, player = wu:shoot(body,x,y,coordspace,player,window,bullets)
end

function gdqsworld:shakescreen(val)
  if utils:round((math.random(-1,1))) < 0 then
    xdirection = -1
  else
    xdirection = 1
  end

  if utils:round((math.random(-1,1))) < 0 then
    ydirection = -1
  else
    ydirection = 1
  end

  ydirection = utils:round((math.random(-1,1)))
  print(xdirection,ydirection,"shaking screen")
  sx = val*xdirection;
  sy = val*ydirection;
end

function bool_to_number(value)
  return value and 1 or 0
end

function gdqsworld:update(dt)
  --SHAKESCREEN
--  print(sx,sy)
  if math.abs(sx) > 0 then
    print(sx,sy,"shake greater than 0")
    sx = -sx+dt/(2*sx)
    sy = -sy+dt/(2*sy) --tried to do some sort of wiggle thing
    if sx < .1 then
      sx,sy=0,0
    end
  end
  wu:update(player,BulletImg,triggers,enemies,dynamite,item,crosshair,zoom,sx,sy,window,bosses,map,gdqsworld,shader,dt)
end

function gdqsworld:draw()
  wu:draw(player,BulletImg,triggers,enemies,dynamite,item,crosshair,zoom,sx,sy,window,bosses,map,gdqsworld,shader)
end

function gdqsworld:canChange()
  if gdqsworld.changemapConditionsMet == 1 then
    return true, gdqsworld.go_to;
  else
    return false, gdqsworld.go_to
  end

end
function gdqsworld:setChange(gotomap)
  gdqsworld.changemapConditionsMet = 1
  gdqsworld.go_to = gotomap;
end

return gdqsworld
;
