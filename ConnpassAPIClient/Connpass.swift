//
//  Connpass.swift
//  ConnpassAPIClient
//
//  Created by JPMartha on 2015/12/10.
//  Copyright © 2015年 JPMartha. All rights reserved.
//

import Foundation
import APIKit

protocol ConnpassDelegate {
    func searchEventDidFinish(events: [Event])
}

public class Connpass {
    
    static var delegate: ConnpassDelegate?
    
    static var events = [Event]()
    
    public static func sendSearchEventRequest() {
        let request = GetSearchEventRequest()
        
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
                
                self.delegate!.searchEventDidFinish(self.events)
                
            case .Failure(let error):
                print("error: \(error)")
            }
        }
    }
}