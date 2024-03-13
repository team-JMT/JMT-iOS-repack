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
    
    var isInitialDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 앱 처음 실행시 위치 권한 체크
        if !UserDefaultManager.hasLocationRequstBefore {
            UserDefaultManager.hasLocationRequstBefore = true
            
            // 위치 권한을 설정하지 않았을때 위치 권한 요청하기
            viewModel?.locationManager.requestWhenInUseAuthorization()
        }
        
        setupBind()
        setupUI()
        self.view.showAnimatedGradientSkeleton()
        
        naverMapView.mapView.addCameraDelegate(delegate: self)
        
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
   

    func fetchData()  {
    
        Task {
            guard !isInitialDataLoaded else { return }
            
            do {
                isInitialDataLoaded = true
                
                // 그룹 가입 여부 확인
                guard let isGroup = try await viewModel?.fetchJoinGroup(), isGroup else {
                    
                    // 그룹에 가입되지 않은 경우
                    showJoinGroupUI()
                    return
                }
                
                // 그룹에 가입된 경우
                setupGroupUI()

                if viewModel?.location == nil {
                    showAccessDeniedAlert(type: .location)
                    return
                }
                
                let address = try await viewModel?.fetchCurrentAddressAsync() ?? "위치 검색 실패"
                
                // 바텀시트에 표시할 데이터 가져오기
                try await fetchSectionAndMapData()
                
                // 최종 UI 업데이트
                updateUI(with: address)
                
            } catch RestaurantError.fetchRecentRestaurantsAsyncError {
                print("첫번째 섹션 로드 데이터 에러")
            } catch RestaurantError.fetchGroupRestaurantsAsyncError {
                print("두번째 섹션 로드 데이터 에러")
            } catch RestaurantError.fetchMapIncludedRestaurantsAsyncError {
                print("네이버 맵 로드 데이터 에러")
            }
        }
    }
    
    func showJoinGroupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showJoinGroupBottomSheetVC()
            self.topDummyView.isHidden = true
            self.topContainerView.isHidden = true
        }
    }
    
    func setupGroupUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.topDummyView.isHidden = false
            self.topContainerView.isHidden = false
            self.groupNameButton.setTitle(self.viewModel?.groupList.first?.groupName ?? "", for: .normal)
            self.showRestaurantListBottomSheetVC()
            self.setTopViewShadow()
            self.updateLocationButtonBottomConstraint()
           
        }
    }
    
    func fetchSectionAndMapData() async throws {
        try await viewModel?.fetchRecentRestaurantsAsync()
        try await viewModel?.fetchGroupRestaurantsAsync()
        
        let visibleRegion = self.naverMapView.mapView.projection.latlngBounds(fromViewBounds: self.naverMapView.frame)
        try await self.viewModel?.fetchMapIncludedRestaurantsAsync(withinBounds: visibleRegion)
    }
    
    func updateUI(with address: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateCamera()
            self.locationButton.setTitle(address, for: .normal)
            self.refreshMarkersInVisibleRegion()
            self.viewModel?.didUpdateBottomSheetTableView?()
            
            self.view.stopSkeletonAnimation()
            self.view.hideSkeleton()
        }
    }
    
    func updateCamera() {
        let lat = viewModel?.location?.latitude ?? 0.0
        let lon = viewModel?.location?.longitude ?? 0.0
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon))
        cameraUpdate.animation = .easeIn
        naverMapView.mapView.zoomLevel = 18.0
        self.naverMapView.mapView.moveCamera(cameraUpdate)
    }
  
    func updateSearchLocation() {
        updateCamera()
        
        Task {
            do {
                let address = try await viewModel?.fetchCurrentAddressAsync()
                self.locationButton.setTitle(address, for: .normal)
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func didTabSearchGroupButton(_ sender: Any) {
        viewModel?.coordinator?.showSearchTabWithButton()
    }
    
    @IBAction func didTabRefreshButton(_ sender: Any) {
        
        if viewModel?.locationManager.checkAuthorizationStatus() == false {
            self.showAccessDeniedAlert(type: .location)
        } else {
            Task {
                do {
                    let visibleRegion = self.naverMapView.mapView.projection.latlngBounds(fromViewBounds: self.naverMapView.frame)
                    try await self.viewModel?.fetchMapIncludedRestaurantsAsync(withinBounds: visibleRegion)
                    self.refreshMarkersInVisibleRegion()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    @IBAction func didTabChangeAddressButton(_ sender: Any) {
        viewModel?.coordinator?.showUserLocationViewController(endPoint: 1)
    }
    

    @IBAction func didTabMyGroupButton(_ sender: Any) {
        showGorupListBottomSheetVC()
    }
    
    func setupBind() {
        
        viewModel?.didUpdateGroupName = { index in
            self.groupNameButton.setTitle(self.viewModel?.groupList[index].groupName ?? "", for: .normal)
        }
    
        viewModel?.displayAlertHandler = {
            self.showAccessDeniedAlert(type: .location)
        }
        
        viewModel?.locationManager.didUpdateLocations = { [weak self] location in
            guard let self = self else { return }
            
            self.viewModel?.location = location
            
            guard self.isInitialDataLoaded  else { return }
            
            if location != nil {
    
                Task {
                    
                    self.viewModel?.didUpdateSkeletonView?()
                    
                    do {
                        let address = try await self.viewModel?.fetchCurrentAddressAsync() ?? "위치 검색 실패"
                        try await self.fetchSectionAndMapData()
                        self.updateUI(with: address)
                    } catch {
                       print(error)
                    }
                }
            }
        }
    }
}

// MARK: UI
extension HomeViewController {
    
    func setupUI() {
        locationButton.layer.cornerRadius = 8
        groupImageView.layer.cornerRadius = 8
        
        naverMapView.showCompass = false
        naverMapView.showScaleBar = false
        naverMapView.showZoomControls = false
        naverMapView.mapView.positionMode = .direction
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

// MARK: BottomSheetViewController 핸들바 설정 // 따로 빼야함
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

// MARK: 지도 마커 설정
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

extension HomeViewController: NMFMapViewCameraDelegate {
    // 카메라 이동완료 후 호출
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let visibleRegion = naverMapView.mapView.projection.latlngBounds(fromViewBounds: naverMapView.frame)
    
        let centerX = (visibleRegion.southWest.lat + visibleRegion.northEast.lat) / 2
        let centerY = (visibleRegion.southWest.lng + visibleRegion.northEast.lng) / 2
        

        print(centerX, centerY)
    }
}



// MARK: // 바텀 시트
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
