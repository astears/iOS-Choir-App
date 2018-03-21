//
//  SongViewController.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/10/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import WebKit
import Firebase

class SongViewController: UIViewController {
    
    @IBOutlet weak var songView: WKWebView!
    @IBOutlet weak var playAudioToolbar: UIToolbar!
    var midiPlayer : AVMIDIPlayer = AVMIDIPlayer()
    
    var songPath : String?
    var audioFileExists = false
    var songTitle : String?
    
    override func viewDidLoad() {
        
        if let path = songPath {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url)
            songView.load(request)
        }
        else {
            print("file not found")
        }
        setupMidiPlayer()
    }
    
    
    @IBAction func handlePlay(_ sender: Any) {
        
        if audioFileExists && midiPlayer.isPlaying == false {
            midiPlayer.play()
            
        }
        
    }
    @IBAction func handlePause(_ sender: Any) {
        if audioFileExists && midiPlayer.isPlaying {
            midiPlayer.stop()
        }
        
        
    }
    @IBAction func handleStop(_ sender: Any) {
        if audioFileExists && midiPlayer.isPlaying {
            midiPlayer.stop()
            midiPlayer.currentPosition = 0
            
        }
        
    }
    
    func setupMidiPlayer() {
        
        let audioFile = songTitle! + " MIDI.mid"
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: "gs://crescendo-59263.appspot.com/").child("audio/\(audioFile)")
        
        guard let bankURL = Bundle.main.path(forResource: "gs_instruments", ofType: "dls", inDirectory: "Audio") else {
            fatalError("\"gs_instruments.dls\" file not found.")
        }
        
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
                self.playAudioToolbar.isHidden = true
                //self.alertFileNotFound(audioFile)
                
            } else {
                // Data for "audio/Mount of Olives MIDI" is returned
                do {
                    if (data != nil) {
                        try self.midiPlayer = AVMIDIPlayer(data: data!, soundBankURL: URL(fileURLWithPath: bankURL))
                        self.audioFileExists = true
                        print("created midi player with sound bank url \(bankURL)")
                    }
            
                } catch let error as NSError {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func alertFileNotFound(_ fileName : String) {
        let alert = UIAlertController(title: "Sorry!", message: "There is no audio file for \(fileName)", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button OK")
        }
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion:nil)
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
