//
//  BookTableViewCell.swift
//  HelloRx
//
//  Created by 여성일 on 3/5/24.
//

import UIKit
import SnapKit

class BookTableViewCell: UITableViewCell {

    static let id: String = "BookTableViewCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
        setContsraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCell() {
        self.addSubview(label)
    }
    private func setContsraint() {
        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
    }

    func configuration(item: Document) {
        label.text = item.title
    }

}
