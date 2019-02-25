-- @Author: 稻香
-- @Date:   2018-11-14 21:45:13
-- @Last Modified by:   稻香
-- @Last Modified time: 2018-12-09 22:46:21
Kyo_t = class()

function Kyo_t:ctor()
	
	self.debug = Q_debug
	self.screenoff = {x = 0, y = 0} 	--屏幕偏移
	self.colliderbox = CC_ColliderBox.new(0, 0, 40, 20, 20, 10)
	self.x = 700
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
	self.yforce = 0


	self.action = "stand"	--状态
	self.attacking = false
	self.skilling = false
	self.jumping = false

	--用于移动逻辑
	self.LastKey = ""
	self.LstLefKeyTime = 0
	self.LstRigKeyTime = 0
	self.LstUpKeyTime = 0
	self.LstDowKeyTime = 0


	self.shuxing = 
	{
	Name = "keke",
	ZhiYe = "Kyo",

	WeapponType = "LargeSword",
	UpKey = "up", --87, --"w",
	DownKey = "down", --83, --"s",
	LeftKey = "left", --65, --"a",
	RightKey = "right", --68, --"d",
	Attack1Key = "1", --74, --"j",
	JumpKey = "2", --75, --"k",
	Attack2Key = "3", --76,"l",

	HP = 100,
	maxHP = 100,
	MP = 100,
	maxMP = 100,
	MoveSpeed = 100,
	MoveSpeedRate = 100,

	AttackSpeedRate = 0,

	}

	self.SoundGroup = {
	attack1 = love.audio.newSource("data/sound/yiya1_10-5.wav", "stream"),

	attack2 = love.audio.newSource("data/sound/yiya1_10-5.wav", "stream"),
	BeAttacked = love.audio.newSource("data/sound/quandaji1_1-0.wav", "stream"),

	walk = love.audio.newSource("data/sound/GroundSound/pub_wrk_01.wav", "stream"),
	run = love.audio.newSource("data/sound/GroundSound/pub_run_01.wav", "stream")

	}

	self.Avatar = {}
	self.Avatar[1] = { place = "body",sprfram = {} }

	self.Avatar[1].sprfram["stand"] = CC_SpriteFrame.new("data/renwu/stand/stand.txt") --stand/stand.txt
	self.Avatar[1].sprfram["stand"].snSpeed = 2

	self.Avatar[1].sprfram["walk"] = CC_SpriteFrame.new("data/renwu/walk/testtxt.txt")
	self.Avatar[1].sprfram["walk"].snSpeed = 10

	self.Avatar[1].sprfram["run"] = CC_SpriteFrame.new("data/renwu/run/run.txt")
	self.Avatar[1].sprfram["run"].snSpeed = 10

	self.Avatar[1].sprfram["attack2"] = CC_SpriteFrame.new("data/renwu/XieShangTi/XieShangTi.txt")
	self.Avatar[1].sprfram["attack2"].snSpeed = 12

end

function Kyo_t:Updata(dt)
	-- body
	self.debug = Q_debug

	self.lx = self.x
	self.ly = self.y

	self:ReactLogic(dt)

	self:MoveLogic(dt)

	--self:JumpLogic()

	self:AttackLogic()

	--self:SkillLogic()

	
	self.lastsn = self.Avatar[1].sprfram[self.action].sn
	self.Avatar[1].sprfram[self.action]:Updata(dt,self.x, self.y  + self.FloatYoff, self.dir, 1, self.rotation)

	--攻击检测碰撞盒
	self.Attackbox = self.Avatar[1].sprfram[self.action].colliderbox

	--位置检测碰撞盒更新
	self.colliderbox:Updata(self.x, self.y, 40, 20, 20, 10, self.dir, 1)

end

function Kyo_t:Show()
	-- body
	self.colliderbox:Updata(self.x, self.y, 40, 20, 20, 10, self.dir, 1)
	self.Avatar[1].sprfram[self.action]:Set(self.x, self.y, self.dir, 1, 0)

	self.Avatar[1].sprfram[self.action]:Show(self.screenoff.x, self.screenoff.y + self.FloatYoff)

	if self.debug == true then
		love.graphics.circle("fill", self.x + self.screenoff.x, self.y + self.screenoff.y, 2, 5)--用100段画白色圆
		self.Avatar[1].sprfram[self.action].colliderbox:Show(red, self.screenoff.x, self.screenoff.y)
		self.colliderbox:Show(red, self.screenoff.x, self.screenoff.y)
	end

end



function Kyo_t:MoveLogic(dt)
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


--对当前状态的反应逻辑
function Kyo_t:ReactLogic(dt)
	-- body
	if GetKeyPressEvent(self.shuxing.UpKey) == false 
		and GetKeyPressEvent(self.shuxing.DownKey) == false 
		and GetKeyPressEvent(self.shuxing.RightKey) == false 
		and GetKeyPressEvent(self.shuxing.LeftKey) == false 
		and self.attacking == false
		and self.skilling == false
		then

		self:ChangeAction("stand")
	end

	if self.floating then
		self.yforce = self.yforce  - 15*dt


		self.FloatYoff = self.FloatYoff - self.yforce*dt*100 --y轴方向朝下
		self:XMove(dt,self.xforce)

		if(self.FloatYoff >= 0) then
			--self:改变动作("被攻击_空中_落地")				
			self.FloatYoff = 0
			self.floating = false
			self.xforce = 0
			self.yforce = 0
		end

	end

end


function Kyo_t:AttackLogic()

	if GetKeyPress(self.shuxing.Attack1Key) 
		then
		self.attacking = true
		if self.action ~= "attack1" then

			--self:ChangeAction("attack1")
		end
		
	end

	if GetKeyPress(self.shuxing.Attack2Key) 
		then
		self.attacking = true
		self:ChangeAction("attack2")
		
	end

	--判断攻击动作是否结束，结束后改变动作为"stand"
	if self.attacking then
		--print(self.lastsn,self.Avatar[1].sprfram[self.action].sn) ---------------------------
		if self.lastsn == #self.Avatar[1].sprfram[self.action].frame
			and self.Avatar[1].sprfram[self.action].sn == 1
			then
			self:ChangeAction("stand")
			self.attacking = false
		end
	end


end


function Kyo_t:ChangeAction(action)
	-- body
	if self.action ~= action then
		self.action = action
		self.Avatar[1].sprfram[self.action]:Reset()

		if self.action == "attack2" then
			self.SoundGroup["attack2"]:play()
		end


	end
end

--x轴移动
function Kyo_t:XMove(dt, xforce)

	self.deltax = (dt*7)*self.XSpeed*xforce*(self.shuxing.MoveSpeed)*(1 + self.shuxing.MoveSpeedRate/100)
	
	if self.action == "run" then
		self.deltax = self.deltax*(1 + self.RunSpeedRate/100) 	--附加奔跑速率
		self.x = self.x + self.deltax
	elseif self.action ~= "run" then
		self.x = self.x + self.deltax
	end
end


--y轴移动,不改变角色显示方向
function Kyo_t:YMove(dt, ydir)
	self.deltay = (dt*7)*self.YSpeed*ydir*(self.shuxing.MoveSpeed)*(1 + self.shuxing.MoveSpeedRate/100)
	self.y = self.y + self.deltay
end

--被击中并浮空（x方向力，x方向力，特效类型，攻击属性）
function Kyo_t:BeAttackedUp(dt, xforce, yforce, effecttype,attackYuansu)

	self.floating = true
	self.xforce = xforce
	self.yforce = yforce
	self.SoundGroup["BeAttacked"]:play()

end