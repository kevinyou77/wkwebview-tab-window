//
//  ContentView.swift
//  WebViewTabWindow
//
//  Created by Kevin Yulias on 26/03/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showWebView: Bool = false
    
    var body: some View {
        VStack {
            Button {
                showWebView.toggle()
            } label: {
                Text("Open web view")
            }
            .sheet(isPresented: $showWebView, content: {
                WKWebViewRepresentable(url: URL(string: "https://www.w3schools.com/html/tryit.asp?filename=tryhtml_default_default")!)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
