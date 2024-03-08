//
//  ConvertUserLocationCoordinator.swift
//  JMTeng
//
//  Created by PKW on 2024/02/12.
//

import Foundation
import UIKit
import CoreLocation

protocol ConvertUserLocationCoordinator: Coordinator {
    func startWithData(data: SearchLocationModel?)
    func goToHomeViewController(lon: Double, lat: Double)
}

class DefaultConvertUserLocationCoordinator: ConvertUserLocationCoordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .convertUserLocation
    
    init(navigationController: UINavigationController?, parentCoordinator: Coordinator,
         finishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.finishDelegate = finishDelegate
    }
    
    func start() { }
    
    func startWithData(data: SearchLocationModel?) {
        let convertUserLoctaionViewController = ConvertUserLocationViewController.instantiateFromStoryboard(storyboardName: "ConvertUserLocation") as ConvertUserLocationViewController
        convertUserLoctaionViewController.viewModel?.coordinator = self
        convertUserLoctaionViewController.viewModel?.locationData = data
        
        self.navigationController?.pushViewController(convertUserLoctaionViewController, animated: true)
    }
    
    func goToHomeViewController(lon: Double, lat: Double) {
        if let homeViewController = self.navigationController?.viewControllers[0] as? HomeViewController {
            homeViewController.viewModel?.location = CLLocationCoordinate2D.init(latitude: lon, longitude: lat)
            homeViewController.updateSearchLocation()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func getChildCoordinator(_ type: CoordinatorType) -> Coordinator? {
        var childCoordinator: Coordinator? = nil
        
        switch type {
        case .convertUserLocation:
            childCoordinator = childCoordinators.first(where: { $0 is ConvertUserLocationCoordinator })
        default:
            break
        }
    
        return childCoordinator
    }
    
}

extension DefaultConvertUserLocationCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0.type != childCoordinator.type }
    }
}
