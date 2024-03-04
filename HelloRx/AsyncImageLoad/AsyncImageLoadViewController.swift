//
//  AsyncImageLoadViewController.swift
//  HelloRx
//
//  Created by 여성일 on 3/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AsyncImageLoadViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let loadImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("불러오기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraint()
        bind()
    }
    
    private func setView() {
        [imageView, loadImageButton, timeLabel].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    private func setConstraint() {
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(150)
            $0.horizontalEdges.equalToSuperview().inset(50)
        }        
        
        loadImageButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(50)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().offset(-50)
        }
    }
    
    private func bind() {
        Observable<Int>.timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .map{ String($0) }
            .bind(to: timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        // input
        let inputImage = PublishSubject<UIImage>()
        loadImageButton.rx.tap
            .bind {
                self.loadImage()
                    .subscribe { item in
                        inputImage.on(.next(item))
                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)

        // output
        inputImage
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    //
    
    func loadImage() -> Observable<UIImage> {
        print("Tapped")
        let url = URL(string: "https://source.unsplash.com/random")!
        return Observable<UIImage>.create { emitter in
            let task = URLSession.shared.dataTask(with: url) { data, _ , _ in
                guard let data = data else {
                    emitter.onCompleted()
                    return
                }
                
                let image = UIImage(data: data)
                emitter.onNext(image!)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}




