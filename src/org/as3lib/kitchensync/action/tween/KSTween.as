package org.as3lib.kitchensync.action.tween
{
	import org.as3lib.kitchensync.KitchenSyncDefaults;
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.easing.EasingUtil;
	import org.as3lib.kitchensync.utils.*;
	
	/**
	 * A tween will change an object's numeric value over time.
	 * Uses a TweenTarget object to determine what to tween. This can be handled automatically
	 * or declared explicitly.
	 * Rule of thumb: KSTween is the action that handles the timing and starting and stopping
	 * the tween while ITweenTargets control the values of the tween.
	 * 
	 * @see org.as3lib.kitchensync.action.tween.ITweenTarget
	 * @see org.as3lib.kitchensync.action.KSSimpleAction
	 * @since 0.1
	 * @author Mims Wright
	 */
	 // todo: review
	 // todo: add example
	public class KSTween extends AbstractAction implements ITween, IPrecisionAction
	{
		/**
		 * Use this property to cause the tween to start from whatever the targetProperty is 
		 * set to at the time the tween executes.
		 */
		 // todo: move this to a more appropriate place
		public static const VALUE_AT_START_OF_TWEEN:Number = NaN;
		
		/** @inheritDoc */
		public function get easingFunction():Function { return _easingFunction; }
		public function set easingFunction(easingFunction:Function):void{ _easingFunction = easingFunction;}
		protected var _easingFunction:Function;
		
		
		/**
		 * A list of tween targets used by this tween.
		 * 
		 * @see org.as3lib.kitchensync.action.tween.ITweenTarget
		 * @see org.as3lib.kitchensync.action.tween.TargetProperty
		 */
		protected var _tweenTargets:Array;
		public function get tweenTargets():Array { return _tweenTargets; }
		
		public function addTweenTarget(tweenTarget:ITweenTarget):void { _tweenTargets.push(tweenTarget); }
		public function removeTweenTarget(tweenTarget:ITweenTarget):void { 
			var index:int = _tweenTargets.indexOf(tweenTarget);
			if (index >= 0) {
				_tweenTargets.splice(index, 1);
			}
		}
		public function removeAllTweenTargets():void {
			_tweenTargets = new Array();
		}
		
		/** @inheritDoc */
		public function get easingMod1():Number { return _easingMod1; }
		public function set easingMod1(easingMod1:Number):void { _easingMod1 = easingMod1; }
		protected var _easingMod1:Number;

		/** @inheritDoc */
		public function get easingMod2():Number { return _easingMod2; }
		public function set easingMod2(easingMod2:Number):void { _easingMod2 = easingMod2; }
		protected var _easingMod2:Number;
		
		/**
		 * Indicates whether the final value for the easing function should snap to the 
		 * target _toValue. If set to true, the target property will equal _toValue regardless
		 * of the results of the easing function.
		 * 
		 * @default true
		 */
		public function get snapToValueOnComplete():Boolean { return _snapToValueOnComplete; }
		public function set snapToValueOnComplete(snapToValueOnComplete:Boolean):void { _snapToValueOnComplete = snapToValueOnComplete; }
		protected var _snapToValueOnComplete:Boolean;
		
		/**
		 * Indicates whether tweened values should snap to whole value numbers or use decimals.
		 * If set to true, the results of the easing functions on the target property will be 
		 * rounded to the nearest integer.
		 * 
		 * @see org.as3lib.kitchensync.ActionDefaults
		 // todo rename to snapToInteger 
		public function get snapToWholeNumber():Boolean { return _snapToWholeNumber; }
		public function set snapToWholeNumber(snapToWholeNumber:Boolean):void { _snapToWholeNumber = snapToWholeNumber; }
		protected var _snapToWholeNumber:Boolean;
		 */
		
		
		/**
		 * Constructor.
		 * 
		 * @see #newWithTweenTarget()
		 * 
		 * @param target - the object whose property will be changed (or an ITweenTarget, but it would be better to use newWithTweenTarget)
		 * @param property - the name of the property to change. The property must be a Number, int or uint such as a Sprite object's "alpha"
		 * @param startValue - the value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param endValue - the starting value of the tween. By default, this is the value of the property before the tween begins.
		 * @param duration - the time in milliseconds that this tween will take to execute. String values are acceptable too.
		 * @param delay - the time to wait in milliseconds before starting the tween. String values are acceptable too.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 */
		public function KSTween(target:Object = null, property:String = "", startValue:Number = VALUE_AT_START_OF_TWEEN, endValue:Number = 0, duration:* = 0, delay:* = 0, easingFunction:Function = null)
		{
			super();
			_tweenTargets = new Array();
			
			// If target is a tweenTarget...
			if (target is ITweenTarget) {
				// use the tweenTarget and ignore the first four params.
				// (it's recommended that you use newWithTweenTarget() instead)
				addTweenTarget(ITweenTarget(target));
			} else if (target is Array) {
				// add the items in the array to the tweenTargets list and ignore the rest of the params.
				var tweenTargetArray:Array = target as Array;
				for each (var tweenTarget:ITweenTarget in tweenTargetArray) {
					addTweenTarget(tweenTarget);
				}
			} else if (target != null) {
				// otherwise, create a TargetProperty object.
				addTweenTarget(new TargetProperty(target, property, startValue, endValue));
			}
			
			// todo: move to ITweenTarget?
			snapToValueOnComplete = KitchenSyncDefaults.snapToValueOnComplete;
			
			this.duration = duration;
			this.delay = delay;
			
			if (easingFunction == null) { 
				easingFunction = KitchenSyncDefaults.easingFunction;
			}
			_easingFunction = easingFunction;
		}
		
		/**
		 * Alternative constructor: creates a new KSTween using an ITweenTarget that you pass into it.
		 * 
		 * @param tweenTarget An explicitly defined tweenTarget object (or an array of tweentargets) that contains the values you want to tween.
		 * @param duration - the time in frames that this tween will take to execute.
		 * @param delay - the time to wait before starting the tween.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 * @return A new KSTween object.
		 */
		public static function newWithTweenTarget(tweenTarget:*, duration:* = 0, delay:* = 0, easingFunction:Function = null):KSTween {
			if (tweenTarget is Array || tweenTarget is ITweenTarget)  {
				return new KSTween(tweenTarget, "", NaN, NaN, duration, delay, easingFunction);
			}
			// else
			throw new TypeError("'tweenTarget' parameter must be of type ITweenTarget or of type Array (containting ITweenTarget).");
		} 

		/** @inheritDoc */
		override public function start():IAction {
			// use startAtTime with the default start time.
			return startAtTime(-1);
		}
		
		/** @inheritDoc */
		public function startAtTime(startTime:int):IPrecisionAction {
			if (_tweenTargets && _tweenTargets.length >= 0) { 
				super.start();
				if (startTime > 0) {
					_startTime = startTime;
				}
				return this;
			}
			// else 
			throw new Error("Tween must have at least one tween target. use addTweenTarget().");
			return null;
		}
		
		
		/**
		 * Stops the tween and sets the target property to the start value.
		 */
		override public function reset():void {
			stop();
			for each (var target:ITweenTarget in _tweenTargets) {
				target.reset();
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Executes the tween when start time has elapsed.
		 */
		override public function update(currentTime:int):void {
			var timeElapsed:int;
			var convertedDuration:int;
			
			// if the tween is running and the delay time has elapsed, perform tweening.
			if ( startTimeHasElapsed(currentTime) ) {
		 		timeElapsed = currentTime - _startTime - _delay;
		 		convertedDuration = duration;		 				 		
				
				var target:ITweenTarget
				
				// if this is the start of the tween.
				if (timeElapsed <= 1) {
					for each (target in _tweenTargets) {
						// if using the 'existing from value' set the start value at the time that the tween begins.
						if (target.startValue == VALUE_AT_START_OF_TWEEN) { 
							target.startValue = target.currentValue; 
						}
					}
				}
				
				// invoke the easing function.
				var result:Number =  EasingUtil.call(_easingFunction, timeElapsed, convertedDuration, _easingMod1, _easingMod2); 
				
				// apply the result to each tween target				
				for each (target in _tweenTargets) {
					// total change in values for the tween.
					//var delta:Number = target.endValue - target.startValue; 
					
					// set the tweenTarget's value.
					target.updateTween(result);
				}
				
				// if the tween's duration is complete.
				if (durationHasElapsed(currentTime)) {
					
					// if snapToValue is set to true, the target property will be set to the target value 
					// regardless of the results of the easing function.
					if (_snapToValueOnComplete) { 
						for each (target in _tweenTargets) {
							target.updateTween(1.0); 
						}
					}
					
					// end the tween.
					complete();
				}
			}
		}
		
		
		/**
		 * Flips the values for to and from values. Essentially, causes the animation to run backwards.
		 * 
		 * @see #cloneReversed()
		 */
		public function reverse():void {
			for each (var target:ITweenTarget in _tweenTargets) {
				var temp:Number = target.startValue;
				target.startValue = target.endValue;
				target.endValue = temp;
			}						
		}
		
		/** @inheritDoc */
		override public function clone():IAction {
			var clonedTargets:Array = new Array();
			for each (var target:ITweenTarget in _tweenTargets) {
				var tweenTargetClone:ITweenTarget = target.clone();
				clonedTargets.push(tweenTargetClone);
			}
			
			var clone:KSTween = newWithTweenTarget(clonedTargets, _duration, _delay, _easingFunction);
			clone._easingMod1 = _easingMod1;
			clone._easingMod2 = _easingMod2;
			clone.autoDelete = _autoDelete;
			clone.snapToValueOnComplete = _snapToValueOnComplete;
			return clone;
		}
		
		
		/**
		 * Creates a copy of this Tween which targets a different object and / or property.
		 * This is mostly used as a convenient way to reuse a tween, e.g. in a sequence.
		 * NOTE: If there are multiple target properties, this will only copy the first one in the array.
		 * 
		 * @example 
		 * <listing version="3.0">
		 *		var tween:Tween = new Tween(foo, "x", 100, 200);
		 *		var sequence:Sequence = new Sequence(
		 *			tween,							// tweens foo's x property from 100 to 200
		 *			tween.cloneWithTarget(foo, y)	// tweens foo's y property from 100 to 200
		 *			tween.cloneWithTarget(bar, y)	// tweens bar's y property from 100 to 200
		 *		);
		 *	</listing>
		 * 
		 * @see #clone()
		 * 
		 * @deprecated - use multiple targetProperties instead.
		 * @see #addTweenTarget()
		 * 
		 * @param target - The new object to target. Defaults to the same target as this.
		 * @param property - The new target object's property to target. 
		 * @return Tween - a copy of this tween with a new target/property.
		 */
		public function cloneWithTarget(target:Object, property:String):KSTween {
			// get the first target from the list.
			var tweenTarget:ITweenTarget = ITweenTarget(_tweenTargets[0]);
			// create a target property with the new target and property. 
			var newTargetProperty:TargetProperty = new TargetProperty(target, property, tweenTarget.startValue, tweenTarget.endValue);
			var clone:KSTween = KSTween(this.cloneWithTweenTarget(newTargetProperty));
			return clone;
		}
		
		/**
		 * Creates a new Tween and reverses the start and end values of the target property.
		 * 
		 * @example 
		 * 		<listing version="3.0">
		 * 			var tween:Tween = new Tween(foo, "x", 100, 200);
		 * 			var sequence:Sequence = new Sequence(
		 * 				tween,							// tweens foo's x from 100 to 200
		 * 				tween.cloneReversed()			// tweens foo's x from 200 to 100
		 * 				tween.cloneReversed(bar)		// tweens bar's x from 200 to 100
		 * 				tween.cloneReversed(foo, y)		// tweens foo's y from 200 to 100
		 * 			);
		 * 		</listing>
		 * 
		 * @see #cloneWithTarget()
		 * @see #reverse()
		 * 
		 * @param target - The optional target object of the new Tween
		 * @param property - The optional property to tween with the new Tween. 
		 * @returns Tween - A new Tween identical to this but with start and end reversed.
		 */
		public function cloneReversed(target:Object = null, property:String = null):KSTween {
			var clone:KSTween;
			if (target != null && property != null) {
			 	clone = KSTween(cloneWithTarget(target, property));
			} else {
				clone = KSTween(this.clone());
			}
			clone.reverse();
			return clone;
		}
		
		/**
		 * Clones the tween with a new tweenTarget.
		 * 
		 * @deprecated - Use multiple target properties insread.
		 * @see #addTweenTarget()
		 */
		public function cloneWithTweenTarget(tweenTarget:*):KSTween {
			var clone:KSTween = KSTween(this.clone());
			clone.removeAllTweenTargets();
			if (tweenTarget is ITweenTarget) {
				clone.addTweenTarget(tweenTarget);
			} else if (tweenTarget is Array) {
				for each (var target:ITweenTarget in tweenTarget) {
					clone.addTweenTarget(target);
				}
			} else {
				throw new TypeError("'tweenTarget' param must be of type Array or of type ITweenTarget");
			}
			return clone;
		}
		
		
		/** @inheritDoc */
		override public function kill():void {
			super.kill();
			removeAllTweenTargets();
		}
		
		/**
		 * Returns a description of the tween.
		 */
		override public function toString():String {
			var string:String = "KSTween[";
			for each (var target:ITweenTarget in _tweenTargets) {
				string += Object(target).toString() + ", ";
			} 
			string += "]";
			return string;
		}
	}
}