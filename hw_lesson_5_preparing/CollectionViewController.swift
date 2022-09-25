//
//  CollectionViewController.swift
//  hw_lesson_5_preparing
//
//  Created by Home on 25.09.2022.
//

import UIKit
import Combine

final public class CollectionViewController: UICollectionViewController {
    
    private var subscriptions: [AnyCancellable] = []
    private let viewModel = CollectionViewModel()
    private let input: PassthroughSubject<CollectionViewModel.Input, Never> = .init()
    private var results: SearchResult?
    
    init() {
        let width = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: width, height: 100)
        super.init(collectionViewLayout: layout)
        initialConfig()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func initialConfig() {
        collectionView?.registerClass(CollectionViewCell.self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { event in
            switch event {
            case .searchQueryError(let error):
                print(error.localizedDescription)
            case .searchQuerySucceed(searchResults: let searchResults):
                self.configCollectionView(searchResults: searchResults)
            }
        }
        .store(in: &subscriptions)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        input.send(.viewDidAppeare)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.pin.all()
    }
    
    private func configCollectionView(searchResults: SearchResult) {
        self.results = searchResults
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results?.result.count ?? 0
    }
        
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(CollectionViewCell.self, for: indexPath)
        cell.config(with: results?.result[indexPath.row]?.value)
        return cell
    }

}
