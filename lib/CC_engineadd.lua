require("lib.engineadd.class")	--对象类
require("lib.engineadd.Color")	--颜色集合
require("lib.engineadd.ColorMain")	--颜色集合

require("lib.engineadd.CC_ColliderBox")	--创建碰撞盒
require("lib.engineadd.CC_ImgColliderBox")	--创建图片碰撞盒
require("lib.engineadd.CC_Sprite")	--精灵
require("lib.engineadd.txtMethod")	--文本方法
require("lib.engineadd.NPK")	--读取NPK资源相关
require("lib.engineadd.CC_SpriteFrame")	--精灵序列
require("lib.engineadd.CC_SpritePak")	--精灵包
require("lib.engineadd.CC_SpriteIMG")	--从NPK_IMG资源中创建精灵序列

require("lib.engineadd.ShortestPath")



Key = {} 	--须要使用键字符
KeyLastTime = {} --键上次按下的时间
Inf_KeyEvent = {} --按键事件信息(是否发生)
Inf_Key = {} --按键信息(是否发生)

--====Key加入须要使用键字符======
--"a"-"z"和标点符号的字母按键字符
for i=33,64 do
	table.insert(Key, string.char(i)) --将Ascii码转成字符，并存入键字符table
end
for i=91,122 do
	table.insert(Key, string.char(i)) --将Ascii码转成字符，并存入键字符table
end

--"f1" - "f12"
for i=1,12 do
	table.insert(Key, "f"..i)
end

--up\down\left\right
table.insert(Key,"up")
table.insert(Key,"down")
table.insert(Key,"left")
table.insert(Key,"right")


--=====为每个键设定初始上次按下的时间====
for i=1,#Key do
	KeyLastTime[Key[i]] = 0
end



--初始按键事件检测函数，在物理按键系统调用
function GetKeyPressEvent0(key)
	local ret
	if love.keyboard.isDown(key) then
		--if love.timer.getTime() - KeyLastTime[key] < 0.05 then
			ret = true
		--end

		--KeyLastTime[key] = love.timer.getTime()
	else
	    ret = false
	end
	return ret
end

--初始按键检测函数，在物理按键系统调用
function GetKeyPress0(key)
	local ret
	if love.keyboard.isDown(key) then

		if love.timer.getTime() - KeyLastTime[key] < 0.05 then
			ret = false
		end
		if love.timer.getTime() - KeyLastTime[key] > 0.05 then
			ret = true
		end

		KeyLastTime[key] = love.timer.getTime()
	else
	    ret = false
	end
	return ret

end

--物理按键系统
function Physics_Sys_Key()

    for i=1,#Key do
        Inf_KeyEvent[Key[i]] = GetKeyPressEvent0(Key[i])
        Inf_Key[Key[i]] = GetKeyPress0(Key[i])
    end
end

--按键事件检测函数
function GetKeyPressEvent(key)
	return Inf_KeyEvent[key]
end

--按键检测函数
function GetKeyPress(key)
	return Inf_Key[key]
end


--获取屏幕偏移
function GetScreenOffset(Followx, Followy, MapWidth, MapHeight,MapOffsetx,MapOffsety)
	local width =  love.graphics.getWidth()
    local height =  love.graphics.getHeight()
    
	local offset = {x = width/2 - Followx, y = height/2 - Followy}
    if Followx <= width/2 - MapOffsetx then 
    	offset.x = width/2 - width/2 + MapOffsetx
    elseif Followx >= MapWidth - width/2 - MapOffsetx then
    	offset.x = width/2 - (MapWidth - width/2 - MapOffsetx)
    end
    if Followy <= height/2 - MapOffsety then
    	offset.y = height/2 - height/2 + MapOffsety
    elseif Followy >= MapHeight - height/2 - MapOffsety then
    	offset.y = height/2 - (MapHeight - height/2 - MapOffsety)
    end

    return offset
end


--返回碰撞时，碰撞盒2哪个边与碰撞盒1接触
function ReturnCollidedLine(colbox1,colbox2)
  --colbox1右边碰到碰撞盒==colbox2左边碰到碰撞盒
  if colbox1.xtop + colbox1.width -1 <= colbox2.xtop then
    return "left"
  end
  --colbox1左边碰到碰撞盒==colbox2右边碰到碰撞盒
  if colbox1.xtop +1 >= colbox2.xtop + colbox2.width then
    return "right"
  end
  --colbox1下边碰到碰撞盒==colbox2上边碰到碰撞盒
  if colbox1.ytop + colbox1.height -1 <= colbox2.ytop then
    return "up"
  end
  --colbox1上边碰到碰撞盒==colbox2下边碰到碰撞盒
  if colbox1.ytop +1 >= colbox2.ytop + colbox2.height then
    return "down"
  end
  
end

--表复制
function table_copy(ori_tab)
    if (type(ori_tab) ~= "table") then
        return nil
    end
    local new_tab = {}
    for i,v in pairs(ori_tab) do
        local vtyp = type(v)
        if (vtyp == "table") then
            new_tab[i] = table_copy(v)
        elseif (vtyp == "thread") then
            new_tab[i] = v
        elseif (vtyp == "userdata") then
            new_tab[i] = v
        else
            new_tab[i] = v
        end
    end
    return new_tab
end
