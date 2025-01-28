//
//  AboutView.swift
//  BootScreenLikeScreenSaver
//
//  Created by 한현민 on 1/28/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 14.0) {
            HStack(spacing: 30.0) {
                Image(nsImage: NSImage(named: "AppIcon")!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                VStack {
                    VStack(spacing: 6.0) {
                        Text("BSL Screen Saver")
                            .font(.largeTitle)
                            .bold()
                        Text("Version 1.01")
                    }
                }
            }
            
            VStack {
                Text("Developed by @deblur99")
                    .foregroundStyle(.gray)
                
                HStack {
                    Button("Github") {
                        NSWorkspace.shared.open(URL(string: "https://github.com/deblur99/BootScreenLikeScreenSaver")!)
                    }
                    
                    Text("|")
                        .foregroundStyle(.gray)
                    
                    Button("Repository") {
                        NSWorkspace.shared.open(URL(string: "https://github.com/deblur99/BootScreenLikeScreenSaver")!)
                    }
                }
                .buttonStyle(.link)
            }
        }
    }
}

#Preview {
    AboutView()
        .frame(width: 400, height: 200)
}
