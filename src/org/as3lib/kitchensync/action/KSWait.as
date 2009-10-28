package org.as3lib.kitchensync.action
{
	import org.as3lib.kitchensync.core.*;
	
	/**
	 * Does nothing except wait. Can be used to delay a sequence.
	 * 
	 * @since 0.2
	 * @author Mims Wright
	 */
	 // todo: add example
	 // todo: review
	public class KSWait extends AbstractAction
	{
		override public function set duration(duration:*):void {
			throw new Error("duration is ignored for KSWait");
		}
		
		/**
		 * Constructor.
		 * 
		 * @param waitTime Time that the action will wait.
		 */
		public function KSWait (waitTime:*):void {
			super();
			this.delay = waitTime;
		}
		
		override public function update(currentTime:int):void {
			if (startTimeHasElapsed) {
				if (durationHasElapsed) {
					complete();
				}
			}
		}
		override public function clone():IAction {
			var clone:KSWait = new KSWait(_delay);
			clone.autoDelete = _autoDelete;
			return clone;
		}
	}
}