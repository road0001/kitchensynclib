package org.as3lib.kitchensync
{
	import org.as3lib.kitchensync.action.tween.*;
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.easing.*;
	import org.as3lib.kitchensync.utils.*;
	
	//TODO: add docs
	public class KitchenSyncDefaults
	{
		public static var syncrhonizerUsesWeakReferences:Boolean = false;
		
		// ALL ACTIONS
		public static var autoDelete:Boolean = false;
		public static var timeStringParser:ITimeStringParser = new TimeStringParser_en();
		public static var easingFunction:Function = Linear.ease;
		
		// TWEENS
		public static var snapToValueOnComplete:Boolean = true;
		public static var snapToInteger:Boolean = false;
		public static var tweenObjectParser:ITweenObjectParser = new KitchenSyncObjectParser();
		
		// GROUPS
		//public static var resetChildrenAtStart:Boolean = true;
	}
}