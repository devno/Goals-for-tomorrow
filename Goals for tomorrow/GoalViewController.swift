//
//  FirstViewController.swift
//  Goals for tomorrow
//
//  Created by Roman Voglhuber on 21/07/15.
//  Copyright (c) 2015 Voglhuber. All rights reserved.
//

import UIKit
import CoreData

class GoalViewController : UITableViewController {
    
    var goals = [String(): [NSManagedObject]()]
    var headers : NSMutableArray = NSMutableArray()
    var numberOfSections: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        navigationItem.leftBarButtonItem = self.editButtonItem()
        
        refreshData()
    }
    
    func refreshData(){
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        
        let  sortDate = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDate]
        
        var error: NSError?
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        
        let dateFormater = NSDateFormatter()
        dateFormater.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormater.dateStyle = NSDateFormatterStyle.LongStyle

        goals = [String(): [NSManagedObject]()]
        headers = NSMutableArray()
        
        let fetchedResults = managedContext?.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults
        {
            for g in results{
                let date = g.valueForKey("date") as! NSDate
                let dif = calendar?.compareDate(date, toDate: NSDate(), toUnitGranularity: NSCalendarUnit.CalendarUnitDay)
                if dif == NSComparisonResult.OrderedAscending {
                    if goals["older"] == nil {
                        goals["older"] = [g]
                        headers.addObject("older")
                    }
                    else{
                        goals["older"]?.append(g)

                    }
                }
                else if dif == NSComparisonResult.OrderedSame{
                    if goals["today"] == nil {
                        goals["today"] = [g]
                        headers.addObject("today")
                    }
                    else{
                        goals["today"]?.append(g)
                    }
                }
                else{
                    if goals[dateFormater.stringFromDate(date)] == nil{
                        goals[dateFormater.stringFromDate(date)] = [g]
                        headers.addObject(dateFormater.stringFromDate(date))
                    }
                    else{
                        goals[dateFormater.stringFromDate(date)]?.append(g)
                    }
                }
            }
        }
        else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals[headers.objectAtIndex(section) as! String]!.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers.objectAtIndex(section) as? String
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        let goal = goals[headers.objectAtIndex(indexPath.section) as! String]![indexPath.row]
        let date : NSDate = goal.valueForKey("date") as! NSDate
        let dateFormater = NSDateFormatter()
        dateFormater.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormater.dateStyle = NSDateFormatterStyle.ShortStyle
        cell.textLabel?.text =  goal.valueForKey("title") as? String
        //+ " - " + dateFormater.stringFromDate(date)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let goal = goals[headers.objectAtIndex(indexPath.section) as! String]![indexPath.row]
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        managedContext.deleteObject(goal)
        
        managedContext.save(nil)
        
        refreshData()
    }
}

