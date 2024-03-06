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
    
    let viewModel: ExLoginViewModelProtocol
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
    
    init(viewModel: ExLoginViewModelProtocol = ExLoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            .asDriver()
            .drive(viewModel.whichLoginId)
            .disposed(by: disposeBag)

        pwTextField.rx.text.orEmpty
            .asDriver()
            .drive(viewModel.whichLoginPw)
            .disposed(by: disposeBag)
        
        // output
        viewModel.emptyCheckIdResult
            .asDriver()
            .drive(validIdView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.emptyCheckPwResult
            .asDriver()
            .drive(validPwView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.validCheckIdResult
            .asDriver()
            .map { $0 ? UIColor.green : UIColor.red}
            .drive(self.validIdView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.validCheckPwResult
            .asDriver()
            .map { $0 ? UIColor.green : UIColor.red}
            .drive(self.validPwView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.validLoginResult
            .asDriver()
            .drive(self.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

