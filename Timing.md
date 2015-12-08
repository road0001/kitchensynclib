# Time string parsing, and sync mode #

Most times in KithcenSync such as duration and offset can be entered using integers or strings. Many different methods for entering times are provided to make KitchenSync versatile enough to work with several types of applications.

## Using integers ##
Using an integer value to set a duration will use milliseconds as the unit of time.

~~[KitchenSync](KitchenSync.md) supports multiple time units so that it might best fit your project's needs.~~ _TimeUnits have been removed from version 1.1 since they were becoming unmanageable and the TimeStringParser seemed to do pretty much the same thing._

## Parsing time strings ##
Because of some magic behind the scenes ([TimeStringParser\_en](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/util/TimeStringParser_en.html)), KitchenSync is able to automatically parse a string value into milliseconds. When using the constructor for any of the actions in KitchenSync, try passing in an English language string with numbers and units such as "1.5 seconds" or "15min".
The following lines are all functionally equivelant...
```
new KSTrace("Five seconds have elapsed.", "5 seconds");
new KSTrace("Five seconds have elapsed.", "5 sec");
new KSTrace("Five seconds have elapsed.", "5 s");
new KSTrace("Five seconds have elapsed.", "0:05");
new KSTrace("Five seconds have elapsed.", "5000ms");
new KSTrace("Five seconds have elapsed.", "5000 milliseconds");
new KSTrace("Five seconds have elapsed.", "5000 msec");
new KSTrace("Five seconds have elapsed.", "3 seconds, 2000 milliseconds");
new KSTrace("Five seconds have elapsed.", "0.8333 minutes");
```
Additionally, all of these structures are supported.
  * "1 hour, 2 minutes, 3 seconds, 4 milliseconds"
  * "1h2m3s4ms"
  * "5sec,12fr"
  * "300 frames"
  * "1.25s"
  * "5 milliseconds, 15mins, 6 hrs"
  * "0.25 days"
  * "dd:hh:mm:ss;ff"
  * ":ss"
  * "m:ss;ff"

Regardless of which method is used, values will always be stored as milliseconds.

## Sync mode ##
Since the Flash Player's frame rate doesn't always stay true to its word, KitchenSync's actions includes a special sync mode. What this does is try to match the time set for the duration and offset to the actual number of milliseconds elapsed rather than the number of frames elapsed. That way, if there is an unusual slowdown, your actions will still happen at the time you asked them to!
Sync mode works regardless of the action's `timeUnit`. You can enable sync mode by setting the `sync` flag to `true` on your actions. In the following snippet, `synchedTween` should finish very nearly 5 seconds after `start()` is called while `tween` will occur after `5 x frameRate` frames have elapsed (which may take more than 5 seconds).
```
var tween:KSTween = new KSTween(sprite1, "x", 500, 0, "5sec");
tween.start();

var synchedTween:KSTween = new KSTween(sprite2, "x", 500, 0, "5sec");
synchedTween.sync = true;
synchedTween.start();
```

The default value for `sync` can be set in [ActionDefaults](ActionDefaults.md).