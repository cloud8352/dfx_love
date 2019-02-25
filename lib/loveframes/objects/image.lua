--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".objects.image"))
local loveframes = require(path .. ".libraries.common")

-- image object
local newobject = loveframes.NewObject("image", "loveframes_object_image", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()

	self.type = "image"
	self.width = 0
	self.height = 0  
	self.orientation = 0
	self.scalex = 1
	self.scaley = 1
	self.offsetx = 0
	self.offsety = 0
	self.shearx = 0
	self.sheary = 0
	self.internal = false
	self.image = nil  --正常显示的图片
	self.imagecolor = {255, 255, 255, 255}
  
  self.hover = false
	self.down = false
	self.clickable = true
	self.enabled = true
  self.draw_width = 50  --图片显示尺寸
  self.draw_height = 50
	self.OnClick = nil
	
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function newobject:update(dt)

	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	self:CheckHover()
	
	local hover = self.hover
	local downobject = loveframes.downobject
	local down = self.down
	local parent = self.parent
	local base = loveframes.base
	local update = self.Update
	
	if not hover then
		self.down = false
	else
		if downobject == self then
			self.down = true
		end
	end
	
	if not down and downobject == self then
		self.hover = true
	end
  
	-- move to parent if there is a parent
	if parent ~= base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if update then
		update(self, dt)
	end
	
end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function newobject:draw()
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawImage or skins[defaultskin].DrawImage
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function newobject:mousepressed(x, y, button)

	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	
	if hover and button == 1 then
		local baseparent = self:GetBaseParent()
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		self.down = true
		loveframes.downobject = self
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function newobject:mousereleased(x, y, button)
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	local onclick = self.OnClick

	if hover and down and clickable and button == 1 then
		if enabled then
			if onclick then
				onclick(self, x, y)
			end
		end
	end
	
	self.down = false

end


--[[---------------------------------------------------------
	- func: SetImage(image)
	- desc: sets the object's image
--]]---------------------------------------------------------
function newobject:SetImage(image)

	if type(image) == "string" then
		self.image = love.graphics.newImage(image)
	else
		self.image = image
	end
	
	self.draw_width = self.image:getWidth()
	self.draw_height = self.image:getHeight()
	
	return self
	
end

--[[---------------------------------------------------------
	- func: GetImage()
	- desc: gets the object's image
--]]---------------------------------------------------------
function newobject:GetImage()

	return self.image
	
end

--[[---------------------------------------------------------
	- func: SetImgSize(width, height)
	- desc: Set image draw Size
--]]---------------------------------------------------------
function newobject:SetImgSize(width, height)
    
  self.draw_width = width
  self.draw_height = height
    
	return self
	
end

--[[---------------------------------------------------------
	- func: SetColor(r, g, b, a)
	- desc: sets the object's color 
--]]---------------------------------------------------------
function newobject:SetColor(r, g, b, a)

	self.imagecolor = {r, g, b, a}
	return self
	
end

--[[---------------------------------------------------------
	- func: GetColor()
	- desc: gets the object's color 
--]]---------------------------------------------------------
function newobject:GetColor()

	return unpack(self.imagecolor)
	
end

--[[---------------------------------------------------------
	- func: SetOrientation(orientation)
	- desc: sets the object's orientation
--]]---------------------------------------------------------
function newobject:SetOrientation(orientation)

	self.orientation = orientation
	return self
	
end

--[[---------------------------------------------------------
	- func: GetOrientation()
	- desc: gets the object's orientation
--]]---------------------------------------------------------
function newobject:GetOrientation()

	return self.orientation
	
end

--[[---------------------------------------------------------
	- func: SetScaleX(scalex)
	- desc: sets the object's x scale
--]]---------------------------------------------------------
function newobject:SetScaleX(scalex)

	self.scalex = scalex
  
  if self.image then
    self.width = scalex * self.image:getWidth()
  end
	return self
	
end

--[[---------------------------------------------------------
	- func: GetScaleX()
	- desc: gets the object's x scale
--]]---------------------------------------------------------
function newobject:GetScaleX()

	return self.scalex
	
end

--[[---------------------------------------------------------
	- func: SetScaleY(scaley)
	- desc: sets the object's y scale
--]]---------------------------------------------------------
function newobject:SetScaleY(scaley)

	self.scaley = scaley
 
  if self.image then
    self.height = scaley * self.image:getHeight()
  end
	return self
	
end

--[[---------------------------------------------------------
	- func: GetScaleY()
	- desc: gets the object's y scale
--]]---------------------------------------------------------
function newobject:GetScaleY()

	return self.scaley
	
end

--[[---------------------------------------------------------
	- func: SetScale(scalex, scaley)
	- desc: sets the object's x and y scale
--]]---------------------------------------------------------
function newobject:SetScale(scalex, scaley)

	self.scalex = scalex
	self.scaley = scaley
	
  if self.image then
    self.width = scalex * self.image:getWidth()
    self.height = scaley * self.image:getHeight()
  end
	return self
	
end

--[[---------------------------------------------------------
	- func: SetImgScale(scalex, scaley)
	- desc: sets the object's image x and y scale
--]]---------------------------------------------------------
function newobject:SetImgScale(scalex, scaley)

	
  if self.image then
    if scalex then
      self.draw_width = scalex * self.image:getWidth()
    end
    if scaley then
      self.draw_height = scaley * self.image:getHeight()
    end
  end
	return self
	
end

--[[---------------------------------------------------------
	- func: GetScale()
	- desc: gets the object's x and y scale
--]]---------------------------------------------------------
function newobject:GetScale()

	return self.scalex, self.scaley
	
end

--[[---------------------------------------------------------
	- func: SetOffsetX(x)
	- desc: sets the object's x offset
--]]---------------------------------------------------------
function newobject:SetOffsetX(x)

	self.offsetx = x
	return self
	
end

--[[---------------------------------------------------------
	- func: GetOffsetX()
	- desc: gets the object's x offset
--]]---------------------------------------------------------
function newobject:GetOffsetX()

	return self.offsetx
	
end

--[[---------------------------------------------------------
	- func: SetOffsetY(y)
	- desc: sets the object's y offset
--]]---------------------------------------------------------
function newobject:SetOffsetY(y)

	self.offsety = y
	return self
	
end

--[[---------------------------------------------------------
	- func: GetOffsetY()
	- desc: gets the object's y offset
--]]---------------------------------------------------------
function newobject:GetOffsetY()

	return self.offsety
	
end

--[[---------------------------------------------------------
	- func: SetOffset(x, y)
	- desc: sets the object's x and y offset
--]]---------------------------------------------------------
function newobject:SetOffset(x, y)

	self.offsetx = x
	self.offsety = y
	
	return self
	
end

--[[---------------------------------------------------------
	- func: GetOffset()
	- desc: gets the object's x and y offset
--]]---------------------------------------------------------
function newobject:GetOffset()

	return self.offsetx, self.offsety
	
end

--[[---------------------------------------------------------
	- func: SetShearX(shearx)
	- desc: sets the object's x shear
--]]---------------------------------------------------------
function newobject:SetShearX(shearx)

	self.shearx = shearx
	return self
	
end

--[[---------------------------------------------------------
	- func: GetShearX()
	- desc: gets the object's x shear
--]]---------------------------------------------------------
function newobject:GetShearX()

	return self.shearx
	
end

--[[---------------------------------------------------------
	- func: SetShearY(sheary)
	- desc: sets the object's y shear
--]]---------------------------------------------------------
function newobject:SetShearY(sheary)

	self.sheary = sheary
	return self
	
end

--[[---------------------------------------------------------
	- func: GetShearY()
	- desc: gets the object's y shear
--]]---------------------------------------------------------
function newobject:GetShearY()

	return self.sheary
	
end

--[[---------------------------------------------------------
	- func: SetShear(shearx, sheary)
	- desc: sets the object's x and y shear
--]]---------------------------------------------------------
function newobject:SetShear(shearx, sheary)

	self.shearx = shearx
	self.sheary = sheary
	
	return self
	
end

--[[---------------------------------------------------------
	- func: GetShear()
	- desc: gets the object's x and y shear
--]]---------------------------------------------------------
function newobject:GetShear()

	return self.shearx, self.sheary
	
end

--[[---------------------------------------------------------
	- func: GetImageSize()
	- desc: gets the size of the object's image
--]]---------------------------------------------------------
function newobject:GetImageSize()

	local image = self.image
	
	if image then
		return image:getWidth(), image:getHeight()
	end
	
end

--[[---------------------------------------------------------
	- func: GetImageWidth()
	- desc: gets the width of the object's image
--]]---------------------------------------------------------
function newobject:GetImageWidth()

	local image = self.image
	
	if image then
		return image:getWidth()
	end
	
end

--[[---------------------------------------------------------
	- func: GetImageWidth()
	- desc: gets the height of the object's image
--]]---------------------------------------------------------
function newobject:GetImageHeight()

	local image = self.image
	
	if image then
		return image:getHeight()
	end
	
end
