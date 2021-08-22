//
//  ViewController.swift
//  Eats!
//
//  Created by Randy Hill on 8/16/21.
//

import UIKit

class RestaurantsView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var data = Database.testData
    private let cellHeight: CGFloat = 104.0
     
    var restaurants: [Restaurant] {
        let searchText = (searchField.text ?? "").lowercased()
        guard searchText.count > 0 else {
            return data
        }
        return data.filter { restaurant in
            return restaurant.name.lowercased().contains(searchText)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup filter button
        filterButton.layer.borderWidth = 1.0
        filterButton.layer.borderColor = UIColor.eatsGrayBorder.cgColor
        filterButton.layer.cornerRadius = 8.0
        
        // Setup search field with right side icon image and delegate callbacks.
        guard let searchImage = UIImage(named: "SearchIcon") else {
            return Log.fail("Search image not in bundle")
        }
        let filterImageView = UIImageView(image: searchImage)
        searchField.addSubview(filterImageView)
        filterImageView.translatesAutoresizingMaskIntoConstraints = false
        filterImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        filterImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        filterImageView.topAnchor.constraint(equalTo: searchField.topAnchor, constant: 4).isActive = true
        filterImageView.rightAnchor.constraint(equalTo: searchField.rightAnchor, constant: -4).isActive = true
        
        // Get search text field changes
        searchField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(searchFieldChanged), name: UITextField.textDidChangeNotification, object: nil)
        
        // Setup table layout
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = cellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: RestaurantCell.reuseIdentifier)
        tableView.backgroundColor = UIColor.eatsTableBackground
   }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    // MARK: ACTIONS ---------------------------------------------------------------------------------

    @IBAction func filterAction(_ sender: Any) {
        tableView.reloadData()
    }
    
    @objc func searchFieldChanged() {
        tableView.reloadData()
    }
}

// MARK: TableView ---------------------------------------------------------------------------------
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

