//
//  SearchMovieViewController.swift
//  BasicMovieApp
//
//  Created by Madduck on 18.10.2021.
//

import UIKit

class SearchMovieViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : SearchMovieModel? {
        didSet {
            configureViewModel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = SearchMovieModel.init(state: SeatchMovieState())
        configureUI()
    }
    
    private func configureViewModel() {
        viewModel?.stateChangeHandler = { [weak self] change in
            guard let self = self else {return}
            switch change {
            case .loading:
                print("start activity indicator")
            case .fetched:
                self.tableView.reloadData()
            case .erroOccured(let error):
                print(error ?? "")
            }
        }
    }
    
    func configureUI() {
        tableView.register(MovieCell().nib(), forCellReuseIdentifier: MovieCell.identifier) 
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.searchBar.showsCancelButton = true
    }
    
    func routeToDetail(show movie :MoviesPresentation) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasicMovieDetailViewController") as! MovieDetailViewController
        
        vc.movie = movie
        show(vc, sender: nil)
    }
    
}

extension SearchMovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.state.searchMoviePresentations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {return UITableViewCell()}
        cell.configure(with: viewModel?.state.searchMoviePresentations[indexPath.row])
        return cell
    }
    
}

extension SearchMovieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let moveList = viewModel?.state.searchMoviePresentations else {return}
        routeToDetail(show: (moveList[indexPath.row]))
    }
}

extension SearchMovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.fetchSearch(with: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}
