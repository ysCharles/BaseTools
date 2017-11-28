//
//  ImageResource.swift
//  BaseTools
//
//  Created by Charles on 28/11/2017.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit

protocol ImageResourceProtocol {
    var image : UIImage? { get }
    var imageURLString : String? { get }
}

public struct ImageResource : ImageResourceProtocol {
    var image: UIImage?
    var imageURLString: String?
    
    public init(image: UIImage?, imageURLString: String?) {
        self.image = image
        self.imageURLString = imageURLString
    }
}
