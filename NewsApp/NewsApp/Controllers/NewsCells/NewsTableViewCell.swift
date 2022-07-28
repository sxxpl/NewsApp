//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    static let identifier: String = "TextCell"
    
    var uiImage:UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var authorLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var newsLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        uiImage.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabels(){
        authorLabel.textColor = .secondaryLabel
        authorLabel.font = .preferredFont(forTextStyle: .caption1)
        
        newsLabel.font = .preferredFont(forTextStyle: .title3)
        newsLabel.numberOfLines = 0
        
        uiImage.layer.cornerRadius = 8
        uiImage.layer.masksToBounds = true
    }
    
    private func setupConstraints(){
        contentView.addSubview(uiImage)
        contentView.addSubview(authorLabel)
        contentView.addSubview(newsLabel)
        NSLayoutConstraint.activate([
            uiImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            uiImage.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            uiImage.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            uiImage.heightAnchor.constraint(equalToConstant: 224),
            authorLabel.topAnchor.constraint(equalTo: uiImage.bottomAnchor, constant: 10),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            newsLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 3),
            newsLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            newsLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            newsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(author:String, news:String, imageUrl:String?){
        authorLabel.text = author
        newsLabel.text = news
        guard let url = imageUrl else {
            return
        }
        uiImage.loadImage(url)
    }
}
