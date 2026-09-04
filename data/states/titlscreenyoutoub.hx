import Date;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.menus.MainMenuState;

// ============================================================
// STATES
// ============================================================

var STATE_BOOT:Int = 0;
var STATE_LOGIN:Int = 1;
var STATE_DESKTOP:Int = 2;
var STATE_YOUTUBE:Int = 3;
var STATE_HORROR:Int = 4;
var STATE_PC:Int = 5;
var STATE_RECYCLE:Int = 6;
var STATE_SETTINGS:Int = 7;

var currentState:Int = STATE_BOOT;

// ============================================================
// GROUPS
// ============================================================

var desktopGroup:FlxGroup;
var taskbarGroup:FlxGroup;
var windowGroup:FlxGroup;
var effectGroup:FlxGroup;
var menuGroup:FlxGroup;

// ============================================================
// DESKTOP
// ============================================================

var desktopBackground:FlxSprite;
var desktopGlow1:FlxSprite;
var desktopGlow2:FlxSprite;

var youtubeIcon:FlxSprite;
var youtubeText:FlxText;

var pcIcon:FlxText;
var pcText:FlxText;

var recycleIcon:FlxText;
var recycleText:FlxText;

var fakeFileIcon:FlxText;
var fakeFileText:FlxText;
var fakeFileExists:Bool = false;

var selectedIcon:String = "";
var draggingYoutube:Bool = false;
var dragOffsetX:Float = 0;
var dragOffsetY:Float = 0;

var lastClickTime:Float = 0;
var lastClickIcon:String = "";

// ============================================================
// TASKBAR
// ============================================================

var taskbar:FlxSprite;
var taskbarTopLine:FlxSprite;

var startButton:FlxSprite;
var startSymbol:FlxText;

var searchBox:FlxSprite;
var searchText:FlxText;

var taskIcon1:FlxSprite;
var taskIcon2:FlxSprite;
var taskIcon3:FlxSprite;

var clockText:FlxText;
var dateText:FlxText;

var volumeText:FlxText;
var showDesktopButton:FlxSprite;

var volumeLevel:Int = 75;
var muted:Bool = false;

// ============================================================
// START MENU
// ============================================================

var startPanel:FlxSprite;
var startTitle:FlxText;
var startYouTube:FlxText;
var startPC:FlxText;
var startRecycle:FlxText;
var startSettings:FlxText;
var startRefresh:FlxText;
var startPower:FlxText;

// ============================================================
// SEARCH
// ============================================================

var searchPanel:FlxSprite;
var searchTitle:FlxText;
var searchResult:FlxText;

// ============================================================
// CONTEXT MENU
// ============================================================

var contextPanel:FlxSprite;
var contextRefresh:FlxText;
var contextNew:FlxText;
var contextDisplay:FlxText;
var contextPersonalize:FlxText;

// ============================================================
// SETTINGS
// ============================================================

var settingsPanel:FlxSprite;
var settingsTitle:FlxText;
var settingsVolume:FlxText;
var settingsMute:FlxText;
var settingsWallpaper:FlxText;
var settingsClose:FlxSprite;
var settingsCloseText:FlxText;

var personalizationIndex:Int = 0;

// ============================================================
// NOTIFICATIONS
// ============================================================

var notificationPanel:FlxSprite;
var notificationTitle:FlxText;
var notificationText:FlxText;

// ============================================================
// LOGIN
// ============================================================

var loginBackground:FlxSprite;
var loginAvatar:FlxSprite;
var loginName:FlxText;
var loginWelcome:FlxText;
var loginHint:FlxText;

// ============================================================
// BOOT
// ============================================================

var bootLogo:FlxText;
var bootText:FlxText;

// ============================================================
// WINDOWS
// ============================================================

var youtubeWindow:FlxSprite;
var youtubeTitleBar:FlxSprite;
var youtubeTitle:FlxText;
var youtubeContent:FlxSprite;

var pcWindow:FlxSprite;
var pcTitleBar:FlxSprite;
var pcTitle:FlxText;
var pcContent:FlxText;

var recycleWindow:FlxSprite;
var recycleTitleBar:FlxSprite;
var recycleTitle:FlxText;
var recycleContent:FlxText;

var closeButton:FlxSprite;
var closeText:FlxText;

var minimizeButton:FlxSprite;
var minimizeText:FlxText;

var messageText:FlxText;

var windowOpen:String = "";
var windowMinimized:Bool = false;

var draggingWindow:Bool = false;
var draggedWindow:String = "";
var windowDragOffsetX:Float = 0;
var windowDragOffsetY:Float = 0;

var clickCount:Int = 0;
var transitioning:Bool = false;

// ============================================================
// HORROR
// ============================================================

var horrorOverlay:FlxSprite;
var horrorText:FlxText;

var glitchTimer:FlxTimer;
var horrorTimer:FlxTimer;
var mainMenuTimer:FlxTimer;

var randomChars:Array<String> = [
	"A","B","C","D","E","F","G","H","I","J",
	"K","L","M","N","O","P","Q","R","S","T",
	"U","V","W","X","Y","Z",
	"0","1","2","3","4","5","6","7","8","9",
	"/","\\","_","-","#","@","%","!","?"
];

// ============================================================
// CREATE
// ============================================================

function create()
{
	currentState = STATE_BOOT;

	clickCount = 0;
	transitioning = false;

	FlxG.mouse.visible = true;

	desktopGroup = new FlxGroup();
	taskbarGroup = new FlxGroup();
	windowGroup = new FlxGroup();
	effectGroup = new FlxGroup();
	menuGroup = new FlxGroup();

	add(desktopGroup);
	add(taskbarGroup);
	add(windowGroup);
	add(effectGroup);
	add(menuGroup);

	startBoot();
}

// ============================================================
// BOOT
// ============================================================

function startBoot()
{
	currentState = STATE_BOOT;

	bootLogo = new FlxText(
		0,
		FlxG.height * 0.39,
		FlxG.width,
		"FUNKIN",
		46
	);

	bootLogo.setFormat(
		null,
		46,
		FlxColor.WHITE,
		"CENTER"
	);

	bootLogo.alpha = 0;
	add(bootLogo);

	bootText = new FlxText(
		0,
		FlxG.height * 0.53,
		FlxG.width,
		"Starting...",
		17
	);

	bootText.setFormat(
		null,
		17,
		FlxColor.fromRGB(180,180,180),
		"CENTER"
	);

	bootText.alpha = 0;
	add(bootText);

	FlxTween.tween(
		bootLogo,
		{alpha:1},
		1
	);

	FlxTween.tween(
		bootText,
		{alpha:1},
		1,
		{startDelay:0.5}
	);

	new FlxTimer().start(
		3,
		function(tmr)
		{
			startLogin();
		}
	);
}

// ============================================================
// LOGIN
// ============================================================

function startLogin()
{
	if (transitioning)
		return;

	currentState = STATE_LOGIN;

	if (bootLogo != null)
		FlxTween.tween(bootLogo,{alpha:0},0.4);

	if (bootText != null)
		FlxTween.tween(bootText,{alpha:0},0.4);

	loginBackground = new FlxSprite();

	loginBackground.makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.fromRGB(17,22,32)
	);

	loginBackground.alpha = 0;
	add(loginBackground);

	loginAvatar = new FlxSprite(
		FlxG.width / 2 - 55,
		FlxG.height * 0.25
	);

	loginAvatar.makeGraphic(
		110,
		110,
		FlxColor.fromRGB(70,75,88)
	);

	loginAvatar.alpha = 0;
	add(loginAvatar);

	loginName = new FlxText(
		0,
		FlxG.height * 0.46,
		FlxG.width,
		"FUNKIN USER",
		27
	);

	loginName.setFormat(
		null,
		27,
		FlxColor.WHITE,
		"CENTER"
	);

	loginName.alpha = 0;
	add(loginName);

	loginWelcome = new FlxText(
		0,
		FlxG.height * 0.52,
		FlxG.width,
		"Welcome",
		19
	);

	loginWelcome.setFormat(
		null,
		19,
		FlxColor.fromRGB(220,220,220),
		"CENTER"
	);

	loginWelcome.alpha = 0;
	add(loginWelcome);

	loginHint = new FlxText(
		0,
		FlxG.height * 0.72,
		FlxG.width,
		"Press ENTER to continue",
		15
	);

	loginHint.setFormat(
		null,
		15,
		FlxColor.fromRGB(160,160,160),
		"CENTER"
	);

	loginHint.alpha = 0;
	add(loginHint);

	FlxTween.tween(loginBackground,{alpha:1},0.7);
	FlxTween.tween(loginAvatar,{alpha:1},0.7);
	FlxTween.tween(loginName,{alpha:1},0.7,{startDelay:0.2});
	FlxTween.tween(loginWelcome,{alpha:1},0.7,{startDelay:0.4});
	FlxTween.tween(loginHint,{alpha:1},0.7,{startDelay:0.7});

	// دخول تلقائي بعد 3.5 ثانية
	new FlxTimer().start(
		3.5,
		function(tmr)
		{
			if (currentState == STATE_LOGIN)
				enterDesktop();
		}
	);
}

// ============================================================
// ENTER DESKTOP
// ============================================================

function enterDesktop()
{
	if (currentState == STATE_DESKTOP)
		return;

	currentState = STATE_DESKTOP;

	removeLogin();
	createDesktop();
}

// ============================================================
// REMOVE LOGIN
// ============================================================

function removeLogin()
{
	if (loginBackground != null)
	{
		remove(loginBackground);
		loginBackground.destroy();
		loginBackground = null;
	}

	if (loginAvatar != null)
	{
		remove(loginAvatar);
		loginAvatar.destroy();
		loginAvatar = null;
	}

	if (loginName != null)
	{
		remove(loginName);
		loginName.destroy();
		loginName = null;
	}

	if (loginWelcome != null)
	{
		remove(loginWelcome);
		loginWelcome.destroy();
		loginWelcome = null;
	}

	if (loginHint != null)
	{
		remove(loginHint);
		loginHint.destroy();
		loginHint = null;
	}
}

// ============================================================
// DESKTOP
// ============================================================

function createDesktop()
{
	desktopBackground = new FlxSprite();

	desktopBackground.makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.fromRGB(10,14,22)
	);

	desktopGroup.add(desktopBackground);

	desktopGlow1 = new FlxSprite(
		FlxG.width * 0.12,
		FlxG.height * 0.10
	);

	desktopGlow1.makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.fromRGB(24,45,75)
	);

	desktopGlow1.alpha = 0.20;
	desktopGroup.add(desktopGlow1);

	desktopGlow2 = new FlxSprite(
		-FlxG.width * 0.2,
		FlxG.height * 0.3
	);

	desktopGlow2.makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.fromRGB(45,25,70)
	);

	desktopGlow2.alpha = 0.10;
	desktopGroup.add(desktopGlow2);

	createDesktopIcons();
	createTaskbar();
}

// ============================================================
// DESKTOP ICONS
// ============================================================

function createDesktopIcons()
{
	youtubeIcon = new FlxSprite();

	try
	{
		youtubeIcon.loadGraphic(
			Paths.image("desktop/youtube")
		);

		youtubeIcon.updateHitbox();
	}
	catch(e:Dynamic)
	{
		youtubeIcon.makeGraphic(
			90,
			60,
			FlxColor.fromRGB(220,0,0)
		);
	}

	youtubeIcon.x = 50;
	youtubeIcon.y = 55;

	desktopGroup.add(youtubeIcon);

	youtubeText = new FlxText(
		35,
		youtubeIcon.y + youtubeIcon.height + 5,
		120,
		"YouTube",
		15
	);

	youtubeText.setFormat(
		null,
		15,
		FlxColor.WHITE,
		"CENTER"
	);

	desktopGroup.add(youtubeText);

	pcIcon = new FlxText(
		50,
		190,
		90,
		"▣",
		42
	);

	pcIcon.setFormat(
		null,
		42,
		FlxColor.WHITE,
		"CENTER"
	);

	desktopGroup.add(pcIcon);

	pcText = new FlxText(
		35,
		240,
		120,
		"This PC",
		15
	);

	pcText.setFormat(
		null,
		15,
		FlxColor.WHITE,
		"CENTER"
	);

	desktopGroup.add(pcText);

	recycleIcon = new FlxText(
		50,
		300,
		90,
		"♜",
		40
	);

	recycleIcon.setFormat(
		null,
		40,
		FlxColor.fromRGB(200,205,215),
		"CENTER"
	);

	desktopGroup.add(recycleIcon);

	recycleText = new FlxText(
		35,
		350,
		120,
		"Recycle Bin",
		15
	);

	recycleText.setFormat(
		null,
		15,
		FlxColor.WHITE,
		"CENTER"
	);

	desktopGroup.add(recycleText);
}

// ============================================================
// TASKBAR
// ============================================================

function createTaskbar()
{
	var taskbarHeight:Int = 58;

	taskbar = new FlxSprite(
		0,
		FlxG.height - taskbarHeight
	);

	taskbar.makeGraphic(
		FlxG.width,
		taskbarHeight,
		FlxColor.fromRGB(24,28,38)
	);

	taskbar.alpha = 0.97;
	taskbarGroup.add(taskbar);

	taskbarTopLine = new FlxSprite(
		0,
		FlxG.height - taskbarHeight
	);

	taskbarTopLine.makeGraphic(
		FlxG.width,
		1,
		FlxColor.fromRGB(70,75,90)
	);

	taskbarGroup.add(taskbarTopLine);

	startButton = new FlxSprite(
		FlxG.width / 2 - 150,
		FlxG.height - 47
	);

	startButton.makeGraphic(
		38,
		38,
		FlxColor.fromRGB(35,40,52)
	);

	taskbarGroup.add(startButton);

	startSymbol = new FlxText(
		startButton.x,
		startButton.y + 7,
		38,
		"⊞",
		23
	);

	startSymbol.setFormat(
		null,
		23,
		FlxColor.WHITE,
		"CENTER"
	);

	taskbarGroup.add(startSymbol);

	searchBox = new FlxSprite(
		FlxG.width / 2 - 105,
		FlxG.height - 47
	);

	searchBox.makeGraphic(
		105,
		38,
		FlxColor.fromRGB(35,40,52)
	);

	taskbarGroup.add(searchBox);

	searchText = new FlxText(
		searchBox.x + 10,
		searchBox.y + 10,
		90,
		"Search",
		13
	);

	searchText.setFormat(
		null,
		13,
		FlxColor.fromRGB(165,170,180),
		"LEFT"
	);

	taskbarGroup.add(searchText);

	taskIcon1 = createTaskIcon(
		FlxG.width / 2 + 20,
		FlxColor.fromRGB(55,60,75)
	);

	taskIcon2 = createTaskIcon(
		FlxG.width / 2 + 65,
		FlxColor.fromRGB(55,60,75)
	);

	taskIcon3 = createTaskIcon(
		FlxG.width / 2 + 110,
		FlxColor.fromRGB(55,60,75)
	);

	volumeText = new FlxText(
		FlxG.width - 170,
		FlxG.height - 43,
		50,
		"75%",
		11
	);

	volumeText.setFormat(
		null,
		11,
		FlxColor.WHITE,
		"RIGHT"
	);

	taskbarGroup.add(volumeText);

	clockText = new FlxText(
		FlxG.width - 115,
		FlxG.height - 45,
		105,
		"",
		13
	);

	clockText.setFormat(
		null,
		13,
		FlxColor.WHITE,
		"RIGHT"
	);

	taskbarGroup.add(clockText);

	dateText = new FlxText(
		FlxG.width - 115,
		FlxG.height - 26,
		105,
		"",
		11
	);

	dateText.setFormat(
		null,
		11,
		FlxColor.fromRGB(170,175,185),
		"RIGHT"
	);

	taskbarGroup.add(dateText);

	showDesktopButton = new FlxSprite(
		FlxG.width - 8,
		FlxG.height - 58
	);

	showDesktopButton.makeGraphic(
		8,
		58,
		FlxColor.fromRGB(60,65,78)
	);

	taskbarGroup.add(showDesktopButton);

	updateClock();
}

function createTaskIcon(
	xPos:Float,
	iconColor:FlxColor
):FlxSprite
{
	var icon = new FlxSprite(
		xPos,
		FlxG.height - 47
	);

	icon.makeGraphic(
		38,
		38,
		iconColor
	);

	taskbarGroup.add(icon);

	return icon;
}

// ============================================================
// CLOCK
// ============================================================

function updateClock()
{
	if (clockText == null)
		return;

	var now = Date.now();

	var hour:Int = now.getHours();
	var minute:Int = now.getMinutes();

	var suffix:String = "AM";

	if (hour >= 12)
		suffix = "PM";

	if (hour > 12)
		hour -= 12;

	if (hour == 0)
		hour = 12;

	var minuteString:String =
		minute < 10 ? "0" + minute : "" + minute;

	clockText.text =
		"" + hour + ":" +
		minuteString + " " +
		suffix;

	var day:Int = now.getDate();
	var month:Int = now.getMonth() + 1;
	var year:Int = now.getFullYear();

	var d:String =
		day < 10 ? "0" + day : "" + day;

	var m:String =
		month < 10 ? "0" + month : "" + month;

	dateText.text =
		m + "/" + d + "/" + year;

	if (volumeText != null)
		volumeText.text =
			muted ? "MUTE" : volumeLevel + "%";
}

// ============================================================
// UPDATE
// ============================================================

function update(elapsed:Float)
{
	updateClock();

	if (currentState == STATE_LOGIN)
	{
		if (FlxG.keys.justPressed.ENTER ||
			FlxG.keys.justPressed.SPACE)
		{
			enterDesktop();
			return;
		}
	}

	if (currentState == STATE_DESKTOP)
		updateDesktop();

	if (currentState == STATE_YOUTUBE)
		updateYouTube();

	if (currentState == STATE_PC)
		updatePCWindow();

	if (currentState == STATE_RECYCLE)
		updateRecycleWindow();

	if (currentState == STATE_SETTINGS)
		updateSettings();

	updateStartMenu();
	updateSearch();
	updateContextMenu();
	updateTaskbarExtra();
}

// ============================================================
// TASKBAR EXTRA
// ============================================================

function updateTaskbarExtra()
{
	if (currentState == STATE_HORROR)
		return;

	if (!FlxG.mouse.justPressed)
		return;

	if (showDesktopButton != null &&
		FlxG.mouse.overlaps(showDesktopButton))
	{
		closeAllWindows();
		hideStartMenu();
		hideSearch();
		hideContextMenu();

		currentState = STATE_DESKTOP;
		return;
	}

	if (clockText != null &&
		FlxG.mouse.x >= FlxG.width - 120 &&
		FlxG.mouse.y >= FlxG.height - 58)
	{
		showNotifications();
		return;
	}

	if (volumeText != null &&
		FlxG.mouse.x >= FlxG.width - 180 &&
		FlxG.mouse.x < FlxG.width - 120 &&
		FlxG.mouse.y >= FlxG.height - 58)
	{
		muted = !muted;
		return;
	}

	if (taskIcon1 != null &&
		FlxG.mouse.overlaps(taskIcon1) &&
		windowOpen == "youtube")
	{
		if (windowMinimized)
			restoreYouTube();

		return;
	}
}

// ============================================================
// DESKTOP
// ============================================================

function updateDesktop()
{
	if (FlxG.mouse.justPressedRight)
	{
		hideStartMenu();
		hideSearch();

		showContextMenu(
			FlxG.mouse.x,
			FlxG.mouse.y
		);

		return;
	}

	if (FlxG.mouse.justPressed)
	{
		hideContextMenu();

		if (startButton != null &&
			FlxG.mouse.overlaps(startButton))
		{
			toggleStartMenu();
			return;
		}

		if (searchBox != null &&
			FlxG.mouse.overlaps(searchBox))
		{
			toggleSearch();
			return;
		}

		if (youtubeIcon != null &&
			FlxG.mouse.overlaps(youtubeIcon))
		{
			handleIconClick("youtube");
			return;
		}

		if (pcIcon != null &&
			FlxG.mouse.x >= pcIcon.x &&
			FlxG.mouse.x <= pcIcon.x + 90 &&
			FlxG.mouse.y >= pcIcon.y &&
			FlxG.mouse.y <= pcIcon.y + 55)
		{
			handleIconClick("pc");
			return;
		}

		if (recycleIcon != null &&
			FlxG.mouse.x >= recycleIcon.x &&
			FlxG.mouse.x <= recycleIcon.x + 90 &&
			FlxG.mouse.y >= recycleIcon.y &&
			FlxG.mouse.y <= recycleIcon.y + 55)
		{
			handleIconClick("recycle");
			return;
		}

		if (fakeFileExists &&
			fakeFileIcon != null &&
			FlxG.mouse.overlaps(fakeFileIcon))
		{
			handleIconClick("file");
			return;
		}

		if (FlxG.mouse.y <
			FlxG.height - 65)
		{
			selectedIcon = "";
		}
	}

	if (draggingYoutube)
	{
		if (FlxG.mouse.pressed)
		{
			youtubeIcon.x =
				FlxG.mouse.x - dragOffsetX;

			youtubeIcon.y =
				FlxG.mouse.y - dragOffsetY;

			youtubeText.x =
				youtubeIcon.x - 15;

			youtubeText.y =
				youtubeIcon.y +
				youtubeIcon.height + 5;
		}
		else
		{
			draggingYoutube = false;
		}
	}

	updateIconSelection();
}

// ============================================================
// ICON CLICK
// ============================================================

function handleIconClick(icon:String)
{
	var currentTime:Float =
		FlxG.game.ticks / 1000;

	selectedIcon = icon;

	if (icon == "youtube")
	{
		draggingYoutube = true;

		dragOffsetX =
			FlxG.mouse.x - youtubeIcon.x;

		dragOffsetY =
			FlxG.mouse.y - youtubeIcon.y;
	}

	if (lastClickIcon == icon &&
		currentTime - lastClickTime < 0.35)
	{
		lastClickIcon = "";
		lastClickTime = 0;

		if (icon == "youtube")
			openYouTube();

		if (icon == "pc")
			openPC();

		if (icon == "recycle")
			openRecycle();

		if (icon == "file")
			openFakeFile();

		return;
	}

	lastClickIcon = icon;
	lastClickTime = currentTime;
}

// ============================================================
// ICON SELECTION
// ============================================================

function updateIconSelection()
{
	if (selectedIcon == "youtube" &&
		youtubeIcon != null)
	{
		youtubeIcon.alpha = 0.75;
	}
	else if (youtubeIcon != null)
	{
		youtubeIcon.alpha = 1;
	}

	if (selectedIcon == "pc" &&
		pcIcon != null)
		pcIcon.color =
			FlxColor.fromRGB(100,170,255);
	else if (pcIcon != null)
		pcIcon.color = FlxColor.WHITE;

	if (selectedIcon == "recycle" &&
		recycleIcon != null)
		recycleIcon.color =
			FlxColor.fromRGB(100,170,255);
	else if (recycleIcon != null)
		recycleIcon.color =
			FlxColor.fromRGB(200,205,215);
}

// ============================================================
// START MENU
// ============================================================

function toggleStartMenu()
{
	if (startPanel != null)
	{
		hideStartMenu();
		return;
	}

	startPanel = new FlxSprite(
		FlxG.width / 2 - 280,
		FlxG.height - 420
	);

	startPanel.makeGraphic(
		560,
		350,
		FlxColor.fromRGB(28,32,44)
	);

	menuGroup.add(startPanel);

	startTitle = makeMenuText(
		"FUNKIN",
		startPanel.x + 25,
		startPanel.y + 20
	);

	startTitle.size = 24;

	startYouTube = makeMenuText(
		"YouTube",
		startPanel.x + 30,
		startPanel.y + 75
	);

	startPC = makeMenuText(
		"This PC",
		startPanel.x + 30,
		startPanel.y + 120
	);

	startRecycle = makeMenuText(
		"Recycle Bin",
		startPanel.x + 30,
		startPanel.y + 165
	);

	startSettings = makeMenuText(
		"Settings",
		startPanel.x + 30,
		startPanel.y + 210
	);

	startRefresh = makeMenuText(
		"Refresh Desktop",
		startPanel.x + 30,
		startPanel.y + 255
	);

	startPower = makeMenuText(
		"Power",
		startPanel.x + 30,
		startPanel.y + 300
	);
}

function makeMenuText(
	text:String,
	x:Float,
	y:Float
):FlxText
{
	var t = new FlxText(
		x,
		y,
		480,
		text,
		17
	);

	t.setFormat(
		null,
		17,
		FlxColor.fromRGB(225,225,230),
		"LEFT"
	);

	menuGroup.add(t);

	return t;
}

// ============================================================
// START MENU UPDATE
// ============================================================

function updateStartMenu()
{
	if (startPanel == null)
		return;

	if (!FlxG.mouse.justPressed)
		return;

	if (startYouTube != null &&
		FlxG.mouse.overlaps(startYouTube))
	{
		hideStartMenu();
		openYouTube();
		return;
	}

	if (startPC != null &&
		FlxG.mouse.overlaps(startPC))
	{
		hideStartMenu();
		openPC();
		return;
	}

	if (startRecycle != null &&
		FlxG.mouse.overlaps(startRecycle))
	{
		hideStartMenu();
		openRecycle();
		return;
	}

	if (startSettings != null &&
		FlxG.mouse.overlaps(startSettings))
	{
		openSettings();
		return;
	}

	if (startRefresh != null &&
		FlxG.mouse.overlaps(startRefresh))
	{
		refreshDesktop();
		return;
	}

	if (startPower != null &&
		FlxG.mouse.overlaps(startPower))
	{
		hideStartMenu();

		new FlxTimer().start(
			0.2,
			function(tmr)
			{
				startLogin();
			}
		);
	}
}

// ============================================================
// HIDE START
// ============================================================

function hideStartMenu()
{
	if (startPanel != null)
	{
		menuGroup.remove(startPanel);
		startPanel.destroy();
		startPanel = null;
	}

	removeMenuText(startTitle);
	removeMenuText(startYouTube);
	removeMenuText(startPC);
	removeMenuText(startRecycle);
	removeMenuText(startSettings);
	removeMenuText(startRefresh);
	removeMenuText(startPower);
}

function removeMenuText(t:FlxText)
{
	if (t != null)
	{
		menuGroup.remove(t);
		t.destroy();
	}
}

// ============================================================
// SEARCH
// ============================================================

function toggleSearch()
{
	if (searchPanel != null)
	{
		hideSearch();
		return;
	}

	searchPanel = new FlxSprite(
		FlxG.width / 2 - 250,
		FlxG.height - 300
	);

	searchPanel.makeGraphic(
		500,
		220,
		FlxColor.fromRGB(28,32,44)
	);

	menuGroup.add(searchPanel);

	searchTitle = new FlxText(
		searchPanel.x + 25,
		searchPanel.y + 25,
		450,
		"Search",
		22
	);

	searchTitle.setFormat(
		null,
		22,
		FlxColor.WHITE,
		"LEFT"
	);

	menuGroup.add(searchTitle);

	searchResult = new FlxText(
		searchPanel.x + 25,
		searchPanel.y + 80,
		450,
		"YouTube\nThis PC\nRecycle Bin\nSettings",
		15
	);

	searchResult.setFormat(
		null,
		15,
		FlxColor.fromRGB(180,185,195),
		"LEFT"
	);

	menuGroup.add(searchResult);
}

function updateSearch()
{
	if (searchPanel == null)
		return;

	if (FlxG.mouse.justPressed)
	{
		if (FlxG.mouse.x < searchPanel.x ||
			FlxG.mouse.x > searchPanel.x + searchPanel.width ||
			FlxG.mouse.y < searchPanel.y ||
			FlxG.mouse.y > searchPanel.y + searchPanel.height)
		{
			hideSearch();
		}
	}
}

function hideSearch()
{
	if (searchPanel != null)
	{
		menuGroup.remove(searchPanel);
		searchPanel.destroy();
		searchPanel = null;
	}

	if (searchTitle != null)
	{
		menuGroup.remove(searchTitle);
		searchTitle.destroy();
		searchTitle = null;
	}

	if (searchResult != null)
	{
		menuGroup.remove(searchResult);
		searchResult.destroy();
		searchResult = null;
	}
}

// ============================================================
// CONTEXT MENU
// ============================================================

function showContextMenu(x:Float,y:Float)
{
	hideContextMenu();

	if (x + 230 > FlxG.width)
		x = FlxG.width - 230;

	if (y + 180 > FlxG.height - 60)
		y = FlxG.height - 240;

	contextPanel = new FlxSprite(x,y);

	contextPanel.makeGraphic(
		230,
		180,
		FlxColor.fromRGB(30,34,45)
	);

	menuGroup.add(contextPanel);

	contextRefresh = makeContextText(
		"Refresh",
		x + 15,
		y + 15
	);

	contextNew = makeContextText(
		"New",
		x + 15,
		y + 50
	);

	contextDisplay = makeContextText(
		"Display settings",
		x + 15,
		y + 85
	);

	contextPersonalize = makeContextText(
		"Personalize",
		x + 15,
		y + 120
	);
}

function updateContextMenu()
{
	if (contextPanel == null)
		return;

	if (!FlxG.mouse.justPressed)
		return;

	if (contextRefresh != null &&
		FlxG.mouse.overlaps(contextRefresh))
	{
		refreshDesktop();
		hideContextMenu();
		return;
	}

	if (contextNew != null &&
		FlxG.mouse.overlaps(contextNew))
	{
		createFakeFile();
		hideContextMenu();
		return;
	}

	if (contextDisplay != null &&
		FlxG.mouse.overlaps(contextDisplay))
	{
		showDisplayInfo();
		hideContextMenu();
		return;
	}

	if (contextPersonalize != null &&
		FlxG.mouse.overlaps(contextPersonalize))
	{
		changeWallpaper();
		hideContextMenu();
		return;
	}

	hideContextMenu();
}

function makeContextText(
	text:String,
	x:Float,
	y:Float
):FlxText
{
	var t = new FlxText(
		x,
		y,
		200,
		text,
		15
	);

	t.setFormat(
		null,
		15,
		FlxColor.WHITE,
		"LEFT"
	);

	menuGroup.add(t);

	return t;
}

function hideContextMenu()
{
	if (contextPanel != null)
	{
		menuGroup.remove(contextPanel);
		contextPanel.destroy();
		contextPanel = null;
	}

	removeContextText(contextRefresh);
	removeContextText(contextNew);
	removeContextText(contextDisplay);
	removeContextText(contextPersonalize);

	contextRefresh = null;
	contextNew = null;
	contextDisplay = null;
	contextPersonalize = null;
}

function removeContextText(t:FlxText)
{
	if (t != null)
	{
		menuGroup.remove(t);
		t.destroy();
	}
}

// ============================================================
// REFRESH / FILE / DISPLAY
// ============================================================

function refreshDesktop()
{
	if (desktopBackground == null)
		return;

	desktopGlow1.alpha = 0;
	desktopGlow2.alpha = 0;

	FlxTween.tween(desktopGlow1,{alpha:0.20},0.35);
	FlxTween.tween(desktopGlow2,{alpha:0.10},0.35);
}

function createFakeFile()
{
	if (fakeFileExists)
		return;

	fakeFileExists = true;

	fakeFileIcon = new FlxText(
		50,
		420,
		90,
		"▤",
		40
	);

	fakeFileIcon.setFormat(
		null,
		40,
		FlxColor.WHITE,
		"CENTER"
	);

	desktopGroup.add(fakeFileIcon);

	fakeFileText = new FlxText(
		35,
		470,
		120,
		"New File.txt",
		14
	);

	fakeFileText.setFormat(
		null,
		14,
		FlxColor.WHITE,
		"CENTER"
	);

	desktopGroup.add(fakeFileText);
}

function openFakeFile()
{
	var popup = new FlxText(
		FlxG.width / 2 - 250,
		FlxG.height / 2 - 50,
		500,
		"New File.txt\n\nThis is a virtual file.",
		20
	);

	popup.setFormat(
		null,
		20,
		FlxColor.WHITE,
		"CENTER"
	);

	effectGroup.add(popup);

	new FlxTimer().start(
		2,
		function(tmr)
		{
			if (popup != null)
			{
				effectGroup.remove(popup);
				popup.destroy();
			}
		}
	);
}

function showDisplayInfo()
{
	var info = new FlxText(
		FlxG.width / 2 - 250,
		FlxG.height / 2 - 50,
		500,
		"Display\n\nResolution: "
		+ FlxG.width + " x " + FlxG.height,
		18
	);

	info.setFormat(
		null,
		18,
		FlxColor.WHITE,
		"CENTER"
	);

	effectGroup.add(info);

	new FlxTimer().start(
		2,
		function(tmr)
		{
			if (info != null)
			{
				effectGroup.remove(info);
				info.destroy();
			}
		}
	);
}

// ============================================================
// WALLPAPER
// ============================================================

function changeWallpaper()
{
	personalizationIndex++;

	if (personalizationIndex > 3)
		personalizationIndex = 0;

	switch(personalizationIndex)
	{
		case 0:
			desktopBackground.makeGraphic(
				FlxG.width,
				FlxG.height,
				FlxColor.fromRGB(10,14,22)
			);

		case 1:
			desktopBackground.makeGraphic(
				FlxG.width,
				FlxG.height,
				FlxColor.fromRGB(10,30,50)
			);

		case 2:
			desktopBackground.makeGraphic(
				FlxG.width,
				FlxG.height,
				FlxColor.fromRGB(35,15,50)
			);

		case 3:
			desktopBackground.makeGraphic(
				FlxG.width,
				FlxG.height,
				FlxColor.fromRGB(25,25,25)
			);
	}
}

// ============================================================
// NOTIFICATIONS
// ============================================================

function showNotifications()
{
	hideNotifications();

	notificationPanel = new FlxSprite(
		FlxG.width - 330,
		FlxG.height - 330
	);

	notificationPanel.makeGraphic(
		310,
		250,
		FlxColor.fromRGB(30,35,47)
	);

	menuGroup.add(notificationPanel);

	notificationTitle = new FlxText(
		notificationPanel.x + 20,
		notificationPanel.y + 20,
		270,
		"Notifications",
		21
	);

	notificationTitle.setFormat(
		null,
		21,
		FlxColor.WHITE,
		"LEFT"
	);

	menuGroup.add(notificationTitle);

	notificationText = new FlxText(
		notificationPanel.x + 20,
		notificationPanel.y + 70,
		270,
		"No new notifications.\n\nFUNKIN SYSTEM\nSystem is running normally.",
		15
	);

	notificationText.setFormat(
		null,
		15,
		FlxColor.fromRGB(190,195,205),
		"LEFT"
	);

	menuGroup.add(notificationText);
}

function hideNotifications()
{
	if (notificationPanel != null)
	{
		menuGroup.remove(notificationPanel);
		notificationPanel.destroy();
		notificationPanel = null;
	}

	if (notificationTitle != null)
	{
		menuGroup.remove(notificationTitle);
		notificationTitle.destroy();
		notificationTitle = null;
	}

	if (notificationText != null)
	{
		menuGroup.remove(notificationText);
		notificationText.destroy();
		notificationText = null;
	}
}

// ============================================================
// YOUTUBE
// ============================================================

function openYouTube()
{
	if (transitioning)
		return;

	hideStartMenu();
	hideSearch();
	hideContextMenu();
	hideNotifications();

	currentState = STATE_YOUTUBE;

	clickCount++;

	createYouTubeWindow();

	switch(clickCount)
	{
		case 1:
			youtubeMessage1();

		case 2:
			youtubeMessage2();
			startSmallGlitch();

		case 3:
			youtubeMessage3();
			startHeavyGlitch();

		default:
			youtubeMessage4();
	}
}

function createYouTubeWindow()
{
	windowOpen = "youtube";
	windowMinimized = false;

	youtubeWindow = new FlxSprite(
		FlxG.width * 0.18,
		FlxG.height * 0.18
	);

	youtubeWindow.makeGraphic(
		Std.int(FlxG.width * 0.64),
		Std.int(FlxG.height * 0.55),
		FlxColor.fromRGB(245,245,248)
	);

	youtubeWindow.alpha = 0;
	windowGroup.add(youtubeWindow);

	youtubeTitleBar = new FlxSprite(
		youtubeWindow.x,
		youtubeWindow.y
	);

	youtubeTitleBar.makeGraphic(
		youtubeWindow.width,
		42,
		FlxColor.fromRGB(32,36,48)
	);

	windowGroup.add(youtubeTitleBar);

	youtubeTitle = new FlxText(
		youtubeWindow.x + 15,
		youtubeWindow.y + 11,
		300,
		"YouTube",
		16
	);

	youtubeTitle.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"LEFT"
	);

	windowGroup.add(youtubeTitle);

	minimizeButton = new FlxSprite(
		youtubeWindow.x + youtubeWindow.width - 84,
		youtubeWindow.y
	);

	minimizeButton.makeGraphic(
		42,
		42,
		FlxColor.fromRGB(32,36,48)
	);

	windowGroup.add(minimizeButton);

	minimizeText = new FlxText(
		minimizeButton.x,
		minimizeButton.y + 8,
		42,
		"_",
		16
	);

	minimizeText.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"CENTER"
	);

	windowGroup.add(minimizeText);

	closeButton = new FlxSprite(
		youtubeWindow.x + youtubeWindow.width - 42,
		youtubeWindow.y
	);

	closeButton.makeGraphic(
		42,
		42,
		FlxColor.fromRGB(32,36,48)
	);

	windowGroup.add(closeButton);

	closeText = new FlxText(
		closeButton.x,
		closeButton.y + 9,
		42,
		"X",
		16
	);

	closeText.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"CENTER"
	);

	windowGroup.add(closeText);

	youtubeContent = new FlxSprite(
		youtubeWindow.x + 20,
		youtubeWindow.y + 70
	);

	youtubeContent.makeGraphic(
		Std.int(youtubeWindow.width - 40),
		Std.int(youtubeWindow.height - 90),
		FlxColor.fromRGB(235,235,240)
	);

	windowGroup.add(youtubeContent);

	FlxTween.tween(
		youtubeWindow,
		{alpha:1},
		0.25,
		{ease:FlxEase.quadOut}
	);
}

function updateYouTube()
{
	if (youtubeWindow == null)
		return;

	updateWindowDrag("youtube");

	if (FlxG.mouse.justPressed)
	{
		if (closeButton != null &&
			FlxG.mouse.overlaps(closeButton))
		{
			closeYouTube();
			return;
		}

		if (minimizeButton != null &&
			FlxG.mouse.overlaps(minimizeButton))
		{
			minimizeYouTube();
			return;
		}
	}
}

function minimizeYouTube()
{
	windowMinimized = true;

	setYouTubeVisible(false);

	currentState = STATE_DESKTOP;
}

function restoreYouTube()
{
	windowMinimized = false;

	setYouTubeVisible(true);

	currentState = STATE_YOUTUBE;
}

function setYouTubeVisible(value:Bool)
{
	if (youtubeWindow != null) youtubeWindow.visible = value;
	if (youtubeTitleBar != null) youtubeTitleBar.visible = value;
	if (youtubeTitle != null) youtubeTitle.visible = value;
	if (youtubeContent != null) youtubeContent.visible = value;
	if (closeButton != null) closeButton.visible = value;
	if (closeText != null) closeText.visible = value;
	if (minimizeButton != null) minimizeButton.visible = value;
	if (minimizeText != null) minimizeText.visible = value;
	if (messageText != null) messageText.visible = value;
}

// ============================================================
// YOUTUBE MESSAGES
// ============================================================

function youtubeMessage1()
{
	showWindowMessage(
		"Are you ready to continue with us?",
		false
	);
}

function youtubeMessage2()
{
	showWindowMessage(
		"Why did you come back?",
		true
	);
}

function youtubeMessage3()
{
	showWindowMessage(
		"You were never supposed to see this.",
		true
	);
}

function youtubeMessage4()
{
	if (transitioning)
		return;

	transitioning = true;

	showWindowMessage(
		"You chose to continue.",
		true
	);

	new FlxTimer().start(
		2,
		function(tmr)
		{
			startHorror();
		}
	);
}

function showWindowMessage(
	text:String,
	glitch:Bool
)
{
	if (messageText != null)
	{
		windowGroup.remove(messageText);
		messageText.destroy();
	}

	messageText = new FlxText(
		youtubeWindow.x + 40,
		youtubeWindow.y + 190,
		youtubeWindow.width - 80,
		text,
		25
	);

	messageText.setFormat(
		null,
		25,
		FlxColor.fromRGB(20,20,25),
		"CENTER"
	);

	messageText.alpha = 0;

	windowGroup.add(messageText);

	FlxTween.tween(
		messageText,
		{alpha:1},
		0.3
	);
}

// ============================================================
// CLOSE YOUTUBE
// ============================================================

function closeYouTube()
{
	if (transitioning)
		return;

	currentState = STATE_DESKTOP;

	clearYouTubeWindow();
}

function clearYouTubeWindow()
{
	if (glitchTimer != null)
	{
		glitchTimer.cancel();
		glitchTimer = null;
	}

	if (youtubeWindow != null)
	{
		windowGroup.remove(youtubeWindow);
		youtubeWindow.destroy();
		youtubeWindow = null;
	}

	if (youtubeTitleBar != null)
	{
		windowGroup.remove(youtubeTitleBar);
		youtubeTitleBar.destroy();
		youtubeTitleBar = null;
	}

	if (youtubeTitle != null)
	{
		windowGroup.remove(youtubeTitle);
		youtubeTitle.destroy();
		youtubeTitle = null;
	}

	if (youtubeContent != null)
	{
		windowGroup.remove(youtubeContent);
		youtubeContent.destroy();
		youtubeContent = null;
	}

	if (closeButton != null)
	{
		windowGroup.remove(closeButton);
		closeButton.destroy();
		closeButton = null;
	}

	if (closeText != null)
	{
		windowGroup.remove(closeText);
		closeText.destroy();
		closeText = null;
	}

	if (minimizeButton != null)
	{
		windowGroup.remove(minimizeButton);
		minimizeButton.destroy();
		minimizeButton = null;
	}

	if (minimizeText != null)
	{
		windowGroup.remove(minimizeText);
		minimizeText.destroy();
		minimizeText = null;
	}

	if (messageText != null)
	{
		windowGroup.remove(messageText);
		messageText.destroy();
		messageText = null;
	}

	windowOpen = "";
	windowMinimized = false;
}

// ============================================================
// PC
// ============================================================

function openPC()
{
	closeAllWindows();

	currentState = STATE_PC;
	windowOpen = "pc";

	pcWindow = new FlxSprite(
		FlxG.width * 0.20,
		FlxG.height * 0.18
	);

	pcWindow.makeGraphic(
		Std.int(FlxG.width * 0.60),
		Std.int(FlxG.height * 0.55),
		FlxColor.fromRGB(238,240,244)
	);

	windowGroup.add(pcWindow);

	pcTitleBar = new FlxSprite(
		pcWindow.x,
		pcWindow.y
	);

	pcTitleBar.makeGraphic(
		pcWindow.width,
		42,
		FlxColor.fromRGB(32,36,48)
	);

	windowGroup.add(pcTitleBar);

	pcTitle = new FlxText(
		pcWindow.x + 15,
		pcWindow.y + 11,
		300,
		"This PC",
		16
	);

	pcTitle.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"LEFT"
	);

	windowGroup.add(pcTitle);

	closeButton = new FlxSprite(
		pcWindow.x + pcWindow.width - 42,
		pcWindow.y
	);

	closeButton.makeGraphic(
		42,
		42,
		FlxColor.fromRGB(32,36,48)
	);

	windowGroup.add(closeButton);

	closeText = new FlxText(
		closeButton.x,
		closeButton.y + 9,
		42,
		"X",
		16
	);

	closeText.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"CENTER"
	);

	windowGroup.add(closeText);

	pcContent = new FlxText(
		pcWindow.x + 40,
		pcWindow.y + 90,
		pcWindow.width - 80,
		"Local Disk (C:)\n\nSystem\nDocuments\nDownloads\nDesktop\n\nFUNKIN SYSTEM",
		20
	);

	pcContent.setFormat(
		null,
		20,
		FlxColor.fromRGB(30,32,38),
		"LEFT"
	);

	windowGroup.add(pcContent);
}

function updatePCWindow()
{
	if (pcWindow == null)
		return;

	updateWindowDrag("pc");

	if (FlxG.mouse.justPressed &&
		closeButton != null &&
		FlxG.mouse.overlaps(closeButton))
	{
		closePC();
	}
}

function closePC()
{
	if (pcWindow != null)
	{
		windowGroup.remove(pcWindow);
		pcWindow.destroy();
		pcWindow = null;
	}

	if (pcTitleBar != null)
	{
		windowGroup.remove(pcTitleBar);
		pcTitleBar.destroy();
		pcTitleBar = null;
	}

	if (pcTitle != null)
	{
		windowGroup.remove(pcTitle);
		pcTitle.destroy();
		pcTitle = null;
	}

	if (pcContent != null)
	{
		windowGroup.remove(pcContent);
		pcContent.destroy();
		pcContent = null;
	}

	if (closeButton != null)
	{
		windowGroup.remove(closeButton);
		closeButton.destroy();
		closeButton = null;
	}

	if (closeText != null)
	{
		windowGroup.remove(closeText);
		closeText.destroy();
		closeText = null;
	}

	currentState = STATE_DESKTOP;
	windowOpen = "";
}

// ============================================================
// RECYCLE BIN
// ============================================================

function openRecycle()
{
	closeAllWindows();

	currentState = STATE_RECYCLE;
	windowOpen = "recycle";

	recycleWindow = new FlxSprite(
		FlxG.width * 0.25,
		FlxG.height * 0.25
	);

	recycleWindow.makeGraphic(
		Std.int(FlxG.width * 0.50),
		Std.int(FlxG.height * 0.40),
		FlxColor.fromRGB(238,240,244)
	);

	windowGroup.add(recycleWindow);

	recycleTitleBar = new FlxSprite(
		recycleWindow.x,
		recycleWindow.y
	);

	recycleTitleBar.makeGraphic(
		recycleWindow.width,
		42,
		FlxColor.fromRGB(32,36,48)
	);

	windowGroup.add(recycleTitleBar);

	recycleTitle = new FlxText(
		recycleWindow.x + 15,
		recycleWindow.y + 11,
		300,
		"Recycle Bin",
		16
	);

	recycleTitle.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"LEFT"
	);

	windowGroup.add(recycleTitle);

	closeButton = new FlxSprite(
		recycleWindow.x + recycleWindow.width - 42,
		recycleWindow.y
	);

	closeButton.makeGraphic(
		42,
		42,
		FlxColor.fromRGB(32,36,48)
	);

	windowGroup.add(closeButton);

	closeText = new FlxText(
		closeButton.x,
		closeButton.y + 9,
		42,
		"X",
		16
	);

	closeText.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"CENTER"
	);

	windowGroup.add(closeText);

	recycleContent = new FlxText(
		recycleWindow.x + 30,
		recycleWindow.y + 100,
		recycleWindow.width - 60,
		"The Recycle Bin is empty.",
		19
	);

	recycleContent.setFormat(
		null,
		19,
		FlxColor.fromRGB(40,42,48),
		"CENTER"
	);

	windowGroup.add(recycleContent);
}

function updateRecycleWindow()
{
	if (recycleWindow == null)
		return;

	updateWindowDrag("recycle");

	if (FlxG.mouse.justPressed &&
		closeButton != null &&
		FlxG.mouse.overlaps(closeButton))
	{
		closeRecycle();
	}
}

function closeRecycle()
{
	if (recycleWindow != null)
	{
		windowGroup.remove(recycleWindow);
		recycleWindow.destroy();
		recycleWindow = null;
	}

	if (recycleTitleBar != null)
	{
		windowGroup.remove(recycleTitleBar);
		recycleTitleBar.destroy();
		recycleTitleBar = null;
	}

	if (recycleTitle != null)
	{
		windowGroup.remove(recycleTitle);
		recycleTitle.destroy();
		recycleTitle = null;
	}

	if (recycleContent != null)
	{
		windowGroup.remove(recycleContent);
		recycleContent.destroy();
		recycleContent = null;
	}

	if (closeButton != null)
	{
		windowGroup.remove(closeButton);
		closeButton.destroy();
		closeButton = null;
	}

	if (closeText != null)
	{
		windowGroup.remove(closeText);
		closeText.destroy();
		closeText = null;
	}

	currentState = STATE_DESKTOP;
	windowOpen = "";
}

// ============================================================
// WINDOW DRAGGING
// ============================================================

function updateWindowDrag(type:String)
{
	var titleBar:FlxSprite = null;
	var win:FlxSprite = null;

	if (type == "youtube")
	{
		titleBar = youtubeTitleBar;
		win = youtubeWindow;
	}

	if (type == "pc")
	{
		titleBar = pcTitleBar;
		win = pcWindow;
	}

	if (type == "recycle")
	{
		titleBar = recycleTitleBar;
		win = recycleWindow;
	}

	if (titleBar == null || win == null)
		return;

	if (FlxG.mouse.justPressed &&
		FlxG.mouse.overlaps(titleBar) &&
		(closeButton == null ||
			!FlxG.mouse.overlaps(closeButton)))
	{
		draggingWindow = true;
		draggedWindow = type;

		windowDragOffsetX =
			FlxG.mouse.x - win.x;

		windowDragOffsetY =
			FlxG.mouse.y - win.y;
	}

	if (draggingWindow &&
		draggedWindow == type)
	{
		if (FlxG.mouse.pressed)
		{
			win.x =
				FlxG.mouse.x - windowDragOffsetX;

			win.y =
				FlxG.mouse.y - windowDragOffsetY;

			moveWindowParts(type);
		}
		else
		{
			draggingWindow = false;
			draggedWindow = "";
		}
	}
}

function moveWindowParts(type:String)
{
	if (type == "youtube")
	{
		var x:Float = youtubeWindow.x;
		var y:Float = youtubeWindow.y;

		youtubeTitleBar.setPosition(x,y);
		youtubeTitle.setPosition(x + 15,y + 11);

		minimizeButton.setPosition(
			x + youtubeWindow.width - 84,
			y
		);

		minimizeText.setPosition(
			minimizeButton.x,
			y + 8
		);

		closeButton.setPosition(
			x + youtubeWindow.width - 42,
			y
		);

		closeText.setPosition(
			closeButton.x,
			y + 9
		);

		youtubeContent.setPosition(
			x + 20,
			y + 70
		);

		if (messageText != null)
		{
			messageText.x = x + 40;
			messageText.y = y + 190;
		}
	}

	if (type == "pc")
	{
		var px:Float = pcWindow.x;
		var py:Float = pcWindow.y;

		pcTitleBar.setPosition(px,py);
		pcTitle.setPosition(px + 15,py + 11);

		closeButton.setPosition(
			px + pcWindow.width - 42,
			py
		);

		closeText.setPosition(
			closeButton.x,
			py + 9
		);

		pcContent.setPosition(
			px + 40,
			py + 90
		);
	}

	if (type == "recycle")
	{
		var rx:Float = recycleWindow.x;
		var ry:Float = recycleWindow.y;

		recycleTitleBar.setPosition(rx,ry);
		recycleTitle.setPosition(rx + 15,ry + 11);

		closeButton.setPosition(
			rx + recycleWindow.width - 42,
			ry
		);

		closeText.setPosition(
			closeButton.x,
			ry + 9
		);

		recycleContent.setPosition(
			rx + 30,
			ry + 100
		);
	}
}

// ============================================================
// SETTINGS
// ============================================================

function openSettings()
{
	hideStartMenu();
	hideSearch();
	hideContextMenu();
	hideNotifications();

	currentState = STATE_SETTINGS;

	settingsPanel = new FlxSprite(
		FlxG.width / 2 - 260,
		FlxG.height / 2 - 190
	);

	settingsPanel.makeGraphic(
		520,
		380,
		FlxColor.fromRGB(35,40,52)
	);

	menuGroup.add(settingsPanel);

	settingsTitle = new FlxText(
		settingsPanel.x + 25,
		settingsPanel.y + 22,
		450,
		"Settings",
		25
	);

	settingsTitle.setFormat(
		null,
		25,
		FlxColor.WHITE,
		"LEFT"
	);

	menuGroup.add(settingsTitle);

	settingsVolume = new FlxText(
		settingsPanel.x + 30,
		settingsPanel.y + 90,
		440,
		"Volume: " + volumeLevel + "%",
		18
	);

	settingsVolume.setFormat(
		null,
		18,
		FlxColor.WHITE,
		"LEFT"
	);

	menuGroup.add(settingsVolume);

	settingsMute = new FlxText(
		settingsPanel.x + 30,
		settingsPanel.y + 140,
		440,
		muted ? "Unmute" : "Mute",
		18
	);

	settingsMute.setFormat(
		null,
		18,
		FlxColor.WHITE,
		"LEFT"
	);

	menuGroup.add(settingsMute);

	settingsWallpaper = new FlxText(
		settingsPanel.x + 30,
		settingsPanel.y + 195,
		440,
		"Change Desktop Background",
		18
	);

	settingsWallpaper.setFormat(
		null,
		18,
		FlxColor.WHITE,
		"LEFT"
	);

	menuGroup.add(settingsWallpaper);

	settingsClose = new FlxSprite(
		settingsPanel.x + settingsPanel.width - 52,
		settingsPanel.y + 10
	);

	settingsClose.makeGraphic(
		42,
		35,
		FlxColor.fromRGB(55,60,72)
	);

	menuGroup.add(settingsClose);

	settingsCloseText = new FlxText(
		settingsClose.x,
		settingsClose.y + 7,
		42,
		"X",
		15
	);

	settingsCloseText.setFormat(
		null,
		15,
		FlxColor.WHITE,
		"CENTER"
	);

	menuGroup.add(settingsCloseText);
}

function updateSettings()
{
	if (settingsPanel == null)
		return;

	if (!FlxG.mouse.justPressed)
		return;

	if (settingsClose != null &&
		FlxG.mouse.overlaps(settingsClose))
	{
		closeSettings();
		return;
	}

	if (settingsVolume != null &&
		FlxG.mouse.overlaps(settingsVolume))
	{
		volumeLevel += 10;

		if (volumeLevel > 100)
			volumeLevel = 0;

		settingsVolume.text =
			"Volume: " + volumeLevel + "%";

		return;
	}

	if (settingsMute != null &&
		FlxG.mouse.overlaps(settingsMute))
	{
		muted = !muted;

		settingsMute.text =
			muted ? "Unmute" : "Mute";

		return;
	}

	if (settingsWallpaper != null &&
		FlxG.mouse.overlaps(settingsWallpaper))
	{
		changeWallpaper();

		settingsWallpaper.text =
			"Background Changed";

		new FlxTimer().start(
			0.7,
			function(tmr)
			{
				if (settingsWallpaper != null)
					settingsWallpaper.text =
						"Change Desktop Background";
			}
		);
	}
}

function closeSettings()
{
	if (settingsPanel != null)
	{
		menuGroup.remove(settingsPanel);
		settingsPanel.destroy();
		settingsPanel = null;
	}

	if (settingsTitle != null)
	{
		menuGroup.remove(settingsTitle);
		settingsTitle.destroy();
		settingsTitle = null;
	}

	if (settingsVolume != null)
	{
		menuGroup.remove(settingsVolume);
		settingsVolume.destroy();
		settingsVolume = null;
	}

	if (settingsMute != null)
	{
		menuGroup.remove(settingsMute);
		settingsMute.destroy();
		settingsMute = null;
	}

	if (settingsWallpaper != null)
	{
		menuGroup.remove(settingsWallpaper);
		settingsWallpaper.destroy();
		settingsWallpaper = null;
	}

	if (settingsClose != null)
	{
		menuGroup.remove(settingsClose);
		settingsClose.destroy();
		settingsClose = null;
	}

	if (settingsCloseText != null)
	{
		menuGroup.remove(settingsCloseText);
		settingsCloseText.destroy();
		settingsCloseText = null;
	}

	currentState = STATE_DESKTOP;
}

// ============================================================
// CLOSE ALL WINDOWS
// ============================================================

function closeAllWindows()
{
	if (youtubeWindow != null)
		clearYouTubeWindow();

	if (pcWindow != null)
		closePC();

	if (recycleWindow != null)
		closeRecycle();

	windowOpen = "";
	windowMinimized = false;
}

// ============================================================
// GLITCH
// ============================================================

function startSmallGlitch()
{
	if (glitchTimer != null)
		glitchTimer.cancel();

	glitchTimer = new FlxTimer();

	glitchTimer.start(
		0.08,
		function(tmr)
		{
			if (messageText == null)
				return;

			var original:String =
				"Why did you come back?";

			var result:String = "";

			for (i in 0...original.length)
			{
				var c:String =
					original.charAt(i);

				if (c != " " &&
					FlxG.random.bool(15))
				{
					c = randomChars[
						FlxG.random.int(
							0,
							randomChars.length - 1
						)
					];
				}

				result += c;
			}

			messageText.text = result;

			messageText.x =
				youtubeWindow.x +
				40 +
				FlxG.random.float(-4,4);

			tmr.reset(0.08);
		}
	);
}

function startHeavyGlitch()
{
	if (glitchTimer != null)
		glitchTimer.cancel();

	glitchTimer = new FlxTimer();

	glitchTimer.start(
		0.045,
		function(tmr)
		{
			if (messageText == null)
				return;

			var original:String =
				"You were never supposed to see this.";

			var result:String = "";

			for (i in 0...original.length)
			{
				var c:String =
					original.charAt(i);

				if (c != " " &&
					FlxG.random.bool(30))
				{
					c = randomChars[
						FlxG.random.int(
							0,
							randomChars.length - 1
						)
					];
				}

				result += c;
			}

			messageText.text = result;

			messageText.x =
				youtubeWindow.x +
				40 +
				FlxG.random.float(-12,12);

			messageText.angle =
				FlxG.random.float(-3,3);

			tmr.reset(0.045);
		}
	);
}

// ============================================================
// HORROR
// ============================================================

function startHorror()
{
	if (transitioning == false)
		transitioning = true;

	currentState = STATE_HORROR;

	if (glitchTimer != null)
	{
		glitchTimer.cancel();
		glitchTimer = null;
	}

	clearYouTubeWindow();

	horrorOverlay = new FlxSprite();

	horrorOverlay.makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.fromRGB(40,0,0)
	);

	horrorOverlay.alpha = 0;

	effectGroup.add(horrorOverlay);

	FlxTween.tween(
		horrorOverlay,
		{alpha:0.55},
		0.6
	);

	horrorText = new FlxText(
		40,
		FlxG.height * 0.40,
		FlxG.width - 80,
		"",
		30
	);

	horrorText.setFormat(
		null,
		30,
		FlxColor.WHITE,
		"CENTER"
	);

	effectGroup.add(horrorText);

	horrorTimer = new FlxTimer();

	horrorTimer.start(
		0.09,
		function(tmr)
		{
			if (currentState != STATE_HORROR)
			{
				tmr.cancel();
				return;
			}

			updateHorror();

			tmr.reset(0.09);
		}
	);

	// ========================================================
	// الانتقال إلى MainMenuState
	// ========================================================

	if (mainMenuTimer != null)
	{
		mainMenuTimer.cancel();
		mainMenuTimer = null;
	}

	mainMenuTimer = new FlxTimer();

	mainMenuTimer.start(
		8.0,
		function(tmr)
		{
			goToMainMenu();
		}
	);
}

// ============================================================
// HORROR UPDATE
// ============================================================

function updateHorror()
{
	if (horrorText == null)
		return;

	var messages:Array<String> = [
		"DON'T LOOK AWAY",
		"WHY ARE YOU HERE?",
		"STOP",
		"STOP",
		"STOP",
		"WE CAN SEE YOU",
		"YOU SHOULD NOT BE HERE",
		"LEAVE",
		"IT KNOWS YOU ARE HERE",
		"DO YOU REMEMBER?",
		"THIS WAS A MISTAKE",
		"RUN",
		"RUN",
		"RUN",
		"YOU CHOSE THIS"
	];

	var selected:String =
		messages[
			FlxG.random.int(
				0,
				messages.length - 1
			)
		];

	var result:String = "";

	for (i in 0...selected.length)
	{
		var c:String =
			selected.charAt(i);

		if (c != " " &&
			FlxG.random.bool(30))
		{
			c = randomChars[
				FlxG.random.int(
					0,
					randomChars.length - 1
				)
			];
		}

		result += c;
	}

	horrorText.text = result;

	horrorText.x =
		40 +
		FlxG.random.float(-20,20);

	horrorText.y =
		FlxG.height * 0.40 +
		FlxG.random.float(-15,15);

	horrorText.angle =
		FlxG.random.float(-4,4);

	horrorText.size =
		FlxG.random.int(24,38);

	if (FlxG.random.bool(12))
	{
		horrorText.alpha = 0;

		new FlxTimer().start(
			0.04,
			function(tmr)
			{
				if (horrorText != null)
					horrorText.alpha = 1;
			}
		);
	}

	if (FlxG.random.bool(8))
	{
		FlxG.camera.shake(
			0.01,
			0.08
		);
	}
}

// ============================================================
// GO TO MAIN MENU
// ============================================================

function goToMainMenu()
{
	if (transitioning == false)
		transitioning = true;

	// منع استدعاء الدالة مرة ثانية
	if (currentState != STATE_HORROR)
		return;

	currentState = STATE_BOOT;

	// إيقاف Timers
	if (glitchTimer != null)
	{
		glitchTimer.cancel();
		glitchTimer = null;
	}

	if (horrorTimer != null)
	{
		horrorTimer.cancel();
		horrorTimer = null;
	}

	if (mainMenuTimer != null)
	{
		mainMenuTimer.cancel();
		mainMenuTimer = null;
	}

	// إيقاف مؤثرات الكاميرا
	FlxG.camera.stopFX();

	// إخفاء الرعب
	if (horrorText != null)
	{
		effectGroup.remove(horrorText);
		horrorText.destroy();
		horrorText = null;
	}

	if (horrorOverlay != null)
	{
		effectGroup.remove(horrorOverlay);
		horrorOverlay.destroy();
		horrorOverlay = null;
	}

	// إخفاء كل القوائم
	hideStartMenu();
	hideSearch();
	hideContextMenu();
	hideNotifications();

	// إغلاق النوافذ
	clearYouTubeWindow();

	if (pcWindow != null)
		closePC();

	if (recycleWindow != null)
		closeRecycle();

	// ========================================================
	// الانتقال الحقيقي إلى MainMenuState
	// ========================================================

	FlxG.switchState(new MainMenuState());
}