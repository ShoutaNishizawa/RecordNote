//
//  RecordPlay.swift
//  RecordNote
//
//  Created by coco j on 2018/12/09.
//  Copyright © 2018 coco j. All rights reserved.
//
//import UIKit
//import Foundation
//import AVFoundation
//import CoreData
//
//class RecordPlay:NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
//
//    var audioFileArray = [AudioFile]()
//    var audioRecorder : AVAudioRecorder!
//    var audioPlayer : AVAudioPlayer!
//    var isRecording : Bool = false
//    var isPlaying : Bool = false
//
//    var currentRow : Int = 0
//
//    var url : URL?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    var selectedItem : Item? {
//        didSet{
//            loadAudioFiles()
//        }
//    }
//
//    func record() {
//
//        if !isRecording {
//
//            let session = AVAudioSession.sharedInstance()
//            try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
//            try! session.setActive(true)
//
//            let settings = [
//                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//                AVSampleRateKey: 44100,
//                AVNumberOfChannelsKey: 2,
//                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//            ]
//
//            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
//            audioRecorder.delegate = self
//            audioRecorder.record()
//
//            isRecording = true
//
////            label.text = "録音中"
////            recordButton.setTitle("STOP", for: .normal)
////            playButton.isEnabled = false
//
//        }else{
//
//            audioRecorder.stop()
//            isRecording = false
//            print("audioFile was saved to context!")
////            label.text = "待機中"
////            recordButton.setTitle("RECORD", for: .normal)
////            playButton.isEnabled = true
//
//        }
//    }
//
//    func getURL() -> URL{
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let docsDirect = paths[0]
//        //現在時刻をString型で取得
//        var now: String = "\(NSDate())"
//        //AudioFileのインスタンスを作成する。
//        let newAudioFile = AudioFile(context: self.context)
//        //作成したインスタンスのfilePathに現在時刻を代入
//        newAudioFile.filePath = now
//        newAudioFile.parentItem = selectedItem
//        //グローバル変数のurlのファイルパスとしてaudioFileArrayのfilePathから参照
//        url = docsDirect.appendingPathComponent(newAudioFile.filePath!)
//        newAudioFile.url = url
//        //filePathに現在時刻が入っているインスタンスと固有urlを元のaudioFileArrayに追加
//        audioFileArray.append(newAudioFile)
//        currentRow += 1
//        //contextの変更内容を保存
//        saveAudioFile()
//        return url!
//    }
//
//    func saveAudioFile() {
//        do {
//            try context.save()
//            print("AudioFile was correctly saved!")
//        } catch {
//            print("Error saving audiofile context, \(error)")
//        }
//    }
//
//    func loadAudioFiles() {
//
//        let request : NSFetchRequest<AudioFile> = AudioFile.fetchRequest()
//        do {
//            audioFileArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from audiofile context \(error)")
//        }
//    }
//
//    static let sharedInstance:RecordPlay = RecordPlay()
//    private override init() {}
//}
