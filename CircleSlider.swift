// Nicholas Ragonese
// May 13, 2016
// github.com/nichrago

// Version 1.0
// -----------
// Basically, a slide controller in a circle shape.
// ------------------------------------------------
// Hello dear developer,
// -------------------------
// Set all the properties you want to edit and then call makeSlider() because that 
// way it will work.
//
// You can set the sizes and colors of the objects and can set your custom selectors for 
// touchesMoved, touchFailed, circleCompleted. the moved selector will send back the 
// radian but keep in mind it us upside down to algebra conventions. Well actually since
// the y coordinate is upside down in the first place it is really upside up but whatever.
//
// If you default all the properties then an average size will be set for all the size
// properties and the colors will be different shades of grey.
// 
// There is a get variable that returns a view in the shape of the inner circle.
//
// There is a bool property where if true when the circle is completed the view dissapears
// called dissappear_when_completed which is fale by default.


import UIKit


class CircleSlider: UIView {
    //
    // * editable properties *
    //
    // sizes
    var circle_diameter: CGFloat!
    var circle_width: CGFloat!
    var touch_diameter: CGFloat! // from end to end of the actual line
    var touch_tolerance: CGFloat! // number of pixels +/- off the circle line that the touch will register
    // colors
    var circle_color = UIColor.darkGrayColor()
    var touch_color = UIColor.lightGrayColor()
    var trail_color = UIColor.whiteColor()
    // for ease of use
    var dissappear_on_completion = false
    
    // selectors for actions, you know because this is a legit class
    enum CircleSliderAction { case touchMoved, touchFailed, circleCompleted }
    
    private var moved_target: NSObject?
    private var moved_selector: Selector?
    private var failed_target: NSObject?
    private var failed_selector: Selector?
    private var completed_target: NSObject?
    private var completed_selector: Selector?
    
    func setSelector(forAction action: CircleSliderAction, target: NSObject, selector: Selector) {
        switch action {
        case .touchMoved:
            moved_target = target
            moved_selector = selector
        case .touchFailed:
            failed_target = target
            failed_selector = selector
        case .circleCompleted:
            completed_target = target
            completed_selector = selector
        }
    }
    //
    // * global variables for the class *
    //
    // circle draw objects
    private var drawn_circle: UIBezierPath!
    private var inner_circle: UIBezierPath!
    private var outer_circle: UIBezierPath!
    // touching draw objects
    private var touch_circle: UIBezierPath!
    private var touch_trail: UIBezierPath!
    // circle maths things
    private var circle_center: CGPoint!
    private var start_rad: CGFloat?
    // testing variables
    private var start_point: CGPoint?
    private var clockwise: Bool?
    private var circled = false
    private var left_check: CGPoint?
    private var right_check: CGPoint?
    //
    // * Get variables for convenience and delight *
    //
    var innerView: UIView? {
        // return a view in the shape and size of the inner circle
        get {
            guard (circle_diameter != nil) && (circle_width != nil) && (circle_center != nil) else {
                return nil
            }
            
            let innerView = UIView(frame: CGRectMake(0, 0, circle_diameter! - circle_width!, circle_diameter! - circle_width!))
            innerView.layer.cornerRadius = innerView.frame.size.width / 2
            
            innerView.center = CGPointMake(circle_center.x + self.frame.origin.x, circle_center.y + self.frame.origin.y)
            return innerView
        }
    }
    //
    // * Functions to start the things *
    //
    func makeSlider() -> Bool {
        // prep and draw the circle, returns false if the view is too small for the properties
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        if circle_width == nil { circle_width = self.frame.width / 10 }
        if touch_diameter == nil { touch_diameter = self.frame.width / 7 }
        if touch_tolerance == nil { touch_tolerance = self.frame.width / 7 }
        if circle_diameter == nil { circle_diameter = self.frame.width - touch_tolerance }
        
        if (((circle_diameter / 2) + touch_tolerance) * 2) < (self.frame.width / 2) { return false }
        
        circle_center = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        
        drawn_circle = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2),
                                    startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        drawn_circle.lineWidth = circle_width
        
        outer_circle = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2) + touch_tolerance,
                                    startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        inner_circle = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2) - touch_tolerance,
                                    startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        self.setNeedsDisplay()
        return true
    }
    //
    // * override the things  *
    //
    override func drawRect(rect: CGRect) {
        guard inner_circle != nil else {
            print("can't draw yet because circle beziers have not been made")
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        CGContextClearRect(context, self.bounds)
        
        circle_color.setStroke()
        drawn_circle.stroke()
        
        if touch_trail != nil { trail_color.setStroke(); touch_trail.stroke() }
        if touch_circle != nil { touch_color.setFill(); touch_circle.stroke(); touch_circle.fill() }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!.locationInView(self)
        
        if outer_circle.containsPoint(touch) && inner_circle.containsPoint(touch) == false {
            startTouch(atPoint: touch)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!.locationInView(self)
        
        if outer_circle.containsPoint(touch) && inner_circle.containsPoint(touch) == false {
            moveTouch(toPoint: touch)
        } else {
            touchFailed()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // well, same thing as if the touchesMoved
        let touch = touches.first!.locationInView(self)
        
        if outer_circle.containsPoint(touch) && inner_circle.containsPoint(touch) == false {
            moveTouch(toPoint: touch)
        } else {
            touchFailed()
        }
    }
    //
    // * where things happen, states get wild *
    //
    private func startTouch(atPoint point: CGPoint) {
        endTouching()
        let circlePoint = getPointOnCircle(forPoint: point)
        touch_circle = UIBezierPath(arcCenter: circlePoint, radius: touch_diameter / 2, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        start_point = circlePoint
        
        let circleRad = atan2(point.y - circle_center.y, point.x - circle_center.x)
        let rads = getRads(withOffset: 0.1, fromRad: circleRad)
        
        left_check = pointOnCircle(forRad: rads.0, withRadius: circle_diameter / 2)
        right_check = pointOnCircle(forRad: rads.1, withRadius: circle_diameter / 2)
        
        updateTouchTrail(toPoint: circlePoint)
        
        self.setNeedsDisplay()
    }
    
    private func moveTouch(toPoint point: CGPoint) {
        let circlePoint = getPointOnCircle(forPoint: point)
        touch_circle = UIBezierPath(arcCenter: circlePoint, radius: touch_diameter / 2, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        updateTouchTrail(toPoint: circlePoint)
        
        if circled {
            if touch_trail.containsPoint(start_point!) { circleCompleted() }
        }
        
        self.setNeedsDisplay()
    }
    
    private func endTouching() {
        start_point = nil
        start_rad = nil
        
        left_check = nil
        right_check = nil
        
        circled = false
        clockwise = nil
        
        touch_circle = nil
        touch_trail = nil
        
        self.setNeedsDisplay()
    }
    
    func updateTouchTrail(toPoint point: CGPoint) {
        let rad = atan2(point.y - circle_center.y, point.x - circle_center.x)
        
        touchMoved(rad)
        
        guard start_rad != nil else { start_rad = rad; return }
        
        if clockwise == nil {
            // figure out if it is or not clockwise
            if start_rad! < 0 {
                if rad < 0 {
                    if start_rad! < rad { clockwise = true }
                    else { clockwise = false }
                } else {
                    if start_rad! > -(1.5) { clockwise = true }
                    else { clockwise = false }
                }
            } else {
                if rad > 0 {
                    if start_rad! < rad { clockwise = true }
                    else { clockwise = false }
                } else {
                    if start_rad! > 1.5 { clockwise = true }
                    else { clockwise = false }
                }
            }
        }
        touch_trail = UIBezierPath(arcCenter: circle_center, radius: (circle_diameter / 2),
                                   startAngle: start_rad!, endAngle: rad, clockwise: clockwise!)
        touch_trail.lineWidth = circle_width
        
        if !circled {
            // we must check if it is now circled
            if clockwise! { if left_check != nil { if touch_trail.containsPoint(left_check!) { circled = true } } }
            else { if right_check != nil { if touch_trail.containsPoint(right_check!) { circled = true } } }
        }
    }
    //
    // * events are happening omg *
    //
    private func circleCompleted() {
        endTouching()
        if dissappear_on_completion { self.removeFromSuperview() }
        if completed_selector != nil && completed_target != nil { completed_target!.performSelector(completed_selector!) }
    }
    
    private func touchFailed() {
        endTouching()
        if failed_selector != nil && failed_target != nil { failed_target!.performSelector(failed_selector!) }
    }
    
    private func touchMoved(rad: CGFloat) {
        if moved_target != nil && moved_selector != nil { moved_target!.performSelector(moved_selector!, withObject: (rad as AnyObject)) }
    }
    //
    // * helpers to help things *
    //
    func getPointOnCircle(forPoint point: CGPoint) -> CGPoint {
        let touchPoint = CGPointMake(point.x - circle_center.x, point.y - circle_center.y)
        
        let touchRad = atan2(touchPoint.y, touchPoint.x)
        return pointOnCircle(forRad: touchRad, withRadius: circle_diameter / 2)
    }
    
    func getCircleValue(hypotenus c: CGFloat, leg a: CGFloat) -> CGFloat {
        return sqrt( (pow(c, 2)) - (pow(abs(a), 2)) )
    }
    
    func getRads(withOffset offset: CGFloat, fromRad rad: CGFloat) -> (CGFloat, CGFloat) {
        var leftRad: CGFloat?
        var rightRad: CGFloat?
        
        if rad <= 0 {
            leftRad = rad - offset
            if leftRad! < -(CGFloat(M_PI)) { leftRad! = CGFloat(M_PI) - (CGFloat(M_PI) + leftRad!) }
        } else {
            leftRad = rad - offset
        }
        if rad <= 0 {
            rightRad = rad + offset
        } else {
            rightRad = rad + offset
            if rightRad > CGFloat(M_PI) { rightRad = -(CGFloat(M_PI)) + (rightRad! - CGFloat(M_PI)) }
        }
        
        return (leftRad!, rightRad!)
    }
    
    func pointOnCircle(forRad rad: CGFloat, withRadius radius: CGFloat) -> CGPoint {
        let x = radius * cos(rad)
        let y = radius * sin(rad)
        return CGPointMake(x + circle_center.x, y + circle_center.y)
    }
    
    // peace
}




























