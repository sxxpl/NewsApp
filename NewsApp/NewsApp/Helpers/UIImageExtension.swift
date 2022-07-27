//
//  UIImageExtension.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import UIKit

extension UIImageView {

    ///метод загрузки изображений с помощью url
    func loadImage(_ imageUrl: String) {

        guard let url = URL(string: imageUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, let response = response else {
                print("error", error?.localizedDescription ?? "not localizedDescription")
                return
            }
            
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
}

