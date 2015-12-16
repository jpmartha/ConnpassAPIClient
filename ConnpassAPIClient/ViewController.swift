//
//  ViewController.swift
//  MyConnpass
//
//  Created by JPMartha on 2015/12/10.
//  Copyright © 2015年 JPMartha. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController,
UITableViewDataSource, UITableViewDelegate,
SFSafariViewControllerDelegate,
ConnpassDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var connpass = Connpass()
    
    var data = [Event]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        connpass.delegate = self
        connpass.sendRequest()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath)
        
        let event = data[indexPath.row]
        cell.textLabel?.text = event.title
        cell.detailTextLabel?.text = event.event_url
        
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = NSURL(string: data[indexPath.row].event_url) {
            let safari = SFSafariViewController(URL: url)
            presentViewController(safari, animated: true, completion: nil)
        }
    }
    
    // MARK: - SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - ConnpassDelegate
    
    func eventSearchDidFinish(events: [Event]) {
        data = events
    }
}

