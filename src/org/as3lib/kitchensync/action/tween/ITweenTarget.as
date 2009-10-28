package org.as3lib.kitchensync.action.tween
{
	/**
	 * A bundle that wraps up a property or other value that can be tweened by a KSTween.
	 * Generally speaking, a KSTween will handle anything related to the timing of the tween
	 * while the ITweenTarget handles anything related to the values of the tween.
	 * 
	 * @author Mims Wright
	 * @since 1.5
	 * @see org.as3lib.kitchensync.action.KSTween
	 */
	public interface ITweenTarget extends INumericController
	{
		/**
		 * The main function that the Tween uses to update the TweenTarget. 
		 * Sets the percentage complete.
		 * 
		 * @example Typically this is implemented as such: 
		 * <listing version="3.0">	
		 * 	public function updateTween(percentComplete:Number):Number {
		 * 		return currentValue = percentComplete * (endValue - startValue) + startValue;
		 *	}
		 * </listing>
		 * 
		 * @param percentComplete a number between 0 and 1 (but sometimes more or less) that represents
		 * 		  the percentage of the tween that has been completed. This should update
		 * @return Number the new current value of the tween.
		 */
		function updateTween (percentComplete:Number):Number;
		
		/**
		 * The value that the tweenTarget will begin from.
		 */
		function get startValue():Number;
		function set startValue(startValue:Number):void;
		
		/**
		 * The value that the tweenTarget will end on.
		 */
		function get endValue():Number;
		function set endValue(endValue:Number):void;
		
		/** 
		 * Reset the value to it's pre-tweened state.
		 * (typically, sets the currentValue equal to the startValue) 
		 */
		function reset():void;
		
		/** Create a copy of the tweenTarget object */
		function clone():ITweenTarget;
	}
}