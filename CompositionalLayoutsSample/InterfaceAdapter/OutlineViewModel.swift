//
//  OutlineViewModel.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/03.
//

import Foundation
import RxSwift
import RxRelay

protocol OutlineViewModelProtocol {
    var menuSections: Observable<[OutlineSectionModel]> { get }
}

final class OutlineViewModel: OutlineViewModelProtocol {
    
    let menuSections: Observable<[OutlineSectionModel]>
    
    private let menuSectionsRelay = BehaviorRelay<[OutlineSectionModel]>(value: [])
    
    init() {
        self.menuSections = self.menuSectionsRelay.asObservable()
        self.setupMenuItems()
    }
    
    private func setupMenuItems() {
        let basicSection = OutlineSectionModel(model: .basic, items: [
            .item(OutlineMenu(title: "Grid Layout", viewControllerType: GridViewController.self))
        ])
        let advancedSection = OutlineSectionModel(model: .advanced, items: [
        ])
        let sections: [OutlineSectionModel] = [basicSection, advancedSection]
        self.menuSectionsRelay.accept(sections)
    }
}
