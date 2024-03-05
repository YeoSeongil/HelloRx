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
    // UI이기 때문에 Relay 선언
    // 텍스트를 구독하고, 받아온 텍스트를 방출해야하므로 옵저버블과 옵저버 역할을 해야하므로
    // 릴레이로 선언
    let inputText = BehaviorRelay<String>(value: "")
    
    // 검색 버튼이 눌렸는가
    // UI요소가 아니기 때문에 서브젝트로 선언
    // 버튼이 눌림을 구독 해야하고, 결과를 방출해야하므로 옵저버블과 옵저버 역할을 해야하므로 서브젝트로 선언
    let buttonTapped = PublishSubject<Void>()
    
    // output
    // 버튼 클릭 시 책 제목 받아와 이벤트 방출
    // 다른 애들을 구독할 필요 없기 때문에 옵저버블로 선언
    let loadResult: Observable<String>
    
    // 검색 결과를 받아오는 옵저버블
    // 다른 애들을 구독할 필요 없기 때문에 옵저버블로 선언
    var fetchData: Observable<[Document]>
    
    let apiData = PublishSubject<[Document]>()
    
    // 검색 결과를 Cell에 사용하기 위한 옵저버블
    // 다른 애들을 구독할 필요 없기 때문에 드라이버로 선언
    let cellData: Driver<[Document]>

    
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

        fetchData
            .bind(to: apiData)
            .disposed(by: disposeBag)
        
        cellData = apiData.asDriver(onErrorJustReturn: [])
    }
}
