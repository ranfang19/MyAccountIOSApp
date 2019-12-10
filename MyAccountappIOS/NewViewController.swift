//
//  NewViewController.swift
//  MyAccountappIOS
//
//  Created by Ran FANG on 2019/12/10.
//  Copyright © 2019 Ran FANG. All rights reserved.
//

import UIKit

class NewViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    //Tab
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        tabBarItem = UITabBarItem(title:"New", image:UIImage(named:"pencil"),tag:2)
    }
    
    // datePicker
    var year:String=""
    var month:String=""
    var day:String=""
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneDatePickerBtn: UIButton!
    @IBOutlet weak var cancelDatePickerBtn: UIButton!
    
    @IBAction func cancelDatePickerBtn(_ sender: Any) {
        datePickerIsHidden(status:true)
    }
    
    
    @IBAction func doneDatePickerBtn(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        year = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "M"
        month = dateFormatter.string(from: datePicker.date)
        dateFormatter.dateFormat = "d"
        day = dateFormatter.string(from: datePicker.date)
        
        datePickerIsHidden(status:true)
    }
    
    @IBAction func datePickerBtn(_ sender: Any) {
        datePickerIsHidden(status:false)
        datePicker?.addTarget(self, action: #selector(NewViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target:self,action:#selector(NewViewController.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        dateTextField.inputView = datePicker
    }
    
    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    
    @objc func dateChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        dateTextField.text=dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    

    func datePickerIsHidden(status:Bool){
        cancelDatePickerBtn.isHidden=status
        doneDatePickerBtn.isHidden=status
        datePicker.isHidden=status
    }
    
    func categoryPickerIsHidden(status:Bool){
        cancelCategoryPickerBtn.isHidden=status
        doneCategoryPickerBtn.isHidden=status
        categoryPicker.isHidden=status
    }
    
    
    
    
    //categoryPicker
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var cancelCategoryPickerBtn: UIButton!
    @IBOutlet weak var doneCategoryPickerBtn: UIButton!
    
    var pickerData: [String] = [String]()
    var categorySelected : String = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        let categoryPickerValue = pickerData[row] as String
        categorySelected = categoryPickerValue
    }
    
    @IBAction func cancelCategoryPickerBtn(_ sender: Any) {
        categoryPickerIsHidden(status:true)
    }
    
    @IBAction func doneCategoryPickerBtn(_ sender: Any) {
        categoryPickerIsHidden(status:true)
        categoryTextField.text=categorySelected
    }
    
    @IBAction func categoryPickerBtn(_ sender: Any) {
        categoryPickerIsHidden(status:false)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerIsHidden(status:true)
        categoryPickerIsHidden(status:true)
        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        year = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM"
        month = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "d"
        day = dateFormatter.string(from: date)
        
        dateTextField.text=day+"/"+month+"/"+year
        
        self.categoryPicker?.delegate = self
        self.categoryPicker?.dataSource = self
        pickerData = ["Transport", "Shopping", "Food", "Housing"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    


}
