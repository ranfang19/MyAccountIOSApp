//
//  SettingViewController.swift
//  MyAccountappIOS
//
//  Created by Ran FANG on 2020/1/5.
//  Copyright © 2020 Ran FANG. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingViewController: UIViewController {

    var data: [Any] = []
    private let persistentContainer = NSPersistentContainer(name: "MyAccountappIOS")
    
    @IBAction func deleteAllDataBtn(_ sender: UIButton) {
        createAlert(title:"WARNING!",message:"Are you sure that you want to delete all data?")
    }
    
    func createAlert(title:String,message:String){
        
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.destructive, handler: {(action:UIAlertAction!) in
            self.deleteAllData()
        }))

        
        self.present(alert,animated:true,completion:nil)
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
        }
    
    func deleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Line")
        
        do {
            data = try context.fetch(fetchRequest)
            if data.count>0 {
                for r in data as! [NSManagedObject] {
                    context.delete(r)
                }
            }
            do {
                try context.save()
            } catch  {
                print("ALL delete error")
            }
        } catch {

        }
    }
    
    
    

    
    

}
