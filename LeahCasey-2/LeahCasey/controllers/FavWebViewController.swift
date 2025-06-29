import UIKit
import WebKit

class FavWebViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    var pManagedObject: FavouritePerson!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Check if pManagedObject is available
        if let person = pManagedObject {
            // Use URL from pManagedObject
            let urlweb = URL(string: person.url ?? "https://www.liverpoolfc.com")  // Default to a fallback URL if it's nil
            if let url = urlweb {
                let webURLRequest = URLRequest(url: url)
                webview.load(webURLRequest)
            }
        } else {
            // If pManagedObject is nil, use the fallback URL
            let urlweb = URL(string: "https://www.liverpoolfc.com")!
            let webURLRequest = URLRequest(url: urlweb)
            webview.load(webURLRequest)
        }
    }
}
