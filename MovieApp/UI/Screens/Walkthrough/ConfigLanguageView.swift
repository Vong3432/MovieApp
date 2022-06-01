//
//  ConfigLanguageView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 01/06/2022.
//

import SwiftUI

struct ConfigLanguageView: View {
    
    @EnvironmentObject private var appState: AppState
    @Namespace private var animation
    @State private var selectedLanguage = "en"
    @State private var showingSuccess = false
    @State private var hide = false
    let completion: (String) -> ()
    
    init(completion: @escaping (String) -> ()) {
        self.completion = completion
        UITableView.appearance().backgroundColor = UIColor(Color.theme.background)
    }
    
    
    private var isEng: Bool {
        selectedLanguage == "en"
    }
    
    private var isZHCN: Bool {
        selectedLanguage == "zh-Hans"
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            
            language
                .offset(x: 0, y: showingSuccess ? 1000 : 0)
                .opacity(showingSuccess ? 0 : 1)
                .animation(.easeIn(duration: 0.5).delay(0.2), value: showingSuccess)
                .opacity(hide ? 0 : 1)
                .animation(.easeIn(duration: 0.5), value: hide)
            
            success
                .offset(x: 0, y: showingSuccess ? 0 : 1000)
                .animation(
                    .spring(response: 0.75, dampingFraction: 0.85, blendDuration: 0.25).delay(0.5), value: showingSuccess
                )
                .offset(x: 0, y: !hide ? 0 : 1000)
                .animation(
                    .spring(response: 0.75, dampingFraction: 0.85, blendDuration: 0.25).delay(0.5), value: hide
                )
                .opacity(showingSuccess ? 1 : 0.2)
                .animation(
                    .linear.delay(0.75), value: showingSuccess)
                .matchedGeometryEffect(id: "Circle", in: animation)
            
        }
    }
    
    private func onDone() {
        showingSuccess = true
        appState.currentLocale = selectedLanguage
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.hide = true
            self.completion(selectedLanguage)
        }
    }
}

struct ConfigLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ConfigLanguageView(completion: { _ in })
                .preferredColorScheme(.dark)
        }
    }
}

extension ConfigLanguageView {
    private var success: some View {
        VStack {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(.green)
                    .frame(width: 50, height: 50)
                    .scaleEffect(showingSuccess && !hide ? 30 : 1, anchor: .center)
                    .opacity(hide ? 0 : 1)
                    .animation(.linear.delay(0.5), value: hide)
                
                VStack(spacing: 20) {
                    Image(systemName: "checkmark")
                    Text("preference_success")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .opacity(hide ? 0 : 1)
                .animation(.spring().delay(0.25), value: hide)
                .padding()
                .font(.title)
            }
            
            Spacer()
        }
    }
    
    private var language: some View {
        VStack(alignment: .leading) {
            Text("Pick Your language")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            List {
                Button {
                    selectedLanguage = "en"
                } label: {
                    HStack {
                        Text("English")
                        Spacer()
                        
                        Image(systemName: isEng ? "checkmark.circle.fill" : "checkmark.circle")
                            .opacity(isEng ? 1 : 0.2)
                            .foregroundColor(isEng ? .green : .gray)
                            .animation(.spring(), value: selectedLanguage)
                    }
                    .padding(.vertical)
                }
                
                Button {
                    selectedLanguage = "zh-Hans"
                } label: {
                    HStack {
                        Text("简体中文")
                        Spacer()
                        Image(systemName: isZHCN ? "checkmark.circle.fill" : "checkmark.circle")
                            .opacity(isZHCN ? 1 : 0.2)
                            .foregroundColor(isZHCN ? .green : .gray)
                            .animation(.spring(), value: selectedLanguage)
                    }
                    .padding(.vertical)
                }
            }
            .listStyle(.plain)
            
            Button {
                onDone()
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .buttonFilled()
            }
            .padding()
            .matchedGeometryEffect(id: "Button", in: animation)
        }
    }
}
