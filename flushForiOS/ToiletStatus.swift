//
//  ToiletStatus.swift
//  fluxCapacitor
//
//  Created by Tomas Novella on 1/8/16.
//  Copyright © 2016 Tomas Novella. All rights reserved.
//

import Foundation

class ToiletStatus : NSObject, SRWebSocketDelegate {
    let kWebSocketURL = "ws://itoilet/changes"
    let kHTTPQueryURL = "http://itoilet/api/sensors" // @todo
    
    private var _statuses = [String:Bool]()
    private var _webSocket: SRWebSocket?
    
    override init() {
        super.init()
        let host = NSURL(string: kWebSocketURL)?.host;
        let _reachability = Reachability(hostName: host);
        _reachability.startNotifier();

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "reachabilityChanged:",
            name: kReachabilityChangedNotification,
            object: nil);
    }
    
    private func wsConnect() {
        if(_webSocket == nil) {
            _webSocket = SRWebSocket(URL: NSURL(string: kWebSocketURL))
            _webSocket?.delegate = self
            _webSocket?.open()
        }
    }
    
    private func wsDisconnect() {
        if(_webSocket != nil) {
            _webSocket?.close()
            _webSocket = nil
        }
        _statuses.removeAll()
    }
    
    func reachabilityChanged(notification:NSNotification) {
        let r = notification.object as! Reachability
        if(r.currentReachabilityStatus() == NetworkStatus.NotReachable) {
            wsDisconnect()
        } else {
            wsConnect()
        }
    }
    
    // MARK: SRWebSocketDelegate
    func webSocketDidOpen(webSocket: SRWebSocket!) {
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        if let msg = (try? NSJSONSerialization.JSONObjectWithData(
            message.dataUsingEncoding(NSUTF8StringEncoding)!, options:[])) as? NSDictionary
        {
            let locked = msg["state"]?.isEqualToString("locked")
            let name = msg["name"] as! String
            _statuses[name] = locked
        }
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        wsDisconnect()
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        wsDisconnect()
    }
    
    //MARK public API
    func getStatuses() -> [String:Bool] {
        return _statuses
    }
    
}