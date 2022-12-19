//
//  AppLoader.swift
//  JetDevsHomeWork
//
//  Created by Chetan on 15/12/22.
//

// swiftlint: disable force_unwrapping unnecessary_leading_void_in empty_closure_params incomplete_if

import CoreGraphics
import QuartzCore
import UIKit

let appSpinnerMarginSide: CGFloat = 35.0
let appLoaderSpinnerMarginTop: CGFloat = 20.0
let appLoaderTitleMargin: CGFloat = 5.0

public class AppLoader: UIView {
    
    public var coverView: UIView?
    public var titleLabel: UILabel?
    private var loadingView: AppLoadingView?
    public var animated: Bool = true
    public var canUpdated = false
    public var title: String?
    public var speed = 1
    public var config: Config = Config() {
        didSet {
            AppLoader.sharedInstance.loadingView?.config = config
        }
    }
    
    override public var frame: CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: AppLoader {
        
        struct Singleton {
            
            static let instance = AppLoader(frame: CGRect(x: 0, y: 0, width: Config().size, height: Config().size))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated, topMargin: 0)
    }
    
    public class func show(animated: Bool, topMargin: Int) {
        self.show(title: nil, animated: animated, topMargin: topMargin)
    }
    
    public class func show(title: String?, animated: Bool) {
        self.show(title: title, animated: animated, topMargin: 0)
    }
    
    public class func show(title: String?, animated: Bool, topMargin: Int) {
        guard let currentWindow: UIWindow = UIWindow.key else {
            return
        }
        let loader = AppLoader.sharedInstance
        loader.canUpdated = true
        loader.animated = animated
        loader.title = title
        loader.update()
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0 - CGFloat(topMargin))
        loader.center = center
        if (loader.superview == nil) {
            loader.coverView = UIView(frame: currentWindow.bounds)
            loader.coverView?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
            currentWindow.addSubview(loader.coverView!)
            currentWindow.addSubview(loader)
            loader.start()
        }
    }
    
    public class func hide() {
        let loader = AppLoader.sharedInstance
        loader.stop()
    }
    
    public class func setConfig(config: Config) {
        let loader = AppLoader.sharedInstance
        loader.config = config
        loader.frame = CGRect(x: 0, y: 0, width: loader.config.size, height: loader.config.size)
    }
    
    /**
     public methods
     */
    
    public func setup() {
        self.alpha = 0
        self.update()
    }
    
    public func start() {
        self.loadingView?.start()
        
        if (self.animated) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (_) -> Void in
            })
        } else {
            self.alpha = 1
        }
    }
    
    public func stop() {
        
        if (self.animated) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.alpha = 0
                }, completion: { (_) -> Void in
                    self.removeFromSuperview()
                    self.coverView?.removeFromSuperview()
                    self.loadingView?.stop()
                })
            }
            
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverView?.removeFromSuperview()
            self.loadingView?.stop()
        }
    }
    
    public func update() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (appSpinnerMarginSide * 2)
        
        if (self.loadingView == nil) {
            self.loadingView = AppLoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingView!)
        } else {
            self.loadingView?.frame = self.frameForSpinner()
        }
        
        if (self.titleLabel == nil) {
            self.titleLabel = UILabel(frame: CGRect(x: appLoaderTitleMargin, y: appLoaderSpinnerMarginTop + loadingViewSize, width: self.frame.width - appLoaderTitleMargin*2, height: 42.0))
            self.addSubview(self.titleLabel!)
            self.titleLabel?.numberOfLines = 1
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabel?.frame = CGRect(x: appLoaderTitleMargin, y: appLoaderSpinnerMarginTop + loadingViewSize, width: self.frame.width - appLoaderTitleMargin*2, height: 42.0)
        }
        
        self.titleLabel?.font = self.config.titleTextFont
        self.titleLabel?.textColor = UIColor.white
        self.titleLabel?.text = self.title
        self.loadingView?.lineTintColor = UIColor.red
        
        self.titleLabel?.isHidden = self.title == nil
    }
    
    func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (appSpinnerMarginSide * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(x: appSpinnerMarginSide, y: yOffset, width: loadingViewSize, height: loadingViewSize)
        }
        
        return CGRect(x: appSpinnerMarginSide, y: appLoaderSpinnerMarginTop, width: loadingViewSize, height: loadingViewSize)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let currentWindow: UIWindow = UIWindow.key else {
            return
        }
        let loader = AppLoader.sharedInstance
        let height: CGFloat = UIScreen.main.bounds.size.height
        let width: CGFloat = UIScreen.main.bounds.size.width
        let center: CGPoint = CGPoint(x: width / 2.0, y: height / 2.0 - CGFloat(0))
        loader.center = center
        if (loader.superview != nil) {
            loader.coverView?.frame = currentWindow.bounds
        }
    }
    
    /**
     *  Loader View
     */
    
    class AppLoadingView: UIView {
        
        public var speed: Int?
        public var lineWidth: Float?
        public var lineTintColor: UIColor?
        public var backgroundLayer: CAShapeLayer?
        public var isSpinning: Bool?
        
        public var config: Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        /**
         Setup loading view
         */
        
        public func setup() {
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 3)
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = CAShapeLayerLineCap.square
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        public func update() {
            self.lineWidth = self.config.spinnerLineWidth
            self.speed = self.config.speed
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
        }
        
        /**
         Draw Circle
         */
        
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        public func drawBackgroundCircle(partial: Bool) {
            let startAngle: CGFloat = CGFloat(Double.pi) / CGFloat(2.0)
            var endAngle: CGFloat = (2.0 * CGFloat(Double.pi)) + startAngle
            
            let center: CGPoint = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            
            let radius: CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath: UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat(Double.pi)) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath
        }
        
        /**
         Start and stop spinning
         */
        
        public func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = CGFloat(Double.pi)  * 2.0
            rotationAnimation.duration = CFTimeInterval(1)
            rotationAnimation.isCumulative = true
            rotationAnimation.repeatCount = HUGE
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        public func stop() {
            self.drawBackgroundCircle(partial: false)
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
    
    /**
     * Loader config
     */
    
    public struct Config {
        
        /**
         *  Size of loader
         */
        
        public var size: CGFloat = 110.0
        
        /**
         *  Color of spinner view
         */
        
        public var spinnerColor = UIColor.primaryColor
        
        /**
         *  Spinner Line Width
         */
        
        public var spinnerLineWidth: Float = 1.0
        
        /**
         *  Color of title text
         */
        
        public var titleTextColor = UIColor.whiteColor
        
        /**
         *  Speed of the spinner
         */
        
        public var speed: Int = 1
        
        /**
         *  Font for title text in loader
         */
        
        public var titleTextFont: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        /**
         *  Background color for loader
         */
        
        public var backgroundColor = UIColor.placeHolderColor
        
        /**
         *  Foreground color
         */
        
        public var foregroundColor = UIColor.primaryColor.withAlphaComponent(0.20)
        
        /**
         *  Foreground alpha CGFloat, between 0.0 and 1.0
         */
        
        public var foregroundAlpha: CGFloat = 0.20
        
        /**
         *  Corner radius for loader
         */
        
        public var cornerRadius: CGFloat = 10.0
        
        public init() {}
        
    }
}

extension UIWindow {
    
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
