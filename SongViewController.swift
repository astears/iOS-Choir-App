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

class SongViewController: UIViewController {
    
    @IBOutlet weak var songView: WKWebView!
    var midiPlayer : AVMIDIPlayer = AVMIDIPlayer()
    
    var songPath : String?
    var audioFileExists = true
    
    override func viewDidLoad() {
    
        if let path = songPath {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url)
            songView.load(request)
        }
        else {
            print("file not found")
        }
        
        if audioFileExists {
            setupMidiPlayer()
        }
        
    }
    
    
    @IBAction func handlePlay(_ sender: Any) {
        if midiPlayer.isPlaying == false {
            midiPlayer.play()
            
        }
        
    }
    @IBAction func handlePause(_ sender: Any) {
        if midiPlayer.isPlaying {
            midiPlayer.stop()
        }
        
        
    }
    @IBAction func handleStop(_ sender: Any) {
        if midiPlayer.isPlaying {
            midiPlayer.stop()
            midiPlayer.currentPosition = 0
            
        }
        
    }
    
    func setupMidiPlayer() {
        
        guard let midiFileURL = Bundle.main.path(forResource: "The King is Coming MIDI", ofType: "mid", inDirectory: "Audio") else {
            fatalError("\"The King is Coming.mid\" file not found.")
        }
        
        guard let bankURL = Bundle.main.path(forResource: "gs_instruments", ofType: "dls", inDirectory: "Audio") else {
            fatalError("\"gs_instruments.dls\" file not found.")
        }
        
        do {
            
            try self.midiPlayer = AVMIDIPlayer(contentsOf: URL(fileURLWithPath: midiFileURL), soundBankURL: URL(fileURLWithPath: bankURL))
            print("created midi player with sound bank url \(bankURL)")
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        self.midiPlayer.prepareToPlay()
        
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
