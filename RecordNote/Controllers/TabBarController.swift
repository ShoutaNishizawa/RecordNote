//
//  TabBarController.swift
//  RecordNote
//
//  Created by coco j on 2019/01/27.
//  Copyright © 2019 coco j. All rights reserved.
//

import UIKit
import FontAwesome_swift

class TabBarController: UITabBarController {
    
    var selectedItem : Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textVC = self.viewControllers![0] as? TextViewController
        textVC?.labelText = (selectedItem?.title)!
        
        let audioVC = self.viewControllers![1] as? AudioTestViewController
        audioVC?.selectedItemForAudioView = selectedItem
        
        let todoVC = self.viewControllers![2] as? ToDoTableViewController
        todoVC?.selectedItemForToDoTableView = selectedItem
        
    }
}
