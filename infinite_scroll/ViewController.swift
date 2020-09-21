//
//  ViewController.swift
//  infinite_scroll
//
//  Created by Anjas Dwi on 11/08/20.
//  Copyright © 2020 Anjas Dwi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    private let apiCaller = APICaller()
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
         return tableView
    }()
    
    private var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        apiCaller.fetchData(pagination: false, completion: { result in
            switch result {
            case .success(let data):
                self.data.append(contentsOf: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
            
        })
        
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let positionY = scrollView.contentOffset.y
        if positionY > (tableView.contentSize.height-100-scrollView.frame.size.height) {
            guard !apiCaller.isPagination else {
                return
            }
            print("fetch more")
            self.tableView.tableFooterView = createSpinnerFooter()
            
            apiCaller.fetchData(pagination: true) { [weak self] result in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                switch result{
                case .success(let moreData):
                    self?.data.append(contentsOf: moreData)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(_):
                    break
                }
                
            }
        }
    }

}

