//
//  PeopleTableViewController.swift
//  Table Screen App
//
//  Created by Sabin Tabirca on 10/02/2025.
//

import UIKit
import CoreData

class PeopleTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //MARK: - model data
    var peopleData : People!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        applySegmentFilter()
    }
    

    // MARK: CORE DATA VARIABLES
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entity : NSEntityDescription!
    var pManagedObject : CDPerson!
    var frc : NSFetchedResultsController<NSFetchRequestResult>!
    var filteredData: [CDPerson] = []
    var isFiltering: Bool = false
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDPerson")
        let sorting = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorting]
        return request
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make a request to CD
        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try frc.performFetch()
        }catch {
            print("frc cannot fetch")
        }
        // set up frc delegate
        frc.delegate = self
            
        // check if CD has objects
        if frc.sections![0].numberOfObjects > 0 {
            print("You already have objects!")
        } else {
            // if CD does not have objects, XML parse
            entity = NSEntityDescription.entity(forEntityName: "CDPerson", in: context)
            peopleData = People(xmlfile: "people_data.xml")
            
            var countdown = peopleData.count()
            while countdown > 0 {
                let tempPerson = peopleData.getPerson(index: countdown - 1)
                countdown -= 1
                pManagedObject = CDPerson(entity: entity, insertInto: context)
                pManagedObject.name = tempPerson.name
                pManagedObject.position = tempPerson.position
                pManagedObject.age = tempPerson.age
                pManagedObject.nationality = tempPerson.nationality
                pManagedObject.goals = tempPerson.goals
                pManagedObject.url = tempPerson.url
                pManagedObject.image = tempPerson.image
                
                do {
                    try context.save()
                } catch {
                    print("context cannot save")
                }
            }
        }
        applySegmentFilter()
    }
    
    private func applySegmentFilter() {
        guard let allPeople = frc.fetchedObjects as? [CDPerson] else {
            filteredData = []
            isFiltering = false
            return
        }
        
        let selectedIndex = segmentControl.selectedSegmentIndex
        let segmentTitle = segmentControl.titleForSegment(at: selectedIndex)
        
        if segmentTitle == "All" {
            isFiltering = false
        } else {
            isFiltering = true
            filteredData = allPeople.filter {
                $0.position?.caseInsensitiveCompare(segmentTitle ?? "") == .orderedSame
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return filteredData.count
        } else {
            return frc.sections?[section].numberOfObjects ?? 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let person: CDPerson
        if isFiltering {
            person = filteredData[indexPath.row]
        } else {
            person = frc.object(at: indexPath) as! CDPerson
        }
        
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = person.position
        cell.imageView?.image = getImage(name: person.image ?? "")
        
        return cell
    }
    
    func getImage(name: String) -> UIImage {
        
        //try documents directory
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        
        if let image = UIImage(contentsOfFile: path){
            return image}
        
        //fallback to app bundle
        if let bundleImage = UIImage(named: name){
            return bundleImage
        }
        return UIImage() //default blank image
    }
    

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.reloadData()
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // get the object from frc
            pManagedObject = frc.object(at: indexPath) as? CDPerson
            // context deletes the object
            context.delete(pManagedObject)
            do {
                try context.save()
            }catch {
                print("context could not save")
            }
        }
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segue0" {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let person: CDPerson
            
            if isFiltering {
                person = filteredData[indexPath.row]
            } else {
                person = frc.object(at: indexPath) as! CDPerson
            }
            
            let destination = segue.destination as! PersonViewController
            destination.pManagedObject = person
        }
    }
    

}
