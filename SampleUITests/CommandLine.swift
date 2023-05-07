//
//  CommandLine.swift
//  SampleUITests
//
//  Created by Alexey Alter Pesotskiy  on 5/7/23.
//

import Foundation

class CommandLine {
    
    private static let host = "http://localhost"
    private static let port: UInt16 = 4567
    
    enum ConnectionState: String {
        case on
        case off
    }
    
    static func setConnection(state: ConnectionState) {
        let network = ["Ethernet", "Wi-Fi", "iPhone USB"]
        for service in network {
            exec("networksetup -setnetworkserviceenabled '\(service)' \(state) || true")
        }
    }
    
    @discardableResult
    private static func exec(_ command: String, async: Bool = false) -> String {
        let urlString = "\(host):\(port)/terminal?async=\(async)"
        guard let url = URL(string: urlString) else { return "" }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["command": command], options: [])
        var output = ""

        if async {
            // Do not wait for the command to complete
            URLSession.shared.dataTask(with: request).resume()
        } else {
            // Wait for the command to complete
            let semaphore = DispatchSemaphore(value: 0)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let string = String(data: data, encoding: .utf8) {
                    output = string
                    semaphore.signal()
                }
            }
            task.resume()
            semaphore.wait()
        }
        return output
    }
}
