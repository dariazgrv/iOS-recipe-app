//
//  RecipeViewController.swift
//  TastyRecipes
//
//  Created by Daria Zugravu on 4/12/20.
//  Copyright © 2020 Daria Zugravu. All rights reserved.
//

import UIKit
import Firebase

class RecipeViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    
    @IBOutlet weak var steps: UITextView!
    
    @IBOutlet weak var addLabel: UILabel!
    

    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var numberOfLikes: UILabel!
    

    
    var recipe: RecipeData?
   var recipesList = [RecipeData]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        recipeTitle.text = recipe?.recipeTitle
        ingredients.text = recipe?.recipeIngredients
        steps.text = recipe?.recipeSteps
        numberOfLikes.text = "\(recipe?.recipeLikes ?? 0)"
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        
         let defaultURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/1200px-Good_Food_Display_-_NCI_Visuals_Online.jpg"
        let url = URL(string: (recipe?.photoURL) ?? defaultURL)
       
        let data = try? Data(contentsOf: url!) //make sure your image in this url exists
        imageView.image = UIImage(data: data!)
        
       

        // Do any additional setup after loading the view.
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapFunction))
               addLabel.isUserInteractionEnabled = true
               addLabel.addGestureRecognizer(tap)
           }

          @IBAction func tapFunction(sender: UITapGestureRecognizer) {
               performSegue(withIdentifier: "addRecipe", sender: self)
           }
    
   
    @IBAction func likeButtonClicked(_ sender: Any) {

        var refRecipes: DatabaseReference!
        
        
         let recipeid = recipe?.id ?? "aa"
        
     
        //var storageRef = Database.database().reference().child("recipes/\(recipeid)")

        refRecipes = Database.database().reference().child("recipes").child("\(recipeid)").child("recipeLikes")
                
                
                            //handle
                            
                            

                            if self.likeButton.tag == 0 {
                                self.likeButton.setBackgroundImage(UIImage(named: "filled.png"), for: .normal)
                                
                                //Database.database().reference().child("recipes").child("\(recipeid)").child("recipeLikes").setValue(16)
                                
                                
                                var numOfLikes: Int?
                                
                                refRecipes.runTransactionBlock({
                                (currentData:MutableData!) in

                                    //self.recipesList.removeAll()


                                        //let recipeObject = snapshot.value as? [String: AnyObject]
                                let currentLikes = currentData.value as? Int ?? 0
                        
                                let liked = currentLikes + 1
                                       

                                currentData.value = liked
                                    
                                    numOfLikes = liked
                                 
                            

                                    return TransactionResult.success(withValue: currentData)


                                           })
                                
                                numberOfLikes.text = "\(recipe!.recipeLikes! + 1)"
                                self.likeButton.tag = 1
                             
                            }
                            else
                            {
                                
                                var numOfLikes: Int?
                                
                                self.likeButton.setBackgroundImage(UIImage(named: "outline.png"), for: .normal)
                                
                                refRecipes.runTransactionBlock({
                                (currentData:MutableData!) in

                                let currentLikes = currentData.value as? Int ?? 0
                                        
                                let unliked = currentLikes - 1
                               

                                currentData.value = unliked
                                   numOfLikes = unliked

                                    return TransactionResult.success(withValue: currentData)


                                    })
                               
                                numberOfLikes.text = "\(recipe!.recipeLikes!)"
                                self.likeButton.tag = 0

                            }

                            //endhandle
                            
                        
                   

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
