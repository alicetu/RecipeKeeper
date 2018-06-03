//
//  Recipe List Controller.swift
//  Reciper Keeper
//
//  Created by Roman Pavlov on 19/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit
import RealmSwift
class RecipeListController: UITableViewController, UISearchResultsUpdating {
    

    //values from filter
    var selectedCuisine:String?
    var selectedTime:Int?
    var recipes: [Recipe] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func unwindToRecipeList(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Format table view
        tableView.estimatedRowHeight = 0
        // Set up search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor.MyTheme.yellow


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//        let sampleRecipe = Recipe(sampleName, sampleIngredient, sampleTime, sampleCuisine)
//        recipes.append(sampleRecipe)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareDataForTableView()
        tableView.reloadData()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchController.isActive = false

    }
    
    //retrieving data from DB to array recipes
    func prepareDataForTableView(){
        recipes = []
        var tempRecipes = [Recipe]()
        let realm = try! Realm()
        
        let demoIngredients = List<String>()
        let demoInstructions = List<Step>()
        let sampleIngredients = ["4 tablespoons self-raising flour", "4 tablespoons white sugar", "2 tablespoons Milo (or other chocolate powder)", "1 large egg, lightly beaten", "2 tablespoons full-cream milk", "2 tablespoons vegetable oil"]
        for ingredient in sampleIngredients {
            demoIngredients.append(ingredient)
        }
        let sampleInstructions = [Step(description: "Combine flour, sugar and milo in a large coffee mug.", needTimer: false, timer: 0), Step(description: "Add egg, milk and oil. Mix until smooth. Microwave on high for 3 and a half minutes. (Put a small plate underneath the mug to prevent mess if cake over-flows)", needTimer: true, timer: 3), Step(description: "Serve in the mug with ice-cream.", needTimer: false, timer: 0)]
        
        for instruction in sampleInstructions {
            demoInstructions.append(instruction)
        }
        
        let demoRecipe = Recipe(name: "Milo mug cake", time: 5, cuisine: "Australian", ingredients: demoIngredients, instruction: demoInstructions)
        try! realm.write {
            realm.add(demoRecipe, update: true)
        }
        
        var results: Results<Recipe>!
        if isSearching(){
            results = realm.objects(Recipe.self).filter("name CONTAINS[cd] %@",searchController.searchBar.text!)
        }else{
            
            var predicates = [NSPredicate]()
            if selectedCuisine != nil{
                let predicate = NSPredicate(format: "cuisine = %@", selectedCuisine!)
                predicates.append(predicate)
            }
            if selectedTime != nil{
                let predicate = NSPredicate(format: "time <= %d", selectedTime!)
                predicates.append(predicate)
            }
            if predicates.count > 0{
                let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
                results =  realm.objects(Recipe.self).filter(compoundPredicate)
            }else{
                results =  realm.objects(Recipe.self)
            }
        }
        for recipe in results{
            tempRecipes.append(recipe)
        }
        recipes = tempRecipes
    }
    
    
    // MARK: - Helpers
    func isSearching()->Bool{
        
        guard searchController.isActive else {return false}
        guard let searchText = searchController.searchBar.text else {return false}
        
        return searchText.count > 1
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
    
        prepareDataForTableView()
    
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    //setting number of rows for recepies
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recipes.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "RecipeItem", for: indexPath) as! RecipeItemCell
        let recipe = recipes[indexPath.row]
        cell.updateRecipeList(with: recipe)
        cell.showsReorderControl = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let realm = try! Realm()
            try! realm.write {
                realm.delete(recipes[indexPath.row])
            }
            self.recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipeViewController = storyboard?.instantiateViewController(withIdentifier: "RecipeController") as! RecipeController
        recipeViewController.currentRecipe = recipes[indexPath.row]
        print(recipes[indexPath.row])
        navigationController?.pushViewController(recipeViewController, animated: true)
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewRecipe" {
            let recipeViewController = segue.destination as! RecipeController
            let selected = tableView.indexPathForSelectedRow?.row
            recipeViewController.currentRecipe = recipes[selected!]
        }
    }
    */
  
    
    //filtering the recipe list
    @IBAction func filterAction(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "FilterController") as! FilterController
        
        if selectedCuisine != nil{
            vc.selectedCuisineIndex = vc.cuisines.index(of: Cuisine(rawValue: selectedCuisine!)!)
        }
        
        if selectedTime != nil{
            vc.selectedTimeIndex = vc.timeMark.index(of: selectedTime!)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
