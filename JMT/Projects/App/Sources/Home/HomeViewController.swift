//
//  HomeViewController.swift
//  App
//
//  Created by PKW on 2023/12/22.
//

import UIKit
import NMapsMap
import FloatingPanel

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel?
    var fpc: FloatingPanelController!
    var bottomSheetVC: HomeBottomSheetViewController!

    @IBOutlet weak var naverMapView: NMFNaverMapView!
    @IBOutlet weak var groupImageView: UIImageView!
    
    @IBOutlet weak var groupNameButton: UIButton!
 
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationButtonBottom: NSLayoutConstraint!

    @IBOutlet weak var noGroupInfoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBind()
        
        print(DefaultKeychainService.shared.accessToken)

        DefaultKeychainService.shared.accessToken = nil
        
        
        viewModel?.checkJoinGroup()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }


    @IBAction func didTabSearchGroupButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func didTabRefreshButton(_ sender: Any) {
        viewModel?.refreshCurrentLocation()
    }
    
    @IBAction func didTabChangeAddressButton(_ sender: Any) {
        viewModel?.coordinator?.showUserLocationViewController(endPoint: 1)
    }
    
    func setupBind() {
        
        viewModel?.displayAlertHandler = {
            self.showLocationAccessDeniedAlert()
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

        viewModel?.didCompletedCheckJoinGroup = { state in
            if state {
                // 위치 권한 체크
                self.viewModel?.checkLocationAuthorization()
                self.setupBottomSheetView()
                self.setTopViewShadow()
                self.noGroupInfoView.isHidden = true
            } else {
                self.noGroupInfoView.isHidden = false
            }
        }
    }
}

// MARK: UI
extension HomeViewController {
    
    func setupUI() {
        locationButton.layer.cornerRadius = 8
        
        naverMapView.showCompass = false
        naverMapView.showScaleBar = false
        naverMapView.showZoomControls = false
        naverMapView.mapView.positionMode = .direction
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
    }
}

// MARK: FloatingPanelControllerDelegate
extension HomeViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .full:
            fpc.setPanelStyle(radius: 0, isHidden: true)
            locationStackView.isHidden = true

        case .half:
            fpc.setPanelStyle(radius: 24, isHidden: false)
            locationStackView.isHidden = false

        case .tip:
            locationStackView.isHidden = false

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

// MARK: BottomSheetViewController 핸들바 설정
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

// MARK: ==

// MARK: ==

// MARK: 나중에 사용
/*
 
 //        let visibleRegion = naverMapView.mapView.projection.latlngBounds(fromViewBounds: naverMapView.frame)
 //        print(visibleRegion)
 //
 
 */
