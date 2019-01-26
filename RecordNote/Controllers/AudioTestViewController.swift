//
//  AudioTestViewController.swift
//  RecordNote
//
//  Created by coco j on 2019/01/26.
//  Copyright © 2019 coco j. All rights reserved.
//


import UIKit
import AVFoundation
import CoreData


class AudioTestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    
    var topSafeAreaHeight: CGFloat = 0
    var bottomSafeAreaHeight: CGFloat = 0
    //青のviewを作成
    let BlueView = UIView()
    
    var audioPlayer : AVAudioPlayer!
    var isPlaying : Bool = false
    var audioRecorder : AVAudioRecorder!
    var isRecording : Bool = false
    
    var audioFileArray = [AudioFile]()
    var url : URL?
    
    var selectedItemForAudioView : Item? {
        didSet{
            loadAudioFilesFromItemVC()
            makeTableView()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            
            // viewDidLayoutSubviewsではSafeAreaの取得ができている
            topSafeAreaHeight = self.view.safeAreaInsets.top
            bottomSafeAreaHeight = self.view.safeAreaInsets.bottom
            
            let bgColor = UIColor.blue
            BlueView.backgroundColor = bgColor
            
            BlueView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            BlueView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            self.view.addSubview(BlueView)
            self.BlueView.frame = CGRect.init(x: 0, y: topSafeAreaHeight, width: self.view.bounds.width, height: 55)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "AudioCell")
        
        cell.textLabel?.text = audioFileArray[indexPath.row].filePath
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isPlaying {
            
            audioPlayer = try! AVAudioPlayer(contentsOf: audioFileArray[indexPath.row].url!)
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true
            
            
        }else{
            
            audioPlayer.stop()
            isPlaying = false
        }
    }
    
    func makeTableView() {
        
        var audioTableView: UITableView!
        audioTableView = {
            let tableView = UITableView(frame: CGRect.init(x: 0, y: 150, width: self.view.bounds.width, height: (self.view.bounds.height - BlueView.bounds.height)), style: .plain)
            tableView.autoresizingMask = [
                .flexibleWidth,
                .flexibleHeight
            ]
            
            tableView.delegate = self
            tableView.dataSource = self
            
            self.view.addSubview(tableView)
            print("made audio table view")
            return tableView
        }()
        loadAudioFilesFromItemVC()
        
        audioTableView.reloadData()
        print("audio table view reloaded!")
    }
    
    
    //オーディオ関係の処理
    func record(selectedItemPath : Item) {
        print("Record button was tapped!")
        
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
            
            
        } else {
            
            audioRecorder.stop()
            print("audioRecorder was stoped!")
            isRecording = false
            saveAudioFile()
            makeTableView()
            
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
            
        } catch {
            print("Error saving audiofile context, \(error)")
        }
        
    }
    
    func loadAudioFilesInAudioVC(with request: NSFetchRequest<AudioFile> = AudioFile.fetchRequest()) {
        
        do {
            audioFileArray = try context.fetch(request)
            print("audio file was loaded !")
            
        } catch {
            print("Error fetching data from audiofile context \(error)")
        }
    }
    
    
    func loadAudioFilesFromItemVC(with request: NSFetchRequest<AudioFile> = AudioFile.fetchRequest(), predicate : NSPredicate? = nil) {
        
        print("selectedItemForAudioViewは？ : \(selectedItemForAudioView)")
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
