//
//  CountryNames.swift
//  NewsApp
//
//  Created by Артем Тихонов on 28.07.2022.
//

import Foundation

///перечисление со странами для выбора
enum country:String,CaseIterable {
    case ru
    case us
    case ua
    var currentName:String {
        switch self {
        case .ru:
            return "Russia"
        case .us:
            return "USA"
        case .ua:
            return "Ukraine"
        }
    }
}
