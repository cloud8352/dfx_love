-- @Author: 稻香
-- @Date:   2018-12-02 22:27:52
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-12-05 20:12:45
require "lib.NormalMap"

LargeMap = class()

function LargeMap:ctor()
	self.m = 0 --m行小房间
	self.n = 0 --n列小房间
	self.width = 0
	self.height = 0
	self.MapName = ""

	self.LargeMapData = {}

end

function LargeMap:Updata()
	for i=1,table.getn(self.LargeMapData) do
		self.LargeMapData[i].map:Updata()
	end

end

function LargeMap:Show(offx,offy)

	for i=1,table.getn(self.LargeMapData) do
		if self.LargeMapData[i].showing == true then
			self.LargeMapData[i].map:Show(offx,offy)
		end
		self.LargeMapData[i].showing = false
	end

end

function LargeMap:Load(LargeMapAdr)

	--self:WipeMapData() 	--每次加载前，清理之前的数据

	self.MapName = LargeMapAdr

	--判断文件是否存在
	--if love.filesystem.exists( mapfile ) == false then
		--print("Not find mapfile")
	--end

	local str = love.filesystem.read( LargeMapAdr, all )

	local  div1 = txtMethod:cutby( str, "*") 

	local  div1_num = table.getn(div1)

	if div1_num > 0 then
		self:ReadMapInf(div1[1])	--读取大地图基本信息，

	end

	--如果房间数正确，读取房间布置信息
	if div1_num == self.m*self.n + 1 then
		for i=2,self.m*self.n + 1 do
			--从第二个单元开始读取房间信息
			print("LargeMap load data:",i-1)

			self.LargeMapData[i-1] = {}

			self:ReadMapArrangeData(self.LargeMapData[i-1], div1[i])
			print("upto",self.LargeMapData[i-1].upto)

			self.LargeMapData[i-1].showing = false 	--定义一个是否显示的布尔量(角色在此小地图，就显示)

			self.LargeMapData[i-1].map = NormalMap.new()

			self.LargeMapData[i-1].map:Load(self.LargeMapData[i-1].mapadr) 	--载入小地图尺寸
			self.LargeMapData[i-1].map.x = self.LargeMapData[i-1].map.MapWidth*( (i-1 -1) % self.n)
			self.LargeMapData[i-1].map.y = self.LargeMapData[i-1].map.MapHeight*math.modf( (i-1 -1) / self.n )
			print("map. x,y",self.LargeMapData[i-1].map.x,self.LargeMapData[i-1].map.y)

			self.LargeMapData[i-1].map:Load(self.LargeMapData[i-1].mapadr) 	--载入小地图
		end

	end

	self.width = self.LargeMapData[1].map.MapWidth*self.n
	self.height = self.LargeMapData[1].map.MapHeight*self.m
	print(self.width,self.height)
	print("LargeMap load end",#self.LargeMapData)

end


function LargeMap:ReadMapInf(StrData)	--读取大地图基本信息,行列数
	local  div1 = txtMethod:cutby( StrData, ",")
	self.m = tonumber(div1[1])
	self.n = tonumber(div1[2])
end


function LargeMap:ReadMapArrangeData(LargeMapData, StrData)
	--LargeMapData = {}

	print("LargeMap loading")
	local  div1 = txtMethod:cutby( StrData, "|")

	LargeMapData.mapadr = div1[1] 	--保存第一单元的小地图地址

	local  div2 = txtMethod:cutby( div1[2], ",")
	LargeMapData.upto = tonumber( (div2[1] - 1)*self.n + div2[2])

	div2 = txtMethod:cutby( div1[3], ",")
	LargeMapData.downto = tonumber( (div2[1] - 1)*self.n + div2[2])

	div2 = txtMethod:cutby( div1[4], ",")
	LargeMapData.leftto = tonumber( (div2[1] - 1)*self.n + div2[2])

	div2 = txtMethod:cutby( div1[5], ",")
	LargeMapData.rightto = tonumber( (div2[1] - 1)*self.n + div2[2])

end