//
//  SongListVC.swift
//  TikTokSample
//
//  Created by Prabhat on 02/07/20.
//  Copyright © 2020 unwrapsolutions. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

protocol PassVideoProtocall {
    func passVal(url: URL)
    
}


class SongListVC: UIViewController {
    
    var videoAsset: AVURLAsset?
    var audioAsset: AVURLAsset?

    
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
        self.mergeAndSave(url: index)
    }
    
    
    func mergeAndSave(url: URL) {
        let mixComposition = AVMutableComposition()

        //Now first load your audio file using AVURLAsset. Make sure you give the correct path of your videos.
        let audio_url = url
        audioAsset = AVURLAsset(url: audio_url, options: nil)
        let audio_timeRange: CMTimeRange = CMTimeRangeMake(start: .zero, duration: audioAsset!.duration)
        
        //Now we are creating the first AVMutableCompositionTrack containing our audio and add it to our AVMutableComposition object.
        let b_compositionAudioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        do {
            try b_compositionAudioTrack?.insertTimeRange(audio_timeRange, of: audioAsset!.tracks(withMediaType: .audio)[0], at: .zero)
        } catch {
        }
        
        //Now we will load video file.
        
        
        let video_url = URL(fileURLWithPath: Bundle.main.path(forResource: "Asteroid_Video", ofType: "m4v") ?? "")
        videoAsset = AVURLAsset(url: video_url, options: nil)
        let video_timeRange: CMTimeRange = CMTimeRangeMake(start: .zero, duration: audioAsset!.duration)

        
        //Now we are creating the second AVMutableCompositionTrack containing our video and add it to our AVMutableComposition object.
        let a_compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        do {
            try a_compositionVideoTrack?.insertTimeRange(video_timeRange, of: videoAsset!.tracks(withMediaType: .video)[0], at: .zero)
        } catch {
        }

        //decide the path where you want to store the final video created with audio and video merge.
        let dirPaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
        let docsDir = dirPaths[0]
        let outputFilePath = URL(fileURLWithPath: docsDir).appendingPathComponent("FinalVideo.mov").absoluteString
        let outputFileUrl = URL(fileURLWithPath: outputFilePath)
        if FileManager.default.fileExists(atPath: outputFilePath) {
            do {
                try FileManager.default.removeItem(atPath: outputFilePath)
            } catch {
            }
        }

        
        //Now create an AVAssetExportSession object that will save your final video at specified path.
        let _assetExport = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        _assetExport?.outputFileType = AVFileType("com.apple.quicktime-movie")
        _assetExport?.outputURL = outputFileUrl

        
        _assetExport?.exportAsynchronously(
            completionHandler: {
                DispatchQueue.main.async(execute: {
                    self.exportDidFinish(_assetExport)
                })
            })


    }
    
    
    func exportDidFinish(_ session: AVAssetExportSession?) {

        if session?.status == .completed {
            let outputURL = session?.outputURL

            let library = ALAssetsLibrary()
            
            
            if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: outputURL) {

                library.writeVideoAtPath(
                    toSavedPhotosAlbum: outputURL,
                    completionBlock: { assetURL, error in
                        
                        DispatchQueue.main.async(execute: {
                            if error != nil {
                            } else {
                                self.loadMoviePlayer(outputURL)
                            }
                        })
                    })
            }

        }
        
        LoadingView.unlockView()

    }

    
    func loadMoviePlayer(_ moviePath: URL?) {

        if let moviePath = moviePath {
            print("\(moviePath)")
            
            self.delegate?.passVal(url: moviePath)
            
            self.dismiss(animated: true, completion: nil)

            
        }
    }

    
    
}
