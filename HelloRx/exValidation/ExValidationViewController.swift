//
//  ExValidationViewController.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ExValidationViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.placeholder = "이메일을 입력하세요."
        return textField
    }()
    
    private let bindLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraint()
        bind()
    }
    
    private func setView() {
        [textField, bindLabel].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    private func setConstraint() {
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(35)
            $0.horizontalEdges.equalToSuperview().inset(50)
        }
        
        bindLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview().inset(50)
        }
    }
    
    private func bind() {
        let inputText = BehaviorRelay(value: false)

        // input
        textField.rx.text.orEmpty
            .asDriver()
            .map { self.isValid(id: $0) }
            .drive(inputText)
            .disposed(by: disposeBag)
        
        // output
        inputText
            .map { $0 ? "올바른 이메일 형식입니다." : "올바르지 않은 이메일 형식입니다."}
            .bind(to: bindLabel.rx.text)
            .disposed(by: disposeBag)
        
        inputText
            .map { $0 ? UIColor.systemGreen : UIColor.systemRed}
            .bind(to: bindLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
    
    private func isValid(id: String) -> Bool {
        return id.contains("@") && id.contains(".")
    }
}
