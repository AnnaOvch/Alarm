//
//  AlarmViewController.swift
//  alarm
//
//  Created by Анна on 21.07.2020.
//  Copyright © 2020 anna. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {
    
    private let timePicker = UIDatePicker()
    private var alarmTime: Date?
    var completionHandler:((Date)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPicker()
        setUpNavBar()
    }
    
}

private extension AlarmViewController {
    func setUpNavBar() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Add alarm"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action:  #selector(saveAlarm))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAlarm))
    }
    
    @objc func saveAlarm() {
        self.dismiss(animated: true) {
            self.completionHandler?(self.timePicker.date)
        }
    }
    @objc func cancelAlarm() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpPicker() {
        
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.frame = CGRect(x: 0.0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3)
        timePicker.backgroundColor = UIColor.systemPink
        self.view.addSubview(timePicker)
       // timePicker.addTarget(self, action: #selector(timePickerChanged), for: .valueChanged)
        let date = Date()
        timePicker.setDate(date, animated: true )
        
    }
    
    @objc func timePickerChanged() {
        print(timePicker.date)
    }
    
}
