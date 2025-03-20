//
//  CollectionViewPresentable.swift
//  VIPER To-do-list
//
//  Created by @_@ on 21.03.2025.
//

import Foundation

// DTO для ячеек коллекции
struct CollectionViewPresentable: Hashable {
    let id: String
    let title: String
    let description: String?
    let checkmarked: Bool
    let date: Date
}
