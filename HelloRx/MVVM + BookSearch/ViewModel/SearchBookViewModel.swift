//
//  SearchBookViewModel.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchBookViewModel {
    let disposeBag = DisposeBag()
    // input
    // 입력한 책 제목
    let inputText = BehaviorRelay<String>(value: "")
    // 검색 버튼이 눌렸는가
    let buttonTapped = PublishSubject<Void>()
    
    // output
    // 버튼 클릭 시 책 제목 받아와 이벤트 방출
    let loadResult: Observable<String>
    var fetchData: Observable<[Document]>
    //var bookData = BehaviorSubject<[Books]>(value: [Books]())
    
    init(_ model: MainModel = MainModel()) {
        self.loadResult = buttonTapped
            .withLatestFrom(inputText) { $1 }
            .filter { !$0.isEmpty}
            .distinctUntilChanged()
        
        let searchBookResult = loadResult
            .flatMapLatest(model.searchBooks)
            .share()
        
        let searchBookValue = searchBookResult
            .compactMap(model.getBooksModelValue)
        
        fetchData = searchBookValue
            .map{ $0.documents }
        
        fetchData.subscribe { book in
            print(book)
        }
    }
}
