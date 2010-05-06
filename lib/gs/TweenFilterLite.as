/*
VERSION: 8.11
DATE: 8/29/2008
ACTIONSCRIPT VERSION: 3.0 (AS2 version is available)
UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenFilterLite.com (has link to AS3 version)
DESCRIPTION:
	TweenFilterLite extends the extremely lightweight (about 3k), powerful TweenLite class, adding the ability to tween filters (like blurs, 
	glows, drop shadows, bevels, etc.) as well as image effects like contrast, colorization, brightness, saturation, hue, and threshold (combined size: about 6k). 
	The syntax is identical to the TweenLite class. If you're unfamiliar with TweenLite, I'd highly recommend that you check it out. 
	It provides easy way to tween multiple object properties over time including a MovieClip's position, alpha, volume, color, etc. 
	Just like the TweenLite class, TweenFilterLite allows you to build in a delay, call any function when the tween starts or has completed
	(even passing any number of parameters you define), automatically kill other tweens that are affecting the same object (to avoid conflicts),
	tween arrays, etc. One of the big benefits of this class (and the reason "Lite" is in the name) is that it was carefully built to 
	minimize file size. There are several other Tweening engines out there, but in my experience, they required more than triple the 
	file size which was unacceptable when dealing with strict file size requirements (like banner ads). I haven't been able to find a 
	faster tweening engine either. TweenFilterLite is simple, very fast, and extremely lightweight.
	
	If you're looking for more features, check out TweenFilterLite's big brother, TweenMax at www.TweenMax.com

ARGUMENTS:
	1) $target : Object - Target whose properties we're tweening
	2) $duration : Number - Duration (in seconds) of the effect
	3) $vars : Object - An object containing the end values of all the properties you'd like to have tweened (or if you're using the 
					  TweenFilterLite.from() method, these variables would define the BEGINNING values). Pass in one object for each filter
					  (named appropriately, like blurFilter, glowFilter, colorMatrixFilter, etc.) Filter objects can contain any number of
					  properties specific to that filter, like blurX, blurY, contrast, color, distance, colorize, brightness, highlightAlpha, etc. 
		  SPECIAL PROPERTIES: 
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
							  to end up at(or begin at if you're using TweenFilterLite.from()). An example hex value would be 0xFF0000.
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
										actually begins, set this to true. By default, it's false which causes TweenFilterLite.from() to render
										its values immediately, even before the delay has expired.
			  timeScale : Number - Multiplier that controls the speed of the tween (perceived duration) where 1 = normal speed, 0.5 = half speed, 2 = double speed, etc. 
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
			  					
			  blurFilter : Object - To apply a BlurFilter, pass an object with one or more of the following properties:
								    blurX, blurY, quality
			  glowFilter : Object - To apply a GlowFilter, pass an object with one or more of the following properties:
			  						alpha, blurX, blurY, color, strength, quality, inner, knockout
			  colorMatrixFilter : Object - To apply a ColorMatrixFilter, pass an object with one or more of the following properties:
										   colorize, amount, contrast, brightness, saturation, hue, threshold, relative, matrix
			  dropShadowFilter : Object - To apply a ColorMatrixFilter, pass an object with one or more of the following properties:
										  alpha, angle, blurX, blurY, color, distance, strength, quality
			  bevelFilter : Object - To apply a BevelFilter, pass an object with one or more of the following properties:
									 angle, blurX, blurY, distance, highlightAlpha, highlightColor, shadowAlpha, shadowColor, strength, quality
	

EXAMPLES: 
	As a simple example, you could tween the blur of clip_mc from where it's at now to 20 over the course of 1.5 seconds by:
		
		import gs.TweenFilterLite;
		TweenFilterLite.to(clip_mc, 1.5, {blurFilter:{blurX:20, blurY:20}});
	
	To set up a sequence where we colorize a MovieClip red over the course of 2 seconds, and then blur it over the course of 1 second,:
	
		import gs.TweenFilterLite;
		TweenFilterLite.to(clip_mc, 2, {colorMatrixFilter:{colorize:0xFF0000, amount:1}});
		TweenFilterLite.to(clip_mc, 1, {blurFilter:{blurX:20, blurY:20}, delay:2, overwrite:false});
		
	If you want to get more advanced and tween the clip_mc MovieClip over 5 seconds, changing the saturation to 0, 
	delay starting the whole tween by 2 seconds, and then call a function named "onFinishTween" when it has 
	completed and pass in a few arguments to that function (a value of 5 and a reference to the clip_mc), you'd 
	do so like:
		
		import gs.TweenFilterLite;
		import fl.motion.easing.Back;
		TweenFilterLite.to(clip_mc, 5, {colorMatrixFilter:{saturation:0}, delay:2, onComplete:onFinishTween, onCompleteParams:[5, clip_mc]});
		function onFinishTween(argument1:Number, argument2:MovieClip):void {
			trace("The tween has finished! argument1 = " + argument1 + ", and argument2 = " + argument2);
		}
	
	If you have a MovieClip on the stage that already has the properties you'd like to end at, and you'd like to 
	start with a colorized version (red: 0xFF0000) and tween to the current properties, you could:
		
		import gs.TweenFilterLite;
		TweenFilterLite.from(clip_mc, 5, {type:"color", colorize:0xFF0000});		
	

NOTES:
	- This class (along with the TweenLite class which it extends) will add about 6kb total to your Flash file.
	- Requires that you target Flash 9 Player or later (ActionScript 3.0).
	- Quality defaults to a level of "2" for all filters, but you can pass in a value to override it.
	- The image filter (colorMatrixFilter) functions were built so that you can leverage this class to manipulate matrixes for the
	  ColorMatrixFilter by calling the static functions directly (so you don't necessarily have to be tweening 
	  anything). For example, you could colorize a matrix by:
	  var myNewMatrix:Array = TweenFilterLite.colorize(myOldMatrix, 0xFF0000, 1);
	- Special thanks to Mario Klingemann (http://www.quasimondo.com) for the work he did on his ColorMatrix class.
	  It was very helpful for the image effects.

	  
CHANGE LOG:
	8.1:
		- Added timeScale special property
	8.05:
		- Added the ability to overwrite only individual overlapping properties with the new OverwriteManager class and "autoOverwrite" special property
		- Added the killVars() method
		- Fixed potential garbage collection bug
		- added static removeTween() method
	7.35:
		- Improved compatibility with TweenFilterLiteVars utility class (for strict data typing and code hinting)
		- Speed optimizations
	7.3:
		- Added "persist" special property
		- Added "removeTint" special property
		- Added compatibility with TweenFilterLiteVars utility class
	7.2:
		- Added "visible" special property
	7.11:
		- Fixed 1009 error in from() calls that was introduced in version 7.1
	7.1: 
		- Enhanced speed by tweaking some internal code.
	7.04:
		- Added ability to define a "matrix" property for colorMatrixFilters.
	7.03:
		- Fixed to() and from() methods to accept an Object as the target instead of only DisplayObjects
	7.01:
		- SIGNIFICANT: Changed the syntax for defining filters. OLD: TweenFilterLite.to(mc, 2, {type:"blur", blurX:20, blurY:20}), NEW: TweenFilterLite.to(mc, 2, {blurFilter:{blurX:20, blurY:20}})
	  
CODED BY: Jack Doyle, jack@greensock.com
Copyright 2008, GreenSock (This work is subject to the terms in http://www.greensock.com/terms_of_use.html.)
*/

package gs {
	import gs.TweenLite;
	import flash.filters.*;
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	
	public class TweenFilterLite extends TweenLite {
		public static var version:Number = 8.11;
		public static var delayedCall:Function = TweenLite.delayedCall; //Otherwise TweenFilterLite.delayedCall() would throw errors (it's a static method of TweenLite)
		public static var killTweensOf:Function = TweenLite.killTweensOf; //Otherwise TweenFilterLite.killTweensOf() would throw errors (it's a static method of TweenLite)
		public static var killDelayedCallsTo:Function = TweenLite.killTweensOf; //Otherwise TweenFilterLite.killDelayedCallsTo() would throw errors (it's a static method of TweenLite)
		public static var removeTween:Function = TweenLite.removeTween;
		public static var defaultEase:Function = TweenLite.defaultEase;
		private static var _idMatrix:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
		private static var _lumR:Number = 0.212671; //Red constant - used for a few color matrix filter functions
		private static var _lumG:Number = 0.715160; //Green constant - used for a few color matrix filter functions
		private static var _lumB:Number = 0.072169; //Blue constant - used for a few color matrix filter functions
		protected var _matrix:Array;
		protected var _endMatrix:Array;
		protected var _cmf:ColorMatrixFilter;
		protected var _clrsa:Array; //Array that pertains to any color properties (like "color", "highlightColor", "shadowColor", etc.)
		protected var _hf:Boolean = false; //Has filters
		protected var _filters:Array = []; //Contains objects, one for each filter that's being tweened. Each object contains the following properties: filter, type
		protected var _originalEase:Function; //in TweenMax, on the up phase of a yoyo or when reverse() is called, we temporarily swap out the easing function for a reverse one, so we store the original here.
		
		public function TweenFilterLite($target:Object, $duration:Number, $vars:Object) {
			super($target, $duration, $vars);
			_originalEase = this.vars.ease;
			if (TweenLite.version < 8.11) {
				trace("TweenFilterLite error! Please update your TweenLite class or try deleting your ASO files. TweenFilterLite requires a more recent version. Download updates at http://www.TweenLite.com.");
			}
			if ($vars.type != undefined) { //warning about backwards compatibility
				trace("TweenFilterLite error: " + $target + " is using deprecated syntax. Please update to the new syntax. See http://www.TweenFilterLite.com for details.");
			}
		}
		
		public static function to($target:Object, $duration:Number, $vars:Object):TweenFilterLite {
			return new TweenFilterLite($target, $duration, $vars);
		}
		
		//This function really helps if there are MovieClips whose filters we want to animate into place (they are already in their end state on the stage for example). 
		public static function from($target:Object, $duration:Number, $vars:Object):TweenFilterLite {
			$vars.runBackwards = true;
			return new TweenFilterLite($target, $duration, $vars);
		}
		
		override public function initTweenVals($hrp:Boolean = false, $reservedProps:String = ""):void {
			if (!$hrp && TweenLite.overwriteManager.enabled) {
				var v:Object = this.vars;
				if (v.isTV == true) {
					v = v.exposedProps; //Enables use of the TweenLiteVars, TweenFilterLiteVars, and TweenMaxVars utility classes.
				}
				TweenLite.overwriteManager.manageOverwrites(v, _all[this.target]);
			}
			_clrsa = [];
			_filters = [];
			_matrix = _idMatrix.slice();
			$reservedProps += " blurFilter glowFilter colorMatrixFilter dropShadowFilter bevelFilter ";
			if (_isDisplayObject) {
				var i:int, fv:Object; //filter vars
				if (this.vars.blurFilter != null) {
					fv = this.vars.blurFilter;
					addFilter("blurFilter", fv, BlurFilter, ["blurX", "blurY", "quality"], new BlurFilter(0, 0, fv.quality || 2));
				}
				if (this.vars.glowFilter != null) {
					fv = this.vars.glowFilter;
					addFilter("glowFilter", fv, GlowFilter, ["alpha", "blurX", "blurY", "color", "quality", "strength", "inner", "knockout"], new GlowFilter(0xFFFFFF, 0, 0, 0, fv.strength || 1, fv.quality || 2, fv.inner, fv.knockout));
				}
				if (this.vars.colorMatrixFilter != null) {
					fv = this.vars.colorMatrixFilter;
					var cmf:Object = addFilter("colorMatrixFilter", fv, ColorMatrixFilter, [], new ColorMatrixFilter(_matrix));
					_cmf = cmf.filter;
					_matrix = ColorMatrixFilter(_cmf).matrix;
					if (fv.matrix != null && fv.matrix is Array) {
						_endMatrix = fv.matrix;
					} else {
						if (fv.relative == true) {
							_endMatrix = _matrix.slice();
						} else {
							_endMatrix = _idMatrix.slice();
						}
						_endMatrix = setBrightness(_endMatrix, fv.brightness);
						_endMatrix = setContrast(_endMatrix, fv.contrast);
						_endMatrix = setHue(_endMatrix, fv.hue);
						_endMatrix = setSaturation(_endMatrix, fv.saturation);
						_endMatrix = setThreshold(_endMatrix, fv.threshold);
						if (!isNaN(fv.colorize)) {
							_endMatrix = colorize(_endMatrix, fv.colorize, fv.amount);
						} else if (!isNaN(fv.color)) { //Just in case they define "color" instead of "colorize"
							_endMatrix = colorize(_endMatrix, fv.color, fv.amount);
						}
					}
					for (i = 0; i < _endMatrix.length; i++) {
						if (_matrix[i] != _endMatrix[i] && _matrix[i] != undefined) {
							this.tweens[this.tweens.length] = {o:_matrix, p:i.toString(), s:_matrix[i], c:_endMatrix[i] - _matrix[i], name:"colorMatrixFilter"};
						}
					}
				}
				if (this.vars.dropShadowFilter != null) {
					fv = this.vars.dropShadowFilter;
					addFilter("dropShadowFilter", fv, DropShadowFilter, ["alpha", "angle", "blurX", "blurY", "color", "distance", "quality", "strength", "inner", "knockout", "hideObject"], new DropShadowFilter(0, 45, 0x000000, 0, 0, 0, 1, fv.quality || 2, fv.inner, fv.knockout, fv.hideObject));
				}
				if (this.vars.bevelFilter != null) {
					fv = this.vars.bevelFilter;
					addFilter("bevelFilter", fv, BevelFilter, ["angle", "blurX", "blurY", "distance", "highlightAlpha", "highlightColor", "quality", "shadowAlpha", "shadowColor", "strength"], new BevelFilter(0, 0, 0xFFFFFF, 0.5, 0x000000, 0.5, 2, 2, 0, fv.quality || 2));
				}
				
				if (this.vars.runBackwards == true) {
					var tp:Object;
					for (i = _clrsa.length - 1; i > -1; i--) {
						tp = _clrsa[i];
						tp.sr += tp.cr;
						tp.cr *= -1;
						tp.sg += tp.cg;
						tp.cg *= -1;
						tp.sb += tp.cb;
						tp.cb *= -1;
						tp.f[tp.p] = (tp.sr << 16 | tp.sg << 8 | tp.sb); //Translates RGB to HEX
					}
				}
				super.initTweenVals(true, $reservedProps);
			} else {
				super.initTweenVals($hrp, $reservedProps);
			}
		}
		
		private function addFilter($name:String, $fv:Object, $filterType:Class, $props:Array, $defaultFilter:BitmapFilter):Object {
			var f:Object = {type:$filterType, name:$name}, fltrs:Array = this.target.filters, i:int, prop:String, valChange:Number, begin:Object, end:Object;
			for (i = 0; i < fltrs.length; i++) {
				if (fltrs[i] is $filterType) {
					f.filter = fltrs[i];
					break;
				}
			}
			if (f.filter == undefined) {
				f.filter = $defaultFilter;
				fltrs[fltrs.length] = f.filter;
				this.target.filters = fltrs;
			}
			for (i = 0; i < $props.length; i++) {
				prop = $props[i];
				if ($fv[prop] != undefined) {
					if (prop == "color" || prop == "highlightColor" || prop == "shadowColor") {
						begin = HEXtoRGB(f.filter[prop]);
						end = HEXtoRGB($fv[prop]);
						_clrsa[_clrsa.length] = {f:f.filter, p:prop, sr:begin.rb, cr:end.rb - begin.rb, sg:begin.gb, cg:end.gb - begin.gb, sb:begin.bb, cb:end.bb - begin.bb};
					} else if (prop == "quality" || prop == "inner" || prop == "knockout" || prop == "hideObject") {
						f.filter[prop] = $fv[prop];
					} else {
						if (typeof($fv[prop]) == "number") {
							valChange = $fv[prop] - f.filter[prop];
						} else {
							valChange = Number($fv[prop]);
						}
						this.tweens[this.tweens.length] = {o:f.filter, p:prop, s:f.filter[prop], c:valChange, name:$name};
					}
				}
			}
			_filters[_filters.length] = f;
			_hf = true;
			return f;
		}
		
		override public function render($t:uint):void {
			var time:Number = ($t - this.startTime) / 1000 * _timeScale, factor:Number, tp:Object, i:int;
			if (time >= this.duration) {
				time = this.duration;
				factor = (_originalEase == this.vars.ease) ? 1 : 0; //to accommodate TweenMax.reverse(). Without this, the last frame would render incorrectly
			} else {
				factor = this.vars.ease(time, 0, 1, this.duration);
			}
			
			for (i = this.tweens.length - 1; i > -1; i--) {
				tp = this.tweens[i];
				tp.o[tp.p] = tp.s + (factor * tp.c);
			}
			if (_hf) { //has filters
				var r:Number, g:Number, b:Number, j:int;
				for (i = _clrsa.length - 1; i > -1; i--) {
					tp = _clrsa[i];
					r = tp.sr + (factor * tp.cr);
					g = tp.sg + (factor * tp.cg);
					b = tp.sb + (factor * tp.cb);
					tp.f[tp.p] = (r << 16 | g << 8 | b); //Translates RGB to HEX
				}
				if (_cmf != null) {
					ColorMatrixFilter(_cmf).matrix = _matrix;
				}
				var f:Array = this.target.filters;
				for (i = 0; i < _filters.length; i++) {
					for (j = f.length - 1; j > -1; j--) {
						if (f[j] is _filters[i].type) {
							f.splice(j, 1, _filters[i].filter);
							break;
						}
					}
				}
				this.target.filters = f;
			}
			if (_hst) { //has sub-tweens
				for (i = _subTweens.length - 1; i > -1; i--) {
					_subTweens[i].proxy(_subTweens[i]);
				}
			}
			
			if (_hasUpdate) {
				this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
			}
			if (time == this.duration) { //Check to see if we're done
				complete(true);
			}
		}
		
		override public function killVars($vars:Object):void {
			if (TweenLite.overwriteManager.enabled) {
				TweenLite.overwriteManager.killVars($vars, this.vars, this.tweens, _subTweens, _filters);
			}
		}
		
		public static function HEXtoRGB($n:Number):Object {
			return {rb:$n >> 16, gb:($n >> 8) & 0xff, bb:$n & 0xff};
		}
		
//---- COLOR MATRIX FILTER FUNCTIONS -----------------------------------------------------------------------------------------------------------------------
		
		public static function colorize($m:Array, $color:Number, $amount:Number = 1):Array { //You can use 
			if (isNaN($color)) {
				return $m;
			} else if (isNaN($amount)) {
				$amount = 1;
			}
			var r:Number = (($color >> 16) & 0xff) / 255;
			var g:Number = (($color >> 8)  & 0xff) / 255;
			var b:Number = ($color         & 0xff) / 255;
			var inv:Number = 1 - $amount;
			var temp:Array =  [inv + $amount * r * _lumR, $amount * r * _lumG,       $amount * r * _lumB,       0, 0,
							  $amount * g * _lumR,        inv + $amount * g * _lumG, $amount * g * _lumB,       0, 0,
							  $amount * b * _lumR,        $amount * b * _lumG,       inv + $amount * b * _lumB, 0, 0,
							  0, 				          0, 					     0, 					    1, 0];		
			return applyMatrix(temp, $m);
		}
		
		public static function setThreshold($m:Array, $n:Number):Array {
			if (isNaN($n)) {
				return $m;
			}
			var temp:Array = [_lumR * 256, _lumG * 256, _lumB * 256, 0,  -256 * $n, 
						_lumR * 256, _lumG * 256, _lumB * 256, 0,  -256 * $n, 
						_lumR * 256, _lumG * 256, _lumB * 256, 0,  -256 * $n, 
						0,           0,           0,           1,  0]; 
			return applyMatrix(temp, $m);
		}
		
		public static function setHue($m:Array, $n:Number):Array {
			if (isNaN($n)) {
				return $m;
			}
			$n *= Math.PI / 180;
			var c:Number = Math.cos($n);
			var s:Number = Math.sin($n);
			var temp:Array = [(_lumR + (c * (1 - _lumR))) + (s * (-_lumR)), (_lumG + (c * (-_lumG))) + (s * (-_lumG)), (_lumB + (c * (-_lumB))) + (s * (1 - _lumB)), 0, 0, (_lumR + (c * (-_lumR))) + (s * 0.143), (_lumG + (c * (1 - _lumG))) + (s * 0.14), (_lumB + (c * (-_lumB))) + (s * -0.283), 0, 0, (_lumR + (c * (-_lumR))) + (s * (-(1 - _lumR))), (_lumG + (c * (-_lumG))) + (s * _lumG), (_lumB + (c * (1 - _lumB))) + (s * _lumB), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
			return applyMatrix(temp, $m);
		}
		
		public static function setBrightness($m:Array, $n:Number):Array {
			if (isNaN($n)) {
				return $m;
			}
			$n = ($n * 100) - 100;
			return applyMatrix([1,0,0,0,$n,
								0,1,0,0,$n,
								0,0,1,0,$n,
								0,0,0,1,0,
								0,0,0,0,1], $m);
		}
		
		public static function setSaturation($m:Array, $n:Number):Array {
			if (isNaN($n)) {
				return $m;
			}
			var inv:Number = 1 - $n;
			var r:Number = inv * _lumR;
			var g:Number = inv * _lumG;
			var b:Number = inv * _lumB;
			var temp:Array = [r + $n, g     , b     , 0, 0,
							  r     , g + $n, b     , 0, 0,
							  r     , g     , b + $n, 0, 0,
							  0     , 0     , 0     , 1, 0];
			return applyMatrix(temp, $m);
		}
		
		public static function setContrast($m:Array, $n:Number):Array {
			if (isNaN($n)) {
				return $m;
			}
			$n += 0.01;
			var temp:Array =  [$n,0,0,0,128 * (1 - $n),
							   0,$n,0,0,128 * (1 - $n),
							   0,0,$n,0,128 * (1 - $n),
							   0,0,0,1,0];
			return applyMatrix(temp, $m);
		}
		
		public static function applyMatrix($m:Array, $m2:Array):Array {
			if (!($m is Array) || !($m2 is Array)) {
				return $m2;
			}
			var temp:Array = [];
			var i:int = 0;
			var z:int = 0;
			var y:int, x:int;
			for (y = 0; y < 4; y++) {
				for (x = 0; x < 5; x++) {
					if (x == 4) {
						z = $m[i + 4];
					} else {
						z = 0;
					}
					temp[i + x] = $m[i]   * $m2[x]      + 
								  $m[i+1] * $m2[x + 5]  + 
								  $m[i+2] * $m2[x + 10] + 
								  $m[i+3] * $m2[x + 15] +
								  z;
				}
				i += 5;
			}
			return temp;
		}
		
//---- GETTERS / SETTERS ------------------------------------------------------------------------------------------------
	
		public function get timeScale():Number {
			return _timeScale;
		}
		public function set timeScale($n:Number):void {
			_timeScale = $n;
			if (_initted && _curTime > this.startTime) {
				this.startTime = _curTime - ((_curTime - this.startTime) * (1 / $n));
				this.initTime = this.startTime - (this.delay * 1000);
			}
		}
		
		
	}
	
}