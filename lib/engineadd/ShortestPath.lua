require("lib.engineadd.CC_ColliderBox")	--创建碰撞盒
--require("lib.CC_engineadd")

--function ReturnCollidedLine(colbox1,colbox2) 和
--function table_copy(ori_tab) 在lib.CC_engineadd中

--获取最短路线,Dijkstra算法
--第四版 2019.4.6

huge = math.huge
--初始化可行点转移矩阵
function trans_matrix_init(collider_group,move_collider,point_enable)
  
  --point_enable = {} --可行移动点
  local point_enable_index = 1
  local move_width = move_collider.width
  local move_height = move_collider.height
  local limit = 2 --标定各障碍物四角坐标，需要留的阈值
  
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
  
  --创建转移矩阵并初始化
  trans_matrix = {}
  route = {}  --存放可行路线
    
  --创建空矩阵
  for i=1,#point_enable do
    trans_matrix[i] = {}
    route[i] = {}
    for j=1,#point_enable do
      trans_matrix[i][j] = huge
      route[i][j] = {}  --存放i点到j点的路线
        
    end
  end
  
  
  for i=1,#point_enable do
    for j=i+1,#point_enable do
      local sx = point_enable[i].x
      local sy = point_enable[i].y
      local ex = point_enable[j].x
      local ey = point_enable[j].y
      if JudgeLine(collider_group,move_collider, sx, sy, ex, ey) then
        trans_matrix[i][j] = math.sqrt( (ex-sx)^2+(ey-sy)^2)
        route[i][j] = {i,j}
          
        --反向距离及路线
        trans_matrix[j][i] = math.sqrt( (ex-sx)^2+(ey-sy)^2)
        route[j][i] = {j,i}
      end
    end
  end
    
    
  --点到点使用Dijkstra算法得到最短路径和距离
  local start_point = 1 --起始点
  local base_point = 2 --以此为源点
  local remain_point_group = {} --还未检索的点
  for i=2,#trans_matrix do
    remain_point_group[i-1] = i
  end
    
  --print("#trans_matrix",#trans_matrix)--------------------------------------------------
    
  local loop_num = 1 --循环次数
  while 1 do
    
    while 1 do
        
      local nearest_point = base_point --存放离源点最近的点
      --找出下一源点
      for i=1,#remain_point_group do
        if trans_matrix[base_point][(remain_point_group[i])] < trans_matrix[base_point][nearest_point] then
          nearest_point = remain_point_group[i]
        end
      end
        
      if nearest_point ~= base_point then
        base_point = nearest_point
      elseif nearest_point == base_point then
        base_point = remain_point_group[1]
      end
        
      --更新remain_point_group
      local remain_point_group_temp = {}
      local index_temp = 1
      for i=1,#remain_point_group do
        if remain_point_group[i] ~= base_point then
          remain_point_group_temp[index_temp] = remain_point_group[i]
          index_temp = index_temp + 1
        end
      end
      --更新转移矩阵及最短路线矩阵
      for i=1,#trans_matrix do
        if i ~= base_point and
          i ~= start_point
        then
          --更新转移矩阵及最短路线矩阵
          if trans_matrix[start_point][base_point] + trans_matrix[base_point][i]
            < trans_matrix[start_point][i]
            then
            --转移矩阵
            trans_matrix[start_point][i] = 
            trans_matrix[start_point][base_point] + trans_matrix[base_point][i]
            --最短路线
            route[start_point][i] = {} --先清空
            local len_route = #route[start_point][base_point]
            for j=1,len_route do
              route[start_point][i][j] = route[start_point][base_point][j]
            end
              
            --拼接路线后半段
            for j=1,#route[base_point][i] do
              route[start_point][i][len_route+j-1] = route[base_point][i][j]
                
            end
          end
        end
          
      end
        
      remain_point_group = remain_point_group_temp
      
      --print("base_point",base_point)-------------------
        
      if #remain_point_group == 1 then
        base_point = start_point
        local index_temp = 1
        for i=1,#trans_matrix do
          if i ~= start_point then
            remain_point_group[index_temp] = i
            index_temp = index_temp +1
          end
        end
          
        --更新反向转移矩阵和路线
        for i=1,#trans_matrix do
          trans_matrix[i][start_point] = trans_matrix[start_point][i]
          route[i][start_point] = {} --先清空
          for j=1,#route[start_point][i] do
            local len_temp = #route[start_point][i]
            route[i][start_point][j] = route[start_point][i][len_temp-j+1] 
          end
        end
          
        --break
        
        loop_num = loop_num +1
        if loop_num ==5 then
          loop_num = 1
          break
        end
        
      end
        
    end
      
    start_point = start_point + 1
    base_point = start_point
    local index_temp = 1
    for i=1,#trans_matrix do
      if i ~= start_point then
        remain_point_group[index_temp] = i
        index_temp = index_temp +1
      end
    end
      
    local end_point = math.modf(#trans_matrix/2) + 1--停止检索点
    if #trans_matrix%2 == 0 then
      end_point = #trans_matrix/2
    end
    --if start_point > end_point then
    if start_point > #trans_matrix then
      start_point = 1
       
      --[[
      loop_num = loop_num +1
      if loop_num ==5 then
        break
      end
      ]]
      break
        
    end
  end
  return route
  
  
  
  
end


--判断起始点直连路线是否有障碍
function JudgeLine(collider_group,move_collider, sx, sy, ex, ey)
  
  local walkable = true --是否可行
  local s_temp = {x=sx,y=sy}  --临时起始点，用于路线检测
  local e_temp = {x=ex,y=ey}
  local kx = (e_temp.y-s_temp.y)/(e_temp.x-s_temp.x)
  local ky = 0
  if math.abs(kx) > 1
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
        walkable = false
        return walkable
      end
    end
      
  end
    
  return walkable
    
end



function GetMINRoute(collider_group,move_collider,point_enable,trans_matrix,route,sx,sy,ex,ey,ot)
  local outtime = ot or nil  --出结果时间
  local time = 0
  local start_time = love.timer.getTime() --运行时间
    
  local route_index = 1
  local shortest_route = {} --最短路线
  local route_distance = huge
  local start_point_group = {} --可行开始点组
  local end_point_group = {}
  local point_group_index = 1
  local start_point = 1 --可行点中开始点
  local end_point = 1
  local distance_sm_group = {} --开始点到路线中间点距离
  local distance_me_group = {} --路线中间点到结束点距离
  
  local ret_or_not = false --是否返回最短路线
    
    
  --如果起点和终点连线，没有接触障碍，直接返回
  if JudgeLine(collider_group,move_collider, sx, sy, ex, ey) then
      shortest_route[1] = {}
      shortest_route[1].x = sx
      shortest_route[1].y = sy
        
      shortest_route[2] = {}
      shortest_route[2].x = ex
      shortest_route[2].y = ey
        
      return shortest_route
  end
    
  --找到可行开始点组和可行结束点组
  for i=1,#trans_matrix do
    local mx = point_enable[i].x
    local my = point_enable[i].y  --中间点
    if JudgeLine(collider_group,move_collider,sx,sy,mx,my) then
      start_point_group[point_group_index] = i
      distance_sm_group[point_group_index] = math.sqrt( (mx-sx)^2+(my-sy)^2)
      point_group_index = point_group_index + 1
    end
  end
  point_group_index = 1
  for i=1,#trans_matrix do
    local mx = point_enable[i].x
    local my = point_enable[i].y  --中间点
    if JudgeLine(collider_group,move_collider,ex,ey,mx,my) then
      end_point_group[point_group_index] = i
      distance_me_group[point_group_index] = math.sqrt( (ex-mx)^2+(ey-my)^2)
      point_group_index = point_group_index + 1
    end
  end
    
  --如果在可行开始点组和可行结束点组中，存在相同点，返回最短路线
  for i=1,#start_point_group do
    for j=1,#end_point_group do
      local i_temp = start_point_group[i] --start_point_group[i]中临时点
      local j_temp = end_point_group[j]
      if i_temp == j_temp then
        ret_or_not = true --可以待检索完所有中间点后返回路线
        if distance_sm_group[i] + distance_me_group[j]
          < route_distance
          then
          route_distance = distance_sm_group[i] + distance_me_group[j]
          start_point = i_temp
        end
          
      end
    end
  end
    
  if ret_or_not then
    shortest_route[1] = {}
    shortest_route[1].x = sx
    shortest_route[1].y = sy
      
    shortest_route[2] = {}
    shortest_route[2].x = point_enable[start_point].x
    shortest_route[2].y = point_enable[start_point].y
      
    shortest_route[3] = {}
    shortest_route[3].x = ex
    shortest_route[3].y = ey
      
    return shortest_route
  end
    
  --找出最短路径
  for i=1,#start_point_group do
    for j=1,#end_point_group do
      local i_temp = start_point_group[i] --start_point_group[i]中临时点
      local j_temp = end_point_group[j]
      local distance_sm = distance_sm_group[i] --开始点到此中间点距离
      local distance_me = distance_me_group[j]
      if distance_sm + trans_matrix[i_temp][j_temp] + distance_me
        < route_distance 
        then
        route_distance = distance_sm + trans_matrix[i_temp][j_temp] + distance_me
        start_point = i_temp
        end_point = j_temp
        
      end
        
    end
      
  end
    
  shortest_route[1] = {}
  shortest_route[1].x = sx
  shortest_route[1].y = sy
    
  --print("[start_point][end_point]",start_point,end_point) -------------------------------------
  for i=1,#route[start_point][end_point] do
    local n = route[start_point][end_point][i]
    shortest_route[i+1] = {}
    shortest_route[i+1].x = point_enable[n].x
    shortest_route[i+1].y = point_enable[n].y
  end
  local len_temp = #shortest_route
  shortest_route[len_temp+1] = {}
  shortest_route[len_temp+1].x = ex
  shortest_route[len_temp+1].y = ey
    
    
  return shortest_route
  
end