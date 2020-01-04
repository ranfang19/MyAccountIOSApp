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

    
    
    var isExpense:Bool = true

    
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var yearArray:[String] = [String]()
    var monthArray:[String] = [String]()
    
    var yearData:String = "2020"
    var monthData:String = "Jan"
    var monthInt:Int=1
    
    var transportArray: [Double] = []
    var foodArray: [Double] = []
    var shoppingArray: [Double] = []
    var housingArray: [Double] = []
    
    var transportTotal:Double=0
    var foodTotal:Double=0
    var shoppingTotal:Double=0
    var housingTotal:Double=0
    
    var lines: [Any] = []
    
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
        monthInt=monthConvert(data: monthData)
        updateChart()
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
    
    func monthConvert(data:String)->Int{
        var monthIntData:Int=1
        switch data {
        case "Jan" :
            monthIntData=1
        case "Feb":
            monthIntData=2
        case "Mar":
            monthIntData=3
        case "Apr":
            monthIntData=4
        case "May":
            monthIntData=5
        case "June":
            monthIntData=6
        case "July":
            monthIntData=7
        case "Aug":
            monthIntData=8
        case "Sept":
            monthIntData=9
        case "Oct":
            monthIntData=10
        case "Nov":
            monthIntData=11
        case "Dec":
            monthIntData=12
        default:
            monthIntData=1
        }
        return monthIntData
    }
    
    
    
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    func setupPieChart(transportData:Double,foodData:Double,shoppingData:Double,housingData:Double){
        pieChartView.chartDescription?.enabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = false
        pieChartView.isUserInteractionEnabled = false
        pieChartView.legend.font = UIFont.systemFont(ofSize: 15)
        
        //pieChartView.legend.enabled = falses
        
        var entries:[PieChartDataEntry] = Array()
        if (transportData != 0){
            entries.append(PieChartDataEntry(value: transportData, label: "Transport:\(String(transportData))"))
        }
        if (shoppingData != 0){
            entries.append(PieChartDataEntry(value: foodData, label: "Shopping:\(String(shoppingData))"))
        }
        if (foodData != 0){
            entries.append(PieChartDataEntry(value: shoppingData, label: "Food:\(String(foodData))"))
        }
        if (housingData != 0){
        entries.append(PieChartDataEntry(value: housingData, label: "Housing:\(String(housingData))"))
        }
        
        let dataSet = PieChartDataSet(entries: entries, label:"")
        dataSet.valueTextColor=UIColor.black
        
        let c1=NSUIColor(hex: 0xfeae65)
        let c2=NSUIColor(hex: 0xf66d44)
        let c3=NSUIColor(hex: 0x65c2a6)
        let c4=NSUIColor(hex: 0x2d87bb)
        
        dataSet.colors = [c1,c2,c3,c4]
        dataSet.drawValuesEnabled = false
        
        pieChartView.data=PieChartData(dataSet:dataSet)
        
        
        
    }
    
    
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        tabBarItem = UITabBarItem(title:"Chart", image:UIImage(named:"chart"),tag:3)
    }
    
    func updateChart(){
        transportArray = []
        foodArray = []
        shoppingArray = []
        housingArray = []
        transportTotal=0
        foodTotal=0
        shoppingTotal=0
        housingTotal=0
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
               
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Line")
        
        fetchRequest.returnsObjectsAsFaults = false
        
        let predicateMonth = NSPredicate(format:"month == %d", monthInt)
        let predicateYear = NSPredicate(format:"year == %d", Int(yearData) ?? 2019)
        let predicateExpense = NSPredicate(format:"expense == %d", isExpense)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateMonth, predicateYear,predicateExpense])
        fetchRequest.predicate = andPredicate
        
        do {
            lines = try context.fetch(fetchRequest)
            for line in lines as! [NSManagedObject] {
                if (line.value(forKey:"category") as! String == "Transport"){
                    transportArray.append(line.value(forKey:"amount") as! Double)
                    transportTotal = transportTotal + (line.value(forKey:"amount") as? Double ?? 0)
                }
                else if (line.value(forKey:"category") as! String == "Food"){
                    foodArray.append(line.value(forKey:"amount") as! Double)
                    foodTotal = foodTotal + (line.value(forKey:"amount") as? Double ?? 0)
                }
                else if (line.value(forKey:"category") as! String == "Shopping"){
                    shoppingArray.append(line.value(forKey:"amount") as! Double)
                    shoppingTotal = shoppingTotal + (line.value(forKey:"amount") as? Double ?? 0)
                }
                else if (line.value(forKey:"category") as! String == "Housing"){
                    housingArray.append(line.value(forKey:"amount") as! Double)
                    housingTotal = housingTotal + (line.value(forKey:"amount") as? Double ?? 0)
                }
            }
            setupPieChart(transportData: transportTotal, foodData: foodTotal, shoppingData: shoppingTotal, housingData: housingTotal)
        } catch {
            print("Failed")
        }
    }
    
    private let persistentContainer = NSPersistentContainer(name: "MyAccountappIOS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearLabel.text = yearData
        monthLabel.text = monthData
        
        pickerViewHiddenStatus(pvStatus: true)

        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                        
            } else {
                self.updateChart()
            }
                }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}

extension ChartViewController: NSFetchedResultsControllerDelegate {}

