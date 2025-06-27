
import SwiftUI
import Foundation
import StoreKit

@MainActor
final class StoreManager: ObservableObject {
    @Published var premiumProduct: Product?
    @Published var isPurchased: Bool = false
    @AppStorage("isPremium") private var isPremium = false
    
    private let productID = "lifetime_premium"
    private var updatesTask: Task<Void, Never>? = nil
    
    init() {
        startTransactionUpdatesListener()
        Task { await loadProduct() }
    }
    
    deinit {
        updatesTask?.cancel()
    }
    
    func loadProduct() async {
        do {
            let storeProducts = try await Product.products(for: [productID])
            premiumProduct = storeProducts.first
            print("✅ StoreManager: Product loaded: \(String(describing: premiumProduct?.displayName))")
        } catch {
            print("❌ StoreManager: Failed to load product: \(error.localizedDescription)")
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
                    print("✅ Purchase verified and premium activated")
                case .unverified:
                    print("⚠️ Purchase unverified")
                }
            case .userCancelled:
                print("🟡 Purchase cancelled by user")
            default:
                break
            }
        } catch {
            print("❌ Purchase failed: \(error.localizedDescription)")
        }
    }
    
    func restorePurchases() async -> Bool {
        do {
            try await AppStore.sync()
            return await checkPurchased()
        } catch {
            print("❌ Restore failed: \(error.localizedDescription)")
            return false
        }
    }
    
    func checkPurchased() async -> Bool {
        print("🔍 Checking for existing purchases")
        
        var found = false
        
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                // Only accept if not revoked and still active
                if transaction.productID == productID,
                   transaction.revocationDate == nil,
                   transaction.expirationDate == nil || transaction.expirationDate! > Date() {

                    found = true
                    break
                }
            default:
                continue
            }
        }

        if found {
            await setPremiumPurchased()
            print("✅ Verified previous active purchase via checkPurchased")
            return true
        } else {
            await clearPremium()
            print("🔁 No previous active verified purchase found")
            return false
        }
    }
    
    private func clearPremium() async {
        isPremium = false
        isPurchased = false
    }
    
    private func setPremiumPurchased() async {
        isPremium = true
        isPurchased = true
    }
    
    private func startTransactionUpdatesListener() {
        updatesTask = Task.detached { [weak self] in
            for await update in Transaction.updates {
                guard let self = self else { return }
                switch update {
                case .verified(let transaction):
                    if transaction.productID == self.productID {
                        await self.setPremiumPurchased()
                    }
                default:
                    break
                }
            }
        }
    }
}
