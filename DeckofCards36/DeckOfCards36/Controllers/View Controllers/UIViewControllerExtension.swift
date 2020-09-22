//
//  UIViewControllerExtension.swift
//  DeckofCards36
//
//  Created by Owen Gaudio on 9/22/20.
//  Copyright © 2020 Owen Gaudio. All rights reserved.
//

import UIKit

extension CardViewController {
    func presentErrorToUser(localizedError: LocalizedError) {
        let alertController = UIAlertController(title: "Error", message: localizedError.errorDescription, preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
