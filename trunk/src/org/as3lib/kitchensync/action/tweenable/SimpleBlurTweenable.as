package org.as3lib.kitchensync.action.tweenable
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	
	// todo documentation
	// todo make a target property tweenable for a blur filter.
	public class SimpleBlurTweenable implements IFilterTweenable
	{
		public function get currentValue():Number { return _blurXTweenable.currentValue; }
		public function set currentValue(currentValue:Number):void { 
			_blurXTweenable.currentValue = currentValue;
			_blurYTweenable.currentValue = currentValue;
		}
		
		public function get startValue():Number	{ return _startValue; }
		public function set startValue(startValue:Number):void { _startValue = startValue; }
		protected var _startValue:Number;
		
		public function get endValue():Number {	return _endValue; }
		public function set endValue(endValue:Number):void { _endValue = endValue; }
		protected var _endValue:Number;
		
		public function get target():DisplayObject { return _target; }
		public function set target(target:DisplayObject):void { _target = target; }
		protected var _target:DisplayObject;
		
		public function SimpleBlurTweenable(target:DisplayObject, startValue:Number, endValue:Number = 0) {
			_target = target;
			_startValue = startValue;
			_endValue = endValue;
			
			_blurXTweenable = new FilterTargetProperty(target, BlurFilter, "blurX", _startValue, _endValue);
			_blurYTweenable = new FilterTargetProperty(target, BlurFilter, "blurY", _startValue, _endValue);
		}

		protected var _blurXTweenable:FilterTargetProperty;
		protected var _blurYTweenable:FilterTargetProperty;

		/**
		 * The main function that the Tween uses to update the Tweenable. 
		 * Sets the percentage complete.
		 * 
		 * @param percentComplete a number between 0 and 1 (but sometimes more or less) that represents
		 * 		  the percentage of the tween that has been completed. This should update
		 * @return Number the new current value of the tween.
		 */
		public function updateTween(percentComplete:Number):Number {
			return currentValue = percentComplete * (endValue - startValue) + startValue;
		}
		
		public function reset():void {
			currentValue = _startValue;
		}
		
		public function clone():ITweenable {
			return new SimpleBlurTweenable(_target, _startValue, _endValue);
		}
		
	}
}