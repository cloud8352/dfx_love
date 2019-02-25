--功能：总控制程序
--作者：cloud
--修改时间：2019.1.24
--修改内容：
--          
--0.1

Q_control = {}

function Q_control.init()
  window_title = "love dfx 0.0.1    ".."fps:"..love.timer.getFPS()
  love.window.setTitle( window_title )

  love.keyboard.setKeyRepeat( true )    --开启：按键重复检测

  myfont = love.graphics.newFont("data/font/SourceHanSerifSC-Medium.otf",12)--字体文件,支持中文
  love.graphics.setFont(myfont)

  --是否开启调试
  Q_debug = false

  width =  love.graphics.getWidth()
  height =  love.graphics.getHeight()
  
  move_collider = CC_ColliderBox.new(0, 0, 40, 20, 20, 10)
  
  -----大地图创建------
  largemap = LargeMap.new()
  largemap:Load("data/largemap/largetestmap2.txt")
  largemap_colliders = {}     --角色当前所处小地图存在的碰撞盒
  ---------------------
  
  --当前所处小地图的绝对坐标(相对于大地图)
  map = NormalMap.new()
  map:Load("testmap")
  map.x = 1730 * 0
  map.y = 430 * 0

  --创建鬼剑
  swordman = Swordman.new()
  swordman.x =  swordman.x + map.x
  swordman.y =  swordman.y + map.y

  -----从Kyo_t中读取第二套控制按键------
  kyo_control_key2 = Kyo_t.new()
  --------------------------------------
  
  --创建Kyo
  kyo = Kyo.new()
  kyo.x = kyo.x + map.x
  kyo.y = kyo.y + map.y
  kyo.shuxing = kyo_control_key2.shuxing
  kyo.ispuppet = false

  -----------敌人组--------------
  enemy_group = {}
  table.insert(enemy_group,kyo)
  -------------------------------

  screenoff = {x = 0, y = 0}

  --初始化ui
  UI_init()

  --把显示的对象统一放在一个table里
  ScreenShowObj = {}
  table.insert(ScreenShowObj, kyo)
  table.insert(ScreenShowObj, swordman)
  --把地图物件加入ScreenShowObj-----------
  for i=1,#largemap.LargeMapData do
      if largemap.LargeMapData[i].map.MapData_thing ~= nil then
          for j=1,#largemap.LargeMapData[i].map.MapData_thing do
              table.insert(ScreenShowObj, largemap.LargeMapData[i].map.MapData_thing[j].sprite)
          end
      end
  end
  ----------------------------------------

  ---------BGM---------------
  bgmplayperiod = 0
  bgm = love.audio.newSource("data/music/forest_town.ogg", "stream")  --"data/music/forest_town.ogg"  "data/music/PLANET (8bit Remix).wav"
  bgm:setVolume(0.2)
  --bgm:play()
  -------------------------------
  
  --创建声音管理table
  sound_group = {}
  sound_group[bgm] = bgm
  sound_group[bgm]:play()
  
end


function Q_control.update(dt)
  
  window_title = "love dfx 0.0.1    ".."fps:"..love.timer.getFPS()
  love.window.setTitle( window_title )
  
  for k,v in pairs(sound_group) do
    if v:isPlaying() == false then
      sound_group[k] = nil
    end
      
  end
  
  --bgm播放管理
  if sound_group[bgm] == nil then
    bgmplayperiod = bgmplayperiod + dt
    if bgmplayperiod > 3 then
      sound_group[bgm] = bgm
      sound_group[bgm]:play()
      bgmplayperiod = 0
    end
  end

  if GetKeyPress("f1") then
      print("f1")
      Q_debug = not Q_debug
  end
  
  if GetKeyPress("f2") then
      print("f2")
      AddEnemy("kyo")
  end

  PuppetLogic(dt) --人偶逻辑

  --kyo:Updata(dt)

  swordman:Updata(dt)
  
  if #enemy_group >0 then
    for i=1,#enemy_group do
      enemy_group[i]:Updata(dt)
    end
  end

  largemap:Updata()

  --角色移动障碍判定
  for i=1,#largemap_colliders do
      if swordman.colliderbox:CheckBox(largemap_colliders[i]) then
        --角色右边碰到碰撞盒
        if swordman.lx + swordman.colliderbox.width/2 - swordman.deltax <= largemap_colliders[i].xtop then
          swordman.x = largemap_colliders[i].xtop - swordman.colliderbox.width/2 -1
        end
        --角色左边碰到碰撞盒
        if swordman.lx - swordman.colliderbox.width/2 - swordman.deltax >= largemap_colliders[i].xtop + largemap_colliders[i].width then
          swordman.x = largemap_colliders[i].xtop + largemap_colliders[i].width + swordman.colliderbox.width/2 +1
        end
        --角色下边碰到碰撞盒
        if swordman.ly + swordman.colliderbox.height/2 - swordman.deltay <= largemap_colliders[i].ytop then
          swordman.y = largemap_colliders[i].ytop - swordman.colliderbox.height/2 -1
        end
        --角色上边碰到碰撞盒
        if swordman.ly - swordman.colliderbox.height/2 - swordman.deltay >= largemap_colliders[i].ytop + largemap_colliders[i].height then
          swordman.y = largemap_colliders[i].ytop + largemap_colliders[i].height + swordman.colliderbox.height/2 +1
        end
          
      end
  end
  
  --enemy_group移动障碍判定
    if #enemy_group >0 then
      for j=1,#enemy_group do
        for i=1,#largemap_colliders do
          if enemy_group[j].colliderbox:CheckBox(largemap_colliders[i]) then
            --角色右边碰到碰撞盒
            if enemy_group[j].lx + enemy_group[j].colliderbox.width/2 - enemy_group[j].deltax <= largemap_colliders[i].xtop then
              enemy_group[j].x = largemap_colliders[i].xtop - enemy_group[j].colliderbox.width/2 -1
            end
            --角色左边碰到碰撞盒
            if enemy_group[j].lx - enemy_group[j].colliderbox.width/2 - enemy_group[j].deltax >= largemap_colliders[i].xtop + largemap_colliders[i].width then
              enemy_group[j].x = largemap_colliders[i].xtop + largemap_colliders[i].width + enemy_group[j].colliderbox.width/2 +1
            end
            --角色下边碰到碰撞盒
            if enemy_group[j].ly + enemy_group[j].colliderbox.height/2 - enemy_group[j].deltay <= largemap_colliders[i].ytop then
              enemy_group[j].y = largemap_colliders[i].ytop - enemy_group[j].colliderbox.height/2 -1
            end
            --角色上边碰到碰撞盒
            if enemy_group[j].ly - enemy_group[j].colliderbox.height/2 - enemy_group[j].deltay >= largemap_colliders[i].ytop + largemap_colliders[i].height then
              enemy_group[j].y = largemap_colliders[i].ytop + largemap_colliders[i].height + enemy_group[j].colliderbox.height/2 +1
            end
              
          end
        end
		
	  end
	end 
  

  --swordman攻击判定
  for i=1,#swordman.AttackBox do
    if swordman.AttackBox[i]:CheckBox(kyo.Attackbox) 
        and swordman.attacking
        then
      if swordman.action == "attack2" 
        --and swordman.lastsn == 4
        and swordman.ActionFramSn >= 35
        and swordman.ActionFramSn <= 38
        and swordman.colliderbox.ytop >= kyo.colliderbox.ytop - kyo.colliderbox.height
        and swordman.colliderbox.ytop <= kyo.colliderbox.ytop + kyo.colliderbox.height
        then
        
        kyo:BeAttackedUp(dt, 0.35*swordman.dir,4.5)
        attack_float_num = attack_float_num + 1
      end
      
      if swordman.action == "attack1" 
        --and swordman.lastsn == 2
        and swordman.ActionFramSn >= 4
        and swordman.ActionFramSn <= 6
        and swordman.colliderbox.ytop >= kyo.colliderbox.ytop - kyo.colliderbox.height
        and swordman.colliderbox.ytop <= kyo.colliderbox.ytop + kyo.colliderbox.height
        then
          
        kyo:BeAttacked(dt, 0.35*swordman.dir,0.2)
        attack_float_num = attack_float_num + 1
      end
    end
  end
  
  --swordman攻击判定2(对enemy_group)
  for i=1,#swordman.AttackBox do
    if #enemy_group >0 then
      for j=1,#enemy_group do
        if swordman.AttackBox[i]:CheckBox(enemy_group[j].Attackbox) 
            and swordman.attacking
            then
          if swordman.action == "attack2" 
            --and swordman.lastsn == 4
            and swordman.ActionFramSn >= 35
            and swordman.ActionFramSn <= 38
            and swordman.colliderbox.ytop >= enemy_group[j].colliderbox.ytop - enemy_group[j].colliderbox.height
            and swordman.colliderbox.ytop <= enemy_group[j].colliderbox.ytop + enemy_group[j].colliderbox.height
            then
            
            enemy_group[j]:BeAttackedUp(dt, 0.35*swordman.dir,4.5)
            attack_float_num = attack_float_num + 1
          end
          
          if swordman.action == "attack1" 
            --and swordman.lastsn == 2
            and swordman.ActionFramSn >= 4
            and swordman.ActionFramSn <= 6
            and swordman.colliderbox.ytop >= enemy_group[j].colliderbox.ytop - enemy_group[j].colliderbox.height
            and swordman.colliderbox.ytop <= enemy_group[j].colliderbox.ytop + enemy_group[j].colliderbox.height
            then
              
            enemy_group[j]:BeAttacked(dt, 0.35*swordman.dir,0.2)
            attack_float_num = attack_float_num + 1
          end
        end
      end
    end
      
  end
  
  --kyo攻击判定
    if kyo.Attackbox:CheckBox(swordman.BodyBox) 
        and kyo.attacking
        then
      if kyo.action == "attack2" 
        --and kyo.l1astsn == 4
        and kyo.ActionFramSn >= 4
        and kyo.ActionFramSn <= 5
        and kyo.colliderbox.ytop >= swordman.colliderbox.ytop - swordman.colliderbox.height
        and kyo.colliderbox.ytop <= swordman.colliderbox.ytop + swordman.colliderbox.height
        then
        
        swordman:BeAttackedUp(dt, 0.35*kyo.dir,4.5)
        attack_float_num = attack_float_num + 1
      end
      
      if kyo.action == "attack1" 
        --and kyo.lastsn == 2
        and kyo.ActionFramSn >= 2
        and kyo.ActionFramSn <= 3
        and kyo.colliderbox.ytop >= swordman.colliderbox.ytop - swordman.colliderbox.height
        and kyo.colliderbox.ytop <= swordman.colliderbox.ytop + swordman.colliderbox.height
        then
          
        swordman:BeAttacked(dt, 0.35*kyo.dir,0.2)
        attack_float_num = attack_float_num + 1
      end
    end
  
  --enemy_group攻击判定
  if #enemy_group >0 then
    for i=1,#enemy_group do
      if enemy_group[i].Attackbox:CheckBox(swordman.BodyBox) 
          and enemy_group[i].attacking
          then
        if enemy_group[i].action == "attack2" 
          --and enemy_group[i].l1astsn == 4
          and enemy_group[i].ActionFramSn >= 4
          and enemy_group[i].ActionFramSn <= 5
          and enemy_group[i].colliderbox.ytop >= swordman.colliderbox.ytop - swordman.colliderbox.height
          and enemy_group[i].colliderbox.ytop <= swordman.colliderbox.ytop + swordman.colliderbox.height
          then
          
          swordman:BeAttackedUp(dt, 0.35*enemy_group[i].dir,4.5)
          attack_float_num = attack_float_num + 1
        end
        
        if enemy_group[i].action == "attack1" 
          --and enemy_group[i].lastsn == 2
          and enemy_group[i].ActionFramSn >= 2
          and enemy_group[i].ActionFramSn <= 3
          and enemy_group[i].colliderbox.ytop >= swordman.colliderbox.ytop - swordman.colliderbox.height
          and enemy_group[i].colliderbox.ytop <= swordman.colliderbox.ytop + swordman.colliderbox.height
          then
            
          swordman:BeAttacked(dt, 0.35*enemy_group[i].dir,0.2)
          attack_float_num = attack_float_num + 1
        end
      end
        
    end
  end
  
  

  --判断角色在大地图里的哪个小地图内
  for i=1,#largemap.LargeMapData do
    
    if i == math.modf(swordman.y/largemap.LargeMapData[1].map.MapHeight)*largemap.n
      + math.modf(swordman.x/largemap.LargeMapData[1].map.MapWidth) + 1
      then
      largemap.LargeMapData[i].showing = true
      map = largemap.LargeMapData[i].map
      map.x = largemap.LargeMapData[i].map.x
      map.y = largemap.LargeMapData[i].map.y
      
      --更新角色当前所处小地图存在的碰撞盒
      for j=1,#largemap.LargeMapData[i].map.MapData_collider do
        largemap_colliders[j] = largemap.LargeMapData[i].map.MapData_collider[j].colliderbox
        
      end           
      
      --判断角色是否到达了小地图边界
      --到达上边界
      if swordman.colliderbox.ytop <= largemap.LargeMapData[i].map.y then
        
        if largemap.LargeMapData[i].upto > 0 then
            swordman.y = largemap.LargeMapData[largemap.LargeMapData[i].upto].map.y 
            + largemap.LargeMapData[largemap.LargeMapData[i].upto].map.MapHeight
            - swordman.colliderbox.height/2 - 1
            print(i,"upto")
            break
        end
      end
      
      --到达下边界
      if swordman.colliderbox.ytop + swordman.colliderbox.height >= 
        largemap.LargeMapData[i].map.y + largemap.LargeMapData[i].map.MapHeight
        then
        
        if largemap.LargeMapData[i].downto > 0 then
          swordman.y = largemap.LargeMapData[largemap.LargeMapData[i].downto].map.y
          + swordman.colliderbox.height/2 + 1
          print(i,"downto:")
          break
        end
      end
      
      --到达zuo边界
      if swordman.colliderbox.xtop <= largemap.LargeMapData[i].map.x then
        
        if largemap.LargeMapData[i].leftto > 0 then
          swordman.x = largemap.LargeMapData[largemap.LargeMapData[i].leftto].map.x 
          + largemap.LargeMapData[largemap.LargeMapData[i].leftto].map.MapWidth
          - swordman.colliderbox.width/2 - 1
          print(i,"leftto")
          break
        end
      end
      
      --到达you边界
      if swordman.colliderbox.xtop + swordman.colliderbox.width >= 
        largemap.LargeMapData[i].map.x + largemap.LargeMapData[i].map.MapWidth
        then
        
        if largemap.LargeMapData[i].rightto > 0 then
          swordman.x = largemap.LargeMapData[largemap.LargeMapData[i].rightto].map.x
          + swordman.colliderbox.width/2 + 1
          print(i,"rightto:")
          break
        end
      end
      
    end
    
  end
  

  --获取屏幕偏移量
  screenoff = GetScreenOffset(swordman.x, swordman.y-120, map.ShowWidth, map.ShowHeight, -map.x + map.MapOffset.x, -map.y + map.MapOffset.y)
    
  --把显示的对象统一放在一个table里
  ScreenShowObj = {}
  table.insert(ScreenShowObj, swordman)
  table.insert(ScreenShowObj, kyo)
  --加入敌人组
  if #enemy_group > 1 then
    for i=1,#enemy_group do
      table.insert(ScreenShowObj,enemy_group[i])
    end
  end
  --把当前地图物件加入ScreenShowObj
  for i=1,#largemap.LargeMapData do
    if largemap.LargeMapData[i].showing == true then
      if largemap.LargeMapData[i].map.MapData_thing ~= nil then
        for j=1,#largemap.LargeMapData[i].map.MapData_thing do
          table.insert(ScreenShowObj, largemap.LargeMapData[i].map.MapData_thing[j].sprite)
        end
      end
    end
  end

  --显示排序
  table.sort(ScreenShowObj,function (ScreenShowObja, ScreenShowObjb) return  ScreenShowObja.y < ScreenShowObjb.y  end)
 
  UI_update()

end

function Q_control.draw()
  
  largemap:Show(screenoff.x, screenoff.y)
  for i=1,#ScreenShowObj do
    ScreenShowObj[i]:Show(screenoff.x, screenoff.y)
  end
  
  
  if Q_debug then
    local j = 1
    if route[j] then
      for i=1,#route[j] do
        love.graphics.setColor( 0,0,1, 1 )
        local x = route[j][i].x + screenoff.x
        local y = route[j][i].y + screenoff.y
        love.graphics.rectangle( "line", x-20, y-10, 40, 20 )
        if i>1 then
          love.graphics.line(route[j][i-1].x+ screenoff.x,route[j][i-1].y +screenoff.y,
            route[j][i].x+ screenoff.x,route[j][i].y +screenoff.y)
        end
          
      end
      love.graphics.setColor( 1,1,1, 1 )
    end
    
  end
  
  UI_draw()
  
end


function UI_init()
  
  --------UI loveframes 初始化--------------
  --loveframes = require("lib.loveframes")
  
  button_sound_click = love.audio.newSource("data/sound/ui/click1.wav", "stream")
  ui_npk_data = {}
  NPK.extract_npk_add("NPK/sprite_interface.NPK",ui_npk_data)
  ui_npk_img = NPK.read_npk_img("sprite/interface/windows_base",ui_npk_data)
  ui_img_group = {
    item_window = ui_npk_img[52].img,
    window_select = ui_npk_img[51].img,
    small_window_1 = ui_npk_img[43].img,
    small_window_2 = ui_npk_img[44].img,
    small_window_true = ui_npk_img[45].img,
    small_window_unuse = ui_npk_img[46].img,
    
  }
  
  --创建角色信息显示框
  local charinf_frame = loveframes.Create("frame")
  charinf_frame:SetPos(300, 100)
  charinf_frame:SetName("character")
  charinf_frame:SetSize(350,500)
  pub_parent = charinf_frame:GetParent()  --获取屏幕总父对象

  --先不显示
  charinf_frame:Remove()

  --左上角角色图片按钮
  charinf_imagebutton = loveframes.Create("imagebutton")
  charinf_imagebutton:SetText("")
  charinf_imagebutton:SetImage("swo.png")
  charinf_imagebutton:SetPos(0, 0)
  charinf_imagebutton:SetImgSize(60, 60)
  charinf_imagebutton:SizeToImage()

  charinf_imagebutton.OnClick = function(object)
    print("The image button was clicked!")
    if sound_group[button_sound_click] ~= nil then
      sound_group[button_sound_click]:stop()
    end
    sound_group[button_sound_click] = button_sound_click
    sound_group[button_sound_click]:play()
    local show_char_shuxing = true  --是否显示角色属性框
    for k,v in pairs(pub_parent.children) do
      if v == charinf_frame then
        show_char_shuxing = false
      end
    end
    
    if show_char_shuxing then
      table.insert(pub_parent.children,charinf_frame)
    end
  end
  
  charinf_img_window = loveframes.Create("image", charinf_imagebutton)
  charinf_img_window:SetImage("char_window.png")
  charinf_img_window:SetPos(0, 0)
  charinf_img_window:SetImgSize(61, 61)
  
  charinf_img_window_hover = loveframes.Create("image", charinf_imagebutton)
  charinf_img_window_hover:SetImage(ui_img_group.window_select)
  charinf_img_window_hover.imagecolor = {255, 255, 255, 0.005}
  charinf_img_window_hover:SetPos(0, 0)
  charinf_img_window_hover:SetImgSize(61, 61)
  charinf_img_window_hover:Remove()
  
  --===创建角色物品拦显示框
  item_frame = loveframes.Create("frame")
  item_frame:SetPos(400, 100)
  item_frame:SetName("item")
  item_frame:SetSize(350,500)
  pub_parent = item_frame:GetParent()  --获取屏幕总父对象
  --创建物品格子8*x
  item_grid = {}
  item_grid_hover = {}
  local grid_width = 30
  local grid_height = 30
  local grid_xnum = 10
  local grid_ynum = 12
  local grid_x = 11
  local grid_y = 53
  for j=1,grid_ynum do
    item_grid[j] = {}
    item_grid_hover[j] = {}
    for i=1,grid_xnum do
      item_grid[j][i] = loveframes.Create("image",item_frame)
      item_grid[j][i]:SetImage(ui_img_group.item_window)
      item_grid[j][i]:SetPos(grid_x,grid_y)
      item_grid[j][i]:SetSize(grid_width,grid_height)
      item_grid_hover[j][i] = loveframes.Create("image",item_frame)
      item_grid_hover[j][i]:SetImage(ui_img_group.window_select)
      item_grid_hover[j][i].imagecolor = {255, 255, 255, 0.02}
      item_grid_hover[j][i]:SetPos(grid_x,grid_y)
      item_grid_hover[j][i]:SetSize(0,0)
      item_grid_hover[j][i]:SetImgSize(grid_width,grid_height)
      item_grid_hover[j][i]:Remove()
      grid_x = grid_x + grid_width + 3
    end
    grid_x = 11
    grid_y = grid_y + grid_height + 3
  
  end


  --先不显示
  item_frame:Remove()
  
  --其他ui界面，坐标统一管理(以分辨率1120*630为基准)
  pos_scale = {x = width/1120, y = height/630}
  
  local button1 = loveframes.Create("button")
  button1:SetPos(width/2*pos_scale.x, 600*pos_scale.y)
  
  charinf_imagebutton2 = loveframes.Create("imagebutton")
  charinf_imagebutton2:SetText("")
  local img1 = "data/ui/button/5.png"
  local img2 = "data/ui/button/6.png"
  local img3 = "data/ui/button/7.png"
  charinf_imagebutton2:SetImage(img1, img2, img3)
  charinf_imagebutton2:SetPos(976*pos_scale.x, 595*pos_scale.y)
  charinf_imagebutton2:SizeToImage()
  charinf_imagebutton2.OnClick = charinf_imagebutton.OnClick
  
  item_imagebutton = loveframes.Create("imagebutton")
  item_imagebutton:SetText("")
  img1 = "data/ui/button/8.png"
  img2 = "data/ui/button/9.png"
  img3 = "data/ui/button/10.png"
  item_imagebutton:SetImage(img1, img2, img3)
  item_imagebutton:SetPos(1002*pos_scale.x, 595*pos_scale.y)
  item_imagebutton:SizeToImage()
  item_imagebutton.OnClick = function(object)
    if sound_group[button_sound_click] ~= nil then
      sound_group[button_sound_click]:stop()
    end
    sound_group[button_sound_click] = button_sound_click
    sound_group[button_sound_click]:play()
    local show_char_shuxing = true  --是否显示角色属性框
    for k,v in pairs(pub_parent.children) do
      if v == item_frame then
        show_char_shuxing = false
      end
    end
    
    if show_char_shuxing then
      table.insert(pub_parent.children,item_frame)
    end
  end
  
  task_imagebutton = loveframes.Create("imagebutton")
  task_imagebutton:SetText("")
  img1 = "data/ui/button/11.png"
  img2 = "data/ui/button/12.png"
  img3 = "data/ui/button/13.png"
  task_imagebutton:SetImage(img1, img2, img3)
  task_imagebutton:SetPos(1028*pos_scale.x, 595*pos_scale.y)
  task_imagebutton:SizeToImage()
  
  skill_imagebutton = loveframes.Create("imagebutton")
  skill_imagebutton:SetText("")
  img1 = "data/ui/button/14.png"
  img2 = "data/ui/button/15.png"
  img3 = "data/ui/button/16.png"
  skill_imagebutton:SetImage(img1, img2, img3)
  skill_imagebutton:SetPos(1054*pos_scale.x, 595*pos_scale.y)
  skill_imagebutton:SizeToImage()
  
  setting_imagebutton = loveframes.Create("imagebutton")
  setting_imagebutton:SetText("")
  img1 = "data/ui/button/72.png"
  img2 = "data/ui/button/73.png"
  img3 = "data/ui/button/74.png"
  setting_imagebutton:SetImage(img1, img2, img3)
  setting_imagebutton:SetPos(1080*pos_scale.x, 595*pos_scale.y)
  setting_imagebutton:SizeToImage()
  
  ---------end-UI loveframes 初始化-------------------
  
  -------------右上角小地图--------
  smallmap = CC_ColliderBox.new(width, 0, 160, 120, 160, 0)
  smallmap_charpos = {x = 0, y = 0}   --小地图上角色的坐标
  smallmap_width = 0  --小地图轮廓宽(适应显示区域的)
  smallmap_height = 0
  --------------------------------
  
  -------------浮空数---------------
  attack_float_num = 0
  --------------------------------
  
  -------------p2是否是人偶按钮-----------
  p2_option_ispuppet_imagebutton = loveframes.Create("imagebutton")
  p2_option_ispuppet_imagebutton:SetText("")
  img1 = ui_img_group.small_window_1
  img2 = ui_img_group.small_window_2
  img3 = ui_img_group.small_window_2
  p2_option_ispuppet_imagebutton:SetImage(img1, img2, img3)
  p2_option_ispuppet_imagebutton:SetPos(800*pos_scale.x, 20*pos_scale.y)
  p2_option_ispuppet_imagebutton:SizeToImage()
  p2_option_ispuppet_imagebutton.OnClick = function(object)
    if sound_group[button_sound_click] ~= nil then
      sound_group[button_sound_click]:stop()
    end
    sound_group[button_sound_click] = button_sound_click
    sound_group[button_sound_click]:play()
    if kyo.ispuppet == false then
      kyo.ispuppet = true
      img1 = ui_img_group.small_window_true
      img2 = ui_img_group.small_window_true
      img3 = ui_img_group.small_window_true
      p2_option_ispuppet_imagebutton:SetImage(img1, img2, img3)
    elseif kyo.ispuppet == true then
      kyo.ispuppet = false
      img1 = ui_img_group.small_window_1
      img2 = ui_img_group.small_window_2
      img3 = ui_img_group.small_window_2
      p2_option_ispuppet_imagebutton:SetImage(img1, img2, img3)
    end
      
  end
  ----------------------------------------

end

function UI_update()
  --------UI 测试 更新-----------------
  if charinf_imagebutton.hover == true then
    table.insert(pub_parent.children,charinf_img_window_hover)
  else
    charinf_img_window_hover:Remove()
  end
  
  for j=1,#item_grid do
    for i=1,#item_grid[j] do
      if item_grid[j][i].hover == true then
        table.insert(item_frame.children,item_grid_hover[j][i])
      else
        item_grid_hover[j][i]:Remove()
      end
    end
  end
  
  ---------end-UI 测试 更新-------------
end

function UI_draw()
  
  --击中显示
  love.graphics.setColor( red, 1 )
  love.graphics.print("击中: "..attack_float_num, width/2 - 20, 5, 0, 1.3, 1.3)
  love.graphics.setColor( 255,255,255, 1 )

  --------右上角小地图------------
  smallmap:Show(blue,0,0)

  love.graphics.setColor( 0,0,0, 0.5 )
  love.graphics.rectangle( "fill", width -160, 0, 160, 120) --小地图显示区域

  love.graphics.setColor( 0,0,0, 0.7 )
  love.graphics.rectangle( "fill", width -160, 0, 160, 20) --小地图坐标数值显示区域
  love.graphics.setColor( 255,255,255, 1 )
  love.graphics.print("坐标: "..math.modf(swordman.x)..","..math.modf(swordman.y), width -160, 0, 0, 1, 1)
  love.graphics.setColor( 0,0,0, 0.5 )

  smallmap_width = 160
  smallmap_height = 160*(largemap.height/largemap.width)
  if smallmap_height > 100 then
      smallmap_width = 100*(largemap.width/largemap.height)
      smallmap_height = 100
  end

  love.graphics.setColor( blue, 0.5 )
  love.graphics.rectangle( "line", width -160, 20, smallmap_width, smallmap_height) --根据大地图尺寸等比画出小地图轮廓

  smallmap_charpos.x = width -160 + smallmap_width*(swordman.x/largemap.width)     --算取swordman在小地图上显示的位置
  smallmap_charpos.y = 20          + smallmap_height*(swordman.y/largemap.height)

  love.graphics.setColor( red, 0.5 )
  love.graphics.rectangle( "fill", smallmap_charpos.x-2, smallmap_charpos.y-2, 4, 4) --显示小地图中人物的位置

  smallmap_charpos.x = width -160 + smallmap_width*(kyo.x/largemap.width)     --算取kyo在小地图上显示的位置
  smallmap_charpos.y = 20          + smallmap_height*(kyo.y/largemap.height)

  love.graphics.setColor( green, 0.5 )
  love.graphics.rectangle( "fill", smallmap_charpos.x-2, smallmap_charpos.y-2, 4, 4) --显示小地图中人物的位置

  love.graphics.setColor( 255,255,255, 1 )
  ------------end=右上角小地图--------------------
  
  -------------p2是否是人偶按钮-----------
  love.graphics.print("p2是否是人偶(敌对):", 800-115, 16, 0, 1, 1)
  -------------end-p2是否是人偶按钮-----------

  -------------按f2加入敌人-----------
  love.graphics.print("按f2加入敌人", 300, 5, 0, 1.2, 1.2)
  -------------end-p2是否是人偶按钮-----------

  if Q_debug then
      love.graphics.print("FPS:"..love.timer.getFPS( ), 10+70, 10, 0, 1, 1)
      love.graphics.print("xyPos:"..math.modf(swordman.x)..","..math.modf(swordman.y), 70+70, 10, 0, 1, 1)
  end
  
end

route_index = {}
--route_time = 3
route = {}
function  PuppetLogic(dt) --人偶逻辑
  --route_time = route_time + dt
  if #enemy_group >0 then
    for i=1,#enemy_group do
        if enemy_group[i].ispuppet then
          local collider_group = {}
          for i=1,#map.MapData_collider do
            table.insert(collider_group, map.MapData_collider[i].colliderbox)
          end 
          local route_temp = CheckDirectRoute(collider_group,move_collider,enemy_group[i].x,enemy_group[i].y,swordman.x,swordman.y)
          if #route_temp ~= 0 then
            route[i] = table_copy(route_temp)
            route_index[i] = 2
          else
            if route[i] == nil
            or #route[i] == 0
            or route_index[i] > #route[i]
            then
              route[i] = GetMINRoute(collider_group,move_collider,enemy_group[i].x,enemy_group[i].y,swordman.x,swordman.y,0.1)
              route_index[i] = 2
            end
          end
          
          if route[i]
          and #route[i] ~= 0 
          then
            enemy_group[i]:MoveTo(dt,route[i][route_index[i]].x,route[i][route_index[i]].y)
            
            if enemy_group[i].x > route[i][route_index[i]].x -5
            and enemy_group[i].x <= route[i][route_index[i]].x +5
            and enemy_group[i].y > route[i][route_index[i]].y -5
            and enemy_group[i].y <= route[i][route_index[i]].y +5
            then
              route_index[i] = route_index[i] + 1  
            end
            
            --print("#route",#route)
            --print("route_index",route_index) 
          end
          
          
          
          if enemy_group[i].x < swordman.x +10
          and enemy_group[i].x >= swordman.x -10
          and enemy_group[i].y < swordman.y +10
          and enemy_group[i].y >= swordman.y -10 
          and enemy_group[i].floating == false --是否浮空
          and enemy_group[i].attacking == false
          and enemy_group[i].attacked == false
          and enemy_group[i].skilling == false
          and enemy_group[i].jumping == false
          and enemy_group[i].lying == false 	--是否躺地
          then
            enemy_group[i]:ChangeAction("attack2")
            if enemy_group[i].action == "attack2" 
              --and enemy_group[i].l1astsn == 4
              and enemy_group[i].ActionFramSn >= 4
              and enemy_group[i].ActionFramSn <= 5
              and enemy_group[i].colliderbox.ytop >= swordman.colliderbox.ytop - swordman.colliderbox.height
              and enemy_group[i].colliderbox.ytop <= swordman.colliderbox.ytop + swordman.colliderbox.height
              then
              
              swordman:BeAttackedUp(dt, 0.35*enemy_group[i].dir,4.5)
              attack_float_num = attack_float_num + 1
            end
            
          end 
          
        end
        
    end
  end
end

function AddEnemy(obj)
  if obj == "kyo" then
    local new_enemy = Kyo.new()
    new_enemy.x = swordman.x + love.math.random(-80, 80)
    new_enemy.y = swordman.y + love.math.random(-80, 80)
    new_enemy.ispuppet = true
    new_enemy.shuxing = kyo_control_key2.shuxing
    table.insert(enemy_group,new_enemy)
  end
  
end

return  Q_control