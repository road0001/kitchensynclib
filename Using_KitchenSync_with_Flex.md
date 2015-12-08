# Using KitchenSync with Adobe Flex #
KitchenSync was designed to be a library for AS3 applications and was intentionally made independent of the Flex framework. Flex contains its own libraries for animation. It also handles validation of children and the display list internally which can cause unexpected results when using KitchenSync. Officially, KitchenSync does not support use with Flex at this point, however, just because it's not officially supported doesn't mean it cannot be used. Here are some tips to help you out.

## Tips ##
  * Using the `creationComplete` or `initialize` events may cause you to get an error.  That is because the `KitchenSync.initialize()` method must receive a DisplayObject that has been added to the display list to get a reference to the stage and that doesn't happen in the `creationComplete` or `initialize` events. Instead, use `addedToStage` to initialize KitchenSync.
  * In order to optimize performance, Flex components don't necessarily update on stage at the exact same time that you set a property such as 'x'. This may affect the performance of KitchenSync. To learn more about this, check out the [invalidateDisplayList() method](http://livedocs.adobe.com/labs/flex3/langref/mx/core/UIComponent.html#invalidateDisplayList()) or read up on [creating custom components](http://livedocs.adobe.com/flex/201/html/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Book_Parts&file=Part1_intro_136_1.html#74609) for a full description.
  * Flex may contain some classes with the same class names (but different package names) as the classes in KitchenSync. This is easily fixed by being sure to import `org.as3lib.kitchensync.*` and `org.as3lib.kitchensync.easing.*`. When you attempt to use a class such as `Cubic`, FlexBuilder should even ask you which package you want to import (pictured below). Make sure you choose the right one one.
![http://as3lib.org/kitchensync/docs/img/organizeImports.png](http://as3lib.org/kitchensync/docs/img/organizeImports.png)
## Example ##
This example uses a listener for the `addedToStage` event to move a Canvas and rotate it.
```
<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" width="500" height="500" 
	addedToStage="onAddedToStage(event)">
	<mx:Script>
		<![CDATA[
			import mx.containers.Canvas;
			import org.as3lib.kitchensync.*;
			import org.as3lib.kitchensync.easing.*;
			import org.as3lib.kitchensync.action.*;
			import org.as3lib.kitchensync.action.tween.*;
		
			protected function onAddedToStage(evnet:Event):void {
				stage.frameRate = 50;
				KitchenSync.initialize(this);
				
				var box:Canvas = new Canvas();
				box.setStyle("backgroundColor", 0x0000FF);
				box.width = 100;
				box.height = 100;
				addChild(box);
				
				var tweenX:KSTween = TweenFactory.newTween(box, "x", 300, 0, "5s", "0.5s", Cubic.easeInOut);
				var tweenY:KSTween = TweenFactory.newTween(box, "y", 300, 0, "3s", "1.5s", Cubic.easeInOut);
				var tweenR:KSTween = TweenFactory.newTween(box, "rotation", 360, 0, "7s", 0, Cubic.easeInOut);
				
				new KSParallelGroup( tweenX, tweenY, tweenR ).start();
			}
		]]>
	</mx:Script>
</mx:Application>
```

## Links ##
  * [Flex Effects API Reference](http://livedocs.adobe.com/labs/flex3/langref/mx/effects/package-detail.html)