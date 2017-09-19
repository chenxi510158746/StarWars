//
//  PlaySoundEffect.swift
//  StarWars
//
//  Created by chenxi on 2017/9/17.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import AVFoundation

enum SoundEffects: String {
    case explosion = "explosion"
    case collision = "collision"
    case torpedo = "torpedo"
}

func playSound(of effect: SoundEffects) {
    OperationQueue.main.addOperation {
        let  player : AVAudioPlayer!
    
        if let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3", subdirectory: "resource") {

            player = try? AVAudioPlayer(contentsOf: url)

            player.play()

        }
        
    }
}
