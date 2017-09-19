//
//  Masks.swift
//  StarWars
//
//  Created by chenxi on 2017/9/17.
//  Copyright © 2017年 chenxi. All rights reserved.
//

struct Masks: OptionSet {
    let rawValue: Int
    
    static let ship   = Masks(rawValue: 1 << 0)
    static let bullet = Masks(rawValue: 1 << 0)
}
