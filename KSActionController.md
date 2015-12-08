# Action Controllers and Commands #
An action controller is a type of action that sends _commands_ to other [action](AbstractAction.md) objects such as stop, start, or pause. The commands that can be executed are stored in the enumeration class `ActionControllerCommand`.  They include...
  * ActionControllerCommand.KILL
  * ActionControllerCommand.PAUSE
  * ActionControllerCommand.RESET
  * ActionControllerCommand.START
  * ActionControllerCommand.STOP
  * ActionControllerCommand.UNPAUSE

## Syntax ##
```
new KSActionController(target:AbstractAction, command:ActionControllerCommand, offset:*);
```
  * `target` - the [AbstractAction](AbstractAction.md) that will receive the commands from the controller.
  * `command` - the function that the [action](AbstractAction.md) will perform when the KSActionController executes.
  * `offset` - the delay before the action executes


## Example ##
The following example will pause a [tween](KSTween.md) partway through its execution and then unpause it after one second using two !KSActionControllers.
```
package
{
	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.easing.*;
	import org.as3lib.kitchensync.action.*;	
	
	import flash.display.Sprite;
	
	public class KSActionControllerDemo extends Sprite
	{
		public function KSActionControllerDemo() {
			KitchenSync.initialize(this);
			
			// Draw a rectangle to use for demonstrations.
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0);
			sprite.graphics.drawRect(0,0,20,20);
			addChild(sprite);
			
			// Tween the rectangle from 0 to 300 over 4 seconds.
			var tween:KSTween = new KSTween(sprite, "x", 300, 0, "4s", "0s", Cubic.easeInOut);
			// use action controllers to pause the tween at 2 seconds then unpause 1 second later.
			var pauseTween:KSActionController = new KSActionController(tween, ActionControllerCommand.PAUSE, "2s");
			var unpauseTween:KSActionController = new KSActionController(tween, ActionControllerCommand.UNPAUSE, "3s");
			// add all actions to a group and start the group.
			var group:KSParallelGroup = new KSParallelGroup(tween, pauseTween, unpauseTween);
			group.start();
		}
	}
}
```

## Related Links ##
  * [API Reference for KSActionController](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/KSActionController.html)
  * [API Reference for ActionControllerCommand](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/ActionControllerCommand.html)