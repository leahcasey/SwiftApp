import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    var pManagedObject: CDPerson!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let person = pManagedObject {
            // Use URL from pManagedObject (CDPerson)
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
