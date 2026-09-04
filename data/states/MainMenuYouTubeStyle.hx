import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import openfl.geom.Rectangle;

import funkin.options.Options;
import funkin.options.keybinds.ChangeKeybindSubState;

using StringTools;


// ============================================================
// YOUTUBE MAIN MENU
// CODENAME ENGINE 1.0.1
// ============================================================


// ============================================================
// YOUTUBE OBJECTS
// ============================================================

var ytRoot:Array<Dynamic> = [];

var ytTopBar:FlxSprite;
var ytSideBar:FlxSprite;

var ytVideo:FlxSprite;

var ytProgress:FlxSprite;
var ytProgressFill:FlxSprite;

var ytPlay:FlxText;
var ytVolume:FlxText;
var ytSettings:FlxText;
var ytFullscreen:FlxText;

var ytSubscribe:FlxSprite;
var ytSubscribeText:FlxText;


// ============================================================
// SEARCH
// ============================================================

var ytSearchBox:FlxSprite;
var ytSearchText:FlxText;
var ytSearchIcon:FlxText;

var ytSearchActive:Bool = false;
var ytSearchInput:String = "";

var ytSearchResults:Array<FlxText> = [];

var ytSearchMaxResults:Int = 7;

var ytSearchSongs:Array<String> = [
	"test",
	"tutorial",

	"bopeebo",
	"fresh",
	"dadbattle",

	"spookeez",
	"south",
	"monster",

	"pico",
	"philly nice",
	"blammed",

	"satin panties",
	"high",
	"milf",

	"cocoa",
	"eggnog",
	"winter horrorland",

	"senpai",
	"roses",
	"thorns",

	"ugh",
	"guns",
	"stress"
];


// ============================================================
// SIDEBAR
// ============================================================

var ytSideItems:Array<FlxText> = [];

var ytSideSelected:Int = 0;


// ============================================================
// VIDEO
// ============================================================

var videoX:Float = 225;
var videoY:Float = 82;

var videoW:Float = 0;
var videoH:Float = 0;

var videoContentX:Float = 0;
var videoContentY:Float = 0;

var videoContentW:Float = 0;
var videoContentH:Float = 0;

var controlHeight:Float = 42;


// ============================================================
// FNF
// ============================================================

var fnfBackground:FlxSprite;
var fnfMenu:FlxTypedGroup<FlxSprite>;

var selectedMenu:Int = 0;

var menuNames:Array<String> = [
	"story mode",
	"freeplay",
	"credits"
];

var menuBaseY:Array<Float> = [];

var floatingTime:Float = 0;


// ============================================================
// VIDEO STATE
// ============================================================

var ytPlaying:Bool = true;
var ytMuted:Bool = false;
var ytSubscribed:Bool = false;
var ytLiked:Bool = false;

var ytTime:Float = 32;
var ytDuration:Float = 225;

var ytLiveProgress:Float = 0;
var ytLiveSpeed:Float = 0.22;
var ytLiveWidth:Float = 85;


// ============================================================
// SETTINGS POPUP
// ============================================================

var settingsOpen:Bool = false;

var settingsPage:String = "main";

var settingsPanel:FlxSprite;
var settingsShadow:FlxSprite;

var settingsTitle:FlxText;
var settingsBack:FlxText;

var settingsRows:Array<Dynamic> = [];

var settingsW:Float = 390;
var settingsH:Float = 440;

var settingsX:Float = 0;
var settingsY:Float = 0;

var settingsSelected:Int = 0;


// ============================================================
// KEYBINDS
// ============================================================

var keybindNames:Array<String> = [
	"NOTE_LEFT",
	"NOTE_DOWN",
	"NOTE_UP",
	"NOTE_RIGHT",
	"LEFT",
	"DOWN",
	"UP",
	"RIGHT",
	"ACCEPT",
	"BACK",
	"PAUSE"
];

var keybindP2:Bool = false;


// ============================================================
// SETTINGS IDS
// ============================================================

var gameplayIDs:Array<String> = [
	"downscroll",
	"ghostTapping",
	"flashingMenu",
	"camZoomOnBeat",
	"gameplayShaders",
	"splashesEnabled",
	"week6PixelPerfect",
	"colorHealthBar"
];

var appearanceIDs:Array<String> = [
	"fpsCounter",
	"antialiasing",
	"gpuOnlyBitmaps",
	"lowMemoryMode",
	"betaUpdates"
];

var miscIDs:Array<String> = [
	"autoPause",
	"streamedMusic",
	"streamedVocals",
	"devMode",
	"allowConfigWarning",
	"naughtyness"
];


// ============================================================
// TEXT
// ============================================================

function ytText(
	x:Float,
	y:Float,
	w:Float,
	text:String,
	size:Int,
	color:Int = 0xFFFFFFFF
):FlxText
{
	var t:FlxText = new FlxText(
		x,
		y,
		w,
		text,
		size
	);

	t.setFormat(
		Paths.font("vcr.ttf"),
		size,
		color,
		"left"
	);

	t.scrollFactor.set();
	t.cameras = [FlxG.camera];

	return t;
}


// ============================================================
// BOX
// ============================================================

function ytBox(
	x:Float,
	y:Float,
	w:Float,
	h:Float,
	color:Int
):FlxSprite
{
	var s:FlxSprite = new FlxSprite(x, y);

	s.makeGraphic(
		Std.int(Math.max(1, w)),
		Std.int(Math.max(1, h)),
		color
	);

	s.scrollFactor.set();
	s.cameras = [FlxG.camera];

	return s;
}


// ============================================================
// ADD OBJECT
// ============================================================

function ytAdd(obj:Dynamic)
{
	if (obj == null)
		return;

	obj.scrollFactor.set();
	obj.cameras = [FlxG.camera];

	add(obj);

	ytRoot.push(obj);
}


// ============================================================
// POST CREATE
// ============================================================

function postCreate()
{
	FlxG.mouse.visible = true;

	createYouTubeLayout();

	createFNFBackground();

	createFNFMenu();

	createSettingsPopup();

	updateFNFSelection();

	updateLayerOrder();
}


// ============================================================
// YOUTUBE LAYOUT
// ============================================================

function createYouTubeLayout()
{
	var W:Float = FlxG.width;
	var H:Float = FlxG.height;

	videoX = 225;
	videoY = 82;

	videoW = W - videoX - 25;

	videoH = videoW * 0.5625;

	var maximumHeight:Float =
		H - videoY - 180;

	if (videoH > maximumHeight)
		videoH = maximumHeight;

	if (videoH < 100)
		videoH = 100;

	videoContentX = videoX;
	videoContentY = videoY;

	videoContentW = videoW;

	videoContentH =
		videoH - controlHeight;

	if (videoContentH < 50)
		videoContentH = 50;


	// ========================================================
	// TOP BAR
	// ========================================================

	ytTopBar = ytBox(
		0,
		0,
		W,
		64,
		0xFF181818
	);

	ytAdd(ytTopBar);


	ytAdd(
		ytText(
			20,
			17,
			35,
			"☰",
			20
		)
	);


	ytAdd(
		ytText(
			55,
			15,
			130,
			"YouTube",
			25
		)
	);


	// ========================================================
	// SEARCH
	// ========================================================

	var searchWidth:Float = W - 480;

	if (searchWidth < 250)
		searchWidth = 250;

	ytSearchBox = ytBox(
		210,
		10,
		searchWidth,
		42,
		0xFF242424
	);

	ytAdd(ytSearchBox);


	ytSearchText = ytText(
		225,
		19,
		searchWidth - 55,
		"Search",
		14,
		0xFFAAAAAA
	);

	ytAdd(ytSearchText);


	ytSearchIcon = ytText(
		210 + searchWidth - 38,
		18,
		30,
		"⌕",
		20
	);

	ytAdd(ytSearchIcon);


	createSearchResults();


	// ========================================================
	// TOP RIGHT
	// ========================================================

	ytAdd(
		ytText(
			W - 210,
			18,
			35,
			"M",
			17
		)
	);

	ytAdd(
		ytText(
			W - 160,
			17,
			35,
			"+",
			20
		)
	);

	ytAdd(
		ytText(
			W - 115,
			18,
			35,
			"●",
			15
		)
	);

	ytAdd(
		ytText(
			W - 65,
			17,
			35,
			"U",
			18
		)
	);


	// ========================================================
	// SIDEBAR
	// ========================================================

	ytSideBar = ytBox(
		0,
		64,
		205,
		H - 64,
		0xFF181818
	);

	ytAdd(ytSideBar);


	var sideNames:Array<String> = [
		"Home",
		"Shorts",
		"Subscriptions",
		"",
		"You",
		"History",
		"Playlists",
		"Watch later",
		"Liked videos"
	];


	for (i in 0...sideNames.length)
	{
		if (sideNames[i] == "")
			continue;

		var side:FlxText =
			ytText(
				25,
				90 + i * 42,
				170,
				sideNames[i],
				14
			);

		side.ID = i;

		ytSideItems.push(side);

		ytAdd(side);
	}


	// ========================================================
	// VIDEO
	// ========================================================

	ytVideo = ytBox(
		videoX,
		videoY,
		videoW,
		videoH,
		0xFF101010
	);

	ytAdd(ytVideo);


	// ========================================================
	// PROGRESS
	// ========================================================

	var controlY:Float =
		videoY +
		videoH -
		controlHeight;


	ytProgress = ytBox(
		videoX,
		controlY,
		videoW,
		4,
		0xFF555555
	);

	ytAdd(ytProgress);


	ytLiveWidth =
		Math.min(
			85,
			Math.max(
				35,
				videoW * 0.08
			)
		);


	ytProgressFill = ytBox(
		videoX,
		controlY,
		ytLiveWidth,
		4,
		0xFFFF0000
	);

	ytAdd(ytProgressFill);


	// ========================================================
	// PLAY
	// ========================================================

	ytPlay = ytText(
		videoX + 12,
		controlY + 10,
		35,
		"||",
		16
	);

	ytAdd(ytPlay);


	// ========================================================
	// VOLUME
	// ========================================================

	ytVolume = ytText(
		videoX + 55,
		controlY + 10,
		55,
		"VOL",
		11
	);

	ytAdd(ytVolume);


	// ========================================================
	// TIME
	// ========================================================

	ytAdd(
		ytText(
			videoX + 115,
			controlY + 10,
			130,
			"0:32 / 3:45",
			11
		)
	);


	// ========================================================
	// CC
	// ========================================================

	ytAdd(
		ytText(
			videoX + videoW - 180,
			controlY + 10,
			30,
			"CC",
			11
		)
	);


	// ========================================================
	// SETTINGS
	// ========================================================

	ytSettings = ytText(
		videoX + videoW - 135,
		controlY + 8,
		55,
		"SET",
		11
	);

	ytAdd(ytSettings);


	// ========================================================
	// FULLSCREEN
	// ========================================================

	ytFullscreen = ytText(
		videoX + videoW - 65,
		controlY + 8,
		45,
		"[ ]",
		11
	);

	ytAdd(ytFullscreen);


	// ========================================================
	// TITLE
	// ========================================================

	var infoY:Float =
		videoY +
		videoH +
		20;


	ytAdd(
		ytText(
			videoX,
			infoY,
			videoW,
			"Friday Night Funkin'",
			21
		)
	);


	ytAdd(
		ytText(
			videoX,
			infoY + 34,
			videoW,
			"723,355 views • Mar 21, 2024",
			13,
			0xFFAAAAAA
		)
	);


	ytAdd(
		ytText(
			videoX,
			infoY + 72,
			250,
			"FridayNightFunkin",
			16
		)
	);


	// ========================================================
	// SUBSCRIBE
	// ========================================================

	ytSubscribe = ytBox(
		videoX + 265,
		infoY + 65,
		130,
		36,
		0xFFFF0000
	);

	ytAdd(ytSubscribe);


	ytSubscribeText = ytText(
		videoX + 265,
		infoY + 74,
		130,
		"SUBSCRIBE",
		11
	);

	ytSubscribeText.alignment = "center";

	ytAdd(ytSubscribeText);


	// ========================================================
	// LIKE / DISLIKE / SHARE
	// ========================================================

	ytAdd(
		ytText(
			videoX,
			infoY + 125,
			videoW,
			"LIKE     DISLIKE     SHARE     DOWNLOAD     ...",
			12,
			0xFFDDDDDD
		)
	);


	ytAdd(
		ytText(
			videoX,
			infoY + 170,
			videoW,
			"Description",
			15
		)
	);


	ytAdd(
		ytText(
			videoX,
			infoY + 198,
			videoW,
			"Friday Night Funkin' official gameplay.",
			12,
			0xFFAAAAAA
		)
	);


	ytAdd(
		ytText(
			videoX,
			infoY + 245,
			videoW,
			"Comments",
			15
		)
	);
}


// ============================================================
// SEARCH RESULTS
// ============================================================

function createSearchResults()
{
	for (i in 0...ytSearchMaxResults)
	{
		var result:FlxText =
			ytText(
				220,
				67 + i * 39,
				430,
				"",
				13,
				0xFFFFFFFF
			);

		result.visible = false;

		result.ID = i;

		ytSearchResults.push(result);

		ytAdd(result);
	}
}


// ============================================================
// SEARCH RESULTS UPDATE
// ============================================================

function updateSearchResults()
{
	if (ytSearchResults == null)
		return;


	var query:String =
		ytSearchInput.toLowerCase().trim();

	var resultIndex:Int = 0;


	for (song in ytSearchSongs)
	{
		if (resultIndex >= ytSearchMaxResults)
			break;


		if (
			query == "" ||
			song.toLowerCase().indexOf(query) >= 0
		)
		{
			var result:FlxText =
				ytSearchResults[resultIndex];

			result.text =
				song;

			result.visible =
				ytSearchActive;

			result.x = 220;

			result.y =
				67 +
				resultIndex * 39;

			result.fieldWidth = 400;

			resultIndex++;
		}
	}


	while (
		resultIndex <
		ytSearchResults.length
	)
	{
		ytSearchResults[resultIndex].visible =
			false;

		resultIndex++;
	}
}


// ============================================================
// OPEN SEARCH
// ============================================================

function openSearch()
{
	ytSearchActive = true;

	ytSearchText.color =
		0xFFFFFFFF;

	if (ytSearchInput == "")
		ytSearchText.text =
			"Search songs...";

	updateSearchResults();

	updateLayerOrder();
}


// ============================================================
// CLOSE SEARCH
// ============================================================

function closeSearch()
{
	ytSearchActive = false;

	ytSearchInput = "";

	ytSearchText.text =
		"Search";

	ytSearchText.color =
		0xFFAAAAAA;


	for (result in ytSearchResults)
	{
		if (result != null)
			result.visible = false;
	}


	updateLayerOrder();
}


// ============================================================
// FNF BACKGROUND
// ============================================================

function createFNFBackground()
{
	fnfBackground = new FlxSprite();

	fnfBackground.loadGraphic(
		Paths.image("menus/menuBG")
	);

	fnfBackground.scrollFactor.set();
	fnfBackground.cameras = [FlxG.camera];

	fitBackgroundInsideVideo();

	add(fnfBackground);

	applyVideoClip();
}


// ============================================================
// FIT BACKGROUND
// ============================================================

function fitBackgroundInsideVideo()
{
	if (fnfBackground == null)
		return;

	if (
		fnfBackground.width <= 0 ||
		fnfBackground.height <= 0
	)
		return;


	var originalW:Float =
		fnfBackground.frameWidth;

	var originalH:Float =
		fnfBackground.frameHeight;


	if (originalW <= 0)
		originalW =
			fnfBackground.width;

	if (originalH <= 0)
		originalH =
			fnfBackground.height;


	if (
		originalW <= 0 ||
		originalH <= 0
	)
		return;


	var scaleX:Float =
		videoContentW / originalW;

	var scaleY:Float =
		videoContentH / originalH;


	var scale:Float =
		Math.min(
			scaleX,
			scaleY
		);


	fnfBackground.scale.set(
		scale,
		scale
	);

	fnfBackground.updateHitbox();


	fnfBackground.x =
		videoContentX +
		(
			videoContentW -
			fnfBackground.width
		) / 2;


	fnfBackground.y =
		videoContentY +
		(
			videoContentH -
			fnfBackground.height
		) / 2;


	applyVideoClip();
}


// ============================================================
// CLIP
// ============================================================

function applyVideoClip()
{
	if (fnfBackground == null)
		return;

	fnfBackground.clipRect =
		new Rectangle(
			videoContentX,
			videoContentY,
			videoContentW,
			videoContentH
		);
}


// ============================================================
// FNF MENU
// ============================================================

function createFNFMenu()
{
	fnfMenu =
		new FlxTypedGroup<FlxSprite>();

	fnfMenu.cameras =
		[FlxG.camera];

	add(fnfMenu);

	menuBaseY = [];


	var spacing:Float = 58;

	var totalHeight:Float =
		(menuNames.length - 1) *
		spacing;

	var startY:Float =
		videoContentY +
		videoContentH / 2 -
		totalHeight / 2;


	for (i in 0...menuNames.length)
	{
		var option:String =
			menuNames[i];


		var item:FlxSprite =
			new FlxSprite();


		item.frames =
			Paths.getFrames(
				"menus/mainmenu/" +
				option
			);


		item.animation.addByPrefix(
			"idle",
			option + " basic",
			24,
			true
		);


		item.animation.addByPrefix(
			"selected",
			option + " white",
			24,
			true
		);


		var names:Array<String> =
			item.animation.getNameList();


		if (names.length > 0)
			item.animation.play(names[0]);


		item.ID = i;


		item.scale.set(
			0.55,
			0.55
		);

		item.updateHitbox();


		item.x =
			videoContentX +
			(
				videoContentW -
				item.width
			) / 2;


		item.y =
			startY +
			i * spacing;


		item.cameras =
			[FlxG.camera];


		keepMenuItemInsideVideo(item);

		menuBaseY.push(item.y);

		fnfMenu.add(item);
	}
}


// ============================================================
// KEEP MENU INSIDE VIDEO
// ============================================================

function keepMenuItemInsideVideo(item:FlxSprite)
{
	if (item == null)
		return;


	var padding:Float = 8;


	var left:Float =
		videoContentX +
		padding;

	var right:Float =
		videoContentX +
		videoContentW -
		item.width -
		padding;


	var top:Float =
		videoContentY +
		padding;

	var bottom:Float =
		videoContentY +
		videoContentH -
		item.height -
		padding;


	if (right < left)
		right = left;

	if (bottom < top)
		bottom = top;


	item.x =
		Math.max(
			left,
			Math.min(
				item.x,
				right
			)
		);


	item.y =
		Math.max(
			top,
			Math.min(
				item.y,
				bottom
			)
		);
}


// ============================================================
// FNF SELECTION
// ============================================================

function updateFNFSelection()
{
	if (fnfMenu == null)
		return;


	fnfMenu.forEach(
		function(item:FlxSprite)
		{
			if (item == null)
				return;


			var names:Array<String> =
				item.animation.getNameList();


			if (names.length == 0)
				return;


			if (item.ID == selectedMenu)
			{
				if (
					names.indexOf("selected") >= 0
				)
					item.animation.play("selected");
				else
					item.animation.play(names[0]);
			}
			else
			{
				if (
					names.indexOf("idle") >= 0
				)
					item.animation.play("idle");
				else
					item.animation.play(names[0]);
			}
		}
	);
}


// ============================================================
// SETTINGS POPUP
// ============================================================

function createSettingsPopup()
{
	settingsW = 390;
	settingsH = 440;


	settingsX =
		videoX +
		videoW -
		settingsW -
		15;


	settingsY =
		videoY +
		videoContentH -
		settingsH -
		15;


	if (settingsX < videoX + 5)
		settingsX =
			videoX + 5;


	if (settingsY < videoY + 5)
		settingsY =
			videoY + 5;


	settingsShadow =
		ytBox(
			settingsX - 6,
			settingsY - 6,
			settingsW + 12,
			settingsH + 12,
			0xAA000000
		);

	settingsShadow.visible = false;

	ytAdd(settingsShadow);


	settingsPanel =
		ytBox(
			settingsX,
			settingsY,
			settingsW,
			settingsH,
			0xFF212121
		);

	settingsPanel.visible = false;

	ytAdd(settingsPanel);


	settingsTitle =
		ytText(
			settingsX + 20,
			settingsY + 17,
			settingsW - 70,
			"Settings",
			18
		);

	settingsTitle.visible = false;

	ytAdd(settingsTitle);


	settingsBack =
		ytText(
			settingsX + settingsW - 48,
			settingsY + 15,
			30,
			"<",
			20
		);

	settingsBack.visible = false;

	ytAdd(settingsBack);


	buildSettingsMain();
}


// ============================================================
// CLEAR SETTINGS
// ============================================================

function clearSettingsRows()
{
	for (row in settingsRows)
	{
		if (row != null)
			remove(row, true);
	}

	settingsRows = [];
}


// ============================================================
// ADD SETTINGS ROW
// ============================================================

function addSettingsRow(
	text:String,
	y:Float,
	size:Int = 14
):FlxText
{
	var row:FlxText =
		ytText(
			settingsX + 22,
			y,
			settingsW - 45,
			text,
			size
		);

	ytAdd(row);

	settingsRows.push(row);

	return row;
}


// ============================================================
// MAIN SETTINGS
// ============================================================

function buildSettingsMain()
{
	clearSettingsRows();


	var pages:Array<String> = [
		"Controls",
		"Gameplay",
		"Appearance",
		"Language",
		"Miscellaneous"
	];


	for (i in 0...pages.length)
	{
		var row:FlxText =
			addSettingsRow(
				pages[i],
				settingsY + 65 + i * 60,
				14
			);

		row.ID = i;


		var arrow:FlxText =
			addSettingsRow(
				">",
				settingsY + 65 + i * 60,
				14
			);

		arrow.x =
			settingsX +
			settingsW -
			45;

		arrow.ID =
			1000 + i;
	}
}


// ============================================================
// TOGGLE SETTINGS WINDOW
// ============================================================

function toggleSettings()
{
	settingsOpen =
		!settingsOpen;


	if (settingsOpen)
	{
		closeSearch();

		settingsPage = "main";

		settingsSelected = 0;

		settingsPanel.visible = true;

		settingsShadow.visible = true;

		settingsTitle.visible = true;

		settingsBack.visible = false;

		settingsTitle.text =
			"Settings";

		buildSettingsMain();

		updateLayerOrder();
	}
	else
	{
		settingsPanel.visible = false;

		settingsShadow.visible = false;

		settingsTitle.visible = false;

		settingsBack.visible = false;

		clearSettingsRows();

		settingsPage = "main";

		updateLayerOrder();
	}
}


// ============================================================
// OPEN SETTINGS PAGE
// ============================================================

function openSettingsPage(page:String)
{
	settingsPage =
		page;

	settingsSelected = 0;

	settingsBack.visible = true;

	settingsTitle.text =
		page;


	switch (page)
	{
		case "Controls":
			buildControls();

		case "Gameplay":
			buildGameplay();

		case "Appearance":
			buildAppearance();

		case "Language":
			buildLanguage();

		case "Miscellaneous":
			buildMiscellaneous();
	}


	updateLayerOrder();
}


// ============================================================
// CONTROLS
// ============================================================

function buildControls()
{
	clearSettingsRows();


	var p1Header:FlxText =
		addSettingsRow(
			"P1",
			settingsY + 48,
			11
		);

	p1Header.color =
		0xFFAAAAAA;

	p1Header.x =
		settingsX + 210;


	var p2Header:FlxText =
		addSettingsRow(
			"P2",
			settingsY + 48,
			11
		);

	p2Header.color =
		0xFFAAAAAA;

	p2Header.x =
		settingsX + 300;


	for (i in 0...keybindNames.length)
	{
		var name:String =
			keybindNames[i];


		var p1:Array<FlxKey> =
			Reflect.field(
				Options,
				"P1_" + name
			);


		var p2:Array<FlxKey> =
			Reflect.field(
				Options,
				"P2_" + name
			);


		var key1:FlxKey =
			p1 != null &&
			p1.length > 0
			? p1[0]
			: FlxKey.NONE;


		var key2:FlxKey =
			p2 != null &&
			p2.length > 0
			? p2[0]
			: FlxKey.NONE;


		var y:Float =
			settingsY +
			72 +
			i * 30;


		var nameText:FlxText =
			addSettingsRow(
				name,
				y,
				11
			);

		nameText.ID = i;


		var key1Text:FlxText =
			addSettingsRow(
				CoolUtil.keyToString(key1),
				y,
				11
			);

		key1Text.x =
			settingsX + 195;

		key1Text.fieldWidth =
			80;

		key1Text.alignment =
			"center";

		key1Text.ID =
			100 + i;


		var key2Text:FlxText =
			addSettingsRow(
				CoolUtil.keyToString(key2),
				y,
				11
			);

		key2Text.x =
			settingsX + 285;

		key2Text.fieldWidth =
			80;

		key2Text.alignment =
			"center";

		key2Text.ID =
			200 + i;
	}
}


// ============================================================
// KEYBIND CHANGE
// ============================================================

function startKeybindChange(
	name:String,
	p2:Bool
)
{
	var previousOpen:Bool =
		settingsOpen;

	settingsOpen = false;


	var currentValue:Array<FlxKey> =
		Reflect.field(
			Options,
			(p2 ? "P2_" : "P1_") + name
		);


	var currentKey:FlxKey =
		(
			currentValue != null &&
			currentValue.length > 0
		)
		? currentValue[0]
		: FlxKey.NONE;


	openSubState(
		new ChangeKeybindSubState(
			function(key:FlxKey)
			{
				Reflect.setField(
					Options,
					(p2 ? "P2_" : "P1_") + name,
					[key]
				);

				Options.applyKeybinds();

				Options.save();

				settingsOpen =
					previousOpen;

				buildControls();

				updateLayerOrder();
			},
			function()
			{
				settingsOpen =
					previousOpen;

				buildControls();

				updateLayerOrder();
			}
		)
	);
}


// ============================================================
// GAMEPLAY
// ============================================================

function buildGameplay()
{
	clearSettingsRows();

	addToggleRow(
		"Downscroll",
		"downscroll",
		0
	);

	addToggleRow(
		"Ghost Tapping",
		"ghostTapping",
		1
	);

	addToggleRow(
		"Flashing Menu",
		"flashingMenu",
		2
	);

	addToggleRow(
		"Camera Zoom",
		"camZoomOnBeat",
		3
	);

	addToggleRow(
		"Gameplay Shaders",
		"gameplayShaders",
		4
	);

	addToggleRow(
		"Note Splashes",
		"splashesEnabled",
		5
	);

	addToggleRow(
		"Week 6 Pixel Perfect",
		"week6PixelPerfect",
		6
	);

	addToggleRow(
		"Health Bar Colors",
		"colorHealthBar",
		7
	);
}


// ============================================================
// APPEARANCE
// ============================================================

function buildAppearance()
{
	clearSettingsRows();

	addToggleRow(
		"FPS Counter",
		"fpsCounter",
		0
	);

	addToggleRow(
		"Antialiasing",
		"antialiasing",
		1
	);

	addToggleRow(
		"GPU Only Bitmaps",
		"gpuOnlyBitmaps",
		2
	);

	addToggleRow(
		"Low Memory Mode",
		"lowMemoryMode",
		3
	);

	addToggleRow(
		"Beta Updates",
		"betaUpdates",
		4
	);
}


// ============================================================
// LANGUAGE
// ============================================================

function buildLanguage()
{
	clearSettingsRows();


	var current:String =
		"Current: " +
		Std.string(Options.language);


	addSettingsRow(
		current,
		settingsY + 60,
		14
	);

	addSettingsRow(
		"English",
		settingsY + 110,
		14
	);

	addSettingsRow(
		"Arabic",
		settingsY + 155,
		14
	);
}


// ============================================================
// MISC
// ============================================================

function buildMiscellaneous()
{
	clearSettingsRows();

	addToggleRow(
		"Auto Pause",
		"autoPause",
		0
	);

	addToggleRow(
		"Streamed Music",
		"streamedMusic",
		1
	);

	addToggleRow(
		"Streamed Vocals",
		"streamedVocals",
		2
	);

	addToggleRow(
		"Developer Mode",
		"devMode",
		3
	);

	addToggleRow(
		"Allow Config Warning",
		"allowConfigWarning",
		4
	);

	addToggleRow(
		"Naughtyness",
		"naughtyness",
		5
	);
}


// ============================================================
// TOGGLE ROW
// ============================================================

function addToggleRow(
	name:String,
	id:String,
	index:Int
)
{
	var value:Bool =
		getSettingValue(id);


	var state:String =
		value
		? "ON"
		: "OFF";


	var row:FlxText =
		addSettingsRow(
			name,
			settingsY + 55 + index * 40,
			13
		);

	row.ID = index;


	var stateText:FlxText =
		addSettingsRow(
			state,
			settingsY + 55 + index * 40,
			12
		);


	stateText.x =
		settingsX +
		settingsW -
		80;

	stateText.fieldWidth =
		55;

	stateText.alignment =
		"center";

	stateText.ID =
		1000 + index;


	stateText.color =
		value
		? 0xFFFF4444
		: 0xFFAAAAAA;
}


// ============================================================
// GET SETTING
// ============================================================

function getSettingValue(id:String):Bool
{
	return switch (id)
	{
		case "naughtyness":
			Options.naughtyness;

		case "downscroll":
			Options.downscroll;

		case "ghostTapping":
			Options.ghostTapping;

		case "flashingMenu":
			Options.flashingMenu;

		case "camZoomOnBeat":
			Options.camZoomOnBeat;

		case "fpsCounter":
			Options.fpsCounter;

		case "autoPause":
			Options.autoPause;

		case "antialiasing":
			Options.antialiasing;

		case "gpuOnlyBitmaps":
			Options.gpuOnlyBitmaps;

		case "week6PixelPerfect":
			Options.week6PixelPerfect;

		case "gameplayShaders":
			Options.gameplayShaders;

		case "colorHealthBar":
			Options.colorHealthBar;

		case "lowMemoryMode":
			Options.lowMemoryMode;

		case "devMode":
			Options.devMode;

		case "betaUpdates":
			Options.betaUpdates;

		case "splashesEnabled":
			Options.splashesEnabled;

		case "streamedMusic":
			Options.streamedMusic;

		case "streamedVocals":
			Options.streamedVocals;

		case "allowConfigWarning":
			Options.allowConfigWarning;

		default:
			false;
	}
}


// ============================================================
// TOGGLE SETTING
// ============================================================

function toggleSetting(id:String)
{
	switch (id)
	{
		case "naughtyness":
			Options.naughtyness =
				!Options.naughtyness;

		case "downscroll":
			Options.downscroll =
				!Options.downscroll;

		case "ghostTapping":
			Options.ghostTapping =
				!Options.ghostTapping;

		case "flashingMenu":
			Options.flashingMenu =
				!Options.flashingMenu;

		case "camZoomOnBeat":
			Options.camZoomOnBeat =
				!Options.camZoomOnBeat;

		case "fpsCounter":
			Options.fpsCounter =
				!Options.fpsCounter;

		case "autoPause":
			Options.autoPause =
				!Options.autoPause;

		case "antialiasing":
			Options.antialiasing =
				!Options.antialiasing;

		case "gpuOnlyBitmaps":
			Options.gpuOnlyBitmaps =
				!Options.gpuOnlyBitmaps;

		case "week6PixelPerfect":
			Options.week6PixelPerfect =
				!Options.week6PixelPerfect;

		case "gameplayShaders":
			Options.gameplayShaders =
				!Options.gameplayShaders;

		case "colorHealthBar":
			Options.colorHealthBar =
				!Options.colorHealthBar;

		case "lowMemoryMode":
			Options.lowMemoryMode =
				!Options.lowMemoryMode;

		case "devMode":
			Options.devMode =
				!Options.devMode;

		case "betaUpdates":
			Options.betaUpdates =
				!Options.betaUpdates;

		case "splashesEnabled":
			Options.splashesEnabled =
				!Options.splashesEnabled;

		case "streamedMusic":
			Options.streamedMusic =
				!Options.streamedMusic;

		case "streamedVocals":
			Options.streamedVocals =
				!Options.streamedVocals;

		case "allowConfigWarning":
			Options.allowConfigWarning =
				!Options.allowConfigWarning;
	}


	Options.applySettings();

	Options.save();
}


// ============================================================
// SELECT FNF MENU
// ============================================================

function selectFNFMenu()
{
	switch (selectedMenu)
	{
		case 0:
			FlxG.switchState(
				new StoryMenuState()
			);

		case 1:
			FlxG.switchState(
				new FreeplayState()
			);

		case 2:
			FlxG.switchState(
				new CreditsMain()
			);
	}
}


// ============================================================
// RETURN SETTINGS
// ============================================================

function returnToMainSettings()
{
	settingsPage =
		"main";

	settingsSelected =
		0;

	settingsBack.visible =
		false;

	settingsTitle.text =
		"Settings";

	buildSettingsMain();

	updateLayerOrder();
}


// ============================================================
// LAYER ORDER
// ============================================================

function updateLayerOrder()
{
	if (fnfBackground != null)
	{
		remove(fnfBackground, true);
		add(fnfBackground);

		applyVideoClip();
	}


	if (fnfMenu != null)
	{
		remove(fnfMenu, true);
		add(fnfMenu);
	}


	if (ytProgress != null)
	{
		remove(ytProgress, true);
		add(ytProgress);
	}


	if (ytProgressFill != null)
	{
		remove(ytProgressFill, true);
		add(ytProgressFill);
	}


	if (ytPlay != null)
	{
		remove(ytPlay, true);
		add(ytPlay);
	}


	if (ytVolume != null)
	{
		remove(ytVolume, true);
		add(ytVolume);
	}


	if (ytSettings != null)
	{
		remove(ytSettings, true);
		add(ytSettings);
	}


	if (ytFullscreen != null)
	{
		remove(ytFullscreen, true);
		add(ytFullscreen);
	}


	if (ytSubscribe != null)
	{
		remove(ytSubscribe, true);
		add(ytSubscribe);
	}


	if (ytSubscribeText != null)
	{
		remove(ytSubscribeText, true);
		add(ytSubscribeText);
	}


	// ========================================================
	// SEARCH ON TOP
	// ========================================================

	if (ytSearchBox != null)
	{
		remove(ytSearchBox, true);
		add(ytSearchBox);
	}


	if (ytSearchText != null)
	{
		remove(ytSearchText, true);
		add(ytSearchText);
	}


	if (ytSearchIcon != null)
	{
		remove(ytSearchIcon, true);
		add(ytSearchIcon);
	}


	for (result in ytSearchResults)
	{
		if (
			result != null &&
			result.visible
		)
		{
			remove(result, true);
			add(result);
		}
	}


	// ========================================================
	// SETTINGS ON TOP
	// ========================================================

	if (settingsOpen)
	{
		if (settingsShadow != null)
		{
			remove(settingsShadow, true);
			add(settingsShadow);
		}


		if (settingsPanel != null)
		{
			remove(settingsPanel, true);
			add(settingsPanel);
		}


		if (settingsTitle != null)
		{
			remove(settingsTitle, true);
			add(settingsTitle);
		}


		if (settingsBack != null)
		{
			remove(settingsBack, true);
			add(settingsBack);
		}


		for (row in settingsRows)
		{
			if (row != null)
			{
				remove(row, true);
				add(row);
			}
		}
	}
}


// ============================================================
// UPDATE
// ============================================================

function update(elapsed:Float)
{
	FlxG.mouse.visible = true;


	// ========================================================
	// VIDEO TIME
	// ========================================================

	if (ytPlaying)
	{
		ytTime += elapsed;

		if (ytTime >= ytDuration)
			ytTime = 0;


		ytLiveProgress +=
			elapsed *
			ytLiveSpeed;


		if (ytLiveProgress >= 1)
			ytLiveProgress -= 1;
	}


	// ========================================================
	// PROGRESS
	// ========================================================

	if (
		ytProgress != null &&
		ytProgressFill != null
	)
	{
		var progressY:Float =
			videoY +
			videoH -
			controlHeight;


		ytProgress.x =
			videoX;

		ytProgress.y =
			progressY;


		var travelWidth:Float =
			Math.max(
				1,
				videoW -
				ytLiveWidth
			);


		ytProgressFill.x =
			videoX +
			travelWidth *
			ytLiveProgress;

		ytProgressFill.y =
			progressY;
	}


	// ========================================================
	// FNF FLOAT
	// ========================================================

	floatingTime += elapsed;


	if (fnfMenu != null)
	{
		fnfMenu.forEach(
			function(item:FlxSprite)
			{
				if (item == null)
					return;


				if (
					item.ID >= 0 &&
					item.ID < menuBaseY.length
				)
				{
					item.y =
						menuBaseY[item.ID] +
						Math.sin(
							floatingTime * 1.4 +
							item.ID
						) * 4;


					keepMenuItemInsideVideo(item);
				}
			}
		);
	}


	// ========================================================
	// SEARCH KEYBOARD
	// ========================================================

	if (ytSearchActive)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			closeSearch();
			return;
		}


		if (FlxG.keys.justPressed.BACKSPACE)
		{
			if (ytSearchInput.length > 0)
			{
				ytSearchInput =
					ytSearchInput.substr(
						0,
						ytSearchInput.length - 1
					);

				if (ytSearchInput == "")
					ytSearchText.text =
						"Search songs...";
				else
					ytSearchText.text =
						ytSearchInput;

				updateSearchResults();
			}
		}


		var keys:Array<FlxKey> = [
			FlxKey.A,
			FlxKey.B,
			FlxKey.C,
			FlxKey.D,
			FlxKey.E,
			FlxKey.F,
			FlxKey.G,
			FlxKey.H,
			FlxKey.I,
			FlxKey.J,
			FlxKey.K,
			FlxKey.L,
			FlxKey.M,
			FlxKey.N,
			FlxKey.O,
			FlxKey.P,
			FlxKey.Q,
			FlxKey.R,
			FlxKey.S,
			FlxKey.T,
			FlxKey.U,
			FlxKey.V,
			FlxKey.W,
			FlxKey.X,
			FlxKey.Y,
			FlxKey.Z
		];


		var letters:Array<String> = [
			"a","b","c","d","e","f","g","h","i","j","k","l","m",
			"n","o","p","q","r","s","t","u","v","w","x","y","z"
		];


		for (i in 0...keys.length)
		{
			if (
				FlxG.keys.justPressed[
					keys[i]
				]
			)
			{
				ytSearchInput +=
					letters[i];

				ytSearchText.text =
					ytSearchInput;

				updateSearchResults();

				break;
			}
		}


		if (FlxG.keys.justPressed.SPACE)
		{
			ytSearchInput += " ";

			ytSearchText.text =
				ytSearchInput;

			updateSearchResults();
		}
	}


	// ========================================================
	// KEYBOARD MENU
	// ========================================================

	if (!settingsOpen && !ytSearchActive)
	{
		if (controls.UP_P)
		{
			selectedMenu--;

			if (selectedMenu < 0)
				selectedMenu = 2;

			updateFNFSelection();
		}


		if (controls.DOWN_P)
		{
			selectedMenu++;

			if (selectedMenu > 2)
				selectedMenu = 0;

			updateFNFSelection();
		}


		if (controls.ACCEPT)
		{
			selectFNFMenu();
			return;
		}


		if (controls.BACK)
		{
			FlxG.switchState(
				new TitleState()
			);

			return;
		}
	}


	// ========================================================
	// SETTINGS KEYBOARD
	// ========================================================

	if (settingsOpen)
	{
		if (controls.BACK)
		{
			if (settingsPage != "main")
				returnToMainSettings();
			else
				toggleSettings();

			return;
		}
	}


	// ========================================================
	// MOUSE
	// ========================================================

	if (!FlxG.mouse.justPressed)
		return;


	var mx:Float =
		FlxG.mouse.x;

	var my:Float =
		FlxG.mouse.y;


	// ========================================================
	// SEARCH BUTTON
	// ========================================================

	if (
		mx >= ytSearchBox.x &&
		mx <= ytSearchBox.x +
			ytSearchBox.width &&
		my >= ytSearchBox.y &&
		my <= ytSearchBox.y +
			ytSearchBox.height
	)
	{
		openSearch();
		return;
	}


	// ========================================================
	// SEARCH RESULTS
	// ========================================================

	if (ytSearchActive)
	{
		for (result in ytSearchResults)
		{
			if (
				result == null ||
				!result.visible
			)
				continue;


			if (
				mx >= result.x - 5 &&
				mx <= result.x +
					result.fieldWidth &&
				my >= result.y - 5 &&
				my <= result.y +
					result.height + 5
			)
			{
				closeSearch();

				FlxG.switchState(
					new FreeplayState()
				);

				return;
			}
		}

		return;
	}


	// ========================================================
	// SETTINGS BUTTON
	// ========================================================

	if (
		mx >= ytSettings.x - 15 &&
		mx <= ytSettings.x +
			ytSettings.width + 15 &&
		my >= ytSettings.y - 15 &&
		my <= ytSettings.y +
			ytSettings.height + 15
	)
	{
		toggleSettings();
		return;
	}


	// ========================================================
	// SETTINGS BACK
	// ========================================================

	if (
		settingsOpen &&
		settingsPage != "main" &&
		mx >= settingsBack.x - 15 &&
		mx <= settingsBack.x +
			settingsBack.width + 15 &&
		my >= settingsBack.y - 15 &&
		my <= settingsBack.y +
			settingsBack.height + 15
	)
	{
		returnToMainSettings();

		return;
	}


	// ========================================================
	// SETTINGS WINDOW
	// ========================================================

	if (settingsOpen)
	{
		if (
			mx < settingsX ||
			mx > settingsX + settingsW ||
			my < settingsY ||
			my > settingsY + settingsH
		)
		{
			return;
		}


		var localY:Float =
			my - settingsY;


		if (settingsPage == "main")
		{
			var index:Int =
				Std.int(
					(localY - 50) / 60
				);


			var pages:Array<String> = [
				"Controls",
				"Gameplay",
				"Appearance",
				"Language",
				"Miscellaneous"
			];


			if (
				index >= 0 &&
				index < pages.length
			)
			{
				openSettingsPage(
					pages[index]
				);
			}

			return;
		}


		if (settingsPage == "Controls")
		{
			var index:Int =
				Std.int(
					(localY - 72) / 30
				);


			if (
				index >= 0 &&
				index < keybindNames.length
			)
			{
				var rowCenter:Float =
					settingsY +
					72 +
					index * 30 +
					15;


				if (
					my >= rowCenter - 15 &&
					my <= rowCenter + 15
				)
				{
					if (
						mx >= settingsX + 180 &&
						mx < settingsX + 285
					)
					{
						startKeybindChange(
							keybindNames[index],
							false
						);

						return;
					}


					if (
						mx >= settingsX + 280 &&
						mx <= settingsX + settingsW
					)
					{
						startKeybindChange(
							keybindNames[index],
							true
						);

						return;
					}
				}
			}

			return;
		}


		if (settingsPage == "Gameplay")
		{
			var index:Int =
				Std.int(
					(localY - 40) / 40
				);


			if (
				index >= 0 &&
				index < gameplayIDs.length
			)
			{
				toggleSetting(
					gameplayIDs[index]
				);

				buildGameplay();

				updateLayerOrder();
			}

			return;
		}


		if (settingsPage == "Appearance")
		{
			var index:Int =
				Std.int(
					(localY - 40) / 40
				);


			if (
				index >= 0 &&
				index < appearanceIDs.length
			)
			{
				toggleSetting(
					appearanceIDs[index]
				);

				buildAppearance();

				updateLayerOrder();
			}

			return;
		}


		if (settingsPage == "Language")
		{
			var index:Int =
				Std.int(
					(localY - 50) / 45
				);


			if (index == 1)
			{
				Options.language =
					"en";

				Options.save();
			}


			if (index == 2)
			{
				Options.language =
					"ar";

				Options.save();
			}


			buildLanguage();

			updateLayerOrder();

			return;
		}


		if (settingsPage == "Miscellaneous")
		{
			var index:Int =
				Std.int(
					(localY - 40) / 40
				);


			if (
				index >= 0 &&
				index < miscIDs.length
			)
			{
				toggleSetting(
					miscIDs[index]
				);

				buildMiscellaneous();

				updateLayerOrder();
			}

			return;
		}


		return;
	}


	// ========================================================
	// SUBSCRIBE
	// ========================================================

	if (
		mx >= ytSubscribe.x &&
		mx <= ytSubscribe.x +
			ytSubscribe.width &&
		my >= ytSubscribe.y &&
		my <= ytSubscribe.y +
			ytSubscribe.height
	)
	{
		ytSubscribed =
			!ytSubscribed;


		ytSubscribe.color =
			ytSubscribed
			? 0xFF444444
			: 0xFFFF0000;


		ytSubscribeText.text =
			ytSubscribed
			? "SUBSCRIBED"
			: "SUBSCRIBE";


		updateLayerOrder();

		return;
	}


	// ========================================================
	// PLAY
	// ========================================================

	if (
		mx >= ytPlay.x &&
		mx <= ytPlay.x + 35 &&
		my >= ytPlay.y &&
		my <= ytPlay.y + 30
	)
	{
		ytPlaying =
			!ytPlaying;


		ytPlay.text =
			ytPlaying
			? "||"
			: ">";

		return;
	}


	// ========================================================
	// VOLUME
	// ========================================================

	if (
		mx >= ytVolume.x &&
		mx <= ytVolume.x + 55 &&
		my >= ytVolume.y &&
		my <= ytVolume.y + 30
	)
	{
		ytMuted =
			!ytMuted;


		ytVolume.text =
			ytMuted
			? "MUTE"
			: "VOL";


		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.volume =
				ytMuted
				? 0
				: Options.volumeMusic;
		}

		return;
	}


	// ========================================================
	// FULLSCREEN
	// ========================================================

	if (
		mx >= ytFullscreen.x &&
		mx <= ytFullscreen.x +
			ytFullscreen.width &&
		my >= ytFullscreen.y &&
		my <= ytFullscreen.y +
			ytFullscreen.height
	)
	{
		FlxG.fullscreen =
			!FlxG.fullscreen;

		return;
	}


	// ========================================================
	// FNF MENU
	// ========================================================

	if (
		mx >= videoContentX &&
		mx <= videoContentX +
			videoContentW &&
		my >= videoContentY &&
		my <= videoContentY +
			videoContentH
	)
	{
		if (fnfMenu != null)
		{
			for (item in fnfMenu.members)
			{
				if (item == null)
					continue;


				if (
					mx >= item.x &&
					mx <= item.x +
						item.width &&
					my >= item.y &&
					my <= item.y +
						item.height
				)
				{
					selectedMenu =
						item.ID;

					updateFNFSelection();

					selectFNFMenu();

					return;
				}
			}
		}
	}
}