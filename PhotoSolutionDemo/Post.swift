//
//  Post.swift
//  PhotoSolutionDemo
//
//  Created by MA XINGCHEN on 20/2/19.
//  Copyright © 2019 mark. All rights reserved.
//

import Foundation

class Post: Decodable{
    
    struct Photo: Decodable{
        var compressed: String
        var original: String
    }
    
    var userID: Int
    var postID: Int
    var time: String
    var description: String
    var photos: [Photo]
    
}
