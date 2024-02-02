//
//  ReminderListViewController+DataSource.swift
//  UIkitReminder
//
//  Created by Alexey Dubovik on 17.01.24.
//

import UIKit

extension ReminderViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>

    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminders[indexPath.item]
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(
            forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = UIColor(named: "ButtonColor")
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)
        ]
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.9, alpha: 1.0)
    }
    
    func reminder(with id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(with: id)
        return reminders[index]
    }
    
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(with: reminder.id)
        reminders[index] = reminder
        
    }
    
    func completeReminder(with id: Reminder.ID) {
        var reminder = reminder(with: id)
        reminder.isComplete.toggle()
        updateReminder(reminder)
        updateSnapshot(reloading: [id])
    }
    
    
    private func doneButtonConfiguration(for reminder: Reminder)
        -> UICellAccessory.CustomViewConfiguration
        {
            let symbolName = reminder.isComplete ? "circle.fill" : "circle"
            let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
            let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
            let button = ReminderDoneButton()
            button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
            button.id = reminder.id
            button.setImage(image, for: .normal)
            return UICellAccessory.CustomViewConfiguration(
                customView: button, placement: .leading(displayed: .always))
        }
}
