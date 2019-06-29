//
//  Page1InterfaceController.swift
//  APIDemo WatchKit Extension
//
//  Created by MacStudent on 2019-06-26.
//  Copyright © 2019 Parrot. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class Page1InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    // MARK: Required function for WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        // output a debug message to the terminal
        print("WATCH: Got a message!")
        print(message)
        /*
         
         message = {
         "lastname":"cat",
         "firstname":"blue"
         "email":
         "lat":
         "lng"
         "username":
         "password":
         }
        */
        self.personDataList = [
            message["lastName"] as! String,
            message["firstName"] as! String,
            message["email"] as! String,
            message["lat"] as! String,
            message["lng"] as! String,
            message["username"] as! String,
            message["password"] as! String
        ]
        
        // 1. Tell watch how many rows you want
        self.tableViewThing.setNumberOfRows(
            self.personDataList.count, withRowType:"myRow"
        )
        
        // 2. Tell watch what data goes in each row
        for (index, data) in self.personDataList.enumerated() {
            let row = self.tableViewThing.rowController(at: index) as! RowController
            row.outputLabel.setText(data)
        }
        
        
        
        
        // update the message with a label
        self.phoneMessageLabel.setText("\(message)")
    }
    
    
    // MARK: Outlets
    // ----------
    //outlet for the table
    @IBOutlet var tableViewThing: WKInterfaceTable!
    
    // outlet for label to hold messages from phone
    @IBOutlet var phoneMessageLabel: WKInterfaceLabel!
    
    // MARK: Data source
    var personDataList = [
        "pritesh",
        "patel",
        "p@gmail.com",
        "45.0",
        "-234.2",
        "ppatel",
        "1234"
    ]
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        // check for wcsession
        if (WCSession.isSupported()) {
            print("WATCH: WCSession is supported!")
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        else {
            print("WATCH: Does not support WCSession, sorry!")
        }
        
        
        // 1. Tell watch how many rows you want
        self.tableViewThing.setNumberOfRows(
            self.personDataList.count, withRowType:"myRow"
        )
        
        // 2. Tell watch what data goes in each row
        for (index, data) in self.personDataList.enumerated() {
            let row = self.tableViewThing.rowController(at: index) as! RowController
            row.outputLabel.setText(data)
        }
        
        
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
