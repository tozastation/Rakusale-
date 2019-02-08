//
//  LogService.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/08.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation
import SwiftyBeaver

class LogService: UIResponder{
    static var shared = LogService()
    let logger = SwiftyBeaver.self
    let console = ConsoleDestination()
    
    private override init() {
        self.logger.addDestination(console)
    }
}
