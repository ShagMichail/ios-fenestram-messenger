//
//  SocketIOManager.swift
//  FenestramMessanger
//
//  Created by Михаил Беленко on 15.07.2022.
//

import Foundation
import SocketIO
import Alamofire

@MainActor
protocol SocketIOManagerObserver: AnyObject {
    func receiveMessage(_ message: MessageEntity)
}

final class SocketIOManager {
    private(set) var manager: SocketManager
    private(set) var socket: SocketIOClient
    
    private var observers: [Weak<SocketIOManagerObserver>] = []
    fileprivate let baseUrlString = Settings.isDebug ? Constants.devSocketUrl : Constants.prodSocketURL
    
    init(accessToken: String) {
        print("access token: ", accessToken)
        self.manager = SocketManager(socketURL: URL(string: baseUrlString)!, config: [
            .log(true),
            .extraHeaders(["Authorization": "Bearer \(accessToken)"])
        ])
        self.socket = self.manager.defaultSocket
        
        connect()
    }
    
    deinit {
        manager.disconnect()
    }
    
    func changeAccessToken(accessToken: String) {
        print("access token: ", accessToken)
        self.manager = SocketManager(socketURL: URL(string: baseUrlString)!, config: [
            .log(true),
            .extraHeaders(["Authorization": "Bearer \(accessToken)"])
        ])
        self.socket = self.manager.defaultSocket
        
        connect()
    }
    
    func connect() {
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
        }
        
        socket.on("receiveMessage") { data, ack in
            print("receive message: ", data)
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed),
               let messagesList = try? JSONDecoder().decode([MessageResponse].self, from: jsonData) {
                messagesList.forEach { [weak self] message in
                    self?.observers.forEach({ observer in
                        guard let observer = observer.value else {
                            return
                        }
                        
                        Task {
                            await observer.receiveMessage(message.message)
                        }
                    })
                }
            }
        }
        
        socket.connect()
    }
    
    func checkConnect() {
        if manager.status != .connected {
            connect()
        }
    }
    
    func addObserver(_ observer: SocketIOManagerObserver) {
        observers.append(Weak(value: observer))
    }
    
    func removeObserver(_ observer: SocketIOManagerObserver) {
        observers.removeAll(where: { $0.value === observer })
    }
    
    func logOut() {
        manager.disconnect()
        socket.disconnect()
        observers.removeAll()
    }
}
