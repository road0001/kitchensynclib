## Summary ##
[Action](AbstractAction.md) to set a property for any object to a specified value after some delay.

## Syntax ##
```
new KSSetProperty(target:Object, key:String, value:*, offset:* = 0);
```

  * `target` - The object whose property you want to modify.
  * `key` - The name of the property to modify.
  * `value` - The new value of the property.
  * `offset` - The delay before the action executes.

## Example ##
This example creates a text field and sets the text property after five seconds.
```
package {
	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.easing.*;
	import org.as3lib.kitchensync.action.*;
	import flash.display.*;
	import flash.text.*;

	public class SetPropertyDemo extends Sprite
	{
		public function SetPropertyDemo()
		{
			KitchenSync.initialize(this);
			
			var info:TextField = new TextField();
			info.autoSize = TextFieldAutoSize.LEFT;
			info.text = "Loading, please wait.";
			addChild(info);
			
			var showCompleteAction:KSSetProperty = new KSSetProperty(info, "text", "Loading Complete!", "5 seconds");
			showCompleteAction.start();
		}
	}
}
```

## Links ##
  * [AbstractAction](AbstractAction.md)
  * [API Reference](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/KSSetProperty.html)