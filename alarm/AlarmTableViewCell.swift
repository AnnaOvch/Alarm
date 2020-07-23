//
//  AlarmTableViewCell.swift
//  alarm
//
//  Created by Анна on 21.07.2020.
//  Copyright © 2020 anna. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    var thisAlarm: Alarm!
    
    weak var delegate: AlarmCellProtocol?
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(_ alarm: Alarm) {
        self.thisAlarm = alarm
        let timeTuple = thisAlarm.alarmTime.getHours()
        self.hoursLabel.text = String(timeTuple.h).addZero()
        self.minutesLabel.text = String(timeTuple.m).addZero()
        self.alarmSwitch.isOn = thisAlarm.isOn
        
    }
    @IBAction func switchTapped(_ sender: UISwitch) {
        thisAlarm.isOn = sender.isOn
        delegate?.switchTapped(alarm: thisAlarm ,cell: self)
        
    }
    
}

extension Date {
    func getHours() -> (h:Int,m:Int) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        return (hour,minute)
    }
}
extension String {
    func addZero() -> Self {
        if self.count == 1 {
            let str = "0" + self
            return str
        }
        return self
    }
}

protocol AlarmCellProtocol: class {
    func switchTapped(alarm: Alarm, cell: AlarmTableViewCell)
}

