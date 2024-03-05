//
//  MainModel.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import Foundation
import RxSwift

struct MainModel {
    let network = APIManager()
    
    func searchBooks(_ query: String) -> Single<Result<Books, URLError>> {
        return network.getBook(title: query)
    }
    
    func getBooksModelValue(_ searchResult : Result<Books, URLError>) -> Books? {
           guard case .success(let value) = searchResult else {
               return nil
           }
           return value
       }
}
