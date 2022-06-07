//
//  NetworkingManager.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import Foundation
import Combine

class NetworkingManager {
    
    static var urlSessionConfig: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        
        let cacheDirectoryUrl = FileManager.getCachesDirectory()
        let cacheUrl = cacheDirectoryUrl.appendingPathComponent("NetworkingCache")
        var diskPath = cacheUrl.path
        
        let cache = URLCache(
            memoryCapacity: 16384, // 0.015625 mb
            diskCapacity: 268435456, // 256 mb
            diskPath: diskPath)
        
        config.urlCache = cache
        config.requestCachePolicy = .useProtocolCachePolicy
        
        return config
    }()
    
    static var session = URLSession(configuration: urlSessionConfig)
    
    enum NetworkingError: LocalizedError {
        case badUrlResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badUrlResponse(url: let url):
                return "[🔥] Bad response url: \(url)"
            case .unknown:
                return "[⚠️] Error occured"
            }
        }
    }
    
    static func delete(url:URL, body: Data? = nil, query: [URLQueryItem]? = nil) async throws -> Data {
        let newUrl = try getURLAfterConfig(url: url, query: query)
        var request = getRequestAfterConfig(url: newUrl)
        request.httpMethod = "DELETE"
        
        // TODO: Remove Data() if found a way to handle optional Data in request.
        let (data, response) = try await session.upload(for: request, from: body ?? Data())
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw NetworkingError.badUrlResponse(url: url)
        }
        
        if let errorResponse = MovieDBAPIResponseParser.getErrorResponse(data) {
            throw errorResponse
        }
        
        return data
    }
    
    static func post(url:URL, body: Data, query: [URLQueryItem]? = nil) async throws -> Data {
        let newUrl = try getURLAfterConfig(url: url, query: query)
        let request = getRequestAfterConfig(url: newUrl)
        let (data, response) = try await session.upload(for: request, from: body)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw NetworkingError.badUrlResponse(url: url)
        }
        
        if let errorResponse = MovieDBAPIResponseParser.getErrorResponse(data) {
            throw errorResponse
        }
        
        return data
    }
    
    static func download(url: URL, query: [URLQueryItem]? = nil) async throws -> Data {
        let newUrl = try getURLAfterConfig(url: url, query: query)
        let request = getRequestAfterConfig(url: newUrl, httpMethod: "GET")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            throw NetworkingError.badUrlResponse(url: url)
        }
        
        if let errorResponse = MovieDBAPIResponseParser.getErrorResponse(data) {
            throw errorResponse
        }
        
        return data
    }
    
    static func download(url: URL, query: [URLQueryItem]? = nil, completion: @escaping (Result<Data, Error>) -> ()) {
        do {
            let newUrl = try getURLAfterConfig(url: url, query: query)
            let request = getRequestAfterConfig(url: newUrl, httpMethod: "GET")
            
            session.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    completion(.failure(error))
                }
                
                completion(.success(data!))
            }
        } catch {
            completion(.failure(NetworkingError.badUrlResponse(url: url)))
        }
    }
    
    static func download(url: URL, query: [URLQueryItem]? = nil) -> AnyPublisher<Data, Error> {
        do {
            let newUrl = try getURLAfterConfig(url: url, query: query)
            let request = getRequestAfterConfig(url: newUrl, httpMethod: "GET")
            
            return session.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .default)) // run in bg thread (?)
                .tryMap { try handleURLResposne(output: $0, url: newUrl) }
                .receive(on: DispatchQueue.main) // pass it to UI thread
                .eraseToAnyPublisher() // makes return type more readable (the AnyPublisher<Data, Error>) instead of the real type from the original publisher.
        } catch {
            return Fail(error: NSError(domain: NetworkingError.badUrlResponse(url: url).localizedDescription, code: 500, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }
    
    static func getRequestAfterConfig(url: URL, httpMethod: String? = "POST") -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        
        return request
    }
    
    static func getURLAfterConfig(url: URL, query: [URLQueryItem]? = nil) throws -> URL {
        
        var defaultQueryItems = [
            URLQueryItem(name: "api_key", value: Keys.apiToken),
        ]
        
        // access user locale setting
        if let locale = UserDefaults.standard.string(forKey: .localePreference) {
            defaultQueryItems.append(URLQueryItem(name: "language", value: locale.toMovieDBLocaleString()))
        }
        
        let queryItems = (query ?? []) + defaultQueryItems
        
        guard let newUrl = url.appending(queryItems) else {
            throw NetworkingError.badUrlResponse(url: url)
        }
        
        return newUrl
    }
    
    static func handleURLResposne(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                  
                  if let errorResponse = MovieDBAPIResponseParser.getErrorResponse(output.data) {
                      throw errorResponse
                  }
                  
                  throw NetworkingError.badUrlResponse(url: url)
              }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription) // human readable error
            break
        }
    }
}
