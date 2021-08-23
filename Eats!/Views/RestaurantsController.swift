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
    
    private let refreshControl = UIRefreshControl()

    // Constants
    private let cellHeight: CGFloat = 104.0

    // Setting view style determines whether we display map or list.
    enum Style: Equatable {
        case list, map(locations: [Restaurant])
        
        var toggle: Style {
            switch self {
            case .list:
                return .map(locations: Database.data)
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
    private var data = [Restaurant]()
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
        mapView.showsUserLocation = true

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
        
        // Setup table layout
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = cellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: RestaurantCell.reuseIdentifier)
        
        // Refresh control
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchNewData), for: .valueChanged)
        
        // Make toggle button front most
        toggleButton.contentHorizontalAlignment = .fill
        toggleButton.contentVerticalAlignment = .fill
        toggleButton.contentMode = .scaleAspectFill
        view.bringSubviewToFront(toggleButton)
        
        // Observe notifications for search text field changes, data refreshes and no locations
        NotificationCenter.default.addObserver(self, selector: #selector(RestaurantsController.filterViewAction), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataRefreshed), name: Database.dataRefreshed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noLocationPermissions), name: Locations.noPermissions, object: nil)
        
        // Add tap areas to dimiss keyboard from
        let mapTapped = UITapGestureRecognizer(target: self, action: #selector(RestaurantsController.dismissKeyboardAction))
        mapView.addGestureRecognizer(mapTapped)
        let viewTapped = UITapGestureRecognizer(target: self, action: #selector(RestaurantsController.dismissKeyboardAction))
        view.addGestureRecognizer(viewTapped)


        // Start with test data in case we don't have internet access.
        data = Database.testData
   }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Locations.shared.start()
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
            
            setMapToRestaurants(restaurants)
        }
        // button always in front
        self.view.bringSubviewToFront(frontView)
        self.view.bringSubviewToFront(self.toggleButton)
        frontView.isHidden = false
     }
    
    func setMapToRestaurants(_ restaurants: [Restaurant]) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = restaurants.map { restaurant in
            return restaurant.annotation
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    // MARK: ACTIONS ---------------------------------------------------------------------------------

    // User tapped List/Maps Button
    @IBAction func toggleViewAction(_ sender: Any) {
        viewStyle = viewStyle.toggle
    }
    
    @IBAction func clearAction(_ sender: Any) {
        searchField.text = ""
        tableView.reloadData()
    }
    
    @objc func filterViewAction() {
        if viewStyle == .list {
            tableView.reloadData()
        } else {
            setMapToRestaurants(restaurants)
        }
    }
    
    @objc func noLocationPermissions() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return Log.error("Could not display error alert due to nil self.")}
            let title = "No Location Permissions"
            let body = "You should give Eats! some location permissions, or it won't be able to display any restaurants other than hard-coded favorites of the developer!"
             self.okAlert(title: title, body: body)
        }
    }
    
    @objc func fetchNewData() {
        if !Database.fetchNewLocations() {
            // Didn't have location to fetch with
            let title = "Don't have Location"
            let body = "Eats! needs location permissions to display local restaruants. If you've  already given Eats! location permissions, try to restart it to get a fresh location."
            okAlert(title: title, body: body)
        }
    }
    
    @objc func dataRefreshed(notification: Notification) {
        guard let newData = notification.object as? [Restaurant] else {
            return Log.error("Refresh notification missing data")
        }
        data = newData
        self.refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    @objc func dismissKeyboardAction() {
        searchField.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // keyboard should be hidden if we start scrolling.
        searchField.resignFirstResponder()
    }
    
    // Display alert if we don't have a location.
    func okAlert(title: String, body: String ) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: {
                // Can appear during fetch request
                self.refreshControl.endRefreshing()
            })
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
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
        // Always dismiss keyboard if cell is tapped.
        tableView.deselectRow(at: indexPath, animated: true)
        searchField.resignFirstResponder()
        
        guard let restaurant = restaurants[safe: indexPath.row] else {
            return Log.error("No restaurant associated at index: \(indexPath)")
        }
        viewStyle = .map(locations: [restaurant])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

