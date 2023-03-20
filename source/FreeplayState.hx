package;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxMath;
var spriteCats = [];
var categories = []; //none
var curSelected = 0;
var curSelectedLimiter = 0;
var curStating = "category";
var songs = [];
var songsText = [];
var icons = [];
class FreeplayState extends MusicBeatState {
	override function create() {
		var bg = new FlxSprite().loadGraphic(Paths.image(MainMenuState.menuBackgrounds[FlxG.random.int(0, MainMenuState.menuBackgrounds.length - 1)]));
		add(bg);
		var tempWeeks = WeekData.reloadWeekFiles(false);
		for (i in WeekData.weeksList) 
			if (!categories.contains(tempWeeks[i].freeplayCategory))
				categories.push(tempWeeks[i].freeplayCategory);
		curSelectedLimiter = categories.length - 1;
		for (i=>cater in categories) {
			var cater = new FlxSprite().loadGraphic(Paths.image(cater));
			cater.screenCenter();
			trace(cater.x);
			cater.x += 700 * i;
			add(cater);
			cater.ID = i;
			spriteCats.push(cater);
		}
		curStating = "category";
		super.create();
		change(0);
	}
	override function update(elapsed) {
		for (i in spriteCats) {
			var thinger = i.ID - curSelected;
			i.x = FlxMath.lerp(i.x, 340 + (700 * thinger), 0.05);
		}
		if (curStating == "category" && controls.UI_LEFT_P || curStating == "songSelect" && controls.UI_UP_P) change(-1);
		if (curStating == "category" && controls.UI_RIGHT_P || curStating == "songSelect" && controls.UI_DOWN_P) change(1);
		if (controls.ACCEPT) select();
		if (controls.BACK) back();
		for (i=>text in songsText) {
			text.targetY = i - curSelected;
		}
		super.update(elapsed);
	}
	function change(a) {
		FlxG.sound.play(Paths.sound('scrollMenu'), 1.2);
		curSelected = FlxMath.wrap(curSelected + a, 0, curSelectedLimiter);
	}
	function select() {
		FlxG.sound.play(Paths.sound('confirmMenu'), 1.2);
		switch (curStating) {
			case "category":
				for (i in WeekData.weeksLoaded)
					if (i.freeplayCategory == categories[curSelected]) {
						var thing = songsText.length;
						for (j=>song in i.songs) {
							songs.push(song);
							var songText = new Alphabet(90, 320, song[0], true);
							songText.isMenuItem = true;
							songText.targetY = thing + j - curSelected;
		
							if (songText.width > 980) songText.scaleX = 980 / songText.width;
							songText.snapToPosition();

							var icon = new HealthIcon(song[1]);
							icon.sprTracker = songText;
							add(icon);
							icons.push(icon);
							add(songText);
							songsText.push(songText);
						}
					}
				curStating = "songSelect";
				curSelectedLimiter = songs.length - 1;
				change(0);
				for (i in spriteCats) i.visible = false;
			case "songSelect": trace(songs[curSelected]);
				CoolUtil.difficulties = ["Normal"];
				var songLowercase:String = Paths.formatToSongPath(songs[curSelected][0]);
				var poop:String = Highscore.formatSong(songLowercase, 0);
				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 0;
				LoadingState.loadAndSwitchState(new PlayState());
				songs = [];
				for (i in songsText) i.destroy();
				for (i in icons) i.destroy();
				songsText = [];
				icons = [];
		}
	}
	function back() {
		FlxG.sound.play(Paths.sound('cancelMenu'), 1.2);
		switch (curStating) {
			case "songSelect":
				songs = [];
				for (i in songsText) i.destroy();
				for (i in icons) i.destroy();
				songsText = [];
				icons = [];
				for (i in spriteCats) i.visible = true;
				curStating = "category";
				curSelectedLimiter = categories.length - 1;
				change(0);
			case "category": MusicBeatState.switchState(new MainMenuState());
		}
	}
}