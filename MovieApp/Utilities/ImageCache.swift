//
//  ImageCache.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import UIKit

class ImageCache {
    var cache: NSCache<NSString, UIImage> {
        let imgCache = NSCache<NSString, UIImage>()
        imgCache.totalCostLimit = 30
        imgCache.countLimit = 30
        return imgCache
    }
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey), cost: 1)
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
