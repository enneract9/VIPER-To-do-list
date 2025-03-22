//
//  ListViewPresentable.swift
//  VIPER To-do-list
//
//  Created by @_@ on 21.03.2025.
//

import Foundation

struct ListViewPresentable: Hashable {
    let id: String
    let title: String
    let description: String?
    let checkmarked: Bool
    let date: String
}
