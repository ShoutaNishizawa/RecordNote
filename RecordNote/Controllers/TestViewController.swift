//
//  TestViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/12/26.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialCollections

class TestViewController: MDCCollectionViewController {
    
    let components = ["ActivityIndicator", "AnimationTiming", "AppBar", "ButtonBar", "Buttons", "CollectionCells", "CollectionLayoutAttributes", "Collections", "Dialogs", "FeatureHighlight", "FlexibleHeader", "HeaderStackView", "Ink"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styler.cellStyle = .card
//
//        // ViewControllerの背景色
//        self.view.backgroundColor = UIColor.init(
//            red:0.71, green: 1.0, blue: 0.95, alpha: 1)
//
//        // スクリーンの横縦幅
//        let screenWidth:CGFloat = self.view.frame.width
//        let screenHeight:CGFloat = self.view.frame.height
//
//
//        // ボタンのインスタンス生成
//        let button = UIButton()
//        // ボタンの位置とサイズを設定
//        button.frame = CGRect(x:screenWidth/1.4, y:screenHeight/2,
//                              width:60, height:60)
//
//        let image = UIImage(named: "todoAddButton")
//
//        button.setImage(image, for: .normal)
//        button.layer.cornerRadius = 30
//        // タップされたときのaction
//        button.addTarget(self,
//                         action: #selector(buttonTapped(sender:)),
//                         for: .touchUpInside)
//
//        // Viewにボタンを追加
//        self.view.addSubview(button)
//    }
//
//    @objc func buttonTapped(sender : AnyObject) {
//
//    }
}
}

extension TestViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return components.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MDCCollectionViewTextCell
        cell.textLabel?.text = components[indexPath.item]
        return cell
    }
}
