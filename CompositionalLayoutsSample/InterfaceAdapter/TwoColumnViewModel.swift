//
//  TwoColumnViewModel.swift
//  CompositionalLayoutsSample
//
//  Created by branch10480 on 2021/04/03.
//

import Foundation
import RxSwift
import RxRelay

protocol TwoColumnViewModelProtocol {
    var sections: Observable<[TwoColumnSectionModel]> { get }
}

final class TwoColumnViewModel: TwoColumnViewModelProtocol {
    
    let sections: Observable<[TwoColumnSectionModel]>
    
    init() {
        let items = Array(0..<94).map { TwoColumnSectionItem.item($0) }
        let section = TwoColumnSectionModel(model: .main, items: items)
        self.sections = Observable.just([section])
    }
}
