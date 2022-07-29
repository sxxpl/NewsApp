//
//  FavoriteViewController.swift
//  NewsApp
//
//  Created by Артем Тихонов on 29.07.2022.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {

    private var favoriteNews: [NewsArticles] = []
    
    private var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorite news"
        setupTableView()
        setupConstraints()
        setupRefreshControl()
        loadNews()
    }
    
    
    ///настройка tableView
    func setupTableView(){
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.frame = view.bounds
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        view.addSubview(tableView)
    }
            
    
    ///настройка констреинтов tableView
    func setupConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
    
    func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = .black
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews(){
        loadNews()
        tableView.refreshControl?.endRefreshing()
    }
}


extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
        cell.configure(author: favoriteNews[indexPath.row].source?.name ?? "author", news: favoriteNews[indexPath.row].title ,imageUrl: (favoriteNews[indexPath.row].urlToImage) ?? nil)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteNews.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let url = URL(string: favoriteNews[indexPath.row].url)
        else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let action = UIContextualAction(style: .destructive, title: nil) { [weak self]_, _, complete in
                guard let deleteNews = self?.favoriteNews[indexPath.row] else {
                    complete(true)
                    return
                }
                do {
                    let realm = try Realm()
                    realm.beginWrite()
                    realm.delete(deleteNews)
                    try realm.commitWrite()
                    DispatchQueue.main.async {
                        self?.favoriteNews.remove(at: indexPath.row)
                        self?.tableView.deleteRows(at: [indexPath], with: .left)
                        self?.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
                complete(true)
            }
    
            action.image = UIImage(systemName: "delete.left.fill")
            let swipeAction = UISwipeActionsConfiguration(actions: [action])
            return swipeAction
        }
}


///расширение, в котором описывается работа с realm
extension FavoriteViewController {
    func loadNews(){
        do {
            let realm = try Realm()
            DispatchQueue.main.async {
                let result = realm.objects(NewsArticles.self)
                self.favoriteNews.removeAll()
                for i in 0..<result.count {
                    self.favoriteNews.append(result[result.count-1-i])
                }
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
}


