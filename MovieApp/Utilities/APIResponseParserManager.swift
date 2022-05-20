//
//  APIResponseParserManager.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 19/05/2022.
//

import Foundation

/// An utility class that includes pre-config formatters, decoders, encoders for TheMovieDB API responses.
final class MovieDBAPIResponseParser {
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        return dateFormatter
    }()
    
    /// Pre-config json decoder for TheMovieDB API responses.
    static var jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return jsonDecoder
    }()
    
    /// Pre-config json encoder for TheMovieDB API request body/parameters.
    static var jsonEncoder: JSONEncoder = {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        
        return jsonEncoder
    }()
    
    /// Encode any **Encodable** model with pre-config json encoder for TheMovieDB API request body/parameters.
    static func encode<T: Encodable>(_ model: T) throws -> Data {
        return try self.jsonEncoder.encode(model)
    }
    
    /// Decode **Data** with pre-config json decoder for TheMovieDB API responses.
    static func decode<T: Decodable>(_ data: Data) throws -> T {
        return try self.jsonDecoder.decode(T.self, from: data)
    }
    
    /// Decode returned response from TheMovieDB API and return APIError if have.
    ///
    /// Because sometimes even though the request is valid, the API would still return [APIError](x-source-tag://APIError) back.
    ///
    /// To avoid this problem, we will check if ``APIError.success`` is *true*, then it means the request is **valid** and return **nil**.
    /// Otherwise, return the error.
    static func getErrorResponse(_ data: Data) -> APIError? {
        guard let errorResponse: APIError = try? self.decode(data),
                errorResponse.success == false else { return nil }
        return errorResponse
    }
}
