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
    
    var songs = [SongInfo]()
    var songPaths = Bundle.main.paths(forResourcesOfType: "pdf", inDirectory: "Songs")
    var selectedRow = 0
    
    override func viewDidLoad() {
        let user = Auth.auth().currentUser!.uid
        print("Home user id is: \(user)")
        
        songPaths.sort()
        for song in songPaths {
            let url = URL(fileURLWithPath: song)
            var name = url.lastPathComponent
            name = stripFileExtension(name)
            songs.append(SongInfo(name, false))
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(songs.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as UITableViewCell
        let cell = UITableViewCell(style: .default, reuseIdentifier: "songCell")
        cell.textLabel?.text = songs[(indexPath.row)].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showSong", sender: indexPath.row)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSong" {
            let destVC = segue.destination as? SongViewController
            destVC?.songPath = songPaths[selectedRow]
            destVC?.songTitle = songs[selectedRow].title
            
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
