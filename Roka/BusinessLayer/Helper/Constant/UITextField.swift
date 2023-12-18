//
//  AppDelegate.swift
//  Roka
//
//  Created by Applify  on 19/09/22.
//

import Foundation
import UIKit

extension UITextView {
    func setLeftPadding(_ amount: CGFloat) {
        self.textContainerInset = UIEdgeInsets(top: 15, left: amount, bottom: 5, right: 5)
    }
}

private var kAssociationKeyMaxLength: Int = 0
var rightPaddingClick: ((Int)->())?

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder!: "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    func setRightPaddingIconLocation(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 24.0, height: 18.0))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 3, left:5, bottom: 0, right: 40)
        self.rightViewMode = .always
        self.rightView = btnView
    }
    
    func setRightPaddingIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: (self.frame.height), height: self.frame.height))
        btnView.addTarget(self, action: #selector(rightPaddingAction), for: .touchUpInside)
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        self.rightViewMode = .always
        self.rightView = btnView
    }
    
    @objc func rightPaddingAction(sender: UIButton) {
        rightPaddingClick?(sender.tag)
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        // iterate over the mask characters until the iterator of numbers ends
        for ch1 in mask where index < numbers.endIndex {
            if ch1 == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                // move numbers iterator to the next index
                index = numbers.index(after: index)
            } else {
                result.append(ch1) // just append a mask character
            }
        }
        return result
    }
    func setLeftView(_ view: UIView, padding: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = true
        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(view)
        outerView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: view.frame.size.width + padding,
                height: view.frame.size.height + padding
            )
        )
        view.center = CGPoint(
            x: outerView.bounds.size.width / 2,
            y: outerView.bounds.size.height / 2
        )
        leftView = outerView
    }
    
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    // The method is used to cancel the check when using
    // the Chinese Pinyin input method.
    // Becuase the alphabet also appears in the textfield
    // when inputting, we should cancel the check.
    func isInputMethod() -> Bool {
        if let positionRange = self.markedTextRange {
            if let _ = self.position(from: positionRange.start, offset: 0) {
                return true
            }
        }
        return false
    }
    
    
    @objc func checkMaxLength(textField: UITextField) {
        
        guard !self.isInputMethod(), let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
    
}

class UnderlinedTextField: UITextField {
    private let defaultUnderlineColor = UIColor.clear
    private let bottomLine = UIView()
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPaddingg
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet { updateView() }
    }
    @IBInspectable var leftPaddingg: CGFloat = 0
    @IBInspectable var leftColor: UIColor = UIColor.lightGray {
        didSet { updateView() }
    }
    
    // Provides Right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x += rightPadding
        return textRect
    }
    @IBInspectable var rightImage: UIImage? {
        didSet { updateView() }
    }
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var rightColor: UIColor = UIColor.lightGray {
        didSet { updateView() }
    }
    
    @IBInspectable var borderColorForTextField: UIColor? = UIColor.appBorderColor {
        didSet {
            layer.borderColor = borderColorForTextField?.cgColor
        }
    }
    
    func updateView() {
        
        if leftImage != nil {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = leftImage
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = leftColor
            leftView = imageView
            
            // Placeholder text color
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: leftColor])
            
        } else {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = rightImage
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = rightColor
            
            let btnView = UIButton(frame: imageView.bounds)
            btnView.addTarget(self, action: #selector(rightImageAction), for: .touchUpInside)
            btnView.tag = rightView?.tag ?? 0
            btnView.setImage(rightImage, for: .normal)
            btnView.tintColor = rightColor
            imageView.addSubview(btnView)
            
            rightView = btnView
            
            // Placeholder text color
            attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: rightColor])
        }
    }
       
    @objc func rightImageAction(sender: UIButton) {
        rightPaddingClick?(sender.tag)
    }
        

    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderStyle = .roundedRect
        layer.borderColor = borderColorForTextField?.cgColor
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor
        
        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    public func setUnderlineColor(color: UIColor = .appSeparator) {
        bottomLine.backgroundColor = color
    }
    
    public func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultUnderlineColor
    }
}

open class LMDFloatingLabelTextField: UITextField {
    
    public enum State {
        case editing
        case notEditing
    }
    
    fileprivate var lmd_state : State = .notEditing {
        didSet {
            self.animatePlaceholderIfNeeded(with: lmd_state)
        }
    }
    
    fileprivate weak var lmd_placeholder: UILabel!
    fileprivate let textRectYInset : CGFloat = 7
    fileprivate var editingConstraints = [NSLayoutConstraint]()
    fileprivate var notEditingConstraints : [NSLayoutConstraint]!
    fileprivate var activeConstraints : [NSLayoutConstraint]!
    
    //MARK: - PUBLIC VARIABLES
    public var placeholderFont = UIFont(name: "sfdisplay_regular", size: 16) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    open override var text: String? {
        didSet {
            self.animatePlaceholderIfNeeded(with: self.lmd_state)
        }
    }
    
    @IBInspectable public var placeholderText: String? {
        didSet {
            self.lmd_placeholder.text = placeholderText
            self.animatePlaceholderIfNeeded(with: self.lmd_state)
        }
    }
    
    @IBInspectable public  var placeholderSizeFactor: CGFloat = 0.7  {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public  var themeColor: UIColor? = UIColor(red: 1, green: 0, blue: 131/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var borderColorr: UIColor? = UIColor.appBorderColor {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public  var errorBorderColor: UIColor? = UIColor(red: 1, green: 0, blue: 131/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var placeholderTextColor: UIColor = UIColor(white: 183/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var textFieldTextColor: UIColor = UIColor(white: 74/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var disabledTextColor: UIColor = UIColor(white: 183/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var disabledBackgroundColor: UIColor = UIColor(white: 247/255, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var enabledBackgroundColor: UIColor = .white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var disabled = false {
        didSet {
            self.updateState(.notEditing)
        }
    }
    
    public var error = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var top_Padding: CGFloat = 6
    @IBInspectable public var left_Padding: CGFloat = 14
    @IBInspectable public var right_Padding: CGFloat = 10
    //MARK: - LIFE CYCLE
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    fileprivate func setupViews() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        
        self.addTarget(self, action: #selector(editingDidBegin), for: UIControl.Event.editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: UIControl.Event.editingDidEnd)
        
        let placeholder = UILabel()
        placeholder.layoutMargins = .zero
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            placeholder.insetsLayoutMarginsFromSafeArea = false
        }
        self.addSubview(placeholder)
        
        self.lmd_placeholder = placeholder
        
        self.notEditingConstraints = [
            NSLayoutConstraint(item: self.lmd_placeholder as Any, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: self.left_Padding),
            NSLayoutConstraint(item: self.lmd_placeholder as Any, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        ]
        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints
        self.setNeedsLayout()
    }
    
    fileprivate func calculateEditingConstraints() {
        let attributedStringPlaceholder = NSAttributedString(string: (self.placeholderText ?? "").uppercased(), attributes: [
            NSAttributedString.Key.font : self.placeholderFont
            ])
        let originalWidth = attributedStringPlaceholder.boundingRect(with: CGSize(width: .greatestFiniteMagnitude, height: self.frame.height), options: [], context: nil).width
        
        let xOffset = (originalWidth - (originalWidth * placeholderSizeFactor)) / 2
        
        self.editingConstraints = [
            NSLayoutConstraint(item: self.lmd_placeholder, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: CGFloat(-xOffset) + self.left_Padding),
            NSLayoutConstraint(item: self.lmd_placeholder, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: self.top_Padding)
        ]
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.tintColor = themeColor
        self.lmd_placeholder.font = self.placeholderFont
        self.lmd_placeholder.textColor = self.placeholderTextColor
        self.lmd_placeholder.text = self.placeholderText
        self.textColor = self.disabled ? self.disabledTextColor : self.textFieldTextColor
        self.backgroundColor = self.disabled ? self.disabledBackgroundColor : self.enabledBackgroundColor
        self.layer.borderColor = self.error ? self.errorBorderColor?.cgColor : self.lmd_state == .editing ?
            self.borderColorr?.cgColor :
        UIColor.appBorderColor.cgColor
        self.isEnabled = !self.disabled
    }
    
//    fileprivate func animatePlaceholderIfNeeded(with state: State, previousState: State?) {
    fileprivate func animatePlaceholderIfNeeded(with state: State) {
        
        switch state {
        case .editing:
            self.animatePlaceholderToActivePosition()
        case .notEditing:
            if (self.text ?? "").isEmpty {
                self.animatePlaceholderToInactivePosition()
            } else {
                self.animatePlaceholderToActivePosition()
            }
        }
        self.setNeedsLayout()
    
//        guard state != previousState else { return }
//        switch state {
//        case .disabled:
//            break
//
//        case .editing:
//            if previousState == .notEditing && (self.text ?? "").isEmpty == true {
//                self.animatePlaceholderToActivePosition()
//            } else if previousState == nil {
//                self.animatePlaceholderToActivePosition(animated: false)
//            }
//
//        case .notEditing:
//            if (self.text ?? "").isEmpty == true {
//                if previousState == .editing {
//                    self.animatePlaceholderToInactivePosition()
//                } else if previousState == nil {
//                    self.animatePlaceholderToInactivePosition(animated: false)
//                }
//            }
//        }
//        self.setNeedsLayout()
    }
    
    fileprivate func animatePlaceholderToActivePosition(animated: Bool = true) {
        self.calculateEditingConstraints()
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate(self.activeConstraints)
        NSLayoutConstraint.activate(self.editingConstraints)
        self.activeConstraints = self.editingConstraints
        
        let animationBlock = {
            self.layoutIfNeeded()
            self.lmd_placeholder.transform = CGAffineTransform(scaleX: self.placeholderSizeFactor, y: self.placeholderSizeFactor)
        }
        if animated {
            UIView.animate(withDuration: 0.2) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
    
    fileprivate func animatePlaceholderToInactivePosition(animated: Bool = true) {
        self.layoutIfNeeded()
        NSLayoutConstraint.deactivate(self.activeConstraints)
        NSLayoutConstraint.activate(self.notEditingConstraints)
        self.activeConstraints = self.notEditingConstraints
        let animationBlock = {
            self.layoutIfNeeded()
            self.lmd_placeholder.transform = .identity
        }
        if animated {
            UIView.animate(withDuration: 0.2) {
                animationBlock()
            }
        } else {
            animationBlock()
        }
    }
    
    @objc private func editingDidBegin() {
        self.lmd_state = .editing
    }
    
    @objc private func editingDidEnd() {
        self.lmd_state = .notEditing
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return self.calculateTextRect(forBounds: bounds)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return self.calculateTextRect(forBounds: bounds)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds)
        return self.calculateTextRect(forBounds: bounds)
    }
    
    fileprivate func calculateTextRect(forBounds bounds: CGRect) -> CGRect {
        let textInset = (self.placeholderText ?? "").isEmpty == true ? 0 : self.textRectYInset
        return CGRect(x: left_Padding,
                      y: textInset,
                      width: bounds.width - (left_Padding * 2) - right_Padding,
                      height: bounds.height)
    }
    
    //MARK: - PUBLIC FUNCTIONS
    public func updateState(_ state: State) {
        self.lmd_state = state
    }
    
}
extension UITextField {
    @objc
    var leftAccessoryViewTopPadding: CGFloat {
        return 0
    }
    
    @objc
    var rightAccessoryViewTopPadding: CGFloat {
        return 0
    }

    @IBInspectable var leftPadding: Int {
        get {
            return Int(self.leftView?.frame.size.width ?? 0.0)
        }
        set {
            if newValue > 0 {
                let paddingView: UIView = UIView(frame: CGRect(x: 0,
                                                               y: 0,
                                                               width: newValue,
                                                               height: Int(self.bounds.size.height)))
                self.leftView = paddingView
                self.leftViewMode = .always
            }
        }
    }
        
    @objc
    func addRightButton(image: UIImage,
                        tintColor: UIColor? = nil,
                        target: Any?,
                        selector: Selector?) {
        let height = self.frame.size.height
        let button = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 20,
                                            height: height - 16))
        
        if let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.contentMode = .right
        self.rightViewMode = .always
        
        button.setImage(image, for: .normal)
        
        if let tintColor = tintColor {
            button.tintColor = tintColor
        }
        
        button.sizeToFit()
        button.frame = CGRect(x: 0, y: 0, width: max(button.frame.size.width, 30) , height: height)
        
        button.contentEdgeInsets = UIEdgeInsets(top: rightAccessoryViewTopPadding, left: 0, bottom: 0, right: 20)
        button.tag = self.tag
        self.rightView = button
    }
    
    @objc
    func addLeftButton(accessories: [Any],
                       target: Any?,
                       selector: Selector?) {
        self.setNeedsDisplay()
        self.setNeedsLayout()
        var text: String?
        var image: UIImage?
        
        let button = UIButton(frame: .zero)
        if let target = target,
            let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.tintColor = self.textColor ?? .white
        button.titleLabel?.font = self.font
        button.setTitleColor(button.tintColor, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: leftAccessoryViewTopPadding,
                                                left: 10,
                                                bottom: 0,
                                                right: 0)
        self.leftViewMode = .always
        if let first = accessories.first as? String {
            text = first + " "
            if accessories.count > 1 {
                image = accessories[1] as? UIImage
            }
            button.contentHorizontalAlignment = .left
            button.semanticContentAttribute = .forceRightToLeft
        } else if let first = accessories.first as? UIImage {
            image = first
            if accessories.count > 1 {
                text = accessories[1] as? String
            }
        }
        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        self.leftView = button
    }
    
    @objc
    func addNewLeftButton(accessories: [Any],
                       target: Any?,
                       selector: Selector?) {
        self.setNeedsDisplay()
        self.setNeedsLayout()
        var text: String?
        var image: UIImage?
        
        let button = UIButton(frame: .zero)
        if let target = target,
            let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.tintColor = self.textColor ?? .white
        button.titleLabel?.font = self.font
        button.setTitleColor(button.tintColor, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 12,
                                                left: 10,
                                                bottom: 0,
                                                right: 0)
        self.leftViewMode = .always
        if let first = accessories.first as? String {
            text = first + " "
            if accessories.count > 1 {
                image = accessories[1] as? UIImage
            }
            button.contentHorizontalAlignment = .left
            button.semanticContentAttribute = .forceRightToLeft
        } else if let first = accessories.first as? UIImage {
            image = first
            if accessories.count > 1 {
                text = accessories[1] as? String
            }
        }
        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        self.leftView = button
    }

    @objc
    func addRightButton(accessories: [Any],
                       font: UIFont? = nil,
                       fontColor: UIColor = .black,
                       target: Any? = nil,
                       selector: Selector? = nil) {
        self.setNeedsDisplay()
        self.setNeedsLayout()
        var text: String?
        var image: UIImage?
        
        let button = UIButton(frame: .zero)
        if let target = target,
            let selector = selector {
            button.addTarget(target, action: selector, for: .touchUpInside)
            button.isUserInteractionEnabled = true
        } else {
            button.isUserInteractionEnabled = false
        }
        button.tintColor = .black
        button.titleLabel?.font = font ?? self.font
        
        button.setTitleColor(fontColor, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: rightAccessoryViewTopPadding,
                                                left: -2,
                                                bottom: 0,
                                                right: 0)
        self.rightViewMode = .always
        if let first = accessories.first as? String {
            text = first + " "
            if accessories.count > 1 {
                image = accessories[1] as? UIImage
            }
            button.contentHorizontalAlignment = .left
            button.semanticContentAttribute = .forceRightToLeft
        } else if let first = accessories.first as? UIImage {
            image = first
            if accessories.count > 1 {
                text = accessories[1] as? String
            }
        }
        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.sizeToFit()
        self.rightView = button
    }


}
