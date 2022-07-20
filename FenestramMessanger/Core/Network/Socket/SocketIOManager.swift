//
//  SocketIOManager.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 15.07.2022.
//

import Foundation
import SocketIO
import Alamofire

protocol SocketIODelegate: AnyObject {
}

final class SocketIOManager {
    let manager: SocketManager
    let socket: SocketIOClient
    
    private weak var delegate: SocketIODelegate?
    
    init(delegate: SocketIODelegate?, accessToken: String) {
        print("access token: ", accessToken)
        self.manager = SocketManager(socketURL: URL(string: Constants.socketURL)!, config: [
            .log(true),
            .extraHeaders(["Authorization": "Bearer \(accessToken)"])
        ])
        self.socket = self.manager.defaultSocket
        
        connect()
        
        self.delegate = delegate
    }
    
    deinit {
        manager.disconnect()
    }
    
    func connect() {
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
        }
        
        socket.on("receiveMessage") { data, ack in
            print("receive message: ", data)
        }
        
        socket.connect()
    }
    
    func checkConnect() {
        if manager.status != .connected {
            manager.reconnect()
        }
    }
}
