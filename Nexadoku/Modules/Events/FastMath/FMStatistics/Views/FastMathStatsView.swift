
import Foundation
import SwiftUI

struct FastMathStatsView: View {
    @Environment(\.dismiss) var dimiss
    @ObservedObject var stats = FastMathStatsManager.shared
    
    var body: some View {
        ZStack {
           FastMathRainBackgorund()
            
            VStack  {
                HStack {
                    Button {
                        dimiss()
                        VibrationManager.shared.lightImpact()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 24, weight: .heavy))
                    }
                    
                    Text("STATISTICS")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding()
                ZStack {
                    GlassListBackground()
                        .padding(.horizontal)
                    
                    List {
                        ForEach(Array(stats.records.enumerated()), id: \.offset) { index, records in
                            HStack {
                                Text("#\(index + 1)")
                                    .foregroundColor(.white.opacity(0.9))
                                    .font(.headline)
                                    .frame(width: 50, alignment: .leading)
                                
                                Spacer()
                                
                                Text(records.date.formattedFM())
                                    .foregroundColor(.white.opacity(0.65))
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                
                                Spacer()
                                
                                Text("\(records.score) - score")
                                    .font(.title3)
                                    .foregroundColor(Color(red: 140/255, green: 60/255, blue: 255/255))
                                    .frame(width: 110, alignment: .trailing)
                            }
                            .padding(.vertical, 6)
                            .listRowBackground(Color.clear)
                            .padding(.horizontal)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 28))
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                        UITableViewCell.appearance().backgroundColor = .clear
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
