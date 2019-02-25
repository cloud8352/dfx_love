--功能：从NPK_IMG资源中创建精灵序列
--作者：cloud
--时间：2019.1.10

require("lib.engineadd.class")	--对象类
require("lib.engineadd.NPK")	--读取IMG资源相关
require("lib.engineadd.txtMethod")	--文本方法
require("lib.engineadd.CC_ColliderBox")	--创建碰撞盒

CC_SpriteIMG = class()

--入参：imgname-npk文件中img图像序列的名称-string型
--      npk_data- NPK.extract_npk(npkfile)提取到的npk数据信息
function CC_SpriteIMG:ctor( imgname, npk_data)
	
	--读取精灵包数据
  self.img = {}
  self.img = NPK.read_npk_img( imgname, npk_data) 	--读取精灵包数据

 	self.sn = 1
 	self.adress = ""
 	self.ox = 0
 	self.oy = 0
 	self.xflip = 1 	--x是否翻转

 	--self.frame = {}	--存放精灵序列相关数据 self.frame[n] = {帧序号 = self.sn,图片地址 = self.adress,中心偏移x = self.ox,中心偏移y = self.oy}

 	self.time = 0 	--动画播放时间
 	self.snSpeed = 7 	--帧率
 	self.x = 0
 	self.y = 0
 	self.xscale = 1
 	self.yscale = 1
 	self.rotation = 0 	--旋转度数
 	self.width = 0 	--精灵宽度
 	self.height = 0

 	--创建一个空包围盒
 	self.colliderbox = CC_ColliderBox.new(0, 0, 0, 0, 0, 0)

 end

--更新，随系统时间，播放到某一帧
function CC_SpriteIMG:Updata(dt, snSpeed, startsn, endsn, x, y, xscale, yscale, rotation)
 
  self.snSpeed = snSpeed
  
 
 	self.time = self.time + dt*self.snSpeed
 	self.sn = math.modf(self.time + startsn)

 	if(self.sn >= endsn + 1) then
 	--最后一帧播放完时，重置播放时间
 		self.time = 0
 		self.sn = startsn
 	end

	self.x = x
	self.y = y
 	self.xscale = xscale * self.xflip
 	self.yscale= yscale
  
  if rotation ~= nil then
    self.rotation = rotation
  end

 	self.ox = 233 - self.img[self.sn].key_x
 	self.oy = 330 - self.img[self.sn].key_y

 	self.width = self.img[self.sn].width
 	self.height = self.img[self.sn].height

 	--碰撞盒更新
	self.colliderbox:Updata(self.x, self.y, self.width, self.height, self.ox, self.oy, self.xscale, self.yscale)

 end


--坐标x，y；xy轴比例因子xscale, yscale；角度rotation（度）
--显示不对对象属性做修改，只输入画面偏移量，用于偏移显示
function CC_SpriteIMG:Show(offx, offy)
 	-- body
  love.graphics.setColor(255, 255, 255, 255)
 	love.graphics.draw( self.img[self.sn].img, self.x + offx, self.y + offy, math.rad(self.rotation), self.xscale, self.yscale,self.ox,self.oy)

 end

--设置x, y, xscale, yscale, rotation
 function CC_SpriteIMG:Set(x, y, xscale, yscale, rotation)
 	-- body
 	self.x = x
 	self.y = y
 	self.xscale = xscale * self.xflip
 	self.yscale = yscale
 	self.rotation = rotation
 end


--[[
--设置中心(dnf)
 function CC_SpriteIMG:SetOxy(sn, x, y)

  self.frame[sn][1] = x - self.frame[sn][1]
  self.frame[sn][2] = y - self.frame[sn][2]

 end
 ]]--


 function CC_SpriteIMG:Reset()
	
	self.sn = 1
	self.time = 0 	--动画播放时间
 end


--精灵序列销毁
 function CC_SpriteIMG:Destroy()

	for i=1,#self.img do
		self.img[i].img:release()
	end
 end

