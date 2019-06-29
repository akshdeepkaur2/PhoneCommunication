//
//  ViewController.swift
//  APIDemo
//
//  Created by Parrot on 2019-03-03.
//  Copyright © 2019 Parrot. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WatchConnectivity

let kWIDTH = UIScreen.main.bounds.size.width
let kHEIGHT = UIScreen.main.bounds.size.height
func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
}


class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var outputLabel: UILabel!

    lazy var receiveLabel: UILabel = {
        let label = UILabel()
        label.frame.size = CGSize(width: kWIDTH - 100, height: 40.0)
        label.center = CGPoint(x: kWIDTH / 2.0, y: kHEIGHT / 3.0)
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 6.0
        label.layer.masksToBounds = true
        label.text = "Receive Message..."
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 50.0, y: receiveLabel.center.y + 60.0, width: kWIDTH - 100.0, height: 40.0)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Input Message..."
        return textField
    }()
    
    // MARK: Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        configureWCSession()
        view.addSubview(receiveLabel)
        view.addSubview(textField)
        //let URL = "https://httpbin.org/get"
        let URL = "https://jsonplaceholder.typicode.com/posts"
        
        Alamofire.request(URL).responseJSON {
            
            response in
            
            // TODO: Put your code in here
            // ------------------------------------------
            // 1. Convert the API response to a JSON object
            
            // -- check for errors
            let apiData = response.result.value
            if (apiData == nil) {
                print("Error when getting API data")
                return
            }
            // -- if no errors, then keep going
            
            print(apiData)
            
            
            // 2. Parse out the data you need (sunrise / sunset time)
            
            // example2 - parse an array of dictionaries
            
            // 2a. Convert the response to a JSON object
            let jsonResponse = JSON(apiData)
            
            print(jsonResponse)
            
            // 2b. Get the array out of the JSON object
            var responseArray = jsonResponse.arrayValue
            
            // 2c. Get the 3rd item in the array
            // item #3 = position 2
            var item = responseArray[2];
            print(item)
            
            // Output the "title" of the item in position #2
            self.outputLabel.text = item["title"].stringValue
            
            
//            // 2b. Get a key from the JSON object
//            let origin = jsonResponse["origin"]
//            let host = jsonResponse["headers"]["Host"]
//
//            // 2c. Output the value to screen
//            print("Your IP Address: \(origin)")
//            print("Host: \(host)")
//
//            // 3. Show the data in the user interface
//            self.outputLabel.text = "IP Address: \(origin)"
        }
    
    
        // Does your iPhone support "talking to a watch"?
        // If yes, then create the session
        // If no, then output error message
       // if (WCSession.isSupported()) {
            print("PHONE: Phone supports WatchConnectivity!")
           
            //WCSession.default.delegate = self
           // WCSession.default.activate()
            
       // }
       // else {
            print("PHONE: Phone does not support WatchConnectivity")
       // }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    func configureWCSession() {
        if #available(iOS 9.0, *) {
            if WCSession.isSupported() {
                let session = WCSession.default
                session.delegate = self
                session.activate()
            } else {
                // Current iOS device dot not support session
            }
        } else {
            // The version of system is not available
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func sendMessegeToWatch(message: String) {
        
        if #available(iOS 9.0, *) {
            if !WCSession.default.isReachable {
                let alert = UIAlertController(title: "Failed", message: "Apple Watch is not reachable.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                return
            } else {
                // The counterpart is not available for living messageing
            }
            
            let message = ["title": "iPhone send a message to Apple Watch", "iPhoneMessage": message]
            WCSession.default.sendMessage(message, replyHandler: { (replyMessage) in
                print(replyMessage)
                DispatchQueue.main.sync {
                    self.receiveLabel.text = replyMessage["replyContent"] as? String
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            // The version of system is not available
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: Actions
    
    @IBAction func buttonPressed(_ sender: Any) {
        let message = textField.text ?? ""
        sendMessegeToWatch(message: message)
        view.endEditing(true)
        
//        print("button pressed")
//        // check if the watch is paired / accessible
//        if (WCSession.default.isReachable) {
//            // construct the message you want to send
//            // the message is in dictionary
//            let abc = [
//                "lastName":"Alex",
//                "firstName":"bolas",
//                "email":"a@gmail.com",
//                "lat":"50.0",
//                "lng":"97.0",
//                "username":"adanison",
//                "password":"0000"
//            ]
//        }
//        else {
//            print("PHONE: Cannot find the watch")
//        }
    }

}

extension ViewController: WCSessionDelegate {
    
    @available(iOS 9.3, *)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print(session)
    }
    
    @available(iOS 9.3, *)
    func sessionDidDeactivate(_ session: WCSession) {
        print(session)
    }
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error == nil {
            print(activationState)
        } else {
            print(error!.localizedDescription)
        }
    }
    
    @available(iOS 9.0, *)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        replyHandler(["title": "received successfully", "replyContent": "This is a reply from iPhone"])
        DispatchQueue.main.sync {
            receiveLabel.text = message["watchMessage"] as? String
        }
    }
    
}

