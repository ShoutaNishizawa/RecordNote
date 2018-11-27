//
//  TestFontViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/11/26.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import FontAwesome_swift

class TestFontViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        label.font = UIFont.fontAwesome(ofSize: 30, style: .regular)
        label.text = String.fontAwesomeIcon(name: .stickyNote)
        
        imageView.image = UIImage.fontAwesomeIcon(name: .github, style: .brands, textColor: .blue, size: CGSize(width: 2000.0, height: 2000.0))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
