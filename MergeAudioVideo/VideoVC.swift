//
//  VideoVC.swift
//  TikTokSample
//
//  Created by Prabhat on 02/07/20.
//  Copyright © 2020 unwrapsolutions. All rights reserved.
//

import UIKit



class VideoVC: UIViewController {
    
    @IBOutlet var videoview: AGVideoPlayerView!
    
    var videoURL: URL?
    
    
    @IBOutlet weak var undoBtn: UIButton!
    
    @IBOutlet weak var doneNtn: UIButton!
    @IBOutlet weak var selectAudioBTn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        undoBtn.isHidden = true
        
        if let url = videoURL {
            videoview.videoUrl = url
            // videoview.previewImageUrl = image
            videoview.shouldAutoplay = true
            videoview.shouldAutoRepeat = false
            videoview.showsCustomControls = false
            videoview.shouldSwitchToFullscreen = false
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        selectAudioBTn.isHidden = true
        undoBtn.isHidden = true
        doneNtn.setTitle("Post", for: .normal)
        
         
    }
    
    @IBAction func selectAudioBtnAction(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(identifier: "SongListVC_Id") as! SongListVC
        vc.videoURL = videoURL
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    @IBAction func undo(_ sender: UIButton) {
        
        if let url = videoURL {
            videoview.videoUrl = url
            // videoview.previewImageUrl = image
            videoview.shouldAutoplay = true
            videoview.shouldAutoRepeat = false
            videoview.showsCustomControls = false
            videoview.shouldSwitchToFullscreen = false
            undoBtn.isHidden = true
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension VideoVC: PassVideoProtocall {
    
    
    func passVal(url: URL) {
        
        undoBtn.isHidden = false
        videoview.videoUrl = url
        // videoview.previewImageUrl = image
        videoview.shouldAutoplay = true
        videoview.shouldAutoRepeat = false
        videoview.showsCustomControls = false
        videoview.shouldSwitchToFullscreen = false
    }
    
    
}




