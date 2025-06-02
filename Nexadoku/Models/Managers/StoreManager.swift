
import SwiftUI
import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var premiumProduct: Product?
    @Published var isPurchased: Bool = false
    private let productID = "lifetime_premium"
    
    init() {
        Task { await loadProduct() }
        Task { await checkPurchased() }
    }
    
    func loadProduct() async {
        do {
            let storeProducts = try await Product.products(for: [productID])
            premiumProduct = storeProducts.first
        } catch {
            print("Error loading product: \(error)")
        }
    }
    
    func purchasePremium() async {
        guard let product = premiumProduct else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified:
                    await setPremiumPurchased()
                default:
                    break
                }
            default: break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }
    
    func checkPurchased() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let signedType) = result,
                signedType.productID == productID {
                    await setPremiumPurchased()
                    break
                }
            }
    }
    
    @AppStorage("isPremium") private var isPremium = false
    private func setPremiumPurchased() {
        isPremium = true
        isPurchased = true
    }
}
