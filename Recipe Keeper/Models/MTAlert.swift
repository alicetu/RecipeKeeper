
import Foundation
import UIKit

/// Simple UIAlertController builder class
public class MTAlert {
    fileprivate var alertController: UIAlertController
    
    public init(title: String? = nil, message: String? = nil, preferredStyle: UIAlertControllerStyle) {
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }
    
    /// text
    public func setTitle(_ title: String) -> Self {
        alertController.title = title
        return self
    }
    /// message
    public func setMessage(_ message: String) -> Self {
        alertController.message = message
        return self
    }
    
    /// animation
    public func setPopoverPresentationProperties(sourceView: UIView? = nil, sourceRect:CGRect? = nil, barButtonItem: UIBarButtonItem? = nil, permittedArrowDirections: UIPopoverArrowDirection? = nil) -> Self {
        
        if let poc = alertController.popoverPresentationController {
            if let view = sourceView {
                poc.sourceView = view
            }
            if let rect = sourceRect {
                poc.sourceRect = rect
            }
            if let item = barButtonItem {
                poc.barButtonItem = item
            }
            if let directions = permittedArrowDirections {
                poc.permittedArrowDirections = directions
            }
        }
        
        return self
    }
    
    /// button event
    public func addAction(title: String = "", style: UIAlertActionStyle = .default, handler: @escaping ((UIAlertAction?) -> ()) = { _ in }) -> Self {
        alertController.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    
    public func addTextFieldHandler(_ handler: @escaping ((UITextField?) -> ()) = { _ in }) -> Self {
        alertController.addTextField(configurationHandler: handler)
        return self
    }
}

public extension MTAlert {

    
    /// popup dialog
    ///
    ///            MTAlert(title: "Question", message: "Are you sure?", preferredStyle: .alert)
    ///                .addAction(title: "NO", style: .cancel) { _ in }
    ///                .addAction(title: "YES", style: .default) { _ in }
    ///                .show(animated: true)
    ///
    ///            // ActionSheet Sample
    ///            if UIDevice.currentDevice().userInterfaceIdiom != .Pad {
    ///            // Sample to show on iPad
    ///                MTAlert(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
    ///                    .addAction(title: "NO", style: .cancel) { _ in }
    ///                    .addAction(title: "YES", style: .default) { _ in }
    ///                    .show(animated: true)
    ///            } else {
    ///            /*
    ///             Sample to show on iPad With setPopoverPresentationProperties(), specify the properties of UIPopoverPresentationController.
    ///             */
    ///                MTAlert(title: "Question", message: "Are you sure?", preferredStyle: .actionSheet)
    ///                    .addAction(title: "YES", style: .default) { _ in }
    ///                    .addAction(title: "Not Sure", style: .default) { _ in }
    ///                    .setPopoverPresentationProperties(sourceView: view, sourceRect: CGRectMake(0, 0, 100, 100), barButtonItem: nil,  permittedArrowDirections: .Any)
    ///               .show(animated: true)
    ///             }
    ///
    /// - Parameters:
    ///   - animated:
    ///   - completionHandler: 
    public func show(animated: Bool = true, completionHandler: (() -> Void)? = nil) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        var forefrontVC = rootVC
        while let presentedVC = forefrontVC.presentedViewController {
            forefrontVC = presentedVC
        }
        forefrontVC.present(self.alertController, animated: animated, completion: completionHandler)
    }
}
