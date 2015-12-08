# Summary #
Action Groups are special types of [actions](AbstractAction.md) that contain sets of other actions which can be controlled simultaneously. All action groups implement the `IActionGroup` interface.

# Details #
The `AbstractActionGroup` class defines common characteristics of all action groups. All action groups use the `addAction()` method to add actions to the group. As you can see from the figure, `AbstractActionGroup` is itself a subclass of [`AbstractAction`](AbstractAction.md) allowing you to nest action groups within other action groups or use a group as if it were a single action. This distinction makes creating long strings of time based events a relatively simple task.

The types of groups are:
  * [KSSequenceGroup](KSSequenceGroup.md)
  * [KSParallelGroup](KSParallelGroup.md)
  * [KSStaggeredGroup](KSStaggeredGroup.md)
  * [KSSimultaneousEndGroup](KSSimultaneousEndGroup.md)
  * --KSSteppedSequenceGroup-- _deprecated_
  * [KSRandomGroup](KSRandomGroup.md)

![http://www.as3lib.org/kitchensync/docs/img/actionGroups.png](http://www.as3lib.org/kitchensync/docs/img/actionGroups.png)

Groups can be used in conjunction with one another. For example, you may wish to create a [sequence](KSSequenceGroup.md) that contains a [parallel](KSParallelGroup.md) action so that you can have several actions occur at the same point in a sequence.

With all of the action groups, separate events are dispatched upon completion of individual items and of the entire group.


## Related Links ##
  * [Composite Design Pattern](http://en.wikipedia.org/wiki/Composite_pattern)
  * [KSSequenceGroup](KSSequenceGroup.md)
  * [KSParallelGroup](KSParallelGroup.md)
  * [KSStaggeredGroup](KSStaggeredGroup.md)
  * [KSSimultaneousEndGroup](KSSimultaneousEndGroup.md)
  * [KSRandomGroup](KSRandomGroup.md)