//
//  InstructionCell.swift
//  Reciper Keeper
//
//  Created by Alice Mai Tu on 13/5/18.
//  Copyright © 2018 Alice Mai Tu. All rights reserved.
//

import UIKit
import UserNotifications


/*
 Presenting UIAlertController from UITableViewCell
 https://stackoverflow.com/questions/30483104/presenting-uialertcontroller-from-uitableviewcell
 */
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}

class InstructionCell: UITableViewCell,UNUserNotificationCenterDelegate {
    
    
    
    
    @IBOutlet weak var timer: UIButton!
    @IBOutlet weak var StepTag: UIView!
    @IBOutlet weak var StepDescription: UILabel!
    @IBOutlet weak var Action: UIButton!
    @IBAction func actionButtonTapped(_ sender: Any) {
        Action.isSelected = !Action.isSelected
        //item?.status = Action.isSelected
    }
    
    
    
    /*
     how to make count down timer and send alert
     https://my.oschina.net/hejunbinlan/blog/494722
     */
    
    var remainingSeconds: Int = 0 {
        willSet(newSeconds) {
            let mins = newSeconds/60
            let seconds = newSeconds%60
            self.timer.setTitle("\(mins):\(seconds)", for: [])
        }
    }
    
    var isCounting: Bool = false {
        willSet(newValue) {
            if newValue {
                countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                //add DidEnterBackground listener
                NotificationCenter.default.addObserver(self, selector: #selector(didenterBackground), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
                
                //add DidBecomeActive listener
                NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
            } else {
                
                countdown?.invalidate()
                countdown = nil
            }
        }
    }
    
    var countdown: Timer?
    
    @objc func updateTimer(_ timer: Timer) {
        remainingSeconds -= 1
        if remainingSeconds <= 0 {
            NotificationCenter.default.removeObserver(self)
            self.isCounting = false
            self.timer.setTitle("00:00", for: [])
            self.remainingSeconds = 0
            let alertController = UIAlertController(title: "Timer", message: "count down over!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            parentViewController?.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    
    @IBAction func startTimer(_ sender: Any) {
        print(timer.tag)
        timer.setImage(nil, for: [])
        remainingSeconds = timer.tag * 60
        isCounting = !isCounting
        timer.setTitleColor(UIColor.blue, for: [])
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = "count down over!"
        content.sound = UNNotificationSound(named: "alarm.mp3")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timer.tag * 60),
                                                        repeats: false)
        let identifier = "RecipeLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        notificationCenter.delegate = self
        
    }
    
    var item: Step? {
        didSet {
            StepDescription.text = item?.stepDescription
            //Action.isSelected = (item?.status)!
        }
    }
    
    var time: Int?{
        didSet {
            if(time == 0){
                self.timer.isHidden = true
            }
            timer.tag = time!
        }
    }
    
    var stepNumber: Int? {
        didSet {
            if (stepNumber! + 1) % 3 == 0 {
                StepTag.backgroundColor = UIColor.MyTheme.pink
            } else if (stepNumber! + 1) % 3 == 1 {
                StepTag.backgroundColor = UIColor.MyTheme.yellow
            } else if (stepNumber! + 1) % 3 == 2 {
                StepTag.backgroundColor = UIColor.MyTheme.orange
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        remainingSeconds = 0
        self.timer.setTitle("00:00", for: [])
        
    }
    
    
    
    
    
    @objc func didenterBackground(){
        saveCurrentTime()
    }
    
    @objc func didBecomeActive(){
        loadLastRunTime()
    }
    
    func saveCurrentTime(){
        let stopRunTime = Date()
        print(stopRunTime)
        UserDefaults.standard.set(stopRunTime, forKey: "stopRunTime")
        
    }
    
    func loadLastRunTime(){
        let lastRunTime = UserDefaults.standard.object(forKey: "stopRunTime")
        if lastRunTime != nil{
            let stopRunTime = lastRunTime as! Date
            let different = stopRunTime.timeIntervalSince(Date())
            print("different \(Int(different))")
            if(remainingSeconds+Int(different)<0){
                remainingSeconds = 0
            }else{
                remainingSeconds += Int(different)
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

