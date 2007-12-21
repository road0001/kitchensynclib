package com.mimswright.sync
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * A group of actions that executes in sequence seperated by a specified gap.
	 */
	public class Staggered extends Parallel
	{	
		
		protected var _stagger:int = 1000;
		public function get stagger():int { return _stagger;}
		public function set stagger(stagger:int):void { 
			if (Number(offset)) {
				_stagger = stagger; 
			} else {
				var timeString:String = stagger.toString();
				var result:TimeStringParserResult = timeStringParser.parseTimeString(timeString);
				_stagger = result.time;
				if (result.timeUnit) {
					_timeUnit = result.timeUnit;
				}
			}
			if (_stagger <= 0) {
				throw new RangeError("Stagger amount must be an integer greater than 0.");
			}
		}
		
		protected var _lastStartTime:Timestamp;
		
		
		/**
		 * Constructor.
		 * 
		 * @throws TypeError - if any children are not of type AbstractSynchronizedAction.
		 * 
		 * @params stagger - The amount of time to stagger between each action starting. 
		 *					 The first one will not stagger (but will use the offset for the Staggered object)
		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.
		 */
		public function Staggered (stagger:*, ... children) {
			this.stagger = stagger;
			for (var i:int = 0; i < children.length; i++) {
				if (children[i] is AbstractSynchronizedAction) {
					var action:AbstractSynchronizedAction = AbstractSynchronizedAction(children[i]);
					addAction(action); 
				} else {
					throw new TypeError ("All children must be of type AbstractSynchronizedAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where AbstractSynchronizedAction was expected.");
				}
			}
		}
		
		/**
		 * When the first update occurs, all of the child actions are started simultaniously.
		 * -todo: Currently, the child actions execute one frame late.
		 */
		override protected function onUpdate(event:SynchronizerEvent):void {
			var time:Timestamp = event.timestamp;
			if (startTimeHasElapsed) {
				if (!_lastStartTime) {
					_runningChildren = _childActions.length;
				}
				if (!_lastStartTime || time.currentFrame - _lastStartTime.currentFrame > convertToFrames(_stagger)) {
					_lastStartTime = time;
					var currentTime:int = time.currentFrame - convertToFrames(offset) - _startTime.currentFrame;
					var childActionIndex:int = Math.floor(currentTime / convertToFrames(_stagger));
					var childAction:AbstractSynchronizedAction = AbstractSynchronizedAction(_childActions[childActionIndex]);

					// add a listener to each action so that the completion of the entire group can be tracked.
					childAction.addEventListener(SynchronizerEvent.COMPLETE, onChildFinished);
					childAction.addEventListener(SynchronizerEvent.START, onChildStart);
					// start the child action
					childAction.start();
					
					// if this is the last child, unregister
					if (childActionIndex == _childActions.length - 1) {
						unregister();
					}
				}
			}
		}
		
		override public function clone():AbstractSynchronizedAction {
			var clone:Staggered = new Staggered(_stagger);
			clone.timeUnit = _timeUnit;
			clone._childActions = _childActions;
			clone.offset = _offset;
			clone.autoDelete = _autoDelete;
			return clone;
		}
		
		override public function toString():String {
			return "Staggered Group containing " + _childActions.length + " children";
		}
	}
}