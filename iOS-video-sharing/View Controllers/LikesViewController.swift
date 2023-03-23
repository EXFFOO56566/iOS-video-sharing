//
//  LikesViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/06/24.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit

class LikesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let titleIcons = ["home", "search", "add", "like", "user"]
    let titles = ["Home", "Categories", "Deals", "My Account", "Cart"]
    
    var comments = ["Lol", "ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha ha", "kweeek!", "Lolol", "This is so funny", "", "", "", "", "", "", "",]
    
    var likes = [Like]()
    
    let bottomView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var menuCV: UICollectionView = {
    
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuId")
        cv.backgroundColor = .clear
        
        return cv
    
    }()
    
    
    lazy var addBtn: UIButton = {
        
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 35
        btn.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
        
        let img = UIImage(named: "add")
        
        btn.setImage(img, for: .normal)
        
        btn.contentEdgeInsets = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        
        btn.addTarget(self, action: #selector(postVideoF), for: .touchUpInside)
        
        
        return btn
    }()
    
    @objc func postVideoF(){
        
        let story = UIStoryboard(name: "Main", bundle:nil)
           let vc = story.instantiateViewController(withIdentifier: "NewViewController") as! OptiViewController
        vc.videoCategory = "videos"
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
    
    let postView: UIView = {
        
        let vw = UIView()
        vw.translatesAutoresizingMaskIntoConstraints = false
        
        
        return vw
        
    }()
    
    lazy var commentsCV: UICollectionView = {
    
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(LikesCollectionViewCell.self, forCellWithReuseIdentifier: "Likes")
        cv.backgroundColor = .clear
        
        return cv
    
    }()
       

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        
    }
    
    var heightConstraint: NSLayoutConstraint?
    
    func setup(){
        
        view.backgroundColor = .white
        
        //view.addSubview(postView)
        view.addSubview(commentsCV)
        
        view.addSubview(bottomView)
        view.addSubview(addBtn)
        view.addSubview(menuCV)
        
        
        
        menuCV.dataSource = self
        menuCV.delegate = self
        
        commentsCV.dataSource = self
        commentsCV.delegate = self
        
        /*postView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        postView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        heightConstraint = postView.heightAnchor.constraint(equalToConstant: 324)
        heightConstraint?.isActive = true
        postView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true*/
        
        commentsCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        commentsCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        commentsCV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        commentsCV.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
               bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
               bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
               bottomView.heightAnchor.constraint(equalToConstant: 90).isActive = true
               
               
               addBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -46).isActive = true
               addBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
               addBtn.widthAnchor.constraint(equalToConstant: 70).isActive = true
               addBtn.heightAnchor.constraint(equalToConstant: 70).isActive = true
               
               menuCV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
               menuCV.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
               menuCV.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
               menuCV.heightAnchor.constraint(equalToConstant: view.frame.width / 5).isActive = true
        
        
        
        let shapeLayer = CAShapeLayer()
               
               shapeLayer.path = createBezierPath().cgPath
               
               shapeLayer.strokeColor = UIColor.white.cgColor
               shapeLayer.fillColor = UIColor.white.cgColor
               shapeLayer.lineWidth = 1.0

               // add the new layer to our custom view
               bottomView.layer.addSublayer(shapeLayer)
               
               bottomView.layer.shadowOffset = .zero
               bottomView.layer.shadowColor = UIColor.white.cgColor
               bottomView.layer.shadowRadius = 20
               bottomView.layer.shadowOpacity = 1
        
    }
    
    func createBezierPath() -> UIBezierPath {
              
              let tabWidth: CGFloat = view.frame.width / 5
              let index: CGFloat = 2

              let bezPath = UIBezierPath()

              let firstPoint = CGPoint(x: (index * tabWidth) - 45, y: 0)
              let firstPointFirstCurve = CGPoint(x: ((tabWidth * index) + tabWidth / 4), y: 0)
              let firstPointSecondCurve = CGPoint(x: ((index * tabWidth) - 34) + tabWidth / 8, y: 44)

              let middlePoint = CGPoint(x: (tabWidth * index) + tabWidth / 2, y: 54)
              let middlePointFirstCurve = CGPoint(x: (((tabWidth * index) + tabWidth) - tabWidth / 8) + 34, y: 44)
              let middlePointSecondCurve = CGPoint(x: (((tabWidth * index) + tabWidth) - tabWidth / 4), y: 0)

              let lastPoint = CGPoint(x: (tabWidth * index) + tabWidth + 45, y: 0)
              bezPath.move(to: firstPoint)
              
              bezPath.addCurve(to: middlePoint, controlPoint1: firstPointFirstCurve, controlPoint2: firstPointSecondCurve)
              bezPath.addCurve(to: lastPoint, controlPoint1: middlePointFirstCurve, controlPoint2: middlePointSecondCurve)
              
              
              let right = CGPoint(x: view.frame.width, y: 0)
              
              bezPath.addLine(to: right)
              
              let down = CGPoint(x: view.frame.width, y: 90)
              
              bezPath.addLine(to: down)
              
              let left = CGPoint(x: 0, y: 90)
              
              bezPath.addLine(to: left)
              
              let up = CGPoint(x: 0, y: 0)
              
              bezPath.addLine(to: up)
              
              let closer = CGPoint(x: (index * tabWidth) - 45, y: 0)
              
              bezPath.addLine(to: closer)
              
              bezPath.append(UIBezierPath(rect: bottomView.bounds))
              bezPath.close()
              
              return bezPath
          }
       
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           
           if collectionView == menuCV {
               
               return 1
           }else {
               
               return 1
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
           if collectionView == menuCV {
               
               return 5
           }else {
               
            return likes.count
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           if collectionView == menuCV {
               
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuId", for: indexPath) as! MenuCollectionViewCell
               
               cell.menuIcon.image = UIImage(named: titleIcons[indexPath.row])?.withRenderingMode(.alwaysTemplate)
               cell.menuIcon.tintColor = .black
            
               //cell.menuTitle.text = titles[indexPath.row]
            
            if indexPath.row == 3 {
                
                cell.menuTitle.backgroundColor = UIColor(red: 235/255, green: 58/255, blue: 82/255, alpha: 1)
            }
               
               if indexPath.row == 2 {
                   
                   cell.menuIcon.alpha = 0
               }
               
               return cell
           }else {
               
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Likes", for: indexPath) as! LikesCollectionViewCell
               
               //cell.videoPreview.image = UIImage(named: searchImages[indexPath.row])
               
            cell.commentValue.text = comments[indexPath.row]
               
               return cell
           }
           
           
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == menuCV {
            
            let indexP = indexPath.row
            
            if indexP == 0 {
                
                let tbv = HomeViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }else if indexP == 1 {
                
                let tbv = DiscoverViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
                
            }else if indexP == 3 {
               
                let tbv = LikesViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }else if indexP == 4 {
                
                let tbv = ProfileViewController()
                
                tbv.modalPresentationStyle = .fullScreen
                
                present(tbv, animated: true, completion: nil)
                
            }
        }
    }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           if collectionView == menuCV {
               
               let size = CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
               
               return size
              
           }else {
            
            let approxWidth = view.frame.width - 24
            
            let newSize = CGSize(width: approxWidth, height: 1000)
            
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
            
            let estimatedFrame = NSString(string: comments[indexPath.row]).boundingRect(with: newSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            let size = CGSize(width: view.frame.width, height: estimatedFrame.height + 62)
            
            return size
           
           }
           
       }
       
       


}
