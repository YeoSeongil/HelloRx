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

    private let viewModel : SearchBookViewModelProtocol
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.id)
        return tableView
    }()
    
    init(viewModel: SearchBookViewModelProtocol = SearchBookViewModel()) {
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
            .bind(to: viewModel.tappedSearchButton)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .asDriver()
            .drive(viewModel.whichTitle)
            .disposed(by: disposeBag)
        
        // output
        viewModel.fetchedSearchOutput
            .drive(tableView.rx.items(cellIdentifier: BookTableViewCell.id, cellType: BookTableViewCell.self)) { row, item, cell in
            cell.configuration(item: item)
        }.disposed(by: disposeBag)
    }
}
