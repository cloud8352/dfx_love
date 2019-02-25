-- @Author: 稻香
-- @Date:   2018-11-12 12:15:42
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-11-21 21:05:46
CC_Sprite = class()

function CC_Sprite:ctor(img, x, y, xscale, yscale)

	self.screenoff = {x = 0, y = 0} 	--屏幕偏移
	self.img = img
    self.x = x
	self.y = y
 	self.xscale = xscale
 	self.yscale = yscale
 	self.rotation = 0
	self.ox = 0 --中心
	self.oy = 0

 	self.width = self.img:getWidth()
 	self.height = self.img:getHeight()
	
	--创建一个空包围盒
 	self.colliderbox = CC_ColliderBox.new(0, 0, 0, 0, 0, 0)
 end


--输入画面偏移
function CC_Sprite:Show( offx, offy)
	
	love.graphics.draw( self.img, self.x + offx, self.y + offy, math.rad(self.rotation), self.xscale, self.yscale,self.ox,self.oy)
    --碰撞盒更新
	self.colliderbox:Updata(self.x, self.y, self.width, self.height, self.ox, self.oy, self.xscale, self.yscale)
 end

--半透明显示
--输入画面偏移
function CC_Sprite:AlphaShow( alpha, offx, offy)
	love.graphics.setColor(255, 255, 255, alpha)
	love.graphics.draw( self.img, self.x + offx, self.y + offy, math.rad(self.rotation), self.xscale, self.yscale,self.ox,self.oy)
    love.graphics.setColor(255, 255, 255, 255)
    --碰撞盒更新
	self.colliderbox:Updata(self.x, self.y, self.width, self.height, self.ox, self.oy, self.xscale, self.yscale)
 end


function CC_Sprite:SetOrigin(ox, oy)
	
	self.ox = ox --中心
	self.oy = oy
 end
