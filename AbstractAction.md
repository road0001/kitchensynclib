# Actions #
KitchenSync is made up of several types of objects that perform some kind of function and are timed by the Synchronizer. These objects are called _actions_. All actions are subclasses of the abstract class `AbstractAction`.

Descendants of AbstractAction can be found in the `org.as3lib.kitchensync.action` package.

### Hierarchy ###
Here's a diagram of the inheritance chain as it stands at this point. (NAMES OF CLASSES ARE OLD)
![http://as3lib.org/kitchensync/docs/img/synchronizedActionUML.png](http://as3lib.org/kitchensync/docs/img/synchronizedActionUML.png)

## States of an action ##
![http://as3lib.org/kitchensync/docs/img/actionStateMachine.png](http://as3lib.org/kitchensync/docs/img/actionStateMachine.png)

## Related Links ##
  * [API Reference for AbstractAction](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/AbstractAction.html)