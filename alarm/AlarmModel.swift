//
//  AlarmModel.swift
//  alarm
//
//  Created by Анна on 21.07.2020.
//  Copyright © 2020 anna. All rights reserved.
//

import Foundation

var allAlarms = [Alarm]()
struct Alarm {
    let alarmTime: Date
    var isOn: Bool
    var idNotification: String?
}
