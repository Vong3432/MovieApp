//
//  YoutubeVideo.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 20/05/2022.
//
import WebKit
import SwiftUI

/// source: https://stackoverflow.com/a/68583934/10868150
struct YoutubeView: UIViewRepresentable {
    
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youTubeURL = URL(string:"https://www.youtube.com/embed/\(videoID)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youTubeURL))
    }
}



extension String {
    func extractYoutubeID() -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: self.count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else { return nil }
        return (self as NSString).substring(with: result.range)
    }
}


