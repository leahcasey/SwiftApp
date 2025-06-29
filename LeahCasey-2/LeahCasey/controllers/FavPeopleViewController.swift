import UIKit
import CoreData

class FavPeopleViewController: UIViewController {
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var personIM: UIImageView!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet var backgroundUI: UIView!
    
    // Person model data (FavouritePerson)
    var pManagedObject: FavouritePerson!
    
    @IBAction func moreInfoAction(_ sender: UIButton) {
    }
    // Action to delete the person from the "favourites" table
    @IBAction func addFavAction(_ sender: UIButton) {
        if let favouritePerson = pManagedObject {
            // Delete the object from Core Data
            context.delete(favouritePerson)
            
            // Save the context to persist the deletion
            do {
                try context.save()
                print("Person deleted from favorites.")
                
                // Navigate back to the previous screen after deletion
                navigationController?.popViewController(animated: true)
            } catch {
                print("Failed to delete person: \(error.localizedDescription)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if pManagedObject (FavouritePerson) is available
        if let favouritePerson = pManagedObject {
            // Populate the view with FavouritePerson data
            personLabel.text = favouritePerson.name
            personIM.image = getImage(name: favouritePerson.image!)

        } else {
            print("FavouritePerson is not available.")
        }
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


    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguefav1" {
            // Get the destination view controller
            let destinationVC = segue.destination as! FavDetailViewController
            
            // Pass the FavouritePerson object to the detail view controller
            destinationVC.pManagedObject = pManagedObject
        }
    }
}
