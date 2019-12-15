//
//  ViewController.swift
//  MyAccountappIOS
//
//  Created by Ran FANG on 2019/12/5.
//  Copyright © 2019 Ran FANG. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearMonthPicker: UIPickerView!
    @IBOutlet weak var cancelPickerButton: UIButton!
    @IBOutlet weak var donePickerButton: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acticityIndicatorView: UIActivityIndicatorView!
    
    
    
    
    var yearArray:[String] = [String]()
    var monthArray:[String] = [String]()
    
    var yearData:String = "2019"
    var monthData:String = "Dec"
    
    var lines = [Line](){
        didSet {
            updateView()
        }
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Line> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Line> = Line.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false),NSSortDescriptor(key: "month", ascending: false),NSSortDescriptor(key: "day", ascending: false),NSSortDescriptor(key: "id", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    
    private func updateView() {
        var hasLines = false

        if let lines = fetchedResultsController.fetchedObjects {
            hasLines = lines.count > 0
        }

        tableView?.isHidden = !hasLines
        acticityIndicatorView?.stopAnimating()
    }
    
    private let persistentContainer = NSPersistentContainer(name: "MyAccountappIOS")
    

    required init?(coder aDecoder:NSCoder){
        super.init(coder:aDecoder)
        tabBarItem = UITabBarItem(title:"Details", image:UIImage(named:"book"),tag:1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yearLabel.text = "2019"
        monthLabel.text = "Dec"

        pickerViewHiddenStatus(pvStatus: true)
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")

            } else {
                self.setupView()
                
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }

                self.updateView()            }
        }
        
    }
    
    private func setupView() {
        updateView()
    }
    
        
    
    func pickerViewHiddenStatus(pvStatus:Bool) {
        yearMonthPicker.isHidden = pvStatus
        cancelPickerButton.isHidden = pvStatus
        donePickerButton.isHidden = pvStatus
    }
    
    @IBAction func triangleButton(_ sender: Any) {
        self.yearMonthPicker?.dataSource = self
        self.yearMonthPicker?.delegate = self
        
        yearArray = ["2017","2018","2019","2020","2021","2022"]
        monthArray = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]

        pickerViewHiddenStatus(pvStatus: false)
        
    }
    
    @IBAction func cancelPickerButton(_ sender: Any) {
        pickerViewHiddenStatus(pvStatus: true)
    }
    
    
    @IBAction func donePickerButton(_ sender: Any) {
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
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let lines = fetchedResultsController.fetchedObjects else { return 0 }
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LineTableViewCell.reuseIdentifier, for: indexPath) as? LineTableViewCell else {
            fatalError("Unexpected Index Path")
        }

        
        // Fetch Modules
        let line = fetchedResultsController.object(at: indexPath)

        // Configure Cell
        cell.dateLabel.text = "\(String(line.year)) / \(String(line.month)) / \(String(line.day))"
        cell.titleLabel.text = line.title
        
        if (line.expense==true) {
            cell.amountLabel.text = "-\(String(line.amount))"
        }
        else if(line.expense==false){
            cell.amountLabel.text = String(line.amount)
        }
        
        
        return cell
    }
}

extension DetailsViewController: NSFetchedResultsControllerDelegate {}

