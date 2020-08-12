//
//  CreateRecipeViewController.swift
//  TastyRecipes
//
//  Created by Daria Zugravu on 4/12/20.
//  Copyright © 2020 Daria Zugravu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

var recipe: RecipeData?

var selectedCategory: String?

protocol CreateRecipeDelegate {
    
    func addRecipe(userRecipeData: RecipeData)
    
}

class CreateRecipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
//
//

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return pickerData[row] // dropdown item
      
    }
    

    
    var refRecipes: DatabaseReference!
    
    var delegate: CreateRecipeDelegate?
    
    
//    var DataTableViewController:DataTableViewController?
//
//    var data = DataLoader().recipeData
//
//    var recipe:RecipeData?
    
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var categoryPick: UIPickerView!
    
    @IBOutlet weak var recipeName: UITextField!
    
    @IBOutlet weak var recipeIngredients: UITextView!
    
    @IBOutlet weak var recipeSteps: UITextView!
    

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var recipeTime: UITextField!
    
    var imagePicker:UIImagePickerController!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeName.delegate = self as? UITextFieldDelegate
        
        recipeIngredients.delegate = self as? UITextViewDelegate
        
        recipeSteps.delegate = self as? UITextViewDelegate
        
        self.categoryPick.delegate = self
        self.categoryPick.dataSource = self
        
        
        //pickerView.delegate = self
        let pickerView = UIPickerView()

        pickerView.delegate = self

        pickerData = ["Main", "Dessert", "Vegan", "Soup", "Easy"]
        // Do any additional setup after loading the view.
        
        //FIRApp.configure()
        
        refRecipes = Database.database().reference().child("recipes");
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        
        userImage.addGestureRecognizer(imageTap)
        userImage.isUserInteractionEnabled = true
        

        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    var keyCopy: String?
    
    func addRecipesDB() {
        
        
        let key = refRecipes.childByAutoId().key
        
        keyCopy = key
        
        let category = pickerData[categoryPick.selectedRow(inComponent: 0)]
        
       
       
        
        uploadMedia() { url in
            guard let url = url else {return}
            
            let recipe = [       "id": key,
                                 "recipeTitle": self.recipeName.text! as String,
                                 "recipeIngredients": self.recipeIngredients.text! as String,
                                 "recipeSteps": self.recipeSteps.text! as String,
                                 "recipeTime": self.recipeTime.text! as String,
                                        "recipeCategory":  category as String,
                                        "recipeLikes": 0 as Int,
                                        "photoURL": url
                              ] as [String : Any]
            
            self.refRecipes.child(key!).setValue(recipe)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        let storageRef = Storage.storage().reference().child("\(keyCopy)" + ".png")
        if let uploadData = self.userImage.image!.pngData() {
           storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
               if error != nil {
                   print("error")
                   completion(nil)
               } else {

               storageRef.downloadURL(completion: { (url, error) in

                   print(url?.absoluteString)
                   completion(url?.absoluteString)
               })
                   // your uploaded photo url.
               }
          }
    }
    }
    

    
    @IBAction func postRecipeTapped(_ sender: Any) {
        
        addRecipesDB()
        
       
            //
        
      
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            userImage.image = image
          
        }
        else
        {
            //Error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadRecipeImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())){
        
        guard let recipeid = recipe?.id else {return }
        let storageRef = Storage.storage().reference().child("recipes/\(recipeid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                //succes!!
                storageRef.downloadURL{url, error in
                    completion(url)
                    
                }
            }
            else {
                //fail!!
                completion(nil)
            }
            
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

