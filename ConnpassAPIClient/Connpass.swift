//
//  Connpass.swift
//  ConnpassAPIClient
//
//  Created by JPMartha on 2015/12/10.
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

protocol ConnpassDelegate {
    func eventSearchDidFinish(events: [Event])
}

public class Connpass {
    
    var delegate: ConnpassDelegate?
    
    var events = [Event]()
    
    func sendRequest() {
        let request = GetEventSearchRequest()
        
        Session.sendRequest(request) { result in
            switch result {
            case .Success(let responseField):
                print("results_returned: \(responseField.results_returned)")
                print("results_available: \(responseField.results_available)")
                print("results_start: \(responseField.results_start)")
                
                self.events.removeAll()
                
                for event in responseField.events {
                    print("event_id: \(event.event_id)")
                    print("title: \(event.title)")
                    print("description: \(event.description)")
                    print("event_url: \(event.event_url)")
                    
                    self.events.append(event)
                }
                
                self.delegate!.eventSearchDidFinish(self.events)
                
            case .Failure(let error):
                print("error: \(error)")
            }
        }
    }
}