//
//  TextViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/12/06.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {

    
    @IBOutlet weak var myLabel: UILabel!
    
    var labelText: String = "初期"
    override func viewDidLoad() {
        super.viewDidLoad()

        myLabel.text = labelText
    }
    ////
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
