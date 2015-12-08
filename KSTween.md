**Note, the way tweens work has changed slightly as of version 1.5. Now, KSTween objects use ITweenTarget objects to control the values that are tweened. Also, when creating a new tween, the syntax is from `startValue` to `endValue` (it used to be the other way around)**

## Summary ##
Perhaps the most used action is the KSTween. It represents a tween - an object that changes a numeric property from one value to another over time. However, in most cases, the word tween is more likely to be synonymous with an animation be-**tween** two key points.

Tweens in KitchenSync are represented by two types of object.
  * A KSTween object is an [action](action.md) associated with tweening. This object contains all the timing information and controls associated with the tween.
  * A class that implements the [ITweenTarget](Tween_Targets.md) interface contains a reference to the object being controlled by the tween and the starting and ending values for the object. This object is used by the KSTween object.
Having two separate types allows us to target a variety of different values (position, filters, colors) without creating a different subclass of KSTween for each application.

In order to save time and keep things simple, the KSTween constructor can be used without explicitly defining a tween target. The constructor will create a new KSTween with a default tween target, `TargetProperty`, which tweens any numeric property of any object.

KSTweens also use a special type of function, called an [easing function](Easing.md), to determine the method of interpolation from the start to the ending values. These functions create the 'shape' of the changing values over time. When applied to a display object's position, the easing function will determine the kind of motion with which it will move between the two points.

## Syntax ##
To quickly create a tween on a property of a target object, use the KSTween constructor:
```
new KSTween(target:Object, property:String, startValue:Number, endValue:Number = KSTween.EXISTING_FROM_VALUE, duration:* = 0, offset:* = 0, easingFunction:Function = null);
```
  * `target` - the object whose property will be changed.
  * `property` - the name of the property to change. The property must be a Number, int or uint such as a `Sprite` object's "alpha"
  * `startValue` - the starting value of the tween. By default, this is the value of the property before the tween.
  * `endValue` - the value to tween the property to. After the tween is done, this will be the value of the property.
  * `duration` - the time in frames that this tween will take to execute.
  * `offset` - the time to wait before starting the tween.
  * `easingFunction` - the function to use to interpolate the values between fromValue and toValue.

To create a KSTween using a custom ITweenTarget, first create your custom tween target then create your KSTween using this syntax:
KSTween.newWithTweenTarget(tweenTarget:ITweenTarget, duration:**= 0, delay:** = 0, easingFunction:Function = null)
  * `tweenTarget` - a reference to the custom tween target you've just created.
  * The rest of the parameters are the same as above.

## Example ##
This example creates a box then two tweens that move it to the right and down respectively.
```
package {
	import flash.display.*;
	
	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.action.tweentarget.*;
	import org.as3lib.kitchensync.easing.*;
	
	public class KSTweenDemo extends Sprite {
		public function KSTweenDemo() {
			// set framerate to 30 frames per second
			stage.frameRate = 30;
			// start KitchenSync. You'll only need to do this once.
			KitchenSync.initialize(this);
		
			// Draw a rectangle to use for demonstrations.
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0);
			sprite.graphics.drawRect(0,0,20,20);
			addChild(sprite);
			
			// Create a tween to move the rectangle from left to right using the constructor. 
			var tweenX:KSTween = new KSTween(sprite, "x", 0, 300, "3sec", "0sec", Cubic.easeInOut);
			
			// If you want to use custom tween targets, replace the line above with the following. 
			// var tweenTargetX:TargetProperty = new TargetProperty(sprite, "x", 0, 300);
			// var tweenX:KSTween = KSTween.newWithTweenTarget(tweenTargetX, "3s", 0, Cubic.easeInOut);
			
			// apply the same animation to the y property.
			var tweenY:KSTween = tweenX.cloneWithTarget(sprite, "y");

			
			tweenX.start();
			tweenY.start();
		}
	}
}
```

## Related Links ##
  * [API Reference](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/KSTween.html)
  * [AbstractAction](AbstractAction.md)
  * [Easing Functions](Easing.md)