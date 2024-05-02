//
//  SearchRestaurantMapViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit
import NMapsMap

class SearchRestaurantMapViewController: UIViewController {
    
    deinit {
        print("SearchRestaurantMapViewController Deinit")
    }
    
    // MARK: - Properties
    var viewModel: SearchRestaurantMapViewModel?
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    @IBOutlet weak var registeredRestaurantView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var selectedBottomView: UIView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var selectedButton: UIButton!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        checkRegistrationRestaurant()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - SetupBindings
    
    
    // MARK: - SetupData
    func setupData() {
        placeNameLabel.text = viewModel?.info?.placeName ?? ""
        distanceLabel.text = "내 위치에서 \(viewModel?.info?.distance.distanceWithUnit() ?? "")"
        addressLabel.text = viewModel?.info?.addressName ?? ""
    }
    
    func checkRegistrationRestaurant() {
        
        Task {
            if await viewModel?.checkRegistrationRestaurant() == false {
                self.registeredRestaurantView.isHidden = false
                self.selectedBottomView.isHidden = true
            } else {
                self.registeredRestaurantView.isHidden = true
                self.selectedBottomView.isHidden = false
            }
            
            self.updateMap()
        }
    }
    
    // MARK: - SetupUI
    func setupUI() {
        setCustomNavigationBarBackButton(goToViewController: .popVC)
        
        registeredRestaurantView.layer.cornerRadius = 8
        infoView.layer.cornerRadius = 8
        selectedButton.layer.cornerRadius = 8
        
        naverMapView.showZoomControls = false
    }
    
    // MARK: - Actions
    @IBAction func didTabSelectedButton(_ sender: Any) {
        viewModel?.coordinator?.showRegistrationRestaurantInfoViewController(info: viewModel?.info)
    }
    
    // MARK: - Helper Methods
    func updateMap() {
        let lat = viewModel?.info?.y ?? 0.0
        let lon = viewModel?.info?.x ?? 0.0
        
        let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lon))
        let markerImage = JMTengAsset.mapPin.image
        marker.iconImage = NMFOverlayImage(image: markerImage)
        marker.mapView = naverMapView.mapView
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon))
        cameraUpdate.animation = .easeIn
        self.naverMapView.mapView.moveCamera(cameraUpdate)
    }
}

// MARK: - TableView Delegate

// MARK: - TableView DataSource

// MARK: - CollectionView Delegate

// MARK: - CollectionView DataSource

// MARK: - Extention
