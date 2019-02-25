require("lib.CC_engineadd")

require("lib.Kyo")
require("lib.Kyo_t")
require("lib.Yaoshi")
require "lib.NormalMap"
require "lib.LargeMap"
require "lib.Swordman"
require "lib.Q_control"


function love.load() --资源加载回调函数，仅初始化时调用一次
  --如果调试启动，就开启调试模式
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  loveframes = require("lib.loveframes")
  Q_control.init()
 
  
end



function love.update(dt) --更新回调函数，每周期调用
  Physics_Sys_Key()   --物理按键系统,在CC_engineadd中
  Q_control.update(dt)
  loveframes.update(dt)
  
end

--ScreenShowObj比较函数
--function (ScreenShowObja, ScreenShowObjb) return  ScreenShowObja.y < ScreenShowObjb.y  end



function love.draw() --绘图回调函数，每周期调用
  
  Q_control.draw()
  loveframes.draw()
end



function love.mousepressed(x, y, button)

  loveframes.mousepressed(x, y, button)
 
end
 
function love.mousereleased(x, y, button)

  loveframes.mousereleased(x, y, button)
 
end
 
function love.keypressed(key, unicode)

  loveframes.keypressed(key, unicode)
 
end
 
function love.keyreleased(key)
 
  loveframes.keyreleased(key)
 
end

