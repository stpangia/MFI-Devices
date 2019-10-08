//
//  ViewController.swift
//  MFI Devices
//
//  Created by Sean Pangia on 10/6/19.
//  Copyright © 2019 Sean Pangia. All rights reserved.
//

import UIKit
import ExternalAccessory

class ViewController: UIViewController, UITableViewDataSource {
    
    let manager = EAAccessoryManager.shared()

    let tableview: UITableView = {
        print("tableview init")
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")

        manager.registerForLocalNotifications()
        NotificationCenter.default.addObserver(self, selector: Selector("deviceConnected:"), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector("deviceDisconnected:"), name: NSNotification.Name.EAAccessoryDidDisconnect, object: nil)

        setupTableView()
        

    }
    
    func setupTableView() {
        print("setupTableView")
        tableview.delegate = self as? UITableViewDelegate
        tableview.dataSource = self
        
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
    }

    func deviceConnected(notification: NSNotification) {
        tableview.reloadData()
        if let acc = notification.userInfo![EAAccessoryKey] {
            showAccessoryInfo(accessory: acc as! EAAccessory)
        }
    }
    
    func deviceDisconnected(notification: NSNotification) {
        tableview.reloadData()
    }
    
    func showAccessoryInfo(accessory: EAAccessory) {
        UIAlertView(title: "\(accessory.manufacturer) \(accessory.name)", message: "\(accessory.description)", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows: \(manager.connectedAccessories.count)")

        return manager.connectedAccessories.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("cellheight")
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Row \(indexPath.row+1)")

        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.backgroundColor = UIColor.white
        
        let acc = manager.connectedAccessories[indexPath.row]
        
        cell.textLabel?.text = "\(acc.manufacturer) \(acc.name)"
        cell.detailTextLabel?.text = "\(acc.modelNumber) \(acc.serialNumber)\n fr:\(acc.firmwareRevision) hr: \(acc.hardwareRevision)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let acc = manager.connectedAccessories[indexPath.row]
        showAccessoryInfo(accessory: acc)
    }
    

}

