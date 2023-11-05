//
//  ImageInputViewControllerRepresentable.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/09/23.
//

import SwiftUI

struct ImageInputViewControllerRepresentable: UIViewControllerRepresentable {
    var viewModel: ExpenseHistoryView.ExpenseHistoryViewModel
    
    func makeUIViewController(context: Context) -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "IIVC") as! ImageInputViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

