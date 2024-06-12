//
//  ViewController.swift
//  GroupDate
//
//  Created by Rath! on 12/6/24.
//

import UIKit

class ViewController: UIViewController {

    let btnNext = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(btnNext)
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        btnNext.setTitle("Next", for: .normal)
        btnNext.backgroundColor = .red
        btnNext.setTitleColor(.white, for: .normal)
        btnNext.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        NSLayoutConstraint.activate([
        
            btnNext.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnNext.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            btnNext.heightAnchor.constraint(equalToConstant: 45),
            btnNext.widthAnchor.constraint(equalToConstant: 300)
        
        ])
        
        btnNext.addTarget(self, action: #selector(tappedNext) , for: .touchUpInside)
    }
    
    
   @objc func tappedNext(){
        let vc = GroupDateVC()
        navigationController?.pushViewController(vc, animated: true)

    }

}



class CustomNavigationController: UIViewController {
    private var currentViewController: UIViewController?

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        if let previousViewController = currentViewController {
            previousViewController.willMove(toParent: nil)
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParent()
        }

        currentViewController = viewController
    }

    func popViewController(animated: Bool) {
        guard let previousViewController = currentViewController?.parent else {
            return
        }

        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        previousViewController.addChild(currentViewController ?? UIViewController())
        view.addSubview(previousViewController.view)
        previousViewController.didMove(toParent: self)

        currentViewController = previousViewController
    }
}
