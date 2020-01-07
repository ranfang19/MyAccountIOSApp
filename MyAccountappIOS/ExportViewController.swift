//
//  ExportViewController.swift
//  MyAccountappIOS
//
//  Created by Ran FANG on 2020/1/5.
//  Copyright © 2020 Ran FANG. All rights reserved.
//

import UIKit
import CoreData


class ExportViewController: UIViewController {
    
    var lines: [Any] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    private let persistentContainer = NSPersistentContainer(name: "MyAccountappIOS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                }
            else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Line")
                fetchRequest.returnsObjectsAsFaults = false
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "year", ascending: false),NSSortDescriptor(key: "month", ascending: false),NSSortDescriptor(key: "day", ascending: false),NSSortDescriptor(key: "id", ascending: true)]
                do {
                    self.lines = try context.fetch(fetchRequest)
                } catch {
                    print("Failed")
                }
                self.activityIndicatorView?.stopAnimating()
            }
        }
    }
}

extension ExportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LineTableViewCell2.reuseIdentifier, for: indexPath) as? LineTableViewCell2 else {
            fatalError("Unexpected Index Path")
        }
        
        let line = lines[indexPath.row] as! NSManagedObject
        cell.exportTitleLabel.text = line.value(forKey: "title") as? String
        
        if (line.value(forKey: "expense") as? Bool == true) {
            cell.exportAmountLabel.text = "-\(String(line.value(forKey: "amount") as? Double ?? 0))"
        }
        else if(line.value(forKey: "expense") as? Bool == false){
            cell.exportAmountLabel.text = String(line.value(forKey: "amount") as? Double ?? 0 )
        }
        return cell
    }
    

}
