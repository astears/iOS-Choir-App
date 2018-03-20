//
//  HomeController.swift
//  Crescendo_iOS
//
//  Created by Andrew Stears on 3/6/18.
//  Copyright © 2018 Andrew Stears. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var songs = [String]()
    var songPaths = Bundle.main.paths(forResourcesOfType: "pdf", inDirectory: "Songs")
    var selectedRow = 0
    
    override func viewDidLoad() {
        print("in Home Controller!")
        
        songPaths.sort()
        for song in songPaths {
            let url = URL(fileURLWithPath: song)
            var name = url.lastPathComponent
            name = stripFileExtension(name)
            songs.append(name)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(songs.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: .default, reuseIdentifier: "songCell")
        cell.textLabel?.text = songs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showSong", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" {
            let destVC = segue.destination as? SongViewController
            destVC?.songPath = songPaths[selectedRow]
            
        }
    }
    
    func stripFileExtension ( _ filename: String ) -> String {
        var components = filename.components(separatedBy: ".")
        guard components.count > 1 else { return filename }
        components.removeLast()
        return components.joined(separator: ".")
    }
    
    @IBAction func handleSignout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch let LogoutError {
            print(LogoutError.localizedDescription)
        }
    }
}
