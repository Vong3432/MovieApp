//
//  CheckoutView.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 18/06/2022.
//

import SwiftUI
//import Stripe

//struct CheckoutView: View {
//    @StateObject private var paymentService = PaymentService()
//    @State private var msg = ""
//    @State private var showAlert = false
//    var body: some View {
//        VStack {
//            if let paymentSheet = paymentService.paymentSheet {
//                PaymentSheet.PaymentButton(
//                    paymentSheet: paymentSheet,
//                    onCompletion: paymentService.onPaymentCompletion
//                ) {
//                    Text("Buy")
//                }
//            } else {
//                ProgressView()
//            }
//        }
//        .onReceive(paymentService.paymentResult) { result in
//            switch result {
//            case .completed:
//                msg = "Payment completed"
//            case .failed(let error):
//                msg = "Payment failed: \(error.localizedDescription)"
//            case .canceled:
//                msg = "Payment canceled."
//            }
//            showAlert = true
//        }
//        .onAppear {
//            paymentService.preparePaymentSheet()
//        }
//        .preferredColorScheme(.dark)
//        .alert(msg, isPresented: $showAlert) {
//            Button("OK", role: .cancel) { }
//        }
//    }
//}
//
//struct CheckoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckoutView()
//            .preferredColorScheme(.dark)
//    }
//}
