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

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UITabBarControllerDelegate {
    
    var navigationTitle : String?
    
    var selectedItem : Item? {
        didSet{
            loadAudioFiles()
        }
    }
    //selectedItemが参照された時のみloadAudioFilesが呼び出される
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("selectedItemに値何か入っている？\(selectedItem?.title)")
        //loadAudioFiles()
        
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
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.record()
            }
        }
        
        let v1 = storyboard?.instantiateViewController(withIdentifier: "textVC")
        let v2 = storyboard?.instantiateViewController(withIdentifier: "audioVC") as! AudioViewController
        let v3 = ExampleViewController()
        let v4 = storyboard?.instantiateViewController(withIdentifier: "todoVC") as! ToDoTableViewController
        let v5 = storyboard?.instantiateViewController(withIdentifier: "settingVC")
        
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
    
    var audioRecorder : AVAudioRecorder!
    var isRecording : Bool = false
    
    var audioFileArray = [AudioFile]()
    var url : URL?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    //オーディオ関係の処理
    func record() {
        
        if !isRecording {
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            isRecording = true
            
            //            label.text = "録音中"
            //            recordButton.setTitle("STOP", for: .normal)
            //            playButton.isEnabled = false
            
        }else{
            
            audioRecorder.stop()
            isRecording = false
            loadAudioFiles()
            print("audioFile was saved to context!")
            //            label.text = "待機中"
            //            recordButton.setTitle("RECORD", for: .normal)
            //            playButton.isEnabled = true
            
        }
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        //現在時刻をString型で取得
        var now: String = "\(NSDate())"
        //AudioFileのインスタンスを作成する。
        let newAudioFile = AudioFile(context: self.context)
        //作成したインスタンスのfilePathに現在時刻を代入
        newAudioFile.filePath = now
        //選択されたセルのitemArray[indexPath.row]をparentItemとして関連付ける
        newAudioFile.parentItem = selectedItem
        //グローバル変数のurlのファイルパスとしてaudioFileArrayのfilePathから参照
        url = docsDirect.appendingPathComponent(newAudioFile.filePath!)
        newAudioFile.url = url
        //filePathに現在時刻が入っているインスタンスと固有urlを元のaudioFileArrayに追加
        audioFileArray.append(newAudioFile)
        print("audioのselectedItemは？\(newAudioFile.parentItem?.title)")
        //contextの変更内容を保存
        saveAudioFile()
        return url!
    }
    
    func saveAudioFile() {
        do {
            try context.save()
            print("AudioFile was correctly saved!")
            
        } catch {
            print("Error saving audiofile context, \(error)")
        }
    }
    
    func loadAudioFiles(with request: NSFetchRequest<AudioFile> = AudioFile.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let itemPredicate = NSPredicate(format: "parentItem.title MATCHES %@", selectedItem!.title!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate, addtionalPredicate])
        } else {
            request.predicate = itemPredicate
        }
        
        do {
            audioFileArray = try context.fetch(request)
        } catch {
            print("Error fetching data from audiofile context \(error)")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
