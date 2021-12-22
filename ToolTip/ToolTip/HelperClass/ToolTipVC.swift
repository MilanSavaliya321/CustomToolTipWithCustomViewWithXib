//
//  PopTipViewController.swift
//  PopTip
//
//  Created by Arvin Quiliza on 5/26/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import UIKit

public class ToolTipVC: UIViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func showToolTip(onItem viewItem: UIView, cmView: UIView, arrowDirection: UIPopoverArrowDirection = .any, viewSize: CGSize =  CGSize(width: CGFloat(246), height: CGFloat(112))) {
        view.addSubViewWithAutolayoutSafeArea(subView: cmView)
        preferredContentSize = viewSize
        modalPresentationStyle = .popover
        let presentationController = self.presentationController as! UIPopoverPresentationController
        //        presentationController.backgroundColor = self.view.backgroundColor
        presentationController.backgroundColor = .clear
        presentationController.sourceView = viewItem
        presentationController.sourceRect = viewItem.bounds
        presentationController.permittedArrowDirections = arrowDirection
        view.backgroundColor = cmView.backgroundColor
        presentationController.delegate = self
    }
}

extension ToolTipVC: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
