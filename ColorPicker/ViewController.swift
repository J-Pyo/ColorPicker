//
//  ViewController.swift
//  ColorPicker
//
//  Created by 홍정표 on 2020/03/16.
//  Copyright © 2020 홍정표. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Mark:-property Types
    private struct ColorComponent{
        
        typealias SliderTag = Int
        typealias Component = Int
        
        static let count: Int = 4
        
        static let red: Int = 0
        static let green: Int = 1
        static let blue: Int = 2
        static let alpha: Int = 3
        
        static func tag(`for`:Component) -> Int{
            return `for` + 100
        }
        static func component(from:SliderTag) ->Component{
            return from - 100
        }
    }
    private struct ViewTag{
        static let sliderRed: Int=100
        static let sliderGreen: Int=101
        static let sliderBlue: Int=102
        static let sliderAlpha: Int=103
    }

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    //Mark:-properties
    private let rgbStep: Float = 255.0
    private let numberOfRGBStep: Int = 256
    private let numberOfAlphaStep: Int = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for i in 0..<self.pickerView.numberOfComponents{
            let numberOfRows: Int = self.pickerView.numberOfRows(inComponent: i)
            self.pickerView.selectRow(numberOfRows - 1, inComponent: i,animated: false)
        }
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard (ViewTag.sliderRed...ViewTag.sliderAlpha).contains(sender.tag) else {
            print("wrong slider tag")
            return
        }
        let component: Int = ColorComponent.component(from: sender.tag)
        let row: Int
        
        if component == ColorComponent.alpha{
            row = Int(sender.value * 10)
        }else{
            row = Int(sender.value)
        }
        
        self.pickerView.selectRow(row,inComponent: component,animated: false)
        self.matchViewColorCurrentValue()
        
    }
    private func matchViewColorCurrentValue(){
        
        guard let redSlider: UISlider = self.view.viewWithTag(ViewTag.sliderRed) as? UISlider,
            let greenSlider: UISlider = self.view.viewWithTag(ViewTag.sliderGreen) as? UISlider,
            let blueSlider: UISlider = self.view.viewWithTag(ViewTag.sliderBlue) as? UISlider,
            let alphaSlider: UISlider = self.view.viewWithTag(ViewTag.sliderAlpha) as? UISlider
        else{
            return
        }
        
        //UIColor는 색 표현이 0~1로 표현되어 있기 때문에 나눠준다.
        let red: CGFloat = CGFloat(redSlider.value / self.rgbStep)
        let green: CGFloat = CGFloat(greenSlider.value / self.rgbStep)
        let blue: CGFloat = CGFloat(blueSlider.value / self.rgbStep)
        let alpha: CGFloat = CGFloat(alphaSlider.value)
        
        let color: UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
        self.colorView.backgroundColor = color
        
    }
}
extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    //DataSource Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return ColorComponent.count //Component 갯수 반환!
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == ColorComponent.alpha{
            return self.numberOfAlphaStep //row 갯수 반환
        }else{
            return self.numberOfRGBStep //row 갯수 반환
        }
    }
    
    //View Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == ColorComponent.alpha{ //알파 컴포넌트일때는 1.1lf 형식으로 보여줘라
            return String(format: "%1.1lf",Double(row) * 0.1)
        }else{
            return "\(row)"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let sliderTag: Int = ColorComponent.tag(for: component)
        
        guard let slider: UISlider = self.view.viewWithTag(sliderTag) as? UISlider else{
            return
        } //slider tag 값과 맞지 않으면 리턴시켜라
        
        if component == ColorComponent.alpha{
            slider.setValue(Float(row)/10.0, animated: false)
        }else{
            slider.setValue(Float(row), animated: false)
        }
        
        self.matchViewColorCurrentValue()
    }
}

