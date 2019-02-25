-- @Author: 稻香
-- @Date:   2018-11-12 22:16:38
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-12-21 14:49:27
require("lib.engineadd.class")	--对象类
require("lib.engineadd.txtMethod")	--文本方法
require("lib.engineadd.CC_Sprite")	--精灵
require("lib.engineadd.CC_ColliderBox")	--创建碰撞盒

CC_SpriteFrame = class()


--SpritePak为精灵包路径-string型
function CC_SpriteFrame:ctor(SpritePak)
 	self.SpritePak = SpritePak
 	self.sn = 1
 	self.adress = ""
 	self.ox = 0
 	self.oy = 0
 	self.xflip = 1 	--x是否翻转

 	self.frame = {}	--存放精灵序列相关数据 self.frame[n] = {帧序号 = self.sn,图片地址 = self.adress,中心偏移x = self.ox,中心偏移y = self.oy}

 	self.img = {}
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

	--读取精灵包数据
	--读取的数据：1帧序号,2图片地址,3中心偏移x,4中心偏移y
	local str = love.filesystem.read( self.SpritePak, all )

	--第一次分割
	local div1 = {}
	div1 = txtMethod:cutby(str,"\n")

	--第二次
	for i=1,#div1 do

		self.frame[i] = txtMethod:cutby(div1[i],",")
	end	

	---将精灵图像按帧序号存入一个table中
	----取精灵序列self.frame中第i帧的第2个元素--图片地址,创建img
	for i=1,#self.frame do
		self.img[i] =  love.graphics.newImage(self.frame[i][2] )
	end

 end

--更新，随系统时间，播放到某一帧
function CC_SpriteFrame:Updata(dt, x, y, xscale, yscale, rotation)
 	-- body
 	self.time = self.time + dt*self.snSpeed
 	self.sn = math.modf( self.time % #self.frame + 1)

 	if(self.sn == #self.frame + 1) then
 	--最后一帧播放完时，重置播放时间
 		self.time = 0
 		self.sn = 1
 	end

	self.x = x
	self.y = y
 	self.xscale = xscale * self.xflip
 	self.yscale= yscale
 	self.rotation = rotation

 	self.ox = self.frame[self.sn][3]
 	self.oy = self.frame[self.sn][4]

 	self.width = self.img[self.sn]:getWidth()
 	self.height = self.img[self.sn]:getHeight()

 	--碰撞盒更新
	self.colliderbox:Updata(self.x, self.y, self.width, self.height, self.ox, self.oy, self.xscale, self.yscale)

 end


--坐标x，y；xy轴比例因子xscale, yscale；角度rotation（度）
--显示不对对象属性做修改，只输入画面偏移量，用于偏移显示
function CC_SpriteFrame:Show(offx, offy)
 	-- body
 	--self.x = x
 	--self.y = y
 	--self.xscale = xscale
 	--self.yscale = yscale
  love.graphics.setColor(255, 255, 255, 255)
 	love.graphics.draw( self.img[self.sn], self.x + offx, self.y + offy, math.rad(self.rotation), self.xscale, self.yscale,self.ox,self.oy)

 end

--设置x, y, xscale, yscale, rotation
 function CC_SpriteFrame:Set(x, y, xscale, yscale, rotation)
 	-- body
 	self.x = x
 	self.y = y
 	self.xscale = xscale * self.xflip
 	self.yscale = yscale
 	self.rotation = rotation
 end


 function CC_SpriteFrame:Reset()
	
	self.sn = 1
	self.time = 0 	--动画播放时间
 end


--精灵序列销毁
 function CC_SpriteFrame:Destroy()

	for i=1,#self.frame do
		self.img[i]:release()
	end
 end

