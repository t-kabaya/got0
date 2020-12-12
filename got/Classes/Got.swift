//
//  KabaFire.swift
//  KabaFire
//
//  Created by IPG on 2020/11/22.
//  Copyright © 2020 Taiki Kabaya. All rights reserved.
//

import Foundation
import UIKit

public class Got {
    public static func get<T: Codable>(url: String, model: T.Type, query: [String : String] = [:], header: [String : String] = [:], completion: @escaping(T) -> Void) {
        self.request(url: url, method: "GET", query: query, completion: { value in
                completion(value)
        })
    }
    
    // TODO: bodyに未対応
    public static func post<T: Codable>(url: String, model: T.Type, header: [String : String] = [:], body: [String : Any], completion: @escaping(T) -> Void) -> Void {
        self.request(url: url, method: "POST", header: header, completion: { value in
            completion(value)
        })
    }
    
    // TODO: bodyに未対応
    public static func put<T: Codable>(url: String, model: T.Type, body: [String : Any], header: [String : String] = [:], completion: @escaping(T) -> Void) -> Void {
        self.request(url: url, method: "PUT", completion: { value in
            completion(value)
        })
    }
    
    public static func delete<T: Codable>(url: String, model: T.Type, header: [String : String] = [:], completion: @escaping(T) -> Void) -> Void {
        self.request(url: url, method: "DELETE", completion: { value in
            completion(value)
        })
    }
    
    // 現状headerとqueryには、Stringしかセット出来ない。
    private static func request<T: Codable>(url: String, method: String, header: [String : String] = [:], query: [String : String] = [:], body: [String : Any] = [:], completion: @escaping(T) -> Void) {
        // add query
        var components = URLComponents(string: url)!
        components.queryItems = query.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        // uriの世界では＋は、&, ＄と同じように予約語であり使ってはならない。本来はエスケープしなければならないが、swiftはこの機能を提供していないため手動でエスケープする。
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let uri = URL(string: url)!
        
        var request = URLRequest(url: uri)
        request.httpMethod = method
        
        // add header
        for (key, value) in header {
            request.setValue(key, forHTTPHeaderField: value)
        }
        
        
        // add body
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: uri) {(data, response, error) in
            guard let data = data else { return }
            do {
                let value: T = try JSONDecoder().decode(T.self, from: data)
                    completion(value)
            } catch {
                // noop
            }
        }
        task.resume()
    }
}

