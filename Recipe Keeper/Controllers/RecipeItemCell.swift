//
//  RecipeItemCell.swift
//  Reciper Keeper
//
//  Created by Roman Pavlov on 10/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit

class RecipeItemCell: UITableViewCell {

    @IBOutlet weak var RecipeTitle: UILabel!
    @IBOutlet weak var RecipeCuisine: UILabel!
    @IBOutlet weak var RecipeTime: UILabel!
    
    func updateRecipeList (with recipe: Recipe) {
        RecipeTitle.text = recipe.name
        RecipeCuisine.text = recipe.cuisine
        if recipe.time < 60 {
            RecipeTime.text = "\(recipe.time) minutes"
        } else if recipe.time == 60 {
            RecipeTime.text = " 1 hour"
        } else if recipe.time > 60 && recipe.time % 60 != 0{
            let hour = Double(recipe.time) / 60.0
            RecipeTime.text = "\(hour) hours"
        } else if recipe.time > 60 && recipe.time % 60 == 0{
            let hour = recipe.time / 60
            RecipeTime.text = "\(hour) hours"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
