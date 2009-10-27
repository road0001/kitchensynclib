package org.as3lib.kitchensync.action
{
	import flash.errors.*;
	import flash.events.*;
	
	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.core.*;
	import org.as3lib.kitchensync.utils.*;
	import org.as3lib.utils.AbstractEnforcer;
	
	[Event(name="actionStart", type="org.as3lib.kitchensync.KitchenSyncEvent")]
	[Event(name="actionPause", type="org.as3lib.kitchensync.KitchenSyncEvent")]
	[Event(name="actionUnpause", type="org.as3lib.kitchensync.KitchenSyncEvent")]
	[Event(name="actionComplete", type="org.as3lib.kitchensync.KitchenSyncEvent")]
	
	/**
	 * This can be any action that takes place at a specifity time and uses the Synchronizer class to coordinate
	 * timing. 
	 *
	 */ 
	 // todo - better implementation of ids
	public class AbstractAction extends EventDispatcher implements IAction
	{	
		
		/**
		 * duration is the length of time that the action will run.
		 * Will accept an integer or a parsable string.
		 * 
		 * @see org.as3lib.kitchensync.ITimeStringParser
		 * @see #timeUnit
		 */
		public function get duration():int { return _duration; }
		public function set duration(duration:*):void { 
			if (!isNaN(duration)) {
				_duration = duration;
			} else {
				var timeString:String = duration.toString();
				_duration = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
		}
		protected var _duration:int = 0;
		
		
		/**
		 * delay is the time that will pass after the start() method is called
		 * before the action begins.
		 * Will accept an integer or a parsable string.
		 * 
		 * @see org.as3lib.kitchensync.ITimeStringParser
		 */
		public function get delay():int { return _delay; }
		public function set delay(delay:*):void { 
			if (!isNaN(delay)) {
				_delay = delay;
			} else {
				var timeString:String = delay.toString();
				_delay = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
		}
		protected var _delay:int = 0;
		
		/** Returns true if the action will occur instantaneously when started */
		public function get isInstantaneous():Boolean {
			return ( _delay <= 0 && _duration <= 0 );
		}
		
		/** 
		 * legacy accessors. synonomous with delay.
		 */
		public function get offset():int { return offset; }
		public function set offset(offset:*):void { this.offset = offset; }
		
		
		/**
		 * autoDelete is a flag that indicates whether the action should be killed 
		 * when it is done executing. The default is set to false so the actions must 
		 * be deleted manually.
		 */
		public function get autoDelete():Boolean { return _autoDelete; }
		public function set autoDelete(autoDelete:Boolean):void { _autoDelete = autoDelete; }
		protected var _autoDelete:Boolean;
		
		
		/** 
		 * Setting sync to true will cause the action to sync up with real time
		 * even if framerate drops. Otherwise, the action will be synced to frames.
		 *
		 * @deprecated since v2.0
		 */ 
//		public function get sync():Boolean { return _sync; }
//		public function set sync(sync:Boolean):void { _sync = sync; }
//		protected var _sync:Boolean;
		
		
		// removed for now.
		/**
		 * The human-readable name of this action. 
		public function get name():String { return _name; }
		public function set name(name:String):void { _name = name; }
		protected var _name:String;
		 */
		
		
		/**
		 * Will return true when the action is running (after start() has been called).
		 * Will continue running until stop() is called or until the action is completed.
		 * Pausing does not change the value of isRunning.
		 */
		public function get isRunning ():Boolean { return _running; }
		protected var _running:Boolean = false;
		
		
		/**
		 * Will return true if the action is paused (after pause() has been called).
		 * Calling unpause() or stop() will return the value to false.
		 */ 
		public function get isPaused ():Boolean { return _paused; }
		protected var _paused:Boolean = false;
		
		
		/**
		 * The time at which the action was last started.
		 */
		public function get startTime():int { return _startTime; }
		protected var _startTime:int;
		
		/**
		 * The time at which the action was last paused.
		 */
		public function get pauseTime():int { return _pauseTime; }
		protected var _pauseTime:int;
		
		
		/**
		 * The time in ms since the start of the action or 0 if the action isn't running.
		 * If the action is paused, the result will be the running time at which it was paused.
		 */ 
		public function get runningTime():int { 
			if (!_running) { return 0; }
			// If the action is paused, factor that into your jump (resluts wont appear until it's restarted)
			if (isPaused) {
				return  (_pauseTime - _startTime);
			} else {
				return (Synchronizer.getInstance().currentTime - _startTime); 
			}
		}
		
		/**
		 * Constructor.
		 * @abstract
		 */
		public function AbstractAction()
		{
			super();
			autoDelete = KitchenSyncDefaults.autoDelete;
//			sync = KitchenSyncDefaults.sync;
			
			//AbstractEnforcer.enforceConstructor(this, AbstractAction);
		}
		
		/**
		 * Adds the action as a listener to the Synchronizer's update event.
		 */
		internal function register():void {
			Synchronizer.getInstance().registerClient(this);
			
			// since the first update won't occur until the next frame, force one here to make it
			// happen right away.
			forceUpdate();
		}
		
		/**
		 * Removes the action as a listener to the Synchronizer's update event.
		 */
		internal function unregister():void {
			Synchronizer.getInstance().unregisterClient(this);
		}
		
		/**
		 * Starts the timer for this action.
		 * Registers the action with the synchronizer.
		 * 
		 * @throws flash.errors.IllegalOperationError - if the method is called while the action is already running.
		 */
		public function start():IAction {
			if (_paused) {
				unpause();				
			} else {
				if (!_running) {
					_running = true;
					_startTime = Synchronizer.getInstance().currentTime;
					register();
					dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.START, _startTime));
				} else {
					throw new IllegalOperationError("The start() method cannot be called when the action is already running. Try stopping the action first or using the clone() method to create a copy of it.");
				}
			}
			return this;
		}
		
		/**
		 * Causes the action to be paused. The action temporarily ignores update events from the Synchronizer 
		 * and the onUpdate() handler will not be called. When unpause() is called,
		 * the action will continue at the point where it was paused.
		 * If the pause() method affects the start time even if the delay time hasn't expired yet. 
		 */
		public function pause():void {
			if (!_running) {
				// Do nothing
				
				//throw new IllegalOperationError("The pause() method cannot be called when the action is not already running or after it has finished running. Use the start() method first.");
			} else if (_paused) {
				//throw new IllegalOperationError("The pause() method cannot be called when the action is already paused. Use the unpause() method first.");
			} else {
				_pauseTime = Synchronizer.getInstance().currentTime;
				_paused = true;
				unregister();
				dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.PAUSE, _pauseTime));
			}
		}
		
		/**
		 * Resumes the action at the point where it was paused.
		 */
		public function unpause():void {
			if (!_running) {
				//throw new IllegalOperationError("The unpause() method cannot be called when the action is not already running or after it has finished running. Use the start() method first.");
			} else if (!_paused) {
				//throw new IllegalOperationError("The unpause() method cannot be called when the action is not already paused. Use the pause() method first.");
			} else {
				register();
				_paused = false;
				var timeSincePause:int = Synchronizer.getInstance().currentTime - _pauseTime;
				_startTime = _startTime + timeSincePause; 
				dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.UNPAUSE, _startTime));
				//trace("_pauseTime:", _pauseTime);
				//trace("_startTime:", _startTime);
				//trace("timeSincePause:", timeSincePause);
				
			}
		}
		
		
		/**
		 * Stops the action from running and resets the timer.
		 */
		public function stop():void {
			if (_running) { 
				_paused = false;
				_running = false;
				_startTime = -1;
				unregister();
			}
		}
		
		
		/**
		 * Moves the playhead to a specified time in the action. If this method is called while the 
		 * action is paused, it will not appear to jump until after the action is unpaused.
		 * This function won't work for instantaneous actions.
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
			if (!isRunning || isInstantaneous) { 
				// todo: make this error optional.
				throw new IllegalOperationError("Can't jump to time if the action isn't running or if duration is 0.");
				return; 
			}
			
			// parse time strings if this is a string.
			var jumpTime:int;
			//if time is a number
			if (!isNaN(time)) {
				jumpTime = int(time);
			} else {
				var timeString:String = time.toString();
				jumpTime = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
			
			// Ignore the delay in this equation if ignoreDelay is true.
			var totalDuration:int = ignoreDelay ? duration : duration + delay;
			
			var currentTime:int = Synchronizer.getInstance().currentTime;
			
			// check that the jump time is valid
			if (jumpTime > totalDuration || jumpTime < 0) {
				// you can't jump to a time that is past the end of the action's total time.
				// todo: make this error optional.
				throw new IllegalOperationError("'time' must be less than the total time of the action and greater than 0.");
			} else {
				// adjust the startTime to make it appear that the playhead should be at 
				// a different point in time on the next update.
				_startTime = -1 * (jumpTime - currentTime); //_startTime - jumpTime - runningTime;
				
				// if ignoring the delay, also move the playhead forward by the delay amount.
				if (ignoreDelay) { 
					_startTime = _startTime - delay; 
				} 
			}
		}
		
		/**
		 * Moves the playhead forward or backward by a specified time. If this method is called while the 
		 * action is paused, it will not appear to jump until after the action is unpaused.
		 * 
		 * @param time The time parameter can either be a number or a parsable time string.
		 */
		public function jumpByTime(time:*):void {
			// parse time strings if this is a string.
			var jumpTime:int;
			//if time is a number
			if (!isNaN(time)) {
				jumpTime = int(time);
			} else {
				var timeString:String = time.toString();
				jumpTime = KitchenSync.timeStringParser.parseTimeString(timeString);
			}
			
			jumpToTime(runningTime + jumpTime);
		}
				
		/**
		 * Causes the action to start playing when another event completes.
		 * 
		 * @param trigger Another action that will trigger the start of this action.
		 * @throws flash.errors.Error If the trigger action is the same as this action.
		 */
		public function addTrigger(trigger:IAction):void {
		 	if (trigger == this) { throw new Error("An action cannot be triggered by itself."); }
			trigger.addEventListener(KitchenSyncEvent.COMPLETE, onTrigger);
		}

		/**
		 * Removes a trigger added with addTrigger().
		 * 
		 * @param trigger Another action that triggers the start of this action.
		 */
		public function removeTrigger(trigger:IAction):void {
		 	trigger.removeEventListener(KitchenSyncEvent.COMPLETE, onTrigger);
		}
		
		/**
		 * Causes the action to start playing when a specified event is fired.
		 * 
		 * @param dispatcher The object that will dispatch the event.
		 * @param eventType The event type to listen for.
		 */
		public function addEventTrigger(dispatcher:IEventDispatcher, eventType:String):void {
			dispatcher.addEventListener(eventType, onTrigger);
		}

		/**
		 * Removes an event trigger added by addEventTrigger().
		 * 
		 * @param dispatcher The event dispatcher to remove.
		 * @param eventType The event type to listen for.
		 */
		public function removeEventTrigger(dispatcher:IEventDispatcher, eventType:String):void {
			dispatcher.removeEventListener(eventType, onTrigger);
		}
		
		/**
		 * Handler that starts playing the action that is called by a trigger event.
		 * @see #addTrigger()
		 * @see #addEventTrigger()
		 * 
		 */
		 // todo - make sure this doesn't screw up if there are multiple triggers or if the thing isn't meant to repeat.
		protected function onTrigger(event:Event):void {
			if (!_running) { start(); }
		}
		
		
		/**
		 * This function will be registered by the register method to respond to update events from the synchronizer.
		 * Code that performs the action associated with this object should go in this function.
		 * This function must be implemented by the subclass.
		 * The internal allows certain other classes such as the AbstractSynchronizedGroup to force an update 
		 * of its children.
		 * 
		 * @abstract
		 * @param currentTimestamp The current timestamp from the Synchronizer.
		 */
		public function update(currentTime:int):void {
			AbstractEnforcer.enforceMethod();
		}
		
		/**
		 * Foreces the update() method to fire without being triggered by Synchronizer.
		 * 
		 * @see #update()
		 */
		protected function forceUpdate():void {
			update(Synchronizer.getInstance().currentTime);
		}
		
		/**
		 * Checks to see whether the start time delay has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is ready to execute. Duration is handled seperately.
		 * @return false if _startTime is null, true if the delay has elapsed.
		 */
		 // todo: make this function use a parameter for currentTime instead of asking synchronizer
		 public function get startTimeHasElapsed():Boolean {
		 	if (isNaN(_startTime) || !_running || _paused) { return false; }
			if (_startTime + _delay <= Synchronizer.getInstance().currentTime) { return true; }
		 	return false;
		 }
		
		/**
		 * Checks to see whether the duration of the action has elapsed and if the _startTime is defined. In other words, 
		 * checks to see whether the action is finished executing. 
		 * @return false if _startTime is null, true if the duration has elapsed.
		 */
		 // todo: make this function use a parameter for currentTime instead of asking synchronizer
		 public function get durationHasElapsed():Boolean {
		 	if (isNaN(_startTime) || !_running || _paused) { return false; }
	 		if (_startTime + _delay + _duration <= Synchronizer.getInstance().currentTime) { return true; }		 		
		 	return false;
		 }
		 

		/**
		 * Creates a copy of the object with all the property values of the original and returns it.
		 * This method should be overrided by child classes to ensure that all properties are copied.
		 * 
		 * @abstract
		 * @returns AbstractSyncrhonizedAction - A copy of the original object. Type casting may be necessary.
		 */
		public function clone():IAction {
			AbstractEnforcer.enforceMethod();
			return this;
		}
				
		/**
		 * Call this when the action has completed.
		 */
		 // todo: make this function use a parameter for currentTime instead of asking synchronizer
		protected function complete():void {
			_running = false;
			unregister();
			dispatchEvent(new KitchenSyncEvent(KitchenSyncEvent.COMPLETE, Synchronizer.getInstance().currentTime));
			if (_autoDelete) { kill(); }
		}		
		
		/**
		 * Unregisters the function and removes any refrerences to objects that it may be holding onto.
		 * Subclass this function to remove references to objects used by the action.
		 */
		 public function kill():void {
		 	if (_running) { complete(); }
		 }
	}
}