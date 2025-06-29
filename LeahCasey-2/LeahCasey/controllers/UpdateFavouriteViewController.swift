//
//  UpdateFavouriteViewController.swift
//  LeahCasey
//
//  Created by Leah Casey on 18/04/2025.
//

import UIKit
import CoreData

class UpdateFavouriteViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // outlets and action
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var positionTF: UITextField!
    @IBOutlet weak var nationalityTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var goalsTF: UITextField!
    @IBOutlet weak var imageTF: UITextField!
    @IBOutlet weak var pickerImageView: UIImageView!
    
    @IBAction func addUpdateAction(_ sender: Any) {
        if pManagedObject == nil{save()
        } else {
            update()
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    // core data objects and functions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pManagedObject : FavouritePerson! = nil
    var pEntity : NSEntityDescription! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the TF-s
        if pManagedObject != nil{
            nameTF.text  = pManagedObject.name
            positionTF.text = pManagedObject.position
            ageTF.text = pManagedObject.age
            nationalityTF.text = pManagedObject.nationality
            goalsTF.text = pManagedObject.goals
            imageTF.text = pManagedObject.image
    
            pickerImageView.image = getImage(name: pManagedObject.image!)
        }
    }
    
    
    // function to deal with data
    func update(){
        // update the pManagedObject
        pManagedObject.name = nameTF.text
        pManagedObject.position = positionTF.text
        pManagedObject.age = ageTF.text
        pManagedObject.nationality = nationalityTF.text
        pManagedObject.goals = goalsTF.text
        pManagedObject.image = imageTF.text
       
        do{
            try context.save()
        }catch{
            print("CD CONTEXT CANNOT SAVE")
        }
        if pickerImageView.image != nil && imageTF.text != nil{
            saveImage(name: imageTF.text!)
        }
    }
    
    
    func save(){
        // create a new managed object
        pEntity = NSEntityDescription.entity(forEntityName: "FavouritePerson", in: context)
        pManagedObject = FavouritePerson(entity: pEntity, insertInto: context)
    
        // update the pManagedObject
        pManagedObject.name = nameTF.text
        pManagedObject.position = positionTF.text
        pManagedObject.age = ageTF.text
        pManagedObject.nationality = nationalityTF.text
        pManagedObject.goals = goalsTF.text
        pManagedObject.image = imageTF.text
        do{
            try context.save()
            if pickerImageView.image != nil && imageTF.text != nil {
                saveImage(name: imageTF.text!)
            }
        }catch{
            print("CD CONTEXT CANNOT SAVE")
        }
    }
    
    
    // image function
    func saveImage(name: String){
        let fm = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let ImageData = pickerImageView.image?.pngData()
        fm.createFile(atPath: path, contents: ImageData, attributes: nil)
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
    
    
    // image picker
    let imagePicker = UIImagePickerController()
    
    
    @IBAction func PickerImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        pickerImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "backFavSegue" {
            let destinationController = segue.destination as! FavouriteViewController
            destinationController.pManagedObject = pManagedObject
        }
    }
}

    
