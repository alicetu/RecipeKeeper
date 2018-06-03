//
//  RecipeController.swift
//  Reciper Keeper
//
//  Created by Alice Mai Tu on 10/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit

class RecipeController: UITableViewController {
    var currentRecipe: Recipe!
    var items = [RecipeViewModelItem]()
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate view model
        let recipeViewModel = RecipeViewModel(recipe: currentRecipe)
        items = recipeViewModel.items
        
        // Specify title and row height
        self.navigationItem.title = currentRecipe.name
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = 40
        tableView?.register(IngredientCell.nib, forCellReuseIdentifier: IngredientCell.identifier)
        tableView?.register(InstructionCell.nib, forCellReuseIdentifier: InstructionCell.identifier)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        // Generate view for each section
        let item = items[indexPath.section]
        switch item.type {
            
        // Generate view for Ingredient section
        case .ingredients:
            
            if let item = item as? RecipeIngredientView, let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier, for: indexPath) as? IngredientCell {
                let ingredient = item.ingredients[indexPath.row]
                cell.item = ingredient
                cell.stepNumber = indexPath.row
                return cell
            }
            
        // Generate view for Instruction section
        case .instruction:
            
            if let item = item as? RecipeInstructionView, let cell = tableView.dequeueReusableCell(withIdentifier: InstructionCell.identifier, for: indexPath) as? InstructionCell {
                let step = item.steps[indexPath.row]
                cell.time = item.steps[indexPath.row].timer
                cell.item = step
                cell.stepNumber = indexPath.row
                return cell
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return items[section].sectionTitle
    }
    
    @IBAction func editRecipe(_ sender: UIButton) {
        let addRecipe = storyboard?.instantiateViewController(withIdentifier: "AddRecipeController") as! AddRecipeController
        addRecipe.currentRecipe = currentRecipe
        addRecipe.name = currentRecipe.name
        addRecipe.cuisine = currentRecipe.cuisine
        addRecipe.time = currentRecipe.time
        for ingredient in currentRecipe.ingredients!{
            addRecipe.ingredients.append(ingredient)
        }
        for step in currentRecipe.instruction!{
            addRecipe.instructions.append("\(step.stepDescription)")
        }
    
        navigationController?.pushViewController(addRecipe, animated: true)
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    
    
}
