//
//  DataTableViewController.swift
//  TastyRecipes
//
//  Created by Daria Zugravu on 4/10/20.
//  Copyright © 2020 Daria Zugravu. All rights reserved.
//

import UIKit
import Firebase

class DataTableViewController: UITableViewController, UISearchBarDelegate{

    //var data = DataLoader().recipeData
    
    var refRecipes: DatabaseReference!
    
    var recipesList = [RecipeData]()
    
    //var searchdata = [RecipeData]()
    
    //var titles: [String]!
    
    //var searchdata: [String]!
    
    //var searchResults: [(recipeId: String, recipeCategory: String, recipeTitle: String, recipeIngredients: String, recipeSteps: String, recipeLikes: Int, recipeTime:  String, photoURL: String)] = []
    
    var searchResults = [RecipeData]()
    
   
    @IBOutlet weak var likes: UILabel!
    
   
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        searchbar.delegate = self
        
        searchResults = recipesList
//        let controller = CreateRecipeViewController()
//                controller.delegate = self
        
        refRecipes = Database.database().reference().child("recipes");
        
        refRecipes.observe(DataEventType.value, with:{(snapshot) in
            if snapshot.childrenCount>0 {
                self.recipesList.removeAll()
                
               
                
                for recipes in snapshot.children.allObjects as![DataSnapshot]{
                    let recipeObject = recipes.value as? [String: AnyObject]
                    let recipeId = recipeObject?["id"]
                    let recipeTitle = recipeObject?["recipeTitle"]
                    let recipeCategory = recipeObject?["recipeCategory"]
                    let recipeIngredients = recipeObject?["recipeIngredients"]
                    let recipeSteps = recipeObject?["recipeSteps"]
                    let recipeLikes = recipeObject?["recipeLikes"]
                    let recipeTime = recipeObject?["recipeTime"]
                    let recipePhoto = recipeObject?["photoURL"]
                    
                    let recipe = RecipeData(id: recipeId as! String?, recipeCategory: recipeCategory as! String?, recipeTitle: recipeTitle as! String?, recipeIngredients: recipeIngredients as! String?, recipeSteps: recipeSteps as! String?, recipeLikes: recipeLikes as! Int?, recipeTime: recipeTime as! String?, photoURL: recipePhoto as! String?)
                    
                   
                    self.recipesList.append(recipe)
                }
                self.tableView.reloadData()
            }
        })
        
//
//        let sizeBiggestSorted = recipesList.sorted { (initial, next) -> Bool in
//                      return initial.recipeLikes ?? 0 > next.recipeLikes ?? 0
//                     }
    
        
        searchResults = recipesList
        
        //searchResults.sorted(by: sizeBiggestSorted)
        
       // recipesList.sort(by: >)
        
//        let mostLiked = searchResults.sorted {
//            $0.recipeLikes ?? 0 < $1.recipeLikes ?? 0
//        }
        
        print(recipesList)
       
    
    }
    
   

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return recipesList.count
        searchResults.sort(by: >) //sortez descrescator dupa numarul de like-uri
        return searchResults.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sparklingHeart = "\u{1F496}"
        let zeroLikes = "Be the first one to \(sparklingHeart) this"
        //cell.textLabel?.text = recipesList[indexPath.row].recipeTitle
        cell.textLabel?.text = searchResults[indexPath.row].recipeTitle
        
        if searchResults[indexPath.row].recipeLikes == 0 {
            cell.detailTextLabel?.text = zeroLikes
        }
        else
        {
            cell.detailTextLabel?.text = "\( searchResults[indexPath.row].recipeLikes ?? 0) " + "\(sparklingHeart)"
        }
        
        if searchResults[indexPath.row].recipeCategory == "Vegan" {
        let lockIcon = UIImage(named: "avocado")
        let lockIconView = UIImageView(image: lockIcon)
        lockIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
            //cell.accessoryView = lockIconView
            cell.imageView?.image = lockIcon
        }
        
        if searchResults[indexPath.row].recipeCategory == "Dessert" {
        let lockIcon = UIImage(named: "cupcake")
        let lockIconView = UIImageView(image: lockIcon)
        lockIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
            cell.imageView?.image = lockIcon
          
        }
        
        if searchResults[indexPath.row].recipeCategory == "Main" {
        let lockIcon = UIImage(named: "mainc")
        let lockIconView = UIImageView(image: lockIcon)
        lockIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
            //cell.accessoryView = lockIconView
            cell.imageView?.image = lockIcon
        }
        if searchResults[indexPath.row].recipeCategory == "Easy" {
               let lockIcon = UIImage(named: "easy")
               let lockIconView = UIImageView(image: lockIcon)
               lockIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
               
                   //cell.accessoryView = lockIconView
                   cell.imageView?.image = lockIcon
               }
        if searchResults[indexPath.row].recipeCategory == "Soup" {
        let lockIcon = UIImage(named: "soup")
        let lockIconView = UIImageView(image: lockIcon)
        lockIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        
            //cell.accessoryView = lockIconView
            cell.imageView?.image = lockIcon
        }
//        cell.detailTextLabel?.text = "\( searchResults[indexPath.row].recipeLikes ?? 0)" + "\(sparklingHeart)"
//
        return cell
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "showRecipeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destination = segue.destination as? RecipeViewController {
//            if searchResults.count != recipesList.count {
                destination.recipe = searchResults[(tableView.indexPathForSelectedRow?.row)!]
            //else {
               // destination.recipe = recipesList[(tableView.indexPathForSelectedRow?.row)!]
            //}
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)

       {
                searchBar.text = ""

                searchResults = recipesList

               searchBar.endEditing(true)

               tableView.reloadData()
       }

       

       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)

       {
        searchResults = searchText.isEmpty ? recipesList : recipesList.filter ({
           
            ( recipe: RecipeData) -> (Bool) in
                    
                    // If dataItem matches the searchText, return true to include it
                    
                                let matchCategory = (recipe.recipeCategory!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) || (recipe.recipeTitle!.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil)
            
           
            
            return matchCategory 

                })

                

                tableView.reloadData()
       }
    
    
    
    func searchRecipes(recipeList:[RecipeData], keyword:String) -> [RecipeData] {
        var foundRecipes = [RecipeData]()
        for recipe in recipeList {
            if recipe.recipeIngredients!.contains(keyword) == true {
                foundRecipes.append(recipe)
            }
        }
        return foundRecipes
    }
}
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   // @objc func postRecipeTapped() {
         
        
    // }

}

//extension DataTableViewController: CreateRecipeDelegate {
//
//    func addRecipe(userRecipeData: RecipeData) {
//
//            self.data.append(userRecipeData)
//            print(type(of: userRecipeData))
//            self.tableView.reloadData()
//            print("Content just added:")
//
//
 //    }*/
