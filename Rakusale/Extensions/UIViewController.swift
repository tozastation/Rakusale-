//
//  UIViewController.swift
//  Rakusale-iOS
//
//  Created by 赤間 悠大 on 2018/10/17.
//  Copyright © 2018年 Ryo.Tozawa. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    static func create() -> Self {
        let name: String = "\(type(of: self))".components(separatedBy: ".").first!
        return instantiate(storyboardName: name)
    }
    
    private static func instantiate<T>(storyboardName: String) -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc: UIViewController? = storyboard.instantiateInitialViewController()
        return vc as!T // swiftlint:disable:this force_cast
    }
    
}
