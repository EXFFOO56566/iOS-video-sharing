//
//  ChatsTableViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/13.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase

class ChatsTableViewController: UITableViewController {
    
    var uniqueId: String!
    
    var openChatLog = false
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backF))
        
        navigationItem.title = "Chats"
        
        //UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        UINavigationBar.appearance().barTintColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.barStyle = .black
        
        if openChatLog == true {
            
            searchF()
        }
        
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        getUserInfo()
        
        observeUserMessages()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func observeUserMessages(){
        
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
            
        }
        
        let ref = Database.database().reference().child("user-messages").child(userId)
        
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let uid = Auth.auth().currentUser?.uid else {
                
                return
            }
            
            let userId = snapshot.key
            
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                
                self.fetchMessageWithMessageId(messageId: messageId)
                
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func fetchMessageWithMessageId(messageId: String){
        
        let messageRef = Database.database().reference().child("messages").child(messageId)
        
        
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject]{
                
                let message = Message(dictionary: dict)
                
                //self.messages.append(message)
                
                if let chatPartnerId = message.checkPartnerId() {
                    
                    self.messagesDictionary[chatPartnerId] = message
                    
                    
                }
                self.attemptReloadofTable()
                
                
            }
            
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func attemptReloadofTable(){
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
        
    }
    
    @objc func reloadTable(){
        
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort { (message1, message2) -> Bool in
            
            let m1Time = message1.timeStamp!.intValue
            
            let m2Time = message2.timeStamp!.intValue
            
            return m1Time > m2Time
        }
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
        
    }
    
    func getUserInfo(){
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            self.uniqueId = user.uid
            
            let itemReview = Database.database().reference().child("users").child(uniqueId)
            
            itemReview.observe(.value, with: {(snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    if let userName = dict["fullName"] as? String {
                        
                        //self.navigationItem.title = "Goo.fy"//userName
                    
                    }
                
                }
            
            })
        
        }
        
    }
    
    @objc func backF(){
        
        dismiss(animated: true, completion: nil)
    }
    
    var user = User()
    
    @objc func searchF(){
        
        let profileVC = ProfileViewController()
        profileVC.chatsController = self
        
        let layout = UICollectionViewFlowLayout()
        
        let chatLogController = ChatLogController(collectionViewLayout: layout)
        chatLogController.user = user
        chatLogController.modalPresentationStyle = .fullScreen
       
        
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        let message = messages[indexPath.row]
        
        cell.message = message
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 72
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        guard let chatParnterId = message.checkPartnerId() else {
            
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatParnterId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                
                self.user.setValuesForKeys(dict)
                self.searchF()
                
            }
            
        }, withCancel: nil)
        
        
        
    }
    
    

}

class UserCell: UITableViewCell {
    
    var message: Message? {
        
        didSet {
            
            setupNameAndAvatar()
            
            detailTextLabel!.text = message?.text
            
            if let seconds = message?.timeStamp?.doubleValue {
                
                let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                
                timeLbl.text = dateFormatter.string(from: timeStampDate as Date)
            }
            
            
            
        }
    }
    
    private func setupNameAndAvatar(){
        
        if let id = message?.checkPartnerId() {
            
            let ref = Database.database().reference().child("users").child(id)
            
            ref.observeSingleEvent(of: .value) { (snapshot) in
                
                if let dict = snapshot.value as? [String: Any] {
                    
                    if let userName = dict["fullName"] as? String {
                        
                        self.textLabel!.text = userName
                        
                    }
                    
                    if let userProfile = dict["profileImageUrl"] as? String {
                        
                        self.profileImageView.sd_setImage(with: URL(string: userProfile), placeholderImage: UIImage(named: "smell"))
                        
                    }
                    
                    
                }
            }
            
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: ((textLabel?.frame.origin.y)! - 2), width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 64, y: ((detailTextLabel?.frame.origin.y)! + 2), width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileImageView: UIImageView = {
        
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 24
        
        return img
    }()
    
    let timeLbl: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "HH:MM:SS"
        lbl.font = UIFont(name: lbl.font.fontName, size: 12)
        lbl.textColor = .darkGray
        
        
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        
        setup()
    }
    
    func setup(){
        
        addSubview(profileImageView)
        addSubview(timeLbl)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        timeLbl.centerYAnchor.constraint(equalTo: self.textLabel!.centerYAnchor).isActive = true
        timeLbl.heightAnchor.constraint(equalToConstant: 48).isActive = true
        timeLbl.widthAnchor.constraint(equalTo: self.textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
