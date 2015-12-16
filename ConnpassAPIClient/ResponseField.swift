//
//  ResponseField.swift
//  ConnpassAPIClient
//
//  Created by JPMartha on 2015/12/16.
//  Copyright © 2015年 JPMartha. All rights reserved.
//

import Foundation
import APIKit
import Himotoki

protocol ConnpassRequestType: RequestType {
    
}

extension ConnpassRequestType {
    var baseURL: NSURL {
        return NSURL(string: "http://connpass.com/api/v1")!
    }
}

struct GetEventSearchRequest: ConnpassRequestType {
    typealias Response = ResponseField
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return "/event"
    }
    
    var parameters: [String: AnyObject] {
        return ["keyword": "関西モバイルアプリ研究会"]
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        return try? decode(object)
    }
}

struct ResponseField: Decodable {
    let results_returned: Int
    let results_available: Int
    let results_start: Int
    let events: [Event]
    
    static func decode(e: Extractor) throws -> ResponseField {
        return try ResponseField(
            results_returned: e <| "results_returned",
            results_available: e <| "results_available",
            results_start: e <| "results_start",
            events: e <|| "events"
        )
    }
}

struct Event: Decodable {
    let event_id: Int
    let title: String
    let description: String
    let event_url: String
    
    static func decode(e: Extractor) throws -> Event {
        return try Event(
            event_id: e <| "event_id",
            title: e <| "title",
            description: e <| "description",
            event_url: e <| "event_url"
        )
    }
}