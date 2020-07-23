//
//  AlarmTableViewController.swift
//  alarm
//
//  Created by Анна on 21.07.2020.
//  Copyright © 2020 anna. All rights reserved.
//

import UIKit
import UserNotifications

enum CellConstants: String {
    case cell
}

class AlarmTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotifications()
        setUpNavigationBar()
        tableView.register(UINib(nibName: "AlarmTableViewCell", bundle: .main), forCellReuseIdentifier: CellConstants.cell.rawValue)
        tableView.tableFooterView = UIView()
        print(listNotifications())////????
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAlarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.cell.rawValue, for: indexPath) as! AlarmTableViewCell
        cell.delegate = self
        cell.configure(allAlarms[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    

}

private extension AlarmTableViewController {
    func setUpNotifications() {
        let options: UNAuthorizationOptions = [.alert,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (didAllow, error) in
            if error != nil {
                print("error")
                return
            }
            if didAllow {
                print("allowed")
            } else {
                print("not allowed")
            }
        }
    }
    

    func setUpAlarmNotification(_ alarm: inout Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Wake up!"
        content.body = " It is already \(alarm.alarmTime.getHours().0):\(alarm.alarmTime.getHours().1)"
        content.sound = UNNotificationSound.default
        
        let imageName = "alarm-clocks"
        let imageURL = AssetExtractor.createLocalUrl(forImageNamed: "alarm-clocks")
        let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL!, options: .none)
        
        content.attachments = [attachment]

        let triggerDate = Calendar.current.dateComponents([.hour,.minute], from: alarm.alarmTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "\(UUID().uuidString)", content: content, trigger: trigger)
        
        alarm.idNotification = request.identifier
        print(alarm.idNotification)
        
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func listNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
            print("\(requests.count) requests -------")
            for request in requests{
                print(request.identifier)
            }
        })
    }
    
    @objc func addAlarm() {
        let vc =  AlarmViewController()
        vc.completionHandler = { [weak self] (alarmDate) in
            var alarm = Alarm(alarmTime: alarmDate, isOn: true)
            self?.setUpAlarmNotification(&alarm)
            allAlarms.append(alarm)
            self?.tableView.reloadData()
            
       }
        let navC = UINavigationController(rootViewController: vc)
        navC.modalPresentationStyle = .fullScreen
        self.present(navC, animated: true, completion: nil)
    }
    
    func setUpNavigationBar() {
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlarm))
          self.navigationItem.title = "Your alarms"
      }
      
}

extension AlarmTableViewController: AlarmCellProtocol {
    func switchTapped(alarm:Alarm, cell: AlarmTableViewCell) {
        guard let indexPath =  tableView.indexPath(for: cell) else {return}
        allAlarms[indexPath.row] = alarm
        if allAlarms[indexPath.row].isOn == false {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [allAlarms[indexPath.row].idNotification!])
            allAlarms[indexPath.row].idNotification = nil
            
        } else if allAlarms[indexPath.row].isOn == true && allAlarms[indexPath.row].idNotification == nil {
            setUpAlarmNotification(&allAlarms[indexPath.row])
        }
        print("work")
        print(allAlarms[indexPath.row])
       
        tableView.reloadData()
    }
    
    
}

class AssetExtractor {

    static func createLocalUrl(forImageNamed name: String) -> URL? {

        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path

        guard fileManager.fileExists(atPath: path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
                else { return nil }

            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }

        return url
    }

}
