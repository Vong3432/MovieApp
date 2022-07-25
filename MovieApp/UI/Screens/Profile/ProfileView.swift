//
//  ProfileView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//

import SwiftUI
//import Stripe

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @State private var isAuthenticated: Bool = false
    @State private var purchased: Bool = false
    @State private var showAlert: Bool = false
    @State private var msg = "Subscribe to Movie App"
    @Environment(\.locale) private var locale
    
    var body: some View {
        ZStack {
            Color.theme.background
            
            List {
                Section{
                    Picker("language", selection: $appState.currentLocale) {
                        ForEach(appState.availableIdentifiers, id: \.self) { identifier in
                            Text(identifier)
                                .tag(identifier)
                        }
                    }.pickerStyle(.automatic)
                } header: {
                    Text("profile_preference_label")
                }
                
                Section {
                    NavigationLink("profile_disclaimer_label") {
                        DisclaimerView()
                    }
                } header: {
                    Text("other")
                }
                
                if isAuthenticated {
//                    Section {
//                        if let paymentSheet = appState.paymentService.paymentSheet {
//                            PaymentSheet.PaymentButton(
//                                paymentSheet: paymentSheet,
//                                onCompletion: appState.paymentService.onPaymentCompletion
//                            ) {
//                                Text("Subscribe to Movie App")
//                                    .tint(.white)
//                            }.disabled(purchased)
//                        } else {
//                            ProgressView()
//                        }
//
//                    } header: {
//                        Text("Purchases")
//                    }

                    
                    Button("sign_out") {
                        logout()
                    }
                    .accessibilityIdentifier("SignOutBtn")
                } else {
                    Button("sign_in") {
                        login()
                    }
                    .accessibilityIdentifier("SignInBtn")
                }

            }
            .listStyle(.grouped)
            
        }
        .alert(msg, isPresented: $showAlert) {
            Button("OK", role: .cancel, action: {})
        }
//        .onAppear {
//            appState.paymentService.preparePaymentSheet()
//        }
//        .onReceive(appState.paymentService.$paymentResult) { result in
//            msg = ""
//            purchased = false
//            
//            switch result {
//            case .completed:
//                msg = "Payment completed"
//                purchased = true
//            case .failed(let error):
//                msg = "Payment failed: \(error.localizedDescription)"
//            case .canceled:
//                msg = "Payment canceled."
//            case .none:
//                break;
//            }
//            
//            if msg.isNotEmpty {
//                showAlert = true
//            }
//        }
        .onReceive(appState.authService.isAuthenticatedPublisher, perform: { isAuthenticated in
            self.isAuthenticated = isAuthenticated
        })
        .preferredColorScheme(.dark)
    }
    
    private func login() {
        Task {
            appState.showSignInScreen()
        }
    }
    
    private func logout() {
        Task {
            try? await appState.authService.logout("")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ProfileView()
                    .environmentObject(AppState())
                    .navigationTitle("profile_tab_title")
                    .environment(\.locale, .init(identifier: "en"))
            }.previewDisplayName("ENG")
            
            NavigationView {
                ProfileView()
                    .environmentObject(AppState())
                    .navigationTitle("profile_tab_title")
                    .environment(\.locale, .init(identifier: "zh-Hans"))
            }.previewDisplayName("ZH-hans")
        }
    }
}
