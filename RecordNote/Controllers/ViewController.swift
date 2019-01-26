//
//  ViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/11/26.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreData
import ESTabBarController_swift
import FontAwesome_swift

protocol ViewControllerDelegate {
    
}


class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITabBarControllerDelegate {
    
    
    var navigationTitle : String?
    
    var selectedItem : Item? {
        didSet{
            //loadAudioFiles()
        }
    }
    //var delegate : AudioViewControllerDelegate?
    var destinationVC : AudioTestViewController?

    //selectedItemが参照された時のみloadAudioFilesが呼び出される
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        destinationVC = (storyboard?.instantiateViewController(withIdentifier: "audioVC") as! AudioTestViewController)
        

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
        
        let v1 = storyboard?.instantiateViewController(withIdentifier: "textVC")
        let v2 = storyboard?.instantiateViewController(withIdentifier: "audioVC") as! AudioTestViewController
        let v3 = ExampleViewController()
        let v4 = storyboard?.instantiateViewController(withIdentifier: "todoVC") as! ToDoTableViewController
        let v5 = storyboard?.instantiateViewController(withIdentifier: "settingVC")
        
        //中央のボタンが押された時の処理
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                print("record button tapped! in VC")
                
                print("selected itemは？ \(self.selectedItem!)")
                self.destinationVC?.selectedItemForAudioView = self.selectedItem
                self.destinationVC?.record(selectedItemPath: self.selectedItem!)
                
            }
        }
        
        //AudioViewControllerにselectedItemの値を受け渡す
        v2.selectedItemForAudioView = selectedItem
        //TodoTableViewControllerにselectedItemの値を渡す
        v4.selectedItemForToDoTableView = selectedItem
        
        
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
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Audio", image: imageView2.image, selectedImage: imageView2.image)
        
        //RecordButtonをイニシャライズ
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: "Record", image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "ToDo", image: imageView4.image, selectedImage: imageView4.image)
        v5?.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "Setting", image: imageView5.image, selectedImage: imageView5.image)
        
        tabBarController.viewControllers = ([v1, v2, v3, v4, v5] as! [UIViewController])
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        
        self.navigationItem.title = navigationTitle
        
    }


//
//    func loadAudioFiles(with request: NSFetchRequest<AudioFile> = AudioFile.fetchRequest(), predicate : NSPredicate? = nil) {
//
//        let itemPredicate = NSPredicate(format: "parentItem.title MATCHES %@", selectedItem!.title!)
//
//        if let addtionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate, addtionalPredicate])
//        } else {
//            request.predicate = itemPredicate
//        }
//
//        do {
//            audioFileArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from audiofile context \(error)")
//        }
//    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
