//
//  MainViewController.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private var newsService = NewsService()
    private var news: News?
    
    private var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
        setupRefreshControl()
        loadNews(country: "ru")
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
        loadNews(country: "ru")
        tableView.refreshControl?.endRefreshing()
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier) as! NewsTableViewCell
            cell.configure(author: news?.articles?[indexPath.row].source.name ?? "author", news: news?.articles?[indexPath.row].title ?? "news",imageUrl: (news?.articles?[indexPath.row].urlToImage) ?? nil)
            cell.selectionStyle = .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if news?.totalResults ?? 0 < 20{
            return news?.totalResults ?? 0
        } else {
            return 20
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let stringUrl = news?.articles?[indexPath.row].url,
            let url = URL(string: stringUrl)
        else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}


///расширение, в котором описывается работа с сервером
extension MainViewController {
    func loadNews(country:String){
        newsService.getNews(country: country) {[weak self] result in
            switch result {
            case .success(let newsData):
                DispatchQueue.main.async {
                    self?.news = newsData
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//extension MainViewController:UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        <#code#>
//    }
//}
