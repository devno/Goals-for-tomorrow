//
//  SecondViewController.swift
//  Goals for tomorrow
//
//  Created by Roman Voglhuber on 21/07/15.
//  Copyright (c) 2015 Voglhuber. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        titleField.becomeFirstResponder()
        
        titleField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addGoalPressed(sender: AnyObject) {
        if count(titleField.text) > 0 {
            addGoal(titleField.text, text: "", date: datePicker.date)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    func addGoal(title : String, text : String, date : NSDate){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity =  NSEntityDescription.entityForName("Goal", inManagedObjectContext: managedContext)
        
        let goal = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        
        goal.setValue(title, forKey: "title")
        goal.setValue(text, forKey: "text")
        goal.setValue(date, forKey: "Date")
        
        //4
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return false
    }
}

