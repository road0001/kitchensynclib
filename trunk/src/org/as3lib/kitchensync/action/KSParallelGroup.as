﻿package org.as3lib.kitchensync.action{	import flash.utils.getQualifiedClassName;		import org.as3lib.kitchensync.core.*;		/**	 * A group of actions that executes all at once the group is started and the delay is reached.	 * 	 * @author Mims Wright	 * @since 0.1	 */	 // todo: add example	 // todo: review	 // todo make total duration return the length of the longest child.	public class KSParallelGroup extends AbstractActionGroup	{					protected var _runningChildren:int = 0;				public  function get childrenAreRunning():Boolean { return _runningChildren > 0; }				override public function get totalDuration():int {			var longestChildDuration:int = 0;			for each (var child:IAction in childActions) {				var childDuration:int = child.delay + child.duration;				if (childDuration > longestChildDuration) {					longestChildDuration = childDuration;				}			}			return longestChildDuration;		}				/**		 * Constructor.		 * 		 * @throws TypeError - if any children are not of type AbstractSynchronizedAction.		 * 		 * @params children - a list of AbstractSynchronizedActions that will be added as children of the group.		 */		public function KSParallelGroup (... children) {			super();			for (var i:int = 0; i < children.length; i++) {				if (children[i] is IAction) {					var action:IAction = IAction(children[i]);					addAction(action); 				} else {					throw new TypeError ("All children must be of type IAction. Make sure you are not calling start() on the objects you've added to the group. Found " + getQualifiedClassName(children[i]) + " where IAction was expected.");				}			}		}				/**		 * When the first update occurs, all of the child actions are started simultaniously.		 */		override public function update(currentTime:int):void {			if (startTimeHasElapsed(currentTime) && !childrenAreRunning) {				// reset the number of running children.				_runningChildren = 0;								// for all child actions				for (var i:int=0; i < _childActions.length; i++) {					var childAction:IAction = IAction(_childActions[i]);					// add a listener to each action so that the completion of the entire group can be tracked.					childAction.addEventListener(KitchenSyncEvent.ACTION_START, onChildStart);					childAction.addEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);					// start the child action					childAction.start();					// add one running child.					_runningChildren++;				}				// once this has started, it doesn't need updates anymore.				unregister();			}		}						/**		 * Called when child actions are completed. After each is finished, checks to see if the entire set is 		 * complete. If not, it waits for the next child.		 * Completed children are removed from the array so they can be garbage collected.		 * 		 * @param event - The SynchronizerEvent.COMPLETE		 * @param event - The SynchronizerEvent.CHILD_COMPLETE		 */		override protected function onChildFinished (event:KitchenSyncEvent):void {			super.onChildFinished(event);			var childAction:IAction = IAction(event.target);			childAction.removeEventListener(KitchenSyncEvent.ACTION_COMPLETE, onChildFinished);			childAction.removeEventListener(KitchenSyncEvent.ACTION_START, onChildStart);			_runningChildren--;			if (_runningChildren == 0) {				complete();			}		}				override public function stop():void {			super.stop();			_runningChildren = 0;		}				override public function clone():IAction {			var clone:KSParallelGroup = new KSParallelGroup();			for (var i:int = 0; i < _childActions.length; i++) {				var action:IAction = getChildAtIndex(i).clone();				clone.addActionAtIndex(action, i);			}			clone.delay = _delay;			clone.autoDelete = _autoDelete;			return clone;		}				override public function toString():String {			return "Parallel group containing " + _childActions.length + " children";		}	}}