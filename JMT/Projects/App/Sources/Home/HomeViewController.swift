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
import Kingfisher

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: HomeViewModel?
    
    var locationManager = LocationManager.shared
    
    var restaurantListFpc: FloatingPanelController!
    var joinGroupFpc: FloatingPanelController!
    var groupListFpc: FloatingPanelController!
    var markers: [NMFMarker] = []
    
    @IBOutlet weak var naverMapView: NMFNaverMapView!
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupNameButton: UIButton!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var topDummyView: UIView!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var topContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationButtonBottom: NSLayoutConstraint!
    
    // 그룹 가입 여부 플래그
    var isHiddenJoinGroupUI = false
    // 맛집 정보 로드 상태 플래그
    var hasFetchedRestaurants = false

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.showAnimatedGradientSkeleton()
        setupUI()
        setupBind()
        setupRestaurantBottomSheetUI()
        
        fetchData()
        
        naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    func fetchData() {
        
        let locationManager = LocationManager.shared
        
        // 권한이 변경되었을때 새로운 데이터 불러오기
        locationManager.didUpdateLocations = {
           
            self.view.showAnimatedGradientSkeleton()
            
            Task {
                do {
                    try await self.updateCurrentAddressData()
                    try await self.viewModel?.fetchJoinGroup()
                    
                    if self.viewModel?.groupList.isEmpty == true {
                       
                        self.updateJoinGroupUI()
                        self.isHiddenJoinGroupUI = false
                        self.hasFetchedRestaurants = false
                    } else {
                        
                        // 그룹 데이터 업데이트
                        self.updateGroupInfoData()
                        
                        // 현재 지도에 포함되어있는 맛집 데이터 가져오기
                        let visibleRegion = self.naverMapView.mapView.projection.latlngBounds(fromViewBounds: self.naverMapView.frame)
                        try await self.viewModel?.fetchMapIncludedRestaurantsAsync(withinBounds: visibleRegion)
                        
                        self.isHiddenJoinGroupUI = true
                        self.hasFetchedRestaurants = true
                        
                        self.view.hideSkeleton()
                        self.viewModel?.didUpdateGroupRestaurantsData?()
                    }
                } catch {
                    print("11111", error)
                }
            }
        }
        
        locationManager.startUpdateLocation()
    }
    
    // 가입된 그룹이 없을때 보여줄 UI 업데이트
    func updateJoinGroupUI() {
        DispatchQueue.main.async {
            self.restaurantListFpc.move(to: .tip, animated: true)
            self.topDummyView.isHidden = true
            self.topContainerView.isHidden = true
            self.showJoinGroupBottomSheetVC()
        }
    }
    
    // 가입된 그룹이 있을때 보여줄 UI 업데이트
    func updateRestaurantUI() {
        DispatchQueue.main.async {
            self.restaurantListFpc.move(to: .half, animated: true)
            self.topDummyView.isHidden = false
            self.topContainerView.isHidden = false
        }
    }
    
    // 가입된 그룹중 선택된 그룹 정보 업데이트
    func updateGroupInfoData() {
        let index = viewModel?.groupList.firstIndex(where: { $0.isSelected == true }) ?? 0
        groupNameLabel.text = viewModel?.groupList[index].groupName
        if let url = URL(string: viewModel?.groupList[index].groupProfileImageUrl ?? "") {
            groupImageView.kf.setImage(with: url)
        } else {
            groupImageView.image = JMTengAsset.defaultProfileImage.image
        }
    }
    
    func updateCurrentAddressData() async throws {
        let address = try await viewModel?.fetchCurrentAddressAsync() ?? ""
        locationButton.setTitle(address, for: .normal)
        updateCamera()
    }
    
    // 카메라 위치 업데이트
    func updateCamera() {
        let lat = LocationManager.shared.coordinate?.latitude ?? 0.0
        let lon = LocationManager.shared.coordinate?.longitude ?? 0.0
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon))
        cameraUpdate.animation = .easeIn
        naverMapView.mapView.zoomLevel = 18.0
        self.naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    // 홈탭으로 돌아왔을때 그룹 정보 확인
    func updateViewBasedOnGroupStatus() {
        Task {
            do {
                // 그룹 정보 가져오기
                try await viewModel?.fetchJoinGroup()
                
                // 그룹 정보가 없을떄
                if viewModel?.groupList.isEmpty == true {
                    // 그룹 가입 UI
                    updateJoinGroupUI()
                    isHiddenJoinGroupUI = false
                    hasFetchedRestaurants = false
                    
                } else { // 그룹 정보가 있을때
                    
                    // 그룹 가입 UI가 숨겨져 있을때
                    if isHiddenJoinGroupUI == false && !hasFetchedRestaurants {
    
                        // 맛집 정보 UI
                        self.updateRestaurantUI()
                        // 현재 지도에 포함되어있는 맛집 데이터 가져오기
                        let visibleRegion = self.naverMapView.mapView.projection.latlngBounds(fromViewBounds: self.naverMapView.frame)
                        try await self.viewModel?.fetchMapIncludedRestaurantsAsync(withinBounds: visibleRegion)
                                        
                        // 그룹 정보
                        updateGroupInfoData()
                        isHiddenJoinGroupUI = true
                        hasFetchedRestaurants = true
                        
                        self.view.hideSkeleton()
                        viewModel?.didUpdateGroupRestaurantsData?()
                    }
                }
            } catch {
                print("123123", error)
            }
        }
    }

    // MARK: - SetupBindings
    func setupBind() {
        
        viewModel?.didUpdateGroupName = { index in
            
            Task {
                do {
                    self.viewModel?.didUpdateGroupRestaurantsData?()
                    
                    self.groupNameLabel.text = self.viewModel?.groupList[index].groupName ?? ""
                    
                    if let url = URL(string: self.viewModel?.groupList[index].groupProfileImageUrl ?? "")  {
                        self.groupImageView.kf.setImage(with: url)
                    } else {
                        self.groupImageView.image = JMTengAsset.defaultProfileImage.image
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // MARK: - FetchData
    
    // MARK: - SetupData
    
    // MARK: - SetupUI
    func setupUI() {
        locationButton.layer.cornerRadius = 8
        groupImageView.layer.cornerRadius = 8
        
        naverMapView.showCompass = false
        naverMapView.showScaleBar = false
        naverMapView.showZoomControls = false
        naverMapView.mapView.positionMode = .direction
    }
    
    // 초기 UI 설정
    func setupRestaurantBottomSheetUI() {
        DispatchQueue.main.async {
            self.topDummyView.isHidden = false
            self.topContainerView.isHidden = false
            
            self.showRestaurantListBottomSheetVC()
            self.setTopViewShadow()
            self.updateLocationButtonBottomConstraint()
        }
    }
    
    // 상단 네비게이션뷰의 그림자
    func setTopViewShadow() {
        // 그림자 컬러
        topContainerView.layer.shadowColor = JMTengAsset.gray500.color.cgColor
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
    }

    
    // MARK: - Actions
    @IBAction func didTabRefreshButton(_ sender: Any) {
        locationManager.startUpdateLocation()
//        if LocationManager.shared.checkAuthorizationStatus() == false {
//            self.showAccessDeniedAlert(type: .location)
//        } else {
//            Task {
//                do {
//                    let visibleRegion = self.naverMapView.mapView.projection.latlngBounds(fromViewBounds: self.naverMapView.frame)
//                    try await self.viewModel?.fetchMapIncludedRestaurantsAsync(withinBounds: visibleRegion)
//                    self.refreshMarkersInVisibleRegion()
//                } catch {
//                    print(error)
//                }
//            }
//        }
    }
    
    @IBAction func didTabChangeAddressButton(_ sender: Any) {
        viewModel?.coordinator?.showUserLocationViewController(endPoint: 1)
    }
    
    @IBAction func didTabSearchGroupButton(_ sender: Any) {
        viewModel?.coordinator?.showSearchTabWithButton()
    }
    
    @IBAction func didTabMyGroupButton(_ sender: Any) {
        showGorupListBottomSheetVC()
    }
    
    // MARK: - Helper Methods
    func updateSearchLocation() {
        Task {
            do {
                updateCamera()
                let address = try await viewModel?.fetchCurrentAddressAsync()
                self.locationButton.setTitle(address, for: .normal)
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - FloatingPanelControllerDelegate
extension HomeViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
//        switch fpc.state {
//        case .full:
////            fpc.setPanelStyle(radius: 0, isHidden: true)
//            //            locationStackView.isHidden = true
//
//        case .half:
////            fpc.setPanelStyle(radius: 24, isHidden: false)
//            //            locationStackView.isHidden = false
//            
//            //        case .tip:
//            //            locationStackView.isHidden = false
//            
//        default:
//            print("")
//        }
    }
    
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        if fpc.isAttracting == false || fpc.isAttracting == true {
            if fpc.surfaceLocation.y < 65 + self.view.safeAreaInsets.top {
                fpc.surfaceLocation.y = 65 + self.view.safeAreaInsets.top
            }
        }
    }
}

// MARK: - BottomSheetViewController 핸들바 설정 // 따로 빼야함
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

// MARK: - 지도 마커 설정
extension HomeViewController {
    func refreshMarkersInVisibleRegion() {
        
        removeAllMarkers()
        
        if let markerRestaurants = viewModel?.markerRestaurants {
            for data in markerRestaurants {
                let marker = NMFMarker(position: NMGLatLng(lat: data.y, lng: data.x))
                let markerImage = UIImage(named: viewModel?.markerImage(category: data.category) ?? "") ?? UIImage()
                marker.iconImage = NMFOverlayImage(image: markerImage)
                marker.captionText = data.name
                marker.mapView = naverMapView.mapView
                markers.append(marker)
            }
        }
    }
    
    func addMarkersInVisibleRegion() {
        
    }
    
    func removeAllMarkers() {
        markers.forEach { $0.mapView = nil } // 각 마커를 지도에서 제거
        markers.removeAll() // 마커 배열 비우기
    }
}

// MARK: - NMFMapViewCameraDelegate
extension HomeViewController: NMFMapViewCameraDelegate {
    // 카메라 이동완료 후 호출
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let visibleRegion = naverMapView.mapView.projection.latlngBounds(fromViewBounds: naverMapView.frame)
        
        let centerX = (visibleRegion.southWest.lat + visibleRegion.northEast.lat) / 2
        let centerY = (visibleRegion.southWest.lng + visibleRegion.northEast.lng) / 2
        
        print(centerX, centerY)
    }
}


// MARK: - 바텀 시트
extension HomeViewController {
    func showJoinGroupBottomSheetVC() {
        
        let storyboard = UIStoryboard(name: "JoinBottonSheet", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "JoinBottonSheetViewController") as? JoinBottonSheetViewController else { return }
        
        vc.viewModel = self.viewModel
        
        joinGroupFpc = FloatingPanelController(delegate: self)
        joinGroupFpc.set(contentViewController: vc)
        joinGroupFpc.layout = JoinBottomSheetFloatingPanelLayout()
        joinGroupFpc.panGestureRecognizer.isEnabled = false
        joinGroupFpc.setPanelStyle(radius: 24, isHidden: true)
        
        self.present(joinGroupFpc, animated: false)
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
