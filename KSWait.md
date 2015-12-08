# Wait #
## Summary ##
This [action](AbstractAction.md) simply waits for the duration specified then ends. It can be used for spacing out time in a [KSSequenceGroup](KSSequenceGroup.md).

## Syntax ##
```
new KSWait(waitTime:*)
```
  * `waitTime` - The wait time (offset)

## Example ##
Creates a [KSSequenceGroup](KSSequenceGroup.md) that moves a square from left to right, uses Wait to pause for 2 seconds, then moves the square from right to left.

[View demo](http://as3lib.org/kitchensync/demo/wait/)

```
package
{
	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.easing.*;
	import org.as3lib.kitchensync.action.*;
	
	import flash.display.Sprite;
	
	public class WaitDemo extends Sprite
	{
		public function WaitDemo() {
			KitchenSync.initialize(this);
			
			// Draw a rectangle to use for demonstrations.
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0);
			sprite.graphics.drawRect(0,0,20,20);
			addChild(sprite);
			
			// Tween the rectangle from 0 to 300 over 4 seconds.
			var tween:KSTween = new KSTween(sprite, "x", 300, 0, "3s", "0s", Cubic.easeInOut);
			// Duplicate the tween in reverse.
			var tween2:KSTween = tween.cloneReversed();
			
			// add a 2 second pause after the square moves before returning it back to it's start position.
                        var wait:KSWait = new KSWait("2s");
			var group:KSSequenceGroup = new KSSequenceGroup(tween, wait, tween2);
			group.start();
		}
	}
}
```