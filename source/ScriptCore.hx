package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.effects.FlxTrail;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import haxe.Http;
import haxe.Json;
import hscript.Interp;
import hscript.Parser;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.Assets;
import parsers.Song;
import states.PlayState;

using StringTools;

#if android
import android.Hardware;
import android.Permissions;
import android.os.Build;
import android.os.Environment;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end

/**
 * Class based from Wednesdays-Infidelty Mod.
 * Credits: lunarcleint.
 */
class ScriptCore extends FlxBasic
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;

	public var interp:Interp;
	public var parser:Parser;

	public function new(file:String)
	{
		super();

		interp = new Interp();
		parser = new Parser();
		parser.allowJSON = true;
		parser.allowTypes = true;

		setVariable('Function_Stop', Function_Stop);
		setVariable('Function_Continue', Function_Continue);

		/**
			extension-androidtools
		**/
		#if android
		setVariable('Hardware', Hardware);
		setVariable('Permissions', Permissions);
		setVariable('Build', Build);
		setVariable('Environment', Environment);
		#end

		/**
			Haxe
		**/
		setVariable('Math', Math);

		setVariable('Reflect', Reflect);
		#if sys
		setVariable('Sys', Sys);
		setVariable('File', File);
		setVariable('FileSystem', FileSystem);
		#end
		setVariable('Type', Type);
		setVariable('Std', Std);
		setVariable('StringTools', StringTools);
		setVariable('Date', Date);
		setVariable('DateTools', DateTools);
		setVariable('Http', Http);
		setVariable('Json', Json);

		/**
			Flixel
		**/
		setVariable('FlxG', FlxG);

		setVariable('FlxSprite', FlxSprite);
		setVariable('FlxCamera', FlxCamera);
		setVariable('FlxTimer', FlxTimer);
		setVariable('FlxBar', FlxBar);
		setVariable('FlxTween', FlxTween);
		setVariable('FlxText', FlxText);
		setVariable('FlxTextBorderStyle', FlxTextBorderStyle);
		setVariable('FlxRect', FlxRect);
		setVariable('FlxEase', FlxEase);
		setVariable('FlxMath', FlxMath);
		setVariable('FlxAtlasFrames', FlxAtlasFrames);
		setVariable('FlxSound', FlxSound);
		setVariable('FlxSpriteGroup', FlxSpriteGroup);
		setVariable('FlxTrail', FlxTrail);
		setVariable('FlxRuntimeShader', FlxRuntimeShader);
		setVariable('FlxBackdrop', FlxBackdrop);
		setVariable('FlxEmitter', FlxEmitter);
		setVariable('FlxParticle', FlxParticle);
		setVariable('FlxGraphic', FlxGraphic);

		/**
			Openfl
		**/
		setVariable('Lib', Lib);

		setVariable('Assets', Assets);
		setVariable('BitmapData', BitmapData);
		setVariable('BitmapFilter', BitmapFilter);
		setVariable('ShaderFilter', ShaderFilter);
		setVariable('Font', Font);
		setVariable('Sound', Sound);

		/**
			Source
		**/
		setVariable('Alphabet', Alphabet);

		#if FUTURE_DISCORD_RCP
		setVariable('DiscordClient', DiscordClient);
		#end
		setVariable('Note', Note);
		setVariable('Song', Song);
		setVariable('Main', Main);
		setVariable('Paths', Paths);
		setVariable('CoolUtil', CoolUtil);
		setVariable('Conductor', Conductor);
		setVariable('PreferencesData', PreferencesData);
		setVariable('SUtil', SUtil);

		/**
			Game States
		**/
		setVariable('PlayState', PlayState);

		try
		{
			interp.execute(parser.parseString(Assets.getText(file)));
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");

		trace('Script Loaded Succesfully: $file');

		executeFunc('create', []);
	}

	public function setVariable(name:String, val:Dynamic):Void
	{
		if (interp == null)
			return;

		try
		{
			interp.variables.set(name, val);
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");
	}

	public function getVariable(name:String):Dynamic
	{
		if (interp == null)
			return null;

		try
		{
			return interp.variables.get(name);
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");

		return null;
	}

	public function removeVariable(name:String):Void
	{
		if (interp == null)
			return;

		try
		{
			interp.variables.remove(name);
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");
	}

	public function existsVariable(name:String):Bool
	{
		if (interp == null)
			return false;

		try
		{
			return interp.variables.exists(name);
		}
		catch (e:Dynamic)
			Lib.application.window.alert(e.message, "Hscript Error!");

		return false;
	}

	public function executeFunc(funcName:String, args:Array<Dynamic>):Dynamic
	{
		if (interp == null)
			return null;

		if (existsVariable(funcName))
		{
			try
			{
				return Reflect.callMethod(null, getVariable(funcName), args);
			}
			catch (e:Dynamic)
				Lib.application.window.alert(e, "Hscript Error!");
		}

		return null;
	}

	override function destroy()
	{
		super.destroy();
		interp = null;
		parser = null;
	}
}
