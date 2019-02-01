//
//  Error.swift
//  Rakusale
//
//  Created by 戸澤涼 on 2019/02/01.
//  Copyright © 2019 Ryo.Tozawa. All rights reserved.
//

import Foundation

enum gRPCError: LocalizedError {
    case RequestError(Int64)
}
