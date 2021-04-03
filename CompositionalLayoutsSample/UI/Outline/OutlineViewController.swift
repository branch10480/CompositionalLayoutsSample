//
//  OutlineViewController.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class OutlineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: OutlineViewModelProtocol!
    
    private let disposeBag = DisposeBag()
    private let dataSource = RxTableViewSectionedAnimatedDataSource<OutlineSectionModel>(configureCell: { (dataSource, tableView, indexPath, item) in
        switch item {
        case .item(let menu):
            let cell = tableView.dequeueReusableCell(withIdentifier: CellName.item, for: indexPath) as! OutlineTableViewCell
            let viewData = OutlineTableViewCellViewData(title: menu.title)
            cell.configure(viewData)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    })
    private enum CellName {
        static let item = "item_cell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = OutlineViewModel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind()
    }
    
    private func setup() {
        title = "Compositional Layouts"
        tableView.register(UINib(nibName: "OutlineTableViewCell", bundle: nil), forCellReuseIdentifier: CellName.item)
        tableView.tableFooterView = .init()
    }
    
    private func bind() {
        viewModel.menuSections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

}

// MARK: - UITableViewDelegate

extension OutlineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - RxDataSources

typealias OutlineSectionModel = AnimatableSectionModel<OutlineSection, OutlineSectionItem>

enum OutlineSection: String, IdentifiableType {
    case basic = "Basic"
    case advanced = "Advanced"
    
    var identity: String {
        rawValue
    }
}

enum OutlineSectionItem: IdentifiableType, Equatable {
    case item(OutlineMenu)
    
    var identity: String {
        switch self {
        case .item(let menu):
            return menu.title
        }
    }
    
    static func == (lhs: OutlineSectionItem, rhs: OutlineSectionItem) -> Bool {
        switch (lhs, rhs) {
        case (.item(let menuLhs), .item(let menuRhs)):
            return menuLhs.title == menuRhs.title
        }
    }
}

struct OutlineMenu {
    var title: String
    var viewControllerType: UIViewController.Type
}
