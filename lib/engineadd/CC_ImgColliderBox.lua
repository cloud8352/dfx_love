-- @Author: 稻香
-- @Date:   2018-11-12 11:55:53
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-11-12 13:14:13
CC_ImgColliderBox = class()

function CC_ImgColliderBox:ctor(img)
 	--self.x = img.x
 	--self.y = img:refresh().y
 	self.width = img:refresh().width
	self.height = img:refresh().height

 end 