package funkin.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import funkin.game.HealthIcon;

import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

using StringTools;


/*
 * ============================================================
 * YouTubeMadnessMenu
 * ============================================================
 *
 * Home:
 *   mods/data/config/freeplaySonglist.txt
 *
 * Song data:
 *   mods/songs/<song>/meta.json
 *
 * Charts:
 *   mods/songs/<song>/charts/
 *
 * FEATURES
 *
 * - Independent YouTube-style pages
 * - Search
 * - Guide / sidebar
 * - Likes
 * - Subscribe
 * - Watch later
 * - History
 * - Playlists
 * - Persistent save
 * - Mouse interaction
 * - Keyboard navigation
 * - Card hover
 * - Selected card enlargement
 * - YouTube-style loading ring
 * - Smooth page transition
 *
 * ============================================================
 */


/* ============================================================
   SONG DATA
   ============================================================ */

var songs:Array<Dynamic> = [];
var allSongs:Array<Dynamic> = [];
var filteredSongs:Array<Dynamic> = [];

var selectedIndex:Int = 0;
var transitioning:Bool = false;


/* ============================================================
   SEARCH
   ============================================================ */

var searchActive:Bool = false;
var searchQuery:String = "";

var searchBox:FlxSprite;
var searchText:FlxText;
var searchCursor:FlxSprite;
var searchClearText:FlxText;
var noResultsText:FlxText;


/* ============================================================
   MAIN UI
   ============================================================ */

var background:FlxSprite;
var topBar:FlxSprite;

var sectionText:FlxText;
var songCounter:FlxText;

var helpText:FlxText;


/* ============================================================
   GUIDE
   ============================================================ */

var guidePanel:FlxSprite;
var guideMenuButton:FlxText;
var guideLogoText:FlxText;

var guideItems:Array<Dynamic> = [];

var guideChannels:Array<String> = [];

var guideWidth:Float = 255;

var guideOpen:Bool = true;

var guideHovered:Int = -1;

var guideScroll:Float = 0;
var guideTargetScroll:Float = 0;
var guideMaxScroll:Float = 0;

var guideSubscriptionsExpanded:Bool = true;
var guideExploreExpanded:Bool = false;


/* ============================================================
   PAGE SYSTEM
   ============================================================ */

var currentGuidePage:String = "Home";
var previousGuidePage:String = "";

var pageBackground:FlxSprite;
var pageAccent:FlxSprite;

var pageTitle:FlxText;
var pageSubtitle:FlxText;

var pageContent:Array<Dynamic> = [];

var pageTransition:Bool = false;

var pageTransitionTime:Float = 0;

var pageTransitionDuration:Float = 0.28;


/* ============================================================
   SAVE DATA
   ============================================================ */

var likedSongs:Array<String> = [];
var watchLaterSongs:Array<String> = [];
var historySongs:Array<String> = [];
var playlistSongs:Array<String> = [];
var savedSubscriptions:Array<String> = [];


/* ============================================================
   HOME CARDS
   ============================================================ */

var cards:Array<FlxSprite> = [];

var thumbnails:Array<HealthIcon> = [];

var titleTexts:Array<FlxText> = [];

var channelTexts:Array<FlxText> = [];

var metadataTexts:Array<FlxText> = [];

var durationTexts:Array<FlxText> = [];

var progressBars:Array<FlxSprite> = [];

var playButtons:Array<FlxSprite> = [];

var playButtonTexts:Array<FlxText> = [];


/* ============================================================
   CARD ACTIONS
   ============================================================ */

var cardLikes:Array<FlxText> = [];

var cardSubscribeButtons:Array<FlxSprite> = [];

var cardSubscribeTexts:Array<FlxText> = [];


/* ============================================================
   SONG GRID
   ============================================================ */

var columns:Int = 3;

var cardWidth:Float = 300;

var cardHeight:Float = 245;

var thumbnailWidth:Float = 300;

var thumbnailHeight:Float = 169;

var gridX:Float = 280;

var gridY:Float = 110;

var gapX:Float = 22;

var gapY:Float = 28;


/* ============================================================
   HOME SCROLL
   ============================================================ */

var targetScroll:Float = 0;

var currentScroll:Float = 0;

var maxScroll:Float = 0;


/* ============================================================
   HOME HOVER
   ============================================================ */

var hoveredIndex:Int = -1;

var previousHoveredIndex:Int = -1;


/* ============================================================
   DOUBLE CLICK
   ============================================================ */

var lastClickedIndex:Int = -1;

var lastClickTime:Float = -1000;


/* ============================================================
   LOADING ANIMATION
   ============================================================ */

var selectedAnimating:Bool = false;

var loadingActive:Bool = false;

var loadingRing:Array<FlxSprite> = [];

var loadingTime:Float = 0;

var loadingDuration:Float = 1.15;

var loadingAngle:Float = 0;

var loadingCenterX:Float = 0;

var loadingCenterY:Float = 0;


/* ============================================================
   KEYBOARD
   ============================================================ */

var keyboardListenerAdded:Bool = false;


/* ============================================================
   CREATE
   ============================================================ */

function create()
{
	transitioning = false;

	selectedIndex = 0;

	hoveredIndex = -1;

	previousHoveredIndex = -1;

	lastClickedIndex = -1;

	lastClickTime = -1000;

	currentScroll = 0;

	targetScroll = 0;

	searchActive = false;

	searchQuery = "";

	currentGuidePage = "Home";

	previousGuidePage = "";

	guideScroll = 0;

	guideTargetScroll = 0;

	loadingActive = false;

	selectedAnimating = false;

	FlxG.mouse.visible = true;


	/* ========================================================
	   LOAD SAVE
	   ======================================================== */

	loadYouTubeSave();


	/* ========================================================
	   BACKGROUND
	   ======================================================== */

	background = new FlxSprite();

	background.makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.fromRGB(
			15,
			15,
			15
		)
	);

	add(background);


	/* ========================================================
	   TOP BAR
	   ======================================================== */

	topBar = new FlxSprite(
		0,
		0
	);

	topBar.makeGraphic(
		FlxG.width,
		70,
		FlxColor.fromRGB(
			20,
			20,
			20
		)
	);

	add(topBar);


	/* ========================================================
	   SEARCH BOX
	   ======================================================== */

	searchBox = new FlxSprite(
		245,
		14
	);

	searchBox.makeGraphic(
		430,
		42,
		FlxColor.fromRGB(
			40,
			40,
			40
		)
	);

	add(searchBox);


	searchText = new FlxText(
		265,
		20,
		330,
		"Search",
		18
	);

	searchText.setFormat(
		null,
		18,
		FlxColor.fromRGB(
			155,
			155,
			155
		),
		"LEFT"
	);

	add(searchText);


	searchCursor = new FlxSprite(
		265,
		20
	);

	searchCursor.makeGraphic(
		2,
		25,
		FlxColor.WHITE
	);

	searchCursor.alpha = 0;

	add(searchCursor);


	searchClearText = new FlxText(
		610,
		18,
		45,
		"×",
		26
	);

	searchClearText.setFormat(
		null,
		26,
		FlxColor.fromRGB(
			180,
			180,
			180
		),
		"CENTER"
	);

	searchClearText.alpha = 0;

	add(searchClearText);


	/* ========================================================
	   NO RESULTS
	   ======================================================== */

	noResultsText = new FlxText(
		gridX,
		gridY + 100,
		600,
		"No results",
		22
	);

	noResultsText.setFormat(
		null,
		22,
		FlxColor.fromRGB(
			160,
			160,
			160
		),
		"LEFT"
	);

	noResultsText.visible = false;

	add(noResultsText);


	/* ========================================================
	   HOME HEADER
	   ======================================================== */

	sectionText = new FlxText(
		gridX,
		80,
		550,
		"Friday Night Funkin'",
		21
	);

	sectionText.setFormat(
		null,
		21,
		FlxColor.WHITE,
		"LEFT"
	);

	add(sectionText);


	songCounter = new FlxText(
		FlxG.width - 260,
		82,
		220,
		"",
		14
	);

	songCounter.setFormat(
		null,
		14,
		FlxColor.fromRGB(
			150,
			150,
			150
		),
		"RIGHT"
	);

	add(songCounter);


	/* ========================================================
	   HELP
	   ======================================================== */

	helpText = new FlxText(
		255,
		FlxG.height - 28,
		FlxG.width - 255,
		"ARROWS Navigate    ENTER Play    DOUBLE CLICK Play    ESC Back",
		13
	);

	helpText.setFormat(
		null,
		13,
		FlxColor.fromRGB(
			150,
			150,
			150
		),
		"CENTER"
	);

	add(helpText);


	/* ========================================================
	   GUIDE
	   ======================================================== */

	createGuideDrawer();


	/* ========================================================
	   PAGE SYSTEM
	   ======================================================== */

	createPageSystem();


	/* ========================================================
	   SONGS
	   ======================================================== */

	loadSongs();

	allSongs = songs.copy();

	filteredSongs = allSongs.copy();


	buildCards();

	updateMaximumScroll();

	updateSelection();

	updateCardPositions();


	/* ========================================================
	   HOME
	   ======================================================== */

	openGuidePage(
		"Home",
		false
	);


	/* ========================================================
	   KEYBOARD
	   ======================================================== */

	addKeyboardListener();
}


/* ============================================================
   SAVE LOAD
   ============================================================ */

function loadYouTubeSave()
{
	try
	{
		var data:Dynamic =
			FlxG.save.data.youtubeMadness;


		if (data == null)
			return;


		var likes:Dynamic =
			Reflect.field(
				data,
				"likedSongs"
			);

		var later:Dynamic =
			Reflect.field(
				data,
				"watchLaterSongs"
			);

		var history:Dynamic =
			Reflect.field(
				data,
				"historySongs"
			);

		var playlists:Dynamic =
			Reflect.field(
				data,
				"playlistSongs"
			);

		var subscriptions:Dynamic =
			Reflect.field(
				data,
				"savedSubscriptions"
			);


		if (likes != null)
			likedSongs = cast likes;

		if (later != null)
			watchLaterSongs = cast later;

		if (history != null)
			historySongs = cast history;

		if (playlists != null)
			playlistSongs = cast playlists;

		if (subscriptions != null)
			savedSubscriptions = cast subscriptions;


		var savedGuide:Dynamic =
			Reflect.field(
				data,
				"guideOpen"
			);


		var savedSubs:Dynamic =
			Reflect.field(
				data,
				"subscriptionsExpanded"
			);


		var savedExplore:Dynamic =
			Reflect.field(
				data,
				"exploreExpanded"
			);


		var savedPage:Dynamic =
			Reflect.field(
				data,
				"currentPage"
			);


		if (savedGuide != null)
			guideOpen = cast savedGuide;


		if (savedSubs != null)
			guideSubscriptionsExpanded =
				cast savedSubs;


		if (savedExplore != null)
			guideExploreExpanded =
				cast savedExplore;


		if (savedPage != null)
			currentGuidePage =
				Std.string(
					savedPage
				);
	}
	catch (e:Dynamic)
	{
		trace(
			"YouTubeMadnessMenu: Save load error: " +
			e
		);
	}
}


/* ============================================================
   SAVE
   ============================================================ */

function saveYouTube()
{
	try
	{
		var data:Dynamic = {};


		data.likedSongs =
			likedSongs.copy();


		data.watchLaterSongs =
			watchLaterSongs.copy();


		data.historySongs =
			historySongs.copy();


		data.playlistSongs =
			playlistSongs.copy();


		data.savedSubscriptions =
			savedSubscriptions.copy();


		data.guideOpen =
			guideOpen;


		data.subscriptionsExpanded =
			guideSubscriptionsExpanded;


		data.exploreExpanded =
			guideExploreExpanded;


		data.currentPage =
			currentGuidePage;


		FlxG.save.data.youtubeMadness =
			data;


		FlxG.save.flush();
	}
	catch (e:Dynamic)
	{
		trace(
			"YouTubeMadnessMenu: Save error: " +
			e
		);
	}
}


/* ============================================================
   KEYBOARD
   ============================================================ */

function addKeyboardListener()
{
	if (keyboardListenerAdded)
		return;


	try
	{
		FlxG.stage.addEventListener(
			KeyboardEvent.KEY_DOWN,
			onSearchKeyDown
		);


		keyboardListenerAdded = true;
	}
	catch (e:Dynamic)
	{
		trace(
			"YouTubeMadnessMenu: Keyboard listener failed: " +
			e
		);
	}
}


function onSearchKeyDown(
	event:KeyboardEvent
)
{
	if (!searchActive)
		return;


	if (
		event.keyCode ==
		Keyboard.ESCAPE
	)
	{
		deactivateSearch();

		return;
	}


	if (
		event.keyCode ==
		Keyboard.BACKSPACE
	)
	{
		if (searchQuery.length > 0)
		{
			searchQuery =
				searchQuery.substr(
					0,
					searchQuery.length - 1
				);

			updateSearchVisual();

			filterSongs();
		}

		return;
	}


	if (
		event.keyCode ==
		Keyboard.ENTER
	)
	{
		if (
			currentGuidePage == "Home" &&
			songs.length > 0
		)
		{
			startSongLoading();
		}

		return;
	}


	if (
		event.keyCode ==
		Keyboard.SPACE
	)
	{
		searchQuery += " ";

		updateSearchVisual();

		filterSongs();

		return;
	}


	var character:String =
		event.charCode > 0
		? String.fromCharCode(
			event.charCode
		)
		: "";


	if (
		character.length > 0 &&
		character != "\n" &&
		character != "\r"
	)
	{
		searchQuery += character;

		updateSearchVisual();

		filterSongs();
	}
}


/* ============================================================
   SEARCH
   ============================================================ */

function updateSearchVisual()
{
	if (searchQuery.length == 0)
	{
		searchText.text = "Search";

		searchText.color =
			FlxColor.fromRGB(
				155,
				155,
				155
			);

		searchClearText.alpha = 0;
	}
	else
	{
		searchText.text =
			searchQuery;

		searchText.color =
			FlxColor.WHITE;

		searchClearText.alpha = 1;
	}


	searchCursor.x =
		265 +
		searchText.width +
		2;
}


function activateSearch()
{
	searchActive = true;

	searchText.color =
		FlxColor.WHITE;

	searchCursor.alpha = 1;

	searchClearText.alpha =
		searchQuery.length > 0
		? 1
		: 0;
}


function deactivateSearch()
{
	searchActive = false;

	searchCursor.alpha = 0;


	if (searchQuery.length == 0)
	{
		searchText.text =
			"Search";

		searchText.color =
			FlxColor.fromRGB(
				155,
				155,
				155
			);

		searchClearText.alpha = 0;
	}
	else
	{
		searchText.color =
			FlxColor.WHITE;

		searchClearText.alpha = 1;
	}
}


function clearSearch()
{
	searchQuery = "";

	searchActive = false;

	searchText.text =
		"Search";

	searchText.color =
		FlxColor.fromRGB(
			155,
			155,
			155
		);

	searchCursor.alpha = 0;

	searchClearText.alpha = 0;

	filteredSongs =
		allSongs.copy();

	songs =
		filteredSongs.copy();

	selectedIndex = 0;

	currentScroll = 0;

	targetScroll = 0;


	if (
		currentGuidePage ==
		"Home"
	)
	{
		clearCards();

		buildCards();

		updateMaximumScroll();

		updateSelection();

		updateCardPositions();
	}


	noResultsText.visible = false;


	saveYouTube();
}


function filterSongs()
{
	var query:String =
		StringTools.trim(
			searchQuery.toLowerCase()
		);


	filteredSongs = [];


	for (song in allSongs)
	{
		var displayValue:Dynamic =
			Reflect.field(
				song,
				"displayName"
			);


		var nameValue:Dynamic =
			Reflect.field(
				song,
				"name"
			);


		var display:String =
			displayValue == null
			? ""
			: Std.string(
				displayValue
			);


		var internal:String =
			nameValue == null
			? ""
			: Std.string(
				nameValue
			);


		if (query.length == 0)
		{
			filteredSongs.push(
				song
			);

			continue;
		}


		if (
			display.toLowerCase()
				.indexOf(query) >= 0
			||
			internal.toLowerCase()
				.indexOf(query) >= 0
		)
		{
			filteredSongs.push(
				song
			);
		}
	}


	songs =
		filteredSongs.copy();


	selectedIndex = 0;

	currentScroll = 0;

	targetScroll = 0;


	if (
		currentGuidePage ==
		"Home"
	)
	{
		clearCards();

		buildCards();

		updateMaximumScroll();

		updateSelection();

		updateCardPositions();
	}


	noResultsText.visible =
		currentGuidePage == "Home" &&
		songs.length == 0;
}


/* ============================================================
   GUIDE
   ============================================================ */

function createGuideDrawer()
{
	guideItems = [];


	guidePanel =
		new FlxSprite(
			0,
			70
		);


	guidePanel.makeGraphic(
		Std.int(guideWidth),
		FlxG.height - 70,
		FlxColor.fromRGB(
			18,
			18,
			18
		)
	);


	add(guidePanel);


	guideMenuButton =
		new FlxText(
			18,
			16,
			32,
			"☰",
			23
		);


	guideMenuButton.setFormat(
		null,
		23,
		FlxColor.WHITE,
		"CENTER"
	);


	add(guideMenuButton);


	guideLogoText =
		new FlxText(
			60,
			15,
			150,
			"YouTube",
			25
		);


	guideLogoText.setFormat(
		null,
		25,
		FlxColor.WHITE,
		"LEFT"
	);


	add(guideLogoText);


	buildGuideContents();

	updateGuideMaximumScroll();

	updateGuideVisibility();
}


/* ============================================================
   BUILD GUIDE
   ============================================================ */

function buildGuideContents()
{
	clearGuideContents();


	var y:Float = 82;


	/* PRIMARY */

	addGuideItem(
		"Home",
		y,
		"home",
		100
	);

	y += 44;


	addGuideItem(
		"Shorts",
		y,
		"shorts",
		101
	);

	y += 44;


	addGuideItem(
		"Subscriptions",
		y,
		"subscriptions",
		102
	);

	y += 58;


	/* YOU */

	addGuideDivider(y);

	y += 16;


	addGuideItem(
		"You",
		y,
		"you",
		200
	);

	y += 44;


	addGuideItem(
		"Your channel",
		y,
		"channel",
		201
	);

	y += 42;


	addGuideItem(
		"History",
		y,
		"history",
		202
	);

	y += 42;


	addGuideItem(
		"Playlists",
		y,
		"playlists",
		203
	);

	y += 42;


	addGuideItem(
		"Watch later",
		y,
		"watchlater",
		204
	);

	y += 42;


	addGuideItem(
		"Liked videos",
		y,
		"liked",
		205
	);

	y += 42;


	addGuideItem(
		"Your videos",
		y,
		"videos",
		206
	);

	y += 42;


	addGuideItem(
		"Downloads",
		y,
		"downloads",
		207
	);

	y += 58;


	/* SUBSCRIPTIONS */

	addGuideDivider(y);

	y += 16;


	var sub =
		addGuideItem(
			"Subscriptions",
			y,
			"subscriptions-header",
			300
		);


	sub.arrow = true;

	sub.arrowDirection =
		guideSubscriptionsExpanded
		? "▼"
		: "▶";


	updateGuideArrow(sub);

	y += 44;


	if (guideSubscriptionsExpanded)
	{
		if (
			guideChannels.length ==
			0
		)
		{
			var empty =
				addGuideItem(
					"No subscriptions",
					y,
					"empty",
					390
				);


			empty.disabled = true;

			y += 42;
		}
		else
		{
			for (
				i in 0...guideChannels.length
			)
			{
				addGuideChannel(
					guideChannels[i],
					y,
					350 + i
				);

				y += 42;
			}
		}
	}


	var more =
		addGuideItem(
			guideSubscriptionsExpanded
			? "Show fewer"
			: "Show more",
			y,
			"more",
			301
		);


	more.arrow = true;

	more.arrowDirection =
		guideSubscriptionsExpanded
		? "▲"
		: "▼";


	updateGuideArrow(more);

	y += 58;


	/* EXPLORE */

	addGuideDivider(y);

	y += 16;


	var explore =
		addGuideItem(
			"Explore",
			y,
			"explore",
			400
		);


	explore.arrow = true;

	explore.arrowDirection =
		guideExploreExpanded
		? "▼"
		: "▶";


	updateGuideArrow(explore);

	y += 44;


	if (guideExploreExpanded)
	{
		addGuideItem(
			"Music",
			y,
			"music",
			401
		);

		y += 42;


		addGuideItem(
			"Gaming",
			y,
			"gaming",
			402
		);

		y += 42;


		addGuideItem(
			"Sports",
			y,
			"sports",
			403
		);

		y += 42;


		addGuideItem(
			"News",
			y,
			"news",
			404
		);

		y += 42;


		addGuideItem(
			"Live",
			y,
			"live",
			405
		);

		y += 42;
	}


	y += 16;


	/* MORE FROM YOUTUBE */

	addGuideDivider(y);

	y += 16;


	addGuideItem(
		"YouTube Premium",
		y,
		"premium",
		500
	);

	y += 42;


	addGuideItem(
		"YouTube Music",
		y,
		"ytmusic",
		501
	);

	y += 42;


	addGuideItem(
		"YouTube Kids",
		y,
		"kids",
		502
	);

	y += 58;


	/* OTHER */

	addGuideDivider(y);

	y += 16;


	addGuideItem(
		"Report history",
		y,
		"report",
		600
	);

	y += 42;


	addGuideItem(
		"Settings",
		y,
		"settings",
		601
	);

	y += 42;


	addGuideItem(
		"Send feedback",
		y,
		"feedback",
		602
	);

	y += 65;


	addGuideFooter(
		"About    Press    Copyright",
		y,
		700
	);

	y += 22;


	addGuideFooter(
		"Terms    Privacy    Policy",
		y,
		701
	);

	y += 22;


	addGuideFooter(
		"YouTube-style interface",
		y,
		702
	);
}


/* ============================================================
   GUIDE FOOTER
   ============================================================ */

function addGuideFooter(
	text:String,
	y:Float,
	id:Int
)
{
	var footer =
		new FlxText(
			18,
			y,
			220,
			text,
			10
		);


	footer.setFormat(
		null,
		10,
		FlxColor.fromRGB(
			150,
			150,
			150
		),
		"LEFT"
	);


	add(footer);


	guideItems.push(
		{
			id: id,
			type: "footer",
			background: footer
		}
	);
}


/* ============================================================
   CLEAR GUIDE
   ============================================================ */

function clearGuideContents()
{
	for (item in guideItems)
	{
		if (item == null)
			continue;


		if (item.background != null)
			remove(
				item.background,
				true
			);


		if (item.text != null)
			remove(
				item.text,
				true
			);


		if (item.icon != null)
			remove(
				item.icon,
				true
			);


		if (item.avatar != null)
			remove(
				item.avatar,
				true
			);


		if (item.arrowText != null)
			remove(
				item.arrowText,
				true
			);
	}


	guideItems = [];
}


/* ============================================================
   GUIDE ITEM
   ============================================================ */

function addGuideItem(
	title:String,
	y:Float,
	iconName:String,
	id:Int
):Dynamic
{
	var data:Dynamic = {};


	data.id = id;

	data.title = title;

	data.type = "item";

	data.disabled = false;

	data.arrow = false;

	data.arrowDirection = "";


	var bg =
		new FlxSprite(
			8,
			y
		);


	bg.makeGraphic(
		Std.int(
			guideWidth - 16
		),
		40,
		FlxColor.fromRGB(
			18,
			18,
			18
		)
	);


	add(bg);

	data.background = bg;


	var icon =
		new FlxText(
			18,
			y + 8,
			28,
			getGuideIcon(
				iconName
			),
			17
		);


	icon.setFormat(
		null,
		17,
		FlxColor.WHITE,
		"CENTER"
	);


	add(icon);

	data.icon = icon;


	var text =
		new FlxText(
			55,
			y + 10,
			guideWidth - 95,
			title,
			13
		);


	text.setFormat(
		null,
		13,
		FlxColor.WHITE,
		"LEFT"
	);


	add(text);

	data.text = text;


	var arrow =
		new FlxText(
			guideWidth - 45,
			y + 9,
			30,
			"",
			14
		);


	arrow.setFormat(
		null,
		14,
		FlxColor.fromRGB(
			180,
			180,
			180
		),
		"CENTER"
	);


	add(arrow);

	data.arrowText = arrow;


	guideItems.push(data);


	updateGuideArrow(data);


	return data;
}


/* ============================================================
   GUIDE CHANNEL
   ============================================================ */

function addGuideChannel(
	name:String,
	y:Float,
	id:Int
):Dynamic
{
	var data:Dynamic = {};


	data.id = id;

	data.title = name;

	data.type = "channel";

	data.disabled = false;


	var bg =
		new FlxSprite(
			8,
			y
		);


	bg.makeGraphic(
		Std.int(
			guideWidth - 16
		),
		40,
		FlxColor.fromRGB(
			18,
			18,
			18
		)
	);


	add(bg);

	data.background = bg;


	var avatar =
		new FlxSprite(
			18,
			y + 6
		);


	avatar.makeGraphic(
		28,
		28,
		FlxColor.fromRGB(
			55,
			55,
			55
		)
	);


	add(avatar);

	data.avatar = avatar;


	var text =
		new FlxText(
			58,
			y + 11,
			guideWidth - 75,
			name,
			12
		);


	text.setFormat(
		null,
		12,
		FlxColor.WHITE,
		"LEFT"
	);


	add(text);

	data.text = text;


	guideItems.push(data);


	return data;
}


/* ============================================================
   GUIDE DIVIDER
   ============================================================ */

function addGuideDivider(
	y:Float
)
{
	var line =
		new FlxSprite(
			18,
			y
		);


	line.makeGraphic(
		Std.int(
			guideWidth - 36
		),
		1,
		FlxColor.fromRGB(
			50,
			50,
			50
		)
	);


	add(line);


	guideItems.push(
		{
			id: -1,
			type: "divider",
			background: line
		}
	);
}


/* ============================================================
   GUIDE ICONS
   ============================================================ */

function getGuideIcon(
	iconName:String
):String
{
	switch (iconName)
	{
		case "home":
			return "⌂";

		case "shorts":
			return "▶";

		case "subscriptions":
		case "subscriptions-header":
			return "▣";

		case "you":
		case "channel":
			return "●";

		case "history":
			return "↶";

		case "playlists":
			return "☷";

		case "watchlater":
			return "◷";

		case "liked":
			return "♥";

		case "videos":
			return "▶";

		case "downloads":
			return "↓";

		case "music":
			return "♫";

		case "gaming":
			return "◆";

		case "sports":
			return "★";

		case "news":
			return "N";

		case "live":
			return "●";

		case "premium":
			return "▶";

		case "ytmusic":
			return "♫";

		case "kids":
			return "K";

		case "report":
			return "⚑";

		case "settings":
			return "⚙";

		case "feedback":
			return "!";

		case "explore":
			return "◇";

		default:
			return "•";
	}
}


/* ============================================================
   GUIDE ARROW
   ============================================================ */

function updateGuideArrow(
	item:Dynamic
)
{
	if (
		item == null ||
		item.arrowText == null
	)
		return;


	if (item.arrow == true)
	{
		item.arrowText.text =
			Std.string(
				item.arrowDirection
			);
	}
	else
	{
		item.arrowText.text = "";
	}
}


/* ============================================================
   GUIDE VISIBILITY
   ============================================================ */

function updateGuideVisibility()
{
	guidePanel.visible = true;

	guideLogoText.visible =
		guideOpen;


	for (item in guideItems)
	{
		if (item == null)
			continue;


		var visible:Bool =
			guideOpen;


		if (item.background != null)
			item.background.visible =
				visible;


		if (item.text != null)
			item.text.visible =
				visible;


		if (item.icon != null)
			item.icon.visible =
				visible;


		if (item.avatar != null)
			item.avatar.visible =
				visible;


		if (item.arrowText != null)
			item.arrowText.visible =
				visible;
	}
}


/* ============================================================
   GUIDE TOGGLE
   ============================================================ */

function toggleGuide()
{
	guideOpen =
		!guideOpen;

	updateGuideVisibility();

	saveYouTube();
}


/* ============================================================
   GUIDE SUBSCRIPTIONS
   ============================================================ */

function toggleGuideSubscriptions()
{
	guideSubscriptionsExpanded =
		!guideSubscriptionsExpanded;


	buildGuideContents();

	guideScroll = 0;

	guideTargetScroll = 0;

	updateGuideMaximumScroll();

	saveYouTube();
}


/* ============================================================
   GUIDE EXPLORE
   ============================================================ */

function toggleGuideExplore()
{
	guideExploreExpanded =
		!guideExploreExpanded;


	buildGuideContents();

	guideScroll = 0;

	guideTargetScroll = 0;

	updateGuideMaximumScroll();

	saveYouTube();
}


/* ============================================================
   GUIDE MAX SCROLL
   ============================================================ */

function updateGuideMaximumScroll()
{
	var lowest:Float = 0;


	for (item in guideItems)
	{
		if (
			item == null ||
			item.background == null
		)
			continue;


		var bottom:Float =
			item.background.y +
			item.background.height;


		if (bottom > lowest)
			lowest = bottom;
	}


	var available:Float =
		FlxG.height - 70;


	guideMaxScroll =
		Math.max(
			0,
			lowest -
			available +
			20
		);


	if (
		guideTargetScroll >
		guideMaxScroll
	)
	{
		guideTargetScroll =
			guideMaxScroll;
	}
}


/* ============================================================
   GUIDE SCROLL
   ============================================================ */

function updateGuideScroll()
{
	if (!guideOpen)
		return;


	if (
		FlxG.mouse.x >= 0 &&
		FlxG.mouse.x <= guideWidth &&
		FlxG.mouse.wheel != 0
	)
	{
		guideTargetScroll -=
			FlxG.mouse.wheel * 45;


		if (
			guideTargetScroll < 0
		)
		{
			guideTargetScroll = 0;
		}


		if (
			guideTargetScroll >
			guideMaxScroll
		)
		{
			guideTargetScroll =
				guideMaxScroll;
		}
	}


	var oldScroll:Float =
		guideScroll;


	guideScroll =
		FlxMath.lerp(
			guideScroll,
			guideTargetScroll,
			0.15
		);


	var delta:Float =
		guideScroll -
		oldScroll;


	if (
		Math.abs(delta) < 0.01
	)
		return;


	for (item in guideItems)
	{
		if (item == null)
			continue;


		if (item.background != null)
			item.background.y -= delta;


		if (item.text != null)
			item.text.y -= delta;


		if (item.icon != null)
			item.icon.y -= delta;


		if (item.avatar != null)
			item.avatar.y -= delta;


		if (item.arrowText != null)
			item.arrowText.y -= delta;
	}
}


/* ============================================================
   GUIDE HOVER
   ============================================================ */

function updateGuideHover()
{
	if (!guideOpen)
	{
		guideHovered = -1;

		return;
	}


	var mx:Float =
		FlxG.mouse.x;

	var my:Float =
		FlxG.mouse.y;


	guideHovered = -1;


	for (i in 0...guideItems.length)
	{
		var item =
			guideItems[i];


		if (
			item == null ||
			item.background == null
		)
			continue;


		if (
			item.type == "divider" ||
			item.type == "footer"
		)
			continue;


		if (
			mx >= item.background.x &&
			mx <=
				item.background.x +
				item.background.width &&
			my >= item.background.y &&
			my <=
				item.background.y +
				item.background.height
		)
		{
			guideHovered = i;

			break;
		}
	}


	for (i in 0...guideItems.length)
	{
		var item =
			guideItems[i];


		if (
			item == null ||
			item.background == null
		)
			continue;


		if (
			item.type == "divider" ||
			item.type == "footer"
		)
			continue;


		if (i == guideHovered)
		{
			item.background.color =
				FlxColor.fromRGB(
					45,
					45,
					45
				);
		}
		else
		{
			item.background.color =
				FlxColor.fromRGB(
					18,
					18,
					18
				);
		}
	}
}


/* ============================================================
   GUIDE CLICK
   ============================================================ */

function handleGuideClick()
{
	if (!guideOpen)
		return;


	var mx:Float =
		FlxG.mouse.x;

	var my:Float =
		FlxG.mouse.y;


	for (item in guideItems)
	{
		if (
			item == null ||
			item.background == null
		)
			continue;


		if (
			item.type == "divider" ||
			item.type == "footer"
		)
			continue;


		if (
			mx >= item.background.x &&
			mx <=
				item.background.x +
				item.background.width &&
			my >= item.background.y &&
			my <=
				item.background.y +
				item.background.height
		)
		{
			if (item.disabled == true)
				return;


			if (
				item.id == 300 ||
				item.id == 301
			)
			{
				toggleGuideSubscriptions();

				return;
			}


			if (item.id == 400)
			{
				toggleGuideExplore();

				return;
			}


			openGuidePage(
				Std.string(
					item.title
				),
				true
			);

			return;
		}
	}
}


/* ============================================================
   PAGE SYSTEM
   ============================================================ */

function createPageSystem()
{
	pageBackground =
		new FlxSprite(
			guideWidth,
			70
		);


	pageBackground.makeGraphic(
		Std.int(
			FlxG.width -
			guideWidth
		),
		Std.int(
			FlxG.height -
			70
		),
		FlxColor.fromRGB(
			15,
			15,
			15
		)
	);


	add(pageBackground);


	pageAccent =
		new FlxSprite(
			guideWidth,
			70
		);


	pageAccent.makeGraphic(
		4,
		FlxG.height -
		70,
		FlxColor.RED
	);


	add(pageAccent);


	pageTitle =
		new FlxText(
			gridX,
			100,
			750,
			"",
			30
		);


	pageTitle.setFormat(
		null,
		30,
		FlxColor.WHITE,
		"LEFT"
	);


	add(pageTitle);


	pageSubtitle =
		new FlxText(
			gridX,
			145,
			750,
			"",
			14
		);


	pageSubtitle.setFormat(
		null,
		14,
		FlxColor.fromRGB(
			150,
			150,
			150
		),
		"LEFT"
	);


	add(pageSubtitle);
}


/* ============================================================
   PAGE VISIBILITY
   ============================================================ */

function setHomeVisible(
	value:Bool
)
{
	for (obj in cards)
		if (obj != null)
			obj.visible = value;


	for (obj in thumbnails)
		if (obj != null)
			obj.visible = value;


	for (obj in titleTexts)
		if (obj != null)
			obj.visible = value;


	for (obj in channelTexts)
		if (obj != null)
			obj.visible = value;


	for (obj in metadataTexts)
		if (obj != null)
			obj.visible = value;


	for (obj in durationTexts)
		if (obj != null)
			obj.visible = value;


	for (obj in progressBars)
		if (obj != null)
			obj.visible = value;


	for (obj in playButtons)
		if (obj != null)
			obj.visible = value;


	for (obj in playButtonTexts)
		if (obj != null)
			obj.visible = value;


	for (obj in cardLikes)
		if (obj != null)
			obj.visible = value;


	for (obj in cardSubscribeButtons)
		if (obj != null)
			obj.visible = value;


	for (obj in cardSubscribeTexts)
		if (obj != null)
			obj.visible = value;


	sectionText.visible = value;

	songCounter.visible = value;


	noResultsText.visible =
		value &&
		songs.length == 0;
}


/* ============================================================
   CLEAR PAGE
   ============================================================ */

function clearPageContent()
{
	for (obj in pageContent)
	{
		if (obj != null)
			remove(
				obj,
				true
			);
	}


	pageContent = [];
}


/* ============================================================
   ADD PAGE OBJECT
   ============================================================ */

function addPageObject(
	obj:Dynamic
)
{
	if (obj == null)
		return;


	add(obj);

	pageContent.push(
		obj
	);
}


/* ============================================================
   OPEN PAGE
   ============================================================ */

function openGuidePage(
	title:String,
	animated:Bool = true
)
{
	previousGuidePage =
		currentGuidePage;


	currentGuidePage =
		title;


	clearPageContent();


	var home:Bool =
		title == "Home";


	setHomeVisible(
		home
	);


	sectionText.visible =
		home;


	songCounter.visible =
		home;


	switch (title)
	{
		case "Home":
			createHomePage();


		case "Shorts":
			createShortsPage();


		case "Subscriptions":
			createSubscriptionsPage();


		case "Your channel":
			createYourChannelPage();


		case "History":
			createHistoryPage();


		case "Playlists":
			createPlaylistsPage();


		case "Watch later":
			createWatchLaterPage();


		case "Liked videos":
			createLikedPage();


		case "Your videos":
			createYourVideosPage();


		case "Downloads":
			createDownloadsPage();


		case "Music":
			createMusicPage();


		case "Gaming":
			createGamingPage();


		case "Sports":
			createSportsPage();


		case "News":
			createNewsPage();


		case "Live":
			createLivePage();


		case "YouTube Premium":
			createPremiumPage();


		case "YouTube Music":
			createYouTubeMusicPage();


		case "YouTube Kids":
			createKidsPage();


		case "Report history":
			createReportPage();


		case "Settings":
			createSettingsPage();


		case "Send feedback":
			createFeedbackPage();


		default:
			createSimplePage(
				"Page not found",
				"This page does not exist."
			);
	}


	updatePageBackground();


	if (animated)
	{
		pageTransition = true;

		pageTransitionTime = 0;

		pageBackground.alpha = 0;

		pageTitle.alpha = 0;

		pageSubtitle.alpha = 0;


		for (obj in pageContent)
		{
			if (obj != null)
				obj.alpha = 0;
		}
	}
	else
	{
		pageBackground.alpha = 1;

		pageTitle.alpha = 1;

		pageSubtitle.alpha = 1;


		for (obj in pageContent)
		{
			if (obj != null)
				obj.alpha = 1;
		}
	}


	saveYouTube();
}


/* ============================================================
   PAGE BACKGROUND
   ============================================================ */

function updatePageBackground()
{
	var color:Int =
		FlxColor.fromRGB(
			15,
			15,
			15
		);


	switch (currentGuidePage)
	{
		case "Home":
			color =
				FlxColor.fromRGB(
					15,
					15,
					15
				);


		case "Shorts":
			color =
				FlxColor.fromRGB(
					28,
					15,
					28
				);


		case "Subscriptions":
			color =
				FlxColor.fromRGB(
					15,
					22,
					30
				);


		case "Your channel":
			color =
				FlxColor.fromRGB(
					20,
					20,
					20
				);


		case "History":
			color =
				FlxColor.fromRGB(
					28,
					25,
					15
				);


		case "Playlists":
			color =
				FlxColor.fromRGB(
					15,
					28,
					20
				);


		case "Watch later":
			color =
				FlxColor.fromRGB(
					18,
					20,
					30
				);


		case "Liked videos":
			color =
				FlxColor.fromRGB(
					32,
					15,
					18
				);


		case "Music":
			color =
				FlxColor.fromRGB(
					30,
					15,
					30
				);


		case "Gaming":
			color =
				FlxColor.fromRGB(
					10,
					20,
					36
				);


		case "Sports":
			color =
				FlxColor.fromRGB(
					15,
					30,
					15
				);


		case "News":
			color =
				FlxColor.fromRGB(
					25,
					25,
					32
				);


		case "Live":
			color =
				FlxColor.fromRGB(
					36,
					15,
					15
				);


		case "Settings":
			color =
				FlxColor.fromRGB(
					22,
					22,
					22
				);
	}


	pageBackground.color =
		color;


	pageAccent.color =
		FlxColor.RED;
}


/* ============================================================
   PAGE TRANSITION
   ============================================================ */

function updatePageTransition(
	elapsed:Float
)
{
	if (!pageTransition)
		return;


	pageTransitionTime +=
		elapsed;


	var progress:Float =
		pageTransitionTime /
		pageTransitionDuration;


	if (progress > 1)
		progress = 1;


	pageBackground.alpha =
		progress;


	pageTitle.alpha =
		progress;


	pageSubtitle.alpha =
		progress;


	for (obj in pageContent)
	{
		if (obj != null)
			obj.alpha = progress;
	}


	if (progress >= 1)
	{
		pageTransition = false;
	}
}


/* ============================================================
   PAGE CONTENT
   ============================================================ */

function createHomePage()
{
	pageTitle.text = "";

	pageSubtitle.text = "";


	if (cards.length > 0)
	{
		updateSelection();

		updateCardPositions();
	}
}


function createShortsPage()
{
	pageTitle.text =
		"Shorts";

	pageSubtitle.text =
		"Short Friday Night Funkin' videos";


	var count:Int =
		Math.min(
			songs.length,
			8
		);


	for (i in 0...count)
	{
		var x:Float =
			gridX +
			(i % 4) * 170;


		var y:Float =
			200 +
			Std.int(i / 4) * 220;


		var box =
			new FlxSprite(
				x,
				y
			);


		box.makeGraphic(
			150,
			180,
			FlxColor.fromRGB(
				28,
				28,
				28
			)
		);


		addPageObject(box);


		var text =
			new FlxText(
				x + 8,
				y + 190,
				145,
				getDisplayName(i),
				12
			);


		text.setFormat(
			null,
			12,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(text);
	}
}


function createSubscriptionsPage()
{
	pageTitle.text =
		"Subscriptions";

	pageSubtitle.text =
		"Your subscribed channels";


	if (
		savedSubscriptions.length == 0
	)
	{
		createSimplePage(
			"Subscriptions",
			"No subscriptions yet."
		);

		return;
	}


	for (
		i in 0...savedSubscriptions.length
	)
	{
		var row =
			new FlxText(
				gridX,
				200 + i * 55,
				700,
				savedSubscriptions[i],
				17
			);


		row.setFormat(
			null,
			17,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(row);
	}
}


function createYourChannelPage()
{
	pageTitle.text =
		"Your channel";

	pageSubtitle.text =
		"Friday Night Funkin'";


	var avatar =
		new FlxSprite(
			gridX,
			205
		);


	avatar.makeGraphic(
		100,
		100,
		FlxColor.fromRGB(
			55,
			55,
			55
		)
	);


	addPageObject(avatar);


	var name =
		new FlxText(
			gridX + 125,
			210,
			500,
			"Your channel",
			24
		);


	name.setFormat(
		null,
		24,
		FlxColor.WHITE,
		"LEFT"
	);


	addPageObject(name);


	var info =
		new FlxText(
			gridX + 125,
			250,
			500,
			"Friday Night Funkin'",
			14
		);


	info.setFormat(
		null,
		14,
		FlxColor.fromRGB(
			150,
			150,
			150
		),
		"LEFT"
	);


	addPageObject(info);
}


function createHistoryPage()
{
	pageTitle.text =
		"History";

	pageSubtitle.text =
		"Recently played songs";


	if (
		historySongs.length == 0
	)
	{
		createSimplePage(
			"History",
			"Your history is empty."
		);

		return;
	}


	for (i in 0...historySongs.length)
	{
		var row =
			new FlxText(
				gridX,
				200 + i * 42,
				700,
				(i + 1) +
				". " +
				historySongs[i],
				15
			);


		row.setFormat(
			null,
			15,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(row);
	}
}


function createPlaylistsPage()
{
	pageTitle.text =
		"Playlists";

	pageSubtitle.text =
		"Your saved playlist";


	if (
		playlistSongs.length == 0
	)
	{
		createSimplePage(
			"Playlists",
			"No saved songs yet."
		);

		return;
	}


	for (i in 0...playlistSongs.length)
	{
		var row =
			new FlxText(
				gridX,
				200 + i * 42,
				700,
				playlistSongs[i],
				15
			);


		row.setFormat(
			null,
			15,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(row);
	}
}


function createWatchLaterPage()
{
	pageTitle.text =
		"Watch later";

	pageSubtitle.text =
		"Songs saved for later";


	if (
		watchLaterSongs.length == 0
	)
	{
		createSimplePage(
			"Watch later",
			"Nothing saved for later."
		);

		return;
	}


	for (i in 0...watchLaterSongs.length)
	{
		var row =
			new FlxText(
				gridX,
				200 + i * 42,
				700,
				watchLaterSongs[i],
				15
			);


		row.setFormat(
			null,
			15,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(row);
	}
}


function createLikedPage()
{
	pageTitle.text =
		"Liked videos";

	pageSubtitle.text =
		"Songs you liked";


	if (
		likedSongs.length == 0
	)
	{
		createSimplePage(
			"Liked videos",
			"You haven't liked any songs."
		);

		return;
	}


	for (i in 0...likedSongs.length)
	{
		var row =
			new FlxText(
				gridX,
				200 + i * 42,
				700,
				likedSongs[i],
				15
			);


		row.setFormat(
			null,
			15,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(row);
	}
}


function createYourVideosPage()
{
	pageTitle.text =
		"Your videos";

	pageSubtitle.text =
		"Your uploaded content";


	createSimplePage(
		"Your videos",
		"No uploaded videos."
	);
}


function createDownloadsPage()
{
	pageTitle.text =
		"Downloads";

	pageSubtitle.text =
		"Downloaded songs";


	if (
		watchLaterSongs.length == 0
	)
	{
		createSimplePage(
			"Downloads",
			"No downloads."
		);

		return;
	}


	for (i in 0...watchLaterSongs.length)
	{
		var row =
			new FlxText(
				gridX,
				200 + i * 42,
				700,
				watchLaterSongs[i],
				15
			);


		row.setFormat(
			null,
			15,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(row);
	}
}


function createMusicPage()
{
	pageTitle.text =
		"Music";

	pageSubtitle.text =
		"Friday Night Funkin' music";


	createCategoryPage(
		"Music"
	);
}


function createGamingPage()
{
	pageTitle.text =
		"Gaming";

	pageSubtitle.text =
		"Friday Night Funkin' gaming";


	createCategoryPage(
		"Gaming"
	);
}


function createSportsPage()
{
	pageTitle.text =
		"Sports";

	pageSubtitle.text =
		"Gaming competitions";


	createSimplePage(
		"Sports",
		"No sports content."
	);
}


function createNewsPage()
{
	pageTitle.text =
		"News";

	pageSubtitle.text =
		"Game news";


	createSimplePage(
		"News",
		"No news available."
	);
}


function createLivePage()
{
	pageTitle.text =
		"Live";

	pageSubtitle.text =
		"Live FNF content";


	createSimplePage(
		"Live",
		"No live streams."
	);
}


function createPremiumPage()
{
	pageTitle.text =
		"YouTube Premium";

	pageSubtitle.text =
		"Premium experience";


	createSimplePage(
		"YouTube Premium",
		"Premium."
	);
}


function createYouTubeMusicPage()
{
	pageTitle.text =
		"YouTube Music";

	pageSubtitle.text =
		"Music experience";


	createCategoryPage(
		"YouTube Music"
	);
}


function createKidsPage()
{
	pageTitle.text =
		"YouTube Kids";

	pageSubtitle.text =
		"Kids content";


	createSimplePage(
		"YouTube Kids",
		"No kids content."
	);
}


function createReportPage()
{
	pageTitle.text =
		"Report history";

	pageSubtitle.text =
		"Your reports";


	createSimplePage(
		"Report history",
		"No reports."
	);
}


function createSettingsPage()
{
	pageTitle.text =
		"Settings";

	pageSubtitle.text =
		"YouTubeMadness";


	var settings:Array<String> =
	[
		"Playback",
		"Appearance",
		"Notifications",
		"Privacy",
		"Keyboard",
		"Language"
	];


	for (i in 0...settings.length)
	{
		var row =
			new FlxText(
				gridX,
				200 + i * 52,
				500,
				settings[i],
				16
			);


		row.setFormat(
			null,
			16,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(row);
	}
}


function createFeedbackPage()
{
	pageTitle.text =
		"Send feedback";

	pageSubtitle.text =
		"Help improve YouTubeMadness";


	createSimplePage(
		"Send feedback",
		"Feedback system."
	);
}


function createSimplePage(
	title:String,
	description:String
)
{
	pageTitle.text =
		title;

	pageSubtitle.text =
		description;
}


function createCategoryPage(
	category:String
)
{
	var count:Int =
		Math.min(
			songs.length,
			9
		);


	if (count == 0)
	{
		createSimplePage(
			category,
			"No content."
		);

		return;
	}


	for (i in 0...count)
	{
		var col:Int =
			i % 3;


		var row:Int =
			Std.int(
				i / 3
			);


		var x:Float =
			gridX +
			col * 225;


		var y:Float =
			200 +
			row * 145;


		var box =
			new FlxSprite(
				x,
				y
			);


		box.makeGraphic(
			205,
			105,
			FlxColor.fromRGB(
				28,
				28,
				28
			)
		);


		addPageObject(box);


		var text =
			new FlxText(
				x,
				y + 115,
				205,
				getDisplayName(i),
				13
			);


		text.setFormat(
			null,
			13,
			FlxColor.WHITE,
			"LEFT"
		);


		addPageObject(text);
	}
}


/* ============================================================
   PAGE UPDATE
   ============================================================ */

function updatePageTransition(
	elapsed:Float
)
{
	if (!pageTransition)
		return;


	pageTransitionTime +=
		elapsed;


	var progress:Float =
		pageTransitionTime /
		pageTransitionDuration;


	if (progress > 1)
		progress = 1;


	pageBackground.alpha =
		progress;


	pageTitle.alpha =
		progress;


	pageSubtitle.alpha =
		progress;


	for (obj in pageContent)
	{
		if (obj != null)
			obj.alpha = progress;
	}


	if (progress >= 1)
		pageTransition = false;
}


/* ============================================================
   CARD LOAD
   ============================================================ */

function startSongLoading()
{
	if (
		selectedAnimating ||
		loadingActive ||
		songs.length == 0 ||
		currentGuidePage != "Home"
	)
		return;


	selectedAnimating = true;


	var card =
		cards[selectedIndex];


	loadingCenterX =
		card.x +
		card.width / 2;


	loadingCenterY =
		card.y +
		thumbnailHeight / 2;


	loadingCenterX =
		Math.max(
			gridX + 40,
			Math.min(
				loadingCenterX,
				FlxG.width - 40
			)
		);


	loadingCenterY =
		Math.max(
			100,
			Math.min(
				loadingCenterY,
				FlxG.height - 70
			)
		);


	createLoadingRing();
}


function createLoadingRing()
{
	destroyLoadingRing();


	loadingRing = [];


	var segments:Int = 12;

	var radius:Float = 30;


	for (i in 0...segments)
	{
		var segment =
			new FlxSprite();


		segment.makeGraphic(
			6,
			16,
			FlxColor.WHITE
		);


		segment.origin.set(
			3,
			3
		);


		var alphaValue:Float =
			0.15 +
			(
				i /
				segments
			) *
			0.85;


		segment.alpha =
			alphaValue;


		add(segment);


		loadingRing.push(
			segment
		);
	}


	loadingActive = true;

	loadingTime = 0;

	loadingAngle = 0;
}


function updateLoadingRing(
	elapsed:Float
)
{
	if (!loadingActive)
		return;


	loadingTime +=
		elapsed;


	loadingAngle +=
		elapsed * 300;


	var segments:Int =
		loadingRing.length;


	var radius:Float = 30;


	for (i in 0...segments)
	{
		var angle:Float =
			(
				i *
				(
					360 /
					segments
				)
			) +
			loadingAngle;


		var radians:Float =
			angle *
			Math.PI /
			180;


		loadingRing[i].x =
			loadingCenterX +
			Math.cos(
				radians
			) *
			radius -
			3;


		loadingRing[i].y =
			loadingCenterY +
			Math.sin(
				radians
			) *
			radius -
			3;


		loadingRing[i].angle =
			angle +
			90;
	}


	if (
		loadingTime >=
		loadingDuration
	)
	{
		loadingActive = false;

		finishSongLoading();
	}
}


function destroyLoadingRing()
{
	if (loadingRing == null)
	{
		loadingRing = [];

		return;
	}


	for (obj in loadingRing)
	{
		if (obj != null)
			remove(
				obj,
				true
			);
	}


	loadingRing = [];
}


function updateSelectedAnimation()
{
	if (!selectedAnimating)
		return;


	if (
		selectedIndex < 0 ||
		selectedIndex >= cards.length
	)
		return;


	var card =
		cards[selectedIndex];


	card.scale.x =
		FlxMath.lerp(
			card.scale.x,
			1.10,
			0.18
		);


	card.scale.y =
		FlxMath.lerp(
			card.scale.y,
			1.10,
			0.18
		);


	var targetX:Float =
		gridX +
		(
			cardWidth -
			cardWidth * 1.10
		) / 2;


	var targetY:Float =
		gridY +
		(
			cardHeight -
			cardHeight * 1.10
		) / 2 -
		currentScroll;


	card.x =
		FlxMath.lerp(
			card.x,
			targetX,
			0.18
		);


	card.y =
		FlxMath.lerp(
			card.y,
			targetY,
			0.18
		);
}


function finishSongLoading()
{
	destroyLoadingRing();


	selectedAnimating = false;


	if (
		selectedIndex >= 0 &&
		selectedIndex < cards.length
	)
	{
		cards[selectedIndex].scale.set(
			1,
			1
		);
	}


	openSelectedSong();
}


/* ============================================================
   CARD ACTION STATES
   ============================================================ */

function getSongInternalName(
	index:Int
):String
{
	if (
		index < 0 ||
		index >= songs.length
	)
		return "";


	return Std.string(
		Reflect.field(
			songs[index],
			"name"
		)
	);
}


function isSongLiked(
	songName:String
):Bool
{
	return likedSongs.indexOf(
		songName
	) >= 0;
}


function isSubscribed(
	channelName:String
):Bool
{
	return savedSubscriptions.indexOf(
		channelName
	) >= 0;
}


function updateCardActions()
{
	for (i in 0...cards.length)
	{
		var songName:String =
			getSongInternalName(i);


		if (
			isSongLiked(songName)
		)
		{
			cardLikes[i].text =
				"♥ Liked";

			cardLikes[i].color =
				FlxColor.RED;
		}
		else
		{
			cardLikes[i].text =
				"♡ Like";

			cardLikes[i].color =
				FlxColor.WHITE;
		}


		var channel:String =
			"Friday Night Funkin'";


		if (
			isSubscribed(channel)
		)
		{
			cardSubscribeButtons[i].color =
				FlxColor.fromRGB(
					60,
					60,
					60
				);


			cardSubscribeTexts[i].text =
				"SUBSCRIBED";
		}
		else
		{
			cardSubscribeButtons[i].color =
				FlxColor.RED;


			cardSubscribeTexts[i].text =
				"SUBSCRIBE";
		}
	}
}


/* ============================================================
   LIKE
   ============================================================ */

function likeSong(
	songName:String
)
{
	if (
		likedSongs.indexOf(
			songName
		) < 0
	)
	{
		likedSongs.push(
			songName
		);
	}
	else
	{
		likedSongs.remove(
			songName
		);
	}


	saveYouTube();
}


/* ============================================================
   WATCH LATER
   ============================================================ */

function toggleWatchLater(
	songName:String
)
{
	if (
		watchLaterSongs.indexOf(
			songName
		) < 0
	)
	{
		watchLaterSongs.push(
			songName
		);
	}
	else
	{
		watchLaterSongs.remove(
			songName
		);
	}


	saveYouTube();
}


/* ============================================================
   PLAYLIST
   ============================================================ */

function togglePlaylistSong(
	songName:String
)
{
	if (
		playlistSongs.indexOf(
			songName
		) < 0
	)
	{
		playlistSongs.push(
			songName
		);
	}
	else
	{
		playlistSongs.remove(
			songName
		);
	}


	saveYouTube();
}


/* ============================================================
   SUBSCRIBE
   ============================================================ */

function toggleSubscription(
	channelName:String
)
{
	if (
		savedSubscriptions.indexOf(
			channelName
		) < 0
	)
	{
		savedSubscriptions.push(
			channelName
		);
	}
	else
	{
		savedSubscriptions.remove(
			channelName
		);
	}


	saveYouTube();
}


/* ============================================================
   BUILD HOME CARDS
   ============================================================ */

function buildCards()
{
	clearCards();


	for (i in 0...songs.length)
	{
		var column:Int =
			i % columns;


		var row:Int =
			Std.int(
				i /
				columns
			);


		var x:Float =
			gridX +
			column *
			(
				cardWidth +
				gapX
			);


		var y:Float =
			gridY +
			row *
			(
				cardHeight +
				gapY
			);


		/* CARD */

		var card =
			new FlxSprite(
				x,
				y
			);


		card.makeGraphic(
			Std.int(
				cardWidth
			),
			Std.int(
				cardHeight
			),
			FlxColor.fromRGB(
				25,
				25,
				25
			)
		);


		card.ID = i;


		add(card);

		cards.push(card);


		/* THUMB */

		var thumb =
			new HealthIcon(
				getIcon(i)
			);


		if (
			Math.max(
				thumb.width,
				thumb.height
			) > 150
		)
		{
			thumb.setUnstretchedGraphicSize(
				150,
				150
			);
		}


		thumb.updateHitbox();


		thumb.x =
			x +
			(
				thumbnailWidth -
				thumb.width
			) / 2;


		thumb.y =
			y +
			(
				thumbnailHeight -
				thumb.height
			) / 2;


		thumb.ID = i;


		add(thumb);

		thumbnails.push(thumb);


		/* PROGRESS */

		var progress =
			new FlxSprite(
				x,
				y +
				thumbnailHeight -
				4
			);


		progress.makeGraphic(
			Std.int(
				thumbnailWidth
			),
			4,
			FlxColor.fromRGB(
				80,
				0,
				0
			)
		);


		progress.ID = i;


		add(progress);

		progressBars.push(progress);


		/* DURATION */

		var duration =
			new FlxText(
				x +
				thumbnailWidth -
				60,
				y +
				thumbnailHeight -
				27,
				52,
				getDuration(i),
				12
			);


		duration.setFormat(
			null,
			12,
			FlxColor.WHITE,
			"RIGHT"
		);


		duration.ID = i;


		add(duration);

		durationTexts.push(duration);


		/* TITLE */

		var title =
			new FlxText(
				x,
				y +
				thumbnailHeight +
				9,
				cardWidth,
				getDisplayName(i),
				17
			);


		title.setFormat(
			null,
			17,
			FlxColor.WHITE,
			"LEFT"
		);


		title.ID = i;


		add(title);

		titleTexts.push(title);


		/* CHANNEL */

		var channel =
			new FlxText(
				x,
				y +
				thumbnailHeight +
				37,
				cardWidth,
				"Friday Night Funkin'",
				13
			);


		channel.setFormat(
			null,
			13,
			FlxColor.fromRGB(
				155,
				155,
				155
			),
			"LEFT"
		);


		channel.ID = i;


		add(channel);

		channelTexts.push(channel);


		/* META */

		var meta =
			new FlxText(
				x,
				y +
				thumbnailHeight +
				58,
				cardWidth,
				getMetadata(i),
				12
			);


		meta.setFormat(
			null,
			12,
			FlxColor.fromRGB(
				120,
				120,
				120
			),
			"LEFT"
		);


		meta.ID = i;


		add(meta);

		metadataTexts.push(meta);


		/* PLAY */

		var play =
			new FlxSprite(
				x + 250,
				y + 115
			);


		play.makeGraphic(
			42,
			42,
			FlxColor.fromRGB(
				210,
				0,
				0
			)
		);


		play.alpha = 0;

		play.ID = i;


		add(play);

		playButtons.push(play);


		var playText =
			new FlxText(
				play.x,
				play.y + 7,
				42,
				">",
				24
			);


		playText.setFormat(
			null,
			24,
			FlxColor.WHITE,
			"CENTER"
		);


		playText.alpha = 0;

		playText.ID = i;


		add(playText);

		playButtonTexts.push(
			playText
		);


		/* LIKE */

		var like =
			new FlxText(
				x + 10,
				y + 111,
				90,
				"",
				12
			);


		like.setFormat(
			null,
			12,
			FlxColor.WHITE,
			"LEFT"
		);


		like.alpha = 0;


		like.ID = i;


		add(like);

		cardLikes.push(like);


		/* SUBSCRIBE */

		var subscribe =
			new FlxSprite(
				x + 10,
				y + 140
			);


		subscribe.makeGraphic(
			105,
			30,
			FlxColor.RED
		);


		subscribe.alpha = 0;

		subscribe.ID = i;


		add(subscribe);

		cardSubscribeButtons.push(
			subscribe
		);


		var subscribeText =
			new FlxText(
				subscribe.x,
				subscribe.y + 7,
				105,
				"",
				10
			);


		subscribeText.setFormat(
			null,
			10,
			FlxColor.WHITE,
			"CENTER"
		);


		subscribeText.alpha = 0;

		subscribeText.ID = i;


		add(subscribeText);

		cardSubscribeTexts.push(
			subscribeText
		);
	}


	updateCardActions();
}


/* ============================================================
   CLEAR CARDS
   ============================================================ */

function clearCards()
{
	for (obj in cards)
		remove(obj, true);


	for (obj in thumbnails)
		remove(obj, true);


	for (obj in titleTexts)
		remove(obj, true);


	for (obj in channelTexts)
		remove(obj, true);


	for (obj in metadataTexts)
		remove(obj, true);


	for (obj in durationTexts)
		remove(obj, true);


	for (obj in progressBars)
		remove(obj, true);


	for (obj in playButtons)
		remove(obj, true);


	for (obj in playButtonTexts)
		remove(obj, true);


	for (obj in cardLikes)
		remove(obj, true);


	for (obj in cardSubscribeButtons)
		remove(obj, true);


	for (obj in cardSubscribeTexts)
		remove(obj, true);


	cards = [];

	thumbnails = [];

	titleTexts = [];

	channelTexts = [];

	metadataTexts = [];

	durationTexts = [];

	progressBars = [];

	playButtons = [];

	playButtonTexts = [];

	cardLikes = [];

	cardSubscribeButtons = [];

	cardSubscribeTexts = [];
}


/* ============================================================
   HOME SCROLL
   ============================================================ */

function updateMaximumScroll()
{
	var rows:Int =
		Std.int(
			Math.ceil(
				songs.length /
				columns
			)
		);


	var contentHeight:Float =
		rows *
		(
			cardHeight +
			gapY
		);


	var availableHeight:Float =
		FlxG.height -
		gridY -
		40;


	maxScroll =
		Math.max(
			0,
			contentHeight -
			availableHeight
		);
}


function clampScroll()
{
	if (targetScroll < 0)
		targetScroll = 0;


	if (targetScroll > maxScroll)
		targetScroll = maxScroll;
}


/* ============================================================
   CARD POSITIONS
   ============================================================ */

function updateCardPositions()
{
	for (i in 0...cards.length)
	{
		var column:Int =
			i % columns;


		var row:Int =
			Std.int(
				i /
				columns
			);


		var baseX:Float =
			gridX +
			column *
			(
				cardWidth +
				gapX
			);


		var baseY:Float =
			gridY +
			row *
			(
				cardHeight +
				gapY
			);


		var y:Float =
			baseY -
			currentScroll;


		if (
			!(
				selectedAnimating &&
				i == selectedIndex
			)
		)
		{
			cards[i].x =
				FlxMath.lerp(
					cards[i].x,
					baseX,
					0.25
				);


			cards[i].y =
				FlxMath.lerp(
					cards[i].y,
					y,
					0.25
				);
		}


		var thumb =
			thumbnails[i];


		thumb.x =
			cards[i].x +
			(
				thumbnailWidth -
				thumb.width
			) / 2;


		thumb.y =
			cards[i].y +
			(
				thumbnailHeight -
				thumb.height
			) / 2;


		progressBars[i].x =
			cards[i].x;


		progressBars[i].y =
			cards[i].y +
			thumbnailHeight -
			4;


		durationTexts[i].x =
			cards[i].x +
			thumbnailWidth -
			60;


		durationTexts[i].y =
			cards[i].y +
			thumbnailHeight -
			27;


		titleTexts[i].x =
			cards[i].x;


		titleTexts[i].y =
			cards[i].y +
			thumbnailHeight +
			9;


		channelTexts[i].x =
			cards[i].x;


		channelTexts[i].y =
			cards[i].y +
			thumbnailHeight +
			37;


		metadataTexts[i].x =
			cards[i].x;


		metadataTexts[i].y =
			cards[i].y +
			thumbnailHeight +
			58;


		playButtons[i].x =
			cards[i].x +
			250;


		playButtons[i].y =
			cards[i].y +
			115;


		playButtonTexts[i].x =
			playButtons[i].x;


		playButtonTexts[i].y =
			playButtons[i].y +
			7;


		cardLikes[i].x =
			cards[i].x +
			10;


		cardLikes[i].y =
			cards[i].y +
			111;


		cardSubscribeButtons[i].x =
			cards[i].x +
			10;


		cardSubscribeButtons[i].y =
			cards[i].y +
			140;


		cardSubscribeTexts[i].x =
			cardSubscribeButtons[i].x;


		cardSubscribeTexts[i].y =
			cardSubscribeButtons[i].y +
			7;
	}
}


/* ============================================================
   SELECTION
   ============================================================ */

function moveSelection(
	amount:Int
)
{
	if (
		currentGuidePage != "Home" ||
		songs.length == 0 ||
		selectedAnimating
	)
		return;


	selectedIndex += amount;


	if (selectedIndex < 0)
		selectedIndex =
			songs.length - 1;


	if (
		selectedIndex >=
		songs.length
	)
	{
		selectedIndex = 0;
	}


	scrollToSelected();

	updateSelection();


	try
	{
		CoolUtil.playMenuSFX(
			SCROLL,
			0.65
		);
	}
	catch (e:Dynamic)
	{
	}
}


function scrollToSelected()
{
	var row:Int =
		Std.int(
			selectedIndex /
			columns
		);


	var rowTop:Float =
		row *
		(
			cardHeight +
			gapY
		);


	var rowBottom:Float =
		rowTop +
		cardHeight;


	var viewHeight:Float =
		FlxG.height -
		gridY -
		40;


	if (
		rowTop <
		targetScroll
	)
	{
		targetScroll =
			rowTop;
	}


	if (
		rowBottom >
		targetScroll +
		viewHeight
	)
	{
		targetScroll =
			rowBottom -
			viewHeight;
	}


	clampScroll();
}


function updateSelection()
{
	for (i in 0...cards.length)
	{
		var selected:Bool =
			i == selectedIndex;


		if (selected)
		{
			cards[i].color =
				FlxColor.fromRGB(
					55,
					55,
					55
				);


			titleTexts[i].color =
				FlxColor.WHITE;


			titleTexts[i].size =
				19;


			progressBars[i].color =
				FlxColor.RED;
		}
		else
		{
			cards[i].color =
				FlxColor.WHITE;


			titleTexts[i].color =
				FlxColor.fromRGB(
					210,
					210,
					210
				);


			titleTexts[i].size =
				17;


			progressBars[i].color =
				FlxColor.fromRGB(
					80,
					0,
					0
				);
		}
	}


	if (songs.length > 0)
	{
		sectionText.text =
			getDisplayName(
				selectedIndex
			);


		songCounter.text =
			(selectedIndex + 1) +
			" / " +
			songs.length;
	}
	else
	{
		sectionText.text =
			"Friday Night Funkin'";


		songCounter.text =
			"0 / 0";
	}


	updateCardActions();
}


/* ============================================================
   HOME MOUSE
   ============================================================ */

function updateMouse()
{
	var mx:Float =
		FlxG.mouse.x;


	var my:Float =
		FlxG.mouse.y;


	hoveredIndex = -1;


	for (i in 0...cards.length)
	{
		var card =
			cards[i];


		if (
			mx >= card.x &&
			mx <=
				card.x +
				cardWidth &&
			my >= card.y &&
			my <=
				card.y +
				cardHeight &&
			card.y +
				cardHeight > 70 &&
			card.y <
				FlxG.height -
				20
		)
		{
			hoveredIndex =
				i;

			break;
		}
	}


	if (
		hoveredIndex !=
		previousHoveredIndex
	)
	{
		if (
			hoveredIndex >= 0
		)
		{
			try
			{
				CoolUtil.playMenuSFX(
					SCROLL,
					0.25
				);
			}
			catch (e:Dynamic)
			{
			}
		}


		previousHoveredIndex =
			hoveredIndex;
	}


	for (i in 0...cards.length)
	{
		var hover:Bool =
			i == hoveredIndex;


		if (hover)
		{
			if (i != selectedIndex)
			{
				cards[i].color =
					FlxColor.fromRGB(
						45,
						45,
						45
					);
			}


			playButtons[i].alpha =
				FlxMath.lerp(
					playButtons[i].alpha,
					1,
					0.2
				);


			playButtonTexts[i].alpha =
				FlxMath.lerp(
					playButtonTexts[i].alpha,
					1,
					0.2
				);


			cardLikes[i].alpha =
				FlxMath.lerp(
					cardLikes[i].alpha,
					1,
					0.2
				);


			cardSubscribeButtons[i].alpha =
				FlxMath.lerp(
					cardSubscribeButtons[i].alpha,
					1,
					0.2
				);


			cardSubscribeTexts[i].alpha =
				FlxMath.lerp(
					cardSubscribeTexts[i].alpha,
					1,
					0.2
				);


			thumbnails[i].scale.x =
				FlxMath.lerp(
					thumbnails[i].scale.x,
					1.05,
					0.15
				);


			thumbnails[i].scale.y =
				FlxMath.lerp(
					thumbnails[i].scale.y,
					1.05,
					0.15
				);
		}
		else
		{
			playButtons[i].alpha =
				FlxMath.lerp(
					playButtons[i].alpha,
					0,
					0.2
				);


			playButtonTexts[i].alpha =
				FlxMath.lerp(
					playButtonTexts[i].alpha,
					0,
					0.2
				);


			cardLikes[i].alpha =
				FlxMath.lerp(
					cardLikes[i].alpha,
					0,
					0.2
				);


			cardSubscribeButtons[i].alpha =
				FlxMath.lerp(
					cardSubscribeButtons[i].alpha,
					0,
					0.2
				);


			cardSubscribeTexts[i].alpha =
				FlxMath.lerp(
					cardSubscribeTexts[i].alpha,
					0,
					0.2
				);


			thumbnails[i].scale.x =
				FlxMath.lerp(
					thumbnails[i].scale.x,
					1,
					0.15
				);


			thumbnails[i].scale.y =
				FlxMath.lerp(
					thumbnails[i].scale.y,
					1,
					0.15
				);


			if (
				i != selectedIndex
			)
			{
				cards[i].color =
					FlxColor.WHITE;
			}
		}
	}
}


/* ============================================================
   HOME CLICK
   ============================================================ */

function handleMouseClick()
{
	if (
		searchActive ||
		currentGuidePage !=
		"Home" ||
		hoveredIndex < 0 ||
		selectedAnimating
	)
		return;


	var songName:String =
		getSongInternalName(
			hoveredIndex
		);


	/* ========================================================
	   LIKE
	   ======================================================== */

	if (
		FlxG.mouse.x >=
			cardLikes[hoveredIndex].x - 5
		&&
		FlxG.mouse.x <=
			cardLikes[hoveredIndex].x + 90
		&&
		FlxG.mouse.y >=
			cardLikes[hoveredIndex].y - 5
		&&
		FlxG.mouse.y <=
			cardLikes[hoveredIndex].y + 28
	)
	{
		likeSong(
			songName
		);


		updateCardActions();


		try
		{
			CoolUtil.playMenuSFX(
				CONFIRM,
				0.5
			);
		}
		catch (e:Dynamic)
		{
		}


		return;
	}


	/* ========================================================
	   SUBSCRIBE
	   ======================================================== */

	if (
		FlxG.mouse.x >=
			cardSubscribeButtons[hoveredIndex].x
		&&
		FlxG.mouse.x <=
			cardSubscribeButtons[hoveredIndex].x +
			cardSubscribeButtons[hoveredIndex].width
		&&
		FlxG.mouse.y >=
			cardSubscribeButtons[hoveredIndex].y
		&&
		FlxG.mouse.y <=
			cardSubscribeButtons[hoveredIndex].y +
			cardSubscribeButtons[hoveredIndex].height
	)
	{
		toggleSubscription(
			"Friday Night Funkin'"
		);


		updateCardActions();


		try
		{
			CoolUtil.playMenuSFX(
				CONFIRM,
				0.5
			);
		}
		catch (e:Dynamic)
		{
		}


		return;
	}


	/* ========================================================
	   NORMAL CARD CLICK
	   ======================================================== */

	var now:Float =
		FlxG.game.ticks /
		1000;


	if (
		lastClickedIndex !=
		hoveredIndex
	)
	{
		selectedIndex =
			hoveredIndex;


		updateSelection();


		lastClickedIndex =
			hoveredIndex;


		lastClickTime =
			now;


		try
		{
			CoolUtil.playMenuSFX(
				SCROLL,
				0.7
			);
		}
		catch (e:Dynamic)
		{
		}


		return;
	}


	if (
		now -
		lastClickTime <
		0.45
	)
	{
		startSongLoading();
	}


	lastClickTime =
		now;
}


/* ============================================================
   LOAD SONG LIST
   ============================================================ */

function loadSongs()
{
	songs = [];


	var path:String =
		"mods/data/config/freeplaySonglist.txt";


	try
	{
		if (
			openfl.Assets.exists(
				path
			)
		)
		{
			var text:String =
				openfl.Assets.getText(
					path
				);


			var lines:Array<String> =
				text.split("\n");


			for (line in lines)
			{
				if (line == null)
					continue;


				line =
					StringTools.trim(
						line
					);


				if (line.length == 0)
					continue;


				if (
					StringTools.startsWith(
						line,
						"//"
					)
				)
					continue;


				var song:Dynamic = {};


				song.name =
					line;


				song.displayName =
					line;


				song.icon =
					getDefaultIcon(
						line
					);


				song.difficulties =
					[
						"normal"
					];


				song.variant =
					"";


				songs.push(
					song
				);
			}
		}
	}
	catch (e:Dynamic)
	{
		trace(
			"YouTubeMadnessMenu: Failed to load songs: " +
			e
		);
	}


	if (
		songs.length == 0
	)
	{
		var fallback:Array<String> =
		[
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


		for (name in fallback)
		{
			var song:Dynamic = {};


			song.name = name;

			song.displayName = name;

			song.icon =
				getDefaultIcon(
					name
				);

			song.difficulties =
				[
					"normal"
				];

			song.variant =
				"";


			songs.push(
				song
			);
		}
	}


	trace(
		"YouTubeMadnessMenu: Loaded " +
		songs.length +
		" songs."
	);
}


/* ============================================================
   ICON / NAME / META
   ============================================================ */

function getDefaultIcon(
	songName:String
):String
{
	if (
		songName == null ||
		songName.length == 0
	)
		return "face";


	return songName;
}


function getIcon(
	index:Int
):String
{
	if (
		index < 0 ||
		index >= songs.length
	)
		return "face";


	var value:Dynamic =
		Reflect.field(
			songs[index],
			"icon"
		);


	if (
		value == null ||
		Std.string(value).length == 0
	)
	{
		return "face";
	}


	return Std.string(
		value
	);
}


function getDisplayName(
	index:Int
):String
{
	if (
		index < 0 ||
		index >= songs.length
	)
		return "";


	var value:Dynamic =
		Reflect.field(
			songs[index],
			"displayName"
		);


	if (
		value == null ||
		Std.string(value).length == 0
	)
	{
		value =
			Reflect.field(
				songs[index],
				"name"
			);
	}


	return Std.string(
		value
	);
}


function getDuration(
	index:Int
):String
{
	return "0:00";
}


function getMetadata(
	index:Int
):String
{
	if (
		index < 0 ||
		index >= songs.length
	)
		return "FNF • Song";


	var bpm:Dynamic =
		Reflect.field(
			songs[index],
			"bpm"
		);


	if (bpm != null)
	{
		return
			"FNF • " +
			Std.string(
				bpm
			) +
			" BPM";
	}


	return "FNF • Song";
}


/* ============================================================
   OPEN SONG
   ============================================================ */

function openSelectedSong()
{
	if (
		transitioning ||
		currentGuidePage != "Home" ||
		songs.length == 0
	)
		return;


	var song:Dynamic =
		songs[
			selectedIndex
		];


	var songName:String =
		Std.string(
			Reflect.field(
				song,
				"name"
			)
		);


	if (
		songName == null ||
		songName.length == 0
	)
		return;


	var difficulties:Array<String> =
		Reflect.field(
			song,
			"difficulties"
		);


	if (
		difficulties == null ||
		difficulties.length == 0
	)
	{
		difficulties =
			[
				"normal"
			];
	}


	var difficulty:String =
		difficulties[0];


	var variant:Dynamic =
		Reflect.field(
			song,
			"variant"
		);


	if (variant == null)
		variant = "";


	/* ========================================================
	   HISTORY
	   ======================================================== */

	if (
		historySongs.indexOf(
			songName
		) >= 0
	)
	{
		historySongs.remove(
			songName
		);
	}


	historySongs.unshift(
		songName
	);


	while (
		historySongs.length > 50
	)
	{
		historySongs.pop();
	}


	saveYouTube();


	transitioning = true;


	try
	{
		CoolUtil.playMenuSFX(
			CONFIRM
		);
	}
	catch (e:Dynamic)
	{
	}


	try
	{
		Options.freeplayLastSong =
			songName;


		Options.freeplayLastDifficulty =
			difficulty;


		Options.freeplayLastVariation =
			variant;


		PlayState.loadSong(
			songName,
			difficulty,
			variant,
			false,
			false
		);


		FlxG.switchState(
			new PlayState()
		);
	}
	catch (e:Dynamic)
	{
		trace(
			"YouTubeMadnessMenu: Failed to load song."
		);

		trace(e);

		transitioning = false;
	}
}


/* ============================================================
   UPDATE
   ============================================================ */

function update(
	elapsed:Float
)
{
	if (transitioning)
		return;


	FlxG.mouse.visible = true;


	/* ========================================================
	   PAGE TRANSITION
	   ======================================================== */

	updatePageTransition(
		elapsed
	);


	/* ========================================================
	   LOADING
	   ======================================================== */

	updateLoadingRing(
		elapsed
	);


	updateSelectedAnimation();


	/* ========================================================
	   GUIDE MENU BUTTON
	   ======================================================== */

	if (
		FlxG.mouse.justPressed
	)
	{
		if (
			FlxG.mouse.x >= 10 &&
			FlxG.mouse.x <= 55 &&
			FlxG.mouse.y >= 10 &&
			FlxG.mouse.y <= 55
		)
		{
			toggleGuide();

			return;
		}
	}


	/* ========================================================
	   GUIDE
	   ======================================================== */

	updateGuideScroll();

	updateGuideHover();


	if (
		FlxG.mouse.justPressed &&
		guideOpen &&
		FlxG.mouse.x >= 0 &&
		FlxG.mouse.x <= guideWidth &&
		FlxG.mouse.y >= 70
	)
	{
		handleGuideClick();

		return;
	}


	/* ========================================================
	   SEARCH
	   ======================================================== */

	if (
		FlxG.mouse.justPressed
	)
	{
		if (
			FlxG.mouse.x >= 245 &&
			FlxG.mouse.x <= 675 &&
			FlxG.mouse.y >= 10 &&
			FlxG.mouse.y <= 60
		)
		{
			if (
				FlxG.mouse.x >= 600 &&
				searchQuery.length > 0
			)
			{
				clearSearch();
			}
			else
			{
				activateSearch();
			}

			return;
		}
	}


	/* ========================================================
	   HOME KEYBOARD
	   ======================================================== */

	if (
		currentGuidePage == "Home" &&
		!searchActive &&
		!selectedAnimating
	)
	{
		if (
			FlxG.keys.justPressed.LEFT
		)
		{
			moveSelection(-1);
		}


		if (
			FlxG.keys.justPressed.RIGHT
		)
		{
			moveSelection(1);
		}


		if (
			FlxG.keys.justPressed.UP
		)
		{
			moveSelection(-columns);
		}


		if (
			FlxG.keys.justPressed.DOWN
		)
		{
			moveSelection(columns);
		}


		if (
			FlxG.keys.justPressed.PAGEUP
		)
		{
			moveSelection(
				-columns * 2
			);
		}


		if (
			FlxG.keys.justPressed.PAGEDOWN
		)
		{
			moveSelection(
				columns * 2
			);
		}
	}


	/* ========================================================
	   HOME SCROLL
	   ======================================================== */

	if (
		currentGuidePage == "Home" &&
		FlxG.mouse.wheel != 0 &&
		!(
			guideOpen &&
			FlxG.mouse.x <= guideWidth
		)
	)
	{
		targetScroll -=
			FlxG.mouse.wheel *
			(
				cardHeight +
				gapY
			);


		clampScroll();
	}


	currentScroll =
		FlxMath.lerp(
			currentScroll,
			targetScroll,
			0.12
		);


	if (
		Math.abs(
			currentScroll -
			targetScroll
		) < 0.5
	)
	{
		currentScroll =
			targetScroll;
	}


	if (
		currentGuidePage == "Home"
	)
	{
		updateCardPositions();

		updateMouse();
	}


	/* ========================================================
	   ENTER
	   ======================================================== */

	if (
		currentGuidePage == "Home" &&
		!searchActive &&
		FlxG.keys.justPressed.ENTER
	)
	{
		startSongLoading();

		return;
	}


	/* ========================================================
	   ESC
	   ======================================================== */

	if (
		!searchActive &&
		FlxG.keys.justPressed.ESCAPE
	)
	{
		goBack();

		return;
	}


	/* ========================================================
	   HOME CLICK
	   ======================================================== */

	if (
		currentGuidePage == "Home" &&
		FlxG.mouse.justPressed
	)
	{
		handleMouseClick();
	}
}


/* ============================================================
   BACK
   ============================================================ */

function goBack()
{
	if (transitioning)
		return;


	transitioning = true;


	destroyLoadingRing();


	saveYouTube();


	try
	{
		CoolUtil.playMenuSFX(
			CANCEL,
			0.7
		);
	}
	catch (e:Dynamic)
	{
	}


	try
	{
		FlxG.switchState(
			new MainMenuState()
		);
	}
	catch (e:Dynamic)
	{
		transitioning = false;
	}
}