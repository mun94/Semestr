
// Developer: Warren Seto
//      File: EditSemesterView.swift
//   Purpose: Displays a list of classes from collected semester data

import UIKit
import CoreData

final class EditSemesterView: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate
{
    
    /* ---- Variables ---- */
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedSemester:Semester!

    lazy var coreData: NSFetchedResultsController =
    {
        let fetch = NSFetchRequest(entityName: "Course") // Get all Course Objects
        fetch.sortDescriptors = [NSSortDescriptor(key: "day", ascending: true)] // Sort by Day
        fetch.predicate = NSPredicate(format: "semester.name == %@", self.selectedSemester.name!) // Find elements that are associated with the semester
        
        let control = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreData.app.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        control.delegate = self
        return control
    }()
    
    
    /* ---- ViewController Code ---- */
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = selectedSemester.name
        
        do { try self.coreData.performFetch() }
        catch let err as NSError { print("Could not fetch \(err), \(err.userInfo)") }
        
        
        CoreData.app.addNewCourse(semester: selectedSemester, "CSC 215", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Monday")
        CoreData.app.addNewCourse(semester: selectedSemester, "CSC 315", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Tuesday")
        CoreData.app.addNewCourse(semester: selectedSemester, "CSC 415", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Wednesday")
        CoreData.app.addNewCourse(semester: selectedSemester, "CSC 515", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Thursday")
        CoreData.app.addNewCourse(semester: selectedSemester, "CSC 615", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Friday")
        CoreData.app.addNewCourse(semester: selectedSemester, "CSC 715", "Forcina", "408", "lo.jpg", "9 AM", "11 AM", "Saturday")
        
    }
    
    
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    
    /* ---- NSFetchedResultsController Code ---- */
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        switch (type)
        {
            case .Insert:
                if let indexPath = newIndexPath
                {
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            
            case .Delete:
                if let indexPath = indexPath
                {
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            
            default:
                print("Not Implemented - \(type)")
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) { tableView.beginUpdates() }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) { tableView.endUpdates() }
    
    
    /* ---- UITableView Code ---- */
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        let view = storyboard!.instantiateViewControllerWithIdentifier("EditCourseView") as! EditCourseView
        view.selectedCourse = coreData.objectAtIndexPath(indexPath) as! Course
        presentViewController(view, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tablecell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CourseCell")!
        
        let temp = coreData.objectAtIndexPath(indexPath) as! Course
        tablecell.textLabel?.text = temp.name
        tablecell.detailTextLabel?.text = "\(temp.location!) \(temp.room!)"
        //tablecell.imageView?.image = UIImage(named: "FORCINA")
        
        return tablecell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (editingStyle == .Delete)
        {
            CoreData.app.deleteObject(coreData.objectAtIndexPath(indexPath) as! NSManagedObject)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        if let sections = coreData.sections
        {
            return sections.count
        }
            return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = coreData.sections
        {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
            return 0
    }
}





