package com.mimswright.sync
{
	/**
	 * Timestamp encapsulates an instant as a frame number and a real time so that either may be used for 
	 * calculating synchronicity.
	 * 
	 * @todo rename currentTime and currentFrame to frames and milliseconds
	 */
	public class Timestamp
	{
		private var _currentTime:Number = 0;
		public function get currentTime():Number { return _currentTime; }
		
		private var _currentFrame:Number = 0;
		public function get currentFrame():Number { return _currentFrame; }
		
		public function Timestamp(frame:Number = 0, currentTime:Number = 0) {
			setTime(frame, currentTime);
		}
		
		internal function setTime(frame:Number = 0, currentTime:Number = 0):void {
			_currentFrame = frame;
			_currentTime = currentTime;
		}
		
		public function clone():Timestamp {
			return new Timestamp(currentFrame, currentTime);
		}
		
		public function toString():String {
			return _currentTime + " msec; " + _currentFrame + " frames";
		}
	}
}