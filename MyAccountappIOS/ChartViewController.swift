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


class ChartViewController: UIViewController {
    
    var isExpense:Bool = false
    @IBAction func incomeExpense(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isExpense = false
        }
        else {
            isExpense = true
        }
    }
    
    @IBAction func leftButton(_ sender: UIButton) {
    }
    
    @IBAction func rightButton(_ sender: UIButton) {
    }
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    var numbers = [Double]()
    
    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        tabBarItem = UITabBarItem(title:"Chart", image:UIImage(named:"chart"),tag:3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

