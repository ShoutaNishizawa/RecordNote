//
//  AudioViewController.swift
//  RecordNote
//
//  Created by coco j on 2018/12/06.
//  Copyright © 2018 coco j. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

//protocol AudioViewControllerDelegate {
//    func record(selectedItemPath : Item)
//}

class AudioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBOutlet weak var audioTableView: UITableView!
    
    
    var audioPlayer : AVAudioPlayer!
    var isPlaying : Bool = false
    var audioRecorder : AVAudioRecorder!
    var isRecording : Bool = false
    
    var audioFileArray = [AudioFile]()
    var url : URL?
    
    var selectedItemForAudioView : Item? {
        didSet{
            loadAudioFiles()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath)
        
        cell.textLabel?.text = audioFileArray[indexPath.row].filePath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isPlaying {
            
            audioPlayer = try! AVAudioPlayer(contentsOf: audioFileArray[indexPath.row].url!)
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true
            
            label.text = "再生中"
            playButton.setTitle("STOP", for: .normal)
            //recordButton.isEnabled = false
            
        }else{
            
            audioPlayer.stop()
            isPlaying = false
            
            label.text = "待機中"
            playButton.setTitle("PLAY", for: .normal)
            //recordButton.isEnabled = true
            
        }
        
    }
    
    @IBAction func play(_ sender: UIButton) {
        audioPlayer.stop()
        isPlaying = false
        
        label.text = "待機中"
        playButton.setTitle("PLAY", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("ファイルパス　：\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        //print("\(tableView)")
    }
    
    //オーディオ関係の処理
    
    func record(selectedItemPath : Item) {
        print("RRRRRRRRRRR")
        
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
            
            audioRecorder = try! AVAudioRecorder(url: getURL(parentItemPath: selectedItemPath), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            isRecording = true
            
            //            label.text = "録音中"
            //            recordButton.setTitle("STOP", for: .normal)
            //            playButton.isEnabled = false
            
        } else {
            
            audioRecorder.stop()
            isRecording = false
            saveAudioFile()
            print("audioRecorder was stoped!")
            //            label.text = "待機中"
            //            recordButton.setTitle("RECORD", for: .normal)
            //            playButton.isEnabled = true
            
        }
    }
    
    func getURL(parentItemPath: Item) -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        //現在時刻をString型で取得
        var now: String = "\(NSDate())"
        //AudioFileのインスタンスを作成する。
        let newAudioFile = AudioFile(context: self.context)
        //作成したインスタンスのfilePathに現在時刻を代入
        newAudioFile.filePath = now
        //選択されたセルのitemArray[indexPath.row]をparentItemとして関連付ける
        newAudioFile.parentItem = parentItemPath
        print("getURL内のselectedItemForAudioViewは？\(parentItemPath.title)")
        //グローバル変数のurlのファイルパスとしてaudioFileArrayのfilePathから参照
        url = docsDirect.appendingPathComponent(newAudioFile.filePath!)
        newAudioFile.url = url
        //filePathに現在時刻が入っているインスタンスと固有urlを元のaudioFileArrayに追加
        audioFileArray.append(newAudioFile)
        
        return url!
    }
    
    
    func saveAudioFile() {
        do {
            try context.save()
            print("AudioFile was correctly saved!")
            
            
            if self.audioTableView == nil {
                print("TAG nilだよ")
            } else {
                print("nilじゃないよ")
            }
            
            getTopViewController()
            //audioTableView.reloadData()
        } catch {
            print("Error saving audiofile context, \(error)")
        }
        
    }
    
    func getTopViewController() -> UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var topViewController: UIViewController = rootViewController
            
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
           topViewController = storyboard?.instantiateViewController(withIdentifier: "audioVC") as! AudioViewController
            print("\(topViewController)")
             return topViewController
        } else {
            return nil
        }
    }
    
    func loadAudioFiles(with request: NSFetchRequest<AudioFile> = AudioFile.fetchRequest(), predicate : NSPredicate? = nil) {
        
        print("selected loadpathは？ : \(selectedItemForAudioView?.loadPath)")
        let itemPredicate = NSPredicate(format: "parentItem.loadPath MATCHES %@", selectedItemForAudioView!.loadPath!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate, addtionalPredicate])
        } else {
            request.predicate = itemPredicate
        }
        
        do {
            audioFileArray = try context.fetch(request)
            print("audioFileArray was inserted")
            
        } catch {
            print("Error fetching data from audiofile context \(error)")
        }
        
    }
    
}
