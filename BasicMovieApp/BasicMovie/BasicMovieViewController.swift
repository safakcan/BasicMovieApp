//
//  ViewController.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import UIKit

class BasicMovieViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var isLoadingList : Bool = false
    var currentPage : Int = 1
    var viewModel: BasicMovieViewModel? {
        didSet {
            configureViewModel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.viewModel = BasicMovieViewModel(state: BasicMovieState())
        viewModel?.fetchPopular(with: self.currentPage)
        
    }
    
    func configureUI() {
        tableView.register(MovieCell().nib(), forCellReuseIdentifier: MovieCell.identifier)
//        Rowheight dynamic
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.searchBar.showsCancelButton = true
    }
    
    private func configureViewModel() {
        viewModel?.stateChangedHandler = { [weak self] change in
            guard let self = self else {return}
            switch change {
            case .loading:
                print("start activity indicator")
            case .fetched:
                self.isLoadingList = false
                self.currentPage += 1
                self.tableView.reloadData()
            case .erroOccured(let error):
                print(error ?? "")
            }
        }
    }
    
    
    func rootToDetail(show movie :MoviesPresentation) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasicMovieDetailViewController") as! BasicMovieDetailViewController
        
        vc.movie = movie
        show(vc, sender: nil)
    }
}

extension BasicMovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.state.moviePresentations.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {return UITableViewCell()}
        cell.configure(with: viewModel?.state.moviePresentations[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension BasicMovieViewController: UITableViewDelegate {
    
//    Fetch pagination related to move.count -> willdisplaycell
//    isLoadingList should be at ViewModel
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height * 2/3 ) && !isLoadingList) {
            self.isLoadingList = true
            self.viewModel?.fetchPopular(with: self.currentPage)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        routeToDetail
        guard let moveList = viewModel?.state.moviePresentations else {return}
        rootToDetail(show: (moveList[indexPath.row]))
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 300
//    }
}

extension BasicMovieViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.fetchSearch(with: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewModel?.reinstallMoviePresentation()
        searchBar.resignFirstResponder()
    }
}
