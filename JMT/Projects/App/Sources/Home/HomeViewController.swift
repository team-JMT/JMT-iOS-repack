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
   
    var isFirstApp = true
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.showAnimatedGradientSkeleton()
        setupUI()
        setupRestaurantBottomSheetUI()
        
        fetchData()
        
        setupBind()

        naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - SetupBindings
    func setupBind() {
        
        viewModel?.didUpdateGroupName = { index in
            self.groupNameButton.setTitle(self.viewModel?.groupList[index].groupName ?? "", for: .normal)
            
            if let url = URL(string: self.viewModel?.groupList[index].groupProfileImageUrl ?? "")  {
                self.groupImageView.kf.setImage(with: url)
            }
        
            Task {
                do {
                    try await self.fetchGroupRestaurantData()
                } catch {
                    print(error)
                }
            }
        }
    
        viewModel?.displayAlertHandler = {
            self.showAccessDeniedAlert(type: .location)
        }
        
        viewModel?.locationManager.didUpdateLocations = {
            if self.isFirstApp == true {
                self.isFirstApp = false
                return
            }
            
            self.fetchData()
        }
    }
    
    // MARK: - FetchData
    // 전체 데이터 패치 관련 메소드
    func fetchData() {
        Task {
            do {
                
                print("권한 최초 실행", viewModel?.locationManager.coordinate)
                // 앱 실행시 첫 데이터 로딩 여부
                guard viewModel?.isFirstLodingData == true else { return }
                
                // 위치 권한이 허용되어있으면
                if viewModel?.locationManager.checkAuthorizationStatus() == true {
                    
                    // 현재 위치를 기반으로 위치 정보 업데이트
                    try await fetchNaverMapViewData()
                    
                    // 그룹에 가입되어 있으면
                    if try await fetchJoinGroup() == true {
                        
                        // 그룹 정보 설정
                        setupGroupData()
                        
                        // 그룹 맛집 정보 가져오기
                        try await fetchGroupRestaurantData()
                        
                        // UI 업데이트? 없어도되는지는 확인 필요
                        //topDummyView.isHidden = false
                        //topContainerView.isHidden = false
                        
                        // 맛집 바텀시트 업데이트
                        viewModel?.didUpdateBottomSheetTableView?()
                        // 스켈레톤뷰 해제
                        self.view.hideSkeleton()
                        
                        // 처음 데이터 가져오는지 체크하는 변수 업데이트
                        viewModel?.isFirstLodingData = false
                        
                    }
                    // 그룹에 가입되어있지 않으면
                    else {
                        // 그룹 가입 바텀시트 설정
                        showJoinGroupBottomSheetVC()
                        // UI 업데이트
                        topDummyView.isHidden = true
                        topContainerView.isHidden = true
                    }
                    
                }
                // 위치 권한이 허용되어있지 않으면
                else {
                    // 패치 종료
                    return
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    // 현재 위치를 기반으로 주소 가져오기
    func fetchNaverMapViewData() async throws {
        
        let address = try await viewModel?.fetchCurrentAddressAsync()
        if address == nil {
            locationButton.setTitle("위치 검색 실패", for: .normal)
        } else {
            locationButton.setTitle(address, for: .normal)
            updateCamera()
        }
    }
    
    // 가입된 그룹 가져오기
    func fetchJoinGroup() async throws -> Bool? {
         return try await viewModel?.fetchJoinGroup()
    }
    
    // 선택한 그룹에 포함된 맛집 정보 가져오기
    func fetchGroupRestaurantData() async throws {
        try await viewModel?.fetchRecentRestaurantsAsync()
        try await viewModel?.fetchGroupRestaurantsAsync()
        
        let visibleRegion = self.naverMapView.mapView.projection.latlngBounds(fromViewBounds: self.naverMapView.frame)
        try await self.viewModel?.fetchMapIncludedRestaurantsAsync(withinBounds: visibleRegion)
    }
    
    // MARK: - SetupData
    // 그룹 정보 표시
    func setupGroupData() {
        let index = viewModel?.groupList.firstIndex(where: { $0.isSelected == true }).map({Int($0)}) ?? 0
        groupNameLabel.text = viewModel?.groupList[index].groupName
    }

    // 홈 탭으로 이동했을때 그룹 가입 여부 체크 함수
    func updateViewBasedOnGroupStatus() {
        
        // 가입된 그룹이 없을때
        if viewModel?.groupList.isEmpty == true {
            // 그룹 가입 바텀시트 설정
            showJoinGroupBottomSheetVC()
            // UI 업데이트
            topDummyView.isHidden = true
            topContainerView.isHidden = true
        }
        // 가입된 그룹이 있을떄
        else {
            
            // 앱 실행시 첫 데이터 로딩 여부 (가입된 그룹이 하나도 없을땐 true여야함)
            guard viewModel?.isFirstLodingData == true else { return }
            
            // 바텀시트 스켈레톤 뷰 활성화
            viewModel?.didUpdateSkeletonView?()
            
            Task {
                do {
                    // 그룹 데이터 설정
                    setupGroupData()
                    // 그룹 맛집 데이터 가져오기
                    try await fetchGroupRestaurantData()
                    // 바텀시트 업데이트
                    viewModel?.didUpdateBottomSheetTableView?()
                    // 첫 데이터 로딩 상태 업데이트
                    viewModel?.isFirstLodingData = false
                    
                    // UI 업데이트
                    topDummyView.isHidden = false
                    topContainerView.isHidden = false
                    self.view.hideSkeleton()
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
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
    
    @IBAction func didTabSearchGroupButton(_ sender: Any) {
        viewModel?.coordinator?.showSearchTabWithButton()
    }

    @IBAction func didTabMyGroupButton(_ sender: Any) {
        showGorupListBottomSheetVC()
    }
    
    // MARK: - Helper Methods
    // 카메라 위치 업데이트
    func updateCamera() {
        let lat = viewModel?.locationManager.coordinate?.latitude ?? 0.0
        let lon = viewModel?.locationManager.coordinate?.longitude ?? 0.0
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon))
        cameraUpdate.animation = .easeIn
        naverMapView.mapView.zoomLevel = 18.0
        self.naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
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



