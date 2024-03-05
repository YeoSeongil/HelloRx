//
//  ExBindViewController.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ExBindViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.placeholder = "텍스트를 입력해보세요."
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
        let inputText = BehaviorRelay(value: "")
        
        // basic bind
        //input
//        textField.rx.text.orEmpty
//            .subscribe { text in
//                inputText.on(.next(text))
//            }.disposed(by: disposeBag)
        
        //output
//        inputText
//            .map {"바인딩 텍스트 : \($0)"}
//            .subscribe { [weak self] text in
//                self?.bindLabel.rx.text.on(.next(text))
//            }.disposed(by: disposeBag)
        
        // rx Bind
        // input
        textField.rx.text.orEmpty
            .asDriver()
            .drive(inputText)
            .disposed(by: disposeBag)
        
        // output
        inputText
            .map { "바인딩 텍스트 : \($0)"}
            .bind(to: bindLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
