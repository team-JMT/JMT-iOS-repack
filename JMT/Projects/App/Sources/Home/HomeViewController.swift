//
//  HomeViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
import NMapsMap
import FloatingPanel
import SkeletonView

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    var restaurantListFpc: FloatingPanelController!
    var joinGroupFpc: FloatingPanelController!
    var groupListFpc: FloatingPanelController!
    var markers: [NMFMarker] = []

    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameButton: UIButton!
 
    @IBOutlet weak var topDummyView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationButtonBottom: NSLayoutConstraint!
<<<<<<< Updated upstream
=======

    @IBOutlet weak var noGroupInfoView: UIView!
>>>>>>> Stashed changes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBind()
        
        print(DefaultKeychainService.shared.accessToken)
<<<<<<< Updated upstream
//                DefaultKeychainService.shared.accessToken = nil
        
        self.view.showAnimatedGradientSkeleton()
        
        setupBind()
        
        naverMapView.mapView.addCameraDelegate(delegate: self)
        
        setupUI()
        
        showRestaurantListBottomSheetVC()
        updateLocationButtonBottomConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        viewModel?.checkJoinGorup()
=======

        DefaultKeychainService.shared.accessToken = nil
        
        
        viewModel?.checkJoinGroup()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
>>>>>>> Stashed changes
    }


    @IBAction func didTabSearchGroupButton(_ sender: Any) {
<<<<<<< Updated upstream
        viewModel?.coordinator?.showSearchTabWithButton()
    }
    
    @IBAction func didTabRefreshButton(_ sender: Any) {
        viewModel?.checkLocationAuthorization()
=======
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func didTabRefreshButton(_ sender: Any) {
>>>>>>> Stashed changes
        viewModel?.refreshCurrentLocation()
    }
    
    @IBAction func didTabChangeAddressButton(_ sender: Any) {
        viewModel?.coordinator?.showUserLocationViewController(endPoint: 1)
    }
    
<<<<<<< Updated upstream

    @IBAction func didTabMyGroupButton(_ sender: Any) {
        showGorupListBottomSheetVC()
    }
    
    func setupBind() {
        
        viewModel?.didUpdateGroupName = { index in
            self.groupNameButton.setTitle(self.viewModel?.groupList[index].groupName ?? "", for: .normal)
            self.viewModel?.fetchRestaurantsData()
        }
        
        viewModel?.didCompletedCheckJoinGroup = {
            
            if self.viewModel?.groupList.isEmpty == true {
                self.showJoinGorupBottomSheetVC()
                self.restaurantListFpc.move(to: .tip, animated: false)
                self.topDummyView.isHidden = true
                self.topContainerView.isHidden = true
            } else {
                self.restaurantListFpc.move(to: .half, animated: true)
                self.groupNameButton.setTitle(self.viewModel?.groupList.first?.groupName ?? "", for: .normal)
                self.topDummyView.isHidden = false
                self.topContainerView.isHidden = false
                self.setTopViewShadow()
                
                self.view.stopSkeletonAnimation()
                self.view.hideSkeleton()
                
                self.viewModel?.fetchRestaurantsData()
            }
        }
=======
    func setupBind() {
>>>>>>> Stashed changes
        
        viewModel?.displayAlertHandler = {
            self.showAccessDeniedAlert(type: .location)
        }
        
        viewModel?.onUpdateCurrentLocation = { lat, lon in
            
            print(lat, lon)
            
            self.viewModel?.getCurrentLocationAddress(lat: String(lat), lon: String(lon), completed: { address in
                
                self.locationButton.setTitle(address, for: .normal)
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon))
                cameraUpdate.animation = .easeIn
                self.naverMapView.mapView.moveCamera(cameraUpdate)
            })
        }

<<<<<<< Updated upstream
        
        
        viewModel?.didTest = {
            DispatchQueue.main.async {
                self.addMarkersInVisibleRegion()
=======
        viewModel?.didCompletedCheckJoinGroup = { state in
            if state {
                // 위치 권한 체크
                self.viewModel?.checkLocationAuthorization()
                self.setupBottomSheetView()
                self.setTopViewShadow()
                self.noGroupInfoView.isHidden = true
            } else {
                self.noGroupInfoView.isHidden = false
>>>>>>> Stashed changes
            }
        }
    }
}

// MARK: UI
extension HomeViewController {
    
    func setupUI() {
        locationButton.layer.cornerRadius = 8
<<<<<<< Updated upstream
        groupImageView.layer.cornerRadius = 8
=======
>>>>>>> Stashed changes
        
        naverMapView.showCompass = false
        naverMapView.showScaleBar = false
        naverMapView.showZoomControls = false
        naverMapView.mapView.positionMode = .direction
<<<<<<< Updated upstream
=======
    }
    
    // 바텀시트뷰 상단에 버튼의 제약조건을 변경
    func updateLocationButtonBottomConstraint() {
        locationButtonBottom.isActive = false
        
        let newConstraint = NSLayoutConstraint(item: locationStackView!,
                                               attribute: .bottom,
                                               relatedBy: .equal,
                                               toItem: fpc.surfaceView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: -15)
        newConstraint.isActive = true
>>>>>>> Stashed changes
    }
    
    // 상단 네비게이션뷰의 그림자
    func setTopViewShadow() {
        // 그림자 컬러
        topContainerView.layer.shadowColor = JMTengAsset.gray400.color.cgColor
        // 그림자 투명도
        topContainerView.layer.shadowOpacity = 1
        // 그림자 퍼짐 정도
        topContainerView.layer.shadowRadius = 16
        
        // 그림자 경로 설정
        let shadowPath = UIBezierPath()
        let shadowHeight: CGFloat = 4.0 // 그림자 높이

        // 그림자 경로를 뷰의 바텀에만 위치시키기
        shadowPath.move(to: CGPoint(x: 0, y: topContainerView.bounds.maxY))
        shadowPath.addLine(to: CGPoint(x: topContainerView.bounds.width, y: topContainerView.bounds.maxY))
        shadowPath.addLine(to: CGPoint(x: topContainerView.bounds.width, y: topContainerView.bounds.maxY + shadowHeight))
        shadowPath.addLine(to: CGPoint(x: 0, y: topContainerView.bounds.maxY + shadowHeight))
        shadowPath.close()

        topContainerView.layer.shadowPath = shadowPath.cgPath
        
        
        self.view.bringSubviewToFront(topContainerView)
    }
<<<<<<< Updated upstream
    
    // 바텀시트뷰 상단에 버튼의 제약조건을 변경
    func updateLocationButtonBottomConstraint() {
        locationButtonBottom.isActive = false
        
        let newConstraint = NSLayoutConstraint(item: locationStackView!,
                                               attribute: .bottom,
                                               relatedBy: .equal,
                                               toItem: restaurantListFpc.surfaceView,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: -15)
        newConstraint.isActive = true
=======
}

// MARK: Setup BottomSheetViewController
extension HomeViewController {
    
    func setupBottomSheetView() {
        let storyboard = UIStoryboard(name: "HomeBottomSheet", bundle: nil)
        guard let vc =  storyboard.instantiateViewController(withIdentifier: "HomeBottomSheetViewController") as? HomeBottomSheetViewController else { return }
    
        vc.viewModel = self.viewModel
        fpc = FloatingPanelController(delegate: self)
        fpc.setPanelStyle(radius: 24, isHidden: false)
        fpc.set(contentViewController: vc)
        fpc.addPanel(toParent: self)
        
        let layout = HomeBottomSheetFloatingPanelLayout()
      
        if viewModel?.popularRestaurants.isEmpty == true && viewModel?.restaurants.isEmpty == true {
            layout.isExpandable = false
            layout.contentHeight = vc.bottomSheetCollectionView.contentSize.height
        }
         
        fpc.layout = layout
        fpc.invalidateLayout()
        updateLocationButtonBottomConstraint()
>>>>>>> Stashed changes
    }
}

// MARK: FloatingPanelControllerDelegate
extension HomeViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .full:
            fpc.setPanelStyle(radius: 0, isHidden: true)
//            locationStackView.isHidden = true

        case .half:
            fpc.setPanelStyle(radius: 24, isHidden: false)
//            locationStackView.isHidden = false

//        case .tip:
//            locationStackView.isHidden = false

        default:
            print("")
        }
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.isAttracting == false || fpc.isAttracting == true {
            if fpc.surfaceLocation.y < 65 + self.view.safeAreaInsets.top {
                fpc.surfaceLocation.y = 65 + self.view.safeAreaInsets.top
            }
        }
    }
}

<<<<<<< Updated upstream
// MARK: BottomSheetViewController 핸들바 설정 // 따로 빼야함
=======
// MARK: BottomSheetViewController 핸들바 설정
>>>>>>> Stashed changes
extension FloatingPanelController {
    func setPanelStyle(radius: CGFloat, isHidden: Bool) {
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = radius
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        appearance.shadows = []

        surfaceView.grabberHandle.isHidden = isHidden
        surfaceView.grabberHandlePadding = 5.0
        surfaceView.grabberHandleSize = CGSize(width: 40, height: 3)
        
        surfaceView.appearance = appearance
    }
}

<<<<<<< Updated upstream
// MARK: 지도 마커 설정
extension HomeViewController {
    func addMarkersInVisibleRegion() {
        
        removeAllMarkers()
        
        let visibleRegion = naverMapView.mapView.projection.latlngBounds(fromViewBounds: naverMapView.frame)
        
        for data in viewModel!.filterRestaurants {
            if isCoordinate(NMGLatLng(lat: data.y, lng: data.x), withinBounds: visibleRegion) {
                let marker = NMFMarker(position: NMGLatLng(lat: data.y, lng: data.x))
                let markerImage = UIImage(named: viewModel?.markerImage(category: data.category) ?? "") ?? UIImage()
                marker.iconImage = NMFOverlayImage(image: markerImage)
                marker.captionText = data.name
                marker.userInfo = ["id": data.id]
                
                let handler = { [weak self] (overlay: NMFOverlay) -> Bool in
                    if let marker = overlay as? NMFMarker {
                        
                        let filterIndex = self?.viewModel?.filterRestaurants.firstIndex(where: { $0.id == marker.userInfo["id"] as! Int })
                        self?.viewModel?.didUpdateIndex?(filterIndex ?? 0)
                    }
                    return true
                }
                
                marker.touchHandler = handler
                
                marker.mapView = naverMapView.mapView
                markers.append(marker)
            }
        }
    }
    
    
    
    func isCoordinate(_ coordinate: NMGLatLng, withinBounds bounds: NMGLatLngBounds) -> Bool {
        let withinLat = coordinate.lat >= bounds.southWest.lat && coordinate.lat <= bounds.northEast.lat
        let withinLng = coordinate.lng >= bounds.southWest.lng && coordinate.lng <= bounds.northEast.lng
        return withinLat && withinLng
    }
    
    func removeAllMarkers() {
        markers.forEach { $0.mapView = nil } // 각 마커를 지도에서 제거
        markers.removeAll() // 마커 배열 비우기
    }
}

extension HomeViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        addMarkersInVisibleRegion()
    }
}



// MARK: // 바텀 시트
extension HomeViewController {
    func showJoinGorupBottomSheetVC() {
        
        let storyboard = UIStoryboard(name: "JoinBottonSheet", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "JoinBottonSheetViewController") as? JoinBottonSheetViewController else { return }
        
        vc.viewModel = self.viewModel
 
        joinGroupFpc = FloatingPanelController(delegate: self)
        joinGroupFpc.set(contentViewController: vc)
        joinGroupFpc.layout = JoinBottomSheetFloatingPanelLayout()
        joinGroupFpc.panGestureRecognizer.isEnabled = false
        joinGroupFpc.setPanelStyle(radius: 24, isHidden: true)

        self.present(joinGroupFpc, animated: true)
    }
    
    func showRestaurantListBottomSheetVC() {
        let storyboard = UIStoryboard(name: "HomeBottomSheet", bundle: nil)
        guard let vc =  storyboard.instantiateViewController(withIdentifier: "HomeBottomSheetViewController") as? HomeBottomSheetViewController else { return }
    
        vc.viewModel = self.viewModel
        
        restaurantListFpc = FloatingPanelController(delegate: self)
        restaurantListFpc.set(contentViewController: vc)
        restaurantListFpc.addPanel(toParent: self)
        
        let layout = HomeBottomSheetFloatingPanelLayout()
        restaurantListFpc.setPanelStyle(radius: 24, isHidden: false)

        restaurantListFpc.layout = layout
        restaurantListFpc.invalidateLayout()
    }
    
    func showGorupListBottomSheetVC() {
        
        let storyboard = UIStoryboard(name: "GroupList", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "GroupListBottomSheet") as? GroupListBottomSheet else { return }
        
        vc.viewModel = self.viewModel
 
        groupListFpc = FloatingPanelController(delegate: self)
        groupListFpc.set(contentViewController: vc)
        groupListFpc.layout = GroupListBottomSheetFloatingPanelLayout()
        groupListFpc.panGestureRecognizer.isEnabled = false
        groupListFpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        groupListFpc.setPanelStyle(radius: 24, isHidden: true)

        self.present(groupListFpc, animated: true)
    }
}
=======
// MARK: ==

// MARK: ==

// MARK: 나중에 사용
/*
 
 //        let visibleRegion = naverMapView.mapView.projection.latlngBounds(fromViewBounds: naverMapView.frame)
 //        print(visibleRegion)
 //
 
 */
>>>>>>> Stashed changes
