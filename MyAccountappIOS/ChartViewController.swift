//
//  ChartViewController.swift
//  MyAccountappIOS
//
//  Created by Ran FANG on 2019/12/10.
//  Copyright © 2019 Ran FANG. All rights reserved.
//

import UIKit
import Charts
import CoreData


class ChartViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    
    
    var isExpense:Bool = false
    @IBAction func incomeExpense(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isExpense = false
        }
        else {
            isExpense = true
        }
    }
    
    @IBAction func pickerButton(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var yearArray:[String] = [String]()
    var monthArray:[String] = [String]()
    
    var yearData:String = "2019"
    var monthData:String = "Dec"
    
    @IBAction func triangleButton(_ sender: UIButton) {
        self.picker?.dataSource = self
        self.picker?.delegate = self
        
        yearArray = ["2017","2018","2019","2020","2021","2022"]
        monthArray = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]

        pickerViewHiddenStatus(pvStatus: false)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        pickerViewHiddenStatus(pvStatus: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        pickerViewHiddenStatus(pvStatus: true)
        yearLabel.text = yearData
        monthLabel.text = monthData
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return yearArray.count
        }
        
        return monthArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return yearArray[row]
        }
        return monthArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        if component == 0 {
            yearData = yearArray[row]
        }
        monthData = monthArray[row]
    }
    
    func pickerViewHiddenStatus(pvStatus:Bool) {
        picker.isHidden = pvStatus
        cancelButton.isHidden = pvStatus
        doneButton.isHidden = pvStatus
    }
    
    
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    var numbers = [Double]()
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        tabBarItem = UITabBarItem(title:"Chart", image:UIImage(named:"chart"),tag:3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearLabel.text = "2019"
        monthLabel.text = "Dec"
        
        pickerViewHiddenStatus(pvStatus: true)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Line")

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "amount") != nil {
                //print(data.value(forKey: "amount")as! Double)
                numbers.append(data.value(forKey: "amount") as! Double)
                }
          }
            
        } catch {
            
            print("Failed")
        }
        
        
        setChartValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func setChartValues(_ count : Int = 20) {
        var lineChartEntry = [ChartDataEntry]()
        for i in 0..<numbers.count{
            let value = ChartDataEntry(x:Double(i),y: Double(numbers[i]))
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(entries:lineChartEntry, label:"Number")
        
        let data = LineChartData()
        data.addDataSet(line1)
        
        lineChartView.data = data
        lineChartView.chartDescription?.text="My af"
    }


}

