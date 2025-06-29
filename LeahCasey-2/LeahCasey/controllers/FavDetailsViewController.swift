import UIKit
import CoreData

class FavDetailViewController: UIViewController {
    
    // MARK: - Outlets and Actions
    
    @IBOutlet weak var personLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBAction func webInfoAction(_ sender: Any) {
    }
    @IBAction func updateAction(_ sender: UIButton) {
    }
    
    // Person model data (FavouritePerson)
    var pManagedObject: FavouritePerson!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if pManagedObject (FavouritePerson) is available
        if let favouritePerson = pManagedObject {
            // Populate the view with FavouritePerson data
            personLabel.text = favouritePerson.name
            positionLabel.text = favouritePerson.position
            ageLabel.text = favouritePerson.age
            nationalityLabel.text = favouritePerson.nationality
            goalsLabel.text = favouritePerson.goals
            
        } else {
            print("FavouritePerson is not available.")
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If needed, you can pass any necessary data to the next view controller here
        // This is just an example for a segue that might be used
        if segue.identifier == "FavWebsegue" {
            let destinationController = segue.destination as! FavWebViewController
            destinationController.pManagedObject = pManagedObject
        }
        if segue.identifier == "favUpdateSegue" {
            let destinationController = segue.destination as! UpdateFavouriteViewController
            destinationController.pManagedObject = pManagedObject
        }
    }
}
