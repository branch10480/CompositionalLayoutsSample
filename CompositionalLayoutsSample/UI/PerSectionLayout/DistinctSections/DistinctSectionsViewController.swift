//
//  DistinctSectionsViewController.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DistinctSectionsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: DistinctSectionsViewModelProtocol = DistinctSectionsViewModel()
    
    private enum CellName {
        static let list = "list_cell"
        static let grid = "grid_cell"
    }
    private let disposeBag = DisposeBag()
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<DistinctSectionsSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
        let section = dataSource.sectionModels[indexPath.section].model
        
        switch item {
        case .item(let value):
            switch section {
            case .list:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName.list, for: indexPath) as! ListCollectionViewCell
                cell.configure(value.description)
                return cell
            case .grid5, .grid3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellName.grid, for: indexPath) as! CollectionViewCell
                cell.configure(value.description)
                return cell
            }
        }
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    private func setup() {
        title = "Distinct Sections Layout"
        collectionView.register(
            UINib(nibName: "ListCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CellName.list
        )
        collectionView.register(
            UINib(nibName: "CollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: CellName.grid
        )
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func bind() {
        viewModel.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionData = DistinctSectionsSection(rawValue: sectionIndex) else {
                return nil
            }
            let columnCount = sectionData.columnCount
            
            // 幅は後ほど自動計算されるのでここで指定する幅は無視される！
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )
            
            let groupHeight: NSCollectionLayoutDimension = columnCount == 1 ?
                .absolute(44) :
                .fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: groupHeight
            )
            // ここで1行あたりの数を指定している count: Int
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columnCount)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(
                top: 20,
                leading: 20,
                bottom: 20,
                trailing: 20
            )
            return section
        }
        return layout
    }

}

// MARK: - UICollectionViewDelegate

extension DistinctSectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - RxDataSources

typealias DistinctSectionsSectionModel = AnimatableSectionModel<DistinctSectionsSection, DistinctSectionsSectionItem>

enum DistinctSectionsSection: Int, CaseIterable, IdentifiableType {
    case list
    case grid5
    case grid3
    
    var identity: Int {
        rawValue
    }
    
    var columnCount: Int {
        switch self {
        case .list: return 1
        case .grid3: return 3
        case .grid5: return 5
        }
    }
}

enum DistinctSectionsSectionItem: IdentifiableType, Equatable {
    case item(Int)
    
    var identity: Int {
        switch self {
        case .item(let id):
            return id
        }
    }
}
