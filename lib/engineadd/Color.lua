Color = {}
--- @title 中国传统色彩表
--- @see 红色系 粉红 妃色 品红 桃红 海棠 石榴 樱桃 银红 大红 绛紫 绯红 胭脂 朱红 丹色 彤色 茜色 火红 赫赤 嫣红 洋红 炎色 赤色 绾色 枣红 檀色 殷红 酡红 酡颜
--- @see 黄色系 鹅黄 鸭黄 樱草 杏黄 杏红 橘黄 橙黄 橘红 姜黄 缃色 橙色 茶色 驼色 昏黄 栗色 棕色 棕绿 棕黑 棕红 棕黄 赭色 赭色 琥珀 褐色 枯黄 黄栌 秋色 秋香
--- @see 绿色系 嫩绿 柳黄 柳绿 竹青 葱黄 葱绿 葱青 葱倩 青葱 油绿 绿沈 碧色 碧绿 青碧 翡翠 草绿 青色 青翠 青白 鸭卵 蟹壳 鸦青 绿色 豆绿 豆青 石青 玉色 缥色 艾绿 松柏 松花 松花
--- @see 蓝色系 靛青 靛蓝 碧蓝 蔚蓝 宝蓝 蓝灰 藏青 藏蓝 黛色 黛螺 黛色 黛绿 黛蓝 黛紫 紫色 紫酱 酱紫 紫檀 绀青 紫棠 青莲 群青 雪青 丁香 藕色 藕荷
--- @see 苍色系 苍翠 苍黄 苍青 苍黑 苍白
--- @see 水色系 水红 水绿 水蓝 淡青 湖蓝 湖绿
--- @see 灰白系 精白 象牙 雪白 月白 缟色 素色 荼白 霜色 花白 鱼肚 莹白 灰色 牙色 铅白
--- @see 黑色系 玄色 玄青 乌色 乌黑 漆黑 墨色 墨灰 黑色 缁色 煤黑 黧色 黎色 黝色 黝黑 黯色
--- @see 金银系 赤金 金色 银色 铜绿 乌金 老银
---
---
--- @see 红色系
Color["粉红"]={1,0.702,0.655}		--- @see 粉红，即浅红色。别称：妃色 杨妃色 湘妃色 妃红色
Color["妃色"]={0.929,0.341,0.212}	--- @see 妃色 妃红色：古同"绯"，粉红色。杨妃色 湘妃色 粉红皆同义。
Color["品红"]={0.941,0,0.337}		--- @see 品红：比大红浅的红色（quester注：这里的"品红"估计是指的"一品红"，是基于大红色系的，和现在我们印刷用色的"品红M100"不是一个概念）
Color["桃红"]={0.957,0.475,0.514}	--- @see 桃红，桃花的颜色，比粉红略鲜润的颜色。（quester注：不大于M70的色彩，有时可加入适量黄色）
Color["海棠"]={0.859,0.353,0.42}	--- @see 海棠红，淡紫红色、较桃红色深一些，是非常妩媚娇艳的颜色。
Color["石榴"]={0.949,0.047,0}		--- @see 石榴红：石榴花的颜色，高色度和纯度的红色。
Color["樱桃"]={0.788,0.216,0.337}	--- @see 樱桃色：鲜红色
Color["银红"]={0.941,0.337,0.329}	--- @see 银红：银朱和粉红色颜料配成的颜色。多用来形容有光泽的各种红色，尤指有光泽浅红。
Color["大红"]={1,0.129,0.129}		--- @see 大红：正红色，三原色中的红，传统的中国红，又称绛色（quester注：RGB 色中的 R255 系列明度）
Color["绛紫"]={0.549,0.263,0.337}	--- @see 绛紫：紫中略带红的颜色
Color["绯红"]={0.784,0.235,0.137}	--- @see 绯红：艳丽的深红
Color["胭脂"]={0.616,0.161,0.2}		--- @see 胭脂：1，女子装扮时用的胭脂的颜色。2，国画暗红色颜料
Color["朱红"]={1,0.298,0}			--- @see 朱红：朱砂的颜色，比大红活泼，也称铅朱 朱色 丹色（quester注：在YM对等的情况下，适量减少红色的成分就是该色的色彩系列感觉）
Color["丹色"]={1,0.306,0.125}		--- @see 丹：丹砂的鲜艳红色
Color["彤色"]={0.953,0.325,0.212}	--- @see 彤：赤色
Color["茜色"]={0.796,0.227,0.337}	--- @see 茜色：茜草染的色彩，呈深红色
Color["火红"]={1,0.176,0.318}		--- @see 火红：火焰的红色，赤色
Color["赫赤"]={0.788,0.122,0.216}	--- @see 赫赤：深红，火红。泛指赤色、火红色。
Color["嫣红"]={0.937,0.478,0.51}	--- @see 嫣红：鲜艳的红色
Color["洋红"]={1,0,0.592}			--- @see 洋红：色橘红（quester注：这个色彩方向不太对，通常洋红指的是倾向于M100系列的红色，应该削弱黄色成分。）
Color["炎色"]={1,0.2,0}				--- @see 炎：引申为红色。
Color["赤色"]={0.765,0.153,0.169}	--- @see 赤：本义火的颜色，即红色
Color["绾色"]={0.663,0.506,0.459}	--- @see 绾：绛色；浅绛色。
Color["枣红"]={0.765,0.129,0.212}	--- @see 枣红：即深红（quester注：色相不变，是深浅变化）
Color["檀色"]={0.702,0.427,0.38}	--- @see 檀：浅红色，浅绛色。
Color["殷红"]={0.745,0,0.184}		--- @see 殷红：发黑的红色。
Color["酡红"]={0.863,0.188,0.137}	--- @see 酡红：像饮酒后脸上泛现的红色，泛指脸红
Color["酡颜"]={0.976,0.565,0.435}	--- @see 酡颜：饮酒脸红的样子。亦泛指脸红色
--- @see 黄色系
Color["鹅黄"]={1,0.945,0.263}		--- @see 鹅黄：淡黄色（quester注：鹅嘴的颜色，高明度微偏红黄色）
Color["鸭黄"]={0.98,1,0.447}		--- @see 鸭黄：小鸭毛的黄色
Color["樱草"]={0.918,1,0.337}		--- @see 樱草色：淡黄色
Color["杏黄"]={1,0.651,0.192}		--- @see 杏黄：成熟杏子的黄色（quester注：Y100 M20~30 感觉的色彩，比较常用且有浓郁中国味道）
Color["杏红"]={1,0.549,0.192}		--- @see 杏红：成熟杏子偏红色的一种颜色
Color["橘黄"]={1,0.537,0.212}		--- @see 橘黄：柑橘的黄色。
Color["橙黄"]={1,0.643,0}			--- @see 橙黄：同上。（quester注：Y100 M50 感觉的色彩，现代感比较强。广告上用得较多）
Color["橘红"]={1,0.459,0}			--- @see 橘红：柑橘皮所呈现的红色。
Color["姜黄"]={1,0.78,0.451}		--- @see 姜黄：中药名。别名黄姜。为姜科植物姜黄的根茎。又指人脸色不正,呈黄白色
Color["缃色"]={0.941,0.761,0.224}	--- @see 缃色：浅黄色。
Color["橙色"]={0.98,0.549,0.208}	--- @see 橙色：界于红色和黄色之间的混合色。
Color["茶色"]={0.702,0.361,0.267}	--- @see 茶色：一种比栗色稍红的棕橙色至浅棕色
Color["驼色"]={0.659,0.518,0.384}	--- @see 驼色：一种比咔叽色稍红而微淡、比肉桂色黄而稍淡和比核桃棕色黄而暗的浅黄棕色
Color["昏黄"]={0.784,0.608,0.251}	--- @see 昏黄：形容天色、灯光等呈幽暗的黄色
Color["栗色"]={0.376,0.157,0.118}	--- @see 栗色：栗壳的颜色。即紫黑色
Color["棕色"]={0.698,0.365,0.145}	--- @see 棕色：棕毛的颜色,即褐色。1，在红色和黄色之间的任何一种颜色2，适中的暗淡和适度的浅黑。
Color["棕绿"]={0.51,0.443,0}		--- @see 棕绿：绿中泛棕色的一种颜色。
Color["棕黑"]={0.486,0.294,0}		--- @see 棕黑：深棕色。
Color["棕红"]={0.608,0.267,0}		--- @see 棕红：红褐色。
Color["棕黄"]={0.682,0.439,0}		--- @see 棕黄：浅褐色。
Color["赭色"]={0.612,0.325,0.2}		--- @see 赭：赤红如赭土的颜料,古人用以饰面
Color["赭色"]={0.584,0.333,0.224}	--- @see 赭色：红色、赤红色。
Color["琥珀"]={0.792,0.412,0.141}	--- @see 琥珀：
Color["褐色"]={0.431,0.318,0.118}	--- @see 褐色： 黄黑色
Color["枯黄"]={0.827,0.694,0.49}	--- @see 枯黄：干枯焦黄
Color["黄栌"]={0.886,0.612,0.271}	--- @see 黄栌：一种落叶灌木，花黄绿色,叶子秋天变成红色。木材黄色可做染料。
Color["秋色"]={0.537,0.424,0.224}	--- @see 秋色：1，中常橄榄棕色,它比一般橄榄棕色稍暗,且稍稍绿些。2，古以秋为金,其色白,故代指白色。
Color["秋香"]={0.851,0.714,0.067}	--- @see 秋香色：浅橄榄色 浅黄绿色。（quester注：直接在Y中掺入k10~30可得到不同浓淡的该类色彩）
--- @see 绿色系
Color["嫩绿"]={0.741,0.867,0.133}	--- @see 嫩绿：像刚长出的嫩叶的浅绿色
Color["柳黄"]={0.788,0.867,0.133}	--- @see 柳黄：像柳树芽那样的浅黄色
Color["柳绿"]={0.686,0.867,0.133}	--- @see 柳绿：柳叶的青绿色
Color["竹青"]={0.471,0.573,0.384}	--- @see 竹青：竹子的绿色
Color["葱黄"]={0.639,0.851,0}		--- @see 葱黄：黄绿色，嫩黄色
Color["葱绿"]={0.62,0.851,0}		--- @see 葱绿：1，浅绿又略显微黄的颜色2，草木青翠的样子
Color["葱青"]={0.055,0.722,0.227}	--- @see 葱青：淡淡的青绿色
Color["葱倩"]={0.055,0.722,0.227}	--- @see 葱倩：青绿色
Color["青葱"]={0.039,0.639,0.267}	--- @see 青葱：翠绿色,形容植物浓绿
Color["油绿"]={0,0.737,0.071}		--- @see 油绿：光润而浓绿的颜色。以上几种绿色都是明亮可爱的色彩。
Color["绿沈"]={0.047,0.537,0.094}	--- @see 绿沈（沉）：深绿
Color["碧色"]={0.106,0.82,0.647}	--- @see 碧色：1，青绿色。2，青白色,浅蓝色。
Color["碧绿"]={0.165,0.867,0.612}	--- @see 碧绿：鲜艳的青绿色
Color["青碧"]={0.282,0.753,0.639}	--- @see 青碧：鲜艳的青蓝色
Color["翡翠"]={0.239,0.882,0.678}	--- @see 翡翠色：1，翡翠鸟羽毛的青绿色。2，翡翠宝石的颜色。（quester注：C-Y≥30
Color["草绿"]={0.251,0.871,0.353}	--- @see 草绿：绿而略黄的颜色。
Color["青色"]={0,0.878,0.62}		--- @see 青色：1，一类带绿的蓝色,中等深浅,高度饱和。3，本义是蓝色。4，一般指深
Color["青翠"]={0,0.878,0.475}		--- @see 青翠：鲜绿
Color["青白"]={0.753,0.922,0.843}	--- @see 青白：白而发青,尤指脸没有血色
Color["鸭卵"]={0.878,0.933,0.91}	--- @see 鸭卵青：淡青灰色，极淡的青绿色
Color["蟹壳"]={0.733,0.804,0.773}	--- @see 蟹壳青：深灰绿色
Color["鸦青"]={0.259,0.298,0.314}	--- @see 鸦青：鸦羽的颜色。即黑而带有紫绿光的颜色。
Color["绿色"]={0,0.898,0}			--- @see 绿色：1，在光谱中介于蓝与黄之间的那种颜色。2，本义：青中带黄的颜色。3
Color["豆绿"]={0.62,0.816,0.282}	--- @see 豆绿：浅黄绿色
Color["豆青"]={0.588,0.808,0.329}	--- @see 豆青：浅青绿色
Color["石青"]={0.482,0.812,0.651}	--- @see 石青：淡灰绿色
Color["玉色"]={0.18,0.875,0.639}	--- @see 玉色:玉的颜色，高雅的淡绿、淡青色
Color["缥色"]={0.498,0.925,0.678}	--- @see 缥：绿色而微白
Color["艾绿"]={0.643,0.886,0.776}	--- @see 艾绿：艾草的颜色。偏苍白的绿色。
Color["松柏"]={0.129,0.651,0.459}	--- @see 松柏绿：经冬松柏叶的深绿
Color["松花"]={0.02,0.467,0.282}	--- @see 松花绿：亦作"松花"、"松绿"。偏黑的深绿色,墨绿。
Color["松花"]={0.737,0.902,0.447}	--- @see 松花色：浅黄绿色。（松树花粉的颜色）《红楼梦》中提及松花配桃红为娇艳
--- @see 蓝色系
Color["蓝色"]={0.267,0.808,0.965}	--- @see 蓝：三原色的一种。像晴天天空的颜色（quester注：这里的蓝色指的不是RGB色彩中的B，而是CMY色彩中的C）
Color["靛青"]={0.09,0.486,0.69}		--- @see 靛青：也叫"蓝靛"。用蓼蓝叶泡水调和与石灰沉淀所得的蓝色染料。呈深蓝绿色（quester注：靛，发音dian四声，有些地方将蓝墨水称为"靛水"或者"兰靛水"）
Color["靛蓝"]={0.024,0.322,0.475}	--- @see 靛蓝：由植物(例如靛蓝或菘蓝属植物)得到的蓝色染料
Color["碧蓝"]={0.243,0.929,0.906}	--- @see 碧蓝：青蓝色
Color["蔚蓝"]={0.439,0.953,1}		--- @see 蔚蓝：类似晴朗天空的颜色的一种蓝色
Color["宝蓝"]={0.294,0.361,0.769}	--- @see 宝蓝：鲜艳明亮的蓝色（quester注：英文中为 RoyalBlue 即皇家蓝色，是皇室选用的色彩，多和小面积纯黄色（金色）配合使用。）
Color["蓝灰"]={0.631,0.686,0.788}	--- @see 蓝灰色：一种近于灰略带蓝的深灰色
Color["藏青"]={0.18,0.306,0.494}	--- @see 藏青：蓝而近黑
Color["藏蓝"]={0.231,0.18,0.494}	--- @see 藏蓝：蓝里略透红色
Color["黛色"]={0.29,0.259,0.4}		--- @see 黛：青黑色的颜料。古代女子用以画眉。
Color["黛螺"]={0.29,0.259,0.4}		--- @see 黛螺：绘画或画眉所使用的青黑色颜料，代指女子眉妩。
Color["黛色"]={0.29,0.259,0.4}		--- @see 黛色：青黑色。
Color["黛绿"]={0.259,0.4,0.4}		--- @see 黛绿：墨绿。
Color["黛蓝"]={0.259,0.314,0.4}		--- @see 黛蓝：深蓝色
Color["黛紫"]={0.341,0.259,0.4}		--- @see 黛紫：深紫色
Color["紫色"]={0.553,0.294,0.733}	--- @see 紫色：蓝和红组成的颜色。古人以紫为祥瑞的颜色。代指与帝王、皇宫有关的事物。
Color["紫酱"]={0.506,0.329,0.388}	--- @see 紫酱：浑浊的紫色
Color["酱紫"]={0.506,0.329,0.463}	--- @see 酱紫：紫中略带红的颜色
Color["紫檀"]={0.298,0.133,0.106}	--- @see 紫檀：檀木的颜色，也称乌檀色 乌木色
Color["绀青"]={0,0.2,0.443}			--- @see 绀青 绀紫：纯度较低的深紫色
Color["紫棠"]={0.337,0,0.31}		--- @see 紫棠：黑红色
Color["青莲"]={0.502,0.114,0.682}	--- @see 青莲：偏蓝的紫色
Color["群青"]={0.298,0.553,0.682}	--- @see 群青：深蓝色
Color["雪青"]={0.69,0.643,0.89}		--- @see 雪青：浅蓝紫色
Color["丁香"]={0.8,0.643,0.89}		--- @see 丁香色：紫丁香的颜色，浅浅的紫色，很娇柔淡雅的色彩
Color["藕色"]={0.929,0.82,0.847}	--- @see 藕色：浅灰而略带红的颜色
Color["藕荷"]={0.894,0.776,0.816}	--- @see 藕荷色：浅紫而略带红的颜色
--- @see 苍色系
Color["苍色"]={0.459,0.529,0.541}	--- @see 苍色：即各种颜色掺入黑色后的颜色，如
Color["苍翠"]={0.318,0.604,0.451}	--- @see 苍翠
Color["苍黄"]={0.635,0.608,0.486}	--- @see 苍黄
Color["苍青"]={0.451,0.592,0.671}	--- @see 苍青
Color["苍黑"]={0.224,0.322,0.376}	--- @see 苍黑
Color["苍白"]={0.82,0.851,0.878}	--- @see 苍白（quester注：准确的说是掺入不同灰度级别的灰色）
--- @see 水色系
Color["水色"]={0.533,0.678,0.651}	--- @see 水色
Color["水红"]={0.953,0.827,0.906}	--- @see 水红
Color["水绿"]={0.831,0.949,0.906}	--- @see 水绿
Color["水蓝"]={0.824,0.941,0.957}	--- @see 水蓝
Color["淡青"]={0.827,0.878,0.953}	--- @see 淡青
Color["湖蓝"]={0.188,0.875,0.953}	--- @see 湖蓝
Color["湖绿"]={0.145,0.973,0.796}	--- @see 湖绿，皆是浅色。 深色淡色：颜色深的或浅的，不再一一列出。
--- @see 灰白系
Color["精白"]={1,1,1}				--- @see 精白：纯白，洁白，净白，粉白。
Color["象牙"]={1,0.984,0.941}		--- @see 象牙白：乳白色
Color["雪白"]={0.941,0.988,1}		--- @see 雪白：如雪般洁白
Color["月白"]={0.839,0.925,0.941}	--- @see 月白：淡蓝色
Color["缟色"]={0.949,0.925,0.871}	--- @see 缟：白色
Color["素色"]={0.878,0.941,0.914}	--- @see 素：白色，无色
Color["荼白"]={0.953,0.976,0.945}	--- @see 荼白：如荼之白色
Color["霜色"]={0.914,0.945,0.965}	--- @see 霜色：白霜的颜色。
Color["花白"]={0.761,0.8,0.816}		--- @see 花白：白色和黑色混杂的。斑白的 夹杂有灰色的白
Color["鱼肚"]={0.988,0.937,0.91}	--- @see 鱼肚白：似鱼腹部的颜色，多指黎明时东方的天色颜色（quester注：M5 Y5）
Color["莹白"]={0.89,0.976,0.992}	--- @see 莹白：晶莹洁白
Color["灰色"]={0.502,0.502,0.502}	--- @see 灰色：黑色和白色混和成的一种颜色
Color["牙色"]={0.933,0.871,0.69}	--- @see 牙色：与象牙相似的淡黄色（quester注：暖白）
Color["铅白"]={0.941,0.941,0.957}	--- @see 铅白：铅粉的白色。铅粉，国画颜料，日久易氧化"返铅"变黑。铅粉在古时用以搽脸的化妆品。（quester注：冷白）
--- @see 黑色系
Color["玄色"]={0.384,0.165,0.114}	--- @see 玄色：赤黑色，黑中带红的颜色，又泛指黑色
Color["玄青"]={0.239,0.231,0.31}	--- @see 玄青：深黑色
Color["乌色"]={0.447,0.369,0.51}	--- @see 乌色：暗而呈黑的颜色
Color["乌黑"]={0.224,0.184,0.255}	--- @see 乌黑：深黑；漆黑
Color["漆黑"]={0.086,0.094,0.137}	--- @see 漆黑：非常黑的
Color["墨色"]={0.314,0.38,0.427}	--- @see 墨色：即黑色
Color["墨灰"]={0.459,0.541,0.6}		--- @see 墨灰：即黑灰
Color["黑色"]={0,0,0}				--- @see 黑色：亮度最低的非彩色的或消色差的物体的颜色；最暗的灰色；与白色截然不同的消色差的颜色；被认为特别属于那些既不能反射、又不能透过能使人感觉到的微小入射光的物体,任何亮度很低的物体颜色。
Color["缁色"]={0.286,0.192,0.192}	--- @see 缁色：帛黑色
Color["煤黑"]={0.192,0.145,0.125}	--- @see 煤黑、象牙黑：都是黑，不过有冷暖之分。
Color["黧色"]={0.365,0.318,0.235}	--- @see 黧：黑中带黄的颜色
Color["黎色"]={0.459,0.4,0.302}		--- @see 黎：黑中带黄似黎草色
Color["黝色"]={0.42,0.408,0.51}		--- @see 黝：本义为淡黑色或微青黑色。
Color["黝黑"]={0.4,0.341,0.341}		--- @see 黝黑：（皮肤暴露在太阳光下而晒成的）青黑色
Color["黯色"]={0.255,0.333,0.365}	--- @see 黯：深黑色、泛指黑色
--- @see 金银系
Color["赤金"]={0.949,0.745,0.271}	--- @see 赤金：足金的颜色
Color["金色"]={0.918,0.804,0.463}	--- @see 金色：平均为深黄色带光泽的颜色
Color["银色"]={0.914,0.906,0.937}	--- @see 银白：带银光的白色
Color["铜绿"]={0.329,0.588,0.533}	--- @see 铜绿
Color["乌金"]={0.655,0.557,0.267}	--- @see 乌金
Color["老银"]={0.729,0.792,0.776}	--- @see 老银：金属氧化后的色彩

return Color