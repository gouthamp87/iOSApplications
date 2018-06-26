//
//  Questions.swift
//  QuiZApp
//
//  Created by Goutham on 6/16/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

class Questions {
    let question:String
    let answer:Bool
    init(text: String, correctAnswer: Bool){
        question = text
        answer = correctAnswer
    }
}
