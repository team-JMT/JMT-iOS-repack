//
//  SearchRestaurantMapViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/04.
//

import UIKit
import NMapsMap

class SearchRestaurantMapViewController: UIViewController {

    var viewModel: SearchRestaurantMapViewModel?
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    @IBOutlet weak var registeredRestaurantView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var selectedBottomView: UIView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var selectedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.didUpdateRestaurantRegistration = { isCheck in
            if isCheck == nil {
                self.selectedBottomView.isHidden = true
            } else {
                self.registeredRestaurantView.isHidden = true
                self.selectedBottomView.isHidden = false
            }
            self.updateMap()
        }

        viewModel?.checkRestaurantRegistration()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func didTabSelectedButton(_ sender: Any) {
        viewModel?.coordinator?.showRegistrationRestaurantInfoViewController(info: viewModel?.info)
    }
    
    func setupUI() {
        
        setCustomNavigationBarBackButton(isSearchVC: false)
        
        registeredRestaurantView.layer.cornerRadius = 8
        infoView.layer.cornerRadius = 8
        selectedButton.layer.cornerRadius = 8
        
        naverMapView.showZoomControls = false
            
        placeNameLabel.text = viewModel?.info?.placeName ?? ""
        distanceLabel.text = "내 위치에서 \(viewModel?.info?.distance.distanceWithUnit() ?? "")"
        addressLabel.text = viewModel?.info?.addressName ?? ""
    }
    
    func updateMap() {
        let lat = viewModel?.info?.y ?? 0.0
        let lon = viewModel?.info?.x ?? 0.0
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon))
        cameraUpdate.animation = .easeIn
        self.naverMapView.mapView.moveCamera(cameraUpdate)
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: lat, lng: lon)
        marker.mapView = naverMapView.mapView
    }
}
