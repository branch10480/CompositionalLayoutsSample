//
//  DistinctSectionsViewModel.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/03.
//

import Foundation
import RxSwift
import RxRelay

protocol DistinctSectionsViewModelProtocol {
    var sections: Observable<[DistinctSectionsSectionModel]> { get }
}

final class DistinctSectionsViewModel: DistinctSectionsViewModelProtocol {
    
    let sections: Observable<[DistinctSectionsSectionModel]>
    
    init() {
        let itemsList = Array(0..<5).map { DistinctSectionsSectionItem.item($0) }
        let sectionList = DistinctSectionsSectionModel(model: .list, items: itemsList)
        
        let itemsGrid5 = Array(0..<10).map { DistinctSectionsSectionItem.item($0) }
        let sectionGrid5 = DistinctSectionsSectionModel(model: .grid5, items: itemsGrid5)
        
        let itemsGrid3 = Array(0..<10).map { DistinctSectionsSectionItem.item($0) }
        let sectionGrid3 = DistinctSectionsSectionModel(model: .grid3, items: itemsGrid3)
        
        self.sections = Observable.just([sectionList, sectionGrid5, sectionGrid3])
    }
}
