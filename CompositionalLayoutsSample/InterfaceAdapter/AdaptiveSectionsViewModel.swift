//
//  AdaptiveSectionsViewModel.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/03.
//

import Foundation
import RxSwift
import RxRelay

protocol AdaptiveSectionsViewModelProtocol {
    var sections: Observable<[AdaptiveSectionsSectionModel]> { get }
}

final class AdaptiveSectionsViewModel: AdaptiveSectionsViewModelProtocol {
    
    let sections: Observable<[AdaptiveSectionsSectionModel]>
    
    init() {
        let itemsList = Array(0..<5).map { AdaptiveSectionsSectionItem.item($0) }
        let sectionList = AdaptiveSectionsSectionModel(model: .list, items: itemsList)
        
        let itemsGrid5 = Array(0..<10).map { AdaptiveSectionsSectionItem.item($0) }
        let sectionGrid5 = AdaptiveSectionsSectionModel(model: .grid5, items: itemsGrid5)
        
        let itemsGrid3 = Array(0..<10).map { AdaptiveSectionsSectionItem.item($0) }
        let sectionGrid3 = AdaptiveSectionsSectionModel(model: .grid3, items: itemsGrid3)
        
        self.sections = Observable.just([sectionList, sectionGrid5, sectionGrid3])
    }
}
