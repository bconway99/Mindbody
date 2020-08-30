//
//  RequestHelper.swift
//  Mindbody
//
//  Created by Ben Conway on 8/29/20.
//  Copyright © 2020 Ben Conway. All rights reserved.
//

import Foundation
import Alamofire
import Handy

class RequestHelper: NSObject {

    typealias CompletionHandler = (_ success: Bool, _ json: Any?, _ error: RequestError?) -> Void

    /// Checks if the device has a network connection and then passes on the request to the appropriate HTTP method.
    /// - Parameters:
    ///   - request: The network request object.
    ///   - completion: The completion block to return to the delegate class.
    static func addRequest(request: Request, completion: @escaping CompletionHandler) {
        guard HandyNetworking.isConnected() else {
            // These strings would usually be added to a separate strings class.
            // So that we can localize languages far more easily.
            let error = RequestError(title: "Error", message: "No internet connection!")
            completion(false, nil, error)
            return
        }

        guard let type = request.type, request.url != nil else {
            // These strings would usually be added to a separate strings class.
            // So that we can localize languages far more easily.
            let error = RequestError(title: "Error", message: "Invalid request!")
            completion(false, nil, error)
            return
        }
        
        switch type {
            
        case .get:
            return get(with: request, completion: completion)
            
        case .post:
            return post(with: request, completion: completion)
        }
    }
    
    /// Parses the JSON response.
    /// - Parameters:
    ///   - response: The JSON response from the network request.
    ///   - completion: The completion block to return to the delegate class.
    static func parseResponse(with response: AFDataResponse<Any>, completion: @escaping CompletionHandler) {
        switch response.result {
            
        case .success(_):
            if let json = response.value {
                completion(true, json, nil)
            } else {
                completion(false, nil, RequestError(title: "Error", message: "Failed request!"))
            }
            
        case .failure(_):
            completion(false, nil, RequestError(title: "Error", message: "Failed request!"))
        }
    }
}

// MARK: - Get

extension RequestHelper {
    
    /// Creates a GET request
    /// - Parameters:
    ///   - request: The network request object.
    ///   - completion: The completion block to return to the delegate class.
    static func get(with request: Request, completion: @escaping CompletionHandler) {
        let request = AF.request(request.url ?? "", method: .get, parameters: request.parameters)
        request.responseJSON { (response: AFDataResponse<Any>) in
            return parseResponse(with: response, completion: completion)
        }
    }
}

// MARK: - Post

extension RequestHelper {
    
    /// Creates a POST request
    /// - Parameters:
    ///   - request: The network request object.
    ///   - completion: The completion block to return to the delegate class.
    static func post(with request: Request, completion: @escaping CompletionHandler) {
        let request = AF.request(request.url ?? "", method: .post, parameters: request.parameters)
        request.responseJSON { (response: AFDataResponse<Any>) in
            return parseResponse(with: response, completion: completion)
        }
    }
}
