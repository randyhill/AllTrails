//
//  ViewController.swift
//  Eats!
//
//  Created by Randy Hill on 8/16/21.
//

import UIKit
import MapKit

class RestaurantsController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // Constants
    private let cellHeight: CGFloat = 104.0

    // Settign view style determines whether we display map or list.
    enum Style {
        case list, map(locations: [Restaurant])
        
        var toggle: Style {
            switch self {
            case .list:
                return .map(locations: Database.testData)
            case .map(_):
                return .list
            }
        }
    }
    
    private var viewStyle: Style = .list {
        didSet {
            setViewTo(viewStyle)
        }
    }
     
    // Restaurants returns filtered data based on search text
    var data = Database.testData
    var restaurants: [Restaurant] {
        let searchText = (searchField.text ?? "").lowercased()
        guard searchText.count > 0 else {
            return data
        }
        return data.filter { model in
            if model.name.lowercased().contains(searchText) { return true }
            if model.bodyText.lowercased().contains(searchText) { return true }
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Match map view to list view first
        mapView.isHidden = true
        mapView.delegate = self

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
        filterImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        filterImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        filterImageView.topAnchor.constraint(equalTo: searchField.topAnchor, constant: 0).isActive = true
        filterImageView.rightAnchor.constraint(equalTo: searchField.rightAnchor, constant: -4).isActive = true
        
        // Get search text field changes
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
        
        
        // Make toggle button front most
        toggleButton.contentHorizontalAlignment = .fill
        toggleButton.contentVerticalAlignment = .fill
        toggleButton.contentMode = .scaleAspectFill
        view.bringSubviewToFront(toggleButton)
   }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    // Swap map view in front of tableview and vica versa when view style changes.
    func setViewTo(_ newStyle: Style) {
        var frontView: UIView
        switch newStyle {
        case .list:
            mapView.isHidden = true
            frontView = tableView
            toggleButton.setImage(UIImage(named: "MapButton"), for: .normal)
        case .map(let restaurants):
            tableView.isHidden = true
            frontView = mapView
            toggleButton.setImage(UIImage(named: "ListButton"), for: .normal)
            
            mapView.removeAnnotations(mapView.annotations)
            let annotations = restaurants.map { restaurant in
                return restaurant.annotation
            }
            mapView.addAnnotations(annotations)
        }
        // button always in front
        self.view.bringSubviewToFront(frontView)
        self.view.bringSubviewToFront(self.toggleButton)
        frontView.isHidden = false
     }
    
    // MARK: ACTIONS ---------------------------------------------------------------------------------

    @IBAction func toggleAction(_ sender: Any) {
        viewStyle = viewStyle.toggle
    }
    
    @IBAction func filterAction(_ sender: Any) {
        searchField.text = ""
        tableView.reloadData()
    }
    
    @objc func searchFieldChanged() {
        tableView.reloadData()
    }
}

// MARK: TableView ---------------------------------------------------------------------------------
extension RestaurantsController: UITableViewDelegate, UITableViewDataSource {

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
        return true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

