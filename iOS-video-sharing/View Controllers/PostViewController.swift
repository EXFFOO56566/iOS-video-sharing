//
//  PostViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer
import AVFoundation
import AVKit
import MobileCoreServices

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKCloudServiceSetupViewControllerDelegate {
    
    private let editor = VideoEditor()
    
    var videoCategory = "videos"
    
    var songs = ["denzel"]
    
    var countryCode = "us"
    
    var albums: [AlbumInfo] = []
    var songQuery: SongQuery = SongQuery()
    var audio: AVAudioPlayer?
    
    lazy var cancelBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "close")?.withRenderingMode(.alwaysTemplate)
        
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.alpha = 0
        
        
        
        return btn
    }()
    
    lazy var musicBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "song")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        
        btn.setTitle("add a sound", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 6,left: 14,bottom: 6,right: 100)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,left: 30,bottom: 0,right: -34)
        //btn.addTarget(self, action: #selector(pickAVideo), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var timerBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "timer")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.alpha = 0
        
        return btn
    }()
    
    lazy var editBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        let img = UIImage(named: "clean")?.withRenderingMode(.alwaysTemplate)
        
        btn.setImage(img, for: .normal)
        btn.tintColor = .white
        btn.alpha = 0
        
        return btn
    }()
    
    lazy var recordBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 2
        
        btn.layer.cornerRadius = 40
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        btn.addTarget(self, action: #selector(recordVideoF), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var nextBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        btn.setTitle("Next", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        
        return btn
    }()

    let musicView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .white
        
        vw.clipsToBounds = true
        vw.layer.cornerRadius = 12
        vw.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        return vw
    }()
    
    
    let searcMusic: UITextField = {
        
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Search Music"
        
        return txt
    }()
    
    let songsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MusicListCell.self, forCellWithReuseIdentifier: "Music")
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        collectionView.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return collectionView
        
    }()
    
    let loadingLoader: UIActivityIndicatorView = {
        
        let img = UIActivityIndicatorView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.tintColor = .white
        img.color = .white
        img.startAnimating()
        img.alpha = 0
        
        
        return img
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
    }
    
    var topMovingAnchor: NSLayoutConstraint?
    
    let controller = SKCloudServiceController()
    
    let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjJaS0FISkE4VVoifQ.eyJpc3MiOiI1N0w0UEZFSjdVIiwiaWF0IjoxNTkzMDkzNDMxLCJleHAiOjE2MDg4NjE0MzF9.RYAnPcewYopNIwdOGR691RKl80bNyk3VK7pz-gQll7jb7KrYihAxX_jmcsWzBtdxuZVjizBPeC0pPrhsjW21PQ"
    
    var userToken = ""
    
    var searchTerm  = "workouts"
    
    var components = URLComponents()
    
    func setup(){
        
        view.addSubview(cancelBtn)
        view.addSubview(musicBtn)
        view.addSubview(recordBtn)
        view.addSubview(editBtn)
        view.addSubview(timerBtn)
        view.addSubview(musicView)
        
        view.addSubview(loadingLoader)
        
        musicView.addSubview(searcMusic)
        musicView.addSubview(songsCollectionView)
        
        songsCollectionView.dataSource = self
        songsCollectionView.delegate = self
        
        cancelBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        cancelBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        musicBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        musicBtn.centerYAnchor.constraint(equalTo: cancelBtn.centerYAnchor).isActive = true
        musicBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        musicBtn.widthAnchor.constraint(equalToConstant: 95).isActive = true
        
        recordBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        recordBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        recordBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        timerBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        timerBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        timerBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timerBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        editBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        editBtn.bottomAnchor.constraint(equalTo: timerBtn.topAnchor, constant: -12).isActive = true
        editBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        editBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        musicView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topMovingAnchor = musicView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        topMovingAnchor?.isActive = true
        musicView.heightAnchor.constraint(equalToConstant: view.frame.height - 200).isActive = true
        musicView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        searcMusic.centerXAnchor.constraint(equalTo: musicView.centerXAnchor).isActive = true
        searcMusic.topAnchor.constraint(equalTo: musicView.topAnchor, constant: 12).isActive = true
        searcMusic.heightAnchor.constraint(equalToConstant: 90).isActive = true
        searcMusic.widthAnchor.constraint(equalToConstant: view.frame.width - 12).isActive = true
        
        songsCollectionView.centerXAnchor.constraint(equalTo: musicView.centerXAnchor).isActive = true
        songsCollectionView.topAnchor.constraint(equalTo: searcMusic.bottomAnchor, constant: 12).isActive = true
        songsCollectionView.bottomAnchor.constraint(equalTo: musicView.bottomAnchor).isActive = true
        songsCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        loadingLoader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingLoader.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingLoader.heightAnchor.constraint(equalToConstant: 35).isActive = true
        loadingLoader.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        

        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                self.albums = self.songQuery.get(songCategory: "")
                DispatchQueue.main.async {
                    //self.tableView?.rowHeight = UITableViewAutomaticDimension;
                    //self.tableView?.estimatedRowHeight = 60.0;
                    self.songsCollectionView.reloadData()
                }
            } else {
                self.displayMediaLibraryError()
            }
        }
        

        
    }
    
    @objc func recordVideoF(){
        
        let alert = UIAlertController(title: "Select Method", message: nil, preferredStyle: .actionSheet)
                        
        let photoLibrary = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            self.recordVideo()
        
        }
        
        let camera = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            self.pickAVideo()
        
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        
        }
        
        alert.addAction(photoLibrary)
        
        alert.addAction(camera)
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func recordVideo(){
        
        pickVideo(from: .camera)
        
    }
    
    @objc func pickAVideo(){
        
        pickVideo(from: .savedPhotosAlbum)
        
        
    }
    
    func displayMediaLibraryError() {

        var error: String
        switch MPMediaLibrary.authorizationStatus() {
        case .restricted:
            error = "Media library access restricted by corporate or parental settings"
        case .denied:
            error = "Media library access denied by user"
        default:
            error = "Unknown error"
        }

        let controller = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }))
        present(controller, animated: true, completion: nil)
    }
    
    
    func cloudServiceSetupViewControllerDidDismiss(_ cloudServiceSetupViewController: SKCloudServiceSetupViewController) {
        // ...
    }
        
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return albums[section].songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Music", for: indexPath) as! MusicListCell
        
        cell.songName.text = albums[indexPath.section].songs[indexPath.row].songTitle
        
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem( songId: songId )

        if  let imageSound: MPMediaItemArtwork = item.value( forProperty: MPMediaItemPropertyArtwork ) as? MPMediaItemArtwork {
            cell.songArt.image = imageSound.image(at: CGSize(width: cell.songArt.frame.size.width, height: cell.songArt.frame.size.height))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem( songId: songId )
        let url: NSURL = item.value( forProperty: MPMediaItemPropertyAssetURL ) as! NSURL
        do {
            audio = try AVAudioPlayer(contentsOf: url as URL)
            guard let player = audio else { return }

            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: view.frame.width, height: 90)
        
        return size
    }
    
    var shouldAddMusic = false
    
    @objc func addMusicF(){
        
        if shouldAddMusic == false {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = 200
            topMovingAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.9) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldAddMusic = true
        }else {
            
            topMovingAnchor?.isActive = false
            topMovingAnchor?.constant = view.frame.height
            topMovingAnchor?.isActive = true
            
            UIView.animate(withDuration: 0.9) {
                
                self.view.layoutIfNeeded()
            }
            
            shouldAddMusic = false
        }
        
        
        
    }
    
    private func pickVideo(from sourceType: UIImagePickerController.SourceType) {
      let pickerController = UIImagePickerController()
      pickerController.sourceType = sourceType
      pickerController.mediaTypes = [kUTTypeMovie as String]
      pickerController.videoQuality = .typeIFrame1280x720
      if sourceType == .camera {
        pickerController.cameraDevice = .front
      }
      pickerController.delegate = self
      present(pickerController, animated: true)
    }
    
    private func showVideo(at url: URL) {
      let player = AVPlayer(url: url)
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      present(playerViewController, animated: true) {
        player.play()
      }
    }
    
    private var pickedURL: URL?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      guard
        let url = pickedURL,
        let destination = segue.destination as? PlayerViewController
        else {
          return
      }
      
      destination.videoURL = url
    }
    
    private func showInProgress() {
      /*activityIndicator.startAnimating()
      imageView.alpha = 0.3
      pickButton.isEnabled = false
      recordButton.isEnabled = false*/
    }
    
    private func showCompleted() {
        
      /*activityIndicator.stopAnimating()
      imageView.alpha = 1
      pickButton.isEnabled = true
      recordButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)*/
    }

}

class MusicListCell: UICollectionViewCell {
    
    let songArt: UIImageView = {
        
        let img = UIImageView()
        img.image = UIImage(named: "smell")
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    let songName: UILabel = {
        
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        lbl.text = "Song Name"
        
        return lbl
    }()
    
    let line: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        vw.backgroundColor = .lightGray
        
        
        return vw
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        
    }
    
    func setup(){
        
        addSubview(songArt)
        addSubview(songName)
        addSubview(line)
        
        songArt.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 12).isActive = true
        songArt.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        songArt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        songArt.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        songName.leftAnchor.constraint(equalTo: songArt.rightAnchor, constant: 12).isActive = true
        songName.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        songName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        songName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        
        line.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        line.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        line.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard
      let url = info[.mediaURL] as? URL
      else {
        print("Cannot get video URL")
        return
    }
    
    //showInProgress()
    self.loadingLoader.alpha = 1
    
    dismiss(animated: true) {
      self.editor.makeBirthdayCard(fromVideoAt: url, forName: "Goo.fy") { exportedURL in
        //self.showCompleted()
        
        self.loadingLoader.alpha = 0
        
        guard let exportedURL = exportedURL else {
          return
        }
        self.pickedURL = exportedURL
        let playerViewController = PlayerViewController()
        playerViewController.videoURL = self.pickedURL
        playerViewController.videoCategory = self.videoCategory
        self.present(playerViewController, animated: true, completion: nil)
      }
    }
  }
}
