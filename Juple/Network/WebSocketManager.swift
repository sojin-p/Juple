//
//  WebSocketManager.swift
//  Juple
//
//  Created by 박소진 on 2024/03/29.
//

import Foundation
import Combine

final class WebSocketManager: NSObject {
    
    static let shared = WebSocketManager()
    
    private override init() {
        super.init()
    }
    
    private var webSocket: URLSessionWebSocketTask?
    
    private var timer: Timer?
    
    private var isOpen = false
    
    var tickerSubject = PassthroughSubject<Ticker, Never>()
    
    var orderBookSubject = PassthroughSubject<OrderBookWS, Never>()
    
    func openWebSocket() {
        
        if let url = URL(string: "wss://api.upbit.com/websocket/v1") {
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            webSocket = session.webSocketTask(with: url)
            
            webSocket?.resume()
            
            ping()
            
        }
        
    }
    
    func closeWebSocket() {
        
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        
        timer?.invalidate()
        timer = nil
        
        isOpen = false
        
    }
    
    func send(_ marketCode: [String]) {
        let string = """
       [{"ticket": "test"}, {"type": "ticker","codes": \(marketCode)}, {"ticket": "test"}, {"type": "orderbook", "codes": \(marketCode)}]
       """
        
        webSocket?.send(.string(string), completionHandler: { error in
            if let error {
                print("send error, \(error)")
            }
        })
    }
    
    func receive() {
        
        if isOpen {
            webSocket?.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let success):
                    //print("receive 성공, \(success)")
                    
                    self?.handleReceivedMessage(success)
                    
                case .failure(let success):
                    print("receive 실패, \(success)")
                    self?.closeWebSocket()
                }
                self?.receive()
            })
        }
        
    } //receive
    
    
    private func handleReceivedMessage(_ message: URLSessionWebSocketTask.Message) {
        
        switch message {
        case .data(let data):
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Failed to parse JSON data")
                return
            }
            
            if let type = json["type"] as? String {
                
                switch type {
                case "ticker":
                    
                    do {
                        let decodedData = try JSONDecoder().decode(Ticker.self, from: data)
//                            print("== receive \(decodedData)")
                        self.tickerSubject.send(decodedData)
                        
                    } catch {
                        print("ticker 디코딩 실패 \(error)")
                    }
                    
                case "orderbook":
                    
                    do {
                        let decodedData = try JSONDecoder().decode(OrderBookWS.self, from: data)
//                            print("== receive \(decodedData)")
                        self.orderBookSubject.send(decodedData)
                        
                    } catch {
                        print("OrderBookWS 디코딩 실패 \(error)")
                    }
                    
                default:
                    print("Unknown message type: \(type)")
                }
                
            } else {
                print("Missing 'type' field in received message")
            }
            
        case .string(let string):
            print("Received string message: \(string)")
            
        @unknown default:
            print("Received unknown message type")
        }
    }
    
    private func ping() {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { [weak self] _ in
            
            self?.webSocket?.sendPing(pongReceiveHandler: { error in
                if let error {
                    print("ping pong error, \(error)")
                } else {
                    print("ping")
                }
            }) //webSocket
            
        }) //timer
        
    } //ping
    
} //WebSocketManager

extension WebSocketManager: URLSessionWebSocketDelegate {
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("==WebSocket Open")
        isOpen = true
        receive()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        isOpen = false
        print("==WebSocket Close")
    }
    
}

