//
//  HTTPURLSession.swift
//
//
//  Created by Writayan Das on 06/02/24.
//

import Foundation

public class DefaultHTTPURLSession {

    public private(set) var session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        let delegate = DefaultHTTPURLSessionDelegate()
        session =  URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }

    public static var shared = DefaultHTTPURLSession()
}

final class DefaultHTTPURLSessionDelegate: NSObject, URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
                return
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }
}
