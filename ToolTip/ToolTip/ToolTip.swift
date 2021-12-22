//
//  ToolTip.swift
//  ButtonToolTip
//
//  Created by alexandru.robert.local on 8/12/21.
//

import Foundation
import UIKit


// MARK: - Enums

enum ToolTipCustomization {
    case font
    case fontColor
    case backgroundColor
}

// MARK: - Struct

struct DescriptionView {
    let description: String
    init(description: String) {
        self.description = description
    }
}

// MARK: - ToolTipManagement

class ToolTipManagement {
    static let instance = ToolTipManagement()
    
    private let toolTipWindow: ToolTipWindow = ToolTipWindow(frame: UIScreen.main.bounds)
    private var activeToolTipsButtons: [UIButton : DescriptionView] = [:]
    
    var font: UIFont = UIFont.systemFont(ofSize: 16)
    var textColor: UIColor = .white
    var backgroundColor: UIColor? = .darkGray
    
    fileprivate func showToolTip(sender: UIButton) {
        guard let description = getToolTip(button: sender) else { return }
        toolTipWindow.show(senderButton: sender, description: description.description)
    }
    
    fileprivate func addActiveToolTip(button: UIButton, description: String) {
        activeToolTipsButtons[button] = DescriptionView(description: description)
    }
    
    fileprivate func removeToolTip(button: UIButton) -> DescriptionView? {
        return activeToolTipsButtons.removeValue(forKey: button)
    }
    
    fileprivate func getToolTip(button: UIButton) -> DescriptionView? {
        return activeToolTipsButtons[button]
    }
    
    func getToolTipsButtons() -> [UIButton : DescriptionView] {
        return self.activeToolTipsButtons
    }
    
    func setPreferences(preferences: [ToolTipCustomization: Any]) {
        for preference in preferences {
            switch preference.key {
            case .font:
                ToolTipManagement.instance.font = preference.value as? UIFont ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
            case .backgroundColor:
                ToolTipManagement.instance.backgroundColor = preference.value as? UIColor
            case .fontColor:
                ToolTipManagement.instance.textColor = preference.value as? UIColor ?? .black
            }
        }
    }
}

// MARK: - ToolTipWindow

private class ToolTipWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setToolTipVCRoot()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setToolTipVCRoot()
    }
    
    private func setToolTipVCRoot() {
        let toolTipVC = ToolTipVC()
        toolTipVC.window = self
        self.rootViewController = toolTipVC
        self.windowLevel = UIWindow.Level.alert + 1
    }
    
    func show(senderButton: UIButton?, description: String) {
        guard let toolTipVC = self.rootViewController as? ToolTipVC else { return }
        self.isHidden = false
        toolTipVC.showPopOver(senderButton: senderButton, description: description)
    }
}

// MARK: ToolTipViewController

private class ToolTipVC: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {
    var popOverVC: UIViewController?
    var window: ToolTipWindow!
    var descriptionLabel: UILabel?
    
    var font: UIFont {
        return ToolTipManagement.instance.font
    }
    var textColor: UIColor {
        return ToolTipManagement.instance.textColor
    }
    var backgroundColor: UIColor? {
        return ToolTipManagement.instance.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.popOverVC?.dismiss(animated: true, completion: {
            self.popOverVC = nil
            self.descriptionLabel = nil
            self.window.isHidden = true
        })
    }
    
    func showPopOver(senderButton: UIButton?, description: String) {
        if popOverVC == nil {
            popOverVC = UIViewController()
            popOverVC?.modalPresentationStyle = .popover
            
            descriptionLabel = UILabel()
            descriptionLabel?.backgroundColor = .clear
            descriptionLabel?.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel?.numberOfLines = 0
            descriptionLabel?.font = self.font
            descriptionLabel?.textColor = self.textColor
            descriptionLabel?.text = description
            
            popOverVC?.view.addSubview(descriptionLabel ?? UILabel())
            if #available(iOS 9, *) {
                popOverVC?.view.addConstraints([descriptionLabel!.topAnchor.constraint(equalTo: popOverVC!.view.topAnchor, constant: 10),
                                                descriptionLabel!.leftAnchor.constraint(equalTo: popOverVC!.view.leftAnchor, constant: 10),
                                                descriptionLabel!.rightAnchor.constraint(equalTo: popOverVC!.view.rightAnchor, constant: -45),
                                                descriptionLabel!.bottomAnchor.constraint(equalTo: popOverVC!.view.bottomAnchor, constant: -5)])
            }
        }
        
        popOverVC?.preferredContentSize = CGSize(width: CGFloat(246), height: CGFloat(112))
        
        let ppc = popOverVC?.popoverPresentationController
        ppc?.backgroundColor = self.backgroundColor
        ppc?.permittedArrowDirections = .up
        ppc?.delegate = self
        
        if let senderButton = senderButton {
            ppc?.sourceRect = senderButton.bounds
            ppc?.sourceView = senderButton
        }
        present(popOverVC!, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Extensions UIButton

extension UIButton {
    func addToolTip(description: String) {
        ToolTipManagement.instance.addActiveToolTip(button: self, description: description)
        self.isUserInteractionEnabled = true
        let simpleGesture = UITapGestureRecognizer(target: self, action: #selector(showToolTip))
        if #available(iOS 11.0, *) {
            simpleGesture.name = "ToolTipGesture"
        }
        self.addGestureRecognizer(simpleGesture)
    }
    
    @objc func showToolTip() {
        ToolTipManagement.instance.showToolTip(sender: self)
    }
    
    func removeToolTip(isUserInteractive: Bool = true) {

        if let gestures = self.gestureRecognizers {
            if gestures.count == 1 {
                self.gestureRecognizers?.remove(at: 0)
            } else {
                for (index, gesture) in gestures.enumerated() {
                    if #available(iOS 11.0, *) {
                        if gesture.name == "ToolTipGesture" {
                            self.gestureRecognizers?.remove(at: index)
                        }
                    } else {
                        if gesture.self === UITapGestureRecognizer.self {
                            self.gestureRecognizers?.remove(at: index)
                        }
                    }
                    self.isUserInteractionEnabled = isUserInteractive
                }
            }
        }
    }
}

