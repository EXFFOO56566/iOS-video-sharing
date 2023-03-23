//
//  ChatLogController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/13.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    var user: User? {
        
        didSet {
            
            navigationItem.title = user!.fullName
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages(){
        
        guard let uid = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        guard let toId = user?.userId else {
            
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    
                    let message = Message(dictionary: dict)
                    
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView.reloadData()
                        
                        let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0) as IndexPath
                        
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                    
                    /*if message.checkPartnerId() == self.user?.userId {
                        
                        
                        
                    }*/
                    
                    
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    let containerView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .clear
        
        return vw
    }()
    
    let curvedView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .white
        vw.layer.cornerRadius = 21
        vw.layer.shadowColor = UIColor.black.cgColor
        vw.layer.shadowOpacity = 0.1
        vw.layer.shadowOffset = CGSize(width: 0, height: 3)
        vw.layer.masksToBounds = false
        
        return vw
        
    }()
    
    let sendImgBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "cameraIco")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .gray
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(sendImageF), for: .touchUpInside)
        
        return btn
        
    }()
    
    
    lazy var inputTextField: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Enter message"
        txt.delegate = self
        
        return txt
    }()
    
    let sendBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let img = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 25
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(sendMessageF), for: .touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        return btn
        
    }()
    
    
    let separatorLine: UIView = {
        
        let vw = UIView()
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .lightGray
        vw.isHidden = true
        
        return vw
        
    }()
    
    

    var canSendMessageTo = true
    var canSendMessageFrom = true
    
    override func viewDidLoad() {
    super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 76, right: 0)
        
        //collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        collectionView.register(ChatMessageCollectionViewCell.self, forCellWithReuseIdentifier: "ChatCell")
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.keyboardDismissMode = .interactive
        
        
        setupInputComponents()
        
        setupKeyboardObservers()
        
        let infoImage = UIImage(named: "info")
        let rightSideOptionButton = UIBarButtonItem()
        rightSideOptionButton.image = infoImage
        //self.navigationItem.rightBarButtonItem = rightSideOptionButton
        let info = UIBarButtonItem(image: infoImage, style: .plain, target: self, action: #selector(infoF))
        self.navigationItem.rightBarButtonItem = info
        
        let itemReview = Database.database().reference().child("users").child(user!.userId!)
        
        itemReview.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                   
                   if let blocked = dict["blocked"] as? [String: AnyObject]{
                       
                       for iB in blocked {
                           
                        if iB.key == Auth.auth().currentUser!.uid {
                               
                            self.canSendMessageFrom = false
                               
                           }
                       }
                       
                   }
                
            }
            
        })
        
        let me = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        
        me.observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                   
                   if let blocked = dict["blocked"] as? [String: AnyObject]{
                       
                       for iB in blocked {
                           
                        if iB.key == Auth.auth().currentUser?.uid {
                               
                            self.canSendMessageTo = false
                               
                           }
                       }
                       
                   }
                
            }
            
        })
        
        
    }
    
    @objc func infoF(){
        
        var reportF: UIAlertAction!
        
        if canSendMessageFrom == true {
            
            reportF = UIAlertAction(title: "Block Account", style: .default) { (action) in
                
                self.blockUnblock()
            
            }
            
        }else {
            
            reportF = UIAlertAction(title: "Unblock Account", style: .default) { (action) in
                
                self.blockUnblock()
            
            }
            
            
        }
        
        let alertController = UIAlertController(title: "Info", message: nil, preferredStyle: .actionSheet)
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        }
        
        alertController.addAction(reportF)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @objc func blockUnblock(){
        
        if self.canSendMessageFrom == true {
            
            let childValues = ["uniqueId": Auth.auth().currentUser!.uid]
            
            Database.database().reference().child("users").child(self.user!.userId!).child("blocked").child(Auth.auth().currentUser!.uid).updateChildValues(childValues as [AnyHashable : Any])
            
            self.canSendMessageFrom = false
            
        }else {
            
            Database.database().reference().child("users").child(self.user!.userId!).child("blocked").child(Auth.auth().currentUser!.uid).removeValue()
            
            self.canSendMessageFrom = true
        }
        
    }
    
    lazy var inputConatinerView: UIView = {
        
        let containerView = UIView()
        
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        containerView.backgroundColor = .white

        return containerView
        
        
    }()
    

    
    func setupKeyboardObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(){
        
        if messages.count > 0 {
            
            let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0) as IndexPath
            
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            
        }
        
        
        
    }
    
    @objc func keyboardWillShow(notification: Notification){
        
        let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        
        UIView.animate(withDuration: duration) {
            
            self.view.layoutIfNeeded()
            
        }
        
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        containerViewBottomAnchor?.constant = -50
        
        UIView.animate(withDuration: duration) {
            
            self.view.layoutIfNeeded()
            
        }
        
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents(){
        
        view.addSubview(containerView)
        containerView.addSubview(curvedView)
        curvedView.addSubview(sendImgBtn)
        containerView.addSubview(sendBtn)
        curvedView.addSubview(inputTextField)
        containerView.addSubview(separatorLine)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        containerViewBottomAnchor?.isActive = true
        
        containerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        curvedView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        curvedView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        curvedView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -55).isActive = true
        curvedView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendImgBtn.leftAnchor.constraint(equalTo: curvedView.leftAnchor, constant: 8).isActive = true
        sendImgBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendImgBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        sendImgBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        sendBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        inputTextField.leftAnchor.constraint(equalTo: sendImgBtn.rightAnchor, constant: 8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendBtn.leftAnchor, constant: -8).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        separatorLine.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorLine.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLine.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        separatorLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    let imagePickerController = UIImagePickerController()
    
    @objc func sendImageF(){
        
        let alert = UIAlertController(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
            
            //self.menuCV.selectItem(at: [0,0], animated: true, scrollPosition: [])
        
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
            
            //self.menuCV.selectItem(at: [0,0], animated: true, scrollPosition: [])
        
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        }
        
        alert.addAction(photoLibrary)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    var globalImage: UIImage!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
    
        
        if let selectedImage = selectedImageFromPicker {
            
            globalImage = selectedImage
            uploadImage()
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    
    }
    
    func uploadImage(){
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("\(imageName).png")
        
        let uploadData = globalImage.jpegData(compressionQuality: 0.4)!
        
        
        
        storageRef.putData(uploadData, metadata: nil) { (mdata, error) in
            
            if error != nil {
            
            }else {
                
                storageRef.downloadURL { (url, error) in
                    
                    guard let downloadURL = url else {
                        
                        // Uh-oh, an error occurred!
                        
                        return
                    
                    }
                    
                    self.sendMessageWithImageUrl(imageUrl: downloadURL.absoluteString)
                    
                
                }
            
            }
        
        }
    
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        picker.delegate = nil
    
    }
    
    
    @objc func sendMessageF(){
        
        if canSendMessageFrom == true {
            
            if canSendMessageTo == true {
                
                let properties = ["text": inputTextField.text!] as [String : AnyObject]
                
                sendMessageWithProperties(properties: properties)
                
                
            }else {
                
                let alertController = UIAlertController(title: "This user has blocked you", message: nil, preferredStyle: .actionSheet)
        
                
                let cancel = UIAlertAction(title: "Close", style: .cancel) { (action) in
                
                }
                
                alertController.addAction(cancel)
                
                present(alertController, animated: true, completion: nil)
                
                
            }
            
            
            
        }else {
            
            let alertController = UIAlertController(title: "You Blocked This Account", message: nil, preferredStyle: .actionSheet)
            

            let reportF = UIAlertAction(title: "Unblock Account", style: .default) { (action) in
                
                Database.database().reference().child("users").child(self.user!.userId!).child("blocked").child(Auth.auth().currentUser!.uid).removeValue()
                
                self.canSendMessageFrom = true
            
            }
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            }
            
            alertController.addAction(reportF)
            alertController.addAction(cancel)
            
            present(alertController, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    private func sendMessageWithImageUrl(imageUrl: String){
        
        let properties = ["imageUrl": imageUrl, "imageWidth": globalImage.size.width, "imageHeight": globalImage.size.height] as [String : AnyObject]
        
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String: AnyObject]) {
        
        let ref = Database.database().reference().child("messages")
        
        let childRef = ref.childByAutoId()
        
        let fromId = Auth.auth().currentUser!.uid
        
        let toId = user!.userId!
        
        let timeStamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        var values = ["toId": toId, "fromId": fromId, "timeStamp": timeStamp, "profileImageUrl": user!.profileImageUrl!] as [String : AnyObject]
        
        properties.forEach({values[$0] = $1})
        
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                
                return
                
            }else {
                
                self.inputTextField.text = nil
                
                let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                
                let messageId = childRef.key!
                
                userMessagesRef.updateChildValues([messageId: 1])
                
                let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                
                recipientUserMessagesRef.updateChildValues([messageId: 1])
                
                
            }
            
            
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        sendMessageF()
        
        return true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatMessageCollectionViewCell
        
        cell.chatLogController = self
        
        let message = messages[indexPath.row]
        
        cell.textView.text = message.text
        
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            
            cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 32
            cell.textView.isHidden = false
            
            cell.userImageView.isHidden = true
            cell.userNameLbl.isHidden = true
            cell.userCaptionLbl.isHidden = true
            
        }else if message.imageUrl != nil {
            
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
            
            cell.userImageView.isHidden = true
            cell.userNameLbl.isHidden = true
            cell.userCaptionLbl.isHidden = true
            
        }
        
        if message.videoUrl != nil {
            
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
            
            cell.userImageView.isHidden = false
            cell.userNameLbl.isHidden = false
            cell.userCaptionLbl.isHidden = false
            
            
        }
        
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        let fullVideoVC = FullVideoViewController()
        fullVideoVC.videoUrl = message.videoUrl
        fullVideoVC.videoOwnerId = message.userId
        //fullVideoVC.userCaption.text += message.videoCaption
        fullVideoVC.videoCaption = message.videoCaption
        fullVideoVC.videoKey = message.videoKey
        fullVideoVC.sharePicture.sd_setImage(with: URL(string: message.videoImage), placeholderImage: UIImage(named: "smell"))
        fullVideoVC.videoImage = message.videoImage
        fullVideoVC.videoWidth = message.videoWidth as? CGFloat
        fullVideoVC.videoHeight = (message.videoHeight as! CGFloat)
        //fullVideoVC.modalPresentationStyle = .fullScreen
        
        present(fullVideoVC, animated: true, completion: nil)

    }
    
    private func setupCell(cell: ChatMessageCollectionViewCell, message: Message){
        
        if let profile = user?.profileImageUrl {
            
            cell.profileImageView.sd_setImage(with: URL(string: profile), placeholderImage: UIImage(named: "smell"))
        }
    
        
        if message.fromId == Auth.auth().currentUser?.uid {
            
            
            cell.bubbleView.backgroundColor = ChatMessageCollectionViewCell.blueColor
            cell.textView.textColor = .white
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
            
            cell.profileImageView.isHidden = true
            
        }else {
            
            cell.bubbleView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
            cell.textView.textColor = .black
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
            
            
            cell.profileImageView.isHidden = false
            
        }
        
        if let messageImage = message.imageUrl {
            
            cell.messageImageView.isHidden = false
            cell.messageImageView.layer.cornerRadius = 16
            
            cell.messageImageViewTopAnchor?.constant = 0//48
            cell.messageImageViewBottomAnchor?.constant = 0//32
            
            cell.messageImageView.sd_setImage(with: URL(string: messageImage), placeholderImage: UIImage(named: "smell"))
        }else {
            
            cell.messageImageView.isHidden = true
        }
        
        if let videoImage = message.videoImage {
            
            cell.messageImageView.isHidden = false
            cell.messageImageView.layer.cornerRadius = 0
            
            
            for recognizer in cell.messageImageView.gestureRecognizers ?? [] {
                    cell.messageImageView.removeGestureRecognizer(recognizer)
            }
            
            cell.messageImageViewTopAnchor?.constant = 48
            cell.messageImageViewBottomAnchor?.constant = -32
            
            cell.messageImageView.sd_setImage(with: URL(string: videoImage), placeholderImage: UIImage(named: "smell"))
            
            cell.userCaptionLbl.text = message.videoCaption
            cell.userNameLbl.text = message.userName
            cell.userImageView.sd_setImage(with: URL(string: message.userProfileImage), placeholderImage: UIImage(named: "smell"))
            
        }
        
    }
    
    var extraHeight = 78
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.row]
        
        if let text = message.text {
            
            height = estimatedFrameForText(text: text).height + 20
            
        } else if message.imageUrl != nil {
            
            if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue  {
                
                height = CGFloat(imageHeight / imageWidth) * 200
                
            }
            
            
            
        }
        
        if message.videoUrl != nil {
            
            if let imageWidth = message.videoWidth?.floatValue, let imageHeight = message.videoHeight?.floatValue  {
                
                height = CGFloat(imageHeight / imageWidth) * 200 + CGFloat(extraHeight)
                
            }
        }
        
        let size = CGSize(width: view.frame.width, height: height)
        
        return size
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
    
    //zoom in logic
    
    var startingFrame: CGRect?
    
    var blackBackgroundView: UIView?
    
    var startingImageView: UIImageView?
    
    func performZoomInForStartingImage(startingImageView: UIImageView){
        
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        zoomingImageView.layer.zPosition = 5
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        zoomingImageView.image = startingImageView.image
        
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        blackBackgroundView = UIView(frame: keyWindow!.frame)
        blackBackgroundView!.backgroundColor = .black
        blackBackgroundView!.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            keyWindow?.addSubview(self.blackBackgroundView!)
            keyWindow?.addSubview(zoomingImageView)
            
            self.blackBackgroundView!.alpha = 1
            
            self.containerView.alpha = 0
            
            let height = self.startingFrame!.height / self.startingFrame!.width * self.view.frame.width
            
            zoomingImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: height)
            
            zoomingImageView.center = keyWindow!.center
            
        }) { (completed: Bool) in
            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            
            
            
        }, completion: nil)
        
        
        
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer){
        
        if let zoomOutImageView = tapGesture.view {
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                
                self.blackBackgroundView!.alpha = 0
                self.containerView.alpha = 1
                
            }) { (completed: Bool) in
                
                zoomOutImageView.removeFromSuperview()
                
                
                
                self.startingImageView?.isHidden = false
            }
            
           
        }
        
        
    }
}
