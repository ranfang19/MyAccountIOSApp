//
//  NewViewController.swift
//  MyAccountappIOS
//
//  Created by Ran FANG on 2019/12/10.
//  Copyright © 2019 Ran FANG. All rights reserved.
//

import UIKit
import CoreData

class NewViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    var id:Int=1
    
    //Tab
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        tabBarItem = UITabBarItem(title:"New", image:UIImage(named:"pencil"),tag:2)
    }
    
    // segment
    
    var isExpense:Bool = false
    @IBAction func incomeExpense(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isExpense = false
            categoryPickerBtn.isHidden = true
        }
        else {
            isExpense = true
            categoryPickerBtn.isHidden = false
        }
    }
    
    // title
    @IBOutlet weak var titleTextField: UITextField!
    var titleFinal:String=""
    
    // amount
    @IBOutlet weak var amountTextField: UITextField!
    var amountFinal:Double=0.00
    
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
    
    @IBOutlet weak var categoryPickerBtn: UIButton!
    @IBAction func categoryPickerBtn(_ sender: Any) {
        categoryPickerIsHidden(status:false)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        titleTextField.text=""
        amountTextField.text=""
        
        datePickerIsHidden(status:true)
        categoryPickerIsHidden(status:true)
        categoryPickerBtn.isHidden = true
        
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
    

    @IBAction func doneBtn(_ sender: Any) {
        let titleFinal=titleTextField.text!
        let amountFinal = Double(amountTextField.text!)
        let yearFinal = Int(year) ?? 0
        let monthFinal = Int(month) ?? 0
        let dayFinal = Int(day) ?? 0
        let categoryFinal = categorySelected
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newLine = NSEntityDescription.insertNewObject(forEntityName: "Line", into: context)
        newLine.setValue(amountFinal, forKey: "amount")
        newLine.setValue(categoryFinal, forKey: "category")
        newLine.setValue(dayFinal, forKey: "day")
        newLine.setValue(isExpense, forKey: "expense")
        newLine.setValue(monthFinal, forKey: "month")
        newLine.setValue(titleFinal, forKey: "title")
        newLine.setValue(yearFinal, forKey: "year")
        newLine.setValue(id, forKey: "id")
        
        do {
            try context.save()
            print("Context saved")
            self.showToast(message: "Context saved")
            id = id + 1
            titleTextField.text=""
            amountTextField.text=""
        } catch {
            print ("ERREUR : impossible de sauvgarder mon context")
        }
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-150, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    

}
