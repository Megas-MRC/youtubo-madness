import funkin.menus.ModSwitchMenu;

function update(){
	if (FlxG.keys.pressed.TAB) {
	persistentUpdate = false;
	persistentDraw = true;
	openSubState(new ModSwitchMenu());
	}
}