## Summary ##
An [action](AbstractAction.md) that causes an event to be dispatched at the time of execution.

An ActionScript 3.0 Event can be dispatched after a delay or as part of a sequence using a `KSDispatchEvent` object. Events are dispatched using the AS3 event dispatching system and can be sent from the `KSDispatchEvent` itself or from any other `IEventDispatcher` that you specify. The constructor can be passed either an Event object or a string for the event type.

> An AS3 Event can be dispatched after a delay or as part of a sequence using this class. Events are dispatched using the AS3 event dispatching system and can be sent from the KSDispatchEvent itself or from any other IEventDispatcher. The constructor can be passed either an Event object or a string for the event type. Uses weak references by default.

## Syntax ##
```
new KSDispatchEvent(event:*, target:IEventDispatcher, offset = 0, ... listeners:*)
Constructor.
```
  * `event` - Can be either an `Event` object or a `String`. If event is an `Event`, that object is used. If event is a string, a new `Event` with that type is automatically created.
  * `target` - The `!IEventDispatcher` that will dispatch the event. The default is this.
  * `offset` - time to wait before execution
  * `listeners` - Any additional objects passed in will be added as listeners (if they're functions)

## Related Links ##
  * [API Reference](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/core/KSDispatchEvent.html)
  * [addEventTrigger()](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/AbstractAction.html#addEventTrigger())
  * [addTrigger()](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/AbstractAction.html#addTrigger())
  * [AbstractAction](AbstractAction.md)