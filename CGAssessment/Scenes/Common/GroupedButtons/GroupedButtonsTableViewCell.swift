//
//  GroupedButtonsTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/10/23.
//

import UIKit

class GroupedButtonsTableViewCell: UITableViewCell {

    // MARK: - Private Properties
    
    @IBOutlet private weak var groupedButtonsView: UIView?
    @IBOutlet private weak var groupedButtonsStackView: UIStackView?
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        groupedButtonsStackView?.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Public Methods
    
    func setup(viewModels: [CGAModels.GroupedButtonViewModel]) {
        var subviews: [GroupedButtonView] = []

        if let currentSubviews = groupedButtonsStackView?.arrangedSubviews as? [GroupedButtonView], !currentSubviews.isEmpty {
            subviews = currentSubviews
        } else {
            for _ in 1...viewModels.count { subviews.append(GroupedButtonView()) }
        }

        var index: Int = 0
        subviews.forEach {
            $0.setup(title: viewModels[safe: index]?.title ?? .none, 
                     symbolName: viewModels[safe: index]?.symbolName ?? "",
                     delegate: viewModels[safe: index]?.delegate)
            index += 1
        }

        subviews.forEach { groupedButtonsStackView?.addArrangedSubview($0) }

        groupedButtonsStackView?.layoutIfNeeded()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        groupedButtonsView?.layer.borderColor = UIColor.label3?.cgColor
        groupedButtonsView?.layer.borderWidth = 1
    }
    
}
