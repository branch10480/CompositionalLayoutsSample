//
//  OutlineViewController.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/01.
//

import UIKit

class OutlineViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    class OutlineItem: Hashable {
        
        let title: String
        let subitems: [OutlineItem]
        let outlineViewController: UIViewController.Type?

        private let identifier = UUID()
        
        init(
            title: String,
            vc: UIViewController.Type? = nil,
            subitems: [OutlineItem]
        ) {
            self.title = title
            self.subitems = subitems
            self.outlineViewController = vc
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
        
        static func == (lhs: OutlineViewController.OutlineItem, rhs: OutlineViewController.OutlineItem) -> Bool {
            return lhs.identifier == rhs.identifier
        }
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, OutlineItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = "Compositional Layouts"
    }

}
