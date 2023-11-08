//
//  NetworkService.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 19/10/23.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Implementation

final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
    ) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(
        request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
    
        logger.log(request: request)

        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    
    func request(
        endpoint: Requestable,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable? {
        do {
            
            var urlRequest = try endpoint.urlRequest(with: config)
            //let token = "eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ0OWU0N2ZiZGQ0ZWUyNDE0Nzk2ZDhlMDhjZWY2YjU1ZDA3MDRlNGQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY2FzaGZsb3ctMzczNzMiLCJhdWQiOiJjYXNoZmxvdy0zNzM3MyIsImF1dGhfdGltZSI6MTY5OTIyNTU3NSwidXNlcl9pZCI6IjRnTzA5YlE0N01hc3pMclRaQ0xVVDFDUW1QTDIiLCJzdWIiOiI0Z08wOWJRNDdNYXN6THJUWkNMVVQxQ1FtUEwyIiwiaWF0IjoxNjk5MjI1NTc1LCJleHAiOjE2OTkyMjkxNzUsImVtYWlsIjoicHJ1ZWJhMUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsicHJ1ZWJhMUBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.PhSTdBieI8yP3ayzlvzK0Uf_ATdDw61qg-Je_WV4-CMV1QDsSltkgwHjGnMKJ-eHgcCnrlvP0bQE7ttf3jp8v2hdwIPVuXjgNKJy7JqmXsxhb7J2YNQWHpeYiwIRuxjOpFB4zrWL2m0ICIvQGTwkKWBCgKy_jcJ52dVFtifBrZPLPOVK4kqWSLuo77Nbqukdem8--W5Cz9zYqf29fZ4AgTQreupHHEHh8NtEi44ysgvkriW0NW8fyVOk0rzyPXKbMwXgKJHqAl-nTbZLoGIzLNuRgfrdDRBuY3NyD2cIr5-7pKGAs04yrY1fVp-cCj4y447FTmnxPg3HjWKhnPH0dw"
            
            //urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            // Añade el encabezado Content-Type si es necesario
            if let method = urlRequest.httpMethod, ["POST", "PUT", "PATCH"].contains(method) {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}


// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be injected into NetworkService instead of default one.

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - Logger

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }

    func log(request: URLRequest) {
        printIfDebug("-------------")
        printIfDebug("request: \(request.url!)")
        printIfDebug("headers: \(request.allHTTPHeaderFields!)")
        printIfDebug("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: - NetworkError extension

extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default: return false
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
