-- @Author: 稻香
-- @Date:   2018-11-11 10:42:20
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-11-20 21:54:00

CC_ColliderBox = class()


function CC_ColliderBox:ctor(x, y, width, height, ox, oy)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	--self.rotation = 0 	--旋转度数
 	self.xscale = 1
 	self.yscale = 1

 	self.ox = ox or 0
 	self.oy = oy or 0

 	--根据偏差计算包围盒xy顶点
 	self.xtop = self.x - self.ox
 	self.ytop = self.y - self.oy

 	--创建形状信息
 	--self.shape = love.physics.newRectangleShape( self.width, self.height )


end


function CC_ColliderBox:Updata(x, y, width, height, ox, oy,  xscale, yscale)
	self.x = x or self.x
	self.y = y or self.x
  
	self.width = width or self.width
	self.height = height or self.height

 	self.ox = ox or self.ox
 	self.oy = oy or self.oy
 	self.xscale = xscale or self.xscale
 	self.yscale= yscale or self.yscale

 	--根据偏差计算包围盒xy顶点
 	if self.xscale > 0 then
	 	self.xtop = self.x - self.ox
	 	self.ytop = self.y - self.oy
 	elseif self.xscale < 0 then
	 	self.xtop = self.x - (self.width -self.ox)
	 	self.ytop = self.y - self.oy
 	end

end

--颜色，画面偏移
function CC_ColliderBox:Show(color, offx, offy)

	love.graphics.setColor( color, 1 )
	love.graphics.rectangle( "line", self.xtop + offx, self.ytop + offy, self.width, self.height )
	love.graphics.setColor( 255, 255, 255, 1 )

end


function CC_ColliderBox:CheckPoint(otherx, othery)
	--如果点在包围盒中返回true
	if otherx >= self.xtop and otherx <= self.xtop + self.width
		and othery >= self.ytop and othery <= self.ytop + self.height
		then

		return true
	else
	    return false
	end

end

function CC_ColliderBox:CheckBox(colliderbox)

	--如果与其他包围盒碰撞，返回true
	if self.xtop <= colliderbox.xtop then
		if self.ytop <= colliderbox.ytop then
			if math.abs(colliderbox.xtop - self.xtop) <= self.width
				and math.abs(colliderbox.ytop - self.ytop) <= self.height
				then
				return true
			else 
				return false
			end
		elseif self.ytop > colliderbox.ytop then
			if math.abs(colliderbox.xtop - self.xtop) <= self.width
				and math.abs(colliderbox.ytop - self.ytop) <= colliderbox.height
				then
				return true
			else 
				return false
			end	
		end

	elseif self.xtop > colliderbox.xtop then
		if self.ytop <= colliderbox.ytop then
			if math.abs(colliderbox.xtop - self.xtop) <= colliderbox.width
				and math.abs(colliderbox.ytop - self.ytop) <= self.height
				then
				return true
			else 
				return false
			end
		elseif self.ytop > colliderbox.ytop then
			if math.abs(colliderbox.xtop - self.xtop) <= colliderbox.width
				and math.abs(colliderbox.ytop - self.ytop) <= colliderbox.height
				then
				return true
			else 
				return false
			end	
		end

	end

end
