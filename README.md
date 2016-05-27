# CircleSlider
I needed a slide controller in the shape of a circle in a project I was building. Thought perhaps it could be reused so I generalized it a bit. The class is still messy and much can be improved but that's part of why it's here.

Demo Video :                                                                              
[Circle Slider Demo](https://www.youtube.com/watch?v=miEAdFv1KE0)


Example implementation:

```swift
var circleSlider = CircleSlider()
// set custom properties. All will default if not set
circleSlider.circle_diameter = 120.0 
circleSlider.circle_width = 10.0
circleSlider.touch_diameter = 15.0 
circleSlider.touch_tolerance = 10.0 

circleSlider.circle_color = UIColor.grayColor()
circleSlider.touch_color = UIColor.darkGrayColor()
circleSlider.trail_color = UIColor.whiteColor()

// set custom selectors... actions = .touchMoved(radian:CGFloat), .touchFailed, .circleCompleted
circleSlider.setSelector(action: .circleCompleted, target: self, selector: #selector(someFunction))

// other things in the class
// view with the dimensions of the inside of the circle
let innerCircleView = circleSlider.innerView
// if true then the circle will dissappear on completion
circleSlider.dissappear_on_completion = true

// setup the circle and draw it
circleSlider.makeSlider()
```
