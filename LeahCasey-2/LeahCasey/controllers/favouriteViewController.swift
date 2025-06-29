import UIKit
import CoreData

class FavouriteViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Core Data Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pManagedObject: FavouritePerson!
    let fetchRequest: NSFetchRequest<FavouritePerson> = FavouritePerson.fetchRequest()
    
    var frc: NSFetchedResultsController<FavouritePerson>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Set up the NSFetchedResultsController
        frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: nil,
                                          cacheName: nil)
        
        // Perform the fetch request
        do {
            try frc.performFetch()

        } catch {
            print("frc cannot fetch: \(error.localizedDescription)")
        }
        
        frc.delegate = self
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frc.sections![section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell
        pManagedObject = frc.object(at: indexPath)
        
        // Safely unwrap optional values and provide defaults if necessary
        let name = pManagedObject.name ?? "No Name"
        let position = pManagedObject.position ?? "No Position"
        let imageName = pManagedObject.image ?? "defaultImage"  // fallback image
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = position
        
        // Safely load the image or use a default
        if let image = UIImage(named: imageName) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = getImage(name: pManagedObject.image!)
        }

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

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

    
    // Override to support editing the table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            pManagedObject = frc.object(at: indexPath)
            
            // Context deletes the object
            context.delete(pManagedObject)
            do {
                try context.save()
            } catch {
                print("Context could not save: \(error)")
            }
        }
    }

    // Prepare for segue to the person view controller (if needed)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguefav" {
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let destination = segue.destination as! FavPeopleViewController
            pManagedObject = frc.object(at: indexPath!)
            destination.pManagedObject = pManagedObject
        }
    }
}
