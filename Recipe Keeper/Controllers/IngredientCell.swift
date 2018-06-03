//
//  IngredientCell.swift
//  Reciper Keeper
//
//  Created by Alice Mai Tu on 15/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit

class IngredientCell: UITableViewCell {
    
    @IBOutlet weak var IngredientTag: UIView!
    @IBOutlet weak var IngredientDescription: UILabel!
    
    var item: String? {
        didSet {
            IngredientDescription.text = item
        }
    }
    var stepNumber: Int? {
        didSet {
            if (stepNumber! + 1) % 3 == 0 {
                IngredientTag.backgroundColor = UIColor.MyTheme.pink
            } else if (stepNumber! + 1) % 3 == 1 {
                IngredientTag.backgroundColor = UIColor.MyTheme.yellow
            } else if (stepNumber! + 1) % 3 == 2{
                IngredientTag.backgroundColor = UIColor.MyTheme.orange
            }
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        
        // Configure the view for the selected state
    }
    
}
