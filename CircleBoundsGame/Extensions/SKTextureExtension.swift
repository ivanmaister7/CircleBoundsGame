//
//  SkTextureExtension.swift
//  CircleBoundsGame
//
//  Created by ivan on 16.10.2024.
//

import SpriteKit

extension SKTexture {
    convenience init(startColor: UIColor, endColor: UIColor, size: CGSize) {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        
        let colors = [startColor.cgColor, endColor.cgColor] as CFArray
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        
        context?.drawLinearGradient(gradient, start: CGPoint.zero, end: CGPoint(x: 0, y: size.height), options: [])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.init(image: image)
    }
}
