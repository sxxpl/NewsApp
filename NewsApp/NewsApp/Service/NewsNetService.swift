//
//  NewsNetService.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import Foundation
import Alamofire

///сервис получения новостей
class NewsService {
    
    let baseUrl = "https://newsapi.org/v2/top-headlines"
    
    let apiKey = "011f695769fc45c9923e37505a53c65d"
    
    
    ///метод получения новостей для определенной страны
    func getNews(country:String,page:Int,completion:@escaping (Swift.Result<News,Error>) -> ()) {
        let parameters:Parameters = [
            "apiKey" : apiKey,
            "country" : country,
            "page": page,
            "pageSize": 20
        ]
        AF.request(baseUrl, parameters: parameters).responseData { response in
            guard let data = response.value else {
                return
            }
            do {
    
                let news = try JSONDecoder().decode(News.self, from: data)
                print(news)
                completion(.success(news))
            } catch {
                print(error)
            }
        }
    }
    
    
    ///получение данных с параметром q (поиск по новостям)
    func getNewsWithSearch(country:String,page:Int,q:String,completion:@escaping (Swift.Result<News,Error>) -> ()) {
        let parameters:Parameters = [
            "apiKey" : apiKey,
            "country" : country,
            "page": page,
            "pageSize": 20,
            "q":q
        ]
        AF.request(baseUrl, parameters: parameters).responseData { response in
            guard let data = response.value else {
                return
            }
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                completion(.success(news))
            } catch {
                print(error)
            }
        }
    }
}
