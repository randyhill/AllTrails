//
//  ViewController.swift
//  Eats!
//
//  Created by Randy Hill on 8/16/21.
//

import UIKit

class RestaurantsView: UIViewController {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var restaurants = Database.testData
    private let cellHeight: CGFloat = 96.0
    private var searchIconSize = CGSize()
    private let searchIconTag = 777
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup filter button
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.borderColor = UIColor.eatsGrayBorder.cgColor
        filterButton.layer.cornerRadius = 8.0
        
        // Setup search field
        guard let searchImage = UIImage(named: "SearchIcon") else {
            return Log.fail("Search image not in bundle")
        }
        searchIconSize = CGSize(width: searchImage.size.width/2, height: searchImage.size.width/2)
         let filterImageView = UIImageView(image: searchImage)
        filterImageView.tag = searchIconTag
        searchField.addSubview(filterImageView)
//        let margins = searchField.layoutMarginsGuide
//        filterImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 16.0).isActive = true
        
        // Setup table
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = cellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: RestaurantCell.reuseIdentifier)
        tableView.backgroundColor = UIColor.eatsTableBackground
   }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Position search icon at right edge of search field once view has been resized
        guard let searchIcon = searchField.viewWithTag(searchIconTag) else {
            return Log.error("Can't find search icon in search field")
        }
        let fieldSize = searchField.frame.size
        searchIcon.frame = CGRect(x: fieldSize.width - searchIconSize.width, y: (fieldSize.height - searchIconSize.height)/2, width: searchIconSize.width, height: searchIconSize.height)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func filterAction(_ sender: Any) {
        print("FILTER!!")
    }
}

extension RestaurantsView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
        return cellHeight //UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        return false
//    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 28.0
//    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as? RestaurantCell else {
            Log.error("Couldn't load Restaurant cell")
            return UITableViewCell()
        }
        guard let model = restaurants[safe: indexPath.row] else {
            Log.error("Index: \(indexPath.row) out of range in Restaurant list")
            return UITableViewCell()
        }
        cell.configure(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

