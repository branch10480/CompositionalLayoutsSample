//
//  TwoColumnViewController.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TwoColumnViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: TwoColumnViewModelProtocol = TwoColumnViewModel()
    
    private enum CellName {
        static let item = "item_cell"
    }
    private let disposeBag = DisposeBag()
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<TwoColumnSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        switch item {
        case .item(let value):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName.item, for: indexPath) as! CollectionViewCell
            cell.configure(value.description)
            return cell
        }
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    private func setup() {
        title = "Two-Column Layout"
        collectionView.register(
            UINib(nibName: "CollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CellName.item
        )
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func bind() {
        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

// MARK: - RxDataSources

typealias TwoColumnSectionModel = AnimatableSectionModel<TwoColumnSection, TwoColumnSectionItem>

enum TwoColumnSection: String, IdentifiableType {
    case main
    var identity: String {
        rawValue
    }
}

enum TwoColumnSectionItem: IdentifiableType, Equatable {
    case item(Int)
    
    var identity: Int {
        switch self {
        case .item(let id):
            return id
        }
    }
}
