ChatWindow = 
{
	tbMsgFlag		= {},						-- 主界面聊天省略号信息条表
	nSingleHeight		= 0,				-- 主界面聊天中一个省略号信息条的高度
	tbMsg			= {},						-- 主界面聊天说话信息条表
	nMainTxtWidth	= 0,					-- 主界面聊天说话信息条的宽度
	nPicSize = 0,								-- 主界面聊天说话信息条的高度
	tbMainChatTxt	= {},					-- 主界面聊天消息缓存列表
	nMainSysLabHide = false,			-- 系统消息渐隐/下降标志
	
	tbFreeLable     = {},                 --管理显示系统消息的Lable的Free表
	tbUseLable      = {},					--管理显示系统消息的lable de 
	tbTxtMsgQueue	= {},				--消息缓存队列
	nLableIndex		= 0,						
	nCommonChatWndYPos = 0,		--普通窗口的YPos
	nUnreadMsgs		= 0,					-- 未读消息总数量	
	nUnreadLeague = 0,					--公会里未读信息条数
	nUnreadPrivate = 0,					--未读私聊数量	
	nUnreadBug		= 0,					--未读Bug数量	 
	nUnreadSal		 = 0,					--未读小秘书数量
	nUnreadTeam	= 0,					--未读组队数量
	nUnreadMijing   = 0,					--未读秘境数量
	nCurPageIdx		= -1,					-- 当前选择页
	szCurSelPlayer	= "",					-- 选中玩家名字
	nProf = nil,								-- 选中玩家职业
	nCurSelPlayerLv = 0,					-- 当前选中好友等级   
	nMsgSpace		= 6,					-- 聊天泡泡竖向间距
	tbPageBtns		= {},					-- 标签存储表
	nRefreshTimer	= 1,					-- 聊天页面刷新时间
	nRoleHeadNum	= 0,					-- 窗口名前缀
	nContHeight		= 0,					-- 聊天窗口高度
	tbContYPos		= {},					-- 聊天窗口Y坐标偏移量
	tbSpeakers		= {},					-- 人物信息缓存表
	tbChannelName	= {},					-- 聊天频道信息缓存表
	bShowEmotion	= false,				-- 是否显示表情中
	nParseStep		= 10,					-- 最大离线消息缓存数量
	tbCurPlayersInfo		= {}, 				-- 名字与信息映射表
	bDelaySwitch = false,					-- 是否切换到私聊频道
	nInputYPosition	= 0,					-- 输入窗口的Y坐标
	szPushName = "",						-- 接收推送消息的玩家名称
	tbSocialData	= {	},					-- 工会玩家信息
	tbNoBlackSocialData = {	},			-- 没有黑名单玩家的公会玩家信息
	tbCacheVoiceMsg = {	},				-- 语音信息缓存表
	bAutoDocking = true,					-- 自动停靠标志
	nCurSevCnt = 0,							-- 实际在线人数
	nSpeakTime = 1,						-- 玩家说话顺序
	nLastSpeakNum = 1,   				-- 消除左侧玩家列表值 
	nRefreshHeadTime = 1,				-- 左侧列表刷新时间
	tbInputData = {	},						-- 通用列表输入数据
	tbFriendWndMap = {	},				-- 名字与窗口的映射表
	szOnlineColor	= "FF44311D",	-- 在线信息显示颜色
	szOnlineCombatColor = "FFFB4B41",  -- 在线战力相关颜色
	szOfflineColor	= "FF7A7162",	-- 离线信息显示颜色
	nShowIdx = 0,							-- 玩家头像列表显示第几个的索引
	bIsConScript = false,					--是否是军征场聊天系统
	bIsConScriptMain = false,			--是否是军征场主界面的聊天系统
	bIsFamRoom = false,					--是否是帮会秘境界面的聊天系统
	bIsMumbo = false,						--是否是天尊界面的聊天系统
	tbTeamConScript = {	},
	tbTeamFam = {	},
	nLastSendTime = 0	,
	tbDartTime = {	},								--记录运镖聊天时间戳
	szCurTencentName = nil,			--当前选中好友腾讯名
}

-- 聊天泡泡
G_ChatBubble =
{
	nNormalBubbleWidth	= 0,
	nExclaimBubbleWidth	= 0,
	nThinkBubbleWidth	= 0,
	nDuration			= 5,
	bClipByDistance		= 1,
}

-- 职业头像索引表
G_Prof = 
{
	[Npcdef.prof_knight] = "set:o4_item_1 image:c14",
	[Npcdef.prof_archer] = "set:o4_item_1 image:c12",
	[Npcdef.prof_warlock] = "set:o4_item_1 image:c13",
}

--切换标签页函数
local l_tbSwitchPageProc = {}

-- 全局加速
local l_CEGUI				= CEGUI
local l_WndMgr				= l_CEGUI.WindowManager:getSingleton( )
local l_AppController 	= GameUI.SUIAppController:Instance( )
local l_MsgCenter   		= GameUI.SUIChatMsgCenter:Instance( )
local l_translator			= GameUI.SUITranslator:Instance( )
local l_pComConfigs	= GameUI.SUIGameConfigs:GetCommonConfigs( )
local l_pUserConfigs = GameUI.SUIGameConfigs:GetUserConfigs( )
local l_nThinkBubbleLabHeight = 0      													--该变量用于存储思考泡泡文本框初始高度
local l_BillBoard 		= l_CEGUI.SBillBoard:Instance( )
local l_UIHelper				= UIHelper
local l_ChatDef   			= Chatdef
local l_FriendDef 			= FriendDef
local l_t						= ChatWindow
local l_Layout				= SLayout
local l_System				= CEGUI.System:getSingleton( )								
local l_pStringToTable 		= l_UIHelper.StringToTable
local l_tbMultiVal			= UIMultiValueConfigs
local l_fBinaryFindInsertPos   = BinaryFindInsertPos
local l_tTranslator			= G_Translator
local l_tTransLinkType		= G_TransLinkType

local l_MsgIcon = "set:sat_common_ui image_2:team"		    -- 未读消息设置图标
local l_MsgIcon1 = "set:sat_common_ui image_2:tpoint"		    -- 未读消息设置图标
local l_nP1EmotionNum	= 20							-- 第一页表情数量
local l_nP2EmotionNum	= 20								-- 第二页表情数量
local l_szMsgContainer = "<Main>_<Container>"				

local l_tMsgFriendList = { }			   					-- 最近发言人表
local l_tbRoleWnd = { } 										--私聊窗口
local l_szForceSelPlayer = ""								-- 默认选择人名
local l_nPageMaxCount = 6									-- 列表最大数量
local l_nMaxChatNum = 100 									-- 世界聊天最大人数
local l_nMaxPrivateChatNum = 21							    -- 私聊列表最大人数
local l_nYposition = 0  									-- 人物列表容器Y位置
local l_nContHight = 0 										-- 人物列表容器高度
local l_nNormalRoleWndWidth 		= 365 * l_System:getSystemScale( )			-- 左侧头像未选中宽度比例   
local l_nNormalRoleWndXPosition 	= 23 * l_System:getSystemScale( )  			-- 左侧头像未选中横坐标位置比例  
local l_nSelRoleWndWidth				= 256 * l_System:getSystemScale( )		    -- 左侧头像选中宽度比例		
local l_nSelRoleWndXPosition			= 13 * l_System:getSystemScale( )		   	 	-- 左侧头像选中横坐标位置比例 
local l_tMsgUnReadNum 	= { }								-- 未读消息标志
local l_tLastMsgTime 			= { }						-- 玩家最后聊天时间
local l_nMsgTime 				= 0							-- 消息时间
local l_tbTempBlack = { } 									-- 临时屏蔽列表
local l_nMaxBlackNum = 20									-- 临时屏蔽列表上限
local l_nCurBlackNum = 0                                    -- 当前临时屏蔽的个数

local l_tbLableProc = {}					                --点击主界面聊天标签处理
local l_szShowCreature = nil
local l_szShowPet = nil
local l_szShareReport = nil 	-- 战报相关
local l_szCopyMsg = ""
local l_szSendConscribe = nil
local l_bPlayVoice = 0

-- 标签页ID表
local l_tbPageBtnOrder =				
{
	[1] = l_ChatDef.chat_room_id_global,
	[2] = l_ChatDef.chat_room_id_social,
	[3] = l_ChatDef.chat_room_id_sys,
	[4] = l_ChatDef.chat_room_id_teampvp,
	[5] = l_ChatDef.chat_room_mijing,
	[6] = l_ChatDef.chat_room_mumbo,
}
local tbDelta = l_UIHelper.StringToTable(SIdToMultiVal( l_tbMultiVal.ConScript, 3 ) , false, '#' )

-- 私聊标签页ID
local l_nChatRoomIdPrivate = 0

local l_tbSerNameToIdx = 
{
	nBugSolve	= GMdef.question_type_bug,				-- BUG解决者
	nSecretary	= GMdef.question_type_complaint,		-- 小秘书
	nKnowAll	= 2		-- 百科全书
}

------- 常量 ----------
-- 客服标签页ID
local l_nServerID = 111

-- 客服数量
local l_nSerWndNum = 3

-- 一次显示数量
local l_nOneGroupNum = 20 

-- 客服回复拼接用名字
local l_tbSerAnsName = 
{
	[ l_tbSerNameToIdx.nSecretary ] = SIdToMultiVal( l_tbMultiVal.LookQuestion, 1 ),
	[ l_tbSerNameToIdx.nBugSolve ] = SIdToMultiVal( l_tbMultiVal.LookQuestion, 2 ),
	[ l_tbSerNameToIdx.nKnowAll ] = SIdToMultiVal( l_tbMultiVal.LookQuestion, 4 ),
}

-- 客服头像
local l_tbSerAnsHead =
{
	[ l_tbSerNameToIdx.nSecretary ] = "set:o4_item_1 image:c12",
	[ l_tbSerNameToIdx.nBugSolve ]	= "set:o4_item_1 image:c13",
	[ l_tbSerNameToIdx.nKnowAll ]	= "set:o4_item_1 image:c14",
}

-- 秘境队伍枚举
local l_enTeamType = { --21字节
	GameId			= 1,
	LeadName 		= 2,
	GiftCreatureId 	= 3,
	Members			= 4,
	CreateTime		= 5,
	IsCombatting	= 6
	}

-- 移动方向枚举
local l_tbDir = 
{
	down = 1,
	up = 0,
}

-- 窗口停留位置显示类型
local l_nShowNoChange = 0
local l_nShowTop = 1
local l_nShowBottom = 2
local l_nShowReview = 3

-- 最大拼接字符串长度
local l_nExtMsgLen = 20

-- 显示时间间隔
local l_nMsgTimeDvalue = 60

-- 最大显示数量
local l_nMaxSerNum = 125

-- GM最多显示页数
local l_nMaxGMPageNum = 7 -- ceil( l_nMaxSerNum / 20 )

-- 开始加载下一页窗口的距离
local l_nMesOffset = -50 * l_System:getSystemScale( )

-- 客服控件列表
local l_tbSerBtnList = { }

-- 选项窗口
local l_tbMenuBarWnd = { }

-- 百科窗口
local l_tbKnowWnd = { }

-- 客服头像窗口
local l_tbSerHead = { }

-- 客服名字窗口
local l_tbSerName = { }

-- 特效窗口
local l_tbEffectWnd = { }

-- 两个菜单选项窗口竖向间距
local l_nMenuDis =  14 * l_System:getSystemScale( )	
-- 菜单高度需要加这个偏移量
local l_nMenuBottomD = 0

-- 客服频道消息窗口高度
local l_nBugTypeHeight = 0
local l_nKnowTypeHeight  = 0

-------------- 变量 -----------------
-- 发送类型 当前选中客服ID
local l_nSendType = -1

-- 当前特效窗口ID
local l_nEffectWndID = -1

-- 是否创建过选项窗口
local l_bCreated  = false

-- 是否从配置读数据
local l_bReadConfigs = false

-- 百科类型
local l_nKnowType = 0

-- 按下时Y坐标
local l_nDownYPos = 0

-- 窗口移动方向
local l_nDirection = -1 

-- 百科最后显示的条目ID
local l_nKnowLast = 0

-- 百科最早显示的条目ID
local l_nKnowBegin = 0 

-- 一次性标识
local l_bSetAlready = false

-- 设置单个窗口标志
local l_bSetSingleMsg = false

-- 发送消息成功回调刷新单条标志位
local l_HandFlag = false 

-- BUG未读消息
local l_bBugUnRead = false

-- 小秘书未读
local l_bSalUnRead = false

-- 创建窗口数量
local l_nTotalWndID = 0

-- 窗口信息
local l_tbSerData = 
{
	[ GMdef.question_type_bug ] = {	},
	[ GMdef.question_type_complaint ] = {	},
}

-- 显示模式
local l_bShowBottom = false

--  当前显示几页
local l_nCurBugPage = 1

-- 当前显示数据条数
local l_nCurBugNum = 0

-- 是否获取过数据
local l_bFirstReqGMData = {}

-- 获取GM数据操作锁
local l_bReqedGMData = false

--模型ID
local l_nGuideAnimId = 42

--模型动作
local l_nGirlActID = 64

--模型点击是否播动作
local l_bTouch = false

-- 父窗口
local l_pTopParent			= nil							-- 弹出界面父窗口

--------------天尊频道---------------
--输入文字长度限制
local l_nMumboInputLenth = 20
local l_nNormalInputLenth = 127

--------------------------------------------------
--                         初始化
--------------------------------------------------
-- Init
function ChatWindow:Init( )
	if l_t.ChatWindow then
		return 
	end
-- Handle
---GC 内存回收 --------------------
	local pParent = g_MainWnd
	if g_CurWindowType == 1 then
		pParent = g_SceneWnd
	end
	
	l_t.ChatWindow	= WindowMgr.LoadLayout( "sat_chat_window.layout", "", pParent )
	l_t.ChatWindowBackGround = l_t.ChatWindow:getChild( "sat_chat_wnd" )
-------------------------------------
	
	l_t.InitChatWnd( )
	l_t.InitService( )
	
	
	l_t.RoleNature	= l_t.ChatWindow:getChild( "scwrr_rolenature" )
	l_t.ChatCloseBtn= l_t.ChatWindow:getChild( "scw_chatcolsebtn" )
	l_t.ChatCloseBtn:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnClose )
	l_t.nMsgSpace = l_t.ChatParent:getAbsoluteWidth( ) / 80
	
	l_t.CurPeople = l_t.ChatWindow:getChild( "scwc_title" )
	
	--初始化聊天值	
	l_t.ChatCount = l_t.ChatWindow:getChild( "scw_chatcount" )
	l_t.ChatCountHelp = l_t.ChatCount:getChild( "scwc_help" )
	l_t.ChatCount:subscribeEvent( l_CEGUI.EventTimer, l_t.UpdateChatCount )
	l_t.ChatCountHelp:subscribeEvent( l_CEGUI.EventTouchClick,l_t.OnClickHelp )
	-- Channel
	for idx, val in ipairs( l_tbPageBtnOrder ) do
		local uChannelID = l_tbPageBtnOrder[idx]
		local pBtn = l_UIHelper.toSTabButton( l_t.ChatWindow:getChild( "scw_btn" .. ( idx  ) ) )
		pBtn:setID( uChannelID )
		pBtn:setSelected( false )
		pBtn:subscribeEvent( l_CEGUI.EventSelectStateChanged, l_t.OnSwitchPage )
		pBtn.nPrimitive = pBtn:getXPosition( )
		pBtn:hide( )
		l_t.tbPageBtns[uChannelID] = pBtn 
	end
	l_t.pUnreadLeague = l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:getChild( "scw_unreadleague" )
	l_t.FriendBtn = l_UIHelper.toSTabButton( l_t.ChatWindow:getChild( "scw_friendtb" ) )
	l_t.FriendBtn:setSelected( false )
	l_t.FriendBtn:setID( l_nChatRoomIdPrivate )
	l_t.pUnreadPrivate = l_t.FriendBtn:getChild( "scw_unreadprivate" )
	l_t.FriendBtn:subscribeEvent( l_CEGUI.EventSelectStateChanged, l_t.OnSwitchPage )
	l_t.ServiceBtn = l_UIHelper.toSTabButton( l_t.ChatWindow:getChild( "scw_servicebtn" ) )
	l_t.pUnreadSer = l_t.ServiceBtn:getChild( "scw_unreadser" )
	l_t.ServiceBtn:setSelected( false )
	l_t.ServiceBtn:setID( l_nServerID )
	l_t.ServiceBtn:subscribeEvent( l_CEGUI.EventSelectStateChanged, l_t.OnSwitchPage )
	
	l_t.ChatWindow:hide( )
end

-- 初始化聊天相关窗口
ChatWindow.InitChatWnd = function( )
	l_t.ChatParent = l_t.ChatWindow:getChild( "scw_chat" )
	
	local pMesWnd = l_t.ChatParent:getChild( "scw_meswnd" )
	
	l_t.RoleListCont	= l_t.ChatParent:getChild( "scw_rolelistcont" )
	l_t.RoleListCont:subscribeEvent( l_CEGUI.EventTimer, l_t.OnRefreshHead )
	l_nYposition = l_t.RoleListCont:getAbsoluteYPosition( )
	l_nContHight = l_t.RoleListCont:getAbsoluteHeight( )
	
	l_t.ChatCont	= l_UIHelper.toSSlideContainer( pMesWnd:getChild( "scw_chatcont" ) )
	l_t.ChatWnd	= l_t.ChatCont:GetContainer( )
	l_t.SpreakBG = pMesWnd:getChild( "scw_spreak" )
	l_t.SpreakBG:subscribeEvent( l_CEGUI.EventTimer, l_t.OnHideSpreakBG)
	l_t.SpreakHead = l_t.SpreakBG:getChild( "scws_head" )
	l_t.SpreakLable = l_t.SpreakBG:getChild( "scws_lable" ) 
	l_t.SpreakBG:hide( )
	l_t.ChatWnd:subscribeEvent( l_CEGUI.EventTimer, l_t.OnRefreshTimer )
	l_t.nContHeight = l_t.ChatCont:getAbsoluteHeight( )
	l_t.tbContYPos = l_t.ChatCont:getYPosition( ).offset
	
	--模型
	l_t.ModelWnd = pMesWnd:getChild( "scw_modle_wnd" )
	l_t.ModelGirl = l_UIHelper.toSAnimWindow( l_t.ModelWnd:getChild( "scw_girl" ) )
	l_t.ModelGirlBg = l_t.ModelGirl:getChild( "scw_girl_bg" ) 
	l_t.ModelGirlBg:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnModelGirlShow )
	l_t.ModelGirl:subscribeEvent( l_CEGUI.EventTimer, l_t.OnModelGirlTimer ) 
	l_t.ModelGirlTipsWnd = l_t.ModelWnd:getChild( "scw_tipswnd" )
	l_t.ModelGirlTxt = l_t.ModelGirlTipsWnd:getChild( "scw_tipstxt" )
	l_t.ModelWnd:hide( )
	
	l_t.InPut = pMesWnd:getChild( "scw_input" )
	l_t.InputBox = l_UIHelper.toSEditBox( l_t.InPut:getChild( "scw_inputebox" ) )
	l_t.PasteBtn	= l_t.InputBox:getChild( "scw_paste_btn" )
	l_t.InputBox:subscribeEvent( CEGUI.EventTouchLongDown, l_t.OnTouchLongDown )
	l_t.PasteBtn:subscribeEvent( CEGUI.EventDeactivated, l_t.OnPasteDeactivated )
	l_t.PasteBtn:subscribeEvent( CEGUI.EventTouchClick, l_t.OnPaste )
	l_t.PasteBtn:hide( )
	l_t.nInputYPosition = l_t.InPut:getAbsoluteYPosition( )
	
	l_t.VoiceSwitch	= l_t.InPut:getChild( "scwi_switch_voice" )
	l_t.VoiceSwitch:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnSwitchModel )
	
	l_t.TouchTalk = l_t.InPut:getChild( "scwi_touch_talk" )
	l_t.TouchTalk:subscribeEvent( l_CEGUI.EventTouchDown, l_t.OnTalkTouchDown )
	l_t.TouchTalk:subscribeEvent( l_CEGUI.EventTouchUp, l_t.OnTalkTouchUp )
	l_t.TouchTalk:subscribeEvent( l_CEGUI.EventTimer, l_t.OnTouchTimer )
	
	local szAccount = LoginMgr:GetAccount( )
	local szURL = G_RechargeSettings:GetVoiceURL( )
	l_AppController:InitVoice( "szr", szAccount, szURL )
	
	l_t.SendBtn  	= l_t.InPut:getChild( "scwi_sendbtn" )
	l_t.SendBtn:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnSendMsg )
	
	l_t.EmotionBtn	= l_CEGUI.toButtonBase( l_t.InPut:getChild( "scwi_emotionbtn" ) )
	l_t.EmotionBtn:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnEmotionBtn )
	l_t.EmotionBtn:subscribeEvent( l_CEGUI.EventNotClickedShieldingWindow, l_t.OnNotClickEmotionWnd )

	l_t.VoiceNotice = pMesWnd:getChild( "scw_rec_notice" )
	l_t.VoiceNotice:hide( )
end

--初始化聊天值窗口


-- 初始化客服窗口
ChatWindow.InitService = function( )
	l_t.ServerParent = l_t.ChatWindow:getChild( "scw_service" )
	
	l_t.SerListCont = l_t.ServerParent:getChild( "scws_listcont" )
	for nIdx = 1, l_nSerWndNum do
		l_tbSerBtnList[ nIdx ] = l_UIHelper.toSTabButton( l_t.SerListCont:getChild( "scwsl_btn" .. nIdx  ) ) 
		l_tbSerBtnList[ nIdx ]:setID( nIdx-1 )
		l_tbSerBtnList[ nIdx ]:subscribeEvent( l_CEGUI.EventSelectStateChanged, l_t.OnSelSer )
		l_tbEffectWnd[ nIdx ] = l_tbSerBtnList[ nIdx ]:getChild( "scwsl_list" .. nIdx  )
		l_tbSerName[ nIdx ] = l_tbEffectWnd[ nIdx ]:getChild( "scwsll_name" .. nIdx  )
		l_tbSerHead[ nIdx ] = l_tbEffectWnd[ nIdx ]:getChild( "scwsll_head" .. nIdx  ) 
	end
	
	l_tbSerName[1]:setAnsiText( SIdToMultiVal( l_tbMultiVal.LookQuestion, 2 ) )
	local pMesBack = l_t.ServerParent:getChild( "scws_mesback" )
	l_t.SerPutWnd = pMesBack:getChild( "scws_inputwnd" )
	l_t.SerBg = pMesBack:getChild( "scwsm_bg" )
--	l_t.SerSb = pMesBack:getChild( "scwsm_shadowb" )
	l_t.SerEmBtn = l_CEGUI.toButtonBase( l_t.SerPutWnd:getChild( "scws_enmot" ) )
	
	l_t.SerPutBox = l_UIHelper.toSEditBox( l_t.SerPutWnd:getChild( "scws_inputbox" ) )
	
	l_t.SerPutSend  	= l_t.SerPutWnd:getChild( "scws_hand" )
	l_t.SerPutSend:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnHandMsg )
	
	l_t.SerMesCont	= l_UIHelper.toSSlideContainer( pMesBack:getChild( "scws_mescont" ) )
	l_t.MesWnd	= l_t.SerMesCont:GetContainer( )
	l_t.SerMesCont:subscribeEvent( l_CEGUI.EventTouchDown, l_t.OnGetCurYp )
	l_t.SerMesCont:subscribeEvent( l_CEGUI.EventTouchMove, l_t.OnJuggDirection )
	l_t.MesWnd:subscribeEvent( l_CEGUI.EventMoved, l_t.OnSetAnotherGroup )
	l_nBugTypeHeight = l_t.SerMesCont:getAbsoluteHeight( )
	l_nKnowTypeHeight = l_nBugTypeHeight * 1.140243
	
	l_t.SerPopMenu = l_t.ServerParent:getChild( "scws_menu" )
	l_t.SerPopMenu:subscribeEvent( l_CEGUI.EventHidden, l_t.OnSaveLookPro )
	l_nMenuBottomD = l_t.SerPopMenu:getChildAtIdx( 0 ):getAbsoluteHeight( ) * 0.375
	
	l_t.SerMenuBar = l_UIHelper.toSTabButton( l_t.SerPopMenu:getChild( "scwsm_bar" ) )
	l_tbMenuBarWnd[1] = l_t.SerMenuBar
	l_t.SerMenuBar:setID( 1 )
	l_t.SerMenuBar:SetGroupID( 1 ) 
	l_t.SerMenuBar:subscribeEvent( l_CEGUI.EventSelectStateChanged, l_t.OnSwitchBar )	
	
end

ChatWindow.ShowOnly = function( )
	l_t:Init( )
	l_t:SetParent( )
	G_CommonBG.Show( G_CommonBG.tShowType.nNormal, l_t.ChatWindow , l_t.HideConsole , nil , nil , ChatWindow.pOnClickConsole )
	l_t.ChatWindow:moveToFront( )
	l_t.SetInputModel( )
	ChatWindow.Busy = nil
end

ChatWindow.HideConsole = function( )
	if l_t.pNpc then
		G_NpcSet:RecoverModelNpc( l_t.pNpc:GetIndex( ) )
		l_t.pNpc = nil
	end
	if l_t.bIsConScriptMain  then
		ChatWindow:ResetTabBtnPos( )
		l_t.bIsConScriptMain = false
	end
	l_t.bIsFamRoom = false
	if l_t.bIsMumbo then
		l_t.tbPageBtns[l_ChatDef.chat_room_mumbo]:hide( )
		l_t.bIsMumbo = false
	end
end

-- 改变父窗口
function ChatWindow:SetParent( )
	local pParent = WindowMgr.GetCurWindowOrder( )
	pParent:addChildWindow( self.ChatWindow )
	l_pTopParent			= WindowMgr.GetCurWindowOrder( G_WindowPart.Top )
end

function ChatWindow:UpdateParent( )
	l_pTopParent			= WindowMgr.GetCurWindowOrder( G_WindowPart.Top )
	l_pTopParent:addChildWindow( self.ChatWindow:getParent():getParent() )
end

--军征场组队界面show
function ChatWindow:ConScriptToShow( )
	self.bIsConScript = true
	--注册聊天频道
 	G_ChatMgr:RegChatRoom( l_ChatDef.chat_room_id_teampvp )
	ChatWindow:Show( )
end

--军征场主界面show
function ChatWindow:ConScriptMainToShow( )
	self.bIsConScriptMain = true
	--注册聊天频道
	G_ChatMgr:RegChatRoom( l_ChatDef.chat_room_id_teampvp )
	ChatWindow:Show( )
end

--帮会秘境聊天show
function ChatWindow:FamRoomToShow( )
	self.bIsFamRoom = true
	--注册聊天频道
	G_ChatMgr:RegChatRoom( l_ChatDef.chat_room_mijing )
	ChatWindow:Show( )
end

--帮会酒会聊天show
function ChatWindow:LeagueReceptionToShow( )
	ChatWindow:Show( )
	--切换至帮会频道
	l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:setSelected( true )
end

--天尊聊天show
function ChatWindow:MumBoToShow( )
	self.bIsMumbo = true
	ChatWindow:Show( )
end

--显示
function ChatWindow:Show( )
	--初始化天尊页签
	l_t.tbPageBtns[l_ChatDef.chat_room_mumbo]:hide( )
	l_t.FriendBtn:show( )
    -- 判断是否有工会
    if Leaguedef.league_position_invalid ~= G_LeagueMgr:GetMyPosition( ) then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:setXPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ].nPrimitive )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_sys ]:setXPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_sys ].nPrimitive )
	else
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:setXPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ].nPrimitive )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_sys ]:setXPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ].nPrimitive )
	end
	if self.bIsConScript then
		l_t.ServiceBtn:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:show( )
	elseif self.bIsConScriptMain   then	
		ChatWindow:SetTabBtnPos( )
		l_t.ServiceBtn:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:show( )
		if G_PvPActMgr:IsInTeam( ) ~= 1 then
			l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )	
		end
	elseif self.bIsFamRoom then	
		l_t.ServiceBtn:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
	elseif self.bIsMumbo then
		l_t.ServiceBtn:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mumbo ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:hide( )
		l_t.FriendBtn:hide( )
	else
		l_t.ServiceBtn:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )
	end
	-- 判断客服页签 0 关闭 1开启
	if G_FuncSwitch:GetFuncStateByID( Taskdef.funcswitch_customer_service ) == 0 then
		l_t.ServiceBtn:hide( )
	end
	l_t.ShowOnly( )
	ChatWindow.setChatCount( )
	if self.bIsConScript then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:setSelected( false )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:setSelected( true )
		G_UIConScript:RefreshPMNum( )
		l_t.RefreshPMNum( )
		l_t.RefreshLeagueNum( )
		l_t.RefreshPriNum( )
		l_t.RefreshSerNum( )
	elseif self.bIsConScriptMain  then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:setSelected( false )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:setSelected( true )
		l_t.nUnreadMsgs = l_t.nUnreadMsgs - l_t.nUnreadTeam
		l_t.nUnreadTeam = 0
		G_UIConScript:UpdateMsgNum( )
		l_t.RefreshPMNum( )
		l_t.RefreshLeagueNum( )
		l_t.RefreshPriNum( )
		l_t.RefreshSerNum( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:show( )
		if G_PvPActMgr:IsInTeam( ) ~= 1 then
			l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )	
		end
	elseif self.bIsFamRoom then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:setSelected( false )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:setSelected( true )		
		l_t.nUnreadMijing = 0
		l_t.nUnreadPrivate = 0
		l_t.nUnreadLeague = 0
		l_t.RefreshPMNum( )
		l_t.RefreshLeagueNum( )
		l_t.RefreshPriNum( )
		l_t.RefreshSerNum( )
	elseif self.bIsMumbo then
		l_t.tbPageBtns[ l_ChatDef.chat_room_mumbo ]:setSelected( false )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mumbo ]:setSelected( true )
		l_t.RefreshPMNum( )
		l_t.RefreshLeagueNum( )
		l_t.RefreshPriNum( )
		l_t.RefreshSerNum( )
	else
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:setSelected( false )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:setSelected( true )		
		l_t.nUnreadMsgs = l_t.nUnreadBug + l_t.nUnreadSal + l_t.nUnreadPrivate + l_t.nUnreadLeague + l_t.nUnreadTeam
		l_t.RefreshPMNum( )
		l_t.RefreshLeagueNum( )
		l_t.RefreshPriNum( )
		l_t.RefreshSerNum( )		
	end
end

--设置四个标签的位置( 世界，私聊，组队，帮会)
function ChatWindow:SetTabBtnPos( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:setXPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:getXPosition( ) )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:setYPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:getYPosition( ) )		
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:setXPosition( l_t.ServiceBtn:getXPosition( ) )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:setYPosition( l_t.ServiceBtn:getYPosition( ) )	
end
--恢复四个标签原先位置
function ChatWindow:ResetTabBtnPos( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:setXPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:getXPosition( ) )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_social ]:setYPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:getYPosition( ) )	
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:setXPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:getXPosition( ) )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:setYPosition( l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:getYPosition( ) )
end

--是否显示
ChatWindow.IsVisible = function( )
	return nil ~= l_t.ChatWindow and l_t.ChatWindow:isVisible( true )
end

--隐藏
function ChatWindow:Hide( )
	if not l_t.ChatWindow then
		return
	end
	if ChatWindow.nCurPageIdx == l_ChatDef.chat_room_id_social and ChatWindow.IsVisible( ) then
		local nCurTime = SSvrUnixTimeStamp( )
		Me:GetTask( ):ReqChgTaskVal( Taskdef.league_chatroom_lastclose, nCurTime )
	end
	if ChatWindow.nCurPageIdx == l_ChatDef.chat_room_id_global and ChatWindow.IsVisible( ) then		
		Me:GetTask( ):ReqChgTaskVal( Taskdef.chat_global_lastclose, SSvrUnixTimeStamp( ) )
	end
	l_t.ChatCont:StopSlide( )
	G_CommonBG.Hide( l_t.ChatWindow )
	l_t.RoleListCont:removeAllTimer( )
	G_SlideListMgr:Reset( "ChatWnd" ) 
	l_t.bShowEmotion = false
	l_t.MoveEmotions( )
	l_t.szCurSelPlayer = ""
	l_t.bDelaySwitch = false
	l_t.bIsConScript = false
	l_t.StopPlayVoice( )	
end

ChatWindow.pOnClickConsole = function( )
		ChatWindow:Hide( )
end

--开始
function ChatWindow:Start( )
	l_t:Init( )
	local pBtn = l_t.tbPageBtns[l_ChatDef.chat_room_id_global] 
	if l_t.bIsConScript then
		pBtn = l_t.tbPageBtns[l_ChatDef.chat_room_id_teampvp]
	end
	if pBtn then
		pBtn:setSelected( false )
		pBtn:setSelected( true )
	end
		--清空语音消息
	l_t.ClearAllVoice( )
end

--关闭
ChatWindow.OnClose = function( args )
	l_t:Hide( )
	l_t.OnPlayFinished( )
end

--退出
function ChatWindow:Exit( )
	l_UIHelper.AbandonRPID( )
	if l_t.ChatWnd then
		l_t.ChatWnd:removeAllChildWindow( )
		l_t.ExitMainChatWnd( )
		l_t.InputBox:ClearText( )
	end

	if l_t.MsgCount then
		l_t.MsgCount:hide( )
	end
	
	l_t:Hide( )
	l_t.nUnreadTeam = 0
	l_t.nCurPageIdx		= -1	
	l_t.nUnreadMsgs		= 0
	l_t.nUnreadLeague     = 0	
	l_t.nUnreadBug		= 0
	l_t.nUnreadSal		= 0
	l_t.nUnreadPrivate	= 0
	l_t.szCurSelPlayer	= ""
	l_t.tbSpeakers		= { }
	l_t.tbChannelName	= { }
	l_t.nLastSendTime	= 0
	l_tMsgFriendList    = { }
	l_tbTempBlack       = {	}
	l_nCurBlackNum      = 0
	l_bFirstReqGMData	= { }
	for nIdx, pBtn in pairs( l_t.tbPageBtns ) do
		pBtn:hide( )
	end
    
	--清空语音消息
	l_t.ClearVoiceBuffer( )
	l_t.OnPlayFinished( )
	
	l_t.ExitServer( )
	
	l_szShowCreature = nil
	l_szShowPet = nil
	l_szShareReport = nil
	l_szSendConscribe = nil
	l_szCopyMsg = ""
end

-- 清空客服相关窗口及数据 
ChatWindow.ExitServer = function( )
	l_tbSerData[ GMdef.question_type_bug ] = { }
	l_tbSerData[ GMdef.question_type_complaint ] = { }
	l_bBugUnRead = false
	l_bSalUnRead = false
end

function ChatWindow:OnReconnection( )
end

function ChatWindow:CanGC( )
	if  "ChatWindow"  == G_Tutor:GetCurTutorModule( )  then
		return 0  
	else
		return 1
	end
end

function ChatWindow:Unit( )
	G_CommonBG.OnWndUnit( l_t.ChatWindow )
end

ChatWindow.ShowModelGirl = function( nType )
	if not  l_t.pNpc then
		l_t.pNpc = G_NpcSet:AssignModelNpc( l_nGuideAnimId ) 
	end
	local szText = l_UIHelper.StringToText( SIdToStyle( UIConfigs.NoPrivateChat ) )
	
	if l_t.pNpc and nType ==1 then 
		l_t.pNpc:UIStartSpecial( l_nGirlActID, 1 )
		l_t.ModelGirl:SetAnimID( l_t.pNpc:GetRepresentID() )
		l_t.ModelGirl:SetHorizontalFlip( 1 )
		l_t.ModelGirlTxt:setAnsiText( szText )
	elseif l_t.pNpc and nType ==2 then
		l_t.pNpc:UIStartSpecial( l_nGirlActID, 1 )
		l_t.ModelGirl:SetAnimID( l_t.pNpc:GetRepresentID() )
		l_t.ModelGirl:SetHorizontalFlip( 1 )
		l_t.ModelGirlTxt:setAnsiText( SIdToMultiVal( l_tbMultiVal.ChatChannel, 4 ) )
	elseif l_t.pNpc and nType == 3 then
		l_t.pNpc:UIStartSpecial( l_nGirlActID, 1 )
		l_t.ModelGirl:SetAnimID( l_t.pNpc:GetRepresentID() )
		l_t.ModelGirl:SetHorizontalFlip( 1 )
		l_t.ModelGirlTxt:setAnsiText( SIdToMultiVal( l_tbMultiVal.ChatChannel, 8 ) )
	end
	l_t.ModelGirlTxt:setClippedByParent( true )
	l_t.ModelWnd:show( )
	l_t.ModelGirl:SetAnimType( "tuzi" )
	l_t.ModelGirl:show( )
	l_t.ModelGirl:ShowAnim( )
	l_t.ModelGirlTipsWnd:show(  )
end

ChatWindow.HideModelGirl = function()
	l_t.ModelGirl:hide( )
	l_t.ModelGirlTipsWnd:hide( )
	l_t.ModelWnd:hide( )
	l_t.ChatCont:show( )
end

ChatWindow.OnModelGirlShow = function( )
	if l_bTouch then
		return
	end
	if not l_t.pNpc then
		l_t.pNpc = G_NpcSet:AssignModelNpc( l_nGuideAnimId )
	end	
	if l_t.pNpc then
		l_t.pNpc:UIStartSpecial( l_nGirlActID, 1 )
		l_bTouch = true
		l_t.ModelGirl:setTimer( 0, 1.5 ) 
	end
end

ChatWindow.OnModelGirlTimer = function( )
	if not l_t.ModelGirl then
		return
	end
	l_bTouch = false
	l_t.ModelGirl:removeAllTimer( ) 
end
--------------------------------------------------
--                         标签页切换
--------------------------------------------------
--标签页切换
ChatWindow.OnSwitchPage = function( args )
	local pBtn = l_UIHelper.toSTabButton( l_CEGUI.toMouseEventArgs( args ).window )
	pBtn:setAlwaysOnTop( false )	
	if pBtn:isSelected( ) then
		pBtn:setAlwaysOnTop( true )
		l_t.ChatWindowBackGround:moveToFront( )
		ChatWindow.SwitchToPage( pBtn )
		l_t.StopPlayVoice( )	
		if pBtn:getID( ) == l_ChatDef.chat_room_mumbo and l_t.InputBox then
			l_t.InputBox:setProperty( "MaxTextLength", l_nMumboInputLenth )
			l_t.InputBox:ClearText( )
		elseif l_t.InputBox then
			l_t.InputBox:setProperty( "MaxTextLength", l_nNormalInputLenth )
		end
	else
		if pBtn:getID( ) == l_ChatDef.chat_room_id_social and ChatWindow.IsVisible( ) then
			local nCurTime = SSvrUnixTimeStamp( )
			Me:GetTask( ):ReqChgTaskVal( Taskdef.league_chatroom_lastclose, nCurTime ) 
		elseif pBtn:getID( ) ==l_ChatDef.chat_room_id_global and ChatWindow.IsVisible( ) then
			Me:GetTask( ):ReqChgTaskVal( Taskdef.chat_global_lastclose	, SSvrUnixTimeStamp( ) )
		end
	end
	if l_t.bIsConScript then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:show( )
	elseif l_t.bIsConScriptMain then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
		if  G_PvPActMgr:IsInTeam( ) ~= 1 then
			l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )
		end
	elseif l_t.bIsFamRoom then
		l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:show( )
		l_t.ServiceBtn:hide( )
	elseif l_t.bIsMumbo then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_mumbo ]:show( )
	else
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )
	end
end


--切换标签页
ChatWindow.SwitchToPage = function( pPageBtn )
	ChatWindow.SetAutoDocking( true )
	l_t.OnHideSpreakBG( )
	l_t.ResetPlayerList( )
	if l_tbSwitchPageProc[pPageBtn:getID( )] then
		l_t.ResizeMsgWnd( )
		l_t.nCurPageIdx = pPageBtn:getID( )
		l_t.ShowParentWnd( )
		l_tbSwitchPageProc[pPageBtn:getID( )]( )
	end
end

-- 显示对应窗口
ChatWindow.ShowParentWnd = function(  )
	if l_t.nCurPageIdx ~= l_nServerID then
		l_t.ChatParent:show( )
		ChatWindow.HideModelGirl( )		
		l_t.ServerParent:hide( )
		l_t.InPut:addChildWindow( l_t.EmotionBtn )
	else
		l_t.ChatParent:hide( )
		l_t.ServerParent:show( )
		l_t.SerPutWnd:addChildWindow( l_t.EmotionBtn )
	end		
end

-- 切换到客服频道
l_tbSwitchPageProc[ l_nServerID ] = function(  )
	-- 设置未读标记
	if l_bBugUnRead == true then
		l_tbSerHead[ l_tbSerNameToIdx.nBugSolve+1 ]:setProperty( "InnerBackground", l_MsgIcon )
		l_tbSerHead[ l_tbSerNameToIdx.nBugSolve+1 ]:setProperty( "FrontImage", l_MsgIcon1 )
	elseif l_bSalUnRead == true then
		l_tbSerHead[ l_tbSerNameToIdx.nSecretary+1 ]:setProperty( "InnerBackground", l_MsgIcon )
		l_tbSerHead[ l_tbSerNameToIdx.nBugSolve+1 ]:setProperty( "FrontImage", l_MsgIcon1 )
	end
	l_tbSerBtnList[2]:setSelected( false )
	l_tbSerBtnList[2]:setSelected( true )
end

--切换到好友标签
l_tbSwitchPageProc[ l_nChatRoomIdPrivate ] = function( )
	l_t.RefreshPlayer( l_nChatRoomIdPrivate )
	l_t.AutoSelFriend( )
	l_t.RefreshFriendNum( )
	l_t.RoleListCont:show( )
end

--切换到世界标签
l_tbSwitchPageProc[l_ChatDef.chat_room_id_global] = function( )
	l_t.BeginRefresh( )
	l_t.RefreshPlayer( l_ChatDef.chat_room_id_global )
	l_t.SwitchToTalkModel( )
	l_t.TouchTalk:enable( )
	local nSevCnt = l_t.nCurSevCnt
	nSevCnt = UserFunc[G_UIUserModule.en_userfunc_global_peple	]( nSevCnt )
	nSevCnt = SLogicRand( 6 ) + nSevCnt
	local szCnt = l_UIHelper.StringToText( string.format (SIdToMultiVal( l_tbMultiVal.ChatChannel, 2 ) , nSevCnt ) )
	local szCnt = string.format (SIdToMultiVal( l_tbMultiVal.ChatChannel, 2 ) , nSevCnt )
	l_t.CurPeople:setAnsiText( szCnt )
	l_t.CurPeople:show( )
	l_t.RoleListCont:show( )
	l_t.nUnreadMsgs = l_t.nUnreadBug + l_t.nUnreadSal + l_t.nUnreadLeague + l_t.nUnreadPrivate + l_t.nUnreadTeam
	l_t.RefreshLeagueNum( )
	l_t.RefreshPriNum( )
	l_t.RefreshFriendNum( 1 )
	l_t.RefreshPMNum( )
end

--切换到组队标签
l_tbSwitchPageProc[l_ChatDef.chat_room_id_teampvp] = function( )
	l_t.BeginRefresh( )
	l_t.RefreshPlayer( l_ChatDef.chat_room_id_teampvp )
	l_t.SwitchToTalkModel( )
	l_t.TouchTalk:enable( )
	l_t.nUnreadMsgs = l_t.nUnreadMsgs - l_t.nUnreadTeam
	l_t.nUnreadTeam = 0
end

--切换到秘境队伍标签
l_tbSwitchPageProc[ l_ChatDef.chat_room_mijing ] = function( )
	l_t.BeginRefresh( )
	l_t.RefreshPlayer( l_ChatDef.chat_room_mijing )
	l_t.SwitchToTalkModel( )
	l_t.TouchTalk:enable( )
end 

--切换到公会标签
l_tbSwitchPageProc[l_ChatDef.chat_room_id_social] = function( )
	l_t.BeginRefresh( )
	G_LeagueMgr:ReqSrhMem( 0, 60 )
	l_t.SwitchToTalkModel( )
	l_t.TouchTalk:enable( )
	l_t.RoleListCont:show( )
	l_t.nUnreadMsgs = l_t.nUnreadMsgs - l_t.nUnreadLeague
	l_t.nUnreadLeague = 0
	l_t.RefreshPMNum( )
	l_t.RefreshLeagueNum( )
end

--切换到系统标签
l_tbSwitchPageProc[l_ChatDef.chat_room_id_sys] = function( )
	l_t.RoleListCont:hide( )
	ChatWindow.ResetChatWnd( )
	ChatMsgCenter.ResetCurPage( )
	l_t.SwitchToTalkModel( )
	l_t.TouchTalk:disable( )
end

--切换到天尊标签
l_tbSwitchPageProc[ l_ChatDef.chat_room_mumbo ] = function( )
	l_t.BeginRefresh( )
	l_t.RefreshPlayer( l_ChatDef.chat_room_mumbo )
	l_t.SwitchToTalkModel( )
	l_t.RoleListCont:show( )
	l_t.TouchTalk:disable( )
end 

--点击聊天值帮助窗口
l_t.OnClickHelp = function(  )
	--正在战斗中，不能跳转
	if G_FightShow.IsVisible( true ) then 
		local szText = SIdToMultiVal( l_tbMultiVal.ChatValue, 6 )
		SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )		
		return 	
	end
	G_chat_help:Show( 1 )
end

--刷新聊天值
ChatWindow.OnChgTask =function( uTaskID )
	if not ChatWindow:IsVisible( ) then
		return
	end
	if uTaskID == Taskdef.taskval_chat_val then
		ChatWindow.ChatCount:setAnsiText( SIdToMultiVal( l_tbMultiVal.ChatChannel, 3 ) .. Me:GetTask( ):GetTaskVal( Taskdef.taskval_chat_val ) )
	end
end
--重置聊天窗口
ChatWindow.ResetChatWnd = function( )
	l_t.ChatWnd:removeAllChildWindow( )
	l_t.ChatWnd:setHeight( 0, 0 )
	l_t.ChatWnd:setYPosition( 0, 0 )
end

--刷新聊天消息
ChatWindow.RefreshChatMsgs = function( )
	local tbMsgs = ChatMsgCenter.GetPreMsg( l_t.nParseStep )
	for idx, val in ipairs( tbMsgs ) do
		l_t.AddMessage( tbMsgs[idx], false )
	end

	return table.maxn( tbMsgs ) > 0
end

-- 开始刷新页面
ChatWindow.BeginRefresh = function( )
	ChatWindow.ResetChatWnd( )
	ChatMsgCenter.SwitchCurPage( l_t.nCurPageIdx, l_t.szCurSelPlayer )

	if l_t.RefreshChatMsgs( ) then
		l_t.ChatWnd:setTimer( l_t.nRefreshTimer, 0.1 )
		ChatWindow.HideModelGirl( )	 
	end
end

--设置聊天值
function ChatWindow.setChatCount( )
	ChatWindow.ChatCount:setAnsiText( SIdToMultiVal( l_tbMultiVal.ChatChannel, 3 ) .. Me:GetTask( ):GetTaskVal( Taskdef.taskval_chat_val ) )
end

-- 分时刷新计时
ChatWindow.OnRefreshTimer = function( args )
	local timerArgs = l_CEGUI.toTimerEventArgs( args )
	if l_t.nRefreshTimer == timerArgs.id then
		local bContinue = l_t.RefreshChatMsgs( )
		if not bContinue then
			timerArgs.window:removeTimer( l_t.nRefreshTimer )
		end
	end
end

--计算聊天消息窗口高度
ChatWindow.ResizeMsgWnd = function( )
	local nContHeight		= l_t.nContHeight
	local nContYPos		= l_t.tbContYPos

	if l_t.bShowEmotion then
		nContHeight		= nContHeight - ( G_Emotion:GetMainWnd( ):getAbsoluteHeight( ) + 15 * l_System:getSystemScale( )  )
	end
	if l_t.SpreakBG:isVisible( ) then
		local nYPos = nContYPos + l_t.SpreakBG:getAbsoluteHeight( )
		local nHeight = nContHeight - l_t.SpreakBG:getAbsoluteHeight( ) 
		l_t.ChatCont:setAbsoluteYPosition( nYPos )
		l_t.ChatCont:setAbsoluteHeight( nHeight )
	else
		l_t.ChatCont:setAbsoluteHeight( nContHeight )
		l_t.ChatCont:setYPosition( 0, nContYPos )
	end

	if nContHeight < l_t.ChatWnd:getAbsoluteHeight( ) then
		if l_t.OnCheckState( ) then
			l_t.ChatWnd:setYPosition( 0, -( l_t.ChatWnd:getAbsoluteHeight( ) - nContHeight ) )
		end
	else
		l_t.ChatWnd:setYPosition( 0, 0 )
	end
	if l_t.ServerParent:isVisible( ) then
		l_t.SerMesCont:setAbsoluteHeight( nContHeight )
		l_t.SerMesCont:setYPosition( 0, nContYPos )
		if nContHeight < l_t.MesWnd:getAbsoluteHeight( ) then
				l_t.MesWnd:setYPosition( 0, -( l_t.MesWnd:getAbsoluteHeight( ) - nContHeight ) )
		else
			l_t.MesWnd:setYPosition( 0, 0 )
		end
	end
end

-- 检查窗口是否自动停靠 
ChatWindow.OnCheckState =function(  )
	if l_t.bAutoDocking then
		return true
	else
		local nPreHight = l_t.ChatWnd:getAbsoluteHeight( )
		local nPreYPosition = l_t.ChatWnd:getAbsoluteYPosition( )
		local nContHeight = l_t.ChatCont:getAbsoluteHeight( )
		return nContHeight - nPreYPosition >= nPreHight - l_t.nMsgSpace
	end
end

--设置消息列表自动停靠
ChatWindow.SetAutoDocking = function( bDocking )
	l_t.bAutoDocking = bDocking
end

--------------------------------------------------
--                         玩家头像
--------------------------------------------------
-- 创建头像相关函数的集合
local tbCreateFunc = 
{
	-- 选中head后弹出玩家信息
	OnSelected  = function( self, args )
		local touchPos = l_CEGUI.toTouchEventArgs( args ).position
		l_t.SelectPlayer( self, touchPos.x, touchPos.y )
	end,
	
	-- 选中head后边部分不弹出提示信息
	OnBarClick = function( self )   
		l_t.SetEffectWnd( self )
		l_t.RefreshSelPlayer( self )
	end,
	
	-- 重置窗口的相关信息
	Reset = function( self )
		self.szName			= ""
		self.nLvl			= 0
		self.nFigureId		= 0
		self.nProf			= 0
		self.uOfflineTime	= 0
		self.uGroupID		= 0

		self.pHead:setProperty( "TopLeftImage", " " )
		self.pHead:setProperty( "TopRightImage", " " )
		self.pName:setAnsiText( "" )
		self.pLvl:setAnsiText( "" )
		self.pVipLvl:setAnsiText( "" )
		self.pVipLvl:show( )
		self.pBtmp:setAnsiText( "" )
		self.pHead:setProperty( "InnerBackground", " " )
		self.pHead:setProperty( "FrontImage", " " )
		-- 这步操作是由于使用竖向通用列表无法调整窗口位置
		-- 所以在重置中调整
		self.pWnd:setAbsoluteWidth( l_nNormalRoleWndWidth )
		self.pWnd:setAbsoluteXPosition( l_nNormalRoleWndXPosition )
	end,
	
	-- 设置窗口信息函数
	SetPlayerInfo = function( self, tbPlayerInfo )
		self:pReset( )
		if tbPlayerInfo.szOpenId then
			self.szName			= tbPlayerInfo.szOpenId
			self.szTencentName = tbPlayerInfo.szName
		else
			self.szName			= tbPlayerInfo.szName
		end
		self.nLvl			= tbPlayerInfo.nLvl
		self.nFigureId		= tbPlayerInfo.nFigureId
		self.nProf			= tbPlayerInfo.nProf
		self.uOfflineTime	= tbPlayerInfo.uOfflineTime
		self.uGroupID		= tbPlayerInfo.uGroupID
		self.bOnline		= tbPlayerInfo.bOnline
		self.nVip           = tbPlayerInfo.nVip
		self.nCombat      	= tbPlayerInfo.nCombat
		self.TitleID          = tbPlayerInfo.TitleID

		self.pName:setAnsiText( tbPlayerInfo.szName )
		self.pName:setProperty( "TextColours", G_LeadingNameColor[ self.nProf ]  ) 
		self.pLvl:setAnsiText( string.format( SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 7 ),tbPlayerInfo.nLvl ) )
		self.pLvl:setProperty( "TextColours", l_t.szOnlineColor )
		if tbPlayerInfo.nVip == 0 then
			self.pVipLvl:hide( )
		else	
			self.pVipLvl:setAnsiText( "v" .. tbPlayerInfo.nVip )
			self.pVipLvl:setProperty( "TextColours", "FFFFFFFF" )
--			self.pVipLvl:setProperty( "FrontImage",  "set:sat_common_ui image:textbg4" )
		end
		self.pBtmp:setProperty( "TextColours", l_t.szOnlineColor )
		self.pHead:setProperty( "TextColour", l_t.szOnlineCombatColor )
		self.pHead:setProperty( "ClientAreaBackgroundExt", G_Prof[ self.nProf ] )
		
		-- 设置名字与窗口的映射表
		for szName, tbWnd in pairs( l_t.tbFriendWndMap ) do
			if tbWnd == self then
				l_t.tbFriendWndMap[ szName ] = nil
			end
		end
		l_t.tbFriendWndMap[ self.szName ] = self
		
		if l_t.szCurSelPlayer ~= self.szName and self.bClear == true then
			-- 清空窗口选中效果
		 	l_t.ClearUnSelWnd( self.pWnd )
			self.bClear = false
		elseif l_t.szCurSelPlayer == self.szName then 
			-- 设置窗口选中效果
			l_t.SetEffectWnd( self )
		end
	end,
	
	-- 检查玩家在线状态并设置相应信息
	CheckOnline = function( self, tbPlayerInfo )
		if tbPlayerInfo.bOnline < 1 then
			self.pName:setProperty( "TextColours", l_t.szOfflineColor )
			self.pLvl:setProperty( "TextColours", l_t.szOfflineColor )
			self.pHead:setProperty( "TextColour", l_t.szOfflineColor )
		end
	end
}

--创建玩家头像
ChatWindow.CreateRoleWnd = function( )
	local tbRoleWnd =
	{
		nIdx = -1,
		bClear = false,
		pOnSelected 		= tbCreateFunc.OnSelected,
		pOnBarClick 		= tbCreateFunc.OnBarClick,
		pReset 				= tbCreateFunc.Reset,
		pSetPlayerInfo 	= tbCreateFunc.SetPlayerInfo,
		pCheckOnline 	= tbCreateFunc.CheckOnline,
	}
	tbRoleWnd.pWnd 	= l_WndMgr:copyWindowWithChild( l_t.RoleNature, l_t.nRoleHeadNum )
	tbRoleWnd.pWnd:setXPosition( 0, 0 )
	tbRoleWnd.pWnd:setID( l_t.nRoleHeadNum )
	
	tbRoleWnd.pHead 			= tbRoleWnd.pWnd:getChild( l_t.nRoleHeadNum .. "scwrrr_head" )
	tbRoleWnd.pState			= tbRoleWnd.pHead:getChild( l_t.nRoleHeadNum .. "scwrrr_state" )
	tbRoleWnd.pName			= tbRoleWnd.pWnd:getChild( l_t.nRoleHeadNum .. "scwrrr_name" )
	tbRoleWnd.pLvl				= tbRoleWnd.pWnd:getChild( l_t.nRoleHeadNum .. "scwrrr_lev" )
	tbRoleWnd.pVipLvl			= tbRoleWnd.pWnd:getChild( l_t.nRoleHeadNum .. "scwrrr_viplv" )
	tbRoleWnd.pBtmp			= tbRoleWnd.pWnd:getChild( l_t.nRoleHeadNum .. "scwrrr_btmp" )
	tbRoleWnd.pRed				= tbRoleWnd.pWnd:getChild( l_t.nRoleHeadNum .. "scwrrr_red" )
	tbRoleWnd.pRed	:hide( )
	tbRoleWnd.pState:hide( )

	tbRoleWnd.pHead:subscribeEvent( l_CEGUI.EventTouchClick, tbRoleWnd.pOnSelected, tbRoleWnd )         --选中head后弹出玩家信息
	tbRoleWnd.pWnd:subscribeEvent( l_CEGUI.EventTouchClick, tbRoleWnd.pOnBarClick, tbRoleWnd )  --选中head后边部分不弹出提示信息

	l_t.nRoleHeadNum = l_t.nRoleHeadNum + 1
	return tbRoleWnd
end

--设置窗口信息
ChatWindow.SetFuncInfo = function( nIdx, tbRoleWnd )
	-- 获取数据
	local szName = l_t.tbInputData[ nIdx ]
	local tbInfo = {	}
	if l_t.nCurPageIdx == l_ChatDef.chat_room_id_global then
		tbInfo = l_t.tbSpeakers.tbInfo[szName]
	elseif l_t.nCurPageIdx == l_nChatRoomIdPrivate then
		tbInfo = l_t.tbCurPlayersInfo[ nIdx ]
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_id_teampvp then
		tbInfo = l_t.tbTeamConScript[ nIdx ]
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_mijing then
		tbInfo = l_t.tbTeamFam[ nIdx ]
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_mumbo then
		tbInfo = l_t.tbSpeakers.tbInfo[szName]
	else
		tbInfo = l_t.tbNoBlackSocialData[ nIdx ]
	end
	if not tbInfo then
		tbRoleWnd.pWnd:hide( )
		table.remove( l_t.tbInputData , nIdx )
		return 
	end
	tbRoleWnd.pWnd:show( )
	-- 设置信息
	tbRoleWnd:pSetPlayerInfo( tbInfo )
	tbRoleWnd.nIdx = nIdx
	-- 检查玩家状态
	if l_t.nCurPageIdx == l_nChatRoomIdPrivate then
		l_t.CheckFriendState( tbRoleWnd )
		tbRoleWnd:pCheckOnline( tbInfo )
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_id_social then
		tbRoleWnd:pCheckOnline( tbInfo )
	end
	-- 临时屏蔽设置
	l_t.SetBlackState( szName )
	--设置玩家称号
	l_t.SetTitle( tbInfo.nTitle, tbRoleWnd )
	-- 设置选中效果
	if l_szForceSelPlayer == tbRoleWnd.szName then  
		l_t.tbForceSelPlayer = tbRoleWnd
	elseif l_t.szCurSelPlayer == tbRoleWnd.szName then
		l_t.SelectPlayer( tbRoleWnd )
	end
	if l_t.nCurPageIdx == l_nChatRoomIdPrivate then
		table.insert( l_tbRoleWnd , tbRoleWnd  )
	end
end

--设置玩家称号
ChatWindow.SetTitle = function( nTitle, tbRoleWnd )
	if not nTitle or nTitle < 1 then
		tbRoleWnd.pBtmp:setAnsiText( "" )
	else
		local szTopColor = G_TitleMgr:GetTitleTopColor( nTitle )
		local szBtmColor = G_TitleMgr:GetTitleBottomColor( nTitle )
		local szColor = "tl:" .. szTopColor .. " tr:" .. szTopColor .. " bl:" .. szBtmColor .. " br:" .. szBtmColor
		tbRoleWnd.pBtmp:setProperty( "TextColours", szColor )
		tbRoleWnd.pBtmp:setAnsiText( G_TitleMgr:GetTitleName( nTitle ) )
	end
end

--主界面喇叭滚动
ChatWindow.SpreakScroll = function( )
	local nWidth = l_t.SpreakLab:GetLayoutWidth()
	l_t.SpreakSLH:hide( )
	if nWidth > l_t.SpreakWnd:getAbsoluteWidth( ) then
		l_t.SpreakLab:setXPosition( 1, 0 )
		l_t.SpreakLab:startAutoXMoving( 0, -nWidth, 15,CEGUI.CURVE_LINEAR  )
	else
		l_t.SpreakLab:setXPosition( 0, 0 )
	end
	l_t.SpreakWnd:hide( )
end

--喇叭滚动结束
ChatWindow.SpreakLabFinished = function( args )
	--ChatWindow.SpreakScroll( )
	local pWnd = l_CEGUI.toWindowEventArgs( args ).window
	if pWnd:getAbsoluteXPosition( ) < -1 then 
		pWnd:setXPosition( 1, 0 )
		pWnd:startAutoXMoving( 0, 0, 6 , CEGUI.CURVE_LINEAR  )
	else
		pWnd:setXPosition( 0, 0 )
		pWnd:stopAutoMoving( )
		l_t.SpreakSLH:show( )
	end
end

ChatWindow.OnHideSpreakBG =function( )
	if l_t.SpreakBG then
		local nContHeight		= l_t.nContHeight
		local nContYPos		= l_t.tbContYPos
		l_t.ChatCont:setAbsoluteHeight( nContHeight )
		l_t.ChatCont:setYPosition( 0, nContYPos )
		l_t.SpreakBG:hide( )
		l_t.SpreakBG:removeAllTimer( )
	end
end
-- 临时屏蔽设置
ChatWindow.SetBlackState = function( szName )
	-- 获取窗口
	local tbRoleWnd = nil
	if szName and l_t.tbFriendWndMap[ szName ] then
		tbRoleWnd = l_t.tbFriendWndMap[ szName ]
	else
		return
	end
	
	if l_tbTempBlack[ szName ] then 
		-- 设置头像图标 
		tbRoleWnd.pHead:setProperty( "TopRightImage", "set:sat_common_ui_2 image:shutdown" )
	else
		-- 恢复头像图标 
		tbRoleWnd.pHead:setProperty( "TopRightImage", "" )
		-- 设置显示状态  
		if l_t.nCurPageIdx == l_nChatRoomIdPrivate then
			local enFriendType = G_MyFriend.GetFriendType( tbRoleWnd.szName )
			if l_FriendDef.friend_group_contact == enFriendType then
				tbRoleWnd.pState:show( )
			end
		else
			tbRoleWnd.pState:hide( )
		end
	end
end

--设置选中效果
ChatWindow.SetEffectWnd = function( tbRoleWnd )  
	if not tbRoleWnd.pWnd then
		return false
	end

	-- 有选中玩家且选中玩家不等于窗口设置数据人名时才清空
	if l_t.szCurSelPlayer ~= "" and  l_t.szCurSelPlayer ~= tbRoleWnd.szName then
		l_t.ClearSaveNowWnd(  l_t.szCurSelPlayer )
	end
	
	l_t.SetEffectAction( tbRoleWnd.pWnd )
	l_t.szCurSelPlayer = tbRoleWnd.szName
	tbRoleWnd.bClear = true
	
	return true
end

-- 窗口选中效果
ChatWindow.SetEffectAction = function( pWnd )
	if not pWnd then
		return
	end	 
	pWnd:setProperty( "ClientAreaBackground", "set:sat_common_ui_2 image:selectm")
	pWnd:setProperty( "FrameRight", "set:sat_common_ui_2 image:chat_selectr")
	pWnd:setProperty( "FrameLeft", "set:sat_common_ui_2 image:chat_selectl")
	pWnd:setProperty( "FrameArea", "{{0," .. 2*l_System:getSystemScale( ) .. "}, {0," .. -1*l_System:getSystemScale( ) .. "}, {1," .. -2*l_System:getSystemScale( ) .. "}, {1," .. 1*l_System:getSystemScale( ) .. "} }" )
	pWnd:setProperty( "ClientArea", "{{0," .. 15 * l_System:getSystemScale( ) .. "}, {0," .. -1* l_System:getSystemScale( ) .. "}, {1,".. -15* l_System:getSystemScale( ) .. "}, {1," .. 1* l_System:getSystemScale( ) .. "} }" )
end

-- 清空选中窗口的具体操作
ChatWindow.ClearSaveNowWnd = function(  szCurSelPlayer )
	local tbRoleWnd = l_t.tbFriendWndMap[ szCurSelPlayer ]
	if not tbRoleWnd then 
		return 
	end
	l_t.ClearUnSelWnd( tbRoleWnd.pWnd )
	tbRoleWnd.bClear = false
end

-- 生成窗口的时候如果具有选中特效，且人名不是选中玩家时调用
ChatWindow.ClearUnSelWnd = function( pWnd )
	if not pWnd then
		return
	end	 
	pWnd:setProperty( "ClientAreaBackground", "set:sat_common_bar image:skill_m2")
	pWnd:setProperty( "FrameRight", "set:sat_common_ui_1 image:getall_r")
	pWnd:setProperty( "FrameLeft", "set:sat_common_ui_1 image:getall_l")
	pWnd:setProperty( "FrameArea", "{{0,0}, {0,0}, {1,0}, {1,-2} }" )
	pWnd:setProperty( "ClientArea", "{{0," .. 47 * l_System:getSystemScale( ) .. "}, {0," .. 1* l_System:getSystemScale( ) .. "}, {1,".. -47* l_System:getSystemScale( ) .. "}, {1," .. 2* l_System:getSystemScale( ) .. "} }" )
end

--刷新聊天窗口
ChatWindow.RefreshSelPlayer = function( tbInfo )
	ChatWindow.SetAutoDocking( true )
	l_t.szCurSelPlayer = tbInfo.szName
	if l_t.FriendBtn:isSelected( ) then
		l_t.ShowFriendSetWnd( tbInfo )
	 	l_t.BeginRefresh( )
	 end
end

--选中玩家
ChatWindow.SelectPlayer = function( tbRoleWnd, nX, nY )
	if not tbRoleWnd then
		return
	end

	local szPlayer = l_t.szCurSelPlayer
	if tbRoleWnd.szName ~= szPlayer then
		l_t.SetEffectWnd( tbRoleWnd )
	end
	
	if tbRoleWnd.szName == Me:GetName() then 
		return 
	end 
	
	if l_t.FriendBtn:isSelected( ) then
		l_t.ShowFriendSetWnd( tbRoleWnd )
		if szPlayer == "" or szPlayer ~= l_t.szCurSelPlayer then
		 	l_t.BeginRefresh( )
		 end
	end  
	l_t.nCurSelPlayerLv = tbRoleWnd.nLvl
	l_t.szCurTencentName = tbRoleWnd.szTencentName
	if nX and nY then
		l_t.CreatRolePopMenu( l_t.szCurSelPlayer, tbRoleWnd.szTencentName )
		G_PopMenu:Show( nX, nY )
	end
end

-- 在大聊天框聊天框选中玩家
ChatWindow.OnSelectPlayerT = function( tbInfo, nX, nY )
	if not tbInfo then
		return
	end
	local tbRoleInfo = l_t.tbFriendWndMap[ tbInfo.szName ]
	
	-- 有选中玩家且选中玩家不等于窗口设置数据人名时才清空
	if l_t.szCurSelPlayer ~= "" and  l_t.szCurSelPlayer ~= tbInfo.szName then
		l_t.ClearSaveNowWnd(  l_t.szCurSelPlayer )
	end
	
	l_t.szCurSelPlayer = tbInfo.szName
	if tbRoleInfo then
		l_t.nCurSelPlayerLv = tbRoleInfo.nLvl
		l_t.szCurTencentName = tbRoleInfo.szTencentName
	end
	if tbInfo.szName == Me:GetName() then 
		return 
	end 
	l_t.CreatRolePopMenu( tbInfo.szName, tbInfo.szTencentName )
 
	if nX and nY then
		G_PopMenu:Show( nX, nY )
	end
end

--重置玩家列表
ChatWindow.ResetPlayerList = function( )
	l_t.nShowIdx = 0
	l_t.szCurSelPlayer = ""
	l_t.tbCurPlayersInfo = {}
	l_t.tbFriendWndMap = {	}
end

-- 定时刷新左侧列表
ChatWindow.OnRefreshHead = function( args )
	local timerArgs = l_CEGUI.toTimerEventArgs( args )
	-- 有玩家出入地图时触发
	if timerArgs.id == 0 then
		l_t.RoleListCont:removeTimer( 0 )
		if l_t.bIsConScript then
			l_t.RefreshPlayer( l_ChatDef.chat_room_id_teampvp )
		else
			if l_t.bIsConScriptMain  then
				l_t.RefreshPlayer( l_ChatDef.chat_room_id_teampvp )
			end
			if l_t.bIsFamRoom then
				l_t.RefreshPlayer( l_ChatDef.chat_room_mijing )
			end
			if l_t.bIsMumbo then
				l_t.RefreshPlayer( l_ChatDef.chat_room_mumbo )
			end
			l_t.RefreshPlayer( l_ChatDef.chat_room_id_global )
		end
	end
end

function ChatWindow.GetConscriptDate( szFriend )
	local tbDate = G_tConScriptChatList[szFriend ]
	return tbDate
end

function ChatWindow.GetFamDate( szFriend )
	local tbDate = G_tFamChatList[szFriend ]
	return tbDate
end

-- 准备左侧列表显示数据
ChatWindow.PrepareDate = function(  )
	local tbData = {}
	if l_t.nCurPageIdx == l_ChatDef.chat_room_id_global  then
		if l_t.tbSpeakers and l_t.tbSpeakers.tbOrder then
			local tbOrderName = l_t.tbSpeakers.tbOrder
			for nIdx, szName in ipairs( tbOrderName ) do
				if not G_FriendMgr:HaveFrdInGroup( szName, l_FriendDef.friend_group_black ) then
					table.insert( tbData, szName )
				end
			end
		end
	elseif l_t.nCurPageIdx == l_nChatRoomIdPrivate then
		l_t.tbCurPlayersInfo = l_t.GetSortedTable( )
		for nIdx, info in ipairs( l_t.tbCurPlayersInfo ) do
			table.insert( tbData, info.szName )
		end
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_id_teampvp  then
		local tFriendNameList =	G_UIConScript:GetTeamFiend(  )
		l_t.tbTeamConScript = {		}
		for _ , szFriend in pairs( tFriendNameList ) do 
			local tbInfo = ChatWindow.GetConscriptDate( szFriend )
			if tbInfo then
				table.insert( l_t.tbTeamConScript, tbInfo )
				table.insert( tbData, szFriend )
			end
		end
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_mijing then
		local tFriendNameList = G_fam_roommain:GetTeamFiend( )
		l_t.tbTeamFam = {		}
		for _ , szFriend in pairs( tFriendNameList ) do 
			local tbInfo = ChatWindow.GetFamDate( szFriend )
			if tbInfo then
				table.insert( l_t.tbTeamFam, tbInfo )
				table.insert( tbData, szFriend )
			end
		end
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_mumbo  then
		if l_t.tbSpeakers and l_t.tbSpeakers.tbOrder then
			local tbOrderName = l_t.tbSpeakers.tbOrder
			for nIdx, szName in ipairs( tbOrderName ) do
				if not G_FriendMgr:HaveFrdInGroup( szName, l_FriendDef.friend_group_black ) then
					table.insert( tbData, szName )
				end
			end
		end
	else		
		l_t.tbNoBlackSocialData = {}
		for nIdx, info in ipairs( l_t.tbSocialData ) do
			if not G_FriendMgr:HaveFrdInGroup( info.szName, l_FriendDef.friend_group_black ) then
				table.insert( l_t.tbNoBlackSocialData, info )
				table.insert( tbData, info.szName )
			end
		end
	end
	return tbData
end

--刷新头像
ChatWindow.RefreshPlayer = function( nPageIdx )
	if not ChatWindow.IsVisible( ) or nPageIdx ~= l_t.nCurPageIdx then
		return
	end
	-- 获取输入数据
	l_t.tbInputData = l_t.PrepareDate( )
	
	l_t.HideModelGirl( )
	l_t.ChatCont:show( )	
	if l_t.FriendBtn:isSelected( ) then 
		if table.maxn( l_t.tbInputData ) <= 0 then
			l_t.ShowModelGirl( 1 )
			l_t.ChatCont:hide( )
		end
	end
	-- 获取选中玩家
	l_t.GetForceSelPlayer( )
	-- 加载和显示列表
	G_SlideListMgr:SetAndShowList( 
													"ChatWnd", 
													l_t.tbInputData,
													l_t.SetFuncInfo, 
													l_t.CreateRoleWnd, 
													l_t.RoleListCont, 
													nil, 
													l_t.RoleNature:getAbsoluteHeight( ), 
													3,
													nil,
													nil,
													true,
													-5
												)
end


-- 获取选中玩家姓名
ChatWindow.GetForceSelPlayer = function(  )
	l_szForceSelPlayer = ""
	if l_t.tbForceSelPlayer then
		l_szForceSelPlayer = l_t.tbForceSelPlayer.szName
		for nIdx, szName in ipairs( 	l_t.tbInputData ) do
			if l_szForceSelPlayer == szName and nIdx > l_nPageMaxCount then
				l_t.nShowIdx = nIdx
				break
			end
		end
	end
	l_t.tbForceSelPlayer = nil
end

--保存地图玩家信息
ChatWindow.SavePlayerInfo = function( szName, nProf, nLvl,  nFigureId, bOnline, uOfflineTime, nTime, nCombat, nVip, nTitle, tbFigure )
	if not l_t.tbSpeakers.tbOrder then
		l_t.tbSpeakers = { tbOrder = {}, tbInfo = {}, nCnt = 0 }
	end

	local tbSpeakers = l_t.tbSpeakers

	local nLastTime = 0	
	local nMake = 0
	if tbSpeakers.tbInfo and tbSpeakers.tbInfo[szName] then
		nLastTime = tbSpeakers.tbInfo[szName].nTime
	end
	
	ChatWindow.DeletePlayerInfo( szName )
	local tbInfo = 
	{
		szName			= szName,
		nProf			= nProf,
		nLvl			= nLvl,
		nFigureId 		= nFigureId,
		bOnline			= bOnline,
		uOfflineTime	= uOfflineTime, 
		nCombat			= nCombat,
		nVip			= nVip,
		nTitle			= nTitle,
		nTime 	= nTime,
		tbFigure = tbFigure
	}
	
	G_NpcSet:AddPlayerName( szName, nVip, nTitle )
	
	if nLastTime ~= 0 and nTime == 0 then
		tbInfo.nTime = nLastTime
	end
	
	tbSpeakers.tbInfo[szName] = tbInfo
	if tbSpeakers.nCnt >= l_nMaxChatNum then
		local szLast = table.remove( tbSpeakers.tbOrder )
		l_t.tbSpeakers.tbInfo[szLast] = nil
		
		--删除演员列表中的演员
		G_NpcSet:DeletePlayerName( szLast )
		nMake = 1
	else
		tbSpeakers.nCnt = tbSpeakers.nCnt + 1
	end
	-- 二分排序找位置 使用时保证数组有序
	local nInsertPos = l_fBinaryFindInsertPos(  tbSpeakers.tbOrder, szName, l_t.fListSort )
	table.insert( tbSpeakers.tbOrder, nInsertPos, szName )
	if nMake == 1 then
		l_t.tbInputData = l_t.PrepareDate( )
	end
	-- 设置刷新闹钟
	if not l_t.RoleListCont:isTimerPresent( 0 ) and l_t.IsVisible( ) and 
		( l_t.nCurPageIdx == l_ChatDef.chat_room_id_global or l_t.nCurPageIdx == l_ChatDef.chat_room_mumbo ) and nTime ~= 0 then
		l_t.RoleListCont:setTimer ( 0, l_t.nRefreshHeadTime )
	end

end

--删除地图玩家信息
ChatWindow.DeletePlayerInfo = function( szName )
	local tbSpeakers = l_t.tbSpeakers
	if tbSpeakers.tbInfo and tbSpeakers.tbInfo[szName] then
		for idx, val in ipairs( tbSpeakers.tbOrder ) do
			if szName == tbSpeakers.tbOrder[idx] then 
			
				table.remove( tbSpeakers.tbOrder, idx )
				tbSpeakers.nCnt = tbSpeakers.nCnt - 1
				tbSpeakers.tbInfo[szName] = nil

				break				
				
			end
		end
		
		--删除演员列表中的演员
		G_NpcSet:DeletePlayerName( szName )
	end
end

-- 世界玩家列表排序规则
ChatWindow.fListSort = function( uLeft, uRight )
	if not uLeft or not uRight then
		return
	end

	local tbSpeakers = l_t.tbSpeakers
	local tbLeft = tbSpeakers.tbInfo[ uLeft ]
	local tbRight = tbSpeakers.tbInfo[ uRight ]
    
	-- 	后说话在前
	local nLeft = tbLeft.nTime
	local nRight = tbRight.nTime
	if nLeft ~= nRight then
		return nLeft > nRight
	end 
    
	-- 没说话等级高在前
	local nLeft = tbLeft.nLvl
	local nRight = tbRight.nLvl
	if nLeft ~= nRight then
		return nLeft > nRight
	end 
	
	return false
end

--玩家进入地图增加信息
ChatWindow.PlayerIntoWorld = function( pNpc )
	if not pNpc then
		return
	end
	l_t.SavePlayerInfo( pNpc:GetName( ), pNpc:GetProf( ), pNpc:GetLevel( ), 1, 1, 0, 0, pNpc:GetTotalCombatVal( ) , pNpc:GetVip( ), pNpc:GetTitle( ),{ pNpc:GetFigure(1), pNpc:GetFigure(2)} )
end

--玩家离开游戏更新世界玩家头像
-- 此函数由于需求不需要
ChatWindow.PlayerLeftWorld = function ( pNpc )
	if not  pNpc then
		return
	end
end
--------------------------------------------------
--					公会
--------------------------------------------------
-- 切换到工会标签回调事件
ChatWindow.InsertSocial = function( tbResult )
	ChatWindow.tbSocialData = {	}
	
	for k, v in pairs( tbResult ) do
		local tbData = {	}
		
		tbData.szName		= v.Name
		tbData.nLvl			= v.Level
		tbData.nVip			= v.Vip
		tbData.nProf		= v.Prof
		tbData.nFigureId	= 0
		tbData.uGroupID		= 0
		tbData.uOfflineTime	= v.Time
		tbData.nTitle		= v.Title
		
		if v.Time > 0 then
			tbData.bOnline = 0
		else
			tbData.bOnline = 1
		end
		
		ChatWindow.tbSocialData[k] = tbData
	end
	
	ChatWindow.RefreshPlayer( Chatdef.chat_room_id_social )
end

--------------------------------------------------
--                          分组好友相关
--------------------------------------------------
-- 添加好友响应回调
ChatWindow.OnAddFrd = 
{
	[ l_FriendDef.friend_group_contact ] = function( szFriendName )
		if l_t.bDelaySwitch then
			-- 主动私聊
			l_t.FriendBtn:setSelected( false )
			l_t.FriendBtn:setSelected( true )
			l_t.bDelaySwitch = false
			-- 推送消息
			if szFriendName == l_t.szPushName then
				ChatWindow.OnPushNotice(l_t.szPushName, l_t.nProf)
			end
		else
			-- 被私聊			
			if ChatWindow.UpdateFriendMsg( szFriendName, l_t.szCurSelPlayer ~= szFriendName ) then
				if l_t.ChatWindow:isVisible( ) and l_t.FriendBtn:isSelected( ) then
					l_t.RefreshPlayer( l_nChatRoomIdPrivate )
				end
			end
			-- 设置选择人物
			if "" == l_t.szCurSelPlayer then
				if l_t.FriendBtn:isSelected( ) then
					l_t.AutoSelFriend( )
				end
			else
				for nIdx, szName in ipairs( l_t.tbCurPlayersInfo ) do
					if l_t.szCurSelPlayer == szName then
						l_t.ShowFriendSetWnd( l_t.tbCurPlayersInfo[ nIdx ] )
					end
					break
				end
			end
		end
	end,
	[ l_FriendDef.friend_group_black ] = function( szFriendName, bMsgNotify )	
		-- 设置刷新闹钟
		if not l_t.RoleListCont:isTimerPresent( 0 ) and l_t.IsVisible( ) and l_t.nCurPageIdx == l_ChatDef.chat_room_id_global then
			l_t.RoleListCont:setTimer ( 0, l_t.nRefreshHeadTime )
		end
		if bMsgNotify == 1 then
			l_t.FriendBackCallBack(  szFriendName )
		end
	end,
	[ l_FriendDef.friend_group_default ] = function( szFriendName, bMsgNotify )	
		-- 框架性保留函数
	end,
}

--获取排序完成的好友列表
ChatWindow.GetSortedTable = function( )	
	local nCnt = 0 
	local tbFriendInfos = {	}
	for szName, tbInfo in pairs( G_TecentMgr.tbChatFriends ) do
		if l_tMsgFriendList[szName] then
			local tInfo = tbInfo
			if l_t.tbForceSelPlayer and l_t.tbForceSelPlayer.Name and l_t.tbForceSelPlayer.Name == szName then
				table.insert( tbFriendInfos, 1, tInfo )		
			else
				table.insert( tbFriendInfos, tInfo )
			end
			nCnt = nCnt + 1
		end
	end
	for szName, tbinfo in pairs( G_FriendMgr.tbFriendSet ) do 
		if l_tMsgFriendList[szName] then
			local tInfo = l_t.GetTbInfo( szName )
			if l_t.tbForceSelPlayer and l_t.tbForceSelPlayer.Name and l_t.tbForceSelPlayer.Name == szName then
				table.insert( tbFriendInfos, 1, tInfo )		
			else
				table.insert( tbFriendInfos, tInfo )
			end
			nCnt = nCnt + 1
		end
	end
	table.sort( tbFriendInfos, l_t.SortFriendByGroup )
	for i = l_nMaxPrivateChatNum, nCnt do
		table.remove( tbFriendInfos )
	end
	l_t.SwithAttrStyle( tbFriendInfos )
	return tbFriendInfos
end

-- 好友排序 
ChatWindow.SortFriendByGroup = function( tbLeft, tbRight )
	local szLeftName = tbLeft.szName
	if tbLeft.szOpenId then
		szLeftName = tbLeft.szOpenId
	end
	local szRightName = tbRight.szName
	if tbRight.szOpenId then
		szRightName = tbRight.szOpenId
	end
	-- 获得是否有未读消息
	local bLeftUnreadFlag = 0
	local bRightUnreadFlag = 0
	if l_tMsgUnReadNum[ szLeftName ] and l_tMsgUnReadNum[ szLeftName ] ~= 0 then
		bLeftUnreadFlag = 1
	end
	if l_tMsgUnReadNum[ szRightName ] and l_tMsgUnReadNum[ szRightName ] ~= 0 then
		bRightUnreadFlag = 1
	end	
	
	if bLeftUnreadFlag ~= bRightUnreadFlag then
		return bLeftUnreadFlag > bRightUnreadFlag
	end
	
	if tbLeft.nOnline ~= tbRight.nOnline then
		return tbLeft.nOnline > tbRight.nOnline
	end

	local tbLeftFriend = l_tMsgFriendList[szLeftName]
	local tbRightFriend = l_tMsgFriendList[szRightName]
	if tbLeftFriend.Time ~= tbRightFriend.Time then
		return tbLeftFriend.Time > tbRightFriend.Time
	end
	
	return false
end

--替换tbInfo的属性形式
ChatWindow.SwithAttrStyle = function( tbFriendInfos )
	for nId, val in pairs( tbFriendInfos ) do
		val.nLvl = val.nLevel
		val.uOfflineTime = val.uLstPlayTime
		val.bOnline = val.nOnline
		val.nVip = val.nVipLv
		val.nCombat = val.nCombatVal	
		val.TitleID = val.nColor
		val.uGroupID = val.nGroupId
	end
end

--根据名字拿到对应的数据
ChatWindow.GetTbInfo = function( szName )
	local pTbInfo = G_FriendMgr:FindFriend( szName )
	local tbInfo = { }
	for key, val in pairs( pTbInfo ) do
		tbInfo[key] = val 
	end
	return tbInfo
end

--获取最后发言的好友 ceshi 该函数有BUG先注释掉 
ChatWindow.GetLastMsgFriend = function( )
--[[	local szFriendName = ""
	local uLastMsgTime = 0
	for szName, tbinfo in pairs( G_FriendMgr.tbFriendSet ) do 
			if l_tMsgFriendList[szName] then
				local tbInfo = l_t.GetTbInfo( szName )
				if uLastMsgTime < tbInfo.uLastMsgTime then
					szFriendName = szName
					uLastMsgTime = tbInfo.uLastMsgTime
				end
			end
	end
	return szFriendName
--]]
	return nil
end

--更新好友最后发言消息
ChatWindow.UpdateFriendMsg = function( szName, bNeedAdd, szTencentName )
	local tbInfo = nil
	if szTencentName then
		tbInfo = G_TecentMgr:FindFriend( szName )
	elseif G_FriendMgr.tbFriendSet[szName] then
		tbInfo = l_t.GetTbInfo( szName )		
	end	
	l_tMsgFriendList[szName] = {	} 
	if szTencentName then
		l_tMsgFriendList[szName].Name = szTencentName
		l_tMsgFriendList[szName].OpenId = szName
	else
		l_tMsgFriendList[szName].Name = szName
		if l_tMsgFriendList[szName].OpenId then
			l_tMsgFriendList[szName].OpenId = nil
		end
	end
	l_tMsgFriendList[szName].Time = SSvrUnixTimeStamp( )
	if tbInfo then
		l_tLastMsgTime[ szName ] = l_nMsgTime
		l_nMsgTime = l_nMsgTime + 1
		if bNeedAdd then
			if l_tMsgUnReadNum[ szName ] then 
				l_tMsgUnReadNum[ szName ] = l_tMsgUnReadNum[ szName ] + 1
			else
				l_tMsgUnReadNum[ szName ] = 1
			end
			l_t.nUnreadPrivate = l_t.nUnreadPrivate + 1
			l_t.nUnreadMsgs = l_t.nUnreadMsgs + 1
			l_t.RefreshFriendNum( )
			l_t.RefreshPriNum( )
			l_t.RefreshPMNum( )
			G_UIConScript.RefreshPMNum( )
		end
		return true
	end
	return false
end

--清除好友发言数量
ChatWindow.ClearFriendMsgNum =  function( szName, uGroupID )
	if l_tMsgUnReadNum[ szName ] then
		l_t.nUnreadMsgs  = l_t.nUnreadMsgs - l_tMsgUnReadNum[ szName ]
		l_t.nUnreadPrivate = l_t.nUnreadPrivate - l_tMsgUnReadNum[ szName ]
		l_tMsgUnReadNum[ szName ] = 0
		l_t.RefreshPMNum( )
		l_t.RefreshPriNum( )
		l_t.RefreshFriendNum( )
	end
end

--获取好友发言数量
ChatWindow.GetFriendMsgNum = function( szName, uGroupID )
	if l_tMsgUnReadNum[ szName ] then
		return l_tMsgUnReadNum[ szName ]
	end
	return 0
end

--获取好友后缀
ChatWindow.GetFriendSuffix = function( tbRoleWnd )
	local enFriendType = G_MyFriend.GetFriendType( tbRoleWnd.szName )
	local szSuffix = ""
	if l_FriendDef.friend_group_contact == enFriendType then
		szSuffix = SIdToMultiVal( l_tbMultiVal.FriendInfo, 1 )
	end
	
	if tbRoleWnd.bOnline == 0 then
		szSuffix = SIdToMultiVal( l_tbMultiVal.FriendInfo, 2 )
	end

	return szSuffix
end

--显示当前好友
ChatWindow.ShowFriendSetWnd = function( tbRoleWnd )
	if tbRoleWnd and "" ~= tbRoleWnd.szName then
		ChatWindow.ClearFriendMsgNum( tbRoleWnd.szName, tbRoleWnd.uGroupID )
		l_t.CheckFriendState( tbRoleWnd )
		l_t.SetBlackState( tbRoleWnd.szName )
	end
	l_t.ResizeMsgWnd( )
end

--自动选中好友
ChatWindow.AutoSelFriend = function( )
	if l_t.tbForceSelPlayer then
		l_t.SelectPlayer( l_t.tbForceSelPlayer )
		l_t.tbForceSelPlayer = nil
	elseif l_t.nShowIdx ~= 0 then
		G_SlideListMgr:ShowList( "ChatWnd", l_t.nShowIdx )
	elseif l_t.tbCurPlayersInfo[1] then
		if "" == l_t.szCurSelPlayer then
			-- 当没有选中玩家的时候，选中第一个玩家
			local szFirstName = l_t.tbCurPlayersInfo[1].szName
			if l_t.tbCurPlayersInfo[1].szOpenId then
				szFirstName = l_t.tbCurPlayersInfo[1].szOpenId
			end
			l_t.SelectPlayer( l_t.tbFriendWndMap[ szFirstName ] )
		end
	else
		l_t.szCurSelPlayer = ""
		l_t.ChatWnd:removeAllChildWindow( )
		l_t.ResizeMsgWnd( )
	end
	if l_t.szCurSelPlayer == "" then
		l_t.SwitchToTalkModel( )
		l_t.TouchTalk:disable( )
	else
		l_t.SwitchToTalkModel( )
		l_t.TouchTalk:enable( )
	end
end

-- 更新单条好友信息
ChatWindow.FriendInfoUpdated = function( enSureName )
	if l_t.nCurPageIdx ~= l_nChatRoomIdPrivate or not l_t.IsVisible( ) then
		return
	end
	local tbPlayerInfo = l_t.GetSortedTable( )
	for nIdx, tbInfo in ipairs( tbPlayerInfo ) do
		if tbInfo.szName == enSureName then		
			-- 更新现有窗口上的显示内容
			if l_t.tbFriendWndMap[ enSureName ] then
				l_t.tbFriendWndMap[enSureName]:pSetPlayerInfo( tbInfo )
				l_t.CheckFriendState( l_t.tbFriendWndMap[enSureName] )
				l_t.tbFriendWndMap[enSureName]:pCheckOnline( tbInfo )
				l_t.SetBlackState( enSureName )
			end
			break
		end
	end
end

-- 更换分组
ChatWindow.FriendGroupChg = function( szName,  ulGroupId, ulOldGroupId )
	if ulGroupId == l_FriendDef.friend_group_black then
		ChatWindow.FriendRmved ( szName )
		l_t.FriendBackCallBack( szName )
	end
end

--删除好友
ChatWindow.FriendRmved = function( szName )
	if not l_t.IsVisible( ) then
		return
	end
	local pRmvAction = l_t.RmvAction[ l_t.nCurPageIdx ]
	if  pRmvAction then
		pRmvAction( szName )
	end
end

-- 解除好友关系
ChatWindow.OnRmvedFrd = function( ulGroupId, szFriendName  )
	if l_FriendDef.friend_group_default == ulGroupId then
		if l_tMsgFriendList[szFriendName] then
			G_FriendMgr:ReqAddFrd( szFriendName, l_FriendDef.friend_group_contact ) 
		end
	end
end

-- 删除好友具体操作
ChatWindow.RmvAction = 
{
	[ l_nChatRoomIdPrivate ] = function( szName )
		if l_tMsgFriendList[szName] then
			l_tMsgFriendList[szName] = nil
		end
		l_t.RefreshPlayer( l_nChatRoomIdPrivate )
		if l_t.szCurSelPlayer == szName then
			l_t.szCurSelPlayer = ""
			l_t.AutoSelFriend( )
		end
	end,
	[ l_ChatDef.chat_room_id_global ] = function( szName )
		-- 设置刷新闹钟
		if not l_t.RoleListCont:isTimerPresent( 0 ) and l_t.IsVisible( ) and l_t.nCurPageIdx == l_ChatDef.chat_room_id_global then
			l_t.RoleListCont:setTimer ( 0, l_t.nRefreshHeadTime )
		end
	end,
	[ l_ChatDef.chat_room_id_social ] = function( szName )	
		l_t.RefreshPlayer( l_ChatDef.chat_room_id_social )
	end,
}

--调整界面状态
ChatWindow.CheckFriendState  = function( tbRoleWnd )
	if ChatWindow.GetFriendMsgNum( tbRoleWnd.szName, tbRoleWnd.uGroupID ) > 0 then
		tbRoleWnd.pHead:setProperty( "InnerBackground", l_MsgIcon )
		tbRoleWnd.pHead:setProperty( "FrontImage", l_MsgIcon1 )
	else
		tbRoleWnd.pHead:setProperty( "InnerBackground", " " )
		tbRoleWnd.pHead:setProperty( "FrontImage", " " )
	end
end

--------------------------------------------------
--                        主界面聊天框
--------------------------------------------------
--初始化主界面聊天框

ChatWindow.InitMainChatWnd = function( )
	local pWndTemp = nil	
	if l_t.MainChatWnd then
		return
	end
--	Handle
	l_t.MainChatWnd = WindowMgr.LoadLayout( "sat_main_chatwnd.layout" )
	l_t.MainChatWnd:subscribeEvent( l_CEGUI.EventTransformScalingFinished, l_t.OnTransformScaleFinished )
	l_t.MainChatWnd:hide( )
	l_t.CommomChatWnd = l_t.MainChatWnd:getChild( "sat_main_common_chatwnd" )
	l_t.CommomChatWnd:subscribeEvent( l_CEGUI.EventTimer, ChatWindow.OnMainChatLabTimer )
	l_t.CommomChatWnd:subscribeEvent( l_CEGUI.EventAlphaFadingFinished, l_t.OnMainSysAlphaFadingEnd )
	l_t.CommomChatWnd:subscribeEvent( l_CEGUI.EventMoved, l_t.OnCommomChatWndMoved )
	
	
	l_t.AnnouncementWnd = l_t.MainChatWnd:getChild( "sat_announcement_chatwnd" )
	l_t.AnnouncementWnd:subscribeEvent( l_CEGUI.EventTimer, ChatWindow.OnMainChatLabTimer )
	l_t.AnnouncementWnd:subscribeEvent( l_CEGUI.EventAlphaFadingFinished, l_t.OnMainSysAlphaFadingEnd )
	l_t.AnnouncementWnd:subscribeEvent( l_CEGUI.EventMoved, l_t.OnCommomChatWndMoved )
	for idx = 1,2 do
		l_t.tbMsgFlag[ idx ] = l_t.CommomChatWnd:getChild( "satm_wndtxt" .. idx  )
		l_t.tbMsgFlag[ idx ]:hide( )
		pWndTemp = l_t.CommomChatWnd:getChild( "satm_clippedwnd" .. idx )
		l_t.nPicSize = pWndTemp:getAbsoluteHeight( )
		l_t.tbMsg[ idx ] = l_UIHelper.toSLable( pWndTemp:getChildByID( 0 ) ) 
		l_t.tbMsg[ idx ]:subscribeEvent( l_CEGUI.EventTouchClick, ChatWindow.OnClickLabel )
		l_t.tbMsg[ idx ]:subscribeEvent( l_CEGUI.EventAutoMovingFinished , ChatWindow.OnMovingFinished )
		l_t.tbMsg[ idx ].pFlag = l_t.tbMsgFlag[ idx ] 
	end
	l_t.nMainTxtWidth = l_t.tbMsg[1]:getAbsoluteWidth( )
	l_t.nSingleHeight = l_t.tbMsgFlag[1]:getAbsoluteHeight( )
	l_t.nSingleWidth = pWndTemp:getAbsoluteWidth( )
	l_t.SysMsgWnd = l_UIHelper.toSSlideContainer( l_t.AnnouncementWnd:getChild("sat_main_sys_wnd") )	
	l_t.SysMsgWnd:subscribeEvent( l_CEGUI.EventTimer, ChatWindow.OnMainSysLabTimer )	
	l_t.SysMsgPage = l_t.SysMsgWnd:GetContainer( )
	l_t.SysMsgLab = l_UIHelper.toSLable( l_t.MainChatWnd:getChild( "sat_main_sys_lab") )
	l_t.SpreakWnd = l_t.MainChatWnd:getChild( "smc_spreak" )
	l_t.SpreakWnd:subscribeEvent( l_CEGUI.EventTimer, l_t.OnSpreakLabTimmer )
	l_t.SpreakWnd:subscribeEvent( l_CEGUI.EventAlphaFadingFinished, l_t.OnSpreakLabAlphaFadingEnd )
	l_t.SpreakWnd:hide( )
	l_t.SpreakSLH = l_t.SpreakWnd:getChild( "smc_wndtxt" )
	l_t.SpreakSLH:hide( )
	l_t.SpreakLab = l_UIHelper.toSLable( l_t.SpreakWnd:getChild( "smcs_commond" ) )
	l_t.SpreakLab:subscribeEvent( l_CEGUI.EventAutoMovingFinished, l_t.SpreakLabFinished )
	l_t.SpreakLab:subscribeEvent( l_CEGUI.EventTouchClick, ChatWindow.OnClickLabel )
	--缓存系统窗口两种状态的YPos和高度(另一种高度为0)
	l_t.nCommonChatWndYPos = l_t.CommomChatWnd:getAbsoluteYPosition( )
	l_t.nSysMsgWndMaxHeight = l_t.SysMsgWnd:getAbsoluteHeight( )
	l_t.nSysMsgWndYPos = l_t.SysMsgWnd:getAbsoluteYPosition( )
	l_t.SysMsgWnd:setAbsoluteHeight( 0 )
	
	l_t.ShowBtn 	= l_t.MainChatWnd:getChild( "smc_msgbtn" )
	l_t.MsgCount 	= l_t.ShowBtn:getChild( "smc_msgcount" )
	l_t.MsgCount:hide( )
--  Envent	
	l_t.ShowBtn:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnShowChatWnd )
	l_t.ShowBtn:subscribeEvent( l_CEGUI.EventTouchDown, l_t.OnShowTouchDown )
	
	-- 加载隐藏玩家控件
	l_t.pSwithWnd = l_t.MainChatWnd:getChild( "smc_swithwnd" )
	l_t.ShieldTipsBtn =  l_t.pSwithWnd:getChild( "sma_swith_hidenpc_txt" )
	l_t.ShieldTipsBtn:subscribeEvent( l_CEGUI.EventTouchClick, l_t.OnShowSystemSetup )
	l_t.ShieldTipsBtn:subscribeEvent( CEGUI.EventTimer, l_t.HideShieldTipsBtn )
end

--显示主界面聊天框
ChatWindow.ShowMainChatWnd = function( )
	l_t.InitMainChatWnd( )
	l_t.MainChatWnd:show( )
	l_t.pSwithWnd:show( )
	l_t.CommomChatWnd:startAlphaFading( 0, 0.5 )
	l_t.CommomChatWnd:hide( )
	l_t:Init( )
end

--隐藏主界面聊天框
ChatWindow.HideMainChatWnd = function( )
	if l_t.MainChatWnd then
		l_t.MainChatWnd:hide( )
	end
end

--退出主界面聊天框
ChatWindow.ExitMainChatWnd = function( )
	if not l_t.MainChatWnd then
		return
	end
		
	for i, v in pairs( l_t.tbMsg ) do
		v:hide( )	
	end
	l_t.tbMainChatTxt = {	}
	if l_t.CommomChatWnd then
		l_t.CommomChatWnd:setAlpha( 0 )
		l_t.CommomChatWnd:removeAllTimer( )
		l_t.SysMsgWnd:removeAllTimer( )
	end
end

--普通消息定时隐藏窗口
ChatWindow.OnMainChatLabTimer = function ( )
	l_t.CommomChatWnd:removeAllTimer()
	if l_t.SysMsgWnd:isTimerPresent( 0 ) then
		return
	end
	
	l_t.CommomChatWnd:startAlphaFading( 0, 0.5 )
	l_t.CommomChatWnd:hide( )
end

--系统消息渐隐结束
ChatWindow.OnMainSysAlphaFadingEnd = function(  )
	if not l_t.CommomChatWnd then
		return
	end
	
    if l_t.CommomChatWnd:getAlpha( ) < 0.1 then
    	l_t.CommomChatWnd:setAbsoluteYPosition( l_t.nCommonChatWndYPos )
    	l_t.RecycleSysMsgInfo( )
    	l_t.CommomChatWnd:hide( )
    	l_t.AnnouncementWnd:hide( )	
	end
end 

--喇叭消息渐隐结束
ChatWindow.OnSpreakLabAlphaFadingEnd = function( )
	if not l_t.SpreakWnd then
		return
	end
	
    if l_t.SpreakWnd:getAlpha( ) < 0.1 then
    	l_t.SpreakLab:stopAutoMoving( )
    	l_t.SpreakWnd:hide( )
    	l_t.SpreakWnd:stopAllUIEffect( )
	end
	l_t.SpreakWnd:hide( )
end

-- 聊天窗口Y坐标改变
l_t.OnCommomChatWndMoved = function( )
	--l_t.AnnouncementWnd:setAbsoluteHeight( l_t.MainChatWnd:getAbsoluteHeight( ) - l_t.AnnouncementWnd:getAbsoluteYPosition( ) -  l_t.CommomChatWnd:getAbsoluteHeight( ) )
	l_t.AnnouncementWnd:setAbsoluteHeight( l_t.nCommonChatWndYPos - l_t.AnnouncementWnd:getAbsoluteYPosition( ) - 5* l_System:getSystemScale( ) )
	local nSysWndH = l_t.nCommonChatWndYPos - l_t.AnnouncementWnd:getAbsoluteYPosition( ) - l_t.nSysMsgWndYPos - 10* l_System:getSystemScale( ) 	
	l_t.SysMsgWnd:setAbsoluteHeight( math.max( nSysWndH, 0 ) )
	 l_t.AnnouncementWnd:hide( )
end

--系统窗口timer处理函数
local l_tbSysLabTimerProcFunc = {} 

--隐藏Timer处理函数
l_tbSysLabTimerProcFunc[0]= function( )
	l_t.SysMsgWnd:removeAllTimer( )
	
	if l_t.CommomChatWnd:isTimerPresent( 0 ) then
		l_t.SysMsgWnd:setTimer( 2, 0.5 )
	else
		--渐隐的情况
		l_t.CommomChatWnd:startAlphaFading( 0, 0.5 )
	end
	l_t.CommomChatWnd:hide( )
end 

--上升Timer处理函数
l_tbSysLabTimerProcFunc[1]=  function( )
	if not l_t.AnnouncementWnd then
		return
	end
	
	local nStepSpace = l_t.nCommonChatWndYPos / 3
	if l_t.AnnouncementWnd:getAbsoluteYPosition( ) > 1 then
		local nFinalYPos = l_t.AnnouncementWnd:getAbsoluteYPosition( ) - nStepSpace
		if nFinalYPos < 0 then
			nFinalYPos = 0
		end
		l_t.AnnouncementWnd:startAutoYMoving( 0, nFinalYPos, 0.3, CEGUI.CURVE_QuadEaseInOut )
	elseif l_t.SysMsgPage:getAbsoluteYPosition( ) + l_t.SysMsgPage:getAbsoluteHeight( ) > l_t.SysMsgWnd:getAbsoluteHeight( ) + 1 then		
		local nFinalYPos = l_t.SysMsgPage:getAbsoluteYPosition( ) - nStepSpace
		if nFinalYPos < l_t.SysMsgWnd:getAbsoluteHeight( ) - l_t.SysMsgPage:getAbsoluteHeight( ) - 1 then
			nFinalYPos = l_t.SysMsgWnd:getAbsoluteHeight( ) - l_t.SysMsgPage:getAbsoluteHeight( )
		end
		l_t.SysMsgPage:startAutoYMoving( 0, nFinalYPos, 0.3, CEGUI.CURVE_QuadEaseInOut )
	else
		l_t.SysMsgWnd:removeTimer( 1 )
	end
	 l_t.AnnouncementWnd:hide( )
end

--下降Timer处理函数
l_tbSysLabTimerProcFunc[2] = function( )
	if not l_t.AnnouncementWnd then
		return
	end
	
	local nStepSpace = l_t.nCommonChatWndYPos / 3
	if l_t.AnnouncementWnd:getAbsoluteYPosition( ) < l_t.nCommonChatWndYPos - 1 then
		local nFinalYPos = l_t.AnnouncementWnd:getAbsoluteYPosition( ) + nStepSpace
		if nFinalYPos > l_t.nCommonChatWndYPos then
			nFinalYPos = l_t.nCommonChatWndYPos
		end
		l_t.AnnouncementWnd:startAutoYMoving( 0, nFinalYPos, 0.3, CEGUI.CURVE_QuadEaseInOut )
	else
		l_t.SysMsgWnd:removeTimer( 2 )
		for i, v in ipairs( l_t.tbTxtMsgQueue ) do
			l_t.MainChatTxtShow( v.szTxt , true, nil, v.nSendTime )
		end
	end
	 l_t.AnnouncementWnd:hide( )
end

--系统消息定时隐藏窗口
ChatWindow.OnMainSysLabTimer = function(args)
	local timerArgs = l_CEGUI.toTimerEventArgs( args )
	l_tbSysLabTimerProcFunc[timerArgs.id]( )	
end

--喇叭消息定时隐藏
ChatWindow.OnSpreakLabTimmer = function( args )
	if ChatWindow.SpreakWnd then
		local timerArgs = l_CEGUI.toTimerEventArgs( args )
		if timerArgs.id == 0 then
			l_t.SpreakWnd:startAlphaFading( 0, 0.5 )
			l_t.SpreakWnd:stopAllUIEffect( )
			l_t.SpreakWnd:removeAllTimer( )
		end
	end
	l_t.SpreakWnd:hide( )
end

--点击主界面聊天框 
ChatWindow.OnShowChatWnd = function( args )
	local pWnd = l_CEGUI.toTouchEventArgs( args ).window
	if not SysMessage.CheckTouchEffect( pWnd:getName( ) ) then
		return
	end
--	l_t:ConScriptToShow( )
	l_t:Show( )
end
--播放点击反馈特效
ChatWindow.OnShowTouchDown = function( args )
	local pWnd = l_CEGUI.toTouchEventArgs( args ).window
	SysMessage.PlayTouchEffect( pWnd  )
end
--自动移动
ChatWindow.AutoMoving = function( bShow, bDirectMove )
	if not l_t.CommomChatWnd then
		return
	end
	
	if bDirectMove then
		l_t.MainChatWnd:stopTransformScaling()		
		if bShow then
	    	l_t.MainChatWnd:show( )
			l_t.MainChatWnd:setTransformScale( 1.0, 1.0 )
		else
			l_t.MainChatWnd:setTransformScale( 3.0, 3.0 )
		end	
	else
		l_t.MainChatWnd:stopTransformScaling()
		l_t.MainChatWnd:setTransformPivot( g_MainUI:getAbsoluteWidth( )  * 0.5, g_MainUI:getAbsoluteHeight()  * 0.5  )
		if bShow then
	    	l_t.MainChatWnd:show( )
			l_t.MainChatWnd:startTransformScaling( 1.0, 0.4, CEGUI.CURVE_QuadEaseOut )   		
		else
			l_t.MainChatWnd:startTransformScaling( 3.0, 0.6, CEGUI.CURVE_QuadEaseIn )   			
		end
	end
	l_t.CommomChatWnd:hide( )
end
ChatWindow.OnTransformScaleFinished = function( )
	if l_t.MainChatWnd:getTransfromScale().x > 1.1 then
		--需要隐藏掉自己
	    l_t.MainChatWnd:hide( )
	end
	l_t.CommomChatWnd:hide( )
end

--刷新消息数量
ChatWindow.RefreshPMNum = function( )
	local bShow = false
	bShow = l_t.nUnreadMsgs > 0
	if l_t.MsgCount then
		l_t.MsgCount:setVisible( bShow )
		if l_t.nUnreadMsgs > 99 then
			l_t.nUnreadMsgs = 99
		end	
		l_t.MsgCount:setAnsiText( l_t.nUnreadMsgs )
		--刷新战斗界面的小红点
		G_FightShow.RefreshPMNum( )
		--刷新世界boss界面的小红点
		G_UIWorldBoss.RefreshPMNum( )
		--刷新帮会秘境聊天按钮小红点
		G_fam_roommain:UpdateMsgNum( )
		--刷新军征场聊天按钮小红点
		G_UIConScript:RefreshPMNum( )
		G_UIConScript:UpdateMsgNum( )
	end
	if G_League_Reception.pChatMsg then
		G_League_Reception.pChatMsg:setVisible( bShow )
		if l_t.nUnreadMsgs > 99 then
			l_t.nUnreadMsgs = 99
		end
		G_League_Reception.pChatMsg:setAnsiText( l_t.nUnreadMsgs )
	end
end

ChatWindow.RefreshLeagueNum = function( )
	local bShow = false
	bShow = l_t.nUnreadLeague > 0
	l_t.pUnreadLeague:setVisible( bShow )
	if l_t.nUnreadLeague > 99 then
		l_t.nUnreadLeague = 99
	end
	l_t.pUnreadLeague:setAnsiText( l_t.nUnreadLeague )

end

ChatWindow.RefreshPriNum = function( )
	local bShow = false
	bShow = l_t.nUnreadPrivate > 0
	l_t.pUnreadPrivate:setVisible( bShow )
	if l_t.nUnreadPrivate > 99 then
		l_t.nUnreadPrivate = 99
	end	
	l_t.pUnreadPrivate:setAnsiText( l_t.nUnreadPrivate )
end

ChatWindow.RefreshSerNum = function( )
	local bShow = false
	local nTotal = l_t.nUnreadBug + l_t.nUnreadSal
	bShow = nTotal > 0
	l_t.pUnreadSer:setVisible( bShow )
	if nTotal > 99 then
		nTotal = 99
	end
	l_t.pUnreadSer:setAnsiText( nTotal )

end

ChatWindow.RefreshFriendNum = function( nType )
	if nType and nType == 1 then 
		for nIdx , tbVal in ipairs( l_tbRoleWnd ) do
			tbVal.pRed:setVisible( false )
		end
		return
	end
	local bShow = false
	for nIdx , tbVal in ipairs( l_tbRoleWnd ) do
		for szName , tbCurWnd in pairs( l_t.tbFriendWndMap ) do
			if tbCurWnd == tbVal then
				local nTotal = l_tMsgUnReadNum[ szName ]
				if nTotal then
					bShow = nTotal > 0
					tbVal.pRed:setVisible( bShow )
					if nTotal > 99 then
						nTotal = 99
					end
					tbVal.pRed:setAnsiText( nTotal )
				end
			end
		end	
	end
end

--分配系统消息
ChatWindow.AssignSysMsgInfo = function( )
	local pLable = table.remove( l_t.tbFreeLable, 1 )
	if pLable == nil then 
		pLable = l_UIHelper.toSLable(  l_WndMgr:copyWindowWithChild( l_t.SysMsgLab, l_t.nLableIndex ) )
		l_t.nLableIndex = l_t.nLableIndex + 1
	end
	return pLable
end

-- 回收系统消息
ChatWindow.RecycleSysMsgInfo = function( )
	if l_t.SysMsgPage then
		l_t.SysMsgPage:removeAllChildWindow( )
	end
	
	for _,val in ipairs( l_t.tbUseLable ) do 
		val:setAnsiText( "" )
		val:hide( )
		table.insert( l_t.tbFreeLable, val )
	end
	l_t.tbUseLable = {}
end

-- 添加系统消息
ChatWindow.AddSysMsgInfo = function( szTxtMsg )
	if not l_t.MainChatWnd then
		return
	end
	--l_t.AnnouncementWnd:show( )
	local pLable = l_t.AssignSysMsgInfo( )
	local nLastIdx = table.maxn( l_t.tbUseLable )
	local nYPos = 0
	if nLastIdx > 0 then
		nYPos = l_t.tbUseLable[nLastIdx]:getAbsoluteYPosition( ) + l_t.tbUseLable[nLastIdx]:getAbsoluteHeight( )
	else
		l_t.SysMsgPage:setAbsoluteHeight( 0 )
		l_t.SysMsgPage:setAbsoluteYPosition( 0 )
	end
	
	pLable:show( )
	pLable:setAnsiText( szTxtMsg )
	l_t.SysMsgPage:addChildWindow( pLable )
	pLable:setAbsoluteYPosition( nYPos )
	
	pLable:hide( )
	local nLableHeight = math.max( pLable:getAbsoluteHeight( ), l_t.nSysMsgWndMaxHeight )
	l_t.SysMsgPage:setAbsoluteHeight( nYPos + nLableHeight )
	table.insert( l_t.tbUseLable, pLable )
end

--设置主界面聊天框文字
ChatWindow.MainChatTxtShow = function( TxtMsg , nSysTap, nSpreak, nSendTime )
	--系统消息
	if nSysTap == true then
		-- 下降隐藏的情况
		if l_t.SysMsgWnd:isTimerPresent( 2 ) then
			--判断缓存中是否已有该消息
			local bHaveBeenInQueue = false
			for i, v in pairs( l_t.tbTxtMsgQueue ) do
				if v.szTxt == TxtMsg and v.nSendTime == nSendTime then
					bHaveBeenInQueue = true
					break
				end
			end
			if not bHaveBeenInQueue then
				local tbMsg = {}
				tbMsg.szTxt = TxtMsg
				tbMsg.nSendTime = nSendTime
				table.insert( l_t.tbTxtMsgQueue, tbMsg )
			end
		else
			--成功输出则去除缓存中的消息
			for i, v in pairs( l_t.tbTxtMsgQueue ) do
				if v.szTxt == TxtMsg and v.nSendTime == nSendTime then
					table.remove( l_t.tbTxtMsgQueue, i )
					break
				end
			end
			l_t.AddSysMsgInfo( TxtMsg )
			if not l_t.SysMsgWnd:isTimerPresent( 1 ) then
				l_t.SysMsgWnd:setTimer( 1, 0.5 )
			end
		end
		
		if l_t.SysMsgWnd:isTimerPresent( 0 ) then
			l_t.SysMsgWnd:removeTimer( 0 )
		end
		l_t.SysMsgWnd:setTimer( 0, 15 )
		l_t.CommomChatWnd:startAlphaFading( 1, 0.5 )
	else
		if nSendTime then
			if 0 < nSendTime and nSendTime < ChatWindow.nLastSendTime then
				return
			else
				ChatWindow.nLastSendTime = nSendTime
			end
		end
		--普通消息
		if table.maxn( l_t.tbMainChatTxt ) >= 2 then
			table.remove( l_t.tbMainChatTxt,1 )		
		end
		table.insert( l_t.tbMainChatTxt,TxtMsg )
		for i,v in ipairs( l_t.tbMainChatTxt ) do
			l_t.tbMsg[ i ]:setAnsiText( l_t.tbMainChatTxt[ i ] )
			l_t.tbMsg[ i ]:show( )
			--如果长度过长，文字进行滚动
			if l_t.tbMsg[ i ]:GetLayoutWidth( ) >= l_t.nSingleWidth then
				l_t.tbMsg[ i ]:setXPosition( 1, 0 )
				l_t.tbMsg[ i ]:startAutoXMoving( 0, -l_t.tbMsg[ i ]:GetLayoutWidth( ) , 14 , CEGUI.CURVE_LINEAR  )			
				l_t.tbMsgFlag[ i ]:hide( )
			else
				l_t.tbMsg[ i ]:setXPosition( 0, 0 )
				l_t.tbMsg[ i ]:stopAutoMoving( )
				l_t.tbMsgFlag[ i ]:hide( )
			end
		end
		l_t.CommomChatWnd:startAlphaFading( 1, 0.5 )
		
		if l_t.CommomChatWnd:isTimerPresent( 0 ) then
			l_t.CommomChatWnd:removeTimer( 0 )
		end
		l_t.CommomChatWnd:setTimer( 0, 30 )
	end
	if nSpreak == true then
		l_t.SpreakWnd:setAlpha( 0 )
		l_t.SpreakLab:setAnsiText( TxtMsg )
		l_t.SpreakWnd:show( )
		l_t.SpreakWnd:setPlayUIEffect( false, 0 )
		l_t.SpreakWnd:setPlayUIEffect( true, 0 )
		--l_t.SpreakLab:setXPosition( 1, 0 )
		l_t.SpreakWnd:removeAllTimer( )
		ChatWindow.SpreakScroll( )
		l_t.SpreakWnd:setTimer( 0, SPlayerComVar( Playerdef.player_chat_speaker_continue ) )
		l_t.SpreakWnd:startAlphaFading( 1, 0.5 )
	end
    l_t.CommomChatWnd:show( )
    l_t.CommomChatWnd:hide( )
    l_t.SpreakWnd:hide( )
end

--滚动一次结束
ChatWindow.OnMovingFinished = function( args )
	local pWnd = l_CEGUI.toWindowEventArgs( args ).window
	if pWnd:getAbsoluteXPosition( ) < -1 then 
		pWnd:setXPosition( 1, 0 )
		pWnd:startAutoXMoving( 0, 0, 6 , CEGUI.CURVE_LINEAR  )
	else
		pWnd:setXPosition( 0, 0 )
		pWnd:stopAutoMoving( )
		pWnd.pFlag:show( )
	end
end

--点击主界面聊天框
ChatWindow.OnClickMainChatWnd = function( args )
	if l_t.CommomChatWnd:getAlpha(  ) > 0 then
		l_tbLableProc[ l_tTransLinkType.nErrorLink ]( )
	end
end

--点击标签
ChatWindow.OnClickLabel = function( args )
	local touchEvent	= l_CEGUI.toTouchEventArgs( args )
	local pLable		= l_UIHelper.toSLable( touchEvent.window )
	local pickedElem	= pLable:PickupElem( touchEvent.position.x, touchEvent.position.y )
	local nLinkType		= l_tTranslator.GetElemType( pickedElem )
	
	--正在战斗中，不能跳转
	if G_FightShow.IsVisible( true ) then 
		local szText = SIdToMultiVal( l_tbMultiVal.ChatValue, 6 )
		SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )		
		return 	
	end	
	
	if l_tbLableProc[nLinkType] then
		return l_tbLableProc[nLinkType]( pickedElem, touchEvent.position )
	else
		l_tbLableProc[ l_tTransLinkType.nErrorLink ]( )
	end

	return false
end

--播放语音消息
ChatWindow.OnPlayVoiceMsg =function( tbLable )
	if not tbLable then
		return
	end

	if ChatWindow.Busy then
		return
	end
	if SGetCurNetState( ) ~= net_state_wifi then
		SysMessage.AddMsg( SIdToStyle( UIConfigs.NoWifiTips ) )
	end
	G_SystemSetup.MuteSet( true )
	l_AppController:StartPlay( ChatWindow.GetCurChannel( ) ,tbLable.nVoiceId )
	ChatWindow.BeginPlayVoice(  )
	tbLable.pMsgWnd:setProperty( "FrontImage", "set:sat_phiz_axinhaoxian image:0" )
	ChatMsgCenter.pPlayingWnd = tbLable.pMsgWnd
	ChatWindow.Busy = true
	ChatWindow.CacheVoiceMsgByID( tbLable.nVoiceId, ChatWindow.GetCurChannel( ) )
end
--------------------------------------------------
--                         接收消息
--------------------------------------------------
--添加聊天消息窗口
ChatWindow.AddMessage = function( msgInfo, bNew )
	local pLabel		= nil
	local pMsgLabel	= nil
	ChatWindow.HideModelGirl( )
	if l_ChatDef.chat_room_id_speaker == msgInfo.uChannelID and ChatWindow.SpreakWnd:isVisible( true ) then
		local bSelf = msgInfo.szSender == Me:GetName( )
		if msgInfo.szTencentName then
			bSelf = msgInfo.szSender == g_szAccount
		end
		local pHead = l_t.SpreakHead
		pHead:setProperty( "ClientAreaBackgroundExt", G_Prof[msgInfo.nProf] )
		pHead:setYRotation( 0 )
		l_t.SpreakLable:setAnsiText( msgInfo.szMsg )
		ChatWindow.setSpreakHeight( l_t.SpreakBG )
		l_t.SpreakBG:removeAllTimer( )
		l_t.SpreakBG:setTimer( 0, SPlayerComVar( Playerdef.player_chat_speaker_continue ) )
		if l_t.ChatCont:getAbsoluteYPosition( ) == 0 then
			l_t.SpreakBG:show( )
			local nYPos = l_t.ChatCont:getAbsoluteYPosition( ) + l_t.SpreakBG:getAbsoluteHeight( )
			local nHeight = l_t.ChatCont:getAbsoluteHeight( ) - l_t.SpreakBG:getAbsoluteHeight( )
			l_t.ChatCont:setAbsoluteYPosition( nYPos )
			l_t.ChatCont:setAbsoluteHeight( nHeight )
		end
	end
	if not msgInfo.tbLabel then
		ChatMsgCenter.AssignMsgInfo( msgInfo )
	end
--设置语音消息标识
	if msgInfo.tbLabel.nVoiceId then
		msgInfo.tbLabel.pMsgWnd.bVoice = 1
		l_t.SaveChnIdWhenSenderMsg( )
		ChatWindow.ChkVoiceMsgIsSelf( msgInfo.tbLabel.nVoiceId )
	else
		msgInfo.tbLabel.pMsgWnd.bVoice = 0
	end
	if l_ChatDef.chat_room_id_sys ~= msgInfo.uChannelID then
		local bSelf = msgInfo.szSender == Me:GetName( )
		if msgInfo.szTencentName then
			bSelf = msgInfo.szSender == g_szAccount
		end
		if bSelf then
			ChatWindow.SetAutoDocking( true )
		else
			ChatWindow.SetAutoDocking( false )
		end
		pMsgLabel = msgInfo.tbLabel.pMsgWnd		
		pMsgLabel:show( )
		
		local pLv = msgInfo.tbLabel.pLv
		if l_t.nCurPageIdx == l_ChatDef.chat_room_id_global then
			if msgInfo.nLevel then
				pLv:setAnsiText(string.format( SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),msgInfo.nLevel ) )	
			else
				if msgInfo.szSender then
					if Me:GetName( ) == msgInfo.szSender then
						pLv:setAnsiText(string.format( SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),Me:GetLevel( ) ) )
					else
						local tbInfo = {			}
						tbInfo =  l_t.tbSpeakers.tbInfo[msgInfo.szSender]
						if tbInfo and tbInfo.nLvl then
							pLv:setAnsiText( string.format( SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ) ,tbInfo.nLvl ))
						else
							pLv:setAnsiText( "" )
						end
					end	
				end
			end
		elseif l_t.nCurPageIdx == l_nChatRoomIdPrivate then
	    	if msgInfo.nLevel then
				pLv:setAnsiText( string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),msgInfo.nLevel ) )	
			else
				for nIdx, info in ipairs( l_t.tbCurPlayersInfo ) do
					if ( info.szOpenId and info.szOpenId == msgInfo.szSender ) or info.szName == msgInfo.szSender then
						pLv:setAnsiText( string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),info.nLvl ))
					elseif ( msgInfo.szTencentName and g_szAccount == msgInfo.szSender ) or Me:GetName( ) == msgInfo.szSender then
						pLv:setAnsiText( string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),Me:GetLevel( )  ) )
					end
				end
			end
		elseif l_t.nCurPageIdx == l_ChatDef.chat_room_id_teampvp then
			if msgInfo.nLevel then
				pLv:setAnsiText( string.format( SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),msgInfo.nLevel ) )
			else
				for nIdx, info in ipairs( l_t.tbTeamConScript ) do
					if info.szName == msgInfo.szSender then
						pLv:setAnsiText( string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),info.nLvl) )
					elseif Me:GetName( ) == msgInfo.szSender then
						pLv:setAnsiText(string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ), Me:GetLevel( ) ) )
					end
				end
			end
		elseif l_t.nCurPageIdx == l_ChatDef.chat_room_mijing then
			if msgInfo.nLevel then
				pLv:setAnsiText(string.format( SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),msgInfo.nLevel ))	
			else
				for nIdx, info in ipairs(l_t.tbTeamFam ) do
					if info.szName == msgInfo.szSender then
						pLv:setAnsiText( string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),info.nLvl) )
					elseif Me:GetName( ) == msgInfo.szSender then
						pLv:setAnsiText(string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ), Me:GetLevel( ) ) )
					end
				end
			end
		else
			if msgInfo.nLevel then
				pLv:setAnsiText(string.format( SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),msgInfo.nLevel ) )	
			else
				for nIdx, info in ipairs( l_t.tbNoBlackSocialData ) do
					if info.szName == msgInfo.szSender then
						pLv:setAnsiText(string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ),info.nLvl) )
					elseif Me:GetName( ) == msgInfo.szSender then
						pLv:setAnsiText(string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ), Me:GetLevel( ) ) )
					end
				end
			end
		end		
		
		local pHead = msgInfo.tbLabel.pHead
		pHead:setProperty( "ClientAreaBackgroundExt", G_Prof[msgInfo.nProf] )
		if bSelf then
			pHead:setYRotation( 180 )
		else
			pHead:setYRotation( 0 )
		end

		pLabel = msgInfo.tbLabel.pMsgLabel
	else
		pMsgLabel = msgInfo.tbLabel.pMsgWnd	
		pMsgLabel:show( )	
		pLabel = msgInfo.tbLabel.pMsgWnd
	end

	if bNew then
		if msgInfo.tbLabel.pTime then
			l_t.ChatWnd:addChildWindow( msgInfo.tbLabel.pTime )
		end
		l_t.ChatWnd:addChildWindow( pMsgLabel )
	else
		l_t.ChatWnd:addChildWindowToFront( pMsgLabel )

		if msgInfo.tbLabel.pTime then
			l_t.ChatWnd:addChildWindowToFront( msgInfo.tbLabel.pTime )
		end
	end

	l_MsgCenter:AddChatMsg( pLabel, msgInfo.szMsg, l_szMsgContainer )
end


--计算聊天消息窗口高度
ChatWindow.setSpreakHeight = function( pWnd )
	if pWnd.bVoice and pWnd.bVoice > 0 then
		pWnd:setVisible( true )
		pWnd:setHeight( 0, ChatMsgCenter.pSelfMsg:getAbsoluteHeight( ) )
		return
	end
	local pLabel = pWnd:getChildByID( 0 )
--	pWnd:setVisible( pLabel:getAbsoluteHeight( ) > 1 )
	
	local nHeight = pLabel:getAbsoluteHeight( ) + pLabel:getAbsoluteYPosition( ) * 2
	local nMsgWidth = ChatMsgCenter.nBubbleWidth - ( ChatMsgCenter.nLabelWidth - pLabel:getAbsoluteWidth( ) )
	nMsgWidth = math.max( nMsgWidth, ChatMsgCenter.nBubbleWidth * 0.66 )
	if nHeight < ChatMsgCenter.nSingleWndHeight then
		pWnd:setHeight( 0, ChatMsgCenter.nSingleWndHeight )
	else
		pWnd:setHeight( 0, nHeight )
	end
end
-- 添加完消息之后事件触发
ChatWindow.ParseFinished = function( szContainer )
	if l_szMsgContainer == szContainer then
		l_t.ResizeMain( )
	end
end

--重新计算大小
ChatWindow.ResizeMain = function( )
	local nChildCount = l_t.ChatWnd:getChildCount( )
	local nPageHeight = 0
	l_t.ChatWnd:setAbsoluteWidth( l_t.ChatCont:getAbsoluteWidth( ) )
	for uIdx = 0, nChildCount - 1 do
		local pChild = l_t.ChatWnd:getChildAtIdx( uIdx )
		if pChild:getChildCount( ) > 0 then
			l_t.ResizeMessage( pChild )
		end

		if pChild:isVisible( true ) then
			if pChild.SysMsg then
				nPageHeight = nPageHeight + l_t.nMsgSpace
			end
			pChild:setYPosition( 0, nPageHeight )
			nPageHeight = nPageHeight + pChild:getAbsoluteHeight( ) + l_t.nMsgSpace
		end
	end
	local bSetPosition = l_t.OnCheckState( )
	l_t.ChatWnd:setAbsoluteHeight( nPageHeight )
	if nPageHeight > l_t.ChatCont:getAbsoluteHeight( ) then
		if bSetPosition then
			l_t.ChatWnd:setYPosition( 0, -nPageHeight + l_t.ChatCont:getAbsoluteHeight( ) )
		end
	else
		l_t.ChatWnd:setYPosition( 0, 0 )
	end
end

--计算聊天消息窗口高度
ChatWindow.ResizeMessage = function( pWnd )
	if pWnd.bVoice and pWnd.bVoice > 0 then
		pWnd:setVisible( true )
		pWnd:setHeight( 0, ChatMsgCenter.pSelfMsg:getAbsoluteHeight( ) )
		return
	end
	local pLabel = pWnd:getChildByID( 0 )
	pWnd:setVisible( pLabel:getAbsoluteHeight( ) > 1 )
	
	local nHeight = pLabel:getAbsoluteHeight( ) + pLabel:getAbsoluteYPosition( ) * 2
	local nMsgWidth = ChatMsgCenter.nBubbleWidth - ( ChatMsgCenter.nLabelWidth - pLabel:getAbsoluteWidth( ) )
	nMsgWidth = math.max( nMsgWidth, ChatMsgCenter.nBubbleWidth * 0.66 )
	pWnd:setAbsoluteWidth( nMsgWidth )
	if pWnd:getAbsoluteXPosition( ) > 0 then
		pWnd:setXPosition( 1, -nMsgWidth )
	end
	
	if nHeight < ChatMsgCenter.nSingleWndHeight then
		pWnd:setHeight( 0, ChatMsgCenter.nSingleWndHeight )
	else
		pWnd:setHeight( 0, nHeight )
	end
end
--------------------------------------------------
--                         聊天泡泡
--------------------------------------------------
--初始化npc泡泡
function G_ChatBubble:Init( )
---GC 内存回收 --------------------
	if self.pBubble then --GC Fix
		return
	end
	self.pBubble = WindowMgr.LoadLayout( "sat_chat_bubble.layout", nil, CEGUI.System:getSingleton( ):getGUISheet( ) )
	self.pBubble:subscribeEvent( l_CEGUI.EventTimer, self.OnBubbleTimer, self )
	--朝左普通气泡
	self.pNormalLeftBubble	= self.pBubble:getChild( "sb_normalleftbubble" )
	self.pNormalLeftBubble:setNoRedraw( true )
	self.pNormalLeftTxt	= self.pNormalLeftBubble:getChild( "sbnlb_txt" )
	--朝右普通气泡
	self.pNormalRightBubble	= self.pBubble:getChild( "sb_normalrightbubble" )
	self.pNormalRightBubble:setNoRedraw( true )
	self.pNormalRightTxt	= self.pNormalRightBubble:getChild( "sbnrb_txt" )
	--居中普通泡泡
	self.pNormalCentreBubble = self.pBubble:getChild("sb_normalcentrebubble")
	self.pNormalCentreBubble:setNoRedraw( true )
	self.pNormalCentreTxt = self.pNormalCentreBubble:getChild( "sbncb_txt" )
	--惊讶气泡
	self.pExclaimBubble = self.pBubble:getChild("sb_centerbubble")
	self.pExclaimBubble:setNoRedraw(true)
	self.pExclaimTxt  = self.pExclaimBubble:getChild( "sbcb_txt" )
   	--思考朝左气泡
	self.pThinkLeftBubble   = self.pBubble:getChild( "sb_thinkleftbubble" )
	self.pThinkLeftBubble:setNoRedraw(true)
	self.pThinkLeftTxt   = self.pThinkLeftBubble:getChild( "sbtlb_txt" )
	--思考朝右气泡
	self.pThinkRightBubble  = self.pBubble:getChild( "sb_thinkrightbubble" )
	self.pThinkRightBubble:setNoRedraw(true)
	self.pThinkRightTxt  = self.pThinkRightBubble:getChild( "sbtrb_txt" )	
	--思考居中气泡
	self.pThinkCentreBubble =  self.pBubble:getChild( "sb_thinkcentrebubble" )
	self.pThinkCentreBubble:setNoRedraw( true )
	self.pThinkCentreTxt = self.pThinkCentreBubble:getChild( "sbtcb_txt" )
	--无底居左
	self.pNoBackNormalLeftBubble	= self.pBubble:getChild( "sb_nbnormalleftbubble" )
	self.pNoBackNormalLeftBubble:setNoRedraw( true )
	self.pNoBackNormalLeftTxt	= self.pNoBackNormalLeftBubble:getChild( "sbnbnlb_txt" )
	--无底居中
	 self.pNoBackNormalCentreBubble = self.pBubble:getChild( "sb_nbnormalcentrebubble" )
	 self.pNoBackNormalCentreBubble:setNoRedraw( true )
	 self.pNoBackNormalCentreTxt = self.pNoBackNormalCentreBubble:getChild( "sbnbnclb_txt" )
	--无底居右
	self.pNoBackNormalRightBubble = self.pBubble:getChild( "sb_nbnormalrightbubble" )
	self.pNoBackNormalRightBubble:setNoRedraw( true )
	self.pNoBackNormalRightTxt = self.pNoBackNormalRightBubble:getChild( "sb_nbnrb_txt" )
	self.pBubble:setXPosition( 0, -10000 )
	self.nNormalBubbleWidth = self.pNormalLeftTxt:getAbsoluteWidth( )    	--设置普通气泡窗口的文本的宽度
	self.nExclaimBubbleWidth = self.pExclaimTxt:getAbsoluteWidth( )       	--设置惊叹气泡窗口的文本的宽度
	self.nThinkBubbleWidth = self.pThinkLeftTxt:getAbsoluteWidth( )		--设置思考气泡窗口的文本的宽度
	l_nThinkBubbleLabHeight = self.pThinkCentreTxt:getAbsoluteHeight( ) --获取思考气泡窗口的文本框的初始高度
end

local l_tSetBubbleWindowFuncs = {}
--设置普通居左的聊天泡泡为显示显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[0] = function( )
	return G_ChatBubble.pNormalLeftBubble,  G_ChatBubble.pNormalLeftTxt , G_ChatBubble.nNormalBubbleWidth
end
--设置普通居右的聊天泡泡为显示显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[1]= function( )
	return G_ChatBubble.pNormalRightBubble, G_ChatBubble.pNormalRightTxt, G_ChatBubble.nNormalBubbleWidth
end
--设置惊讶的聊天泡泡为显示显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[2]=function( )
	return G_ChatBubble.pExclaimBubble, G_ChatBubble.pExclaimTxt, G_ChatBubble.nExclaimBubbleWidth
end
--设置思考居左的聊天泡泡为显示显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[3]= function( )
	return G_ChatBubble.pThinkLeftBubble, G_ChatBubble.pThinkLeftTxt, G_ChatBubble.nThinkBubbleWidth
end
--设置思考居右的聊天泡泡为显示显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[4]= function( )
	return G_ChatBubble.pThinkRightBubble, G_ChatBubble.pThinkRightTxt, G_ChatBubble.nThinkBubbleWidth
end
--设置普通居中的聊天泡泡为显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[5]= function( )
	return G_ChatBubble.pNormalCentreBubble, G_ChatBubble.pNormalCentreTxt, G_ChatBubble.nNormalBubbleWidth
end
--设置思考居中的聊天泡泡为显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[6]= function( )
	return G_ChatBubble.pThinkCentreBubble, G_ChatBubble.pThinkCentreTxt, G_ChatBubble.nThinkBubbleWidth
end
--设置无底居左的聊天泡泡为显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[7]= function( )
	return G_ChatBubble.pNoBackNormalLeftBubble, G_ChatBubble.pNoBackNormalLeftTxt, G_ChatBubble.nNormalBubbleWidth
end
--设置无底居中的聊天泡泡为显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[8]= function( )
	return G_ChatBubble.pNoBackNormalCentreBubble, G_ChatBubble.pNoBackNormalCentreTxt, G_ChatBubble.nNormalBubbleWidth
end
--设置无底居右的聊天泡泡为显示窗口及设置窗口宽度
l_tSetBubbleWindowFuncs[9]= function( )
	return G_ChatBubble.pNoBackNormalRightBubble, G_ChatBubble.pNoBackNormalRightTxt, G_ChatBubble.nNormalBubbleWidth
end


--Npc头顶泡泡
--bClipByDistance ---- 为STRUE时候，会随着距离增大裁剪（头顶信息为100米左右，聊天泡泡50米左右），为FALSE则不需要裁剪，只要有就显示。
--Flag  SAT_UiHeadFlags_NearDistance---//为了保证不和头顶的其他特效穿插，往前面挪动一小段距离
--		  SAT_UiHeadFlags_ClipByScreen---//聊天泡泡的时候，如果没有置换这个标志，当人在屏幕外边的时候会把聊天泡泡放到屏幕内（相对与目标的方向），设置这个标志则聊天泡泡位置不变。
function G_ChatBubble:ShowNPCBubble( pNpc, szMsg, nType, nDuration, bClipByDistance, uFlag , nPos, bUseBracketParse )
	if not pNpc then
		return
	end 
	
	self:Init( )
	local pBubble = nil
	local pTxt = nil
	local nBubbleWidth = nil          
	if nil == nDuration then
		nDuration = self.nDuration
	end
	
	if nil == bClipByDistance then
		bClipByDistance = self.bClipByDistance
	end
	
	if nil == uFlag then
		uFlag = 0
	end

	if nil == nPos then
		nPos = 0
	end
	
	if nil == nType or nil == l_tSetBubbleWindowFuncs[nType] then
		nType = 0
	end
	--根据nType值获取要显示的气泡窗口指针（pBubble）、文本框指针（pTxt）、窗口宽度（nBubbleWidth）
	--0为普通居左的气泡窗口
	--1为普通居右的气泡窗口
	--2为惊讶的气泡窗口
	--3为思考居左的气泡窗口
	--4为思考居右的气泡窗口
	pBubble, pTxt, nBubbleWidth = l_tSetBubbleWindowFuncs[nType]( )     
	--设置所显示的文本的格式
	
	--如果bUseBracketParse则使用方括号的表情解析方式，否则为尖括号的解析方式
	local szParsedMsg = ""
	if bUseBracketParse and 1 == bUseBracketParse then
		szParsedMsg = ParseChatMsg.ParseMsgContent( szMsg, "cn=FF483823" )
	else
		local tTextColor = {Color = " cn=FF483823"}
		szParsedMsg = UIHelper.ParseLable( szMsg, tTextColor )
	end
	
	local szFinalMsg =
			"<Layout w=" .. nBubbleWidth .. ">" .. 
				"<Seg le=4 fs=19 tha=center>" .. 
					szParsedMsg .. 
				"</Seg>" .. 
			"</Layout>"
	pTxt:setAnsiText( szFinalMsg )
	local YPos = pTxt:getAbsoluteYPosition( )
	if 1 == nType or 0 == nType or 5 == nType or 7== nType or 8 == nType or 9 == nType  then
	--普通气泡窗口要根据文本来改变其高度值。
	--具体实现是根据文本（pTxt）的高度、文本与气泡窗口的间距（YPos）
	--以及窗口下角的尖尖的高度来设置气泡窗口的高度
		pBubble:setHeight( 0, YPos*2+pTxt:getAbsoluteHeight( )+23 * CEGUI.System:getSingleton( ):getSystemScale( ) )  
	else
	--非普通窗口居中显示文字。
	--具体做法是根据气泡窗口和文本框的高度差值的一半来设置文本框和气泡窗口之间的间距
		pTxt:setAbsoluteYPosition(( l_nThinkBubbleLabHeight - pTxt:getAbsoluteHeight( ))/2 )
	end	
	self.pBubble:setXPosition( 0, 0 )
	if self.pBubble:isTimerPresent( pNpc:GetRepresentID( ) ) then
		G_ChatBubble:DestoryBubble( pNpc:GetRepresentID( ) )
	end
	l_BillBoard:UpdateBubble( pNpc:GetRepresentID( ), pBubble, nPos , bClipByDistance, uFlag )
	self.pBubble:setXPosition( 0,-10000)
	if nDuration > 0 then
		self.pBubble:setTimer( pNpc:GetRepresentID( ), nDuration )
	end
end

--隐藏聊天泡泡
function G_ChatBubble:HideBubble( pNpc )
	self:DestoryBubble( pNpc:GetRepresentID( ) )
end

--销毁泡泡
function G_ChatBubble:DestoryBubble( uID )
	if not self.pBubble then
		return
	end

	self.pBubble:removeTimer( uID )
	l_BillBoard:DestoryBubble( uID )
end

--泡泡时间响应
function G_ChatBubble:OnBubbleTimer( args )
	local timerArgs = l_CEGUI.toTimerEventArgs( args )
	self:DestoryBubble( timerArgs.id )
end

--------------------------------------------------
--                           其他
--------------------------------------------------
--添加聊天频道
ChatWindow.AddChannel = function( uChannelID , szName )
	l_t.tbChannelName[uChannelID] = szName
	if l_t.tbPageBtns[uChannelID] then
		l_t.tbPageBtns[uChannelID]:setAnsiText( szName )
		l_t.tbPageBtns[uChannelID]:show( )
	end
	if l_t.bIsConScript then
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:hide( )
		l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:show( )
	else
		if l_t.bIsConScriptMain  then
			l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
			l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:show( )
		elseif l_t.bIsFamRoom then
			l_t.tbPageBtns[ l_ChatDef.chat_room_mijing ]:show( )
			l_t.ServiceBtn:hide( )
		else	
			l_t.tbPageBtns[ l_ChatDef.chat_room_id_global ]:show( )
			l_t.tbPageBtns[ l_ChatDef.chat_room_id_teampvp ]:hide( )	
		end
	end
end

--发送私聊消息
ChatWindow.PrivateChat = function( szName, szMsg, nInterval )
	if szName and szMsg then
		if not l_tbTempBlack[ szName ] then
				if l_tMsgFriendList[szName].OpenId then
					G_TecentMgr:ReqPrivateChat( l_tMsgFriendList[szName].OpenId, szMsg )
				else
					G_ChatMgr:ReqPrivateChat( szName, szMsg, nInterval )
				end
				l_tLastMsgTime[ szName ] = l_nMsgTime
				l_nMsgTime = l_nMsgTime + 1
		else
				GlobalComMsgDlg:ResetAll( )
				GlobalComMsgDlg:SetButton1( SIdToStyle( UIConfigs.Ok ), nil, nil, ChatWindow.OnSendMsgToTempBlack )
				GlobalComMsgDlg:SetParam1( szMsg )
				GlobalComMsgDlg:SetButton2( SIdToStyle( UIConfigs.Cancel ) )
				GlobalComMsgDlg:SetPrompt(
					"<Seg tha=center f=wrap><Obj fs=19 cn=FF5F5041>"..
						SIdToStyle( UIConfigs.ChatToBlackTip ) .. 
					"</Obj></Seg>" )
				GlobalComMsgDlg:ShowDlg( l_pTopParent, true )
			end
	end
end

--发送消息
ChatWindow.OnSendMsg = function( args )
	if ChatWindow.Busy then
		return
	end
	if l_t.VoiceSwitch:getID( ) == 1 then
		l_t.SwitchToTalkModel( )
		return
	end
	local text = l_UIHelper.GetText( l_t.InputBox )
	if "" ~= text then
		if Me:GetLevel( ) < G_PlayerSet:GetGlobalChatMinLevel( ) and l_t.tbPageBtns[l_ChatDef.chat_room_id_global ]:isSelected( ) then
			local szText = string.format( SIdToMultiVal( l_tbMultiVal.ChatValue,4 ), G_PlayerSet:GetGlobalChatMinLevel( ) )
			SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )		
			return 		
		end
		if not G_ChatMgr:IsChatValEnough( ) and l_t.tbPageBtns[l_ChatDef.chat_room_id_global ]:isSelected( )then
			local szText = string.format( SIdToMultiVal( l_tbMultiVal.ChatChannel, 6 ), SPlayerComVar( Playerdef.player_chat_globalroom_cost ) - Me:GetTask( ):GetTaskVal( Taskdef.taskval_chat_val ) )
			SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )
			return
		end
		if l_t.nCurPageIdx ~= l_nChatRoomIdPrivate  then
			G_ChatMgr:ReqChatInRoom( l_t.nCurPageIdx, text )
		else
			l_t.PrivateChat( l_t.szCurSelPlayer, text )	
		end
	end
	l_t.InputBox:ClearText( )
end

-- 给被临时屏蔽的玩家发消息
ChatWindow.OnSendMsgToTempBlack = function( text )
	l_tbTempBlack[ l_t.szCurSelPlayer ] = false
	l_t.PrivateChat( l_t.szCurSelPlayer, text )
	l_t.RefreshPlayer( l_nChatRoomIdPrivate )
	l_tLastMsgTime[ l_t.szCurSelPlayer ] = l_nMsgTime
	l_nMsgTime = l_nMsgTime + 1
end

--------------------------------------------------
--                         聊天表情
--------------------------------------------------
--移动聊天表情页面
ChatWindow.MoveEmotions = function( )
	local pEmotionWnd = G_Emotion:GetMainWnd( )
	local nEmotionWndHeight = pEmotionWnd:getAbsoluteHeight( )
	local nInputYPosition 	= l_t.nInputYPosition	
	-- EmotionWnd Y坐标偏移量的补充	
	local nEmotionWndYOffsetEx = 41 * l_System:getSystemScale( )
	-- InPut Y坐标偏移量的补充
	local nInPutYOffsetEx	  = -14 * l_System:getSystemScale( )
	
	local pCurInput	= l_t.InputBox
	if not l_t.ChatParent:isVisible( ) then
		pCurInput = l_t.SerPutBox
	end
	if l_t.bShowEmotion then
		local tPos = 
		{ 
			x = 
			{ 
				scale = 0,
				offset = 95 * l_System:getSystemScale( ) 
			}, 
			
			y = 
			{ 
				scale = 1, 
				offset = 0 
			} 
		}
		G_Emotion:Show( l_t.ChatWindow, tPos, pCurInput )
		l_System:addToShieldingWindowList( pEmotionWnd:getName( ), true )
		l_System:setShieldingEventWindow( l_t.EmotionBtn )
	    pEmotionWnd:startAutoYMoving( 1, -nEmotionWndHeight - nEmotionWndYOffsetEx, CEGUI.CURVE_QuintEaseOut )
	    l_t.InPut:startAutoYMoving( 0, nInputYPosition - nEmotionWndHeight + nInPutYOffsetEx, CEGUI.CURVE_QuintEaseOut )
		l_t.SerPutWnd:startAutoYMoving( 0, nInputYPosition - nEmotionWndHeight + nInPutYOffsetEx, CEGUI.CURVE_QuintEaseOut )
	else
		l_System:clearShieldingWindowList( )
		l_System:setShieldingEventWindow( nil )
	    pEmotionWnd:startAutoYMoving( 1, 0, CEGUI.CURVE_QuintEaseOut )
	    l_t.InPut:stopAutoMoving( )
	    l_t.InPut:setYPosition( 0, nInputYPosition )
	    l_t.SerPutWnd:stopAutoMoving( )
	    l_t.SerPutWnd:setYPosition( 0, nInputYPosition )
	end
	ChatWindow.SetAutoDocking( true )
	l_t.ResizeMsgWnd( )
end

--聊天表情
ChatWindow.OnEmotionBtn = function( args )
	if ChatWindow.Busy then
		return
	end
	if l_t.VoiceSwitch:getID( ) == 1 then
		l_t.SwitchToTalkModel( )
		return
	end
	l_t.bShowEmotion = not l_t.bShowEmotion
	l_t.MoveEmotions( )	
end

--点击表情以外窗口
ChatWindow.OnNotClickEmotionWnd = function( args )
	l_t.bShowEmotion = false
	l_t.MoveEmotions( )
end

--------------------------------------------------
--                         菜单相关
--------------------------------------------------
--创建角色菜单
--个人私聊|加为好友|查看资料|屏蔽玩家|取消屏蔽|进入家园
ChatWindow.CreatRolePopMenu = function( szName, szTencentName )
	-- 获得字符串Table
	local tbTxt = l_pStringToTable( SIdToMultiVal( l_tbMultiVal.PopMenuTxt, 1 ) )
	local szCancelText = SIdToMultiVal( l_tbMultiVal.PopMenuTxt, 2 )
	

	local tbBtnTxt = {}
	local tbBtnEvent = {}
	local tbState		= {	}
	local enFriendType = G_MyFriend.GetFriendType( l_t.szCurSelPlayer )
	
	-- 个人私聊
	if l_t.nCurPageIdx ~= l_nChatRoomIdPrivate then
		table.insert( tbBtnTxt, tbTxt[1] )
		table.insert( tbBtnEvent, l_t.OnMenuPrivateChat )
		if l_FriendDef.friend_group_black == enFriendType then
			table.insert(tbState, true)	
		end
	end
	
	-- 添加好友
	if l_FriendDef.friend_group_default ~= enFriendType and not szTencentName then
		table.insert( tbBtnTxt, tbTxt[2] )
		table.insert( tbBtnEvent, l_t.OnMenuAddFriend )
	end
	
	--查看资料
	table.insert( tbBtnTxt, tbTxt[3] )
	table.insert( tbBtnEvent, l_t.OnMenuShowRoleInfo )
	
	--	私聊增加切磋
	if l_t.nCurPageIdx == l_nChatRoomIdPrivate then
		if  G_FriendMgr:HasRealFriend( l_t.szCurSelPlayer ) then
			table.insert( tbBtnTxt, tbTxt[5] )
			table.insert( tbBtnEvent, l_t.OnMenuFight )
			
			table.insert( tbBtnTxt, tbTxt[15] )
			table.insert( tbBtnEvent, l_t.OnMenuRTFight )
		elseif G_TecentMgr:FindFriend( l_t.szCurSelPlayer ) then
			table.insert( tbBtnTxt, tbTxt[5] )
			table.insert( tbBtnEvent, l_t.OnMenuFight )
		end
	end
	-- 结束会话
	if l_t.nCurPageIdx < 1 then
		table.insert( tbBtnTxt, tbTxt[6] )
		table.insert( tbBtnEvent, l_t.OnMenuResume )
	end
	
	if not szTencentName then
		if l_tbTempBlack[ szName ] then
			-- 取消屏蔽
			table.insert( tbBtnTxt, szCancelText )
			table.insert( tbBtnEvent, l_t.OnCancelShield )
		elseif l_FriendDef.friend_group_black ~= enFriendType then
			-- 屏蔽玩家
			table.insert( tbBtnTxt, tbTxt[4] )
			table.insert( tbBtnEvent, l_t.OnMenuScreenRole )
		end
		if G_leaguelevup.IsIniviteToLeague( ) and l_t.nCurPageIdx ~= l_ChatDef.chat_room_id_social then 
			table.insert( tbBtnTxt, tbTxt[13] ) 
			table.insert( tbBtnEvent, l_t.OnMenuLeagueInvite )
		end
	end
	
	G_PopMenu.CreatePopMenuWnd( table.maxn( tbBtnTxt ),tbBtnTxt,tbBtnEvent,tbState)
end


--私聊
ChatWindow.OnMenuPrivateChat = function( args )
	local pWnd = l_CEGUI.toTouchEventArgs( args ).window
	if pWnd:isDisabled( ) then 
		SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ChatValue,5 ), 2, l_pTopParent )
		return 	
	end
	G_PopMenu:Hide( )
	l_t.SwitchPrivateChat( )
end

-- 私聊具体操作
ChatWindow.SwitchPrivateChat = function( szName, pushflag, nProf, szOpenId )
	if pushflag then
		if szOpenId then
			l_t.szPushName = szOpenId
		else
			l_t.szPushName = szName
		end
	end
	if szOpenId then
		l_t.szCurSelPlayer = szOpenId
	elseif szName then
		l_t.szCurSelPlayer = szName
	end
	if nProf then
		l_t.nProf = nProf
	end
	l_tMsgFriendList[l_t.szCurSelPlayer] = { }
	l_tMsgFriendList[l_t.szCurSelPlayer].Name = l_t.szCurSelPlayer  --当前选择的私聊玩家  
	l_tMsgFriendList[l_t.szCurSelPlayer].Time = SSvrUnixTimeStamp( )
	l_tMsgFriendList[l_t.szCurSelPlayer].OpenId = szOpenId
	if not szOpenId and l_FriendDef.friend_group_begin == G_MyFriend.GetFriendType( l_t.szCurSelPlayer ) then
		G_FriendMgr:ReqAddFrd( l_t.szCurSelPlayer, l_FriendDef.friend_group_contact )  -- 申请添加最近联系人 回调添加好友事件
		l_t.bDelaySwitch = true
		l_t.tbForceSelPlayer = {	szName = l_t.szCurSelPlayer }
	else
		l_t.tbForceSelPlayer = {	szName = l_t.szCurSelPlayer }
		l_t.FriendBtn:setSelected( false )
		l_t.FriendBtn:setSelected( true )
		if pushflag then
			ChatWindow.OnPushNotice(l_t.szCurSelPlayer, nProf)
		end
	end	
end

-- 推送消息
ChatWindow.OnPushNotice = function(sPushName, nProf)
	local tMsg = {SIdToMultiVal( l_tbMultiVal.PushNoticeTips, 0 ),
				  SIdToMultiVal( l_tbMultiVal.PushNoticeTips, 1 ),
				  SIdToMultiVal( l_tbMultiVal.PushNoticeTips, 2 ),
				  SIdToMultiVal( l_tbMultiVal.PushNoticeTips, 3 ),
				  SIdToMultiVal( l_tbMultiVal.PushNoticeTips, 4 ),								
				 }
	local Msg = tMsg[SLogicRand(5) + 1]
	local Prof = nil
	if not nProf then
		 Prof = NpcSet:FindNpcByName(sPushName):GetProf()
	else
		 Prof = nProf
	end
	ChatWindow.ReceivePrivateMsg(sPushName, Me:GetName(),0,Msg, Prof,0,SUnixTimeStamp( ),nil)
	l_t.nUnreadMsgs = l_t.nUnreadMsgs - 1
	l_t.nUnreadPrivate = l_t.nUnreadPrivate - 1
	l_t.RefreshPriNum( )
end

--添加好友
ChatWindow.OnMenuAddFriend = function( args )
	G_PopMenu:Hide( )

	if l_FriendDef.friend_group_default ~= G_MyFriend.GetFriendType( l_t.szCurSelPlayer ) then
		G_FriendMgr:ReqAddFrd( l_t.szCurSelPlayer, l_FriendDef.friend_group_default )
		--SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.FriendApply, 2 ), 2, l_pTopParent )
	end
end

--查看资料
ChatWindow.OnMenuShowRoleInfo = function( args )
	G_PopMenu:Hide( )
	--正在战斗中，不能跳转
	if G_FightShow.IsVisible( true ) then 
		local szText = SIdToMultiVal( l_tbMultiVal.ChatValue, 6 )
		SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )		
		return 	
	end
	if l_t.szCurTencentName then
		G_TecentMgr:ReqFirendView( l_t.szCurSelPlayer )
	else
		G_PlayerViewer:ReqViewEquipByName( l_t.szCurSelPlayer )
	end
end

--屏蔽好友
ChatWindow.OnMenuScreenRole = function( args )
	G_PopMenu:Hide( )
	l_t.SureToShield( )
end

-- 取消屏蔽
ChatWindow.OnCancelShield = function( args )
	G_PopMenu:Hide( )
	l_t.CancelTempBlack( l_t.szCurSelPlayer )
	l_t.SetBlackState( l_t.szCurSelPlayer )
	SysMessage.ShowRuntimeMsg(SIdToMultiVal( l_tbMultiVal.PopMenuTxt, 4 ), 2, l_pTopParent )
end

-- 屏蔽二次确认对话框
ChatWindow.SureToShield = function(  )
	local szTxt = 
		"<Seg tha=center f=wrap>" ..
			"<Obj fs=19 cn=FF5F5041 le=4 >"	..	
				SIdToMultiVal( l_tbMultiVal.FriendInfo, 6 ) .. "\n" ..
				SIdToMultiVal( l_tbMultiVal.FriendInfo, 7 ) .. 
			"</Obj>"	..	
		"</Seg>"
	GlobalComMsgDlg:ResetAll( )
	GlobalComMsgDlg:SetButton1( SIdToStyle( UIConfigs.Ok2 ), nil, nil, l_t.OkShield )
	GlobalComMsgDlg:SetButton2( SIdToStyle( UIConfigs.Cancel2 ), nil, nil, l_t.TempOkShield )
	GlobalComMsgDlg:SetPrompt( szTxt )
	GlobalComMsgDlg:ShowDlg( l_pTopParent )
end

-- 永久屏蔽
ChatWindow.OkShield = function(  )
	if l_FriendDef.friend_group_black ~= G_MyFriend.GetFriendType( l_t.szCurSelPlayer ) then
		if l_tMsgFriendList[l_t.szCurSelPlayer] then
			l_tMsgFriendList[l_t.szCurSelPlayer] = nil
		end
		G_FriendMgr:ReqAddFrd( l_t.szCurSelPlayer, l_FriendDef.friend_group_black )
	end
end

-- 临时屏蔽
ChatWindow.TempOkShield = function(  )
    -- 被临时屏蔽的只能进行取消屏蔽操作, 因此重复屏蔽是属于外部异常
    -- 这里不用做处理
	if ChatWindow.AddTempBlack( l_t.szCurSelPlayer ) then
		l_t.SetBlackState( l_t.szCurSelPlayer )
	end
end

-- 添加临时屏蔽人员
ChatWindow.AddTempBlack = function( szName )
    if l_tbTempBlack[szName] then
        return false
    end

    -- 判断是否超出上限
	if l_nCurBlackNum < l_nMaxBlackNum then
		l_tbTempBlack[ szName ] = true
        l_nCurBlackNum = l_nCurBlackNum + 1
		SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.FriendInfo, 8 ), 2, l_pTopParent )
		return true
	else
		SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.PopMenuTxt, 3 ), 2, l_pTopParent )
		return false
	end
end

-- 取消临时屏蔽人员
ChatWindow.CancelTempBlack = function( szName )
	if nil == szName then
		return
	end
	
	if l_tbTempBlack[ szName ] then
		l_tbTempBlack[ szName ] = nil
        l_nCurBlackNum = l_nCurBlackNum - 1 
	end
end

-- 判断是否是临时屏蔽人员
ChatWindow.IsTempBlack = function( szName )
	return nil ~= l_tbTempBlack[ szName ]
end

--屏蔽好友成功事件
ChatWindow.FriendBackCallBack  = function( szName )
	SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.FriendInfo, 5 ), 2, l_pTopParent )
end
--邀请入会
ChatWindow.OnMenuLeagueInvite = function( )
	G_PopMenu:Hide( )
	local pOkFunc = function()
		l_t.WriteLeagueLink ( G_LeagueMgr:GetConscribe( ), G_LeagueMgr:GetName( ), 1 ,  l_t.szCurSelPlayer )
	end
	GlobalComMsgDlg:ResetAll( )
	local szTips = "<Seg f=wrap tha=center>" ..
									"<Obj fs=19 cn=FF5F5041>"..
										SIdToMultiVal( l_tbMultiVal.League2, 1 ) ..
									"</Obj>" ..
							"</Seg>"
	GlobalComMsgDlg:SetButton1( SIdToStyle( UIConfigs.Ok3 ), nil, nil, pOkFunc )
	GlobalComMsgDlg:SetButton2( SIdToStyle( UIConfigs.Cancel3 ), nil, nil )
	GlobalComMsgDlg:SetPrompt( szTips )
	GlobalComMsgDlg:ShowDlg(  g_GameTop, true )
	
end
--结束会话
ChatWindow.OnMenuResume = function( args )
	G_PopMenu:Hide( )
	if l_tMsgFriendList[l_t.szCurSelPlayer] then   --删除当前私聊玩家玩家
		l_tMsgFriendList[l_t.szCurSelPlayer] = nil
	end
	l_t.FriendRmved( l_t.szCurSelPlayer )
end


--菜单切磋
ChatWindow.OnMenuFight = function( args )
	local nSelLev =l_t.nCurSelPlayerLv
	if nSelLev == 0 then
		return
	end
	local tbInfo = nil
	if l_t.szCurTencentName then
		tbInfo = G_TecentMgr:FindFriend( l_t.szCurSelPlayer )
	else
		tbInfo = G_FriendMgr:FindFriend(  l_t.szCurSelPlayer  )
	end
	G_PopMenu:Hide()
		--正在战斗中，不能跳转
	if G_FightShow.IsVisible( true ) then 
		local szText = SIdToMultiVal( l_tbMultiVal.ChatValue, 6 )
		SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )		
		return 	
	end
	local nFightLvLimit	= SGetCombatCfgCfg( ):GetComVar( Skilldef.bothfight_lvlimit )
	if Me:GetLevel( ) < nFightLvLimit then
		SysMessage.ShowRuntimeMsg( string.format( SIdToMultiVal( l_tbMultiVal.FightRequest, 0 ), nFightLvLimit ), 1.5, g_MainTop )
		return
	end
	if nSelLev < nFightLvLimit then
		SysMessage.ShowRuntimeMsg( string.format(SIdToMultiVal( l_tbMultiVal.FightRequest, 1), nFightLvLimit ), 1.5, g_MainTop )
		return 
	end
	GlobalComMsgDlg:ResetAll( )
	GlobalComMsgDlg:SetParam1( l_t.szCurSelPlayer )
	GlobalComMsgDlg:SetButton1( SIdToStyle( UIConfigs.Ok ), nil, nil, l_t.LetUsFight )
	GlobalComMsgDlg:SetButton2( SIdToStyle( UIConfigs.Cancel ) )
	GlobalComMsgDlg:SetPrompt(
				"<Seg tha=center f=wrap><Obj fs=19 cn=FF5F5041>"..
					SIdToMultiVal( l_tbMultiVal.FightRequest, 4 )..
				"</Obj></Seg>" 
							)
	GlobalComMsgDlg:ShowDlg( g_MainTop, true )
end

function ChatWindow.LetUsFight(  )
	local tbInfo = nil
	if l_t.szCurTencentName then
		tbInfo = G_TecentMgr:FindFriend( l_t.szCurSelPlayer )
	else
		tbInfo = G_FriendMgr:FindFriend( l_t.szCurSelPlayer )
	end
	local nSelLev	= tbInfo.nLevel 
	if nSelLev - Me:GetLevel( ) >= SGetCombatCfgCfg( ):GetComVar( Skilldef.bothfight_lv_notify ) then
			l_t.NoticeToFight( l_t.szCurSelPlayer )
	else
		if l_t.szCurTencentName then
			G_CombatMgr:ReqFight( l_t.szCurSelPlayer, true )
		else
			G_CombatMgr:ReqFight( l_t.szCurSelPlayer )
		end
	end
end

--切磋等级差异提醒
ChatWindow.NoticeToFight		= function ( szName, bRealPK )		
	GlobalComMsgDlg:ResetAll( )
	GlobalComMsgDlg:SetParam1( szName )
	if bRealPK then
		GlobalComMsgDlg:SetButton1( SIdToStyle( UIConfigs.Ok ), nil, nil, G_MyFriend.ReakPK )
	else
		GlobalComMsgDlg:SetButton1( SIdToStyle( UIConfigs.Ok ), nil, nil, G_MyFriend.Fighting )
	end
	GlobalComMsgDlg:SetButton2( SIdToStyle( UIConfigs.Cancel ) )
	GlobalComMsgDlg:SetPrompt(
				"<Seg tha=center f=wrap><Obj fs=19 cn=FF5F5041>"..
					SIdToMultiVal( l_tbMultiVal.FightRequest, 2 )..
				"</Obj></Seg>" 
							)
	GlobalComMsgDlg:ShowDlg( g_MainTop, true )
	
end

--即时切磋
ChatWindow.OnMenuRTFight = function(  )
	local tbInfo = G_FriendMgr:FindFriend( l_t.szCurSelPlayer )
	if not  G_FriendMgr:HasRealFriend( l_t.szCurSelPlayer ) then
		G_PopMenu:Hide( )
		return
	end
	local nSelLev = tbInfo.nLevel
	G_PopMenu:Hide( )
		--正在战斗中，不能跳转
	if G_FightShow.IsVisible( true ) then 
		local szText = SIdToMultiVal( l_tbMultiVal.ChatValue, 6 )
		SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )		
		return 	
	end
	--获取即时切磋所需等级
	local nFightLvLimit = SGetCombatCfgCfg( ):GetComVar( Skilldef.bothfight_lvlimit )
	if Me:GetLevel( ) < nFightLvLimit then
		 SysMessage.ShowRuntimeMsg( string.format( SIdToMultiVal( l_tbMultiVal.FightRequest, 0 ), nFightLvLimit ), 1.5, g_MainTop )
		 return 
	end
	if nSelLev < nFightLvLimit then
		SysMessage.ShowRuntimeMsg( string.format( SIdToMultiVal( l_tbMultiVal.FightRequest, 1 ), nFightLvLimit ), 1.5, g_MainTop )
		return
	end

	if nSelLev - Me:GetLevel( ) >= SGetCombatCfgCfg( ):GetComVar( Skilldef.bothfight_lv_notify ) then
			l_t.NoticeToFight( l_t.szCurSelPlayer, true )
	else
			G_CombatMgr:ReqPKOnTime( l_t.szCurSelPlayer )
	end

end

ChatWindow.SwitchParent = function( pParent )
---GC 内存回收 --------------------
	if not l_t.ChatWindow and not l_t.MainChatWnd  then
		return
	end
-----------------------------------
	local pParentWnd = l_t.ChatWindow:getParent( )
	if pParent and pParent ~= pParentWnd then
		pParentWnd:removeChildWindow( l_t.ChatWindow )
		pParentWnd:removeChildWindow( l_t.MainChatWnd )
		pParent:addChildWindow( l_t.ChatWindow )
		pParent:addChildWindow( l_t.MainChatWnd )
		l_t.ChatWindow:moveToFront( )
	end
end

--语音聊天系统
-----------------------按钮操作及响应--------------------
--设置输入框显示模式
function ChatWindow.SetInputModel( )
	if Me:GetNpc( ):GetVip( ) >= 0 then
		--切换到聊天模式
		l_t.SwitchToTalkModel( )
	else
		--切换到普通模式
		l_t.SwitchToCommonMoel( )
	end
end
--切换到普通模式
function ChatWindow.SwitchToCommonMoel( )
	l_t.VoiceSwitch:hide( )
	l_t.TouchTalk:hide( )
	l_t.InputBox:show( )
end
--切换到语聊文字模式
function ChatWindow.SwitchToTalkModel( )
	l_t.VoiceSwitch:show( )
	l_t.VoiceSwitch:setID( 0 )
	l_t.TouchTalk:hide( )
	l_t.InputBox:show( )
	local nInPutWidth = l_t.InPut:getAbsoluteWidth( ) - l_t.SendBtn:getAbsoluteWidth( ) 
				- l_t.EmotionBtn:getAbsoluteWidth( ) - l_t.VoiceSwitch:getAbsoluteWidth( )
	l_t.VoiceSwitch:setProperty( "ClientAreaBackgroundExt", "set:sat_common_ui_2 image:gvioce" )			--设置语音按钮图标
	l_t.VoiceSwitch:setProperty( "ClientAreaBackgroundExt2", "" )	
end

--切换到语聊语音模式
function ChatWindow.SwitchToVoiceModel( )
	l_t.VoiceSwitch:show( )
	l_t.VoiceSwitch:setID( 1 )
	l_t.VoiceSwitch:setProperty( "ClientAreaBackgroundExt", "" ) 
	l_t.VoiceSwitch:setProperty( "ClientAreaBackgroundExt2", "set:sat_common_ui_2 image:keyboard" )		 --设置文字按钮图标
	l_t.InputBox:hide( )
	l_t.TouchTalk:show( )
	l_t.TouchTalk:setAnsiText( SIdToMultiVal( l_tbMultiVal.Voice, 0 ) )
end
--模式切换按钮点击事件
function ChatWindow.OnSwitchModel( args )
	if ChatWindow.Busy then
		return
	end
	if l_t.VoiceSwitch:getID( ) == 1 then
		l_t.SwitchToTalkModel( )
	else
		l_t.SwitchToVoiceModel( )
	end
end
--TalkBar按下事件
function ChatWindow.OnTalkTouchDown( args )
	if ChatWindow.Busy then
		return
	end
	if Me:GetLevel( ) < G_PlayerSet:GetGlobalChatMinLevel( ) then 
		local szText = string.format( SIdToMultiVal( l_tbMultiVal.ChatValue,4 ), G_PlayerSet:GetGlobalChatMinLevel( ) )
		SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )	
		return
	end
	--聊天值不值提示
	if not G_ChatMgr:IsChatValEnough( ) and l_t.tbPageBtns[l_ChatDef.chat_room_id_global ]:isSelected( ) then 
		local szText = string.format( SIdToString( Chatdef.chat_not_enough_val ) , SPlayerComVar( Playerdef.player_chat_globalroom_cost ) - Me:GetTask( ):GetTaskVal( Taskdef.taskval_chat_val ) )
		SysMessage.ShowRuntimeMsg( szText, 2, g_GameTop )
		return 	
	end
	l_t.TouchFlag = false
	l_t.TouchTalk:setID( 0 )
	l_t.TouchTalk:setTimer( 0, 0.1 )
end
--Timer
function ChatWindow.OnTouchTimer( args )
	if SAT_PLATFORM == "ANDROID" then
		-- 程序版本过低无法使用语言功能
		if SApp.GetVersionCode( ) < 27878 then
			GlobalComMsgDlg:ResetAll( )
			GlobalComMsgDlg:SetButton1( SIdToStyle( UIConfigs.Ok ) )
			GlobalComMsgDlg:SetPrompt(
				"<Seg tha=center f=wrap><Obj fs=19 cn=FF5F5041>"..
					SIdToStyle( 236 ) ..
				"</Obj></Seg>" )
			GlobalComMsgDlg:ShowDlg( g_RootTop, true )
			return
		end
	end

	local timerArgs = CEGUI.toTimerEventArgs( args )
	if 0 == timerArgs.id then
		--关闭音效
		G_SystemSetup.MuteSet( true )
		l_t.TouchTalk:removeAllTimer( )
		return l_t.TouchTalk:setTimer( 1, 0.2 )
	end
	l_t.TouchTalk:removeAllTimer( )
	ChatWindow.Busy = true
	l_t.TouchFlag = true
	--开始录音
	l_t.VoiceNotice:show( )
	local nType = 0 
	if l_t.nCurPageIdx <= l_nChatRoomIdPrivate then
		nType = 1
	end
	l_AppController:StartRecord( nType )
	--TouchTalk按钮文本改变
	l_t.TouchTalk:setAnsiText( SIdToMultiVal( l_tbMultiVal.Voice, 1 ) )
	--显示界面窗口提示	
end
--TalkBar松开事件
function ChatWindow.OnTalkTouchUp( args )
	l_t.VoiceNotice:hide( )
	l_t.TouchTalk:removeAllTimer( )
	if Me:GetLevel( ) < G_PlayerSet:GetGlobalChatMinLevel( ) then 
		return
	end
	--聊天值不值提示
	if not G_ChatMgr:IsChatValEnough( ) and l_t.tbPageBtns[l_ChatDef.chat_room_id_global ]:isSelected( ) then 
		return 	
	end
	if not l_t.TouchFlag then
		--点击时间过短，返回
		SysMessage.ShowRuntimeMsg(  SIdToMultiVal( l_tbMultiVal.Voice, 6 ), 2, l_pTopParent )
		return
	end
	if l_t.TouchTalk:isDisabled( ) or l_t.TouchTalk:getID(  ) == 1 then
		l_t.TouchTalk:setAnsiText( SIdToMultiVal( l_tbMultiVal.Voice, 0 ) )
		l_t.TouchFlag = false
		return
	end
	l_t.TouchFlag = false
	ChatWindow.Busy = true
	--停止录音
	l_AppController:StopRecord( )
	l_t.TouchTalk:disable( )
	--TouchTalk按钮文本改变
	l_t.TouchTalk:setAnsiText( SIdToMultiVal( l_tbMultiVal.Voice, 0 ) )
	--关闭界面窗口提示
end

-----------------------消息处理--------------------
--写入语音消息并发送
function ChatWindow.WriteVocieInfo( nID, nInterval )
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.nVoiceLink, nID, nInterval )
	if l_t.nCurPageIdx > l_nChatRoomIdPrivate then
		G_ChatMgr:ReqChatInRoom( l_t.nCurPageIdx, G_Translator:GetLinkText( elemInfo ), nInterval )
	else
		l_t.PrivateChat( l_t.szCurSelPlayer, G_Translator:GetLinkText( elemInfo ), nInterval )
	end
end

function ChatWindow.GetSenderNameLabel( szName, nMsgWidth, nVipLv, uChannelID )
	local szSender = ""
	if Me:GetName( ) == szName then
		szSender = SIdToStyle( UIConfigs.MeTxt )
	else
		szSender = szName
	end
	local szVip = ""
	if nVipLv then
		szVip = ParseChatMsg.Vip( nVipLv )
	end
	
	local szChannelName = ""
	if uChannelID then
		szChannelName = ParseChatMsg.ChannelName( uChannelID )
	end
	local szLabel = "<Layout w=" .. nMsgWidth .. ">" ..
			"<Seg le=0 >" ..
				szChannelName ..
				"<Obj tva=center fs=19 f=wrap cn=FF44311D>" ..
					szSender .. ":" .. 
				"</Obj>" ..
			"</Seg>" .. 
			"</Layout>"
	return szLabel
end

function ChatWindow.GetSenderNameLabelWithChannel( szName, nMsgWidth, nChannelID, nVipLv )
	local szSender = ""
	if Me:GetName( ) == szName then
		szSender = SIdToStyle( UIConfigs.MeTxt )
	else
		szSender = szName
	end	
	local szLabel = "<Layout w=" .. nMsgWidth .. ">" ..
			"<Seg le=0 >" ..
				ParseChatMsg.ChannelChatName( nChannelID ) .. 
				ParseChatMsg.Vip( nVipLv ) ..
				"<Obj tva=center fs=19 f=wrap cn=FFFFFFFF>" ..
					szSender .. ":" .. 
				"</Obj>" ..
			"</Seg>" .. 
			"</Layout>"
	return szLabel
end

--接受聊天消息
function ChatWindow.ReceiveChatMessage( 
						szSender,
						nGMFlag,
						szMsg,
						uChannelID,
						nSenderProf,
						nSenderLevel,
						ulTime,
						nFigureId,
						nShowChn,
						nVipLv,
						nCombatVal, 
						nTitle
					 )
	 --  判断是否被临时屏蔽
	if l_tbTempBlack[ szSender ] then
		return
	end
	if szSender == Me:GetName( ) then
		if l_szShowCreature == szMsg then
			local nTimes = Me:GetTask( ):GetTaskVal( Taskdef.taskval_type_creature_show )
			Me:GetTask( ):ChgTaskVal( Taskdef.taskval_type_creature_show, nTimes - 1 )
			Me:GetTask( ):ReqChgTaskVal( Taskdef.taskval_type_creature_show, nTimes - 1 )
			SysMessage.ShowRuntimeMsg( string.format( SIdToString( 829 ), nTimes - 1 ),2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
			l_szShowCreature = nil
		elseif l_szShowPet == szMsg then 
			local nTimes = Me:GetTask( ):GetTaskVal( Taskdef.taskval_type_pet_show )
			Me:GetTask( ):ChgTaskVal( Taskdef.taskval_type_pet_show, nTimes - 1 )
			Me:GetTask( ):ReqChgTaskVal( Taskdef.taskval_type_pet_show, nTimes - 1 )
			SysMessage.ShowRuntimeMsg( string.format( SIdToString( 830 ), nTimes - 1 ),2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
			l_szShowPet = nil
		elseif l_szShareReport == szMsg then
			SysMessage.ShowRuntimeMsg( SIdToMultiVal( UIMultiValueConfigs.Arena, 9 ),2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
			l_szShareReport = nil		
		elseif l_szSendConscribe == szMsg then
			--SysMessage.ShowRuntimeMsg( SIdToMultiVal( UIMultiValueConfigs.Guild4, 4 ),2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
			l_szSendConscribe = nil
		end 
	end		
	if uChannelID == l_ChatDef.chat_room_id_teampvp then
		local tbInfo = 
				{
					szName			= szSender,
					nProf			= nSenderProf,
					nLvl			= nSenderLevel,
					nFigureId 		= nFigureId,
					bOnline			= bOnline,
					uOfflineTime	= uOfflineTime, 
					nCombat			= nCombatVal,
					nVip			= nVipLv,
					nTitle			= nTitle,
					nTime 	= ulTime,
					tbFigure = {						}
				}
		G_tConScriptChatList[szSender] = {				}
		G_tConScriptChatList[szSender] = tbInfo
	end
	if uChannelID == l_ChatDef.chat_room_mijing then
		local tbInfo = 
				{
					szName			= szSender,
					nProf			= nSenderProf,
					nLvl			= nSenderLevel,
					nFigureId 		= nFigureId,
					bOnline			= bOnline,
					uOfflineTime	= uOfflineTime, 
					nCombat			= nCombatVal,
					nVip			= nVipLv,
					nTitle			= nTitle,
					nTime 	= ulTime,
					tbFigure = {						}
				}
			G_tFamChatList[ szSender ] = {				}
			G_tFamChatList[ szSender ] = tbInfo
	end
	local nMsgWidth = ChatMsgCenter.nLabelWidth
	--拆分聊天消息
	local szMsgTable = ParseChatMsg.SplitMsg( szMsg, l_ChatDef.chat_room_id_sys == uChannelID )
	local msgInfo = nil
	local msgInfo2 = nil
	--分情情况处理
	local bVoice = false
	if szMsgTable[1].m_Flag then
		local elemInfo = l_UIHelper.GetElemInfo( szMsgTable[1].m_Msg )
		if l_tTranslator.GetElemType( elemInfo ) == l_tTransLinkType.nVoiceLink then 		--语聊消息
			--在主界面聊天部分显示
			local szMainVoice =  "<Obj t=pic pw=" .. math.floor( l_t.nSingleHeight * 0.8 ) .. "  ph=" .. math.floor( l_t.nSingleHeight * 0.8 ) .. " tva=center >set:sat_common_ui_2 image:gvioce</Obj>"
			local szMainVoiceMsg = ParseChatMsg.GetLayoutChatMsg( l_t.nMainTxtWidth, szSender, "", szMainVoice, uChannelID, nSenderProf, 1 )
			l_t.MainChatTxtShow( szMainVoiceMsg, nil, nil, ulTime )
			--在聊天界面显示
			local nVoiceId = l_translator:GetAnsiContext( elemInfo )	--语音Id
			local nInterval = elemInfo:GetGameObjIdByIdx( 1 )

			--检测当前收到的消息是否是自己发送的消息
			if szSender == Me:GetName( ) then
				return
			end
			local szLabelMsg = l_t.GetSenderNameLabel( szSender, nMsgWidth, nVipLv, uChannelID )
			msgInfo = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, "", uChannelID, nSenderProf, ulTime, nFigureId, nShowChn, nVoiceId, nInterval, "", nSenderLevel )
			bVoice = true
		elseif l_tTranslator.GetElemType( elemInfo ) == l_tTransLinkType.GuildFamType then --帮会秘境
			--将帮会秘境信息存入缓存table中
			local nFamRoomID = elemInfo:GetGameObjIdByIdx( 1 )
			local nCreateTime = elemInfo:GetGameObjIdByIdx( 2 )
			--提示吼出去后回调关闭界面
			if G_fam_invite:IsVisible( true ) and szSender == Me:GetName( ) then 
				SysMessage.ShowRuntimeMsg(  SIdToMultiVal( l_tbMultiVal.GuildFamPlay, 7 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
				G_fam_invite:Hide( )
			end
			if table.getn(G_tFamChatList) == 0 then 
				local tFamChatInfo = {	}
				tFamChatInfo.nFamRoomID = nFamRoomID
				tFamChatInfo.nCreateTime = nCreateTime
				tFamChatInfo.szMsg = szMsg
				tFamChatInfo.elemInfo = elemInfo
				tFamChatInfo.uChannelID = uChannelID
				tFamChatInfo.szMsgTable = szMsgTable
				tFamChatInfo.nSenderProf = nSenderProf 
				tFamChatInfo.szSender = szSender 
				
				table.insert( G_tFamChatList , tFamChatInfo )
			else 
				local nMinNum =  table.getn(G_tFamChatList) - 10
				if nMinNum < 1 then 
					nMinNum = 1
				end
				local nNeedAdd = 0
				--遍历最新10条
				local tFamChatInfo = {	}
				for index = table.getn(G_tFamChatList) , nMinNum , -1 do 
					--如果一下信息都相同，那就不用insert了
					if G_tFamChatList[index] and G_tFamChatList[index].nFamRoomID == nFamRoomID and G_tFamChatList[index].szMsg == szMsg then 
						
						--如果频道是空的(私聊) 或者和新的不想的 就准备换
						if not G_tFamChatList[index].uChannelID or G_tFamChatList[index].uChannelID ~= uChannelID then 
							--如果已经是世界频道了 就不换了
							if G_tFamChatList[index].uChannelID ~= l_ChatDef.chat_room_id_global then  
								G_tFamChatList[index].uChannelID = uChannelID	
							end
						end			
							nNeedAdd = 1
						break			
					end
				end 
				if nNeedAdd == 0 then 
					tFamChatInfo.nFamRoomID = nFamRoomID
					tFamChatInfo.nCreateTime = nCreateTime
					tFamChatInfo.szMsg = szMsg
					tFamChatInfo.elemInfo = elemInfo
					tFamChatInfo.uChannelID = uChannelID
					tFamChatInfo.szMsgTable = szMsgTable
					tFamChatInfo.nSenderProf = nSenderProf 
					tFamChatInfo.szSender = szSender 
					table.insert( G_tFamChatList , tFamChatInfo )
				end
			end
			--如果聊天界面是显示的则刷新列表界面
			if G_fam_chatlist:IsVisible(  ) then 
				G_fam_chatlist:SetAllInfo( )
			end
		end
	end
	
	if not bVoice then										--普通消息
		--解析聊天消息
		local szMessage = ParseChatMsg.ParseMsg( szMsgTable )
		msgInfo, msgInfo2 = ChatWindow.ParseNormalMsg( szMessage, uChannelID, ulTime, nShowChn, nFigureId, szSender, nTitle, nSenderProf, nVipLv, szMsg, nSenderLevel , szMsgTable)
	end
		
	ChatWindow.AddShowMsg( msgInfo, msgInfo2, uChannelID, nShowChn )
	ChatWindow.CheckSender( szSender, nSenderProf, nSenderLevel, nFigureId, nCombatVal, nVipLv, nTitle, uChannelID, nShowChn, ulTime )
end

--处理普通聊天消息
ChatWindow.ParseNormalMsg = function( szMessage, uChannelID, ulTime, nShowChn, nFigureId, szSender, nTitle, nSenderProf, nVipLv, szMsg , nSenderLevel , szMsgTable)
	local nMsgWidth = ChatMsgCenter.nLabelWidth
	local msgInfo = {}
	local msgInfo2 = {}
	local szLabelMsg = ""
	local szMainMsg = ParseChatMsg.GetLayoutChatMsg( l_t.nMainTxtWidth, szSender, "", szMessage, uChannelID, nTitle,  1 )
	l_t.MainChatTxtShow( szMainMsg, uChannelID == l_ChatDef.chat_room_id_sys, uChannelID == l_ChatDef.chat_room_id_speaker, ulTime )
	G_UIConScript.MainChatTxtShow( szMainMsg, uChannelID == l_ChatDef.chat_room_id_sys, uChannelID == l_ChatDef.chat_room_id_speaker,uChannelID == l_ChatDef.chat_room_id_global )
	G_League_Reception.MainChatTxtShow(szMsg, uChannelID == l_ChatDef.chat_room_id_social , false , szSender , szMsgTable)
	G_Mumbo:MainChatTxtShow(szMsg, uChannelID == l_ChatDef.chat_room_mumbo, szSender )
	--获取消息排版、保存到消息管理中心
	if uChannelID == l_ChatDef.chat_room_id_global then
		szLabelMsg = ParseChatMsg.GetLayoutChatMsg( nMsgWidth, szSender, "", szMessage,	uChannelID, nTitle, 4, nVipLv )
		msgInfo = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, "", l_ChatDef.chat_room_id_global, nSenderProf, ulTime, nFigureId, nShowChn, nil, nil, szMsg, nSenderLevel)
	elseif uChannelID == l_ChatDef.chat_room_id_social then
			
		szLabelMsg = ParseChatMsg.GetLayoutChatMsg( nMsgWidth, szSender, "", szMessage,	uChannelID, nTitle, 2, nVipLv )
		msgInfo2 = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, "", uChannelID, nSenderProf, ulTime, nFigureId, nShowChn, nil, nil, szMsg, nSenderLevel)
	elseif uChannelID == l_ChatDef.chat_room_id_speaker then
		szLabelMsg = ParseChatMsg.GetLayoutChatMsg( nMsgWidth, szSender, "", szMessage,	uChannelID, nTitle, 4, nVipLv )
		msgInfo = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, "", l_ChatDef.chat_room_id_speaker, nSenderProf, ulTime, nFigureId, nShowChn, nil, nil, szMsg , nSenderLevel)
	elseif uChannelID == l_ChatDef.chat_room_id_teampvp then
		if Me:GetName( ) ~= szSender then
			szLabelMsg = ParseChatMsg.GetLayoutChatMsg( nMsgWidth, szSender, "", szMessage,	uChannelID, nTitle,	4, nVipLv )
			msgInfo = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, "", l_ChatDef.chat_room_id_global, nSenderProf, ulTime, nFigureId, nShowChn, nil, nil, szMsg, nSenderLevel )
		end
		szLabelMsg = ParseChatMsg.GetLayoutChatMsg( nMsgWidth, szSender, "", szMessage,	uChannelID, nTitle, 2, nVipLv )
		msgInfo2 = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, "", uChannelID, nSenderProf, ulTime, nFigureId, nShowChn, nil, nil, szMsg, nSenderLevel)
	else
		szLabelMsg = ParseChatMsg.GetLayoutChatMsg( nMsgWidth, szSender, "", szMessage,	uChannelID, nTitle, 2, nVipLv )
		msgInfo = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, "", uChannelID, nSenderProf, ulTime, nFigureId, nShowChn, nil, nil, szMsg, nSenderLevel )
	end
	return msgInfo, msgInfo2
end

--添加消息显示
ChatWindow.AddShowMsg = function( msgInfo, msgInfo2, uChannelID, nShowChn )
	if l_t.nCurPageIdx == l_ChatDef.chat_room_id_social then
		if uChannelID == l_ChatDef.chat_room_id_social or
			l_ChatDef.chat_room_id_social == nShowChn then
			l_t.AddMessage( msgInfo2, true )
		end
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_id_global then
		if l_ChatDef.chat_room_id_social == nShowChn or
			l_ChatDef.chat_room_id_global == nShowChn or
			l_ChatDef.chat_room_id_teampvp == nShowChn or
			uChannelID == l_ChatDef.chat_room_id_teampvp or
			uChannelID == l_ChatDef.chat_room_id_social or
			uChannelID == l_ChatDef.chat_room_id_speaker or 
			uChannelID == l_ChatDef.chat_room_id_global then
			l_t.AddMessage( msgInfo, true )
		end
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_id_teampvp then
		if uChannelID == l_ChatDef.chat_room_id_teampvp or
			l_ChatDef.chat_room_id_teampvp == nShowChn then
			l_t.AddMessage( msgInfo2, true )
		end
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_mijing then
		if uChannelID == l_ChatDef.chat_room_mijing or
			l_ChatDef.chat_room_mijing == nShowChn then
			l_t.AddMessage( msgInfo, true )
		end
	elseif l_t.nCurPageIdx == l_ChatDef.chat_room_mumbo then
		if uChannelID == l_ChatDef.chat_room_mumbo then
			l_t.AddMessage( msgInfo, true )
		end
	end
end

ChatWindow.CheckSender = function( szSender, nSenderProf, nSenderLevel, nFigureId, nCombatVal, nVipLv, nTitle, uChannelID, nShowChn, nSendTime )
	if szSender and Me:GetName( ) ~= szSender then
		l_t.SavePlayerInfo( szSender, nSenderProf, nSenderLevel, nFigureId, 1, 0, l_t.nSpeakTime, nCombatVal , nVipLv, nTitle )
		l_t.nSpeakTime = l_t.nSpeakTime + 1
		if not nSendTime then 
			nSendTime = 0		
		end
		if ( not ChatWindow.ChatWindow:isVisible( ) or l_t.nCurPageIdx ~= l_ChatDef.chat_room_id_social ) and
			( l_ChatDef.chat_room_id_social == uChannelID or l_ChatDef.chat_room_id_social == nShowChn ) and
			Me:GetTask( ):GetTaskVal( Taskdef.league_chatroom_lastclose ) < nSendTime and 
			Me:GetTask( ):GetTaskVal( Taskdef.chat_global_lastclose ) < nSendTime  then
			l_t.nUnreadLeague = l_t.nUnreadLeague + 1	
			l_t.nUnreadMsgs = l_t.nUnreadMsgs + 1
			l_t.RefreshLeagueNum( )
			l_t.RefreshPMNum( )
		elseif ( not ChatWindow.ChatWindow:isVisible( ) or 
			l_t.nCurPageIdx ~= l_ChatDef.chat_room_id_global ) and
			( l_ChatDef.chat_room_id_global == uChannelID or l_ChatDef.chat_room_id_global == nShowChn ) and
			Me:GetTask( ):GetTaskVal( Taskdef.chat_global_lastclose ) < nSendTime then
			l_t.nUnreadMsgs = l_t.nUnreadMsgs + 1
			l_t.RefreshPMNum( )
			
		elseif( not ChatWindow.ChatWindow:isVisible(  ) or
			( l_t.nCurPageIdx ~= l_ChatDef.chat_room_id_teampvp and
			l_t.nCurPageIdx ~= l_ChatDef.chat_room_id_global )	) and
			( l_ChatDef.chat_room_id_teampvp == uChannelID or l_ChatDef.chat_room_id_teampvp == nShowChn ) then
			l_t.nUnreadTeam = l_t.nUnreadTeam + 1
			l_t.nUnreadMsgs = l_t.nUnreadMsgs + 1
			l_t.RefreshPMNum( )
		elseif( not ChatWindow.ChatWindow:isVisible( ) or
			l_t.nCurPageIdx ~= l_ChatDef.chat_room_mijing ) and
			( l_ChatDef.chat_room_mijing == uChannelID or l_ChatDef.chat_room_mijing == nShowChn ) then
			l_t.nUnreadMsgs = l_t.nUnreadMsgs + 1
			l_t.RefreshPMNum( )			
		end
		if l_t.nCurPageIdx == l_ChatDef.chat_room_id_teampvp then
			ChatWindow.RefreshPlayer( l_t.nCurPageIdx)
		end 
		if l_t.nCurPageIdx == l_ChatDef.chat_room_mijing then
			ChatWindow.RefreshPlayer( l_t.nCurPageIdx )
		end
		if l_t.nCurPageIdx == l_ChatDef.chat_room_mumbo then
			ChatWindow.RefreshPlayer( l_t.nCurPageIdx )
		end
	end
end

--接收私聊消息
ChatWindow.ReceivePrivateMsg = function( szSender, szReceiver, nGMFlag, szMsg, nProf, bOflMsg, ulTime, nVipLv , nTitle, nFigureId, szTencentName )
	--  判断是否被临时屏蔽
	if l_tbTempBlack[ szSender ] then
		return
	end

	G_League_Reception.MainChatTxtShow(szMsg, false, true , szSender)	
		
	local nMsgWidth = ChatMsgCenter.nLabelWidth
	local szMsgTable = ParseChatMsg.SplitMsg( szMsg )

	--分情况处理
	local elemInfo = l_UIHelper.GetElemInfo( szMsgTable[1].m_Msg )
	local szLabelMsg = ""
	local msgInfo = {}
	local msgInfo2 = {}

	if l_tTranslator.GetElemType( elemInfo ) == l_tTransLinkType.nVoiceLink then 		--语音消息
		--在主界面显示
		local szMainVoice = "<Obj t=pic pw=" .. math.floor( l_t.nSingleHeight * 0.8 )  .. "  ph=" .. math.floor( l_t.nSingleHeight * 0.8 ) .. " tva=center >set:n_sat_common_ui image:voiceicon</Obj>"
		local szMainVoiceMsg = ParseChatMsg.GetLayoutChatMsg( l_t.nMainTxtWidth, szSender, szReceiver, szMainVoice, 0, nProf, 1 )
		l_t.MainChatTxtShow( szMainVoiceMsg, nil, nil, ulTime )
		--在聊天界面显示
		local nVoiceId = l_translator:GetAnsiContext( elemInfo )
		local nInterval = elemInfo:GetGameObjIdByIdx( 1 )
		--检测当前消息是否是自己发送
		if ChatWindow.CheckSelfSend( szSender, szTencentName ) then
			return
		end
		szLabelMsg = l_t.GetSenderNameLabel( szSender, nMsgWidth, nVipLv, 0 )
		msgInfo = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, szSender, szReceiver, 0, nProf, ulTime, nFigureId, 0, nVoiceId, nInterval )
	elseif l_tTranslator.GetElemType( elemInfo ) == l_tTransLinkType.ConScription then --军征场
			if G_fam_invite:IsVisible( true ) and szSender == Me:GetName( ) then 
				SysMessage.ShowRuntimeMsg(  SIdToMultiVal( l_tbMultiVal.GuildFamPlay, 7 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
				G_fam_invite:Hide( )
			end
	elseif l_tTranslator.GetElemType( elemInfo ) == l_tTransLinkType.GuildFamType then --帮会秘境
		--提示吼出去后回调关闭界面
		if G_fam_invite:IsVisible( true ) and szSender == Me:GetName( ) then 
			SysMessage.ShowRuntimeMsg(  SIdToMultiVal( l_tbMultiVal.GuildFamPlay, 7 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
			G_fam_invite:Hide( )
		end
		--将帮会秘境信息存入缓存table中
			local nFamRoomID = elemInfo:GetGameObjIdByIdx( 1 )
			local nCreateTime = elemInfo:GetGameObjIdByIdx( 2 )	
			if table.getn(G_tFamChatList) == 0 then 
				local tFamChatInfo = {	}
				tFamChatInfo.nFamRoomID = nFamRoomID
				tFamChatInfo.nCreateTime = nCreateTime
				tFamChatInfo.szMsg = szMsg
				tFamChatInfo.elemInfo = elemInfo
				tFamChatInfo.uChannelID = uChannelID
				tFamChatInfo.szMsgTable = szMsgTable
				tFamChatInfo.nSenderProf = nProf 
				tFamChatInfo.szSender = szSender 
				
				table.insert( G_tFamChatList , tFamChatInfo )
			else 
				local nMinNum =  table.getn(G_tFamChatList) - 10
				if nMinNum < 1 then 
					nMinNum = 1
				end
				local nNeedAdd = 0
				--遍历最新10条
				local tFamChatInfo = {	}
				for index = table.getn(G_tFamChatList) , nMinNum , -1 do 
					--如果一下信息都相同，那就不用insert了
					if G_tFamChatList[index] and G_tFamChatList[index].nFamRoomID == nFamRoomID and G_tFamChatList[index].szMsg == szMsg then 		
						nNeedAdd = 1
						break			
					end
				end 
				if nNeedAdd == 0 then 
					tFamChatInfo.nFamRoomID = nFamRoomID
					tFamChatInfo.nCreateTime = nCreateTime
					tFamChatInfo.szMsg = szMsg
					tFamChatInfo.elemInfo = elemInfo
					tFamChatInfo.uChannelID = uChannelID
					tFamChatInfo.szMsgTable = szMsgTable
					tFamChatInfo.nSenderProf = nProf 
					tFamChatInfo.szSender = szSender 
					table.insert( G_tFamChatList , tFamChatInfo )
				end
			end
			--如果聊天界面是显示的则刷新列表界面
			if G_fam_chatlist:IsVisible(  ) then 
				G_fam_chatlist:SetAllInfo( )
			end
			local szMessage  = ParseChatMsg.ParseMsg( szMsgTable )
			local szMainMsg = ParseChatMsg.GetLayoutChatMsg( 
										l_t.nMainTxtWidth,
										szSender, 
										szReceiver,
										szMessage, 
										0, 
										nTitle,
										1 )

		l_t.MainChatTxtShow( szMainMsg, false, nil, ulTime )
		
		local szLabelMsg2 = ParseChatMsg.GetLayoutChatMsg( ChatMsgCenter.nLabelWidth, szSender, "", szMessage, 0, nTitle, 2,	nVipLv )
		msgInfo2 = ChatMsgCenter.SaveToMsgCenter( szLabelMsg2, szSender, szReceiver, 0, nProf, ulTime, nFigureId )
	else
		local szMessage  = ParseChatMsg.ParseMsg( szMsgTable )
		local szMainMsg = ParseChatMsg.GetLayoutChatMsg( 
										l_t.nMainTxtWidth,
										szSender, 
										szReceiver,
										szMessage, 
										0, 
										nTitle,
										1 )

		l_t.MainChatTxtShow( szMainMsg, false, nil, ulTime )

		--获取消息排版、保存到消息管理中心		
		
		local szLabelMsg2 = ParseChatMsg.GetLayoutChatMsg( ChatMsgCenter.nLabelWidth, szSender, "", szMessage, 0, nTitle, 2,	nVipLv, szTencentName )
		msgInfo2 = ChatMsgCenter.SaveToMsgCenter( szLabelMsg2, szSender, szReceiver, 0, nProf, ulTime, nFigureId, nil, nil, nil, nil, nil, szTencentName )
	end

	if ChatWindow.CheckSelfSend( szSender, szTencentName ) then
		l_tMsgFriendList[szReceiver] = {	}
		if szTencentName then
			l_tMsgFriendList[szReceiver].Name = szTencentName
			l_tMsgFriendList[szReceiver].OpenId = szReceiver
		else
			l_tMsgFriendList[szReceiver].Name = szReceiver
		end
		l_tMsgFriendList[szReceiver].Time = SSvrUnixTimeStamp( )
	else
		l_tMsgFriendList[szSender] = {	}
		if szTencentName then
			l_tMsgFriendList[szSender].Name = szTencentName
			l_tMsgFriendList[szSender].OpenId = szSender
		else
			l_tMsgFriendList[szSender].Name = szSender
		end
		l_tMsgFriendList[szSender].Time = SSvrUnixTimeStamp( )
	end
	
	if l_t.ChatWindow:isVisible( ) then
		if l_t.FriendBtn:isSelected( ) then
			if l_t.szCurSelPlayer == szSender or ChatWindow.CheckSelfSend( szSender, szTencentName ) then
				l_t.AddMessage( msgInfo2, true )
			end
		elseif l_t.nCurPageIdx == l_ChatDef.chat_room_id_global then
			if not ChatWindow.CheckSelfSend( szSender, szTencentName ) then
				l_t.AddMessage( msgInfo, true )
			end
		end
	end	
	if not ChatWindow.CheckSelfSend( szSender, szTencentName ) then
		if ChatWindow.UpdateFriendMsg( szSender, l_t.szCurSelPlayer ~= szSender, szTencentName ) then
			if l_t.ChatWindow:isVisible( ) and l_t.FriendBtn:isSelected( ) then
				l_t.RefreshPlayer( l_nChatRoomIdPrivate )
			end
		end
	end
	G_NpcSet:PlayerChatInLeagueMap( szSender )
end

--判断发送人是否自己
function ChatWindow.CheckSelfSend( szSender, szTencentName )
	if szTencentName then
		if g_szAccount == szSender then
			return true
		else
			return false
		end
	else
		if szSender == Me:GetName( ) then
			return true
		else
			return false
		end
	end
end

--保存自己的和已播放的语音消息
function ChatWindow.CacheVoiceMsgByID( nVoiceId, nChannelID )
	if not l_t.tbCacheVoiceMsg then
		l_t.tbCacheVoiceMsg = {	}
	end
	l_t.tbCacheVoiceMsg.nVoiceId= nChannelID
end

--清空客户端缓存语音消息
function ChatWindow.ClearVoiceBuffer(  )
	for key, val in pairs( l_t.tbCacheVoiceMsg ) do
		if val <= 0 then
			l_AppController:ClearRecord( 1, key )
		else
			l_AppController:ClearRecord( 0, key )
		end
	end
end
function ChatWindow.ClearAllVoice ( )
	local szVoiceID = "all"
	l_AppController:ClearRecord( 1, szVoiceID )
end

--预发送消息，仅自己可见
function ChatWindow.PreSendVoiceMsg( nVoiceId, nInterval )
	local nChannelID =  l_t.nCurPageIdx
	local szLabelMsg = ""
	if l_t.FriendBtn:isSelected( ) then
		nChannelID = 0
	end
	szLabelMsg = l_t.GetSenderNameLabel( Me:GetName( ), ChatMsgCenter.nLabelWidth, nil, nChannelID )
	local msgInfo = ChatMsgCenter.SaveToMsgCenter( szLabelMsg, Me:GetName( ), l_t.szCurSelPlayer, nChannelID, Me:GetProf( ), SUnixTimeStamp( ), nil, nChannelID, nVoiceId, nInterval )
	l_t.AddMessage( msgInfo, true )
end

--检测当前收到的消息是否是自己发送的消息
function ChatWindow.ChkVoiceMsgIsSelf( nVoiceId )
	local msgInfo = nil
	if l_t.FriendBtn:isSelected( ) then
		msgInfo = ChatMsgCenter.SearchVoiceByIDAndPlayer( nVoiceId, l_t.szCurSelPlayer )
	else
		msgInfo = ChatMsgCenter.SearchVoiceByID( nVoiceId )
		if not msgInfo then
			msgInfo = ChatMsgCenter.SearchVoiceByIDAndPlayer( nVoiceId, l_t.szCurSelPlayer )
		end
	end
	if msgInfo then
		if msgInfo.tbLabel.pWait then
			msgInfo.tbLabel.pWait:stopUIEffect( )
			msgInfo.tbLabel.pWait:hide( )
		end
		local nTime = msgInfo.nInterval
		if msgInfo.nInterval == 0 then
			nTime = 1
		end	
		msgInfo.tbLabel.pMsgWnd:setAnsiText( nTime .. "''" )
		msgInfo.bSended = true
		return true
	else
		return false
	end
end

--记录当前消息发送的频道
function ChatWindow.SaveChnIdWhenSenderMsg( )
	if l_t.FriendBtn:isSelected( ) then
		l_t.SenderChannelID = 0
		return
	end
	l_t.SenderChannelID = l_t.nCurPageIdx
end

--获取当前频道
function ChatWindow.GetCurChannel( )
	local nType = 0 
	if l_t.nCurPageIdx <= l_nChatRoomIdPrivate then
		nType = 1
	end
	return nType
end
-----------------------通知响应--------------------
--录音结束
function ChatWindow.OnRecFinished( szRecName, nResult, nInterval )
	l_t.VoiceNotice:hide( )
	l_t.TouchTalk:setID( 1 )
	if nResult == 0 then					--上传失败
		ChatWindow.Busy = nil
		--修改发送中标识
		l_t.ChkVoiceMsgIsSelf( szRecName )
		l_t.TouchTalk:enable( )
		SysMessage.ShowRuntimeMsg( SIdToStyle( UIConfigs.VoiceMsg ) , 3, l_pTopParent )
	elseif nResult == 1 then				--成功
		l_t.TouchTalk:enable( )
		ChatWindow.Busy = nil
		local nTimeRec = l_t.nCurInterval
		if not nTimeRec then
			nTimeRec = 1
		end
		l_t.WriteVocieInfo( szRecName, nTimeRec )
		--修改发送中标识
		l_t.ChkVoiceMsgIsSelf( szRecName )
	elseif nResult == 2 then			--录音完成
		if G_SystemSetup.IsBgMusicEnable( ) then
			G_SystemSetup.MuteSet( false )
		end
		l_t.TouchTalk:disable( )
		ChatWindow.Busy = true		
		--保存当前录音ID
		l_t.CacheVoiceMsgByID( szRecName, l_t.nCurPageIdx )
		--记录当前频道
		l_t.SaveChnIdWhenSenderMsg( )
		--预发送消息
		l_t.PreSendVoiceMsg( szRecName, nInterval )
		l_t.nCurInterval = nInterval
	elseif nResult == 3 then			--录音失败
		if G_SystemSetup.IsBgMusicEnable( ) then
			G_SystemSetup.MuteSet( false )
		end
		ChatWindow.Busy = nil
		l_t.TouchTalk:enable( )
		SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.Voice, 2 ), 2, l_pTopParent )
	end
end
--播放结束
function ChatWindow.OnPlayFinished( szRecName )
	if ChatWindow.Busy then
		ChatWindow.Busy = nil
	end
	if G_SystemSetup.IsBgMusicEnable( ) then
		G_SystemSetup.MuteSet( false )
	end
	if ChatMsgCenter.pPlayingWnd then
		ChatMsgCenter.pPlayingWnd:setProperty( "FrontImage", "set:sat_common_ui_2 image:gvioce" )
		ChatMsgCenter.pPlayingWnd = nil
	end

end

function ChatWindow.StopPlayVoice( )
	if l_bPlayVoice > 0 then
		l_AppController:StopPlay( )
	end	
	l_bPlayVoice = 0
end

function ChatWindow.BeginPlayVoice(  )
	l_bPlayVoice = l_bPlayVoice + 1
end

function ChatWindow.PlayVoiceEnd( )
	l_bPlayVoice = l_bPlayVoice - 1
end
--------------------------------------------------
--                 链接相关处理
--------------------------------------------------

--无type处理
l_tbLableProc[ l_tTransLinkType.nErrorLink ] = function( pPickedElem, pos )
	if not l_t.IsVisible( ) then
		l_t:Show( )
	end

	return true
end

--装备链接
l_tbLableProc[ l_tTransLinkType.nItemLink ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	ChatWindow.tbLinkPos = { x = pos.x, y = pos.y }
	Me:GetItemViewer( ):ReqViewItem( pPickedElem:GetGameObjIdByIdx( 4 ), pPickedElem:GetGameObjIdByIdx( 5 ) )
	return true
end

--战宠链接
l_tbLableProc[ l_tTransLinkType.nCreatureLink ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local uCreatureID = pPickedElem:GetGameObjIdByIdx( 1 )
	local uPlayerID = pPickedElem:GetGameObjIdByIdx( 2 )
	G_CreatureMgr:ReqViewCreature( uPlayerID, uCreatureID )
	return true
end

--神兽链接
l_tbLableProc[ l_tTransLinkType.PetLink ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local uPetTempID = pPickedElem:GetGameObjIdByIdx( 1 )
	local uPlayerID = pPickedElem:GetGameObjIdByIdx( 2 )
	G_PetMgr:ReqViewPetById( uPlayerID, uPetTempID  )
	return true
end

--公会链接
l_tbLableProc[ l_tTransLinkType.LeagueLink] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local nType = pPickedElem:GetGameObjIdByIdx( 1 )
	local szLeagueName = l_translator:GetAnsiContext( pPickedElem )
	G_league_hire.OnClickOpen(szLeagueName , nType )
	return true
end

--运镖链接
l_tbLableProc[ l_tTransLinkType.Dart ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	--判断当前的状态 是 运镖状态 等待领取奖励,组队押镖次数是否还存在
	if G_ChargeDartMgr:GetCurDartType( )==ChargeDartdef.DartState_Running then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ChargeDartStr7, 2 ), 2,WindowMgr.GetCurWindowOrder( ) )
	elseif G_ChargeDartMgr:GetCurDartType( )==ChargeDartdef.DartState_Award then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ChargeDartStr7, 3 ), 2,WindowMgr.GetCurWindowOrder( ) )
	elseif 	G_ChargeDartMgr:GetCurHelpDartCnt() >=G_ChargeDartMgr:GetHelpDartLimitCnt( ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ChargeDartStr7, 0 ), 2,WindowMgr.GetCurWindowOrder( ) )	
	end
	local szLeaderName = l_translator:GetAnsiContext( pPickedElem )
	G_ChargeDartMgr:ReqJoinDart( szLeaderName )
	return true
end

--劫镖失败链接
l_tbLableProc[ l_tTransLinkType.DartFightLose ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	
	if G_ChargeDartMgr:GetSelfRobDartCnt( )<=0 then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ChargeDartStr7, 8 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local szLeaderName = l_translator:GetAnsiContext( pPickedElem )
	local nDartID = pPickedElem:GetGameObjIdByIdx( 1 )
	G_ChargeDartMgr:ReqRobDart( nDartID )
	return true
end

--邀请加入帮会群链接
l_tbLableProc[ l_tTransLinkType.LeagueGroupInviteLink ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local szSenderName = l_translator:GetAnsiContext( pPickedElem )
	if Me:GetName( ) == szSenderName then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.LeagueGroup , 7 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
	end
	if G_TecentMgr:CheckAlreadyInGroup( ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.LeagueGroup , 8 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
	end
	local szQQVersion, szWXVersion = G_TecentMgr:GetVersion( )
	local nCurLoginType = G_TecentMgr:GetCurLoginType( )
	if nCurLoginType == 0 then
		return
	end
	if ( nCurLoginType == Tecentdef.LoginType_QQ and szQQVersion ~= "" ) or ( nCurLoginType == Tecentdef.LoginType_WX and szWXVersion ~= "" ) then
		local szLeagueGuild = tostring( SHashKey( G_LeagueMgr:GetName( ) ) )
		G_TecentMgr:ReqIntoLeagueGroup( szLeagueGuild, Me:GetName( ) )
		return true
	else
		SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.TencentTips, nCurLoginType ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
	end
end

--帮会秘境链接
l_tbLableProc[ l_tTransLinkType.GuildFam] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local nFamRoomID = pPickedElem:GetGameObjIdByIdx( 1 )
	local nCreateTime = pPickedElem:GetGameObjIdByIdx( 2 )
	local tTeam = G_PrilandMgr:GetSelfTeamInfo( )
	if Me:GetLevel( ) < G_SystemNoticeMgr:GetAppOpenLv( Taskdef.system_id_priland ) then 
		SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.GuildFamTwo, 1 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
		return true
	end
	if tTeam and table.getn( tTeam ) > 0 then
		if nCreateTime ==tTeam[ l_enTeamType.CreateTime ] then
			G_guild_fam:OpenFam( ) 
		else
			SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.GuildFamErrorStr, 0 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
		end	 
	else
		--发送进入房间的请求
		G_PrilandMgr:ReqAddTeam( nFamRoomID, nCreateTime )
	end
	return true
end

--军征场链接
l_tbLableProc[ l_tTransLinkType.ConScription] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local nFamRoomID = pPickedElem:GetGameObjIdByIdx( 1 )
	local nCreateTime = pPickedElem:GetGameObjIdByIdx( 2 )
--	local tTeam = G_PrilandMgr:GetSelfTeamInfo( )
	if Me:GetLevel( ) < G_PvPActMgr:GetFightLvLimit( ) then ---限制条件及提示
		SysMessage.ShowRuntimeMsg( string.format(tbDelta[3],G_PvPActMgr:GetFightLvLimit( )), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
		return true
	end
	if G_PvPActMgr:IsInTeam( ) ~= 1 then
		G_UIConScript:SetReShow( )
		G_PvPActMgr:ReqJoinTeam( nFamRoomID )
	elseif G_PvPActMgr:GetTeamID( ) == nFamRoomID then
		if G_PvPActMgr:IsInRoom( ) == 1 then
			SysMessage.ShowRuntimeMsg( SIdToMultiVal( UIMultiValueConfigs.ConScript2, 6 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
		else
			G_UIConScript:SetTipsComeIn( )
			G_PvPActMgr:ReqEnterRoom( )
		end
	else
		if G_PvPActMgr:GetSelfMembState( ) == PvPDef.teamstate_normal then
			SysMessage.ShowRuntimeMsg( SIdToMultiVal( UIMultiValueConfigs.ConScript2, 6 ), 2, WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
		else
			SysMessage.ShowRuntimeMsg( tbDelta[2], 2,  WindowMgr.GetCurWindowOrder( G_WindowPart.Top ) )
		end
	end
--		G_PrilandMgr:ReqAddTeam( nFamRoomID, nCreateTime )
--	end
	return true
end

--好友Boss链接
l_tbLableProc[ l_tTransLinkType.nFriendBoss ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	local uBossID = pPickedElem:GetGameObjIdByIdx( 1 )
	local tbInfo = G_FriendBossMgr:GetSingleBossInfo( uBossID, true )
	if not tbInfo or not next(tbInfo) then
		local tbTemp = G_FriendBossMgr:GetSingleBossInfo( uBossID, false )
		if tbTemp and tbTemp.uEndTime <= SSvrUnixTimeStamp( ) then
			SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.FriendBossTxt, 8 ), 2, g_GameTop )--失效		
		else
			SysMessage.ShowRuntimeMsg( SIdToString( 558 ), 2, g_GameTop )--关闭	
		end
	else
		if tbInfo.nCombatTimes >= G_FriendBossMgr:GetMaxSingleBossJoinTimes( ) then
			SysMessage.ShowRuntimeMsg( SIdToString( 563 ), 2, g_GameTop )
		else
			G_FriendBossMgr:ReqEnterCombat( uBossID )		--请求进入战斗
		end
	end
	return true
end

-- 战报链接
l_tbLableProc[ l_tTransLinkType.nReportLink ] = function( pPickedElem, pos )
	if G_UIConScriptTips:IsVisible( true ) then
		return SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.ConScript3, 6 ), 2,WindowMgr.GetCurWindowOrder( ) )
	end
	G_BattleReport.bPopPush = false
	if pPickedElem:GetGameObjIdByIdx( 2 ) == Playerdef.report_type_pvpact then
		G_Review_Combattle:ConScriptToShow( )
	else
		G_Review_Combattle:ArenaToShow( )
	end
	local uReportId = pPickedElem:GetGameObjIdByIdx( 1 )
	G_ArenaMgr:ReqPlayBack( uReportId )
	return true
end

--写入装备链接
ChatWindow.WriteItemInfo = function( pItem, uPlayerID )
	if nil == pItem then
		return
	end
	
	l_t.InputBox:Write( l_tTranslator.GetElemInfo( l_tTransLinkType.nItemLink, pItem, uPlayerID ) )
	SysMessage.ShowRuntimeMsg( SIdToString( 829 ),2, l_pTopParent )
end

--写入战宠链接
ChatWindow.WriteCreatureInfo = function( uCreatureTempID, uPlayerID )
	local tCreature = G_CreatureMgr.tbCreatureSet[ uCreatureTempID ]
	if not tCreature then
		return
	end
	
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.nCreatureLink, uCreatureTempID, uPlayerID )
	local szMsg = string.format( SIdToMultiVal( l_tbMultiVal.PetNotice, 1 ), G_Translator:GetLinkText( elemInfo ) )
	l_szShowCreature = szMsg
	G_ChatMgr:ReqChatInRoom( l_ChatDef.chat_room_id_global, szMsg )
end

--写入神兽连接
ChatWindow.WritePetInfo = function( uPetTempID, uPlayerID )
	local tPet = G_PetMgr:GetPet( uPetTempID )
	if not tPet then
		return
	end
	
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.PetLink, uPetTempID, uPlayerID )
	local szMsg = string.format( SIdToMultiVal( l_tbMultiVal.PetSkillStr, 6 ), G_Translator:GetLinkText( elemInfo ) )
	l_szShowPet = szMsg
	G_ChatMgr:ReqChatInRoom( l_ChatDef.chat_room_id_global, szMsg )
end

--写入运镖队伍链接
ChatWindow.WriteDart = function( szConscribe, szLeaderName , nRoomID , tbName  )
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.Dart, szLeaderName, tbName )
	local szInfo = G_Translator:GetLinkText( elemInfo )
	local szMsg = szConscribe .. szInfo
	local tbMsg = {	}
	tbMsg[1] = szMsg
	tbMsg[2] = Me:GetProf( )
	tbMsg[3] = Me:GetLevel( )
	tbMsg[4] = SSvrUnixTimeStamp( )
	tbMsg[5] = Me:GetVipLv( )
	tbMsg[6] =	G_EmbattleMgr:CalcCacheCombatFightVal( )
	G_ChargeDartMgr:ReqChatWithParam( tbMsg, tbName )
end

--写入运镖失败通知帮友连接
ChatWindow.WriteDartFightLose = function( szConscribe, szLeaderName, nDartID )
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.DartFightLose, szLeaderName, nDartID )
	local szInfo = G_Translator:GetLinkText( elemInfo )
	local szMsg = szConscribe .. szInfo
	G_PrilandMgr:ReqChatInRoom( l_ChatDef.chat_room_id_social, szMsg )
end

--写入帮会秘境链接
ChatWindow.WriteGuildFam = function( szConscribe, nFamRoomID , nRoomID , tbName, nCreateTime  )
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.GuildFam, nFamRoomID, nCreateTime )
	local szInfo = G_Translator:GetLinkText( elemInfo )
	local elemInfoType = l_tTranslator.GetElemInfo( l_tTransLinkType.GuildFamType , nFamRoomID, nCreateTime)
	local szType = G_Translator:GetLinkText( elemInfoType )
	local szMsg = szType .. szConscribe .. szInfo
	if not tbName then 
		G_PrilandMgr:ReqChatInRoom( nRoomID, szMsg )
	else 
		G_PrilandMgr:ReqPrivateChat( tbName , szMsg )
	end
end

--写入军征场链接
ChatWindow.WriteGuildConScript = function( szConscribe, nFamRoomID , nRoomID , tbName, nCreateTime  )
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.ConScription, nFamRoomID, nCreateTime )
	local szInfo = G_Translator:GetLinkText( elemInfo )
	local szMsg =  szConscribe .. szInfo
	if not tbName then 
		G_PrilandMgr:ReqChatInRoom( nRoomID, szMsg )
	else 
		G_PrilandMgr:ReqPrivateChat( tbName , szMsg )
	end
end

--写入公会邀请链接
ChatWindow.WriteLeagueLink = function( szConscribe, szLeagueName, nType, szPlayerName )
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.LeagueLink, szLeagueName, nType )
	local szMsg = szConscribe .. G_Translator:GetLinkText( elemInfo )

	if nType == 0 then   --世界招募
		l_szSendConscribe = szMsg
		G_LeagueMgr:ReqSendConscribe( szMsg )
	elseif nType == 1 then
		G_LeagueMgr:ReqSendJoin( szPlayerName, szMsg )
	elseif nType == 2 then
		G_LeagueMgr:ReqSendFriendsConscribe( szMsg )
	end
end

-- 写入战报链接
ChatWindow.WriteBattleReport = function( szChallenger, szAgainster, uReportId,uReportType )
	if not uReportId then
		return	
	end
	
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.nReportLink, szChallenger, szAgainster, uReportId,uReportType )
	local szMsg = string.format( SIdToMultiVal( l_tbMultiVal.Arena, 6 ), G_Translator:GetLinkText( elemInfo ) )
	l_szShareReport = szMsg
	G_ChatMgr:ReqChatInRoom( l_ChatDef.chat_room_id_global, szMsg )
end

--写入邀请加入公会群链接
ChatWindow.WriteLeagueGroupInviteLink = function( szSenderName )
	local elemInfo = l_tTranslator.GetElemInfo( l_tTransLinkType.LeagueGroupInviteLink, szSenderName )
	local szInfo = G_Translator:GetLinkText( elemInfo )
	local szMsg = SIdToMultiVal( l_tbMultiVal.LeagueGroup, 9 ) .. szInfo
	G_PrilandMgr:ReqChatInRoom( l_ChatDef.chat_room_id_social, szMsg )
end

--------------------------------------------------
--                 客服频道
--------------------------------------------------

-- 切换客服对象
ChatWindow.OnSelSer = function( args )
	local pWnd = l_UIHelper.toSTabButton( CEGUI.toWindowEventArgs( args ).window )
	if not pWnd:isSelected( ) then
		return
	end
	local SerID = pWnd:getID( )
	-- 更改发送标志
	l_nSendType = SerID
	
	-- 设置选中效果
	l_t.SetSelWnd( SerID )
	l_nEffectWndID = SerID
	
	l_nCurBugPage = 1
	l_bSetAlready = false
	l_bReqedGMData = false
	-- 设置输入框
	l_t.SetKeyState( )
	
	if SerID == l_tbSerNameToIdx.nKnowAll then
		-- 弹出菜单
		l_t.PopSerMenu( )
		
	else
		-- 隐藏菜单
		l_t.SerPopMenu:hide( )		
		--[[ 首次推送
		if l_t.FirstPutNotify( ) then
			return
		end	]]
		-- 重置未读消息图标
		if SerID == GMdef.question_type_bug then
			l_bBugUnRead = false
			l_t.nUnreadBug = 0
		else
			l_bSalUnRead = false
			l_t.nUnreadSal = 0
		end
		l_t.RefreshSerNum( )
		l_tbSerHead[ SerID+1 ]:setProperty( "InnerBackground", "" )
		l_tbSerHead[ SerID+1 ]:setProperty( "FrontImage", " " )
		if l_bFirstReqGMData[l_nSendType] then
			-- 右侧信息窗口重置
			l_t.UpdateShowWnd( l_nSendType, 1, l_nOneGroupNum, l_nShowBottom )
		else
			if not l_bReqedGMData then
				-- 请求数据
				l_bShowBottom = true
				l_bReqedGMData = true
				l_bFirstReqGMData[l_nSendType] = true
				G_GameMaster:ReqGetQue( l_nSendType, 0 )
			end
		end
		
	end
	l_t.RefreshPMNum( )	
end

--[[ 首次推送 ,逻辑实现
ChatWindow.FirstPutNotify = function( )
	if l_nSendType == GMdef.question_type_bug and Me:ChkNewroleFlags( Playerdef.player_newrole_gm0 ) ~= 0 then	
		return false
	end
	if l_nSendType == GMdef.question_type_complaint and Me:ChkNewroleFlags( Playerdef.player_newrole_gm1 ) ~= 0 then	
		return false
	end
		
	-- 设置初次提示
	local szText = ""
	local szName = ""
	if l_nSendType == GMdef.question_type_bug then
		szText = SIdToMultiVal( l_tbMultiVal.LookQuestion, 8 )
		szName = l_tbSerAnsHead[ l_tbSerNameToIdx.nBugSolve ]
	else
		szText = SIdToMultiVal( l_tbMultiVal.LookQuestion, 7 )
		szName = l_tbSerAnsHead[ l_tbSerNameToIdx.nSecretary ]
	end
	local szLabel = l_t.GetMsgText( szText, szName )
	l_nTotalWndID = l_nTotalWndID + 1
	local tbWndData = { bIsSelf = false, nAssigned = l_nTotalWndID }
	tbWndData = ChatMsgCenter.GetMsgWnd( tbWndData ) 
	l_bSetSingleMsg = true
	l_t.AddMesWnd( tbWndData, szLabel, l_tbSerAnsHead[ l_tbSerNameToIdx.nKnowAll ], false )
	l_t.ReYpoSer[ l_nShowTop ]( )	
	-- 推送完毕，置判断标志位
	if l_nSendType == GMdef.question_type_bug then
		Me:ReqChgNewroleFlag( Playerdef.player_newrole_gm0 )
	else
		Me:ReqChgNewroleFlag( Playerdef.player_newrole_gm1 )
	end
	
	return true	
	
end ]]

-- 右侧信息窗口重置
ChatWindow.UpdateShowWnd = function( nType, nBegin, nEnd, nShowType )
	local nPreYp = l_t.MesWnd:getAbsoluteYPosition( )
	local nPreHeight = l_t.MesWnd:getAbsoluteHeight( )
	local nCurHeight = 0
	local tbInfo = l_tbSerData[ nType ]
	-- 重置消息窗口
	l_t.ResetSerMsgWnd( )
	for nIdx = nEnd, nBegin, -1 do
		if tbInfo[ nIdx ] then
		
			local tbWndData = tbInfo[ nIdx ]			
			if tbWndData.pTime then
				l_t.MesWnd:addChildWindow( tbWndData.pTime )
				tbWndData.pTime:setAbsoluteYPosition( nCurHeight )
				nCurHeight = nCurHeight + tbWndData.pTime:getAbsoluteHeight( )
			end
			l_t.MesWnd:addChildWindow( tbWndData.tbLable.pMsgWnd )
			tbWndData.tbLable.pMsgWnd:setAbsoluteYPosition( nCurHeight )
			nCurHeight = nCurHeight + tbWndData.tbLable.pMsgWnd:getAbsoluteHeight( ) + l_t.nMsgSpace
			
			if nIdx == nEnd then
				l_nCurBugNum = nEnd
			end 			
			
		elseif not tbInfo[ nIdx ] and tbInfo[ nIdx-1 ] then
			l_nCurBugNum = nIdx - 1
		end
	end
	local nMesWndH = nCurHeight
	nCurHeight = math.max( l_t.SerMesCont:getAbsoluteHeight( ), nCurHeight )
	l_t.MesWnd:setAbsoluteHeight( nMesWndH )
	l_t.MesWnd:setAbsoluteWidth( l_t.SerMesCont:getAbsoluteWidth( ) )
	if nShowType == l_nShowNoChange then
		nCurHeight = nPreHeight
	end
	l_t.ReYpoSer[ nShowType ]( nCurHeight, nPreYp )
end

-- 设置输入框
ChatWindow.SetKeyState =  function( )
	if l_nSendType == l_tbSerNameToIdx.nKnowAll then
		l_t.SerPutWnd:hide( )
		l_t.SerBg:show( )
--		l_t.SerSb:show( )
		l_t.SerMesCont:setAbsoluteHeight( l_nKnowTypeHeight )
	else
		l_t.SerPutWnd:show( )
		l_t.SerBg:hide( )
--		l_t.SerSb:hide( )
		l_t.SerMesCont:setAbsoluteHeight( l_nBugTypeHeight )
	end
end
	
-- 保存浏览进度信息
ChatWindow.OnSaveLookPro =  function( )
	local nLookHeight = math.abs( l_t.MesWnd:getAbsoluteYPosition( ) )
	local nTotalHeight = 0
	local nKnowNum = l_nKnowBegin
	local nYposition = 0
	if nLookHeight > 0 then 
		for nIdx = 1, table.getn( l_tbKnowWnd ) do
			 local nWndHeight = l_tbKnowWnd[ nIdx ]:getAbsoluteHeight( )
			 if nLookHeight > nTotalHeight and nLookHeight < nTotalHeight + nWndHeight then
			 	nKnowNum =  nKnowNum + math.ceil( nIdx / 2 ) - 1
			 	if nIdx % 2 == 0 then
			 		nYposition = nLookHeight - nTotalHeight + l_tbKnowWnd[ nIdx-1 ]:getAbsoluteHeight( ) + l_t.nMsgSpace
			 	else
			 		nYposition = nLookHeight - nTotalHeight
			 	end 
			 	break
			 else
				 nTotalHeight = nTotalHeight + nWndHeight + l_t.nMsgSpace	
			 end
		end
	end
	-- 信息存盘
	l_pUserConfigs:SetUInt( "GameConfigs", "QesType", l_nKnowType )
	l_pUserConfigs:SetUInt( "GameConfigs", "QesNum", nKnowNum )
	l_pUserConfigs:SetUInt( "GameConfigs", "QesHeight", nYposition )
	l_pUserConfigs:Save( )
end

-- 设置窗口选中效果
ChatWindow.SetSelWnd = function( SerID )
	if l_nEffectWndID ~= -1 then
		-- 清空 l_nSendType 的特效
		l_t.ClearUnSelWnd( l_tbEffectWnd[ l_nEffectWndID+1 ]  )
	end
	-- 设置 SerID 窗口的特效
--	l_t.SetEffectAction( l_tbEffectWnd[ l_nSendType+1 ] )
end

-- 弹出选项窗口
ChatWindow.PopSerMenu = function( )
	-- 判断是否创建过，没有则创建菜单
	if not l_bCreated then
		l_t.CreateWnd(  )
	end
	
	-- 重置消息窗口
	l_t.ResetSerMsgWnd( )
	
	-- 首次打开推送消息
	if Me:ChkNewroleFlags( Playerdef.player_newrole_gm ) == 0 then -- 人物初次显示标志位判断  	
		l_t.FirstPutMsg(  )
	end
		
	-- 读机器配置，获取以前浏览状态
	local nLastIdx = l_pUserConfigs:GetUInt( "GameConfigs", "QesType", 0 )
	if nLastIdx ~= 0 then
		-- 设置选中效果
		l_bReadConfigs = true
		l_tbMenuBarWnd[ nLastIdx ]:setSelected( false )
		l_tbMenuBarWnd[ nLastIdx ]:setSelected( true )
	end
		
	-- 显示选项窗口
	l_t.SerPopMenu:show( )
	l_t.SerPopMenu:moveToFront( )
end

-- 首次打开推送消息
ChatWindow.FirstPutMsg = function(  )
	-- 设置初次提示
	local szText = SIdToMultiVal( l_tbMultiVal.LookQuestion, 9 )
	local szName = SIdToMultiVal( l_tbMultiVal.LookQuestion, 3 )
	local szLabel = l_t.GetMsgText( szText, szName )
	l_nTotalWndID = l_nTotalWndID + 1
	local tbWndData = { bIsSelf = false, nAssigned = l_nTotalWndID }
	tbWndData = ChatMsgCenter.GetMsgWnd( tbWndData ) 
	l_bSetSingleMsg = true
	l_t.AddMesWnd( tbWndData, szLabel, l_tbSerAnsHead[ l_tbSerNameToIdx.nKnowAll ], false )
	l_t.ReYpoSer[ l_nShowTop ]( )	
	
	-- 推送完毕，置判断标志位
	Me:ReqChgNewroleFlag( Playerdef.player_newrole_gm )
	
end

-- 创建选项窗口 
ChatWindow.CreateWnd = function(  )
	-- 获得类型个数
	local nType = G_CommonProblemsCfg:GetTypeNum( )
	if nType == 0 then
		return
	end
	
	-- 高度
	local nBarHeight = l_tbMenuBarWnd[1]:getAbsoluteHeight( )
	local nHeight = nBarHeight + l_nMenuDis  
	
	-- 设置名称
	local szName = G_CommonProblemsCfg:GetTypeName( 1 )
	l_tbMenuBarWnd[1]:setAnsiText( szName )
	
	-- 复制窗口
	for nIdx = 2, nType do
		l_tbMenuBarWnd[ nIdx ] = l_UIHelper.toSTabButton( l_WndMgr:copyWindowWithChild( l_t.SerMenuBar, nIdx )  ) 
		l_tbMenuBarWnd[ nIdx ]:setID( nIdx )
		l_tbMenuBarWnd[ nIdx ]:SetGroupID( 1 ) 
		l_tbMenuBarWnd[ nIdx ]:subscribeEvent( l_CEGUI.EventSelectStateChanged, l_t.OnSwitchBar )
		l_t.SerPopMenu:addChildWindow( l_tbMenuBarWnd[ nIdx ] )
		l_tbMenuBarWnd[ nIdx ]:setAbsoluteYPosition( nHeight )
		nHeight = nHeight + nBarHeight
		szName = G_CommonProblemsCfg:GetTypeName( nIdx )
		l_tbMenuBarWnd[nIdx]:setAnsiText( szName )
		if nIdx == nType then
			l_tbMenuBarWnd[ nIdx ]:setProperty( "ClientAreaBackground", "" )
			l_tbMenuBarWnd[ nIdx ]:setProperty( "ClientAreaBackgroundExt", "" )
			l_tbMenuBarWnd[ nIdx ]:setProperty( "ClientAreaBackgroundExt2", "" )
		else
			l_tbMenuBarWnd[ nIdx ]:setProperty( "ClientAreaBackground", "set:sat_common_ui_1 image:namainfo_r" )
			l_tbMenuBarWnd[ nIdx ]:setProperty( "ClientAreaBackgroundExt", "set:sat_common_ui_1 image:namainfo_r" )
			l_tbMenuBarWnd[ nIdx ]:setProperty( "ClientAreaBackgroundExt2", "set:sat_common_ui_1 image:namainfo_m" )
		end
	end
		
	l_t.SerPopMenu:setAbsoluteHeight( nHeight + 14 * l_System:getSystemScale( ) ) 
	
	-- 创建完毕
	l_bCreated = true
end

-- 切换下拉菜单选项
ChatWindow.OnSwitchBar = function( args )
	local pWnd = UIHelper.toSTabButton( CEGUI.toWindowEventArgs( args ).window )
	if not pWnd:isSelected( ) then
		return
	end
	
	-- 设置查看类型
	local nId = pWnd:getID( )
	l_nKnowType = nId
	-- 获得问题的个数 
	local nTotalNum = G_CommonProblemsCfg:GetSetNum( nId )	

	-- 重置消息窗口
	l_t.ResetSerMsgWnd( )
	-- 回收窗口
	l_t.RecoverWnd( )
	
	if l_bReadConfigs then
		l_t.ReviewShow( nId )
		l_bReadConfigs = false
	else
		l_nKnowBegin = 1
		l_t.SetOnePage( nId, 1 )
		l_t.ReSetAllSerWnd( l_nShowTop )
	end
	
end

-- 恢复浏览进度
ChatWindow.ReviewShow = function( nType )
	-- 读取配置，获得显示第几条
	local nLastQue = l_pUserConfigs:GetUInt( "GameConfigs", "QesNum", 0 )
	l_nKnowBegin = nLastQue
	-- 显示当前页数据
	l_t.SetOnePage( nType, nLastQue )
	l_t.ReSetAllSerWnd( l_nShowReview )
end

-- 显示一页数据 
ChatWindow.SetOnePage = function( nType, nIdx, bPre )
	local bEnd = false
	
	if bPre then
		-- 前一页
		for nPos = nIdx - 1, nIdx - l_nOneGroupNum, -1 do
			if l_t.SetQAWnd( nType, nPos, bPre ) then
				l_nKnowBegin = l_t.SetQAWnd( nType, nPos, bPre ) + 1
				bEnd = true
				break
			end
		end
		-- 起始条目
		if not bEnd then
			l_nKnowBegin = l_nKnowBegin - l_nOneGroupNum
		end
	else
		-- 后一页
		for nPos = nIdx, nIdx + l_nOneGroupNum -1 do
			if l_t.SetQAWnd( nType, nPos ) then
				l_nKnowLast = l_t.SetQAWnd( nType, nPos ) - 1
				bEnd = true
				break
			end
		end
		-- 终止条目
		if not bEnd then
			l_nKnowLast = nIdx + l_nOneGroupNum -1 
		end
	end
	
end

-- 设置一对问答窗口
ChatWindow.SetQAWnd = function( nType, nPos, bPre )
	-- 获得数据
	local tbData = G_CommonProblemsCfg:GetQuestionInfo( nType, nPos )
 	if not tbData then
 		return nPos
 	end
	
	if bPre then
		l_t.SetAnseWnd( tbData, bPre )
		l_t.SetQuesWnd( tbData, bPre )
	else
		l_t.SetQuesWnd( tbData, bPre )
		l_t.SetAnseWnd( tbData, bPre )
	end	
	
end

-- 设置问题窗口
ChatWindow.SetQuesWnd = function( tbData, bPre )
	-- 拼接问题字符串
	local szQueLabel = l_t.GetMsgText( tbData.szQuestion, tbData.szName )
	-- 获得问题窗口
	l_nTotalWndID = l_nTotalWndID + 1
	local tbWndData = { bIsSelf = true, nAssigned = l_nTotalWndID }
	tbWndData = ChatMsgCenter.GetMsgWnd( tbWndData) 
	-- 设置信息添加窗口
	l_t.AddMesWnd( tbWndData, szQueLabel, tbData.szIco, true, bPre , nil,  true)
	-- 添加到计算第几个的表里
	l_t.UpdateKnowWndTb( tbWndData.tbLable.pMsgWnd, bPre )
end

-- 设置回答窗口
ChatWindow.SetAnseWnd = function( tbData, bPre )
	-- 拼接回答字符串
	local szAnLabel = l_t.GetMsgText( tbData.szAnswer, l_tbSerAnsName[ l_tbSerNameToIdx.nKnowAll ] )
	-- 获得回答窗口
	l_nTotalWndID = l_nTotalWndID + 1
	local tbWndData = { bIsSelf = false, nAssigned = l_nTotalWndID }
	tbWndData = ChatMsgCenter.GetMsgWnd( tbWndData ) 
	-- 设置信息添加窗口
	l_t.AddMesWnd( tbWndData, szAnLabel, l_tbSerAnsHead[ l_tbSerNameToIdx.nKnowAll ], false, bPre, nil, true)
	-- 添加到计算第几个的表里
	l_t.UpdateKnowWndTb( tbWndData.tbLable.pMsgWnd, bPre )
end

-- 添加到计算第几个的表里
ChatWindow.UpdateKnowWndTb = function( pWnd, bPre )
	if bPre then
		table.insert( l_tbKnowWnd, 1, pWnd )
	else
		table.insert( l_tbKnowWnd, pWnd )
	end
end

-- 获取拼接字符串Layout
ChatWindow.GetMsgText = function( szText, szName, szExtMsg, nExtTime, bWorld )
	local nRealVip = 0
	local nTitle = 0 
				
	local nMsgWidth = ChatMsgCenter.nLabelWidth
	local szMessage = ""
	if szExtMsg and nExtTime and nExtTime ~= 0 then
		local nMonth  = STaskTimeObj:GetMonthByTimeStamp( nExtTime )
		local nDay		= STaskTimeObj:GetDayByTimeStamp( nExtTime )
		local szText2 = string.format( SIdToMultiVal( l_tbMultiVal.LookQuestion, 0 ), nMonth, nDay )
		szExtMsg = UIHelper.SubNameStr( szExtMsg, l_nExtMsgLen + 1 )
		szText2 = string.format( SIdToMultiVal( l_tbMultiVal.LookQuestion, 6 ), szText2 .. szExtMsg )
		if bWorld then
			szMessage = "<Obj tva=center fs=19 fgt=normal f=wrap cn=FF44311D>" .. szText .. szText2  .. "</Obj>"
		else
			szMessage = "<Obj tva=center fs=19 fgt=normal f=wrap cn=FF44311D>" .. szText .. "\n" .. szText2  .. "</Obj>"
		end
	else
		szMessage = ParseChatMsg.ParseMsgContent( szText, "cn=FF483823" )
	end
	
	-- 获得名字颜色
	if szName == Me:GetName( ) then
		nTitle = G_TitleMgr:GetCurUseTitleId( )
		nRealVip = Me:GetVipLv( )
	end
	if bWorld then
		return ParseChatMsg.GetLayoutChatMsg( l_t.nMainTxtWidth, szName, "", szMessage, 11,1, 1 )
	else
		return ParseChatMsg.GetLayoutChatMsg( nMsgWidth, szName, "", szMessage, 11, nTitle, 2, nRealVip ) 
	end
end

-- 添加问答窗口
ChatWindow.AddMesWnd = function( tbWndData, szText, szImage, bQues, bPre, bBug, bName )
	local pMsgWnd	= nil
	local pMsgLabel = nil
	pMsgWnd = tbWndData.tbLable.pMsgWnd		
	pMsgLabel = tbWndData.tbLable.pMsgLabel	
	pMsgWnd:show( )
	if  bName then
		local pLv =  tbWndData.tbLable.pLv
		pLv:hide( )
	else
		local pLv =  tbWndData.tbLable.pLv
		pLv:setAnsiText(string.format(SIdToMultiVal( l_tbMultiVal.ChangeToChinese, 8 ), Me:GetLevel( ) ) )
	end
	local pHead = tbWndData.tbLable.pHead
	pHead:setProperty( "ClientAreaBackground", szImage )
	if bQues then
		pHead:setYRotation( 180 )
	else
		pHead:setYRotation( 0 )
	end
	
	pMsgLabel:setAnsiText( szText )
	local nHeight = pMsgLabel:getAbsoluteHeight( ) + pMsgLabel:getAbsoluteYPosition( ) * 2
	local nMsgWidth = ChatMsgCenter.nBubbleWidth - ( ChatMsgCenter.nLabelWidth - pMsgLabel:getAbsoluteWidth( ) )
	nMsgWidth = math.max( nMsgWidth, ChatMsgCenter.nBubbleWidth * 0.66 )
	pMsgWnd:setAbsoluteWidth( nMsgWidth )
	if pMsgWnd:getAbsoluteXPosition( ) > 0 then
		pMsgWnd:setXPosition( 1, -nMsgWidth )
	end
	local nMsgHeight = nil
	if ChatMsgCenter.nSingleWndHeight > pMsgLabel:getAbsoluteHeight( ) + pMsgLabel:getAbsoluteYPosition( ) * 2 then
		nMsgHeight = ChatMsgCenter.nSingleWndHeight
	else
		nMsgHeight = pMsgLabel:getAbsoluteHeight( ) + pMsgLabel:getAbsoluteYPosition( ) * 2
	end
	pMsgWnd:setHeight( 0, nMsgHeight )

	if not bBug then
		if bPre then	
			l_t.MesWnd:addChildWindowToFront( pMsgWnd )
		else
			l_t.MesWnd:addChildWindow( pMsgWnd )
		end
	end
	
	-- 只设置单个窗口	
	if l_bSetSingleMsg then	
		local nPreHeight = l_t.MesWnd:getAbsoluteHeight( )
		local nLabelHeight = pMsgWnd:getAbsoluteHeight( )
		pMsgWnd:setAbsoluteYPosition( nPreHeight )
		local nPageHeight = nPreHeight + nLabelHeight + l_t.nMsgSpace
		l_t.MesWnd:setAbsoluteHeight( math.max( nPageHeight, l_t.SerMesCont:getAbsoluteHeight( ) ) )
		l_t.MesWnd:setAbsoluteWidth( l_t.SerMesCont:getAbsoluteWidth( ) )
		l_bSetSingleMsg = false
	end
	
end

-- 调整全部窗口
ChatWindow.ReSetAllSerWnd = function( nType, nPreHight, nPreYPosition )
	local nPageHeight = l_t.ResizeSer( )
	if nType == l_nShowNoChange then
		nPageHeight = nPreHight
	end
	l_t.ReYpoSer[ nType ]( nPageHeight, nPreYPosition )	
end

-- 重新调整Page大小
ChatWindow.ResizeSer = function( )
	local nChildCount = l_t.MesWnd:getChildCount( )
	local nPageHeight = 0
	for uIdx = 0, nChildCount - 1 do
		local pChild = l_t.MesWnd:getChildAtIdx( uIdx )
		pChild:setYPosition( 0, nPageHeight )
		nPageHeight = nPageHeight + pChild:getAbsoluteHeight( ) + l_t.nMsgSpace
	end
	l_t.MesWnd:setAbsoluteWidth( l_t.SerMesCont:getAbsoluteWidth( ) )
	l_t.MesWnd:setAbsoluteHeight( math.max( nPageHeight, l_t.SerMesCont:getAbsoluteHeight( ) ) )
	return nPageHeight
end

-- 重新调整窗口位置
ChatWindow.ReYpoSer =
{
	-- 置顶显示
	[ l_nShowTop ] = function( )
		l_t.MesWnd:setYPosition( 0, 0 )
	end,
	
	-- 置底显示
	[ l_nShowBottom ] = function( nPageHeight )
		l_t.MesWnd:setYPosition( 0, -nPageHeight + l_t.SerMesCont:getAbsoluteHeight( ) )
	end,
	
	-- 显示内容不变
	[ l_nShowNoChange ] = function( nPreHight, nPreYPosition )
		local nCurYPosition = l_t.MesWnd:getAbsoluteHeight( )
		l_t.MesWnd:setAbsoluteYPosition( nPreYPosition + nPreHight - nCurYPosition )
	end,
	
	-- 恢复浏览进度
	[ l_nShowReview ] = function( )
		local nLastYp = l_pUserConfigs:GetUInt( "GameConfigs", "QesHeight", -1 )
		l_t.MesWnd:setYPosition( 0, -nLastYp )	
	end,
	
} 

-- 重置消息窗口
ChatWindow.ResetSerMsgWnd = function( )
	l_t.MesWnd:removeAllChildWindow( )
	l_t.MesWnd:setYPosition( 0, 0 )
	l_t.MesWnd:setAbsoluteHeight( 0 )
end

-- 回收窗口
ChatWindow.RecoverWnd = function( )
	ChatMsgCenter.QuesLabelList:RecoverAll( )
	ChatMsgCenter.AnseLabelList:RecoverAll( )
	l_tbKnowWnd = { }
end


---------------------------  分页显示 --------------------------------------

-- 获得当前坐标
ChatWindow.OnGetCurYp = function( args )
	local TouchArgs = CEGUI.toTouchEventArgs( args )
	l_nDownYPos = TouchArgs.position.y
	l_bSetAlready = true
end

-- 判断方向
ChatWindow.OnJuggDirection = function( args )
	local TouchArgs = CEGUI.toTouchEventArgs( args )
	local nDelta = TouchArgs.position.y - l_nDownYPos
	
	if nDelta > 0 then
		l_nDirection = l_tbDir.down
	else
		l_nDirection = l_tbDir.up
	end
end

-- 判断距离，设置窗口
ChatWindow.OnSetAnotherGroup = function( args )
	local nPreHight = l_t.MesWnd:getAbsoluteHeight( )
	local nPreYPosition = l_t.MesWnd:getAbsoluteYPosition( )
	local nContHeight = l_t.SerMesCont:getAbsoluteHeight( )
	
	-- 上滑
	if l_nDirection == l_tbDir.up then
		if nContHeight - nPreYPosition - nPreHight >= l_nMesOffset and l_bSetAlready then
			l_bSetAlready = false
			-- 添加下一组数据
			l_t.SetNextGroup( )
		end
	end
	
	-- 下滑
	if l_nDirection == l_tbDir.down then
		if nPreYPosition >= l_nMesOffset and l_bSetAlready then
			l_bSetAlready = false
			-- 设置上一组数据
			l_t.SetPreGroup( nPreHight, nPreYPosition )
		end
	end
	
end

-- 添加下一组数据
ChatWindow.SetNextGroup = function( )
	if l_nSendType == l_tbSerNameToIdx.nKnowAll then
		-- 百科
		l_t.SetOnePage( l_nKnowType, l_nKnowLast+1 )
		l_t.ResizeSer( )
	end
end

-- 添加上一组数据
ChatWindow.SetPreGroup = function( nPreHight, nPreYPosition )
	if l_nSendType == l_tbSerNameToIdx.nKnowAll then
		-- 百科
		l_t.SetOnePage( l_nKnowType, l_nKnowBegin-1, true )
		l_t.ReSetAllSerWnd( l_nShowNoChange, nPreHight, nPreYPosition )
	else
		local nTotalPageNum = G_GameMaster:GetPageCnt( l_nSendType )
		-- 界面最多只请求7页数据( 125个数据 )
		if nTotalPageNum > l_nMaxGMPageNum then
			nTotalPageNum   = l_nMaxGMPageNum
		end	
		
		if l_nCurBugPage >= nTotalPageNum then
			return
		elseif l_nCurBugPage * l_nOneGroupNum < l_nCurBugNum then
			l_t.UpdateShowWnd( l_nSendType, 1, ( l_nCurBugPage+1 ) * l_nOneGroupNum, l_nShowNoChange )
			l_nCurBugPage = l_nCurBugPage + 1
		else 
			if not l_bReqedGMData then
				l_bReqedGMData = true
				l_bFirstReqGMData[l_nSendType] = true
				G_GameMaster:ReqGetQue( l_nSendType, l_nCurBugPage )
			end
		end
	end
end


--------------------- 小秘书&BUG解决者 ---------------------

-- 提交消息
ChatWindow.OnHandMsg = function( args )
	local szQue = l_UIHelper.GetText( l_t.SerPutBox )
	szQue = G_TextFilterMgr:WarningStrGsub( szQue )
	if "" ~= szQue then
		G_GameMaster:ReqCmtQue( l_nSendType, szQue )	
		l_HandFlag = true
	end
	l_t.SerPutBox:ClearText( )	
end

-- 提交消息成功回调
ChatWindow.OnCmtQueSuc = function ( )
	SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.SysWarn0, 5 ), 5, l_pTopParent )   
	if not l_t.ChatWindow then
		return 	
	end
	l_t.SerPutBox:ClearText( )
end

-- 提交成功&请求查看回调
ChatWindow.OnRefQueList = function( nQueType, Offset, Num)
	if l_HandFlag then
		-- 提交成功
		l_t.UpdateSingleMsg( nQueType, Offset, Num )
		l_HandFlag = false
	else
		l_bReqedGMData = false
		-- 请求查看
		l_t.SetSerOnePage( nQueType, Offset, Num )
	end
end	

-- 单条刷新
ChatWindow.UpdateSingleMsg = function( nQueType, Offset, Num )
	if not l_t.ServerParent then
		return
	end
	
	-- 创建设置窗口，更新Table	
	local tbInfo = G_GameMaster:GetQueDesc( nQueType, 1 )
	l_t.CreSetWnd( tbInfo, nQueType, true )
	l_nCurBugNum = l_nCurBugNum + 1
	
	-- 更新窗口
	if l_nSendType == nQueType and l_t.ServerParent:isVisible( ) then
		l_t.UpdateShowWnd( l_nSendType, 1, l_nCurBugNum, l_nShowBottom )
	end
	
end

-- 创建设置问答窗口
ChatWindow.CreSetWnd = function( tbInfo, nType, bPre )
	local tbWndData = { bIsSelf = false, nAssigned = l_nTotalWndID }
	if tbInfo.bIsAnswer then
		-- 回答窗口
		-- 拼接问题字符串
		local szQueLabel = l_t.GetMsgText( tbInfo.szMsg, l_tbSerAnsName[ nType ], tbInfo.szExtMsg, tbInfo.nExtTime )
		-- 获得问题窗口
		l_nTotalWndID = l_nTotalWndID + 1
		if tbInfo.nTime - tbInfo.nExtTime >= l_nMsgTimeDvalue and tbInfo.nExtTime ~= 0 then
			tbWndData.bTime = true
			tbWndData.nTime = tbInfo.nTime
		end 
		tbWndData = ChatMsgCenter.GetMsgWnd( tbWndData, true) 			
		l_t.AddMesWnd( tbWndData, szQueLabel, l_tbSerAnsHead[ nType ], false, bPre, true )
	else
		-- 玩家提问
		-- 拼接问题字符串
		local szQueLabel = l_t.GetMsgText( tbInfo.szMsg, Me:GetName( ) )
		-- 获得问题窗口
		l_nTotalWndID = l_nTotalWndID + 1
		tbWndData = { bIsSelf = true, nAssigned = l_nTotalWndID }
		tbWndData = ChatMsgCenter.GetMsgWnd( tbWndData, true) 			
		l_t.AddMesWnd( tbWndData, szQueLabel, G_Prof[Me:GetProf( )], false, bPre, true, false ) 
	end
	
	if l_tbSerData[ nType ] and table.maxn( l_tbSerData[ nType ] ) >= l_nMaxSerNum then
		-- 移除最顶窗口
		l_t.RemoveTopWnd( nType )
	end
	if bPre then
		table.insert( l_tbSerData[ nType ], 1, tbWndData )
	else
		table.insert( l_tbSerData[ nType ], tbWndData )
	end
end

-- 移除最顶窗口
ChatWindow.RemoveTopWnd = function( nType )
	local tbInfo = l_tbSerData[ nType ]
    if not tbInfo then
        return
    end

    local tbData = tbInfo[#tbInfo]
	if tbData.pTime then
		-- 移除时间窗口
		ChatMsgCenter.Time2LabelList:Recover( tbData.nAssigned )
	end
	-- 移除最顶窗口
	if tbData.bIsSelf then
		ChatMsgCenter.Ques2LabelList:Recover( tbData.nAssigned )
	else
		ChatMsgCenter.Anse2LabelList:Recover( tbData.nAssigned )
	end
	table.remove( tbInfo )
end

-- 设置一页消息
ChatWindow.SetSerOnePage = function( nQueType, Offset, Num )
	for nIdx = 1, Num do
		-- 获取数据, 确保只刷新l_nMaxSerNump个数据
		-- 否则调用CreSetWnd会把当前正在显示的顶部的窗口顶掉
		local nPos = Offset * l_nOneGroupNum + nIdx
		if nPos > l_nMaxSerNum then
			break 
		end
		
		local tbInfo = G_GameMaster:GetQueDesc( nQueType, nPos )
		if not tbInfo then
			break
		end
		l_t.CreSetWnd( tbInfo, nQueType, false )
	end
	if l_bShowBottom then
		-- 第一页显示底部，其他情况普通显示
		local nShowType = l_nShowNoChange 
		if 0 == Offset then
			nShowType = l_nShowBottom
		end 
		l_t.UpdateShowWnd( l_nSendType, 1, ( Offset + 1 ) * l_nOneGroupNum, nShowType )
		l_bShowBottom = false
	else
		l_t.UpdateShowWnd( l_nSendType, 1, ( Offset + 1 ) * l_nOneGroupNum, l_nShowNoChange )
	end
end

-- 新消息回复
ChatWindow.OnNewReply = function( tbInfo )
	if not tbInfo then
		return 
	end
	-- 更换形式
	local tbInfo2 = 
	{
		bIsAnswer = true,
		nTime = tbInfo.nReplyTime,
		szMsg = tbInfo.szAns,
		nExtTime = tbInfo.nCommitTime,
		szExtMsg = tbInfo.szQue	
	}
	
	-- 主界面聊天显示
	local szMainMsg = l_t.GetMsgText( tbInfo2.szMsg , l_tbSerAnsName[ tbInfo.nType ], tbInfo2.szExtMsg, tbInfo2.nExtTime, true )
	l_t.MainChatTxtShow( szMainMsg, false )
	
	-- 未读设置
	if not l_t.ServerParent or not l_t.ServerParent:isVisible( ) then
		if tbInfo.nType == GMdef.question_type_bug then
			l_bBugUnRead = true
			l_t.nUnreadBug = l_t.nUnreadBug + 1
			l_t.nUnreadMsgs = l_t.nUnreadMsgs + 1
		else
			l_bSalUnRead = true
			l_t.nUnreadSal = l_t.nUnreadSal + 1
			l_t.nUnreadMsgs = l_t.nUnreadMsgs + 1
		end
		ChatWindow.RefreshSerNum( )
		ChatWindow.RefreshPMNum( )
	end
	
	-- 创建设置窗口，更新Table	
	l_t.CreSetWnd( tbInfo2, tbInfo.nType, true )
	l_nCurBugNum = l_nCurBugNum + 1
	
	-- 更新窗口
	if l_t.ServerParent:isVisible( ) then
		if l_nSendType == tbInfo.nType then
			l_t.UpdateShowWnd( l_nSendType, 1, l_nCurBugNum, l_nShowBottom )
		else 
			l_tbSerHead[ tbInfo.nType+1 ]:setProperty( "InnerBackground", l_MsgIcon )
			l_tbSerHead[ tbInfo.nType+1 ]:setProperty( "FrontImage", l_MsgIcon1 )
		end
	end
	
end

-- 上线同步是否有未读消息
ChatWindow.OnSyncHaveUnread = function( tbInfo )
	if tbInfo[ GMdef.question_type_bug ] == 1 then
		l_bBugUnRead = true
	end
	if tbInfo[ GMdef.question_type_complaint ] == 1 then
		l_bSalUnRead = true
	end
end

--点击“已隐藏其他玩家”按钮所触发的事件（显示系统设置页面）
ChatWindow.OnShowSystemSetup = function( )
	G_SystemSetup:Show( )
end

--判断“已隐藏其他玩家”按钮是否显示，显示的话隐藏并且清除计时器
ChatWindow.HideShieldTipsBtn = function( )
	if l_t.ShieldTipsBtn and l_t.ShieldTipsBtn:isVisible( true ) then
		l_t.ShieldTipsBtn:hide( )
		l_t.ShieldTipsBtn:removeTimer( 1 )
	end
end

--低配手机每次进入默认显示“已隐藏其他玩家”一分钟，其他手机根据是否设置隐藏其他玩家选择“已隐藏其他玩家”按钮是否显示一分钟
ChatWindow.ShowShieldTipsBtn = function( )
	if not l_t.ShieldTipsBtn then
		l_t.InitMainChatWnd( )
	end
	-- 低配隐藏玩家npc
	l_t.ShieldTipsBtn:show( )
	l_t.ShieldTipsBtn:setTimer( 1, 60 )
end

ChatWindow.OnRotation = function( args )
	local pWnd		= l_CEGUI.toTouchEventArgs( args ).window
	local nZRotation	= pWnd:getRotation( ).z
	if nZRotation >= 360 then
		nZRotation = nZRotation - 360
	end
	nZRotation = nZRotation + 8
	pWnd:setZRotation( nZRotation )
end

ChatWindow.CopySendMsg = function( szMsg )
	-- 仅限电脑显示
	if SAT_PLATFORM ~= 'WIN32' then
		return
	else
		if not szMsg or szMsg == "" then
			return
		end
		local uStrLen  = string.len( szMsg )
		for uIdx = 1, uStrLen do
			if 255 == string.byte( szMsg, uIdx ) then
				SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.Voice, 7 ), 3, l_pTopParent )
				return
			end
		end
		SysMessage.ShowRuntimeMsg( SIdToMultiVal( l_tbMultiVal.Voice, 9 ), 3, l_pTopParent )
		l_szCopyMsg = szMsg
	end
end

ChatWindow.OnTouchLongDown = function( args )
	-- 仅限电脑显示
	if SAT_PLATFORM ~= 'WIN32' then
		return
	else
		if not l_szCopyMsg or l_szCopyMsg == "" then
			return
		end
		local szText = UIHelper.GetText( l_t.InputBox )
		local nWidth = l_t.InputBox:getFont( ):getAnsiTextExtent( szText, l_t.InputBox:getFontSize( ), l_t.InputBox:getGlyphType( ) )
		l_t.InputBox:deactivate( )
		if nWidth > l_t.InputBox:getAbsoluteWidth( ) - l_t.PasteBtn:getAbsoluteWidth( ) then
			l_t.PasteBtn:setXPosition( 1, -l_t.PasteBtn:getAbsoluteWidth( ) )
		else
			l_t.PasteBtn:setXPosition( 0, nWidth )
		end
		l_t.PasteBtn:show( )
		l_t.PasteBtn:activate( )
	end	
end

ChatWindow.OnPasteDeactivated = function( args )
	l_t.PasteBtn:hide( )
end

ChatWindow.OnPaste = function( args )
	local szText = UIHelper.GetText( l_t.InputBox ) .. l_szCopyMsg
	l_t.InputBox:Overwrite( szText )
	l_t.PasteBtn:deactivate( )
end

ChatWindow.CheckIsServer = function( )
	return l_t.nCurPageIdx == l_nServerID
end

ChatWindow.RefMemLs = function( tbResult )
	if ChatWindow.IsVisible( ) then
		ChatWindow.InsertSocial( tbResult )
	end	
end


ChatWindow.OnInviteReceive = function( szSender, tbMsg )
	local nFlag = tbMsg[7]
	if nFlag or nFlag == 1 then 
		return
	end
	local szMsg = tbMsg[1]
	local nSenderProf = tbMsg[2]
	local nSenderLevel = tbMsg[3]
	local ulTime = tbMsg[4]
	local nVipLv = tbMsg[5] 
	local nCombatVal = tbMsg[6]
	if not ChatWindow.tbDartTime[szSender] or ulTime - ChatWindow.tbDartTime[szSender] > 3600 then 
		ChatWindow.ReceiveChatMessage( szSender,0,szMsg,Chatdef.chat_room_id_social,nSenderProf,nSenderLevel,ulTime,
						1,nil,nVipLv,nCombatVal, 0 )
		ChatWindow.tbDartTime[szSender] = ulTime
	end
end

--运镖复仇提示信息
ChatWindow.OnRevenge = function( szEnemy, nDartId )
	local ulTime = SSvrUnixTimeStamp( )
	local szMsg = string.format( SIdToMultiVal( l_tbMultiVal.ChargeDartStr4, 8 ) , szEnemy )
	
	ChatWindow.ReceiveChatMessage( nil,0,szMsg,Chatdef.chat_room_id_sys,nil,nil,ulTime,
						nil,2,nil,nil, nil)
end

--删除聊天缓存中某玩家言论
ChatWindow.OnDeletePlayerMsg = function( szName )
	ChatMsgCenter.DeletPlayerMsg( szName )
	if ChatWindow:IsVisible( true ) then
		ChatWindow.BeginRefresh( )
	end
end

G_UIModuleFrame:RegEventConsole( OnChargeDartEvent, "OnEnemyChargeDart", ChatWindow.OnRevenge )
G_UIModuleFrame:RegEventConsole( OnChargeDartEvent, "OnRecvieDartMsg", ChatWindow.OnInviteReceive )
G_UIModuleFrame:RegEventConsole( OnLeagueEnv, "OnRefMemLs", l_t.RefMemLs )
G_UIModuleFrame:RegUICaseModule( ChatWindow, "ChatWindow", nil, true )
G_UIModuleFrame:RegEventConsole( OnPlayerEvent, "OnTaskValChged", ChatWindow.OnChgTask )
G_UIModuleFrame:RegEventConsole( OnPlayerEvent, "OnDeleteMsg", ChatWindow.OnDeletePlayerMsg )

