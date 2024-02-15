//
//  ConvertUserLocationViewController.swift
//  JMTeng
//
//  Created by PKW on 2024/02/12.
//

import UIKit
import NMapsMap

class ConvertUserLocationViewController: UIViewController {

    var viewModel: ConvertUserLocationViewModel?
    
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCustomNavigationBarBackButton(isSearchVC: false)
        
        placeNameLabel.text = viewModel?.locationData?.placeName ?? ""
        addressNameLabel.text = viewModel?.locationData?.addressName ?? ""
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: viewModel?.locationData?.y ?? 0.0, lng: viewModel?.locationData?.x ?? 0.0))
        cameraUpdate.animation = .easeIn
        naverMapView.mapView.moveCamera(cameraUpdate)
        
        let marker = NMFMarker()
        marker.position = NMGLatLng(lat: viewModel?.locationData?.y ?? 0.0, lng: viewModel?.locationData?.x ?? 0.0)
        marker.mapView = naverMapView.mapView
        
        print(viewModel?.locationData)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func didTabDoneButton(_ sender: Any) {
        LocationManager.shared.updateCurrentLocation(lat: viewModel?.locationData?.y ?? 0.0, lon: viewModel?.locationData?.x ?? 0.0)
        viewModel?.coordinator?.navigationController?.popToRootViewController(animated: true)
    }
}
