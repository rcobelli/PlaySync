//
//  IPSelection.swift
//  PlaySync
//
//  Created by Ryan Cobelli on 8/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingIPPrompt = false
    
    var body: some View {
        VStack {
            Button("Enter IP Address") {
                promptForIP()
            }
        }
        // Present modal when flag is true
        .sheet(isPresented: $showingIPPrompt) {
            IPEntryView(onSubmit: { ip in
                UserDefaults.standard.set(ip, forKey: "userIP")
                showingIPPrompt = false
            }, onCancel: {
                showingIPPrompt = false
            })
        }
    }
    
    func promptForIP() {
        showingIPPrompt = true
    }
}

struct IPEntryView: View {
    @State private var ipAddress: String = ""
    var onSubmit: (String) -> Void
    var onCancel: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter IP Address")
                .font(.title2)
            
            TextField("e.g. 10.0.0.4", text: $ipAddress)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done)
                .frame(width: 300)
                .onSubmit {
                    submitIP()
                }
            
            HStack {
                Button("Cancel") {
                    onCancel()
                }
                Button("Save") {
                    submitIP()
                }
            }
        }
        .padding()
    }
    
    private func submitIP() {
        // (Optional) Add validation for proper IP format here
        onSubmit(ipAddress)
    }
}

