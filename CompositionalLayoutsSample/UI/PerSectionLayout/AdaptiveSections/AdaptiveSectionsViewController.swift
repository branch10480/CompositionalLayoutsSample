//
//  AdaptiveSectionsViewController.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AdaptiveSectionsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: AdaptiveSectionsViewModelProtocol = AdaptiveSectionsViewModel()
    
    private enum CellName {
        static let list = "list_cell"
        static let grid = "grid_cell"
    }
    private let disposeBag = DisposeBag()
    private let dataSource = RxCollectionViewSectionedAnimatedDataSource<AdaptiveSectionsSectionModel>(configureCell: { dataSource, collectionView, indexPath, item in
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
        title = "Adaptive Sections Layout"
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
            
            guard let sectionData = AdaptiveSectionsSection(rawValue: sectionIndex) else {
                return nil
            }
            let width = layoutEnvironment.container.effectiveContentSize.width
            let columnCount = sectionData.columnCount(for: width)
            
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
            
            let groupHeight: NSCollectionLayoutDimension = columnCount <= 2 ?
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

extension AdaptiveSectionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - RxDataSources

typealias AdaptiveSectionsSectionModel = AnimatableSectionModel<AdaptiveSectionsSection, AdaptiveSectionsSectionItem>

enum AdaptiveSectionsSection: Int, CaseIterable, IdentifiableType {
    case list
    case grid5
    case grid3
    
    var identity: Int {
        rawValue
    }
    
    func columnCount(for width: CGFloat) -> Int {
        let widthMode = width > 800
        switch self {
        case .list: return widthMode ? 2 : 1
        case .grid3: return widthMode ? 6 : 3
        case .grid5: return widthMode ? 10 : 5
        }
    }
}

enum AdaptiveSectionsSectionItem: IdentifiableType, Equatable {
    case item(Int)
    
    var identity: Int {
        switch self {
        case .item(let id):
            return id
        }
    }
}
