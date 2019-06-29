# PhoneCommunication
Akshdeep kaur. co7381118
pardeep kaur
Answer of question 1.
the function to recieve message from watch is didRecieveMessage.
below is the whole method cde for recieving message from watch

func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        replyHandler(["title": "received successfully", "replyContent": "This is a reply from iPhone"])
        DispatchQueue.main.sync {
            receiveLabel.text = message["watchMessage"] as? String
            
            Answer of question 2.
            Closure is tomprevent unwanted data or parameters to be show up in result 
            for example if we use this
            replyHandler(["title": "received successfully", "replyContent": "This is a reply from watch"])
        DispatchQueue.main.sync {
            contentLabel.setText(message["iPhoneMessage"] as? String)
            this is without closure and the result will be
            ["title": received successfully, "replyContent": This is a reply from iPhone]
            but with closure it will show only
            [received successfully, This is a reply from iPhone]
