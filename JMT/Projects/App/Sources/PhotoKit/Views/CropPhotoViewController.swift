//
//  CropPhotoViewController.swift
//  App
//
//  Created by PKW on 2024/01/10.
//

import UIKit

class CropPhotoViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cropAreaView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nextButton: UIButton!
    
    public var didFinishCropping: ((UIImage) -> Void)?
    
    private let pinchGR = UIPinchGestureRecognizer()
    private let panGR = UIPanGestureRecognizer()
    
    var originalImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = originalImage
        containerView.clipsToBounds = true
        
        // 이미지뷰 확대
        pinchGR.addTarget(self, action: #selector(pinch(_:)))
        pinchGR.delegate = self
        cropAreaView.addGestureRecognizer(pinchGR)
        
        // 이미지뷰 이동
        panGR.addTarget(self, action: #selector(pan(_:)))
        panGR.delegate = self
        cropAreaView.addGestureRecognizer(panGR)
    
        setupImageView()
        setupUI()
    }
    
    @IBAction func DoneButton(_ sender: Any) {
     
        guard let image = imageView.image else { return }
        
        let xCrop = cropAreaView.frame.minX - imageView.frame.minX
        let yCrop = cropAreaView.frame.minY - imageView.frame.minY
        let widthCrop = cropAreaView.frame.width
        let heightCrop = cropAreaView.frame.height
        let scaleRatio = image.size.width / imageView.frame.width
        let scaledCropRect = CGRect(x: xCrop * scaleRatio,
                                    y: yCrop * scaleRatio,
                                    width: widthCrop * scaleRatio,
                                    height: heightCrop * scaleRatio)
        
        guard let cutImageRef: CGImage = image.cgImage?.cropping(to: scaledCropRect) else { return }
        
        let croppedImage = UIImage(cgImage: cutImageRef)
        didFinishCropping?(croppedImage)
    }
    
    func setupImageView() {
        let imageRatio: Double = Double(originalImage.size.width / originalImage.size.height)
        let cropViewRatio: Double =  Double(cropAreaView.frame.width / cropAreaView.frame.height)
        let screenWidth = UIScreen.main.bounds.width
    
        if cropViewRatio > imageRatio {
            imageViewWidthConstraint.constant = screenWidth
            imageViewHeightConstraint.constant = imageViewWidthConstraint.constant / imageRatio
        } else if cropViewRatio < imageRatio {
            imageViewWidthConstraint.constant = screenWidth * imageRatio
            imageViewHeightConstraint.constant = screenWidth
        } else {
            imageViewWidthConstraint.constant = screenWidth
            imageViewHeightConstraint.constant = screenWidth
        }
    }
    
    func setupUI() {
        setCustomBackButton()
        nextButton.layer.cornerRadius = 8
    }
}

// YPImagePicker 라이브러리 참고
extension CropPhotoViewController: UIGestureRecognizerDelegate {
    
    // MARK: - Pinch Gesture
    @objc
    func pinch(_ sender: UIPinchGestureRecognizer) {
        // TODO: Zoom where the fingers are (more user friendly)
        switch sender.state {
        case .began, .changed:
            var transform = imageView.transform
            // Apply zoom level.
            transform = transform.scaledBy(x: sender.scale,
                                            y: sender.scale)
            imageView.transform = transform
        case .ended:
            pinchGestureEnded()
        case .cancelled, .failed, .possible:
            ()
        @unknown default:
            print("unknown default reached. Check code.")
        }
        // Reset the pinch scale.
        sender.scale = 1.0
    }
    
    private func pinchGestureEnded() {
        var transform = imageView.transform
        let kMinZoomLevel: CGFloat = 1.0
        let kMaxZoomLevel: CGFloat = 3.0
        var wentOutOfAllowedBounds = false
        
        // Prevent zooming out too much
        if transform.a < kMinZoomLevel {
            transform = .identity
            wentOutOfAllowedBounds = true
        }
        
        // Prevent zooming in too much
        if transform.a > kMaxZoomLevel {
            transform.a = kMaxZoomLevel
            transform.d = kMaxZoomLevel
            wentOutOfAllowedBounds = true
        }
        
        // Animate coming back to the allowed bounds with a haptic feedback.
        if wentOutOfAllowedBounds {
            generateHapticFeedback()
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.transform = transform
            })
        }
    }
    
    func generateHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
    
    // MARK: - Pan Gesture
    
    @objc
    func pan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
//        let imageView = imageView
        
        // Apply the pan translation to the image.
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        
        // Reset the pan translation.
        sender.setTranslation(CGPoint.zero, in: view)
        
        if sender.state == .ended {
            keepImageIntoCropArea()
        }
    }
    
    private func keepImageIntoCropArea() {
        let imageRect = imageView.frame
        let cropRect = cropAreaView.frame
        var correctedFrame = imageRect
        
        // Cap Top.
        if imageRect.minY > cropRect.minY {
            correctedFrame.origin.y = cropRect.minY
            print("top")
        }
        
        // Cap Bottom.
        if imageRect.maxY < cropRect.maxY {
            correctedFrame.origin.y = cropRect.maxY - imageRect.height
            print("bottom")
        }
        
        // Cap Left.
        if imageRect.minX > cropRect.minX {
            correctedFrame.origin.x = cropRect.minX
            print("left")
        }
        
        // Cap Right.
        if imageRect.maxX < cropRect.maxX {
            correctedFrame.origin.x = cropRect.maxX - imageRect.width
            print("right")
        }
        
        // Animate back to allowed bounds
        if imageRect != correctedFrame {
            UIView.animate(withDuration: 0.3, animations: {
                self.imageView.frame = correctedFrame
            })
        }
    }
    
    /// Allow both Pinching and Panning at the same time.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

final class CropAreaView: UIView {
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)

        self.backgroundColor?.setFill()
        UIRectFill(rect)

        let layer = CAShapeLayer()
        let path = CGMutablePath()

        path.addRoundedRect(in: bounds, cornerWidth: bounds.width/2, cornerHeight: bounds.width/2)
        path.addRect(bounds)

        layer.path = path
        layer.fillRule = CAShapeLayerFillRule.evenOdd

        self.layer.mask = layer
    }
}
