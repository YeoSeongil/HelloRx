//
//  ExLoginViewModel.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ExLoginViewModelProtocol {
    // Input
    var whichLoginId: AnyObserver<String> { get }
    var whichLoginPw: AnyObserver<String> { get }
    
    // Output
    var emptyCheckIdResult: Driver<Bool> { get }
    var emptyCheckPwResult: Driver<Bool> { get }
    var validCheckIdResult: Driver<Bool> { get }
    var validCheckPwResult: Driver<Bool> { get }
    var validLoginResult: Driver<Bool> { get }
}

class ExLoginViewModel {
    private let disposeBag = DisposeBag()
    
    // Input
    var inputIdText = BehaviorSubject<String>(value: "")
    var inputPwText = BehaviorSubject<String>(value: "")
    
    // Output
    var emptyCheckId = BehaviorRelay(value: false)
    var emptyCheckPw = BehaviorRelay(value: false)
    var validCheckId = BehaviorRelay(value: false)
    var validCheckPw = BehaviorRelay(value: false)
    var validLogin = BehaviorRelay(value: false)
    
    init() {
        tryEmptyCheckId()
        tryEmptyCheckPw()
        tryValidCheckId()
        tryValidCheckPw()
        tryValidLogin()
    }
    
    private func tryEmptyCheckId() {
        inputIdText
            .map { $0.isEmpty && $0.count == 0 }
            .bind(to: emptyCheckId)
            .disposed(by: disposeBag)
    }
    
    private func tryEmptyCheckPw() {
        inputPwText
            .map { $0.isEmpty && $0.count == 0 }
            .bind(to: emptyCheckPw)
            .disposed(by: disposeBag)
    }    
    
    private func tryValidCheckId() {
        inputIdText
            .map { $0.contains("@") && $0.contains(".") }
            .bind(to: validCheckId)
            .disposed(by: disposeBag)
    }    
    
    private func tryValidCheckPw() {
        inputPwText
            .map { $0.count > 5 }
            .bind(to: validCheckPw)
            .disposed(by: disposeBag)
    }    
    
    private func tryValidLogin() {
        Observable.combineLatest(validCheckId, validCheckPw, resultSelector: { $0 && $1})
            .bind(to: validLogin)
            .disposed(by: disposeBag)
    }
}

extension ExLoginViewModel: ExLoginViewModelProtocol {
    // Input
    var whichLoginId: AnyObserver<String> {
        inputIdText.asObserver()
    }
    
    var whichLoginPw: AnyObserver<String> {
        inputPwText.asObserver()
    }
    
    // Output
    var emptyCheckIdResult: Driver<Bool> {
        emptyCheckId.asDriver(onErrorJustReturn: false)
    }
    
    var emptyCheckPwResult: Driver<Bool> {
        emptyCheckPw.asDriver(onErrorJustReturn: false)
    }
    
    var validCheckIdResult: Driver<Bool> {
        validCheckId.asDriver(onErrorJustReturn: false)
    }
    
    var validCheckPwResult: Driver<Bool> {
        validCheckPw.asDriver(onErrorJustReturn: false)
    }
    
    var validLoginResult: Driver<Bool> {
        validLogin.asDriver(onErrorJustReturn: false)
    }
    
}
