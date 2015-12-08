Behind the scenes, a class called `Synchronizer` acts as a timing clock for all of the [synchronized action](AbstractAction.md). Each time an action starts, the `Synchronizer` adds it to a sort of virtual timeline.

![http://www.as3lib.org/kitchensync/docs/img/virtualTimeline.png](http://www.as3lib.org/kitchensync/docs/img/virtualTimeline.png)

_Fig - Synchronizer assigns actions to a 'virtual timeline'._

Most actions have two properties that control time. They are duration and offset. The duration is the time during which the [action](AbstractAction.md) executes. Some actions, such as [functions](KSFunction.md) and [event dispatchers](KSDispatchEvent.md), have a duration of 0 meaning that they execute instantaneously and only once. The other property, offset, controls how much time will pass before the action will start to execute. Offset is synonymous with delay. Both properties start counting only after the action's `start()` method has been called.

## Syntax ##
Usually, the Synchronizer isn't directly accessed. Actions register themselves with the Syncrhonizer when they are started and the timing dispatches occur internally. To initialize the Synchronizer, use the following syntax.
```
KitchenSync.initialize(this, "1.5");
```
Where `this` is your main application class and the number (which is optional) is the version number of KitchenSync that you're using.