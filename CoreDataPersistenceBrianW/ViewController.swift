//
//  ViewController.swift
//  CoreDataPersistenceBrianW
//
//  Created by Brian Wawczak on 3/31/19.
//  Copyright © 2019 Brian Wawczak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private static let lineEntityName = "Line"
    private static let lineNumberKey = "lineNumber"
    private static let lineTextKey = "lineText"
    
    
    @IBOutlet var lineFields:[UITextField]!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:
        ViewController.lineEntityName)
        
        do {
            let objects = try context.fetch(request)
            for object in objects {
                let lineNum: Int = object.value(forKey: ViewController.lineNumberKey)! as! Int
                let lineText = object.value(forKey: ViewController.lineTextkey) as? String
                ?? ""
                let textField = lineFields[lineNum]
                textField.text = lineText
            }
            
            let app = UIApplication.shared
            NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)),
            name: UIApplication.willResignActiveNotification,
                object: app)
        } catch {
            // error thrown from executeFetchRequest()
            print("There was an error in executeFetchRequest(): \(error)")
        }
    }
    
    func applicationWillResignActive(_ notification:Notification) {
        let appDelegate =
            UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        for i in 0..<lineFields.count {
            let textField = lineFields[i]
            
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName:
            ViewController.lineEntityName)
            let pred = NSPredicate(format: "%K = %d", ViewController.lineNumberKey, i)
            request.predicate = pred
            
            do {
                let objects = try context.fetch(request)
                var theLine: NSManagedObject! = objects.first as? NSManagedObject
                if theLine == nil {
                    // no existing data for this row - insert a new managed object for it theLine =
                    kSecAttrDescription.insertNewObject(
                        forEntityName: ViewController.lineEntityName,
                        into: context)
                        as NSManagedObject
                    }
                    
                    theLine.setValue(i, forKey: ViewController.lineNumberKey)
                    theLine.setValue(textField.text, forKey: ViewController.lineTextKey)
                } catch {
                    print ("There was an error in executeFetchRequest(): \(error)")
                }
                appDelegate.saveContext()
            }
        }
    


}

