//
//  MainViewController.swift
//  NewsApp
//
//  Created by Артем Тихонов on 26.07.2022.
//

import UIKit

class MainViewController: UIViewController {
    private let userDefaults = UserDefaults.standard
    private var newsService = NewsService()
    private var news: News?
    private var currentPage:Int = 1
    private var isLoading:Bool = false
    var currentCountry:String {
        let userDefaults = UserDefaults.standard
        guard let country = userDefaults.string(forKey: "currentCountry")
        else {
            return "ru"
        }
        return country
    }
    
    private var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var langMenu:UIMenu{
        let menuActions = country.allCases.map({(country) -> UIAction in
            return UIAction(title: country.currentName , image: nil) { (_) in
                self.changeCountry(country: country.rawValue)
            }
        })
        
        return UIMenu(title: "Change country", children: menuActions)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        setupNavigationBar()
        setupTableView()
        setupConstraints()
        setupRefreshControl()
        loadNews(country: currentCountry,page: currentPage)
    }
    
    
    ///настройка tableView
    func setupTableView(){
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.frame = view.bounds
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        view.addSubview(tableView)
    }
    
    ///настройка navigationBar, возможность выбора страны
    func setupNavigationBar(){
        let langImage = UIImage(systemName: "flag")
        let langBarButtonItem = UIBarButtonItem(title: nil, image: langImage, primaryAction: nil, menu: langMenu)
        langBarButtonItem.tintColor = .gray
        navigationItem.rightBarButtonItem = langBarButtonItem
    }
            
    func changeCountry(country:String){
        userDefaults.set(country, forKey: "currentCountry")
        currentPage = 1
        loadNews(country:currentCountry,page:currentPage)
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
        currentPage = 1
        loadNews(country: currentCountry,page:currentPage)
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
        if news?.totalResults ?? 0 < 20*(currentPage){
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { action, _, complete in
            complete(true)
        }
        
        action.image = UIImage(systemName: "star.fill")
        action.backgroundColor = .systemYellow
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        return swipeAction
    }
}


///расширение, в котором описывается работа с сервером
extension MainViewController {
    func loadNews(country:String,page:Int){
        newsService.getNews(country: country,page: page) {[weak self] result in
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
    
    func dopLoadNews(country:String,page:Int){
        newsService.getNews(country: country,page: page) {[weak self] result in
            switch result {
            case .success(let newsData):
                DispatchQueue.main.async {
                    self?.dopNews(newNews: newsData)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func dopNews(newNews:News){
        self.news?.articles?.append(contentsOf: newNews.articles ?? [])
    }
}

extension MainViewController:UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard
            let maxRow = indexPaths.map({$0.row }).max(),
            let totalResults = news?.totalResults
        else{return}
        if  maxRow > 18+((currentPage-1)*20) {
            if totalResults/20 >= currentPage,
                !isLoading
            {
                self.isLoading = true
                currentPage+=1
                dopLoadNews(country: currentCountry, page: currentPage)
                isLoading = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
