//
//  BookSearchViewController.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BookSearchViewController: UIViewController {

    private let viewModel = SearchBookViewModel()
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsSearchResultsButton
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraint()
        bind()
    }
    
    private func setView() {
        [searchBar, tableView].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    private func setConstraint() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(15)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
    }
    
    private func bind() {
        // input
        searchBar.rx.searchButtonClicked
            .asObservable()
            .bind(to: viewModel.buttonTapped)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .asDriver()
            .drive(viewModel.inputText)
            .disposed(by: disposeBag)
        
        // output
        viewModel.cellData
            .drive(tableView.rx.items(cellIdentifier: BookTableViewCell.id, cellType: BookTableViewCell.self)) { row, item, cell in
            cell.configuration(item: item)
        }.disposed(by: disposeBag)
    }
}
