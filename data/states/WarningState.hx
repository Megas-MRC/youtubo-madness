package funkin.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import funkin.menus.TitleState;

// ============================================================
// YOUTUBE MADNESS - BOOT / WARNING SCREEN
// ============================================================

var transitioning:Bool = false;
var currentScreen:String = "warning";
var bootReady:Bool = false;
var selectedBoot:Int = 0;

// ============================================================
// OBJECTS
// ============================================================

var background:FlxSprite;

var systemText:FlxText;
var infoText:FlxText;
var warningText:FlxText;

var setupText:FlxText;
var bootText:FlxText;
var continueText:FlxText;
var statusText:FlxText;

var bootSelection:FlxText;

// ============================================================
// CREATE
// ============================================================

function create()
{
	transitioning = false;
	currentScreen = "warning";
	bootReady = false;
	selectedBoot = 0;

	FlxG.mouse.visible = false;

	// --------------------------------------------------------
	// BLACK BACKGROUND
	// --------------------------------------------------------

	background = new FlxSprite();
	background.makeGraphic(
		FlxG.width,
		FlxG.height,
		FlxColor.BLACK
	);
	add(background);

	// --------------------------------------------------------
	// SYSTEM TITLE
	// --------------------------------------------------------

	systemText = new FlxText(
		25,
		20,
		FlxG.width - 50,
		"YOUTUBE MADNESS BIOS",
		16
	);

	systemText.setFormat(
		null,
		16,
		FlxColor.WHITE,
		"LEFT"
	);

	add(systemText);

	// --------------------------------------------------------
	// BIOS INFORMATION
	// --------------------------------------------------------

	infoText = new FlxText(
		25,
		55,
		FlxG.width - 50,
		"YOUTUBE MADNESS SYSTEM 1.0\n"
		+ "Copyright (C) YouTube Madness\n"
		+ "Memory Test: 12288K OK",
		14
	);

	infoText.setFormat(
		null,
		14,
		FlxColor.WHITE,
		"LEFT"
	);

	add(infoText);

	// --------------------------------------------------------
	// WARNING
	// --------------------------------------------------------

	warningText = new FlxText(
		25,
		FlxG.height * 0.36,
		FlxG.width - 50,
		"WARNING\n\n"
		+ "This game contains flashing lights,\n"
		+ "glitches and disturbing content.\n\n"
		+ "Proceed only if you wish to continue.",
		18
	);

	warningText.setFormat(
		null,
		18,
		FlxColor.WHITE,
		"CENTER"
	);

	add(warningText);

	// --------------------------------------------------------
	// SETUP
	// --------------------------------------------------------

	setupText = new FlxText(
		25,
		FlxG.height - 90,
		FlxG.width - 50,
		"F11 = SETUP",
		14
	);

	setupText.setFormat(
		null,
		14,
		FlxColor.WHITE,
		"LEFT"
	);

	add(setupText);

	// --------------------------------------------------------
	// BOOT MENU
	// --------------------------------------------------------

	bootText = new FlxText(
		0,
		FlxG.height - 90,
		FlxG.width - 25,
		"F12 = BOOT MENU",
		14
	);

	bootText.setFormat(
		null,
		14,
		FlxColor.WHITE,
		"RIGHT"
	);

	add(bootText);

	// --------------------------------------------------------
	// CONTINUE
	// --------------------------------------------------------

	continueText = new FlxText(
		0,
		FlxG.height - 55,
		FlxG.width,
		"ENTER = CONTINUE",
		14
	);

	continueText.setFormat(
		null,
		14,
		FlxColor.WHITE,
		"CENTER"
	);

	add(continueText);

	// --------------------------------------------------------
	// STATUS
	// --------------------------------------------------------

	statusText = new FlxText(
		25,
		FlxG.height - 25,
		FlxG.width - 50,
		"Press ENTER to continue...",
		12
	);

	statusText.setFormat(
		null,
		12,
		FlxColor.fromRGB(170, 170, 170),
		"LEFT"
	);

	add(statusText);

	// --------------------------------------------------------
	// BOOT SELECTION
	// --------------------------------------------------------

	bootSelection = new FlxText(
		25,
		FlxG.height - 150,
		FlxG.width - 50,
		"",
		14
	);

	bootSelection.setFormat(
		null,
		14,
		FlxColor.WHITE,
		"LEFT"
	);

	bootSelection.visible = false;

	add(bootSelection);

	// --------------------------------------------------------
	// DISCORD
	// --------------------------------------------------------

	DiscordUtil.call(
		"onMenuLoaded",
		["YouTube Madness BIOS"]
	);

	// --------------------------------------------------------
	// BOOT DELAY
	// --------------------------------------------------------

	statusText.text = "Initializing YouTube Madness system...";

	new FlxTimer().start(
		0.8,
		function(tmr:FlxTimer)
		{
			if (currentScreen == "warning")
			{
				statusText.text =
					"System initialization complete.";
			}
		}
	);
}

// ============================================================
// UPDATE
// ============================================================

function update(elapsed:Float)
{
	// --------------------------------------------------------
	// WARNING
	// --------------------------------------------------------

	if (currentScreen == "warning")
	{
		if (FlxG.keys.justPressed.F11)
		{
			openSetup();
			return;
		}

		if (FlxG.keys.justPressed.F12)
		{
			openBootMenu();
			return;
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			continueToGame();
			return;
		}
	}

	// --------------------------------------------------------
	// SETUP
	// --------------------------------------------------------

	if (currentScreen == "setup")
	{
		if (FlxG.keys.justPressed.ESCAPE ||
			FlxG.keys.justPressed.F11)
		{
			returnToWarning();
			return;
		}
	}

	// --------------------------------------------------------
	// BOOT MENU
	// --------------------------------------------------------

	if (currentScreen == "boot")
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			returnToWarning();
			return;
		}

		if (!bootReady)
			return;

		if (FlxG.keys.justPressed.UP)
		{
			selectedBoot--;

			if (selectedBoot < 0)
				selectedBoot = 3;

			updateBootSelection();
		}

		if (FlxG.keys.justPressed.DOWN)
		{
			selectedBoot++;

			if (selectedBoot > 3)
				selectedBoot = 0;

			updateBootSelection();
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			selectBootOption();
			return;
		}
	}
}

// ============================================================
// SETUP SCREEN
// ============================================================

function openSetup()
{
	currentScreen = "setup";

	systemText.text =
		"YOUTUBE MADNESS BIOS - SETUP UTILITY";

	infoText.text =
		"MAIN\n"
		+ "SYSTEM INFORMATION\n"
		+ "DISPLAY SETTINGS\n"
		+ "AUDIO SETTINGS\n"
		+ "BOOT SETTINGS\n"
		+ "SECURITY SETTINGS";

	warningText.text =
		"BIOS SETUP UTILITY\n\n"
		+ "System Configuration\n\n"
		+ "Processor ............ OK\n"
		+ "Memory ............... OK\n"
		+ "Display .............. OK\n"
		+ "Audio ................ OK\n"
		+ "Storage .............. OK";

	warningText.setFormat(
		null,
		17,
		FlxColor.WHITE,
		"LEFT"
	);

	setupText.text =
		"F11 = BACK";

	bootText.text = "";

	continueText.text =
		"ESC = EXIT SETUP";

	statusText.text =
		"YOUTUBE MADNESS BIOS SETUP";

	FlxG.camera.flash(
		FlxColor.WHITE,
		0.12
	);
}

// ============================================================
// BOOT MENU
// ============================================================

function openBootMenu()
{
	currentScreen = "boot";
	bootReady = false;
	selectedBoot = 0;

	systemText.text =
		"YOUTUBE MADNESS - BOOT MENU";

	infoText.text =
		"BOOT DEVICE SELECTION\n\n"
		+ "Detected devices:";

	warningText.text =
		"BOOT MENU\n\n"
		+ "> YOUTUBE MADNESS\n"
		+ "  SYSTEM RECOVERY\n"
		+ "  SAFE MODE\n"
		+ "  BIOS SETUP\n\n"
		+ "Use UP/DOWN to select.";

	warningText.setFormat(
		null,
		17,
		FlxColor.WHITE,
		"LEFT"
	);

	setupText.text =
		"ESC = BACK";

	bootText.text =
		"YOUTUBE MADNESS";

	continueText.text =
		"ENTER = SELECT";

	statusText.text =
		"Detecting boot devices...";

	bootSelection.visible = true;

	FlxG.camera.flash(
		FlxColor.WHITE,
		0.12
	);

	// --------------------------------------------------------
	// BOOT DELAY
	// --------------------------------------------------------

	new FlxTimer().start(
		0.7,
		function(tmr:FlxTimer)
		{
			if (currentScreen != "boot")
				return;

			bootReady = true;

			statusText.text =
				"Boot devices detected.";

			updateBootSelection();
		}
	);
}

// ============================================================
// BOOT SELECTION DISPLAY
// ============================================================

function updateBootSelection()
{
	if (currentScreen != "boot")
		return;

	var arrow0:String = selectedBoot == 0 ? ">" : " ";
	var arrow1:String = selectedBoot == 1 ? ">" : " ";
	var arrow2:String = selectedBoot == 2 ? ">" : " ";
	var arrow3:String = selectedBoot == 3 ? ">" : " ";

	bootSelection.text =
		arrow0 + " YOUTUBE MADNESS\n"
		+ arrow1 + " SYSTEM RECOVERY\n"
		+ arrow2 + " SAFE MODE\n"
		+ arrow3 + " BIOS SETUP";

	statusText.text =
		"Use UP/DOWN to select - ENTER to boot.";
}

// ============================================================
// BOOT OPTION
// ============================================================

function selectBootOption()
{
	switch (selectedBoot)
	{
		case 0:
			continueToGame();

		case 1:
			statusText.text =
				"System Recovery is not available.";

		case 2:
			statusText.text =
				"Safe Mode is not available.";

		case 3:
			openSetup();
	}
}

// ============================================================
// RETURN TO WARNING
// ============================================================

function returnToWarning()
{
	currentScreen = "warning";
	bootReady = false;

	bootSelection.visible = false;

	systemText.text =
		"YOUTUBE MADNESS BIOS";

	infoText.text =
		"YOUTUBE MADNESS SYSTEM 1.0\n"
		+ "Copyright (C) YouTube Madness\n"
		+ "Memory Test: 12288K OK";

	warningText.text =
		"WARNING\n\n"
		+ "This game contains flashing lights,\n"
		+ "glitches and disturbing content.\n\n"
		+ "Proceed only if you wish to continue.";

	warningText.setFormat(
		null,
		18,
		FlxColor.WHITE,
		"CENTER"
	);

	setupText.text =
		"F11 = SETUP";

	bootText.text =
		"F12 = BOOT MENU";

	continueText.text =
		"ENTER = CONTINUE";

	statusText.text =
		"Press ENTER to continue...";
}

// ============================================================
// CONTINUE
// ============================================================

function continueToGame()
{
	if (transitioning)
		return;

	transitioning = true;

	statusText.text =
		"Loading YOUTUBE MADNESS...";

	new FlxTimer().start(
		0.8,
		function(tmr:FlxTimer)
		{
			FlxG.camera.flash(
				FlxColor.WHITE,
				0.20,
				function()
				{
					FlxG.camera.fade(
						FlxColor.BLACK,
						0.8,
						false,
						function()
						{
							goToTitle();
						}
					);
				}
			);
		}
	);
}

// ============================================================
// TITLE STATE
// ============================================================

function goToTitle()
{
	FlxG.switchState(
		new TitleState()
	);
}