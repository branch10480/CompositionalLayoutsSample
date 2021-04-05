//
//  GridViewModel.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/03.
//

import Foundation
import RxSwift
import RxRelay

protocol GridViewModelProtocol {
    var sections: Observable<[GridSectionModel]> { get }
}

final class GridViewModel: GridViewModelProtocol {
    
    let sections: Observable<[GridSectionModel]>
    
    init() {
        let items = Array(0..<94).map { GridSectionItem.item($0) }
        let section = GridSectionModel(model: .main, items: items)
        self.sections = Observable.just([section])
    }
}
