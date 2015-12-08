## Summary ##
A Staggered [group](ActionGroups.md) of actions will execute one after the other in a sequence however, the actions are separated by a specified time (e.g. 1 second) rather than the end of the previous action.

## Syntax ##
```
new KSStaggeredGroup(stagger:*, ... children)
```
  * `stagger` - The time to wait between each child's execution. Can be an integer or a string which follows the [time parsing rules](Timing#Parsing_time_strings.md).
  * `children` - The remaining parameters are added as child actions (if they are AbstractAction instances)

## Related Links ##
  * [AbstractActionGroup](AbstractActionGroup.md)
  * [API Reference](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/KSStaggeredGroup.html)