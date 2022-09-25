//
//  Reusable.swift
//  vkontakteVS
//
//  Created by Home on 23.08.2021.
//

import UIKit

protocol Reusable {
    static var reuseIdentifire: String { get }
    static var nib: UINib { get }
}

extension Reusable {
    static var reuseIdentifire: String {
        String(describing: self)
    }
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: nil)
    }
}

extension UIView: Reusable {}

extension UICollectionView {
    func register<Cell: UICollectionViewCell> (_:Cell.Type) {
        self.register(Cell.nib, forCellWithReuseIdentifier: Cell.reuseIdentifire)
    }
    
    func registerClass<Cell: UICollectionViewCell> (_:Cell.Type) {
        self.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifire)
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell> (_:Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifire, for: indexPath) as? Cell
        else {
            fatalError("Message: Error in dequeue \(Cell.reuseIdentifire)")}
        return cell
    }
}
