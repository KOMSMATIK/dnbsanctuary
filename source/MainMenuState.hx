package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import openfl.Assets;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var firstIn:Bool = true;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story',
		'freeplay',
		//#if MODS_ALLOWED 'mods', #end
		//#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		//#if !switch 'donate', #end
		'ost',
		'settings'
	];

	var optionTextShit:Array<String> = [
		'Story Mode',
		'Freeplay',
		'Credits',
		'OST',
		'Settings'
	];

	var magenta:FlxSprite;
	var bg:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var tabel:FlxSprite;
	var dnbTrophy:FlxSprite;
	var sanctuaryTrophy:FlxSprite;
	var periculumTrophy:FlxSprite;
	var gokuTrophy:FlxSprite;

	var menuItemBG:FlxSprite;
	var menuText:FlxText;
	var ramdom:Array<String> = [];
	var ramdomText:FlxText;
	var firstStart:Bool = true;
	var finishedFunnyMove:Bool = false;
	var allowInput:Bool = false;

	public static var menuBackgrounds:Array<String> =
	[
		'menubackgrounds/1',
		'menubackgrounds/2',
		'menubackgrounds/3',
		'menubackgrounds/4'
	];

	override function create()
	{
		/*#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();*/

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		Application.current.window.title = Main.appTitle;

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		//ramdom = FlxG.random.getObject(getRandomTextShit());

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		bg = new FlxSprite(-80).loadGraphic(setBG());
		//bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 0.9));
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = 0xFFF5DB4B;
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(bg.graphic);
		//magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 0.9));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItemBG = new FlxSprite().makeGraphic(FlxG.width, 156, FlxColor.BLACK);
		menuItemBG.alpha = 0.6;
		menuItemBG.y = FlxG.height / 2 + 115;
		menuItemBG.centerOrigin();
		menuItemBG.x = -1500;
		add(menuItemBG);

		menuText = new FlxText(-1000, 425, FlxG.width, optionTextShit[curSelected], 32);
		menuText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		menuText.borderSize = 1.25;

		var ramdomTextBG:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, 40, FlxColor.BLACK);
		ramdomTextBG.alpha = 0.7;
		add(ramdomTextBG);

		ramdomText = new FlxText(0, -10, FlxG.width, "", 32);
		ramdomText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		ramdomText.borderSize = 1.25;
		ramdomText.screenCenter(X);
		add(ramdomText);

		tabel = new FlxSprite(100, 310).loadGraphic(Paths.image('trophies/une_table'));
		tabel.setGraphicSize(Std.int(tabel.width * 0.8));
		tabel.screenCenter(X);
		tabel.antialiasing = ClientPrefs.globalAntialiasing;
		add(tabel);

		dnbTrophy = new FlxSprite(220, 160).loadGraphic(Paths.image('trophies/dnbTrophy'));
		dnbTrophy.setGraphicSize(Std.int(dnbTrophy.width * 0.8));
		dnbTrophy.antialiasing = ClientPrefs.globalAntialiasing;
		if(ClientPrefs.dnbTrophy)
		    add(dnbTrophy);
		

		sanctuaryTrophy = new FlxSprite(420, 125).loadGraphic(Paths.image('trophies/sanctTrophy'));
		sanctuaryTrophy.setGraphicSize(Std.int(sanctuaryTrophy.width * 0.8));
		sanctuaryTrophy.antialiasing = ClientPrefs.globalAntialiasing;
		if(ClientPrefs.sanctuaryTrophy)
		    add(sanctuaryTrophy);
		
		periculumTrophy = new FlxSprite(600, 120).loadGraphic(Paths.image('trophies/periculumTrophy'));
		periculumTrophy.setGraphicSize(Std.int(periculumTrophy.width * 0.8));
		periculumTrophy.antialiasing = ClientPrefs.globalAntialiasing;
		if(ClientPrefs.periculumTrophy)
		    add(periculumTrophy);

		gokuTrophy = new FlxSprite(800, 130).loadGraphic(Paths.image('trophies/gokuTrophy'));
		gokuTrophy.setGraphicSize(Std.int(gokuTrophy.width * 0.8));
		gokuTrophy.antialiasing = ClientPrefs.globalAntialiasing;
		if(ClientPrefs.gokuTrophy)
		    add(gokuTrophy);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		add(menuText);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			/*var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/dnb_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();*/

			var menuItem:FlxSprite = new FlxSprite(FlxG.width * 1.6, 0);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/dnb_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + "Unselected", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + "Selected", 24);
			menuItem.animation.play('idle');
			menuItem.antialiasing = false;
			menuItem.setGraphicSize(128, 128);
			menuItem.ID = i;
			menuItem.updateHitbox();
			menuItems.add(menuItem);

			if (firstStart)
				{
					FlxTween.tween(menuItemBG, {x: 0}, 2, {ease: FlxEase.expoInOut});
					FlxTween.tween(menuText, {x: 0}, 2, {ease: FlxEase.expoInOut});
					FlxTween.tween(menuItem, {x: FlxG.width / 2 - 463 + (i * 200)}, 1 + (i * 0.25), {
						ease: FlxEase.backInOut,
						onComplete: function(flxTween:FlxTween)
						{
							finishedFunnyMove = true;
							allowInput = true;
							//menuItem.screenCenter(Y);
							changeItem();
						}
					});
				}
				else
				{
					//menuItem.screenCenter(Y);
					menuItem.x = FlxG.width / 2 - 463 + (i * 200);
					changeItem();
				}
			}
	
			firstStart = false;
	
			menuItems.forEach(function(spr:FlxSprite)
			{
				spr.y = FlxG.height / 2 + 130;
			});


		

		//FlxG.camera.follow(camFollowPos, null, 1);

		/*var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);*/
		var versionShit:FlxText = new FlxText(0, FlxG.height - 32, 0, "Sanctuary - Rizzalicious Dev Build!", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Comic Sans MS Bold", 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.screenCenter(X);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		menuItems.forEach(function(spr:FlxSprite)
			{
				spr.y = FlxG.height / 2 + 130;
			});

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P && allowInput)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 1.2);
				changeItem(-1);
				FlxTween.tween(menuText, {x: -10}, 0.1, {ease: FlxEase.expoInOut,
				onComplete: function(flxtween:FlxTween):Void {
					FlxTween.tween(menuText, {x: 0}, 0.1);
				}
				});
				menuText.text = optionTextShit[curSelected];
			}

			if (controls.UI_RIGHT_P && allowInput)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 1.2);
				changeItem(1);
				menuText.text = optionTextShit[curSelected];
				FlxTween.tween(menuText, {x: 10}, 0.1, {ease: FlxEase.expoInOut,
					onComplete: function(flxtween:FlxTween):Void {
						FlxTween.tween(menuText, {x: 0}, 0.1);
					}
					});
			}

			if (controls.BACK && allowInput)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'), 1.2);
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT && allowInput)
			{
				if (optionShit[curSelected] == 'ost')
				{
					CoolUtil.browserLoad('https://youtube.com/playlist?list=PLgyQbXt3iFsFj3O9VxIbzY5haJdfkwZ7v');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'), 1.2);

					if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);
					menuText.color = FlxColor.LIME;

					menuText.scale.x = 1.2;
					menuText.scale.y = 1.2;
					FlxTween.tween(menuText.scale, {x: 1, y: 1}, 0.1, {ease: FlxEase.quadIn});

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							/*FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});*/
							/*var sprArrays:Array<FlxSprite> = new Array<FlxSprite>();
							        FlxTween.tween(spr, {x: -30}, 1 {
										onComplete: function(tween:FlxTween) {
										spr.velocity.set(new FlxRandom().float(0, 10), new FlxRandom().float(300, 450));
										}
									});
									spr.angularVelocity = 30;
									sprArrays.push(spr);*/
							FlxTween.tween(spr, {y: 700, alpha: 0}, 1, {ease: FlxEase.backInOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						    });
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story':
										//MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'settings':
										LoadingState.loadAndSwitchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		/*menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});*/
	}

	function getRandomTextShit():Array<Array<String>>
	{
			var fullText:String = Assets.getText(Paths.txt('randomText'));
			var firstArray:Array<String> = fullText.split('\n');
			var swagGoodArray:Array<Array<String>> = [];
			return swagGoodArray;
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;


		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				/*camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();*/
			}
		});
	}

	public static function setBG():flixel.system.FlxAssets.FlxGraphicAsset
		{
			var chance:Int = FlxG.random.int(0, menuBackgrounds.length - 1);
			return Paths.image(menuBackgrounds[chance]);
		}
}
