package com.mimswright.sync
{
	public class TimestampUtil
	{	
		public static function add(timestampA:Timestamp, timestampB:Timestamp):Timestamp {
			return new Timestamp(timestampA.currentFrame + timestampB.currentFrame, timestampA.currentTime + timestampB.currentTime);
		}

		public static function subtract(timestampA:Timestamp, timestampB:Timestamp):Timestamp {
			return new Timestamp(timestampA.currentFrame - timestampB.currentFrame, timestampA.currentTime - timestampB.currentTime);
		}
	}
}