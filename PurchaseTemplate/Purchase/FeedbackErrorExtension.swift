// MARK: - TEMPORARILY COMMENTED OUT - Focus on Welcome screen only
#if false
extension UIViewController {
    func showConnectionError(with feedback: InvestmentsHubFeedback, primaryAction: @escaping () -> Void) {
        display(feedback: feedback) {
            primaryAction()
        } secondaryAction: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    
    func showGenericError(with feedback: InvestmentsHubFeedback) {
        display(feedback: feedback) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
#endif
