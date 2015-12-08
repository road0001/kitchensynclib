# Easing functions #
Easing functions are mathematical functions that are used to interpolate values between two endpoints usually with non-linear results. That's a fancy way of saying that they determine the way something moves.

All of the easing functions in KitchenSync take at least two arguments, time elapsed and duration (some also take additional modifier arguments such as frequency or aplitude), and produce results in the range of 0.0 to 1.0 (again, some functions, such as the Elastics may travel outside of that range). This is slightly different from many other versions of easing functions which calculate a start value and end value but I found this to be cleaner and more versatile.

All of the easing functions are stored as static functions in the `org.as3lib.kitchensync.easing` package. Since you're using KitchenSync, it's not likely that you will be working with the gritty details of easing functions since they're handled automatically within the KSTween class. However, if you need to access them directly, call the function with the [EasingUtil.call()](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/easing/EasingUtil.html#call()) method (more on EasingUtil below), or use the following syntax.
```
newPosition = startPosition + (Cubic.easeIn(timeElapsed, totalDuration) * (endPosition - startPosition));
```
Many of the easing functions in KitchenSync have been adapted from Robert Penner's library and are subject to the original [terms of use](http://www.robertpenner.com/easing_terms_of_use.html).

## Demonstration ##
The best way to understand the easing functions is to play around with them. Check out this easing demo.
[Easing Demo](http://as3lib.org/kitchensync/demo/easing)

## EasingUtil ##
Included in the easing package is a utility class called EasingUtil. This class contains a few methods that make working with easing functions easier. They are...
  * `EasingUtil.call()` - used internally to provide a more predictable interface for calling easing functions.
  * `EasingUtil.generateArray()` - Generates an array of numbers based on an easing function. This is very useful for creating graphs of motion or for pre-calculating the position of an object before animation begins.
  * `EasingUtil.getAveragedFunction()` - Described below.

## Hybrid easing functions ##
Some functions in the easing package combine or modify other easing functions to produce new hybrid easing functions with unique characteristics.
  * [EasingUtil.getAveragedFunction(easingFunction1, easingFunction2)](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/easing/EasingUtil.html#getAveragedFunction()) - Combines two functions to produce a hybrid – sometimes with very unpredictable results.
  * [Stepped.getSteppedFunction(easingFunction, numberOfSteps)](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/easing/Stepped.html#getSteppedFunction()) - Creates a stepped function from another function that generates values that are rounded up or down to create a stair-step motion. Very useful for achieving that '8-bit' look.

## List of easing functions ##
KitchenSync contains the following easing functions. Most you are probably familiar with but there are some new ones in bold.

### Polynomial functions ###
  * Linear X^1
  * Quadratic X^2 (in)
  * Quadratic X^2 (out)
  * Quadratic X^2 (in/out)
  * Cubic X^3 (in)
  * Cubic X^3 (out)
  * Cubic X^3 (in/out)
  * Quartic X^4 (in)
  * Quartic X^4 (out)
  * Quartic X^4 (in/out)
  * Quintic X^5 (in)
  * Quintic X^5 (out)
  * Quintic X^5 (in/out)
  * **Sextic X^6 (in)**
  * **Sextic X^6 (out)**
  * **Sextic X^6 (in/out)**

### Other Math functions ###
  * Exponential (in)
  * Exponential (out)
  * Exponential (in/out)
  * Circular (in)
  * Circular (out)
  * Circular (in/out)
  * Sine (in)
  * Sine (out)
  * Sine (in/out)

### Elastic functions ###
  * Back (in)
  * Back (out)
  * Back (in/out)
  * Bounce (in)
  * Bounce (out)
  * Bounce (in/out)
  * Elastic (in)
  * Elastic (out)
  * Elastic (in/out)

### Oscillating functions ###
  * **Sine**
  * **Absolute Sine**
  * **Sawtooth**
  * **Triangle**
  * **Pulse**

### Misc. functions ###
  * **Random**
  * **Stepped**
  * **Averaged**


## Related Links ##
  * [org.as3lib.kitchensync.easing package API](http://as3lib.org/kitchensync/docs/api/org/as3lib/kitchensync/easing/package-detail.html)
  * [KSTweens](KSTween.md)