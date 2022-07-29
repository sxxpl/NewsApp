//
//  NewsJSONData.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import Foundation
import RealmSwift

///модель для парсинга и  сохранения в Realm
final class News:Object, Decodable {
    @objc dynamic var totalResults:Int = 0
    var articles = List<NewsArticles>()
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        articles = try container.decode(List<NewsArticles>.self, forKey: .articles)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
    }
    enum CodingKeys:String, CodingKey {
        case totalResults
        case articles
    }
    
    
}

class NewsArticles:Object, Decodable{
    @objc dynamic var source:ArticleSourse?
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    @objc dynamic var urlToImage:String? = nil
    @objc dynamic var publishedAt = ""
    
    enum CodingKeys:String, CodingKey {
        case source = "source"
        case title = "title"
        case url = "url"
        case urlToImage = "urlToImage"
        case publishedAt = "publishedAt"
    }
    
    override class func primaryKey() -> String? {
        "title"
    }
    
}

class ArticleSourse:Object,Decodable{
    @objc dynamic var name = ""
    
    enum CodingKeys:String, CodingKey {
        case name = "name"
    }
}

//struct NewsRealm:Codable {
//    var totalResults:Int
//    var articles:[NewsArticles]?
//}
//
//struct NewsArticles:Codable{
//    var source:ArticleSourse
//    var title:String
//    var url:String
//    var urlToImage:String?
//    var publishedAt:String
//}
//
//struct ArticleSourse:Codable{
//    var name:String
//}
