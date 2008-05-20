package org.as3lib.kitchensync.action
{
	import flash.errors.IllegalOperationError;
	
	import org.as3lib.kitchensync.KitchenSyncDefaults;
	import org.as3lib.kitchensync.action.tweenable.ITweenable;
	import org.as3lib.kitchensync.action.tweenable.TargetProperty;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.easing.EasingUtil;
	import org.as3lib.kitchensync.util.*;
	
	/**
	 * A tween will change an object's numeric value over time.
	 */
	 // todo - make getters and setters for most of the properties.
	 // todo - make target property accessable
	public class KSTween extends AbstractAction
	{
		/**
		 * Use this property to cause the tween to start from whatever the targetProperty is 
		 * set to at the time the tween executes.
		 */
		public static const EXISTING_FROM_VALUE:Number = Number.NEGATIVE_INFINITY;
		
		/**
		 * The function used to interpolated the values between the start and end points.
		 * 
		 * @see org.as3lib.kitchensync.easing
		 */
		public function get easingFunction():Function { return _easingFunction; }
		public function set easingFunction(easingFunction:Function):void{ _easingFunction = easingFunction;}
		protected var _easingFunction:Function;
		
		
		/**
		 * 
		 */
		protected var _tweenable:ITweenable;
		public function get tweenable():ITweenable { return _tweenable; }
		public function set tweenable(tweenable:ITweenable):void { _tweenable = tweenable; }
		
		
		/**
		 * Used to modify the results of the easing function. 
		 * This is only used on some functions such as Elastic.
		 */
		public function set easingMod1(easingMod1:Number):void { _easingMod1 = easingMod1; }
		public function get easingMod1():Number { return _easingMod1; }
		protected var _easingMod1:Number;

		/**
		 * Used to modify the results of the easing function. 
		 * This is only used on some functions such as Elastic.
		 */
		public function set easingMod2(easingMod2:Number):void { _easingMod2 = easingMod2; }
		public function get easingMod2():Number { return _easingMod2; }
		protected var _easingMod2:Number;
		
		/**
		 * Indicates whether the final value for the easing function should snap to the 
		 * target _toValue. If set to true, the target property will equal _toValue regardless
		 * of the results of the easing function.
		 * 
		 * @default true
		 */
		public function set snapToValueOnComplete(snapToValueOnComplete:Boolean):void { _snapToValueOnComplete = snapToValueOnComplete; }
		public function get snapToValueOnComplete():Boolean { return _snapToValueOnComplete; }
		protected var _snapToValueOnComplete:Boolean;
		
		/**
		 * Indicates whether tweened values should snap to whole value numbers or use decimals.
		 * If set to true, the results of the easing functions on the target property will be 
		 * rounded to the nearest integer.
		 * 
		 * @see org.as3lib.kitchensync.ActionDefaults
		 */
		 // todo test
		public function set snapToWholeNumber(snapToWholeNumber:Boolean):void { _snapToWholeNumber = snapToWholeNumber; }
		public function get snapToWholeNumber():Boolean { return _snapToWholeNumber; }
		protected var _snapToWholeNumber:Boolean;
		
		
		/**
		 * Constructor
		 * 
		 * 
		 * @param target - the object whose property will be changed (or an ITweenable, but it would be better to use newWithTweenable)
		 * @param property - the name of the property to change. The property must be a Number, int or uint such as a Sprite object's "alpha"
		 * @param toValue - the value to tween the property to. After the tween is done, this will be the value of the property.
		 * @param fromValue - the starting value of the tween. By default, this is the value of the property before the tween begins.
		 * @param duration - the time in frames that this tween will take to execute.
		 * @param delay - the time to wait before starting the tween.
		 * @param easingFunction - the function to use to interpolate the values between fromValue and toValue.
		 */
		public function KSTween(target:Object = null, property:String = "", startValue:Number = EXISTING_FROM_VALUE, endValue:Number = 0, duration:* = 0, delay:* = 0, easingFunction:Function = null)
		{
			super();
			var tweenable:ITweenable;
			
			if (target is ITweenable) {
				tweenable = ITweenable(target);
			} else {
				tweenable = new TargetProperty(target, property, startValue, endValue);
			}
			_tweenable = tweenable;
			
			snapToValueOnComplete = KitchenSyncDefaults.snapToValueOnComplete;
			snapToWholeNumber = KitchenSyncDefaults.snapToWholeNumber;
			
			this.duration = duration;
			this.delay = delay;
			
			if (easingFunction == null) { 
				easingFunction = KitchenSyncDefaults.easingFunction;
			}
			_easingFunction = easingFunction;
		}
		
		public static function newWithTweenable(tweenable:ITweenable, duration:* = 0, delay:* = 0, easingFunction:Function = null):KSTween {
			return new KSTween(tweenable, "", NaN, NaN, duration, delay, easingFunction);
		} 
		
		override public function start():AbstractAction {
			if (_tweenable == null) { 
				throw new Error("'tweenable' must not be null. Cannot start tween without a Tweenable target.");
				return null;
			}
			return super.start();
		}
		
		
		/**
		 * Stops the tween and sets the target property to the start value.
		 */
		public function reset():void {
			stop();
			_tweenable.reset();
		}
		
		/**
		 * Executes the tween.
		 */
		override protected function onUpdate(event:KitchenSyncEvent):void {
			var time:Timestamp = event.timestamp;
			var timeElapsed:int;
			var convertedDuration:int;
			if (startTimeHasElapsed) {
				if (_sync) {
			 		timeElapsed = time.currentTime - _startTime.currentTime - _delay;
			 		convertedDuration = duration;		 				 		
			 	} else {
			 		timeElapsed = time.currentFrame - _startTime.currentFrame - TimestampUtil.millisecondsToFrames(_delay);
			 		convertedDuration = TimestampUtil.millisecondsToFrames(duration);
			 	}
				//timeElapsed = time.currentFrame - _startTime.currentFrame - _delay;
				if (_tweenable.startValue == EXISTING_FROM_VALUE && timeElapsed <= 1) { 
					_tweenable.startValue = _tweenable.currentValue; 
				}
				var delta:Number = _tweenable.endValue - _tweenable.startValue; 
				var result:Number =  EasingUtil.call(_easingFunction, timeElapsed, convertedDuration, _easingMod1, _easingMod2) * delta + _tweenable.startValue; 
				if (_snapToWholeNumber) { result = Math.round(result); }
				
				_tweenable.currentValue = result;
				if (durationHasElapsed) {
					// if snapToValue is set to true, the target property will be set to the target value 
					// regardless of the results of the easing function.
					if (_snapToValueOnComplete) { _tweenable.currentValue = _tweenable.endValue; }
					complete();
				}
			}
		}
		
		
		
		/**
		 * Moves the playhead to a specified time in the action. If this method is called while the 
		 * action is paused, it will not appear to jump until after the action is unpaused.
		 * 
		 * @param time The time parameter can either be a number or a parsable time string. If the 
		 * time to jump to is greater than the total duration of the action, it will throw an IllegalOperationError.
		 * @param ignoreDelay If set to true, the delay will be ignored and the action will jump to
		 * the specified time in relation to the duration.
		 * 
		 * @throws flash.errors.IllegalOperationError If the time to jump to is longer than the total time for the action.
		 */
		public function jumpToTime(time:*, ignoreDelay:Boolean = false):void {
			// jumpToTime will fail if the action isn't running.
			if (!isRunning) { 
				throw new IllegalOperationError("Can't jump to time if the action isn't running.");
				return; 
			}
			
			// parse time strings if this is a string.
			var jumpTimeNumber:int;
			//if time is a number
			if (!isNaN(time)) {
				jumpTimeNumber = int(time);
			} else {
				var timeString:String = time.toString();
				jumpTimeNumber = timeStringParser.parseTimeString(timeString);
			}
			
			// Convert the jump time into a timestamp
			var jumpTime:Timestamp =TimestampUtil.getTimestampFromMilliseconds(jumpTimeNumber);
			
			// Ignore the delay in this equation if ignoreDelay is true.
			var totalDuration:int = ignoreDelay ? duration : duration + delay;
			
			// extract the jump time based on the action's timeUnit
			var offsetTimestamp:Timestamp;
			offsetTimestamp = TimestampUtil.getTimestampFromMilliseconds(delay);
			
			// check that the jump time is valid
			jumpTimeNumber = jumpTime.currentTime;
			if (jumpTimeNumber > totalDuration) {
				// you can't jump to a time that is past the end of the action's total time.
				throw new IllegalOperationError("'time' must be less than the total time of the action.");
			} else {
				// If the action is paused, factor that into your jump (resluts wont appear until it's restarted)
				var runningTime:Timestamp
				if (isPaused) {
					runningTime = TimestampUtil.subtract(_pauseTime, _startTime);
				} else {
					runningTime = TimestampUtil.subtract(Synchronizer.getInstance().currentTimestamp, _startTime); 
				} 
				
				// adjust the startTime to make it appear that the playhead should be at 
				// a different point in time on the next update.
				_startTime = TimestampUtil.subtract(_startTime, TimestampUtil.subtract(jumpTime, runningTime));
				
				// if ignoring the delay, also move the playhead forward by the delay amount.
				if (ignoreDelay) { 
					_startTime = TimestampUtil.subtract(_startTime, offsetTimestamp); 
				} 
			}
		}
		
		// TODO add jumpByTime() method
		
		
		
		
		/**
		 * Creates a new Tween and reverses the start and end values of the target property.
		 * 
		 * @use <code>
		 * 			var tween:Tween = new Tween(foo, "x", 100, 200);
		 * 			var sequence:Sequence = new Sequence(
		 * 				tween,							// tweens foo's x from 100 to 200
		 * 				tween.cloneReversed()			// tweens foo's x from 200 to 100
		 * 				tween.cloneReversed(bar)		// tweens bar's x from 200 to 100
		 * 				tween.cloneReversed(foo, y)		// tweens foo's y from 200 to 100
		 * 			);
		 * 		</code>
		 * 
		 * @see #cloneWithTarget()
		 * @see #reverse()
		 * 
		 * @param target - The optional target object of the new Tween
		 * @param property - The optional property to tween with the new Tween. 
		 * @returns Tween - A new Tween identical to this but with start and end reversed.
		 */
		public function cloneReversed(target:Object = null, property:String = null):KSTween {
			var clone:KSTween = KSTween(cloneWithTarget(target, property));
			clone.reverse();
			return clone;
		}
		
		/**
		 * Flips the values for to and from values. Essentially, causes the animation to run backwards.
		 * 
		 * @see #cloneReversed()
		 */
		public function reverse():void {
			var temp:Number = _tweenable.startValue;
			_tweenable.startValue = _tweenable.endValue;
			_tweenable.endValue = temp;						
		}
		
		
		/**
		 * Creates a copy of this Tween which targets a different object and / or property.
		 * This is mostly used as a convenient way to reuse a tween, e.g. in a sequence.
		 * 
		 * @use <code>
		 *		var tween:Tween = new Tween(foo, "x", 100, 200);
		 *		var sequence:Sequence = new Sequence(
		 *			tween,							// tweens foo's x property from 100 to 200
		 *			tween.cloneWithTarget(bar),		// tweens bar's x property from 100 to 200
		 *			tween.cloneWithTarget(foo, y)	// tweens foo's y property from 100 to 200
		 *			tween.cloneWithTarget(bar, y)	// tweens bar's y property from 100 to 200
		 *		);
		 *	</code>
		 * 
		 * @see #clone()
		 * 
		 * @param target - The new object to target. Defaults to the same target as this.
		 * @param property - The new target object's property to target. Defaults to the same property as this.
		 * @return Tween - a copy of this tween with a new target/property.
		 */
		public function cloneWithTarget(target:Object, property:String):KSTween {
			var clone:KSTween = KSTween(this.clone());
			var targetProperty:TargetProperty = new TargetProperty(target, property, clone._tweenable.startValue, clone._tweenable.endValue);
			clone._tweenable = targetProperty;
			return clone;
		}
		
		override public function clone():AbstractAction {
			var tweenableClone:ITweenable = _tweenable.clone();
			var clone:KSTween = newWithTweenable(tweenableClone, _duration, _delay, _easingFunction);
			clone._easingMod1 = _easingMod1;
			clone._easingMod2 = _easingMod2;
			clone.autoDelete = _autoDelete;
			clone.snapToValueOnComplete = _snapToValueOnComplete;
			clone.snapToWholeNumber = _snapToWholeNumber;
			return clone;
		}
		
		/**
		 * Clean up references to target
		 */
		override public function kill():void {
			super.kill();
			_tweenable = null;
		}
		
		/**
		 * Returns either the _id or a description of the tween.
		 */
		override public function toString():String {
			return "KSTween :" + Object(_tweenable).toString();
		}
	}
}