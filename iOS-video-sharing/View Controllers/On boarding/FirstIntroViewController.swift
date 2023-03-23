//
//  FirstIntroViewController.swift
//  Goo.fy
//
//  Created by Thapelo on 2020/08/26.
//  Copyright © 2020 Thapelo. All rights reserved.
//

import UIKit
import liquid_swipe

class FirstIntroViewController: UIViewController {

    var viewColor: UIColor = .systemBlue {
        didSet {
            viewIfLoaded?.backgroundColor = viewColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewColor
    }

}

class ViewController: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
    
    var viewControllers: [UIViewController] = {
        let firstPageVC = SecondIntroViewController()
        let secondPageVC = ThirdIntroViewController()
        let thirdPageVC = FourthViewController()
        let forthPageVC = SignUpViewController()
        var controllers: [UIViewController] = [firstPageVC, secondPageVC, thirdPageVC, forthPageVC]
        
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = self
    }

    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
        return viewControllers.count
    }
    
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewControllers[index]
    }

}
