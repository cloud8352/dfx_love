--功能：读取NPK资源相关
--作者：cloud
--修改时间：2019.1.19
--修改内容：NPK.extract_npk()中清空 NPK_Header.count
--          优化NPK.read_npk_img( imgname, npk_data) 函数，增加ARGB4444和ARGB1555贴图的处理办法
--4.0

require("lib.engineadd.txtMethod")	--文本方法

NPK = {}

--=====NPK包格式============
local NPK_Header = 
{
    flag = "NeoplePack_Bill".."\0",  --[16] 文件标识 "NeoplePack_Bill"
    count = 0          --[4] 包内img文件的数目
}
 
local NPK_Index =
{
    offset = 0,    --[4] 文件的包内偏移量
    size = 0,    --[4] 文件的大小
    name = ""   --[256] 文件名
}
 
local decord_flag = "puchikon@neople dungeon and fighter DNF"  --[256]
--构造解密文件名用的decord_flag
local len = string.len(decord_flag) --39
--print(len)
for i = len + 1,255 do
  if (i - len) % 3 == 1 then 
    decord_flag = decord_flag..'D'
  elseif (i - len) % 3 == 2 then
    decord_flag = decord_flag..'N'
  elseif (i - len) % 3 == 0 then
    decord_flag = decord_flag..'F'
  end
    
  if i == 255 then
    decord_flag = decord_flag.."\0"
  end
end


--=========img文件格式==============
local NImgF_Header =  --占32个字节
{
	flag = "Neople Img File".."\0",  --[16]; // 文件标石"Neople Img File".."\0"
	index_size=0, --;	//[4] 索引表大小，以字节为单位
	unknown1=0,     --[4] 保留，4字节，为0
	version=2,      --[4] 版本号，IMGV2文件结构中的版本号为2。
	index_count=0,  --;//[4] 索引表数目
}
 
local NImgF_Index = {}
NImgF_Index.dwType = 0  --目前已知的类型有 0x0E(1555格式) 0x0F(4444格式) 0x10(8888格式) 0x11(指向型)
NImgF_Index.dwCompress = 0 -- 目前已知的类型有 0x06(zlib压缩) 0x05(未压缩)
NImgF_Index.width = 0        -- 宽度
NImgF_Index.height = 0       -- 高度
NImgF_Index.size = 0        -- 压缩时size为压缩后大小，未压缩时size为转换成8888格式时占用的内存大小
NImgF_Index.key_x = 0        -- X关键点，当前图片在整图中的X坐标
NImgF_Index.key_y = 0        -- Y关键点，当前图片在整图中的Y坐标
NImgF_Index.max_width = 0    -- 整图的宽度
NImgF_Index.max_height = 0   -- 整图的高度，有此数据是为了对齐精灵


local data_string = "" --读取的数据字符

--提取npk，
--入参：npk文件地址，string
--返回：table型：npk_data = {imgfile1 = {}, imgfile2 = {}, ...}；imgfile1 = {offset= 0, size =0}
function NPK.extract_npk(npkfile)
  local npk_data = {} --存放提取的npk信息-各img文件的offs和size
  
  --2018.1.19添加--清空 NPK_Header.count
  NPK_Header.count = 0
  
  --读取npk
  data_string = love.filesystem.read( npkfile, all )
  if NPK_Header.flag == string.sub(data_string, 1, 16) then
    --读取img文件个数：16-20byte
    for i=1,4 do
      local count = string.sub(data_string, 16+i, 16+i)
      NPK_Header.count = NPK_Header.count + string.byte(count)*(2^8)^(i-1)
    end
    print("NPK_Header.count",NPK_Header.count)-----------------------
    
    --提取npk中img数据信息，各img的偏移地址，大小，名称
    extract_npk_img(npkfile, npk_data)
    --SHA256加密检验
    extract_npk_SHA256()
  elseif NPK_Header.flag ~= string.sub(data_string, 1, 16) then
    print("the pak is broken:check NPK_Header.flag failed")
  end
  
  data_string = nil --提取完文件信息，清空内存
  print("extract info of npk complete!")
  return npk_data
end

--提取npk中img数据信息，各img的偏移地址，大小，名称
--入参：npk文件地址，string
--      npk_data-NPK.extract_npk(npkfile)提取到的npk数据信息
function extract_npk_img(npkfile,npk_data)
  local offset = 0
  local size = 0
  local name = 0
  local decord_flag_byte = 0
  for i=0,NPK_Header.count-1 do
    NPK_Index.offset = 0
    NPK_Index.size = 0
    NPK_Index.name = ""
    for j=1,4 do
      offset = string.sub(data_string, 20+i*264+j, 20+i*264+j)
      NPK_Index.offset = NPK_Index.offset + string.byte(offset)*(2^8)^(j-1)
      size = string.sub(data_string, 24+i*264+j, 24+i*264+j)
      NPK_Index.size = NPK_Index.size + string.byte(size)*(2^8)^(j-1)
      
    end

    
    for j=1,256 do
      name = string.sub(data_string, 20+i*264+8 +j, 20+i*264+8 +j)
      name = string.byte(name)
      decord_flag_byte = string.sub(decord_flag, j, j)
      decord_flag_byte = string.byte(decord_flag_byte)
      
      --与名称解码标志按位异或
      name = bit.bxor(name,decord_flag_byte)
      name = string.char(name)
      if name == "\0" then  --文件路径名称读到0x00为止
        break
      end
      NPK_Index.name = NPK_Index.name..name
    
    end
    npk_data[NPK_Index.name] = { npkfile=npkfile,offset=NPK_Index.offset, size=NPK_Index.size}
  end

end



function extract_npk_SHA256()
  
  --没做检验
end

--根据提取到的npk数据信息读取img中图片信息和数据
--入参：imgname-读取的文件地址名称，string
--      npk_data- NPK.extract_npk(npkfile)提取到的npk数据信息
--返回：img文件中某一图片信息及数据，
--[[  
img[i] = {dwType=0, dwCompress=0, width=0, height=0, 
          size=0, key_x=0, key_y=0, max_width=0, max_height=0,
          linksn=0, imgdata = FileData型, img = img型 }
]]--

function NPK.read_npk_img( imgname, npk_data)
  local img = {}
  local img_start_adr = npk_data[imgname].offset --img文件开始的地址
  local img_size = npk_data[imgname].size
  local npk_name = "" --所加载img所在的npk文件路径名称
  
  --清空NImgF_Header各参数
  NImgF_Header.index_size = 0
  NImgF_Header.version = 0
  NImgF_Header.index_count = 0

  print("start read img",imgname)
  
  npk_name = npk_data[imgname].npkfile
  print("npk_name",npk_name)
  
  --读取npk
  data_string = love.filesystem.read( npk_name, all )
  
  print("img_start_adr",img_start_adr)
  local flag = string.sub(data_string,img_start_adr+1,img_start_adr+16)
  
  if NImgF_Header.flag == flag then
   --如果img文件标志检验成功，读取img数据
   
   --======读取img头信息===========================
    for i=1,4 do
      local index_size = string.sub(data_string,img_start_adr+16+i,img_start_adr+16+i)
      NImgF_Header.index_size = NImgF_Header.index_size + string.byte(index_size)*(2^8)^(i-1)
      
      local version = string.sub(data_string,img_start_adr+24+i,img_start_adr+24+i)
      NImgF_Header.version = NImgF_Header.version + string.byte(version)*(2^8)^(i-1)
      
      local index_count = string.sub(data_string,img_start_adr+28+i,img_start_adr+28+i)
      NImgF_Header.index_count = NImgF_Header.index_count + string.byte(index_count)*(2^8)^(i-1)
    end
    print("NImgF_Header.index_size",NImgF_Header.index_size)  -------------------------------------------------
    print("NImgF_Header.version",NImgF_Header.version)  -------------------------------------------------
    print("NImgF_Header.index_count",NImgF_Header.index_count)  -------------------------------------------------
    
    --============-end读取img头信息=================
    
    
    --创建存储img的空间，table型
    for i=1,NImgF_Header.index_count do
      img[i] = 
      {dwType=0, dwCompress=0, width=0, height=0, 
        size=0, key_x=0, key_y=0, max_width=0, max_height=0,
        linksn=0, imgdata, img
      }
    end
    
    --======读取贴图信息======================================
    local start_adr  = img_start_adr + 32 --索引表首地址
    for i=1,NImgF_Header.index_count do
      
      --根据当前贴图类型，读取信息
      for j=1,4 do
        local dwType = string.sub(data_string,start_adr+j,start_adr+j)
        img[i].dwType = img[i].dwType + string.byte(dwType)*(2^8)^(j-1)
      end
      if img[i].dwType ~= 17 then --非0x11(指向型)
        for j=1,4 do
          local dwCompress = string.sub(data_string,start_adr+4+j,start_adr+4+j)
          img[i].dwCompress = img[i].dwCompress + string.byte(dwCompress)*(2^8)^(j-1) 
          
          local width = string.sub(data_string,start_adr+8+j,start_adr+8+j)
          img[i].width = img[i].width + string.byte(width)*(2^8)^(j-1) 
          
          local height = string.sub(data_string,start_adr+12+j,start_adr+12+j)
          img[i].height = img[i].height + string.byte(height)*(2^8)^(j-1) 
          
          local size = string.sub(data_string,start_adr+16+j,start_adr+16+j)
          img[i].size = img[i].size + string.byte(size)*(2^8)^(j-1) 
          
          local key_x = string.sub(data_string,start_adr+20+j,start_adr+20+j)
          img[i].key_x = img[i].key_x + string.byte(key_x)*(2^8)^(j-1) 
          
          local key_y = string.sub(data_string,start_adr+24+j,start_adr+24+j)
          img[i].key_y = img[i].key_y + string.byte(key_y)*(2^8)^(j-1) 
          
          local max_width = string.sub(data_string,start_adr+28+j,start_adr+28+j)
          img[i].max_width = img[i].max_width + string.byte(max_width)*(2^8)^(j-1) 
          
          local max_height = string.sub(data_string,start_adr+32+j,start_adr+32+j)
          img[i].max_height = img[i].max_height + string.byte(max_height)*(2^8)^(j-1) 
        end
        --print("img[i].dwType",img[i].dwType)  ----------------------------------------------------------
        --print("img[i].key_x",img[i].key_x)  ----------------------------------------------------------
        
        --根据当前贴图的类型，得出下一张贴图的地址
        start_adr = start_adr + 36
      elseif img[i].dwType == 17 then --0x11,指向型
        --读取指向的序号
        for j=1,4 do
          local linksn_temp = string.sub(data_string,start_adr+4+j,start_adr+4+j)
          img[i].linksn = img[i].linksn + string.byte(linksn_temp)*(2^8)^(j-1) 
        end
        img[i].linksn = img[i].linksn + 1
        --print("img[i].linksn",i,img[i].linksn)  ------------------------------------------------------------------
        
        --根据当前贴图的类型，得出下一张贴图的地址
        start_adr = start_adr + 8
      end
      
    end
    
    --读取完所有非指向型贴图后，读取所有指向型贴图
    for i=1,NImgF_Header.index_count do
      if img[i].dwType == 17 then --0x11(指向型)
        --链接指向的数据
        --print(i,img[i].linksn)
        img[i].dwCompress = img[img[i].linksn].dwCompress
        img[i].width = img[img[i].linksn].width
        img[i].height = img[img[i].linksn].height
        img[i].size = img[img[i].linksn].size
        img[i].key_x = img[img[i].linksn].key_x
        img[i].key_y = img[img[i].linksn].key_y
        img[i].max_width = img[img[i].linksn].max_width
        img[i].max_height = img[img[i].linksn].max_height  
      end
      
    end
    --======end-读取贴图信息========================
   
    --======读取所有的贴图数据=====================
    --检查贴图数据首地址是否正确
    print("img_data start_adr",start_adr) ----------------------------------
    if start_adr == img_start_adr+32 + NImgF_Header.index_size then
      --先读取非指向型贴图数据
      for i=1,#img do
        --读取当前贴图
        local img_data_string = string.sub(data_string,start_adr+1,start_adr + img[i].size)
        if img[i].dwType == 16 then --采用（ARGB8888）颜色系统
          --是否使用了zlib压缩
          if 6 == img[i].dwCompress then  --使用zlib压缩
            img_data_string = love.data.decompress( "string", "zlib", img_data_string )  --解压后，为像素点阵数据
            img[i].imgdata = npk_newImageData( img[i].width, img[i].height, img_data_string ) --不能用引擎函数
            img[i].img = love.graphics.newImage( img[i].imgdata )
          elseif 5 == img[i].dwCompress then  --未压缩
            print(i)
            img[i].imgdata = npk_newImageData( img[i].width, img[i].height, img_data_string )
            img[i].img = love.graphics.newImage( img[i].imgdata )
          end
          --下一数据地址
          start_adr = start_adr + img[i].size
        elseif img[i].dwType == 15 or img[i].dwType == 14 then  --颜色系统为ARGB4444或ARGB1555的贴图不提取，取默认
          img[i].imgdata = love.image.newImageData(1, 1)
          img[i].img = love.graphics.newImage( img[i].imgdata ) 
          --下一数据地址
          start_adr = start_adr + img[i].size
        elseif img[i].dwType == 17 then --0x11(指向型)
          --下一数据地址
          start_adr = start_adr + 0 --指向型，占用为0
        end
          
        --读取完贴图数据后，清空，释放内存
        img_data_string = nil
          
      end
      
      print("end address",start_adr)  ------------------------------------
      
      --读取指向型贴图数据    
      for i=1,#img do
        if img[i].dwType == 17 then --0x11(指向型)
          img[i].imgdata = img[img[i].linksn].imgdata
          img[i].img = img[img[i].linksn].img
        end
        
      end
      data_string = nil --读取完img，清空读取npk占用的内存
      print("read img complete!")
      return img

    elseif start_adr ~= img_start_adr + NImgF_Header.index_size then
      print("img_data address is not correct")
      return {img,"img_data address is not correct"}
    end
    --======end-读取所有的贴图数据======
    
  elseif NImgF_Header.flag ~= flag then
    print("the pak is broken:check NImgF_Header.flag failed")
    return {img,"the pak is broken:check NImgF_Header.flag failed"}
  end
  
end

--创建npk_img的图片数据
--不能使用love.image.newImageData( width, height, "rgba8", img_data_string )创建
--npk中img的贴图颜色系统为argb8888
function npk_newImageData( width, height, img_data_string )
  local data = love.image.newImageData(width, height)
  local r,g,b,a
  local num=1 --当前像素
  
  if 4 > string.len(img_data_string) then
    return data
  end
    for i=0,height-1 do
      for j=0,width-1 do
        b = string.byte(img_data_string,num)/255
        g = string.byte(img_data_string,num+1)/255
        r = string.byte(img_data_string,num+2)/255
        a = string.byte(img_data_string,num+3)/255
        data:setPixel(j, i, r, g, b, a)
        num = num + 4
      end
    end
  return data
  
end



--提取npk信息，并把信息附加到npk_data_add = {}中
function NPK.extract_npk_add(npkfile,npk_data_add)
  local npk_data_temp = NPK.extract_npk(npkfile)
  for key,value in pairs(npk_data_temp) do
    npk_data_add[key] = value
  end
end

return NPK