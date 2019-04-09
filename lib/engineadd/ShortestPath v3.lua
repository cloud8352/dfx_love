require("lib.engineadd.CC_ColliderBox")	--创建碰撞盒
--require("lib.CC_engineadd")

--function ReturnCollidedLine(colbox1,colbox2) 和
--function table_copy(ori_tab) 在lib.CC_engineadd中

--获取最短路线,可行点标记法
function GetMINRoute(collider_group,move_collider,sx,sy,ex,ey,ot)
  local outtime = ot or nil  --出结果时间
  local time = 0
  local start_time = love.timer.getTime() --运行时间
  local grid_lenth = 3 --直线检索单元格长度
  local point_enable = {} --可行移动点
  local point_enable_index = 1
  local route = {}  --存放可行路线
  local route_index = 1
  local shortest_route = {} --最短路线
  local move_width = move_collider.width
  local move_height = move_collider.height
  local limit = 3 --标定各障碍物四角坐标，需要留的阈值
  
  --=====================判断起始点直连路线是否有障碍======================
  local return_route = true
  local s_temp = {x=sx,y=sy}  --临时起始点，用于路线检测
  local e_temp = {x=ex,y=ey}
  local kx = (e_temp.y-s_temp.y)/(e_temp.x-s_temp.x)
  local ky = 0
  if math.abs(kx) > 1 
    --or 0 == e_temp.x-s_temp.x
  then
    ky = 1/kx
    s_temp = {x=sy,y=sx}
    e_temp = {x=ey,y=ex}
  end
  for dx=1,math.abs(s_temp.x-e_temp.x)+1 do
    dx = dx - 1
    if e_temp.x-s_temp.x < 0 then
      dx = -dx
    end
    local x = 0
    local y = 0
    if math.abs(kx) > 1 then
      y = s_temp.x + dx
      x = (y - s_temp.x)*ky + s_temp.y
    elseif math.abs(kx) <= 1 then
      x = s_temp.x + dx
      y = (x - s_temp.x)*kx + s_temp.y
    end
    move_collider:Updata(x, y)
    
    for i=1,#collider_group do
      if move_collider:CheckBox(collider_group[i]) then
        return_route = false
      end
    end
    
  end
  
  if return_route then
    shortest_route[1] = {x=sx,y=sy} --最短路线
    shortest_route[2] = {x=ex,y=ey} --最短路线
    return shortest_route
  end
  --=====================end-判断起始点直连路线是否有障碍======================
  
  --=====================标记出所有可行点======================
  for i=1,#collider_group do
    --碰撞盒左上角点
    local point = {}
    point.x = collider_group[i].x - move_width/2 - limit
    point.y = collider_group[i].y - move_height/2 - limit
    local add_to_point = true  --是否加入可行点列
    move_collider:Updata(point.x, point.y)
    for j=1,#collider_group do
      if move_collider:CheckBox(collider_group[j]) then
        add_to_point = false
        break
      end
    end
    
    if add_to_point then
      point_enable[point_enable_index] = {x=point.x,y=point.y}
      point_enable_index = point_enable_index + 1
    end
    
    --碰撞盒右上角点
    point.x = collider_group[i].x + collider_group[i].width + move_width/2 + limit
    point.y = collider_group[i].y - move_height/2 - limit
    add_to_point = true  --是否加入可行点列
    move_collider:Updata(point.x, point.y)
    for j=1,#collider_group do
      if move_collider:CheckBox(collider_group[j]) then
        add_to_point = false
        break
      end
    end
    
    if add_to_point then
      point_enable[point_enable_index] = {x=point.x,y=point.y}
      point_enable_index = point_enable_index + 1
    end
    
    --碰撞盒左下角点
    point.x = collider_group[i].x - move_width/2 - limit
    point.y = collider_group[i].y + collider_group[i].height + move_height/2 + limit
    add_to_point = true  --是否加入可行点列
    move_collider:Updata(point.x, point.y)
    for j=1,#collider_group do
      if move_collider:CheckBox(collider_group[j]) then
        add_to_point = false
        break
      end
    end
    
    if add_to_point then
      point_enable[point_enable_index] = {x=point.x,y=point.y}
      point_enable_index = point_enable_index + 1
    end
    
    --碰撞盒右下角点
    point.x = collider_group[i].x + collider_group[i].width + move_width/2 + limit
    point.y = collider_group[i].y + collider_group[i].height + move_height/2 + limit
    add_to_point = true  --是否加入可行点列
    move_collider:Updata(point.x, point.y)
    for j=1,#collider_group do
      if move_collider:CheckBox(collider_group[j]) then
        add_to_point = false
        break
      end
    end
    
    if add_to_point then
      point_enable[point_enable_index] = {x=point.x,y=point.y}
      point_enable_index = point_enable_index + 1
    end
    
  end
  
  
  --=====================end-标记出所有可行点======================
  
  --=====================判断起始点到其他可行点的可行路线======================
  route[1] = {} --赋值初始点
  route[1][1] = {x=sx,y=sy}
  local route_len_min = 0
  local s_temp2 = {x=sx,y=sy}  --临时起始点2，用于直线检测
  local e_temp2 = {x=ex,y=ey}  
  
  table.insert(point_enable,{x=ex,y=ey})  --在所有可行点组中加入终点
  
  local point_rest =  {}  --创建还未判断的点table
  for i=1,#point_enable do
    local x = point_enable[i].x
    local y = point_enable[i].y
    point_rest[i]={x=x,y=y}
  end
  
  while 1 do
      
    --如果运行时间大于返回结果时间
    time = love.timer.getTime() - start_time
    if outtime then
      if outtime < time then
        --判断所有路线，如果路线中最后一个点不是终点，就移除
        local route_temp = {}
        for i=1,#route do
          if route[i][#route[i]].x == ex
          and route[i][#route[i]].y == ey
          then
            table.insert(route_temp,route[i])
          end
        end
        route = route_temp
          
        shortest_route = table_copy( route[#route]) --最短路线,为所有符合条件路线组中最后一条
        --清空内存
        point_enable = {} --可行移动点
        route = {}  --存放可行路线
        s_temp = {}  --临时起始点，用于路线检测
        e_temp = {}
        s_temp2 = {}  --临时起始点2，用于直线检测
        e_temp2 = {}  
        point_rest =  {}  --创建还未判断的点table
        if shortest_route == nil then
          shortest_route = {}
        end
        return shortest_route
      end
    end
    
    local index_off = 0 --路线检索偏移
    local index_temp = #route
    s_temp = route[route_index][#route[route_index]]
    for i=1,#point_rest do
      local add_to_route = true --是否加入路线
      e_temp = point_rest[i]
      
      local s_temp2 = {x=s_temp.x,y=s_temp.y}
      local e_temp2 = {x=e_temp.x,y=e_temp.y}
      kx = (e_temp2.y-s_temp2.y)/(e_temp2.x-s_temp2.x)
      ky = 0
      if math.abs(kx) > 1
      then
        --x,y,斜率倒一下
        ky = 1/kx
        s_temp2 = {x=s_temp.y,y=s_temp.x}
        e_temp2 = {x=e_temp.y,y=e_temp.x}
      end
        
      local n_len = math.abs(s_temp2.x-e_temp2.x)+1
      n_len = math.modf(n_len/grid_lenth)
      for n=1,n_len do
        local dx = (n - 1)*grid_lenth
        if e_temp2.x-s_temp2.x < 0 then
          dx = -dx
        end
        local x = 0
        local y = 0
        if math.abs(kx) > 1 then
          y = s_temp2.x + dx
          x = (y - s_temp2.x)*ky + s_temp2.y
        elseif math.abs(kx) <= 1 then
          x = s_temp2.x + dx
          y = (x - s_temp2.x)*kx + s_temp2.y
        end
        move_collider:Updata(x, y)
        
        for j=1,#collider_group do
          if move_collider:CheckBox(collider_group[j]) then
            add_to_route = false
            break
          end
        end
        if add_to_route == false then
          break
        end
        
      end
      if add_to_route then
        if index_off == 0 then
          table.insert(route[route_index],{x=e_temp.x,y=e_temp.y})
        end
        if index_off > 0 then
          route[index_temp+index_off] = table_copy(route[route_index])
          local table_len = #route[index_temp+index_off]
          route[index_temp+index_off][table_len] = {x=e_temp.x,y=e_temp.y}
        end
        index_off = index_off + 1
      end
        
    end
     
    --检测完一条线路
    if index_off == 0 then
      route_index = route_index + 1
    end
      
    while route_len_min > 0 do
      if route[route_index] == nil then
        break
      end
      
      local lenth = 0
      for i=2,#route[route_index] do
        local x1 = route[route_index][i-1].x
        local y1 = route[route_index][i-1].y
        local x2 = route[route_index][i].x
        local y2 = route[route_index][i].y
        lenth = lenth + math.sqrt( (x1-x2)^2+(y1-y2)^2)
      end
      if route_len_min < lenth then
        route[route_index] = {}
        route[route_index][1] = {x=sx,y=sy}
        route_index = route_index + 1
        index_off = 1
      elseif route_len_min >= lenth then
        break
      end
        
    end
     
    --如果此条线路最后一点为终点，检测下一条路线
    if route[route_index] then
      if route[route_index][#route[route_index]].x == ex
        and route[route_index][#route[route_index]].y == ey
        then
        local lenth = 0
        for i=2,#route[route_index] do
          local x1 = route[route_index][i-1].x
          local y1 = route[route_index][i-1].y
          local x2 = route[route_index][i].x
          local y2 = route[route_index][i].y
          lenth = lenth + math.sqrt( (x1-x2)^2+(y1-y2)^2)
        end
        route_len_min = lenth
        route_index = route_index + 1
        --print(route_index-1,"1-----route_len_min",route_len_min)
        index_off = 1
      end
    end
     
     
    while 1 do
      --print("point_rest")
      if route[route_index] == nil then
        break
      end
      
      --检测完一个路线的一个点是否可行，重置剩下需要检测的点组
      point_rest = {}
      for i=1,#point_enable do
        local add = true
        for j=1,#route[route_index] do
          if point_enable[i].x == route[route_index][j].x
            and point_enable[i].y == route[route_index][j].y
          then
            add = false
            
          end
        end
        if add then
          point_rest[#point_rest +1] = {x=point_enable[i].x,y=point_enable[i].y}
        end
      end
      
      --一条由所有可行点组成的路线
      if point_rest == nil then
        route_index = route_index + 1
        index_off = 1
      elseif point_rest then
        break
      end
      
    end
    
    
    --检测完所有
    if route[route_index] == nil then
      --判断所有路线，如果路线中最后一个点不是终点，就移除
      local route_temp = {}
      for i=1,#route do
        if route[i][#route[i]].x == ex
        and route[i][#route[i]].y == ey
        then
          table.insert(route_temp,route[i])
        end
      end
      route = route_temp
      break
    end
    
  end
  
  --=====================end-判断起始点到其他可行点的可行路线======================
  --print("#route",#route)
  --print("route_len_min",route_len_min)
  shortest_route = table_copy( route[#route]) --最短路线,为所有符合条件路线组中最后一条
  --清空内存
  point_enable = {} --可行移动点
  route = {}  --存放可行路线
  s_temp = {}  --临时起始点，用于路线检测
  e_temp = {}
  s_temp2 = {}  --临时起始点2，用于直线检测
  e_temp2 = {}  
  point_rest =  {}  --创建还未判断的点table
  if shortest_route == nil then
    shortest_route = {}
  end
  return shortest_route
  
end

--检查两点直线路线是否可行
function CheckDirectRoute(collider_group,move_collider,sx,sy,ex,ey,ot)
  local grid_lenth = 3 --直线检索单元格长度
  local shortest_route = {} --最短路线
  
  --=====================判断起始点直连路线是否有障碍======================
  local return_route = true
  local s_temp = {x=sx,y=sy}  --临时起始点，用于路线检测
  local e_temp = {x=ex,y=ey}
  local kx = (e_temp.y-s_temp.y)/(e_temp.x-s_temp.x)
  local ky = 0
  if math.abs(kx) > 1 
    --or 0 == e_temp.x-s_temp.x
  then
    ky = 1/kx
    s_temp = {x=sy,y=sx}
    e_temp = {x=ey,y=ex}
  end
  for dx=1,math.abs(s_temp.x-e_temp.x)+1 do
    dx = dx - 1
    if e_temp.x-s_temp.x < 0 then
      dx = -dx
    end
    local x = 0
    local y = 0
    if math.abs(kx) > 1 then
      y = s_temp.x + dx
      x = (y - s_temp.x)*ky + s_temp.y
    elseif math.abs(kx) <= 1 then
      x = s_temp.x + dx
      y = (x - s_temp.x)*kx + s_temp.y
    end
    move_collider:Updata(x, y)
    
    for i=1,#collider_group do
      if move_collider:CheckBox(collider_group[i]) then
        return_route = false
      end
    end
    
  end
  
  if return_route then
    shortest_route[1] = {x=sx,y=sy} --最短路线
    shortest_route[2] = {x=ex,y=ey} --最短路线 
  end
  return shortest_route
  --=====================end-判断起始点直连路线是否有障碍======================
  
end

