import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlets and Actions
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    
    var pManagedObject: CDPerson!  // Only CDPerson is used now
    
    @IBAction func webInfoAction(_ sender: Any) {
        // Action to open web info (not implemented yet)
    }
    
    @IBAction func updateAction(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the view with CDPerson data
        nameLabel.text = pManagedObject.name
        positionLabel.text = pManagedObject.position
        ageLabel.text = pManagedObject.age
        nationalityLabel.text = pManagedObject.nationality
        goalsLabel.text   = pManagedObject.goals
    }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Websegue" {
            let destinationController = segue.destination as! WebViewController
            // Pass the CDPerson data to the WebViewController
            destinationController.pManagedObject = pManagedObject
        }
        if segue.identifier == "updateSegue1" {
            let destinationController = segue.destination as! AddPersonViewController
            destinationController.pManagedObject = pManagedObject
        }
    }
}
