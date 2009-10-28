package org.as3lib.kitchensync.action.tween
{
	/**
	 * Allows a control interface for translating values to and from numeric values. 
	 * e.g. setting a base-n number with a decimal number
	 * 
	 * @author Mims Wright
	 * @since 1.5
	 */
	 
	 // todo: move to a more appropriate package
	 // todo: better docs
	public interface INumericController
	{
		/**
		 * This is the current value of the number.
		 */
		function get currentValue():Number;
		function set currentValue(currentValue:Number):void;
		
	}
}