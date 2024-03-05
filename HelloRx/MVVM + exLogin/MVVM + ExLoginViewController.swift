//
//  MVVM + ExLoginViewController.swift
//  HelloRx
//
//  Created by 여성일 on 3/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MVVMexLoginViewController: UIViewController {
    
    private let viewModel = ExLoginViewModel()
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
        idTextField.rx.text.orEmpty
            .bind(to: viewModel.inputIdText)
            .disposed(by: disposeBag)

        
        pwTextField.rx.text.orEmpty
            .bind(to: viewModel.inputPwText)
            .disposed(by: disposeBag)
        
        // output
        viewModel.emptyCheckId
            .bind(to: validIdView.rx.isHidden )
            .disposed(by: disposeBag)
        
        viewModel.emptyCheckPw
            .bind(to: validPwView.rx.isHidden )
            .disposed(by: disposeBag)
        
        viewModel.validCheckId
            .map { $0 ? UIColor.green : UIColor.red}
            .bind(to: self.validIdView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.validCheckPw
            .map { $0 ? UIColor.green : UIColor.red}
            .bind(to: self.validPwView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.validLogin
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

class ExLoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    var inputIdText = BehaviorSubject(value: "")
    var inputPwText = BehaviorSubject(value: "")
    
    var emptyCheckId = BehaviorSubject(value: false)
    var emptyCheckPw = BehaviorSubject(value: false)
    
    var validCheckId = BehaviorSubject(value: false)
    var validCheckPw = BehaviorSubject(value: false)
    
    var validLogin = BehaviorSubject(value: false)
    
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
