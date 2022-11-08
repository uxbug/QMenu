//
//  QMDescController.swift
//  QMenu
//
//  Created by password 1234 on 9/6/21.
//

import Cocoa
import WebKit

class QMDescController: QMBaseController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
}

fileprivate extension QMDescController {
    func makeUI() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        guard let path = Bundle.main.path(forResource: "desc", ofType: "html"), let html = try? String.init(contentsOfFile: path) else {
            return
        }
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    @IBAction func exportScriptFile(_ sender: Any) {
        let panel = NSOpenPanel.init()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.begin { resonse in
            switch resonse {
            case .OK:
                guard let path = panel.url?.path else {
                    return
                }
                if let terminal = Bundle.main.path(forResource: "runner", ofType: "scpt") {
                    let filePath = path + "/runner.scpt"
                    try? FileManager.default.copyItem(atPath: terminal, toPath: filePath)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func logList(_ sender: Any) {
        let log = QMLogController.init()
        presentAsSheet(log)
    }
}

extension QMDescController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url)
        decisionHandler(.allow)
    }
    
    func textView(_ textView: NSTextView, clickedOnLink link: Any, at charIndex: Int) -> Bool {
        guard let url = link as? String else {
            return false
        }
        if url.hasPrefix("preferences") {   // 启用插件
            showExtensionManagementInterface()
        } else if url.hasPrefix("path") {   // 跳转脚本路径
            guard let scriptURL = try? FileManager.default.url(for: .applicationScriptsDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
                return false
            }
            var path = scriptURL.path.deletingLastPathComponent
            path = path.appending("com.liyb.QMenu.QMenuTarget")
            NSWorkspace.shared.open(URL.init(fileURLWithPath: path))
        }
        return true
    }
}
