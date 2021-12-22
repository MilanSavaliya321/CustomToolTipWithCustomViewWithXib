//
//  ViewController2.swift
//  ToolTip
//
//  Created by MilanSavaliya321 on 22/12/21.
//

import UIKit

class ViewController: UIViewController {

    let toolTip = ToolTipVC()
    let customeView = TempView.fromNib()

    override func viewDidLoad() {
        super.viewDidLoad()
        customeView.btnClose.addTarget(self, action: #selector(dismissPop), for: .touchUpInside)
        customeView.lblTitle.text = "Lorem Ipsum is simply"
        customeView.lblDescription.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."
    }

    @objc func dismissPop() {
        toolTip.dismiss(animated: true, completion: nil)
    }

    @IBAction func onBTn1(_ sender: UIButton) {
        toolTip.showToolTip(onItem: sender, cmView: customeView, arrowDirection: .up)
        present(toolTip, animated: true, completion: nil)
    }

    @IBAction func onBtn2(_ sender: UIButton) {
        toolTip.showToolTip(onItem: sender, cmView: customeView, arrowDirection: .up)
        present(toolTip, animated: true, completion: nil)
    }

    @IBAction func onBtn3(_ sender: UIButton) {
        toolTip.showToolTip(onItem: sender, cmView: customeView, arrowDirection: .left)
        present(toolTip, animated: true, completion: nil)
    }

    @IBAction func onBtn4(_ sender: UIButton) {
        let viewSize = CGSize(width: CGFloat(200), height: CGFloat(200))
        toolTip.showToolTip(onItem: sender, cmView: customeView, arrowDirection: .up, viewSize: viewSize)
        present(toolTip, animated: true, completion: nil)
    }

    @IBAction func onBtn5(_ sender: UIButton) {
        toolTip.showToolTip(onItem: sender, cmView: customeView, arrowDirection: .right)
        present(toolTip, animated: true, completion: nil)
    }

    @IBAction func onBtn6(_ sender: UIButton) {
        toolTip.showToolTip(onItem: sender, cmView: customeView, arrowDirection: .down)
        present(toolTip, animated: true, completion: nil)
    }

    @IBAction func onBtn7(_ sender: UIButton) {
        toolTip.showToolTip(onItem: sender, cmView: customeView, arrowDirection: .down)
        present(toolTip, animated: true, completion: nil)
    }

}
