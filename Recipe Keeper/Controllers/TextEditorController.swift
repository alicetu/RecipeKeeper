//
//  TextEditorController.swift
//  Reciper Keeper
//
//  Created by Roman Pavlov on 19/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//
import UIKit

enum TextEditorMode {
    case ingredient
    case instruction
}

class TextEditorController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var details: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timerlabel: UILabel!
    
    @IBOutlet weak var textInput: UITextView!
    @IBOutlet weak var timerInput: UITextView!
    
    @IBOutlet weak var userInputView: UIView!
    var originalPosition = CGFloat()
    
    var mode: TextEditorMode!
    var position = 0
    var data = [String]()
    
    
    @objc func tapDetected(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textInput.layer.borderWidth = 1
        textInput.layer.borderColor = UIColor.lightGray.cgColor
        
        timerInput.layer.borderWidth = 1
        timerInput.layer.borderColor = UIColor.lightGray.cgColor
        
        details.dataSource = self
        details.delegate = self
        details.rowHeight = UITableViewAutomaticDimension
        
        if mode == .ingredient {
            
            self.navigationItem.title = "Add Ingredient"
            self.label.text = "Ingredient"
            self.timerInput.isHidden = true
            self.timerlabel.isHidden = true
        } else if mode == .instruction {
            
            self.navigationItem.title = "Step Instruction"
            self.label.text = "Step Instruction"
        }
        
        originalPosition = userInputView.frame.origin.y
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddRecipeController.tapDetected))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue, let offset = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboard: \(keyboardSize.height)")
            print("offset: \(offset.height)")
            // If there is no keyboard
            if userInputView.frame.origin.y == originalPosition {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.userInputView.frame.origin.y = self.originalPosition - keyboardSize.height
                })
            }
            // If there is keyboard
            else {
                if keyboardSize.height == offset.height {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.userInputView.frame.origin.y = self.originalPosition - keyboardSize.height
                    })
                } else {
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.userInputView.frame.origin.y = self.originalPosition - offset.height
                    })
                }
            }
            print(self.userInputView.frame.origin.y)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            userInputView.frame.origin.y = originalPosition
            print(keyboardSize.height)
            print(self.userInputView.frame.origin.y)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    @IBAction func addItem(_ sender: Any) {
        if mode == .ingredient {
            if let text = textInput.text {
                if (!text.hasLetters) {
                    MTAlert(title: "Please enter a valid ingredient", message: "", preferredStyle: .alert)
                        .addAction(title: "Close", style: .cancel) { (_) in
                        }.show()
                    return
                }
                data.append(text)
                DispatchQueue.main.async(execute: {
                    self.details.reloadData()
                })
                textInput.text = ""
                textInput.resignFirstResponder()
            }
        } else {
            if let text = textInput.text {
                if (!text.hasLetters) {
                    MTAlert(title: "Please enter a valid instruction", message: "", preferredStyle: .alert)
                        .addAction(title: "Close", style: .cancel) { (_) in
                        }.show()
                    return
                }
                if let timer = timerInput.text {
                    if (timer != "") {
                        data.append("\(text) (\(timer)mins)")
                    } else {
                        data.append(text)
                    }
                    DispatchQueue.main.async(execute: {
                        self.details.reloadData()
                    })
                }
                textInput.text = ""
                timerInput.text = ""
                textInput.resignFirstResponder()
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }

    
    @IBAction func saveAction(_ sender: Any) {
        if let vcs = navigationController?.viewControllers {
            if let previousVC = vcs[vcs.count - 2] as? AddRecipeController {
                if mode == .ingredient {
                    if (position == -1){
                        for ingredient in data{
                            previousVC.ingredients.append(ingredient)
                        }
                    }else{
                        previousVC.ingredients.insert(contentsOf: data, at: position+1)
                    }
                } else if mode == .instruction {
                    if (position == -1) {
                        for instruction in data {
                            previousVC.instructions.append(instruction)
                        }
                    } else {
                        previousVC.instructions.insert(contentsOf: data, at: position+1)
                        
                    }
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
