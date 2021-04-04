//
//  GridViewController.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class GridViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: GridViewModelProtocol = GridViewModel()
    
    private enum CellName {
        static let item = "item_cell"
    }
    private let disposeBag = DisposeBag()
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<GridSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
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
        title = "Grid Layout"
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
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

// MARK: - RxDataSources

typealias GridSectionModel = AnimatableSectionModel<GridSection, GridSectionItem>

enum GridSection: String, IdentifiableType {
    case main
    var identity: String {
        rawValue
    }
}

enum GridSectionItem: IdentifiableType, Equatable {
    case item(Int)
    
    var identity: Int {
        switch self {
        case .item(let id):
            return id
        }
    }
}
