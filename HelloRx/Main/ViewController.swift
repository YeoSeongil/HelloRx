//
//  ViewController.swift
//  HelloRx
//
//  Created by 여성일 on 3/4/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {

    private var disposeBag = DisposeBag()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraint()
        bind()
    }
    
    private func setView() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        title = "HelloRx"
    }
    
    private func setConstraint() {
        tableView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        let tableViewItem = Observable<[String]>.just(["asyncImageLoad", "exLogin"])
        
        tableViewItem.bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.id, cellType: MainTableViewCell.self)) { row, item, cell in
            cell.configuration(item: item)
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                switch indexPath.row {
                case 0:
                    //self?.present(AsyncImageLoadViewController(), animated: true)
                    self?.navigationController?.pushViewController(AsyncImageLoadViewController(), animated: true)
                case 1:
                    self?.navigationController?.pushViewController(exLoginViewController(), animated: true)
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
}

