//
//  AboutView.swift
//  Sudoku
//
//  Created by Helter Skelter on 19/03/25.
//

import SwiftUI

struct PrivacyPolicy: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            SystemDarkBackground()
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        dismiss()
                        VibrationManager.shared.lightImpact()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .heavy))
                    }
                    
                    Text("PRIVACY POLICY")
                        .foregroundColor(.white)
                        .font(.system(size: 30, weight: .heavy))
                    
                    Spacer()
                }
                .padding()
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                    .shadow(color: .purple.opacity(0.6), radius: 15, x: 0, y: 6)
                    .shadow(color: .indigo.opacity(0.4), radius: 10, x: 0, y: -4)
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text("no_data_collection")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("no_personal_data")
                            
                            Text("no_internet_required")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("offline_functionality")
                            
                            Text("third_party_services")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("no_third_party_services")
                            
                            Text("childrens_privacy")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("no_information_collected")
                        }
                        
                        Group {
                            Text("policy_changes")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("policy_update")

                            Text("contact_us")
                                .font(.headline)
                                .foregroundColor(.purple)
                            Text("If you have any questions or concerns, please contact us through the support section of the app.")
                        }
                    }
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.3))
                            .blur(radius: 0.2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.purple.opacity(0.4), lineWidth: 0.5)
                            )
                    )
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PrivacyPolicy()
}
