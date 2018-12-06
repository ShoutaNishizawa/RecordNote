//
//  ViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/11/26.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import FontAwesome_swift

class ViewController: UIViewController, UITabBarControllerDelegate {
    
    var navigationTitle : String?
    
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
        
        let v1 = storyboard?.instantiateViewController(withIdentifier: "textVC")
        let v2 = storyboard?.instantiateViewController(withIdentifier: "audioVC")
        let v3 = ExampleViewController()
        let v4 = storyboard?.instantiateViewController(withIdentifier: "todoVC")
        let v5 = storyboard?.instantiateViewController(withIdentifier: "settingVC")
        
        //タブ用のアイコンを取得
        let imageView1 = UIImageView()
        imageView1.image = UIImage.fontAwesomeIcon(name: .pencilAlt , style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
        
        let imageView2 = UIImageView()
        imageView2.image = UIImage.fontAwesomeIcon(name: .itunesNote , style: .brands, textColor: .black, size: CGSize(width: 30, height: 30))
        
        let imageView4 = UIImageView()
        imageView4.image = UIImage.fontAwesomeIcon(name: .checkCircle , style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
        
        let imageView5 = UIImageView()
        imageView5.image = UIImage.fontAwesomeIcon(name: .cog , style: .solid, textColor: .black, size: CGSize(width: 30, height: 30))
        
        //タブボタンのイニシャライズ
        v1?.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Note", image: imageView1.image, selectedImage: imageView1.image)
        v2?.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Audio", image: imageView2.image, selectedImage: imageView2.image)
        
        //RecordButtonをイニシャライズ
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: "Record", image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        
        v4?.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "ToDo", image: imageView4.image, selectedImage: imageView4.image)
        v5?.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Setting", image: imageView5.image, selectedImage: imageView5.image)
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5] as! [UIViewController]
        
        let navigationController = ExampleNavigationController.init(rootViewController: tabBarController)
        navigationController.title = "Example"
        
        addChild(navigationController)
        view.addSubview(navigationController.view)
        tabBarController.view.frame = view.frame
        tabBarController.didMove(toParent: self)
        
        self.navigationItem.title = navigationTitle
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

