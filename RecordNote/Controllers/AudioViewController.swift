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

class AudioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playButton: UIButton!

    var audioPlayer : AVAudioPlayer!
    var isPlaying : Bool = false
    
    var selectedItemForAudioView : Item? {
        didSet{
            loadAudioFiles()
        }
    }
    
    @IBOutlet weak var audioTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let singleton = ViewController()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singleton.audioFileArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath)

        cell.textLabel?.text = singleton.audioFileArray[indexPath.row].filePath

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if !isPlaying {

            audioPlayer = try! AVAudioPlayer(contentsOf: singleton.audioFileArray[indexPath.row].url!)
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
        
        print("print audiofileArray parentItem : \(singleton.audioFileArray[indexPath.row].parentItem)")
    }

    @IBAction func play(_ sender: UIButton) {
        audioPlayer.stop()
        isPlaying = false

        label.text = "待機中"
        playButton.setTitle("PLAY", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudioFiles()
        print("シングルトンは？\(singleton.selectedItem?.title)")
        print("selectedItemForAudioVIewは？：\(selectedItemForAudioView?.loadPath)")
        
    }
    
   
        func loadAudioFiles(with request: NSFetchRequest<AudioFile> = AudioFile.fetchRequest(), predicate : NSPredicate? = nil) {

            let itemPredicate = NSPredicate(format: "parentItem.loadPath MATCHES %@", selectedItemForAudioView!.loadPath!)

            if let addtionalPredicate = predicate {
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [itemPredicate, addtionalPredicate])
            } else {
                request.predicate = itemPredicate
            }

            do {
                singleton.audioFileArray = try context.fetch(request)
            } catch {
                print("Error fetching data from audiofile context \(error)")
            }
        }

}
