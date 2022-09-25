//
//  CollectionViewCell.swift
//  hw_lesson_5_preparing
//
//  Created by Home on 25.09.2022.
//

import UIKit

final public class CollectionViewCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfig()
    }
    
    private func initialConfig() {
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func config(with text: String?) {
        titleLabel.text = text
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.pin.horizontally().vCenter().sizeToFit(.width)
    }
}
