//
//  PlayerViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/07/11.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import AVKit
import Photos

class PlayerViewController: UIViewController {
  var videoURL: URL!
  
  private var player: AVPlayer!
  private var playerLayer: AVPlayerLayer!
    
    var videoCategory = "videos"
    
    lazy var saveVideoBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.setTitle("Next", for: .normal)
        
        btn.addTarget(self, action: #selector(saveVideoF), for: .touchUpInside)
        
        return btn
    }()
  
    
    let videoView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
  
  @IBAction func saveVideoButtonTapped(_ sender: Any) {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
      switch status {
      case .authorized:
        self?.saveVideoToPhotos()
      default:
        print("Photos permissions not granted.")
        return
      }
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    view.addSubview(videoView)
    
    view.addSubview(saveVideoBtn)
    
    videoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    videoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    videoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    
    saveVideoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    saveVideoBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
    saveVideoBtn.heightAnchor.constraint(equalToConstant: 80).isActive = true
    saveVideoBtn.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
    player = AVPlayer(url: videoURL)
    playerLayer = AVPlayerLayer(player: player)
    playerLayer.frame = videoView.bounds
    videoView.layer.addSublayer(playerLayer)
    player.play()
    
    NotificationCenter.default.addObserver(
      forName: .AVPlayerItemDidPlayToEndTime,
      object: nil,
      queue: nil) { [weak self] _ in self?.restart() }
  }
    
    private func saveVideoToPhotos() {
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
      }) { [weak self] (isSaved, error) in
        if isSaved {
          print("Video saved.")
        } else {
          print("Cannot save video.")
          print(error ?? "unknown error")
        }
        DispatchQueue.main.async {
          self?.navigationController?.popViewController(animated: true)
        }
      }
    }
    
    @objc func saveVideoF(){
        
        /*PHPhotoLibrary.requestAuthorization { [weak self] status in
          switch status {
          case .authorized:
            self?.saveVideoToPhotos()
          default:
            print("Photos permissions not granted.")
            return
          }
        }*/
        player.pause()
        
        let publishVC = PublishVideoViewController()
        publishVC.videoURL = self.videoURL
        publishVC.videoCategory = videoCategory
        
        present(publishVC, animated: true, completion: nil)
        
        
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    playerLayer.frame = videoView.bounds
  }
  
  private func restart() {
    player.seek(to: .zero)
    player.play()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: .AVPlayerItemDidPlayToEndTime,
      object: nil)
  }
}
