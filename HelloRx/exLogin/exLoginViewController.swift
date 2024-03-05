//
//  exLoginViewController.swift
//  HelloRx
//
//  Created by 여성일 on 3/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class exLoginViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let pwTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let validIdView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let validPwView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraint()
        bind()
    }
    
    private func setView() {
        [idTextField, pwTextField, validIdView, validPwView, loginButton].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    private func setConstraint() {
        idTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(150)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
            $0.horizontalEdges.equalToSuperview().inset(50)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(35)
            $0.horizontalEdges.equalToSuperview().inset(50)
        }
        
        validIdView.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(10)
            $0.top.equalTo(idTextField.snp.top).offset(5)
            $0.trailing.equalTo(idTextField.snp.trailing).offset(-5)
        }
        
        validPwView.snp.makeConstraints {
            $0.width.equalTo(10)
            $0.height.equalTo(10)
            $0.top.equalTo(pwTextField.snp.top).offset(5)
            $0.trailing.equalTo(pwTextField.snp.trailing).offset(-5)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview().inset(50)
            $0.height.equalTo(50)
        }
    }
    
    private func bind() {
        loginButton.rx.tap
            .bind { print("login") }
            .disposed(by: disposeBag)
        
        // input
        let emptyCheckId = BehaviorRelay(value: false)
        let emptyCheckPw = BehaviorRelay(value: false)
        
        let validCheckId = BehaviorRelay(value: false)
        let validCheckPw = BehaviorRelay(value: false)
        
        idTextField.rx.text.orEmpty
            .asDriver()
            .map{self.isEmpty(text: $0)}
            .drive(emptyCheckId)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .asDriver()
            .map{self.isEmpty(text: $0)}
            .drive(emptyCheckPw)
            .disposed(by: disposeBag)
        
        idTextField.rx.text.orEmpty
            .asDriver()
            .map{ self.checkId(id:$0) }
            .drive(validCheckId)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .asDriver()
            .map{ self.checkPw(pw:$0) }
            .drive(validCheckPw)
            .disposed(by: disposeBag)
        
        // output
        emptyCheckId
            .asDriver(onErrorJustReturn: false)
            .drive(validIdView.rx.isHidden )
            .disposed(by: disposeBag)
        
        emptyCheckPw
            .asDriver(onErrorJustReturn: false)
            .drive(validPwView.rx.isHidden )
            .disposed(by: disposeBag)
        
        validCheckId
            .asDriver(onErrorJustReturn: false)
            .map { $0 ? UIColor.green : UIColor.red}
            .drive( self.validIdView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        validCheckPw
            .asDriver(onErrorJustReturn: false)
            .map { $0 ? UIColor.green : UIColor.red}
            .drive(self.validPwView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(validCheckId, validCheckPw, resultSelector:  { $0 && $1})
            .asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabled)
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


