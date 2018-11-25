//
//  ViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/11/26.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ViewController: UIViewController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tabBarController : ESTabBarController = ESTabBarController()
        tabBarController.delegate = self
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        
        //中央のボタン(index == 2)の時、true
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        
        //中央のボタンが押された時の処理
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
                alertController.addAction(takePhotoAction)
                let selectFromAlbumAction = UIAlertAction(title: "Select from album", style: .default, handler: nil)
                alertController.addAction(selectFromAlbumAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                tabBarController?.present(alertController, animated: true, completion: nil)
            }
        }
        //４つ目のかFavorボタンが押された時
        //        tabBarController.shouldHijackHandler = {
        //            tabbarController, viewController, index in
        //            if index == 3 {
        //                return true
        //            }
        //            return false
        //        }
        //
        //        //中央のボタンが押された時の処理
        //        tabBarController.didHijackHandler = {
        //            [weak tabBarController] tabbarController, viewController, index in
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        //                //self.performSegue(withIdentifier: "goToTest", sender: self)
        //                //self.tabBarController?.performSegue(withIdentifier: "testVC", sender: self)
        //
        //                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //                let dstView = storyBoard.instantiateViewController(withIdentifier: "testVC")
        //                self.tabBarController?.navigationController?.present(dstView, animated: true, completion: nil)
        //            }
        //        }
        
        let v1 = ExampleViewController()
        //let v2 = storyboard?.instantiateViewController(withIdentifier: "testVC")
        let v2 = ExampleViewController()
        let v3 = ExampleViewController()
        let v4 = ExampleViewController()
        let v5 = ExampleViewController()
        
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"), tag: 0)
        v2?.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Find", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"), tag: 1)
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"), tag: 2)
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Favor", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"), tag: 3)
        v5.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Me", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"), tag: 4)
        print(v3.tabBarItem.tag)
        
        v4.changeTipColor(sender: self)
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5] as! [UIViewController]
        
        
        
        //        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        //        tabBarController.title = "Example"
        
        
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.frame
        tabBarController.didMove(toParentViewController: self)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

