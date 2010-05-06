/*
VERSION: 8.11
DATE: 8/29/2008
ACTIONSCRIPT VERSION: 3.0 (AS2 version is also available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenLite.com (there's a link to the AS3 version)
DESCRIPTION:
	Tweening. We all do it. Most of us have learned to avoid Adobe's Tween class in favor of a more powerful engine
	that requires less code (e.g. Tweener). Each has its own strengths & weaknesses. A few years back, 
	I created TweenLite because I needed a very compact tweening engine that was fast and efficient (I couldn't 
	afford the file size bloat that came with the other tweening engines). It quickly became integral to my work 
	flow. I figured others might be able to benefit from it, so I released it publicly. Over the past few years, 
	TweenLite has grown more popular than I could have imagined.

	Since then, I've added new capabilities while trying to keep file size way down (3K). TweenFilterLite extends 
	TweenLite and adds the ability to tween filters including ColorMatrixFilter effects like saturation, contrast, 
	brightness, hue, and even colorization but it only adds about 3k to the file size. Same syntax as TweenLite. 
	There are AS2 and AS3 versions of both of the classes ready for download. TweenMax adds even more features to 
	TweenFilterLite including bezier tweening, pause/resume, sequencing, and much more. (see www.TweenMax.com)

	I know what you're thinking - "if it's so 'lightweight', it's probably missing a lot of features which makes 
	me nervous about using it as my main tweening engine." It is true that it doesn't have the same feature set 
	as some other tweening engines, but I can honestly say that after using it on almost every project I've worked 
	on over the last few years (many award-winning flash apps for fortune-500 companies), it has never let me down. 
	I never found myself needing some other functionality. You can tween any property (including a DisplayObject's 
	volume and color), use any easing function, build in delays, callback functions, pass arguments to that 
	callback function, and even tween arrays all with one line of code. If you need more features, you can always 
	step up to TweenFilterLite or TweenMax.

	I haven't been able to find a faster tween engine either. See an interactive speed comparison 
	of various tweening engines at http://blog.greensock.com/tweeing-speed-test/.

ARGUMENTS:
	1) $target : Object - Target MovieClip (or any other object) whose properties we're tweening
	2) $duration : Number - Duration (in seconds) of the effect
	3) $vars : Object - An object containing the end values of all the properties you'd like to have tweened (or if you're using the 
	         			TweenLite.from() method, these variables would define the BEGINNING values). For example:
							  alpha: The alpha (opacity level) that the target object should finish at (or begin at if you're 
									 using TweenLite.from()). For example, if the target.alpha is 1 when this script is 
									 called, and you specify this argument to be 0.5, it'll transition from 1 to 0.5.
							  x: To change a MovieClip's x position, just set this to the value you'd like the MovieClip to 
								 end up at (or begin at if you're using TweenLite.from()). 
		  SPECIAL PROPERTIES (**OPTIONAL**):
		  	  delay : Number - Amount of delay before the tween should begin (in seconds).
			  ease : Function - You can specify a function to use for the easing with this variable. For example, 
								fl.motion.easing.Elastic.easeOut. The Default is Regular.easeOut.
			  easeParams : Array - An array of extra parameters to feed the easing equation. This can be useful when you 
								   use an equation like Elastic and want to control extra parameters like the amplitude and period.
								   Most easing equations, however, don't require extra parameters so you won't need to pass in any easeParams.
			  autoAlpha : Number - Use it instead of the alpha property to gain the additional feature of toggling 
			  					   the visible property to false when alpha reaches 0. It will also toggle visible 
								   to true before the tween starts if the value of autoAlpha is greater than zero.
			  visible : Boolean - To set a DisplayObject's "visible" property at the end of the tween, use this special property.
			  volume : Number - Tweens the volume of an object with a soundTransform property (MovieClip/SoundChannel/NetStream, etc.)
			  tint : Number - To change a DisplayObject's tint/color, set this to the hex value of the tint you'd like
							  to end up at(or begin at if you're using TweenLite.from()). An example hex value would be 0xFF0000. 
			  removeTint : Boolean - If you'd like to remove the tint that's applied to a DisplayObject, pass true for this special property.
			  frame : Number - Use this to tween a MovieClip to a particular frame.
			  onStart : Function - If you'd like to call a function as soon as the tween begins, pass in a reference to it here.
								   This is useful for when there's a delay. 
			  onStartParams : Array - An array of parameters to pass the onStart function. (this is optional)
			  onUpdate : Function - If you'd like to call a function every time the property values are updated (on every frame during
									the time the tween is active), pass a reference to it here.
			  onUpdateParams : Array - An array of parameters to pass the onUpdate function (this is optional)
			  onComplete : Function - If you'd like to call a function when the tween has finished, use this. 
			  onCompleteParams : Array - An array of parameters to pass the onComplete function (this is optional)
			  persist : Boolean - if true, the TweenLite instance will NOT automatically be removed by the garbage collector when it is complete.
			  					  However, it is still eligible to be overwritten by new tweens even if persist is true. By default, it is false.
			  renderOnStart : Boolean - If you're using TweenFilterLite.from() with a delay and want to prevent the tween from rendering until it
										actually begins, set this to true. By default, it's false which causes TweenLite.from() to render
										its values immediately, even before the delay has expired.
			  overwrite : int - Controls how other tweens of the same object are handled when this tween is created. Here are the options:
			  					- 0 (NONE): No tweens are overwritten. This is the fastest mode, but you need to be careful not to create any 
			  								tweens with overlapping properties, otherwise they'll conflict with each other. 
											
								- 1 (ALL): (this is the default unless OverwriteManager.init() has been called) All tweens of the same object 
										   are completely overwritten immediately when the tween is created. 
										   		TweenLite.to(mc, 1, {x:100, y:200});
												TweenLite.to(mc, 1, {x:300, delay:2, overwrite:1}); //immediately overwrites the previous tween
												
								- 2 (AUTO): (used by default if OverwriteManager.init() has been called) Searches for and overwrites only 
											individual overlapping properties in tweens that are active when the tween begins. 
												TweenLite.to(mc, 1, {x:100, y:200});
												TweenLite.to(mc, 1, {x:300, overwrite:2}); //only overwrites the "x" property in the previous tween
												
								- 3 (CONCURRENT): Overwrites all tweens of the same object that are active when the tween begins.
												  TweenLite.to(mc, 1, {x:100, y:200});
												  TweenLite.to(mc, 1, {x:300, delay:2, overwrite:3}); //does NOT overwrite the previous tween because the first tween will have finished by the time this one begins.
	

EXAMPLES: 
	As a simple example, you could tween the alpha to 50% (0.5) and move the x position of a MovieClip named "clip_mc" 
	to 120 and fade the volume to 0 over the course of 1.5 seconds like so:
	
		import gs.TweenLite;
		TweenLite.to(clip_mc, 1.5, {alpha:0.5, x:120, volume:0});
	
	If you want to get more advanced and tween the clip_mc MovieClip over 5 seconds, changing the alpha to 0.5, 
	the x to 120 using the "easeOutBack" easing function, delay starting the whole tween by 2 seconds, and then call
	a function named "onFinishTween" when it has completed and pass in a few parameters to that function (a value of
	5 and a reference to the clip_mc), you'd do so like:
		
		import gs.TweenLite;
		import fl.motion.easing.Back;
		TweenLite.to(clip_mc, 5, {alpha:0.5, x:120, ease:Back.easeOut, delay:2, onComplete:onFinishTween, onCompleteParams:[5, clip_mc]});
		function onFinishTween(argument1:Number, argument2:MovieClip):void {
			trace("The tween has finished! argument1 = " + argument1 + ", and argument2 = " + argument2);
		}
	
	If you have a MovieClip on the stage that is already in it's end position and you just want to animate it into 
	place over 5 seconds (drop it into place by changing its y property to 100 pixels higher on the screen and 
	dropping it from there), you could:
		
		import gs.TweenLite;
		import fl.motion.easing.Elastic;
		TweenLite.from(clip_mc, 5, {y:"-100", ease:Elastic.easeOut});		
	

NOTES:
	- This class will add about 3kb to your Flash file.
	- Putting quotes around values will make the tween relative to the current value. For example, if you do
	  TweenLite.to(mc, 2, {x:"-20"}); it'll move the mc.x to the left 20 pixels which is the same as doing
	  TweenLite.to(mc, 2, {x:mc.x - 20});
	- You can change the TweenLite.defaultEase function if you prefer something other than Regular.easeOut.
	- You must target Flash Player 9 or later (ActionScript 3.0)
	- You can tween the volume of any MovieClip using the tween property "volume", like:
	  TweenLite.to(myClip_mc, 1.5, {volume:0});
	- You can tween the color of a MovieClip using the tween property "tint", like:
	  TweenLite.to(myClip_mc, 1.5, {tint:0xFF0000});
	- To tween an array, just pass in an array as a property named endArray like:
	  var myArray:Array = [1,2,3,4];
	  TweenLite.to(myArray, 1.5, {endArray:[10,20,30,40]});
	- You can kill all tweens for a particular object (usually a MovieClip) anytime with the 
	  TweenLite.killTweensOf(myClip_mc); function. If you want to have the tweens forced to completion, 
	  pass true as the second parameter, like TweenLite.killTweensOf(myClip_mc, true);
	- You can kill all delayedCalls to a particular function using TweenLite.killDelayedCallsTo(myFunction_func);
	  This can be helpful if you want to preempt a call.
	- Use the TweenLite.from() method to animate things into place. For example, if you have things set up on 
	  the stage in the spot where they should end up, and you just want to animate them into place, you can 
	  pass in the beginning x and/or y and/or alpha (or whatever properties you want).
	  
	  
CHANGE LOG:
	8.11:
		- Added the ability to overwrite only individual overlapping properties with the new OverwriteManager class
		- Added the killVars() method
		- Fixed potential garbage collection issue
	7.04:
		- Speed optimizations
	7.02:
		- Added ability to tween the volume of any object that has a soundTransform property instead of just MoveiClips and SoundChannels. Now NetStream volumes can be tweened too.
	7.01:
		- Fixed delayedCall() error (removed onCompleteScope since it's not useful in AS3 anyway)
	7.0:
		- Added "persist" special property
		- Added "removeTint" special property (please use this instead of tint:null)
		- Added compatibility with TweenLiteVars utility class
	6.3:
		- Added "visible" special property
	6.24:
		- Very minor change in the complete() function that helps prevent duplicate error reports in onComplete calls.
	6.23:
		- Minor speed improvements and size reduction
	6.22:
		- Removed property validation in the initTweenVals() method because Flash Player 10's Object.hasOwnProperty() incorrectly reports that DisplayObjects don't have a "z" property (same for rotationX, rotationY, and rotationZ I believe) At least in the Beta version that's out as of 5/23/08
	6.21:
		- Fixed bug with complete() not working properly in certain scenarios.
	6.2:
		- Enhanced speed and changed the "tweens" property from an Object to an Array
	6.13:
		- Fixed potential problem with the complete() method that could prevent a tween from completing properly.
	6.11:
		- Fixed issue that prevented tweening to a tint of 0 (black)
	6.1:
		- Ensured that even thousands of tweens are synced (uses an internally-controlled timer)
		- Removed support for mcColor (in favor of "tint")
	6.04:
		- Fixed bug that caused calls to complete() to not render if the tween hadn't ever started (like if there was a delay that hadn't expired yet)
	6.03:
		- Added the "renderOnStart" property that can force TweenLite.from() to render only when the tween actually starts (by default, it renders immediately even if the tween has a delay.)
	6.02:
		- Fixed bug that could cause TweenLite.delayedCall() to generate a 1010 error.
	6.01:
		- Fixed bug that could cause TweenLite.from() to not render the values immediately.
		- Fixed bug that could prevent tweens with a duration of zero from rendering properly.
	6.0:
		- Added ability to tween a MovieClip's frame
		- Added onCompleteScope, onStartScope, and onUpdateScope
		- Reworked internal class routines for handling SubTweens

CODED BY: Jack Doyle, jack@greensock.com
Copyright 2008, GreenSock (This work is subject to the terms in http://www.greensock.com/terms_of_use.html.)
*/

package gs {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.*;

	public class TweenLite {
		public static var version:Number = 8.11;
		public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
		public static var defaultEase:Function = TweenLite.easeOut;
		public static var overwriteManager:Object; //makes it possible to integrate the gs.utils.tween.OverwriteManager for adding autoOverwrite capabilities
		protected static var _all:Dictionary = new Dictionary(); //Holds references to all our tween targets.
		protected static var _curTime:uint;
		private static var _classInitted:Boolean;
		private static var _sprite:Sprite = new Sprite(); //A reference to the sprite that we use to drive all our ENTER_FRAME events.
		private static var _listening:Boolean; //If true, the ENTER_FRAME is being listened for (there are tweens that are in the queue)
		private static var _timer:Timer = new Timer(2000);
	
		public var duration:Number; //Duration (in seconds)
		public var vars:Object; //Variables (holds things like alpha or y or whatever we're tweening)
		public var delay:Number; //Delay (in seconds)
		public var startTime:int; //Start time
		public var initTime:int; //Time of initialization. Remember, we can build in delays so this property tells us when the frame action was born, not when it actually started doing anything.
		public var tweens:Array; //Contains parsed data for each property that's being tweened (each has to have a target, property, start, and a change).
		public var target:Object; //Target object (often a MovieClip)
		
		protected var _active:Boolean; //If true, this tween is active.
		protected var _subTweens:Array; //Only used for associated sub-tweens like tint and volume
		protected var _hst:Boolean; //Has sub-tweens. Tracking this as a Boolean value is faster than checking _subTweens.length
		protected var _hasUpdate:Boolean; //has onUpdate. Tracking this as a Boolean value is faster than checking this.vars.onUpdate == null.
		protected var _isDisplayObject:Boolean; //We need to know if the target is a DisplayObject so that we can apply visibility changes, do tint and Sound tweens, etc
		protected var _initted:Boolean;
		protected var _timeScale:Number; //Allows you to speed up or slow down a tween. Default is 1 (normal speed) 0.5 would be half-speed
		
		public function TweenLite($target:Object, $duration:Number, $vars:Object) {
			if ($target == null) {return};
			if (!_classInitted) {
				_curTime = getTimer();
				_sprite.addEventListener(Event.ENTER_FRAME, executeAll);
				if (overwriteManager == null) {
					overwriteManager = {mode:1, enabled:false};
				}
				_classInitted = true;
			}
			var mode:int = ($vars.overwrite == undefined || (!overwriteManager.enabled && $vars.overwrite > 1)) ? overwriteManager.mode : int($vars.overwrite);
			if (_all[$target] == undefined || ($target != null && mode == 1)) { 
				delete _all[$target];
				_all[$target] = new Dictionary(true);
			}
			_all[$target][this] = this;
			this.vars = $vars;
			this.duration = $duration || 0.001; //Easing equations don't work when the duration is zero.
			this.delay = $vars.delay || 0;
			_timeScale = $vars.timeScale || 1;
			_active = ($duration == 0 && this.delay == 0);
			this.target = $target;
			_isDisplayObject = ($target is DisplayObject);
			if (!(this.vars.ease is Function)) {
				this.vars.ease = defaultEase;
			}
			if (this.vars.easeParams != null) {
				this.vars.proxiedEase = this.vars.ease;
				this.vars.ease = easeProxy;
			}
			if (!isNaN(Number(this.vars.autoAlpha))) {
				this.vars.alpha = Number(this.vars.autoAlpha);
				this.vars.visible = (this.vars.alpha > 0);
			}
			this.tweens = [];
			_subTweens = [];
			_hst = _initted = false;
			this.initTime = _curTime;
			if ((this.vars.runBackwards == true && this.vars.renderOnStart != true) || _active) {
				initTweenVals();
				this.startTime = _curTime;
				if (_active) { //Means duration is zero and delay is zero, so render it now, but add one to the startTime because this.duration is always forced to be at least 0.001 since easing equations can't handle zero.
					render(this.startTime + 1);
				} else {
					render(this.startTime);
				}
				var v:* = this.vars.visible;
				if (this.vars.isTV == true) {
					v = this.vars.exposedProps.visible;
				}
				if (v != null && this.vars.runBackwards == true && _isDisplayObject) {
					this.target.visible = Boolean(v);
				}
			}
			if (!_listening && !_active) {
				_timer.addEventListener("timer", killGarbage);
            	_timer.start();
				_listening = true;
			}
		}
		
		public function initTweenVals($hrp:Boolean = false, $reservedProps:String = ""):void {
			var p:String, i:int;
			var v:Object = this.vars;
			if (v.isTV == true) {
				v = v.exposedProps; //Enables use of the TweenLiteVars, TweenFilterLiteVars, and TweenMaxVars utility classes.
			}
			if (!$hrp && overwriteManager.enabled) {
				overwriteManager.manageOverwrites(v, _all[this.target]);
			}
			if (this.target is Array) {
				var endArray:Array = this.vars.endArray || [];
				for (i = 0; i < endArray.length; i++) {
					if (this.target[i] != endArray[i] && this.target[i] != undefined) {
						this.tweens[this.tweens.length] = {o:this.target, p:i.toString(), s:this.target[i], c:endArray[i] - this.target[i], name:i.toString()}; //o: object, p:property, s:starting value, c:change in value,
					}
				}
			} else {
				
				if ((typeof(v.tint) != "undefined" || this.vars.removeTint == true) && _isDisplayObject) { //If we're trying to change the color of a DisplayObject, then set up a quasai proxy using an instance of a TweenLite to control the color.
					var clr:ColorTransform = this.target.transform.colorTransform;
					var endClr:ColorTransform = new ColorTransform();
					if (v.alpha != undefined) {
						endClr.alphaMultiplier = v.alpha;
						delete v.alpha;
					} else {
						endClr.alphaMultiplier = this.target.alpha;
					}
					if (this.vars.removeTint != true && ((v.tint != null && v.tint != "") || v.tint == 0)) { //In case they're actually trying to remove the colorization, they should pass in null or "" for the tint
						endClr.color = v.tint;
					}
					addSubTween("tint", tintProxy, {progress:0}, {progress:1}, {target:this.target, color:clr, endColor:endClr});
				}
				if (v.frame != null && _isDisplayObject) {
					addSubTween("frame", frameProxy, {frame:this.target.currentFrame}, {frame:v.frame}, {target:this.target});
				}
				if (!isNaN(this.vars.volume) && this.target.hasOwnProperty("soundTransform")) { //If we're trying to change the volume of an object with a soundTransform property, then set up a quasai proxy using an instance of a TweenLite to control the volume.
					addSubTween("volume", volumeProxy, this.target.soundTransform, {volume:this.vars.volume}, {target:this.target});
				}
				
				for (p in v) {
					if (p == "ease" || p == "delay" || p == "overwrite" || p == "onComplete" || p == "onCompleteParams" || p == "runBackwards" || p == "visible" || p == "autoOverwrite" || p == "persist" || p == "onUpdate" || p == "onUpdateParams" || p == "autoAlpha" || p == "timeScale" || p == "onStart" || p == "onStartParams" ||p == "renderOnStart" || p == "proxiedEase" || p == "easeParams" || ($hrp && $reservedProps.indexOf(" " + p + " ") != -1)) { 
						
					} else if (!(_isDisplayObject && (p == "tint" || p == "removeTint" || p == "frame")) && !(p == "volume" && this.target.hasOwnProperty("soundTransform"))) {
						//if (this.target.hasOwnProperty(p)) { //REMOVED because there's a bug in Flash Player 10 (Beta) that incorrectly reports that DisplayObjects don't have a "z" property. This check wasn't entirely necessary anyway - it just prevented runtime errors if/when developers tried tweening properties that didn't exist.
							if (typeof(v[p]) == "number") {
								this.tweens[this.tweens.length] = {o:this.target, p:p, s:this.target[p], c:v[p] - this.target[p], name:p}; //o:object, p:property, s:starting value, c:change in value
							} else {
								this.tweens[this.tweens.length] = {o:this.target, p:p, s:this.target[p], c:Number(v[p]), name:p}; //o:object, p:property, s:starting value, c:change in value
							}
						//}
					}
				}
			}
			if (this.vars.runBackwards == true) {
				var tp:Object;
				for (i = this.tweens.length - 1; i > -1; i--) {
					tp = this.tweens[i];
					tp.s += tp.c;
					tp.c *= -1;
				}
			}
			if (v.visible == true && _isDisplayObject) {
				this.target.visible = true;
			}
			if (this.vars.onUpdate != null) {
				_hasUpdate = true;
			}
			_initted = true;
		}
		
		protected function addSubTween($name:String, $proxy:Function, $target:Object, $props:Object, $info:Object = null):void {
			var sub:Object = {name:$name, proxy:$proxy, target:$target, info:$info};
			_subTweens[_subTweens.length] = sub;
			for (var p:String in $props) {
				if (typeof($props[p]) == "number") {
					this.tweens[this.tweens.length] = {o:$target, p:p, s:$target[p], c:$props[p] - $target[p], sub:sub, name:$name}; //o:Object, p:Property, s:Starting value, c:Change in value, sub:Subtween object;
				} else {
					this.tweens[this.tweens.length] = {o:$target, p:p, s:$target[p], c:Number($props[p]), sub:sub, name:$name};
				}
			}
			_hst = true; //has sub tweens. We track this with a boolean value as opposed to checking _subTweens.length for speed purposes
		}
		
		public static function to($target:Object, $duration:Number, $vars:Object):TweenLite {
			return new TweenLite($target, $duration, $vars);
		}
		
		//This function really helps if there are objects that we just want to animate into place (they are already at their end position on the stage for example). 
		public static function from($target:Object, $duration:Number, $vars:Object):TweenLite {
			$vars.runBackwards = true;
			return new TweenLite($target, $duration, $vars);
		}
		
		public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array = null):TweenLite {
			return new TweenLite($onComplete, 0, {delay:$delay, onComplete:$onComplete, onCompleteParams:$onCompleteParams, overwrite:0});
		}
		
		public function render($t:uint):void {
			var time:Number = ($t - this.startTime) / 1000, factor:Number, tp:Object, i:int;
			if (time >= this.duration) {
				time = this.duration;
				factor = 1;
			} else {
				factor = this.vars.ease(time, 0, 1, this.duration);
			}
			for (i = this.tweens.length - 1; i > -1; i--) {
				tp = this.tweens[i];
				tp.o[tp.p] = tp.s + (factor * tp.c);
			}
			if (_hst) { //has sub-tweens
				for (i = _subTweens.length - 1; i > -1; i--) {
					_subTweens[i].proxy(_subTweens[i]);
				}
			}
			if (_hasUpdate) {
				this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
			}
			if (time == this.duration) {
				complete(true);
			}
		}
		
		public static function executeAll($e:Event = null):void {
			var t:uint = _curTime = getTimer();
			if (_listening) {
				var a:Dictionary = _all, p:Object, tw:Object;
				for each (p in a) {
					for (tw in p) {
						if (p[tw] != undefined && p[tw].active) {
							p[tw].render(t);
						}
					}
				}
			}
		}
		
		public function complete($skipRender:Boolean = false):void {
			if (!$skipRender) {
				if (!_initted) {
					initTweenVals();
				}
				this.startTime = _curTime - (this.duration * 1000) / _timeScale;
				render(_curTime); //Just to force the final render
				return;
			}
			if (this.vars.visible != undefined && _isDisplayObject) {
				if (!isNaN(this.vars.autoAlpha) && this.target.alpha == 0) {
					this.target.visible = false;
				} else if (this.vars.runBackwards != true) {
					this.target.visible = this.vars.visible;
				}
			}
			if (this.vars.persist != true) {
				removeTween(this); //moved above the onComplete callback in case there's an error in the user's onComplete - this prevents constant errors
			}
			if (this.vars.onComplete != null) {
				this.vars.onComplete.apply(null, this.vars.onCompleteParams);
			}
		}
		
		public static function removeTween($t:TweenLite = null):void {
			if ($t != null && _all[$t.target] != undefined) {
				_all[$t.target][$t] = null; //prevents garbage collection issues.
				delete _all[$t.target][$t];
			}
		}
		
		public static function killTweensOf($tg:Object = null, $complete:Boolean = false):void {
			if ($tg != null && _all[$tg] != undefined) {
				if ($complete) {
					var o:Object = _all[$tg];
					for (var tw:* in o) {
						o[tw].complete(false);
					}
				}
				delete _all[$tg];
			}
		}
		
		public function killVars($vars:Object):void {
			if (overwriteManager.enabled) {
				overwriteManager.killVars($vars, this.vars, this.tweens, _subTweens, []);
			}
		}
		
		public static function killGarbage($e:TimerEvent):void {
			var tg_cnt:uint = 0, found:Boolean, p:Object, twp:Object, tw:Object;
			for (p in _all) {
				found = false;
				for (twp in _all[p]) {
					found = true;
					break;
				}
				if (!found) {
					delete _all[p];
				} else {
					tg_cnt++;
				}
			}
			if (tg_cnt == 0) {
				_timer.removeEventListener("timer", killGarbage);
				_timer.stop();
				_listening = false;
			}
		}
		
		public static function easeOut($t:Number, $b:Number, $c:Number, $d:Number):Number {
			return -$c * ($t /= $d) * ($t - 2) + $b;
		}
		
//---- PROXY FUNCTIONS ------------------------------------------------------------------------
		
		protected function easeProxy($t:Number, $b:Number, $c:Number, $d:Number):Number { //Just for when easeParams are passed in via the vars object.
			return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
		}
		public static function tintProxy($o:Object):void {
			var n:Number = $o.target.progress, r:Number = 1 - n, sc:Object = $o.info.color, ec:Object = $o.info.endColor;
			$o.info.target.transform.colorTransform = new ColorTransform(sc.redMultiplier * r + ec.redMultiplier * n,
																		  sc.greenMultiplier * r + ec.greenMultiplier * n,
																		  sc.blueMultiplier * r + ec.blueMultiplier * n,
																		  sc.alphaMultiplier * r + ec.alphaMultiplier * n,
																		  sc.redOffset * r + ec.redOffset * n,
																		  sc.greenOffset * r + ec.greenOffset * n,
																		  sc.blueOffset * r + ec.blueOffset * n,
																		  sc.alphaOffset * r + ec.alphaOffset * n);
		}
		public static function frameProxy($o:Object):void {
			$o.info.target.gotoAndStop(Math.round($o.target.frame));
		}
		public static function volumeProxy($o:Object):void {
			$o.info.target.soundTransform = $o.target;
		}
		
		
//---- GETTERS / SETTERS -----------------------------------------------------------------------
		
		public function get active():Boolean {
			if (_active) {
				return true;
			} else if ((_curTime - this.initTime) / 1000 > this.delay) {
				_active = true;
				this.startTime = this.initTime + (this.delay * 1000);
				if (!_initted) {
					initTweenVals();
				} else if (this.vars.visible != undefined && _isDisplayObject) {
					this.target.visible = true;
				}
				if (this.vars.onStart != null) {
					this.vars.onStart.apply(null, this.vars.onStartParams);
				}
				if (this.duration == 0.001) { //In the constructor, if the duration is zero, we shift it to 0.001 because the easing functions won't work otherwise. We need to offset the this.startTime to compensate too.
					this.startTime -= 1;
				}
				return true;
			} else {
				return false;
			}
		}
		
	}
	
}