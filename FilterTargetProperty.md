# Introduction #

FilterTargetProperty allows you to tween filters by setting up a custom [TweenTarget](Tween_Targets.md) for properties of filters.


# Example #
This example will change the distance of a drop shadow over time.
```
package {
	import flash.display.*;
	import flash.filters.*;

	import org.as3lib.kitchensync.*;
	import org.as3lib.kitchensync.action.*;
	import org.as3lib.kitchensync.action.tweentarget.*;
	import org.as3lib.kitchensync.easing.*;
	
	public class FilterTargetPropertyDemo extends Sprite {
		public function FilterTargetPropertyDemo() {
			// set framerate to 30 frames per second
			stage.frameRate = 30;
			// start KitchenSync. You'll only need to do this once.
			KitchenSync.initialize(this);
		
			// Draw a rectangle to use for demonstrations.
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0);
			sprite.graphics.drawRect(0,0,20,20);
			addChild(sprite);
			
			//Define a custom dropshadow
                        var customDSFilter:DropShadowFilter = new DropShadowFilter (2, 45, 0xCCCCCC, 1, 5,5, 1, BitmapFilterQuality.HIGH);

                       //Apply the filter to the sprite
                      sprite.filters = [customDSFilter];

                       //Create the new FilterTargetProperty Object
                       var dropShadowFTP:FilterTargetProperty = new FilterTargetProperty(sprite,DropShadowFilter,"distance",0,100);
                       //Use the new TweenTarget object in a tween definition. Remember to use the newWithTweenTarget() method to instantiate it.
                       var dropShadowTween:KSTween = KSTween.newWithTweenTarget(dsTargetProp, "5sec", 0,Elastic.easeOut);
                       
                       //Start the tween.
                       dropShadowTween.start();
		}
	}
}
```

## Related Links ##
  * [Tween targets](Tween_Targets.md)
  * [API reference](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/tweentarget/FilterTargetProperty.html)