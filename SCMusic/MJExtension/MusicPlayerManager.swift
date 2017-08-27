//
//  MusicPlayerManager.swift
//  SC Player
//
//  Created by 凌       陈 on 7/3/17.
//  Copyright © 2017 凌       陈. All rights reserved.
//

import UIKit
import AVFoundation


class MusicPlayerManager: NSObject {
    
    // 播放相关
    var play : AVPlayer?
    var playItem: AVPlayerItem?
    
    dynamic var finishPlaySongIndex = 0
    dynamic var isMusicListSelected = false
    
    var playSongIndexTemp = 0
    
    static let sharedInstance: MusicPlayerManager = {
        let shared = MusicPlayerManager()
        
        return shared
    }()
    
    override init() {
        super.init()
    }
    
    
    func setPlayItem(songURL: String) {
        let unsafeP = songURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet(charactersIn:"`#%^{}\"[]|\\<> ").inverted)!
        let url = URL(string: unsafeP)!
        playItem = AVPlayerItem(url: url)
    }
    
    func setPlay() {
        play = AVPlayer(playerItem: playItem)
    }
    
    func startPlay() {
        play?.play()
    }
    
    func stopPlay() {
        play?.pause()
    }
    
    /// 定位到某个时间
    func seekToTime(time : TimeInterval)  {
//        play?.currentTime = time
    }
    
    func getPlayerRate() -> Float {
        return (play?.rate)!
    }
    
    func setPlayFinishNotification() {
        // 播放结束通知
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: play?.currentItem)
    }
    
    
    func finishedPlaying() {
        print("播放完毕!")
        finishPlaySongIndex = finishPlaySongIndex + 1
    }
}
