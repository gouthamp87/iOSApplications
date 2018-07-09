//
//  ViewController.swift
//  Flash Chat
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    // To read messages from DB create a MessageArray to populate for a user
    var messagesArray : [Message] = [Message]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    var keyboardHeight:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set yourself as the delegate and datasource here:
        messageTableView.delegate = self
        messageTableView.dataSource = self
        //Set yourself as the delegate of the text field here:
        messageTextfield.delegate = self
        //Set the tapGesture here: so that the keyboard disappears after you click anywhere outside the text area.
        
        messageTableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedOnTableView)))
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        configureTableView()
        retrieveMessages()
        messageTableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //MARK: Text field delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        resignFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: TableView cell delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
//        let msgArray = ["First Message", "Second Message", "Third Message"]
        cell.messageBody.text = messagesArray[indexPath.row].message
        cell.senderUsername.text = messagesArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "egg")
        
        if cell.senderUsername.text == Auth.auth().currentUser?.email as String!{
            cell.avatarImageView.backgroundColor = UIColor.darkGray
            cell.messageBackground.backgroundColor = UIColor.purple
        } else {
            cell.avatarImageView.backgroundColor = UIColor.magenta
            cell.messageBackground.backgroundColor = UIColor.cyan
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120
    }
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    

    
    //TODO: Declare textFieldDidBeginEditing here:
    
    
    
    
    //TODO: Declare textFieldDidEndEditing here:
    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    
    
    // Send the messages to Firebase DB
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        // Before reading disable Text and send
        sendButton.isEnabled = false
        messageTextfield.isEnabled = false
        
        // Read the message to be send.
        let messageToSend = messageTextfield.text!
        print("Message to send was \(messageToSend)")
        // Clear the text field after reading and dismiss the keyboard.
        messageTextfield.text = nil
        messageTextfield.endEditing(true)
        
        // After reading enable Text and send
        sendButton.isEnabled = true
        messageTextfield.isEnabled = true
        
        //Send the message to Firebase and save it in our database
        
        let messageDB = Database.database().reference().child("GothChatMessages")   //This would create a child Database called "GothChatMessages" in our DB. Is this the right way?
        let messageDictionary = ["Sender":Auth.auth().currentUser?.email, "MessageBody": messageToSend]
        messageDB.childByAutoId().setValue(messageDictionary) { (err, dbReference) in
            if err != nil{
                print("Writing message \(messageToSend)to DB failed with error \(String(describing: err))");
            } else {
                print("Successfully Saved message to DB")
                //                self.retrieveMessages()   BUGFIX: Don't do this here, it owuld keep adding observers and would mess up.
            }
        }
        
    }
    
    //  Retrieve the messages from firebaseDB here:
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("GothChatMessages")
//        messageDB.observe(.value) { (snapshot) in
//            let messageRetrieved = snapshot.value as! Dictionary<String,[String:String]>
//            print(messageRetrieved)
//            var i = 0
//            for (key,value) in messageRetrieved{
//                self.messagesArray[i].message = value["MessageBody"]
//                self.messagesArray[i].sender = value["Sender"]
//                i = i+1
//            }
//        }
        messageDB.observe(.childAdded) { (snapshot) in
            let newMessage = snapshot.value as? Dictionary<String,String>
            print("New Message got added \(String(describing: newMessage)) ")
            let message = Message()
            message.message = newMessage?["MessageBody"]
            message.sender = newMessage?["Sender"]
            self.messagesArray.append(message)
            self.configureTableView()
            self.messageTableView.reloadData()
        }
    }
    

//    func retrieveMessagesOld(){
//        let messageDB = Database.database().reference().child("GothChatMessages")
//        messageDB.observe(.value) { (snapshot) in
//            let messageRetrieved = snapshot.value as? NSDictionary
//            print(messageRetrieved!)
//        }
//    }
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Hey there was a problem signing out")
        }
    }
    
    
    //MARK: - Detect keyboard height dynamically
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print(keyboardHeight)
        }
        heightConstraint.constant = keyboardHeight + 50
    }

    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print(keyboardHeight)
        }
        heightConstraint.constant = 50
    }

    //MARK: Gesture Recogniser Handles
    @objc func tappedOnTableView()  {
        messageTextfield.endEditing(true)
    }
    
}
