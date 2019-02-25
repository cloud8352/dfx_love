-- @Author: 稻香
-- @Date:   2018-11-16 21:41:54
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-12-21 19:52:26
NormalMap = class()

function NormalMap:ctor()
	self.debug = Q_debug
	self.MapName = ""
	self.MapType = "SafePlace"	--"	Battlefield"
	self.ShowWidth = 0 	--地图显示尺寸
	self.ShowHeight = 0
	self.MapWidth = 0 	--实际地图尺寸(可移动区域)
	self.MapHeight = 0
	self.x = 0 	--地图的位置
	self.y = 0


	self.CharPos = {x = 0, y = 0}
	self.CharCollider = {}
	self.MapOffset = {x = 0, y = 0}
	self.ScreenOffset = {x = 0, y = 0}


	self.MapData_1layer = {}
	self.MapData_2layer = {}
	self.MapData_3layer = {}
	self.MapData_thing = {}
	self.MapData_collider = {}

	self.MapData_Toplayer = {}


end


function NormalMap:Updata()
	self.debug = Q_debug



end


function NormalMap:Show(offx,offy)
	for i=1,table.getn(self.MapData_3layer) do
		self.MapData_3layer[i].sprite:Show(offx + (offx + self.x)*0.15,offy)
	end

	for i=1,table.getn(self.MapData_2layer) do
		self.MapData_2layer[i].sprite:Show(offx + (offx + self.x)*0.05,offy)
	end

	for i=1,table.getn(self.MapData_1layer) do
		self.MapData_1layer[i].sprite:Show(offx,offy)
	end

	for i=1,table.getn(self.MapData_thing) do
		if self.MapData_thing[i].TopShow == false then
			self.MapData_thing[i].sprite:Show(offx,offy)
			--self.MapData_thing[i].sprite:AlphaShow( 0.7, offx, offy)
		end
	
		if self.debug then
			love.graphics.circle("fill", self.MapData_thing[i].sprite.x + offx, self.MapData_thing[i].sprite.y + offy, 2, 5)--用100段画白色圆
			self.MapData_thing[i].sprite.colliderbox:Show(red,offx,offy)
		end
	end

	if self.debug then
		for i=1,table.getn(self.MapData_collider) do
			self.MapData_collider[i].colliderbox:Show(blue, offx, offy)
		end

	end


end


--顶层显示
function NormalMap:TopShow(offx,offy)

	for i=1,table.getn(self.MapData_thing) do
		if self.MapData_thing[i].TopShow == true then
			self.MapData_thing[i].sprite:AlphaShow( 0.5, offx, offy)
		end
	end

end


function NormalMap:Load(MapName)
	self:WipeMapData() 	--每次加载前，清理之前的数据

	self.MapName = MapName

	print("data/map/"..MapName..".inf")
	--读取小地图偏移,尺寸 信息
	local infstr = love.filesystem.read( "data/map/"..MapName..".inf", all )
	local  infdiv1 = txtMethod:cutby( infstr, "|") 	--

	local  infdiv2 = txtMethod:cutby( infdiv1[1], ",")

	self.MapOffset = {x = tonumber(infdiv2[1]), y = tonumber(infdiv2[2])}
	print(self.MapOffset.x,self.MapOffset.y)

	infdiv2 = txtMethod:cutby( infdiv1[2], ",")
	self.MapWidth = tonumber(infdiv2[1])
	self.MapHeight = tonumber(infdiv2[2])


	--读取小地图数据
	local mapfile = "data/map/"..MapName..".emhmap"

	print(mapfile)
	--判断文件是否存在
	--if love.filesystem.exists( mapfile ) == false then
		--print("Not find mapfile")
	--end

	if(MapName == "赛丽亚的旅馆" or MapName == "艾尔文防线" or MapName == "阿法利亚营地入口" or MapName == "洛兰入口")then
		self.MapType = "SafePlace"
	else
		self.MapType  = "Battlefield"
	end

	local str = love.filesystem.read( mapfile, all )

	local  div1 = txtMethod:cutby( str, "*") 

	local  div1_num = table.getn(div1)

	if div1_num > 0 then
		self:ReadMapInf(div1[1])	--读取地图基本信息，
		print(1)
	end
	if div1_num > 1 then
		self:ReadMapLayerData(self.MapData_3layer, div1[2])
		print(self.MapData_3layer[1].x)
		print(2)
	end
	if div1_num > 2 then
		self:ReadMapLayerData(self.MapData_2layer, div1[3])
		--print(div1[3])
		print(3)
	end
	if div1_num > 3 then
		self:ReadMapLayerData(self.MapData_1layer, div1[4])
		--print(div1[4])
		print(4)
	end
	if div1_num > 4 then
		self:ReadMapThingData(self.MapData_thing,div1[5])
		--print(div1[5])
		print(5)
	end
	if div1_num > 5 then
		self:ReadMapLayerData(self.MapData_Toplayer, div1[6])
		--print(div1[6])
		print(6)
	end
	if div1_num > 6 then
		self:ReadMapColliderData(self.MapData_collider, div1[7])
		print("coll_n"..#self.MapData_collider)
		--print(div1[7])
		print(7)
	end

	print("load end")

end


--读取地图基本信息，
function NormalMap:ReadMapInf(StrData)
	local str = txtMethod:cutby(StrData,"|")
	if table.getn(str) == 1 then
		local div1 = txtMethod:cutby(str[1], ",")

		if table.getn(div1) == 2 then
			self.ShowWidth = div1[1]
			self.ShowHeight = div1[2]
		end

	end	
end


--读地图基础层数据
--MapData,为table型；StrData，入参，字符串型
function NormalMap:ReadMapLayerData(MapData, StrData)
	local str = txtMethod:cutby(StrData,"|")

	--遍历该层所有数据
	for i = 1,table.getn(str) do
		local div1 = txtMethod:cutby(str[i], ",")

		if table.getn(div1) == 4 then

			MapData[i] = {
				x = tonumber(div1[1]) + self.x - self.MapOffset.x,
				y = tonumber(div1[2]) + self.y - self.MapOffset.y,
				ImgAddress = div1[3],
				xscale = tonumber(div1[4]),
			}
		
			--如果图片地址不为空，创建图片精灵
			if div1[3] ~= "" then
				--不能识别"\"目录分隔符，将图片地址中"\"改成"/"
				MapData[i].ImgAddress = txtMethod:replace(MapData[i].ImgAddress, "\\", "/")

				local img = love.graphics.newImage(MapData[i].ImgAddress)
				MapData[i].sprite = CC_Sprite.new(img, MapData[i].x, MapData[i].y, MapData[i].xscale, 1)
				--置图片中心
				MapData[i].sprite:SetOrigin(MapData[i].sprite.width/2, MapData[i].sprite.height/2)
			end	
		end

	end		
end

--读地图物件数据
function NormalMap:ReadMapThingData(MapData, StrData)
	local str = txtMethod:cutby(StrData,"|")

	--遍历该层所有数据
	for i = 1,table.getn(str) do
		local div1 = txtMethod:cutby(str[i], ",")

		if table.getn(div1) == 6 then
			MapData[i] = {
				x = tonumber(div1[1]) + self.x - self.MapOffset.x,
				y = tonumber(div1[2]) + self.y - self.MapOffset.y,
				ImgAddress = div1[3],
				xscale = tonumber(div1[4]),
				ox = tonumber(div1[5]),
				oy = tonumber(div1[6]),
				TopShow = false
			}
			--原始数据xy是图片的中间位置，实际精灵的基准中心位置为：
			MapData[i].x = MapData[i].x + MapData[i].ox
			MapData[i].y = MapData[i].y + MapData[i].oy
		
			--如果图片地址不为空，创建图片精灵
			if div1[3] ~= "" then
				--不能识别"\"目录分隔符，将图片地址中"\"改成"/"
				MapData[i].ImgAddress = txtMethod:replace(MapData[i].ImgAddress, "\\", "/")

				local img = love.graphics.newImage(MapData[i].ImgAddress)
				MapData[i].sprite = CC_Sprite.new(img, MapData[i].x, MapData[i].y, MapData[i].xscale, 1)
				--置图片中心
				MapData[i].sprite:SetOrigin(MapData[i].sprite.width/2 + MapData[i].ox, MapData[i].sprite.height/2 + MapData[i].oy)
				--MapData[i].sprite:SetOrigin(MapData[i].ox, MapData[i].sprite.height/2)

			end	
		end

	end	
end


--读地图碰撞盒数据
function NormalMap:ReadMapColliderData(MapData, StrData)
	local str = txtMethod:cutby(StrData,"|")

	--遍历该层所有数据
	for i = 1,table.getn(str) do
		local div1 = txtMethod:cutby(str[i], ",")

		if table.getn(div1) == 4 then
			MapData[i] = {
				xtop = tonumber(div1[1]) + self.x - self.MapOffset.x,
				ytop = tonumber(div1[2]) + self.y - self.MapOffset.y,
				w = tonumber(div1[3]),
				h = tonumber(div1[4]),
			}
			MapData[i].colliderbox = CC_ColliderBox.new(MapData[i].xtop, MapData[i].ytop, MapData[i].w, MapData[i].h,0,0)

		end
	end	

end


--每次加载前，清理之前的数据
function NormalMap:WipeMapData() 
	
end