// Nicholas Ragonese
// May 17, 2016


import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTestButtons()
    }
    
    func makeTestButtons() {
        let buttonwidth = (self.view.frame.width / 2) - 15
        
        let button1 = UIButton(frame: CGRectMake(10, self.view.frame.height - 100, buttonwidth, 40))
        button1.backgroundColor = .lightGrayColor()
        button1.addTarget(self, action: #selector(self.button1Pressed), forControlEvents: .TouchDown)
        let label1 = UILabel(frame: CGRectMake(0, 0, buttonwidth, 40))
        label1.userInteractionEnabled = false
        label1.textAlignment = .Center
        label1.text = "Demo 1"
        button1.addSubview(label1)
        
        let button2 = UIButton(frame: CGRectMake(buttonwidth + 20, self.view.frame.height - 100, buttonwidth, 40))
        button2.backgroundColor = .lightGrayColor()
        button2.addTarget(self, action: #selector(self.button2Pressed), forControlEvents: .TouchDown)
        let label2 = UILabel(frame: CGRectMake(0, 0, buttonwidth, 40))
        label2.userInteractionEnabled = false
        label2.textAlignment = .Center
        label2.text = "Demo 2"
        button2.addSubview(label2)
        
        let button3 = UIButton(frame: CGRectMake(10, self.view.frame.height - 50, buttonwidth, 40))
        button3.backgroundColor = .lightGrayColor()
        button3.addTarget(self, action: #selector(self.button3Pressed), forControlEvents: .TouchDown)
        let label3 = UILabel(frame: CGRectMake(0, 0, buttonwidth, 40))
        label3.userInteractionEnabled = false
        label3.textAlignment = .Center
        label3.text = "Demo 3"
        button3.addSubview(label3)
        
        let button4 = UIButton(frame: CGRectMake(buttonwidth + 20, self.view.frame.height - 50, buttonwidth, 40))
        button4.backgroundColor = .lightGrayColor()
        button4.addTarget(self, action: #selector(self.button4Pressed), forControlEvents: .TouchDown)
        let label4 = UILabel(frame: CGRectMake(0, 0, buttonwidth, 40))
        label4.userInteractionEnabled = false
        label4.textAlignment = .Center
        label4.text = "Demo 4"
        button4.addSubview(label4)
        
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        self.view.addSubview(button4)
    }
    
    
    var currentCircleSlider: CircleSlider!
    
    
    func button1Pressed() {
        if currentCircleSlider != nil { currentCircleSlider.removeFromSuperview() }
        
        let circleSlider = CircleSlider(frame: CGRectMake(0, 80, self.view.frame.width, self.view.frame.width))
        circleSlider.makeSlider()
        
        currentCircleSlider = circleSlider
        self.view.addSubview(circleSlider)
    }
    
    func button2Pressed() {
        if currentCircleSlider != nil { currentCircleSlider.removeFromSuperview() }
        
        let circleSlider = CircleSlider(frame: CGRectMake(0, 80, self.view.frame.width, self.view.frame.width))
        
        circleSlider.setSelector(forAction: .touchMoved, target: self, selector: #selector(demoMovedSelector(_:)))
        circleSlider.setSelector(forAction: .circleCompleted, target: self, selector: #selector(demoCompletionSelector))
        circleSlider.setSelector(forAction: .touchFailed, target: self, selector: #selector(demoFailedSelector))
        
        circleSlider.makeSlider()
        
        currentCircleSlider = circleSlider
        self.view.addSubview(circleSlider)
    }
    
    
    func demoCompletionSelector() {
        print("\n\nthe circle was completed\n\n")
    }
    
    func demoMovedSelector(rad: AnyObject) {
        print("moved to rad: \(rad)")
    }
    
    func demoFailedSelector() {
        print("\n\ncircle circling has failed user messed up\n\n")
    }
    
    
    func button3Pressed() {
        if currentCircleSlider != nil { currentCircleSlider.removeFromSuperview() }
        
        let circleSlider = CircleSlider(frame: CGRectMake(0, 80, self.view.frame.width, self.view.frame.width))
        circleSlider.circle_color = UIColor.blackColor()
        circleSlider.touch_color = UIColor.greenColor()
        circleSlider.trail_color = UIColor.lightGrayColor()
        
        circleSlider.dissappear_on_completion = true
        
        //circleSlider.circle_diameter = 250.0
        circleSlider.circle_width = 40.0
        circleSlider.touch_tolerance = 40.0
        
        circleSlider.makeSlider()
        
        currentCircleSlider = circleSlider
        self.view.addSubview(circleSlider)
    }
    
    func button4Pressed() {
        if currentCircleSlider != nil { currentCircleSlider.removeFromSuperview() }
        
        let circleSlider = CircleSlider(frame: CGRectMake(0, 80, self.view.frame.width, self.view.frame.width))
        circleSlider.circle_color = UIColor.blackColor()
        circleSlider.touch_color = UIColor.greenColor()
        circleSlider.trail_color = UIColor.lightGrayColor()
        
        circleSlider.dissappear_on_completion = true
        
        circleSlider.circle_diameter = 250.0
        circleSlider.circle_width = 40.0
        circleSlider.touch_tolerance = 40.0
        
        circleSlider.makeSlider()
        
        currentCircleSlider = circleSlider
        self.view.addSubview(circleSlider)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    


}

