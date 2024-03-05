//
//  ExLoginViewModel.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class ExLoginViewModel {
    private let disposeBag = DisposeBag()
    
    var inputIdText = BehaviorRelay(value: "")
    var inputPwText = BehaviorRelay(value: "")
    
    var emptyCheckId = BehaviorRelay(value: false)
    var emptyCheckPw = BehaviorRelay(value: false)
    
    var validCheckId = BehaviorRelay(value: false)
    var validCheckPw = BehaviorRelay(value: false)
    
    var validLogin = BehaviorRelay(value: false)
    
    init() {
        inputIdText
            .map { self.isEmpty(text: $0) }
            .bind(to: emptyCheckId)
            .disposed(by: disposeBag)
        
        inputIdText
            .map { self.checkId(id: $0) }
            .bind(to: validCheckId)
            .disposed(by: disposeBag)
        
        inputPwText
            .map { self.isEmpty(text: $0) }
            .bind(to: emptyCheckPw)
            .disposed(by: disposeBag)
        
        inputPwText
            .map{ self.checkPw(pw: $0) }
            .bind(to: validCheckPw)
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(validCheckId, validCheckPw, resultSelector: { $0 && $1})
            .bind(to: validLogin)
            .disposed(by: disposeBag)
    }
    
    private func isEmpty(text: String) -> Bool {
        return text.isEmpty && text.count == 0
    }
    
    private func checkId(id: String) -> Bool {
        return id.contains("@") && id.contains(".")
    }
    
    private func checkPw(pw: String) -> Bool {
        return pw.count > 5
    }
}
