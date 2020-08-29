//
//  Scene.swift
//  Notes
//
//  Created by Ольга on 23.08.2020.
//  Copyright © 2020 Ольга. All rights reserved.
//

import UIKit

enum Scene {
    case list(TaskListViewModel)
    case add(AddTaskViewModel)
    case detail(DetailTaskViewModel)
}

extension Scene {
    func showViewController() -> UIViewController {
        switch self {
        case .list(let viewModel):
            var viewController = TasksViewController()
            let navigationViewController = UINavigationController(rootViewController: viewController)
            viewController.bind(viewModel: viewModel)
            return navigationViewController
            
        case .add(let viewModel):
            var addViewController = AddTaskViewController()
            let navigationViewController = UINavigationController(rootViewController: addViewController)
            addViewController.bind(viewModel: viewModel)
            return navigationViewController
            
        case .detail(let viewModel):
            var detailViewController = DetailTaskViewController()
            let navigationViewController = UINavigationController(rootViewController: detailViewController)
            detailViewController.bind(viewModel: viewModel)
            return navigationViewController
        }
    }
}
