--mainmenu.lua
mainmenu = {}
bclass = require "modules/buttonclass"
utils = require "modules/utils"
main = require ("main");

function mainmenu:load()
  self.buttons = {}
  bg = love.graphics.newImage("assets/textbox.png")
  newobj = utils:makeObj(bclass) --make the object
  newobj:init(100,100,75,50,"play",love.graphics.newImage("assets/textbox.png"),"play") --init the object
  --utils:printTable(newobj)
  self.buttons[#self.buttons+1] = newobj--bclass:init(100,100,75,50,"play",bg,"play");
  love.mouse.setVisible(true);
end

function mainmenu:update()
  function love.mousepressed(x, y, button)
    if button == 1 then
      for n,b in pairs(self.buttons) do
        --print(n,b)
        if b:clicked(x,y) then
          --do event
          ev = b:getEvent()
          if ev == "play" then
            main:changeLevel("westham")
          end
        end
      end
    end
  end
end

function mainmenu:draw()
  for n,b in pairs(self.buttons) do
    --utils:printTable(b)
    b:draw()
  end
end
return mainmenu
