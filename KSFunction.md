## Summary ##
The `KSFunction` class represents a function or method and any specified arguments that are to be called at a specified time or after some delay. Just pass in the function you want to call and any arguments. The function will be called when the action executes.

## Syntax ##
**Note:** unlike earlier versions of ActionScript, with AS3 there is no need to use a delegate to retain the scope of the function.

### Getting results of a synchronized function ###
If the function called by a KSFunction object returns a result, that result will be stored in the KSFunction as an untyped object. To access it, use the `result` property.
```
var getSumFunc:KSFunction = new KSFunction(1000, getSum, 1, 2, 3, 4, 5);
getSumFunc.start();

// LATER....

var sum:Number = Number(getSumFunc.result); // 15
```

## Links ##
  * [API Reference](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/action/KSFunction.html)
  * [AbstractAction](AbstractAction.md)