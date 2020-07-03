//
//  SongListVC.swift
//  TikTokSample
//
//  Created by Prabhat on 02/07/20.
//  Copyright © 2020 unwrapsolutions. All rights reserved.
//

import UIKit
import AVKit

protocol PassVideoProtocall {
    func passVal(url: URL)
    
}


class SongListVC: UIViewController {
    
    var videoURL: URL?

    var dataSource:[URL] = []
    var dataSource1:[String] = ["1", "2", "3", "4", "5"]
    
    var delegate:PassVideoProtocall?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let url1 = Bundle.main.url(forResource: "Linkin_Park", withExtension: "mp3")
        let url2 = Bundle.main.url(forResource: "iThink", withExtension: "mp3")
        let url3 = Bundle.main.url(forResource: "urban", withExtension: "mp3")
        let url4 = Bundle.main.url(forResource: "audio3", withExtension: "mp3")
        let url5 = Bundle.main.url(forResource: "audio4", withExtension: "mp3")

        dataSource.append(url1!)
        dataSource.append(url2!)
        dataSource.append(url3!)
        dataSource.append(url4!)
        dataSource.append(url5!)
    
    }

}

extension SongListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongItemCell", for: indexPath) as! SongItemCell
        
        cell.lbl.text = dataSource1[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = dataSource[indexPath.row]
        
        LoadingView.lockView()
        
        
        self.delegate?.passVal(url: URL(string: "")!)
        
        self.dismiss(animated: true, completion: nil)

        
    }
    
    
}
