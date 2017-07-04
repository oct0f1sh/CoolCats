//
//  Array+Shuffle.swift
//  CoolCats
//
//  Created by Duncan MacDonald on 7/4/17.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import Foundation

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
