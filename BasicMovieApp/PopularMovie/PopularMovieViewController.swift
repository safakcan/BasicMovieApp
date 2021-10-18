//
//  ViewController.swift
//  BasicMovieApp
//
//  Created by Madduck on 14.10.2021.
//

import UIKit

class PopularMovieViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var currentPage : Int = 1
    var viewModel: PopularMovieViewModel? {
        didSet {
            configureViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.viewModel = PopularMovieViewModel(state: PopularMovieState())
        viewModel?.fetchPopular(with: self.currentPage)
        
    }
    
    func configureUI() {
        tableView.register(MovieCell().nib(), forCellReuseIdentifier: MovieCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureViewModel() {
        viewModel?.stateChangedHandler = { [weak self] change in
            guard let self = self else {return}
            switch change {
            case .loading:
                print("start activity indicator")
            case .fetched:
                self.currentPage += 1
                self.tableView.reloadData()
            case .erroOccured(let error):
                print(error ?? "")
            }
        }
    }
    
    
    func routeToDetail(show movie :MoviesPresentation) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BasicMovieDetailViewController") as! MovieDetailViewController
        
        vc.movie = movie
        show(vc, sender: nil)
    }
}

extension PopularMovieViewController: UITableViewDataSource {
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

extension PopularMovieViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewmodel = viewModel else {return}
        if !(indexPath.row + 1 < viewmodel.state.moviePresentations.count) {
            self.viewModel?.fetchPopular(with: self.currentPage)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let moveList = viewModel?.state.moviePresentations else {return}
        routeToDetail(show: (moveList[indexPath.row]))
    }
}
