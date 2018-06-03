//
//  EstimateTimeCell.swift
//  Reciper Keeper
//
//  Created by Alice Mai Tu on 22/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit

class EstimateTimeCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
 

    @IBOutlet weak var estimatedTime: UITextField!
    
    let tableView = AddRecipeController()
    
    var timePicker = UIPickerView()
    let timePickerData: [Int] = [5,10,15,20,30,45,60,90,120,180,240,300,360]
    var selectedTime: Int?
    
    func formatTime(time: Int) -> String {
        let unit: Int
        if time >= 120 {
            unit = time / 60
            return ("\(unit) hours")
        } else {
            return ("\(time) minutes")
        }
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePickerData.count
        
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let title = formatTime(time: timePickerData[row])
        return title
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = timePickerData[row]
        let selected = formatTime(time: timePickerData[row])
        estimatedTime.text = selected
    }
    
    var time: Int? {
        didSet {
            estimatedTime.placeholder = "How long does this recipe take?"
            if time != nil {
                let recipeTime = formatTime(time: time!)
                estimatedTime.text = recipeTime
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
        estimatedTime.inputView = timePicker
        timePicker.tag = 2
        timePicker.delegate = self
        
        estimatedTime.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
