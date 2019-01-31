//
//  APIService.swift
//  Rakusale-iOS
//
//  Created by 戸澤涼 on 2018/12/02.
//  Copyright © 2018 Ryo.Tozawa. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class APIService {
    
    func getShopsResponse() -> Observable<DataResponse<Any>> {
        return Observable.create { observer in
            var request = URLRequest(url: URL(string: SHOP_REST)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 5.0
            Alamofire.request(request)
                .responseJSON { response in
                    observer.onNext(response)
                    observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
