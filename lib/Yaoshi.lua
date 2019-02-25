-- @Author: 稻香
-- @Date:   2018-12-21 13:54:31
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-12-21 15:27:44
--药师

Yaoshi = class()

function Yaoshi:ctor()
	
	self.debug = Q_debug
	self.ispuppet = false
	self.screenoff = {x = 0, y = 0} 	--屏幕偏移
	self.colliderbox = CC_ColliderBox.new(0, 0, 40, 20, 20, 10)
	
	self.AttackBox = {} 	--攻击检测碰撞盒
	self.ActionFramSn = 0 	--当前动作播放到的帧数

	self.x = 500
	self.y = 200
	self.lx = 400	--上次x
	self.ly = 400
	self.lastsn = 1 	--动作上次的帧
	self.dir = 1
	self.rotation = 0 	--度
	self.XSpeed = 23/100 	--x轴移动速度
	self.YSpeed = 15/100 	--y轴移动速度
	self.deltax = 0 	--x轴移动差值，随dt变化
	self.deltay = 0
	self.RunSpeedRate = 30 	--奔跑移动速度增加率，%

	self.FloatYoff = 0 	--浮空y偏移
	self.floating = false --是否浮空
	self.xforce = 0 	--x方向受力
	self.yforce0 = 0 	--初始y方向力，用于判断空中状态
	self.yforce = 0

	self.action = "stand"	--状态
	self.attacking = false
	self.skilling = false
	self.jumping = false
	self.lying = false 	--是否躺地
	self.lyingtime = 0 	--躺地时间

	--用于移动逻辑
	self.LastKey = ""
	self.LstLefKeyTime = 0
	self.LstRigKeyTime = 0
	self.LstUpKeyTime = 0
	self.LstDowKeyTime = 0


	self.shuxing = 
	{
	Name = "keke",
	ZhiYe = "Yaoshi",

	WeapponType = "LargeSword",
	UpKey = "w", --87, --"w",
	DownKey = "s", --83, --"s",
	LeftKey = "a", --65, --"a",
	RightKey = "d", --68, --"d",
	Attack1Key = "j", --74, --"j",
	JumpKey = "k", --75, --"k",
	Attack2Key = "l", --76,"l",

	HP = 100,
	maxHP = 100,
	MP = 100,
	maxMP = 100,
	MoveSpeed = 100,
	MoveSpeedRate = 100,

	AttackSpeedRate = 0,

	}

	self.SoundGroup = {
	attack1 = love.audio.newSource("data/sound/attack1_12-0.wav", "stream"),

	attack2 = love.audio.newSource("data/sound/attack1_12-0.wav", "stream"),
	BeAttacked = love.audio.newSource("data/sound/quandaji1_1-0.wav", "stream"),

	walk = love.audio.newSource("data/sound/GroundSound/pub_wrk_01.wav", "stream"),
	run = love.audio.newSource("data/sound/GroundSound/pub_run_01.wav", "stream")

	}

	self.Avatar = {}
	self.Avatar[1] = { place = "body",sprfram = {} }

	self.Avatar[1].sprfram["stand"] = CC_SpriteFrame.new("data/character/yaoshi/0stand/stand.txt") --stand/stand.txt
	self.Avatar[1].sprfram["stand"].snSpeed = 4

	self.Avatar[1].sprfram["walk"] = CC_SpriteFrame.new("data/character/yaoshi/20walk/walk.txt")
	self.Avatar[1].sprfram["walk"].snSpeed = 10
	self.Avatar[1].sprfram["walk"].xflip = -1 	--需要x翻转

	self.Avatar[1].sprfram["run"] = CC_SpriteFrame.new("data/character/yaoshi/100run/run.txt")
	self.Avatar[1].sprfram["run"].snSpeed = 10
	self.Avatar[1].sprfram["run"].xflip = -1

	self.Avatar[1].sprfram["attack1"] = CC_SpriteFrame.new("data/character/yaoshi/200attack/attack_-.txt")
	self.Avatar[1].sprfram["attack1"].snSpeed = 12

	self.Avatar[1].sprfram["attack2"] = CC_SpriteFrame.new("data/character/yaoshi/250shang ti/shang ti.txt")
	self.Avatar[1].sprfram["attack2"].snSpeed = 10

	--------------跳跃--------------
	self.Avatar[1].sprfram["jump_ready"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_ready.txt")
	self.Avatar[1].sprfram["jump_ready"].snSpeed = 10

	self.Avatar[1].sprfram["jump_up"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_up.txt")
	self.Avatar[1].sprfram["jump_up"].snSpeed = 10

	self.Avatar[1].sprfram["jump_top"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_top.txt")
	self.Avatar[1].sprfram["jump_top"].snSpeed = 10

	self.Avatar[1].sprfram["jump_down"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["jump_down"].snSpeed = 10

	--------------被击--------------
	self.Avatar[1].sprfram["beattacked"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["beattacked"].snSpeed = 10

	self.Avatar[1].sprfram["beattacked_fly_up1"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["beattacked_fly_up1"].snSpeed = 10

	self.Avatar[1].sprfram["beattacked_fly_up2"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["beattacked_fly_up2"].snSpeed = 10

	self.Avatar[1].sprfram["beattacked_fly_top"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["beattacked_fly_top"].snSpeed = 10

	self.Avatar[1].sprfram["beattacked_fly_down"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["beattacked_fly_down"].snSpeed = 10

	self.Avatar[1].sprfram["beattacked_grabbed"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["beattacked_grabbed"].snSpeed = 10
	--------------------------------------------

	self.Avatar[1].sprfram["lying"] = CC_SpriteFrame.new("data/character/yaoshi/40jump/jump_down.txt")
	self.Avatar[1].sprfram["lying"].snSpeed = 10


end

function Yaoshi:Updata(dt)
	-- body
	self.debug = Q_debug

	self.lx = self.x
	self.ly = self.y

	self:ReactLogic(dt)

	--是否是人偶
	if self.ispuppet == false then
		self:MoveLogic(dt)

		self:JumpLogic()

		self:AttackLogic()

		--self:SkillLogic()
	end

	
	self.lastsn = self.Avatar[1].sprfram[self.action].sn
	self.Avatar[1].sprfram[self.action]:Updata(dt,self.x, self.y  + self.FloatYoff, self.dir, 1, self.rotation)

	self.ActionFramSn = self.Avatar[1].sprfram[self.action].sn
	--攻击检测碰撞盒
	self.Attackbox = self.Avatar[1].sprfram[self.action].colliderbox

	--位置检测碰撞盒更新
	self.colliderbox:Updata(self.x, self.y, 40, 20, 20, 10, self.dir, 1)

end

function Yaoshi:Show(offx, offy)
	--print("self.action:",self.action,self.Avatar[1].sprfram[self.action].sn)
	-- body
	self.colliderbox:Updata(self.x, self.y, 40, 20, 20, 10, self.dir*0.5, 1*0.5) --角色位置碰撞盒

	self.Avatar[1].sprfram[self.action]:Set(self.x, self.y  + self.FloatYoff, self.dir*0.5, 1*0.5, 0)
	self.Avatar[1].sprfram[self.action]:Show(offx, offy)

	if self.debug == true then
		love.graphics.circle("fill", self.x + offx, self.y + offy, 2, 5)--用100段画白色圆
		self.Avatar[1].sprfram[self.action].colliderbox:Show(red, offx, offy)
		self.colliderbox:Show(red, offx, offy)

	end

end



function Yaoshi:MoveLogic(dt)
	-- body
	if not self.attacking
		and not self.skilling
		then

		--非跳跃状态下，状态检测
		if not self.jumping then
			--左键是否奔跑检测
			if GetKeyPress(self.shuxing.LeftKey) then

				if self.LastKey ~= self.shuxing.LeftKey then
					--如果上次按下的键不是 左键
					self:ChangeAction("walk")
					else --如果上次按下的键是 左键
					if  love.timer.getTime() - self.LstLefKeyTime < 0.3 
						then
						self:ChangeAction("run")
					end
					if	love.timer.getTime() - self.LstLefKeyTime >= 0.3
						then
						self:ChangeAction("walk")
					end
				end

				self.LstLefKeyTime = love.timer.getTime()
				self.LastKey = self.shuxing.LeftKey
			end

			--右键是否奔跑检测
			if GetKeyPress(self.shuxing.RightKey) then
				
				if self.LastKey ~= self.shuxing.RightKey then
					--如果上次按下的键不是 you键
					self:ChangeAction("walk")
				else --如果上次按下的键是 you键	
					if  love.timer.getTime() - self.LstRigKeyTime < 0.3 
						then
						self:ChangeAction("run")
					end
					if	love.timer.getTime() - self.LstRigKeyTime >= 0.3
						then
						self:ChangeAction("walk")
					end
				end

				self.LstRigKeyTime = love.timer.getTime()
				self.LastKey = self.shuxing.RightKey
			end
			--检测上次上下键
			if GetKeyPress(self.shuxing.UpKey) then
				self.LastKey = self.shuxing.UpKey
			end
			if GetKeyPress(self.shuxing.DownKey) then
				self.LastKey = self.shuxing.DownKey
			end

		end

		--上下键判断逻辑
		--控制纵轴移动
		--如果上键按下，下键未按下
		if GetKeyPressEvent(self.shuxing.UpKey) and GetKeyPressEvent(self.shuxing.DownKey) == false
			then
			if self.action ~= "run" and self.jumping == false then
				self:ChangeAction("walk")
			end

			self:YMove(dt,-1)
			self.LastKey = self.shuxing.UpKey			
		--如果上键未按下，下键按下			
		elseif GetKeyPressEvent(self.shuxing.UpKey) == false and GetKeyPressEvent(self.shuxing.DownKey)
			then
			if self.action ~= "run" and self.jumping == false then
				self:ChangeAction("walk")
			end

			self:YMove(dt,1)
			self.LastKey = self.shuxing.DownKey
		--如果上键按下，下键按下	
		elseif GetKeyPressEvent(self.shuxing.UpKey) and GetKeyPressEvent(self.shuxing.DownKey)
			then
			if self.action ~= "run" and self.jumping == false then
				self:ChangeAction("walk")
			end

			if self.LastKey == self.shuxing.UpKey then
				self:YMove(dt,-1)
			end
			if self.LastKey == self.shuxing.DownKey then
				self:YMove(dt,1)
			end		
		end


		--左右键判断逻辑
		--控制横轴移动
		--如果左键按下，右键未按下
		if GetKeyPressEvent(self.shuxing.LeftKey) and GetKeyPressEvent(self.shuxing.RightKey) == false
			then
			if self.action ~= "run" and self.jumping == false then
				self:ChangeAction("walk")
			end

			if self.action ~= "jumpattack" then
				self.dir = -1
			end
			self:XMove(dt, self.dir)
			self.LastKey = self.shuxing.LeftKey			
		--如果zuo键未按下，you键按下			
		elseif GetKeyPressEvent(self.shuxing.LeftKey) == false and GetKeyPressEvent(self.shuxing.RightKey)
			then
			if self.action ~= "run" and self.jumping == false then
				self:ChangeAction("walk")
			end

			if self.action ~= "jumpattack" then
				self.dir = 1
			end
			self:XMove(dt, self.dir)
			self.LastKey = self.shuxing.RightKey
			--如果左键按下，右键按下
		elseif GetKeyPressEvent(self.shuxing.LeftKey) and GetKeyPressEvent(self.shuxing.RightKey)
			then
			if self.action ~= "run" and self.jumping == false then
				self:ChangeAction("walk")
			end

			if self.action ~= "jumpattack" then
				if self.LastKey == self.shuxing.LeftKey then
					self.dir = -1
				elseif self.LastKey == self.shuxing.RightKey then
					self.dir = 1
				end
			end
			self:XMove(dt, self.dir)
		end
	end

	--根据状态播放音效
	if self.action == "walk" then
		if(self.SoundGroup["walk"]:isPlaying() == false) then
			self.SoundGroup["walk"]:play()
		end
	end
	if self.action == "run" then
		if(self.SoundGroup["run"]:isPlaying() == false) then
			self.SoundGroup["run"]:play()
		end
	end


end


--跳跃逻辑
function Yaoshi:JumpLogic()
	if not self.skilling
		and not self.attacking
		and not self.jumping
		then
		if GetKeyPress(self.shuxing.JumpKey) 
			then
			self.jumping = true
			self:ChangeAction("jump_ready")
			self.jumping = false
		end


	end

end


--对当前状态的反应逻辑
function Yaoshi:ReactLogic(dt)
	-- body
	if GetKeyPressEvent(self.shuxing.UpKey) == false 
		and GetKeyPressEvent(self.shuxing.DownKey) == false 
		and GetKeyPressEvent(self.shuxing.RightKey) == false 
		and GetKeyPressEvent(self.shuxing.LeftKey) == false 
		and self.attacking == false
		and self.skilling == false
		and self.floating == false
		and self.lying == false
		then

		self:ChangeAction("stand")
	end

	--如果浮空，单纯计算显示的浮空位置偏差
	if self.floating then
		self.yforce = self.yforce  - 15*dt

		self.FloatYoff = self.FloatYoff - self.yforce*dt*100 --y轴方向朝下
		self:XMove(dt,self.xforce)

		if(self.FloatYoff >= 0) then	
			self.FloatYoff = 0
			self.floating = false
			self.xforce = 0
			self.yforce = 0
		end	
	end

	--如果处于浮空，并且被击中，根据浮空位置判断状态
	if self.floating then
		if self.action ==  "beattacked_fly_up1"
			and self.yforce < self.yforce0*0.5
			then
			self:ChangeAction("beattacked_fly_up2")
		end

		if self.action ==  "beattacked_fly_up2"
			and self.yforce < 0
			then
			self:ChangeAction("beattacked_fly_top")
		end

		if self.action ==  "beattacked_fly_top"
			and self.yforce < -self.yforce0*0.5
			then
			--self:ChangeAction("beattacked_fly_down")
		end
	
	end	

	if self.action ==  "beattacked_fly_top"
		and self.FloatYoff >= 0 then

		self.lying = true
		self:ChangeAction("lying")
	end

	if self.lying then
		self.lyingtime = self.lyingtime + dt

		if self.lyingtime > 0.5 then
			self.lyingtime = 0
			self.lying = false
		end

	end



end


function Yaoshi:AttackLogic()

	if GetKeyPress(self.shuxing.Attack1Key) 
		then
		self.attacking = true
		if self.action ~= "attack1" then

			self:ChangeAction("attack1")
		end
		
	end

	if GetKeyPress(self.shuxing.Attack2Key) 
		then
		self.attacking = true
		self:ChangeAction("attack2")
		
	end

	--判断攻击动作是否结束，结束后改变动作为"stand"
	if self.attacking then
		--print(self.lastsn,self.Avatar[1].sprfram[self.action].sn) --------------------------------
		if self.lastsn == #self.Avatar[1].sprfram[self.action].frame
			and self.Avatar[1].sprfram[self.action].sn == 1
			then
			self:ChangeAction("stand")
			self.attacking = false
		end
	end


end


function Yaoshi:ChangeAction(action)
	-- body
	if self.action ~= action then
		self.action = action
		self.Avatar[1].sprfram[self.action]:Reset()

		if self.action == "attack2" then
			self.SoundGroup["attack2"]:play()
		end

		if self.action == "attack1" then
			self.SoundGroup["attack1"]:play()
		end


	end
end

--x轴移动
function Yaoshi:XMove(dt, xforce)

	self.deltax = (dt*7)*self.XSpeed*xforce*(self.shuxing.MoveSpeed)*(1 + self.shuxing.MoveSpeedRate/100)
	
	if self.action == "run" then
		self.deltax = self.deltax*(1 + self.RunSpeedRate/100) 	--附加奔跑速率
		self.x = self.x + self.deltax
	elseif self.action ~= "run" then
		self.x = self.x + self.deltax
	end
end


--y轴移动,不改变角色显示方向
function Yaoshi:YMove(dt, ydir)
	self.deltay = (dt*7)*self.YSpeed*ydir*(self.shuxing.MoveSpeed)*(1 + self.shuxing.MoveSpeedRate/100)
	self.y = self.y + self.deltay
end


--被击中并浮空（x方向力，x方向力，特效类型，攻击属性）
function Yaoshi:BeAttackedUp(dt, xforce, yforce, effecttype,attackYuansu)

	self.floating = true
	self:ChangeAction("beattacked_fly_up1")
	self.xforce = xforce
	self.yforce0 = yforce 	--初始y方向力，用于判断空中状态
	self.yforce = yforce
	self.SoundGroup["BeAttacked"]:play()

end