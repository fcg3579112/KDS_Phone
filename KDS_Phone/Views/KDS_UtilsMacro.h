//
//  KDS_UtilsMacro.h
//  KDS_Phone
//
//  Created by kds on 14-12-30.
//  Copyright (c) 2014年 kds. All rights reserved.
//

/**
 *  存放一些功能宏，比如判断系统版本、颜色宏及其它一些简短函数宏
 */

#ifndef KDS_Phone_KDS_UtilsMacro_h
#define KDS_Phone_KDS_UtilsMacro_h


#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d]\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


#define kListEmptyString      @"ABC123"    //如果是这个字符串，列表显示时显示空
#define kKeyBoradHistoryFile  @"KeyBoradHistory.plist"          //键盘精灵搜索历史文件路径
#define kZiXuanListAllInforFile   @"ZiXuanListAllInforFile.plist"   //自选股列表全部信息--缓存上次请求的自选列表，为了兼容服务器请求自选信息失败的情况
#define kNewRecentMoreMenuArray   @""         //更多页面需要显示小红点的菜单名称，暂时为空


#define kHangYeBKCode       1     //行业板块
#define kGaiNianBKCode      2     //概念板块
#define kDiYuBKCode         3     //地域板块
#define kDaShuJuBKCode      0     //大数据板块

//Method
#define kScreen_Bounds ([UIScreen mainScreen].bounds)
#define kScreen_Width ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define kScreen_Height ([UIScreen mainScreen].bounds.size.height)
// 横屏时的屏幕宽高
#define kScreen_Width_Hor   (kSystem_Version_Less_Than(@"8.0") ? kScreen_Width : kScreen_Height)     // 横屏时的宽度
#define kScreen_Height_Hor  (kSystem_Version_Less_Than(@"8.0") ? kScreen_Height : kScreen_Width)     // 横屏时的高度
//包含热点栏（如有）高度，标准高度为20pt，当有个人热点连接时，高度为40pt。
#define KSTATUSBAR_HEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)

//定义设备
#define kDevice_iPad ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//版本号
//#define kSystem_Version [[[UIDevice currentDevice] systemVersion] floatValue]

#define kSystem_Version_Equal_To(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define kSystem_Version_Greater_Than(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define kSystem_Version_Greater_Than_Or_Equal_To(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kSystem_Version_Less_Than(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kSystem_Version_Less_Than_Or_Equal_To(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//width & height
#define kNavigationBarHeight                    44.0f   //导航条高度
#define kToolBarHeight                          44.0f   //工具栏高度
#define kNavi_StatusBarHeight (kNavigationBarHeight + kStatusBarHeight)
#define kTabBarHeight                           (iPhoneX ? 83.0f : 49.0f)   //tabbar高度
#define kTabBarRealHeight                       49.0f                       // tabbar真实高度
#define kStatusBarHeight                        (iPhoneX ? 44.0f : 20.0f)   //iPhone状态栏高度
#define kTabBarBottomMargin                     (iPhoneX ? 34.0f : 0.0f)   //iPhoneX tabbar 下面操作区的高度
#define KSafeAreaTopMargin                      (kNavigationBarHeight + kStatusBarHeight)
#define KKeyBoardBottomMargin                   (iPhoneX ? 83.0f : 0.0f)   //键盘底部的 margin
#define kPickViewHeight                         216.0f  //pickview高度
#define kKeyBoardHeight                         (getAutoSize(220.0f) + KKeyBoardBottomMargin) //自定义数字键盘的高度
#define kDownButton_Width                       60.0f   //键盘消失按钮的宽
#define kDownButton_Height                      38.0f   //键盘消失按钮的高
#define kHangQingPad_Height (kSystem_Version_Less_Than(@"7.0") ? 1.0f : 0.5f) //行情首页、列表等界面在块与块之间有条缝隙、此缝隙的高


#define kHQMainPad_Width     1.0f                       //行情首页 (中信建投)

#define kTopHeight_Ios7    (kSystem_Version_Less_Than(@"7.0") ? 0.0f : kStatusBarHeight + kNavBarHeight)  //ios7之上或之下坐标起始位置

//#define kBASESCREENHEIGHT 480.0f    //以iPhone 4屏size做为基准
//#define kBASESCREENWIDTH  320.0f
#define kBASESCREENHEIGHT 667.0f    //以iPhone6屏size做为基准
#define kBASESCREENWIDTH  375.0f

#define kBaseScreenHeight_Hor   (kSystem_Version_Less_Than(@"8.0") ? kBASESCREENHEIGHT : kBASESCREENWIDTH)    // 横屏时的高度
#define kBaseScreenWidth_Hor    (kSystem_Version_Less_Than(@"8.0") ? kBASESCREENWIDTH : kBASESCREENHEIGHT)     // 横屏时的宽度

#define kWidthScale_Hor         (kScreen_Width_Hor / kBaseScreenWidth_Hor) // 当前屏幕的宽度/基准宽度
#define kHeightScale_Hor         (kScreen_Height_Hor / kBaseScreenHeight_Hor) // 当前屏幕的高度/基准高度

// 屏幕宽高适配比例（X 上如果小于6的比例，强制为6的）
#define kAutoSizeScaleX_ (kScreen_Width/kBASESCREENWIDTH < 1.0f ? 1.0f : kScreen_Width/kBASESCREENWIDTH)      //竖屏_X
#define kAutoSizeScale_Hor_X (kScreen_Height/kBASESCREENWIDTH < 1.0f ? 1.0f : kScreen_Height/kBASESCREENWIDTH)//横屏_X
//#define kAutoSizeScaleX_ kScreen_Width/kBASESCREENWIDTH      //竖屏_X
//#define kAutoSizeScale_Hor_X kScreen_Height/kBASESCREENWIDTH //横屏_X

#define kAutoSizeScaleY_ kScreen_Height/kBASESCREENHEIGHT    // Y
#define getAutoSize(key) ((NSInteger)(kAutoSizeScaleX_ * key))     //竖屏
#define getAutoSize_Y(key) (kAutoSizeScaleY_ * key)          // Y 竖屏
#define getAutoSize_Hor(key) (kAutoSizeScale_Hor_X * key)    //横屏
#define getAutoDelSize(key) (key / kAutoSizeScaleX_)
#define getAutoSize_Hor_FSView(key) ((kScreen_Height/kBASESCREENWIDTH) * key)    //分时K线横屏 以6为基准，进行等比例缩放。


//内容的高度（除了状态栏、导航栏、底部菜单栏）
#define kContentView_Height kScreen_Height - (KSTATUSBAR_HEIGHT == 40.0f ? 20 + kStatusBarHeight : kStatusBarHeight) - kNavigationBarHeight - kTabBarHeight


#define kCurrAppBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //当前系统内部开发版本号(build)
#define kCurrAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] //当前系统发布版本号(version)
#define kCurrAppName [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]      //当前app的名称


#define kSharedAppDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])   //项目AppDelegate

//设备判断
#define iPhone4         (kScreen_Width == 320.0f && kScreen_Height == 480.0f ? YES : NO)
#define iPhone5         (kScreen_Width == 320.0f && kScreen_Height == 568.0f ? YES : NO)
#define iPhone6         (kScreen_Width == 375.0f && kScreen_Height == 667.0f ? YES : NO)
#define iPhone6Plus     (kScreen_Width == 414.0f && kScreen_Height == 736.0f ? YES : NO)
#define iPhone4_5       (kScreen_Width == 320.0f && kAutoSizeScaleX_ == 1.0f ? YES : NO)
#define iPhoneX         (kScreen_Width == 375.0f && kScreen_Height == 812.0f ? YES : NO)

//获取本地化的字符串描述---英语或汉语
#ifndef getString
#define kTableName @"Localizable file name"
#define getString(key) [[KDS_LanguageManager bundle] localizedStringForKey:(key) value:@"" table:([[[NSBundle mainBundle] infoDictionary] objectForKey:kTableName])]
//#define getString(x) NSLocalizedStringFromTable(x, [[[NSBundle mainBundle] infoDictionary] objectForKey:kTableName], nil)
#endif

#define kSuperUser      @"KDS888"           // 超级用户(服务器地址)
#define kErrorLog       @"kkddss"           // 运行日志
#define kAPITest        @"KDSAPI"           // 协议测试

#define kGetYZMMaxTimeCount                 60      //获取验证码超时的时间


#define kAlertViewOfViewController_tag  200001 //每个界面第一个UIAlertView的tag，之后的在此基础上+1就行

#define KX_MAX_COUNT        186        //K线最大数据个数
#define KX_MAX_COUNT_HISTORY  90       //K线最大数据个数 请求历史数据
#define STOCK_COUNT_ONCE    100        //一次请求的股票数目
#define KX_MAX_HISTORY_COUNT       120        //有历史K线(第一次请求的条数)
#define HISTORY_ATUO_REQUEST    10       //有历史K线自动刷新请求的条数（横屏）

//K线周期
#define KX_1MIN				0x100			//1分钟K线
#define KX_5MIN				0x101			//5分钟K线
#define KX_15MIN			0x103			//15分钟K线
#define KX_30MIN			0x106			//30分钟K线
#define KX_60MIN			0x10c			//60分钟K线
#define KX_DAY				0x201			//日K线
#define KX_WEEK				0x301			//周K线
#define KX_MONTH			0x401			//月K线
#define KX_QUARTER			0x403			//季K线
#define KX_HALFYEAR			0x406			//半年K线
#define KX_YEAR				0x40c			//年K线

//排序类型定义
#define PX_NONE				0				//不排序
#define PX_CODE				1				//代码
#define PX_ZRSP				2				//昨收
#define PX_ZGCJ				3				//最高
#define PX_ZDCJ				4				//最低
#define PX_ZJCJ				5				//最新
#define PX_CJSL				6				//成交数量
#define PX_CJJE				7				//成交金额
#define PX_ZDF				8				//涨跌幅
#define PX_ZF				9				//震幅
#define PX_HS				10				//换手率
#define PX_SYL				11				//市盈率
#define PX_WB				12				//委比
#define PX_LB				13				//量比
#define PX_ZS				14				//涨速
#define PX_JRKP             15              //今日开盘
#define PX_ZD               16              //涨跌
#define PX_Buy              17              //买
#define PX_Sell             18              //卖
#define PX_CC               19              //持仓
#define PX_LZG_ZDF          20              //板块领涨股涨跌幅
#define PX_QQGZName         21              //全球股指的名称排序（相当于不排序）
#define PX_BuyVol           22              //买量
#define PX_SellVol          23              //卖量

//市场类型
#define MT_SHENZHEN			1				//深圳交易所
#define MT_SHANGHAI			2				//上海交易所
#define MT_SS				3				//深圳交易所+上海交易所
#define MT_SANBAN			4				//三板市场
#define MT_HONGKONG			5				//香港交易所
#define MT_B2H              6               //B转H市场
#define MT_CSE				7				//深圳交易所+上海交易所+三板市场（全市场）
#define MT_EARTH			8				//全球指数
#define MT_SH_QQ            9               //上海个股期权
#define MT_SH_QH			17				//上海商品期货交易所
#define MT_DL_QH			18				//大连商品期货交易所
#define MT_ZZ_QH			20				//郑州商品期货交易所
#define MT_ZQ_QH			24				//中国金融期货交易所(中金所)
#define MT_ZG_QH			31				//上海期货+大连期货+郑州期货+中金所
#define MT_HONGKONG_SGT     32				//香港交易所深港通
#define MT_HONGKONG_GGT     33				//香港交易所沪港通


//商品代码类型
#define CT_UNKNOWN			0				//未知
#define CT_STOCKA			1				//A股
#define CT_STOCKB			2				//B股
#define CT_FUND				4				//基金
#define CT_QZ				8				//权证
#define CT_INDEX			16				//指数
#define CT_BOND				32				//债券
#define CT_GZHG				33				//国债回购
#define CT_HK_HS			64				//恒生指数
#define CT_CYB				128				//创业板
#define CT_ZXB				256				//中小板
#define CT_HK_MAIN_BOARD	257				//港股主板
#define CT_QQINDEX			258				//全球指数
#define CT_FOREIGN          259             //外汇

#define CT_SBHQ             512             //三板行情,所有股转
#define ST_LWTS             513             //两网及退市
#define ST_XYZR             514             //协议转让
#define ST_ZSZR             515             //做市转让
#define ST_JJZR             516             //竞价转让
#define ST_HGT              517             //沪港通
#define ST_SGT              529             //深港通

#define ST_CFG              518             //成分股
#define ST_SHOP             519             //上海个股期权

#define ST_GZ_JCC           526             //股转基础层
#define ST_GZ_CXC           527             //股转创新层

#define CT_NEWSTOCK			1024			//新股
#define CT_SB				1025			//三板行情
#define CT_AB				1026			//AB股对照
#define CT_AH				1027			//AH股对照
#define CT_LOF				1028			//LOF基金板块
#define CT_ETF				1029			//ETF基金板块
#define CT_BK				1030			//板块管理
#define CT_TSZLB            2048            //退市整理板
#define CT_B2H              4096            //B转H股
#define CT_STG              8192            //ST,*ST股

//排序方向
#define PXDirect_None       -1              //无序
#define PXDirect_Up         0               //升序
#define PXDirect_Down       1               //降序

//全球指数区域划分
#define QQZS_Special        0               //四个重点指数：道琼工业、NASDAQ、S&P 500、香港恒生
#define QQZS_Asia           1               //亚洲指数
#define QQZS_Europe         2               //欧洲指数
#define QQZS_America        3               //美洲指数
#define QQZS_World          4               //全球指数
#define QQZS_Forex          5               //全球外汇
#define QQZS_Goods          6               //国际商品



//＊＊＊＊＊＊＊＊＊＊＊交易模块宏＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊//
//买卖类别
#define kTRADE_CHARTB                       @"B"   //买卖方向为买入
#define kTRADE_CHARTS                       @"S"   //买卖方向为卖出
#define kTRADE_CHARTP                       @"P"   //新股申购

//权证行权
#define kTRADE_CHART07                      @"7"   //权证行权

//转股回售
#define kTRADE_CHARTG                       @"G"  //可转债转股
#define kTRADE_CHARTH                       @"H"  //转债回售

//要约收购
#define kTRADE_CHARTY                       @"Y"  //要约收购
#define kTRADE_CHARTE                       @"E"  //要约解除

//债券回购
#define kTRADE_CHARZYRK                     @"n"  //质押入库
#define kTRADE_CHARZYCK                     @"p"  //质押出库

//报价转让－意向
#define kTRADE_CHARTHB                      @"HB"  //意向委托买进
#define kTRADE_CHARTHS                      @"HS"  //意向委托卖出
#define kTRADE_CHART1B                      @"1B"  //成交确认买进
#define kTRADE_CHART1S                      @"1S"  //成交确认卖出
#define kTRADE_CHARTOB                      @"OB"  //定价买进
#define kTRADE_CHARTOS                      @"OS"  //定价卖出

//港股通（沪港通）
#define kTRADE_CHART2B                      @"2B"  //竞价限价买入
#define kTRADE_CHART2S                      @"2S"  //竞价限价卖出
#define kTRADE_CHART3B                      @"3B"  //增强限价买入
#define kTRADE_CHART3S                      @"3S"  //增强限价卖出
#define kTRADE_CHART4S                      @"4S"  //零股限价卖出



//融资融券
#define kTRADE_DBPMR                        @"BD"   //担保品买入
#define kTRADE_DBPMC                        @"SD"   //担保品卖出
#define kTRADE_DBPZR                        @"BZ"   //担保品转入
#define kTRADE_DBPZC                        @"SZ"   //提保品转出
#define kTRADE_RZMR                         @"BR"   //融资买入
#define kTRADE_RQMC                         @"SR"   //融券卖出
#define kTRADE_MQHK                         @"SQ"   //卖券还款
#define kTRADE_MQHQ                         @"BQ"   //买券还券
#define kTRADE_ZJHQ                         @"PQ"   //直接还券

#define KTRADE_YZZR                        @"CR"    //银证转入
#define KTRADE_YZZC                        @"QC"    //银证转出
#define KTRADE_YECX                        @"YE"    //余额查询

//转融通
#define kTRADE_CJ                           @"CJ"   //转融通出借
#define kTRADE_YDRZSQ                       @"JZ"   //约定融资申请
#define kTRADE_YDRQSQ                       @"JQ"   //约定融券申请

//报价回购
#define kTRADE_BJHGMR                       @"BH"   //报价回购买入

#define KZERO8                              @"0"
#define KONE08                              @"1"
#define KTWO08                              @"2"
#define KTHREE08                            @"3"
#define KTHREE04                            @"4"
#define KFIVE08                             @"5"
#define KSIX08                              @"6"

//LOF
#define kLOF_CF                             @"85"    //基金分拆
#define kLOF_HB                             @"86"    //基金合并

//ETF
#define kETF_SWSG                           @"82"    //ETF实物申购
#define kETF_SWSH                           @"84"    //ETF实物赎回
#define kETF_SWCZ                           @"89"    //ETF实物冲账
#define kETF_KJSG                           @"90"    //跨境ETF申购
#define kETF_KJSH                           @"91"    //跨境ETF赎回
#define kETF_SG                             @"1"     //ETF申购
#define kETF_SH                             @"2"     //ETF赎回

//货币基金
#define kHBJJ_SG                            @"3"     //货币基金申购
#define kHBJJ_SH                            @"4"     //货币基金赎回

//债券回购 add by hhx 2013.09.02
#define kZQHG_ZHG                           @"ZH"     //正回购
#define kZQHG_NHG                           @"NH"     //逆回购



//股份转让
#define kTRADE_MMLB_GFZR_XJMR                    @"1b"  //两网退市/做市限价买入
#define kTRADE_MMLB_GFZR_XJMC                    @"1s"  //两网退市/做市限价卖出
#define kTRADE_MMLB_GFZR_DJMR                    @"1e"  //协议定价买入
#define kTRADE_MMLB_GFZR_DJMC                    @"1f"  //协议定价卖出
#define kTRADE_MMLB_GFZR_CJQRMR                  @"1g"  //协议成交确认买入
#define kTRADE_MMLB_GFZR_CJQRMC                  @"1h"  //协议成交确认卖出
#define kTRADE_MMLB_GFZR_HBQRMR                  @"1j"  //协议互报成交确认买入
#define kTRADE_MMLB_GFZR_HBQRMC                  @"1k"  //协议互报成交确认卖出

#define kGGXQ_F10UrlIPAndPort       @"http://113.78.134.108:8088"   // 个股详情F10ip地址

//json协议的错误代码
#define kErrCode_Ok         @"0"          //成功

// 零值的替代字符
#define kNullStr            @"--"

//板块代码
#define BKCode_SHANGHAI     @"sh#000001"      //上证指数
#define BKCode_SHANZHEN     @"sz#399001"      //深圳指数
#define BKCode_CHUANGYE     @"sz#399006"      //创业指数

#define kCookiesArrayData      @"cookiesArrayData.json"   // cookie转成的数据流
#define kCookiesStringData     @"cookiesStringData.json"  // cookie转成的数据流

#define kUserIdKey                          @"user_id"
#define kAccess_token                       @"access_token"

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#endif

