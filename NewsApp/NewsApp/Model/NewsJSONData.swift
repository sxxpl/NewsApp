//
//  NewsJSONData.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import Foundation


///структуры для парсинга новостей
struct News:Codable {
    var totalResults:Int
    var articles:[NewsArticles]?
}

struct NewsArticles:Codable{
    var source:ArticleSourse
    var title:String
    var url:String
    var urlToImage:String?
    var publishedAt:String
}

struct ArticleSourse:Codable{
    var name:String
}
