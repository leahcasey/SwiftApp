import UIKit
import CoreData

class PersonViewController: UIViewController {
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var personIM: UIImageView!
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet var backgroundUI: UIView!
    
    // Person model data (only CDPerson)
    var pManagedObject: CDPerson!
    
    @IBAction func moreInfoAction(_ sender: UIButton) {
    }
    
    // Action to add person to favorites
    @IBAction func addFavAction(_ sender: UIButton) {
        // Check if pManagedObject (CDPerson) is available
        if let cdPerson = pManagedObject {
            // Create a FavouritePerson managed object
            let favPerson = FavouritePerson(context: context)
            
            // Copy data from CDPerson to FavouritePerson
            favPerson.name = cdPerson.name
            favPerson.position = cdPerson.position
            favPerson.nationality = cdPerson.nationality
            favPerson.image = cdPerson.image
            favPerson.age = cdPerson.age
            favPerson.url = cdPerson.url
            favPerson.goals = cdPerson.goals

            
            // Save the context to persist the FavouritePerson
            do {
                try context.save()
                print("\(cdPerson.name!) added to favorites.")
                
                // Show a message or update the UI (optional)
                let alert = UIAlertController(title: "Success", message: "\(cdPerson.name!) added to favorites!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } catch {
                print("Failed to save favourite person: \(error.localizedDescription)")
            }
        }
        // Navigate back to the previous screen after adding to favorites
        navigationController?.popViewController(animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if pManagedObject (CDPerson) is available
        if let cdPerson = pManagedObject {
            // Populate the view with CDPerson data
            personLabel.text = cdPerson.name
            personIM.image = getImage(name: cdPerson.image!)
            
        } else {
            // Handle case when pManagedObject is nil
            print("CDPerson is not available.")
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


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Handle segue preparation (if needed)
        if segue.identifier == "segue1" {
            let destinationController = segue.destination as! DetailsViewController

            destinationController.pManagedObject = pManagedObject
        }
    }
}
