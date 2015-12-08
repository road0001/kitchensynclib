This page is here to help you when there have been conversions that affect legacy code. **Remember to always check the [change log](ChangeLog.md) for a list of updates to each version!**

### Converting to 1.2 and later ###
To convert to version 1.2 or later, I suggest that you
  * search for the old names of classes and replace them with the new class names
  * replace `Synchronizer.initialze()` with `KitchenSync.initialize()`.
  * replace imports for `com.mimswright.sync.*` with `org.as3lib.kitchensync.*` and `org.as3lib.kitchensync.action.*` (you probably won't need access to the other packages)
  * replace imports for `com.mimswright.easing.*` with `org.as3lib.kitchensync.easing.*`

### Converting to 1.5 and later ###
To convert to version 1.5 or later, I suggest that you
  * Especially note the changes in syntax to the [KSTween](KSTween.md) constructor. Now the start value is before the end value.
  * Change `org.as3lib.kitchensync.util` to `org.as3lib.kitchensync.utils`

## Naming Changes ##
[Click to see the changes to class names](http://spreadsheets.google.com/pub?key=pIE-vTZCHHbSyu2Kwb_VWEQ&output=html&gid=0&single=true)

## Package Changes ##
[Click here to see the new package structure](http://spreadsheets.google.com/pub?key=pIE-vTZCHHbSyu2Kwb_VWEQ&output=html&gid=1&single=true)

  * org.as3lib.kitchensync - Contains the new KitchenSync class and the KitchenSyncDefaults. These are global classes that control the entire system.
  * org.as3lib.kitchensync.easing - Contains all the easing function classes.
  * org.as3lib.kitchensync.action - Contains all Actions
  * org.as3lib.kitchensync.action.tweenable - Contains classes that represent properties that can be tweened.
  * org.as3lib.kitchensync.core - Contains the internal workings of the system
  * org.as3lib.kitchensync.utils (util in 1.2) - Contains helper classes.

## Other changes ##
  * `Synchronizer.initialize()` has been replaced with `KitchenSync.initialize()`