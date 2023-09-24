//
//  StopwatchTableViewCell.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 23/09/23.
//

import UIKit

protocol StopwatchDelegate: AnyObject {
    func didStopCounting(elapsedTime: TimeInterval)
}

class StopwatchTableViewCell: UITableViewCell {

    @IBOutlet private weak var leftButtonView: UIView?
    @IBOutlet private weak var leftButtonLabel: UILabel?
    @IBOutlet private weak var rightButtonView: UIView?
    @IBOutlet private weak var rightButtonLabel: UILabel?

    // Label to display the stopwatch time
    @IBOutlet private weak var stopwatchLabel: UILabel?

    // Timer object to track elapsed time
    private var stopwatchTimer: Timer?

    // Variable to keep track of elapsed time
    private var elapsedTime: TimeInterval = 0

    // Delegate to send elapsed time frontwards
    private weak var delegate: StopwatchDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        setupViews()
        setupGestures()
    }

    // MARK: - Public Methods

    func setup(delegate: StopwatchDelegate?) {
        self.delegate = delegate
    }

    // MARK: - Private Methods

    private func setupViews() {
        stopwatchLabel?.text = "00:00,00"

        leftButtonLabel?.text = LocalizedTable.reset.localized
        leftButtonView?.layer.borderWidth = 1
        leftButtonView?.layer.borderColor = UIColor.label1?.cgColor
        leftButtonView?.layer.cornerRadius = (leftButtonView?.frame.size.width ?? 0) / 2

        rightButtonLabel?.text = LocalizedTable.start.localized
        rightButtonView?.layer.borderWidth = 1
        rightButtonView?.layer.borderColor = UIColor.label1?.cgColor
        rightButtonView?.layer.cornerRadius = (rightButtonView?.frame.size.width ?? 0) / 2
    }

    private func setupGestures() {
        let leftButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLeftButton))
        let rightButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRightButton))

        leftButtonView?.addGestureRecognizer(leftButtonTapGesture)
        rightButtonView?.addGestureRecognizer(rightButtonTapGesture)
    }

    @objc private func didTapLeftButton() {
        // If the timer is running
        guard stopwatchTimer == nil else { return }

        elapsedTime = 0
        stopwatchLabel?.text = "00:00,00"

        delegate?.didStopCounting(elapsedTime: 0)
    }

    @objc private func didTapRightButton() {
        // If the timer is running, stop it
        if let timer = stopwatchTimer {
            timer.invalidate()
            stopwatchTimer = nil

            // Update the button text
            rightButtonLabel?.text = LocalizedTable.start.localized
            rightButtonView?.backgroundColor = .background7
            leftButtonView?.alpha = 1

            // Send to delegate
            delegate?.didStopCounting(elapsedTime: elapsedTime)
        } else {
            // Start the timer
            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
                guard let self else { return }

                // Update the elapsed time
                self.elapsedTime += timer.timeInterval

                // Format the elapsed time as a stopwatch time
                let minutes = Int(self.elapsedTime) / 60 % 60
                let seconds = Int(self.elapsedTime) % 60
                let milliseconds = Int(self.elapsedTime * 100) % 100

                // Update the label with the formatted time
                self.stopwatchLabel?.text = String(format: "%02d:%02d,%02d", minutes, seconds, milliseconds)
                self.leftButtonView?.alpha = 0.4
            }

            // Update the button text
            rightButtonLabel?.text = LocalizedTable.stop.localized
            rightButtonView?.backgroundColor = .background14
        }
    }
}
