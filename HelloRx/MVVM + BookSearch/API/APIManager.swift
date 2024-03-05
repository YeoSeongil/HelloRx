//
//  APIManager.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import Foundation
import RxSwift

class APIManager {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getComponent(title: String) -> URLComponents {
        let schema = "https"
        let host = "dapi.kakao.com"
        let path = "/v3/search/book"
        
        var components = URLComponents()
        
        components.scheme = schema
        components.host = host
        components.path = path
        
        components.queryItems = [
            URLQueryItem(name: "target", value: "title"),
            URLQueryItem(name: "query", value: title),
            URLQueryItem(name: "size", value: "10"),
        ]
        return components
    }
    
    func getBook(title: String) -> Single<Result<Books, URLError>> {
        guard let url = getComponent(title: title).url else {
            return .just(.failure(URLError(.badURL)))
        }
        
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(API.apiKey)", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let bookData = try JSONDecoder().decode(Books.self, from: data)
                    return .success(bookData)
                } catch {
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch { _ in
                    .just(Result.failure(URLError(.cannotLoadFromNetwork)))
            }
            .asSingle()
    }
}
