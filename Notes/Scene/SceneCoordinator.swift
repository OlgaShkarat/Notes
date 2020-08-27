//
//  SceneCoordinator.swift
//  Notes
//
//  Created by Ольга on 23.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SceneCoordinatorType {
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    func close(animated: Bool) -> Completable
}

class SceneCoordinator: SceneCoordinatorType {
    
    private let disposeBag = DisposeBag()
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = UIViewController()
        self.window.makeKeyAndVisible()
    }
    
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        let target = scene.showViewController()
        
        switch style {
        case .root:
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
            
        case .modal:
            target.modalPresentationStyle = .fullScreen
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target
        }

        return subject.ignoreElements()
    }
  
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC
                    completable(.completed)
                }
            } else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            } else {
                completable(.error(TransitionError.unknown))
            }

            return Disposables.create()
        }
    }
}
