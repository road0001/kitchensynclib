# Introduction #

A tween target is a type of object that represents values being controlled by a tween. These objects are used in conjunction with [KSTween](KSTween.md) actions. Tween targets can control simple numeric values like x and y, complex numeric values like colors, values that are complicated to change like filter properties, and even for controlling timeline animations. Having a separate class for setting the values allows us to use a single tween action class for multiple purposes.

The most common type of tween target is the `TargetProperty` which contains an object and the name of a property of the object.


# Related Links #
  * [KSTween](KSTween.md) - An action associated with a tween.
  * [API Reference](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/tweentarget/ITweenTarget.html)