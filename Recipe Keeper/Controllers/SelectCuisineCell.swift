//
//  SelectCuisineCell.swift
//  Reciper Keeper
//
//  Created by Alice Mai Tu on 22/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit

class SelectCuisineCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var cuisineType: UITextField!
    
    let tableView = AddRecipeController()
    
    var cuisinePicker = UIPickerView()
    let cuisinePickerData: [Cuisine] = Cuisine.allCases
    
    func numberOfComponents(in cuisinePicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cuisinePickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cuisinePickerData[row].rawValue
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cuisineType.text = cuisinePickerData[row].rawValue
    }
    
    
    
    var cuisine: String? {
        didSet {
            cuisineType.placeholder = "Pick a cuisine"
            if cuisine != nil {
                cuisineType.text = cuisine
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
        // Load cuisine picker
        cuisineType.inputView = cuisinePicker
        cuisinePicker.tag = 1
        cuisinePicker.delegate = self
        
        cuisineType.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
