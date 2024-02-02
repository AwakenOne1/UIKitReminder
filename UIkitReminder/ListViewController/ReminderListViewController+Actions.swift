//
//  ReminderListViewController+Actions.swift
//  UIkitReminder
//
//  Created by Alexey Dubovik on 2.02.24.
//

import Foundation

extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else { return }
        completeReminder(with: id)
    }
}
