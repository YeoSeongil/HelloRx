//
//  SearchBookViewModel.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchBookViewModelProtocol {
    // Input
    var whichTitle: AnyObserver<String> { get }
    var tappedSearchButton: AnyObserver<Void> { get }
    
    // Output
    var fetchedSearchOutput: Driver<[Document]> { get }
}

class SearchBookViewModel {
    
    let disposeBag = DisposeBag()
    
    // input
    private let searchKeyword = BehaviorSubject<String>(value: "")
    private let searchEvent = PublishSubject<Void>()
    
    // output
    private let fetchingSearchOutput = BehaviorRelay<[Document]>(value: [])
    
    init(_ model: MainModel = MainModel()) {
        trySearchForBookTitle()
    }
    
    private func trySearchForBookTitle() {
        let result = searchEvent
            .withLatestFrom(searchKeyword) { $1 }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
        
        let searchBookValue = result
            .flatMapLatest(MainModel().searchBooks)
            .share()
            .compactMap(MainModel().getBooksModelValue)
        
        let fetchData = searchBookValue
            .map{ $0.documents }
        
        fetchData.subscribe() { doc in
            self.fetchingSearchOutput.accept(doc)
        }.disposed(by: disposeBag)
    }
}

extension SearchBookViewModel: SearchBookViewModelProtocol {
    var whichTitle: AnyObserver<String> {
        searchKeyword.asObserver()
    }
    
    var tappedSearchButton: AnyObserver<Void> {
        searchEvent.asObserver()
    }
    
    var fetchedSearchOutput: Driver<[Document]> {
        fetchingSearchOutput.asDriver(onErrorDriveWith: .empty())
    }
}
