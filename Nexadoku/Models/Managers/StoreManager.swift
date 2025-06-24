
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
        Task { await loadProduct() }
        Task { await checkPurchased() }
        startTransactionUpdatesListener()
    }
    
    func loadProduct() async {
        do {
            let storeProducts = try await Product.products(for: [productID])
            premiumProduct = storeProducts.first
            print("Fetched product: \(storeProducts)")
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
            }
        }
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await checkPurchased()
        } catch {
            print("Restore failed: \(error)")
        }
    }
    
    private func setPremiumPurchased() async {
        isPremium = true
        isPurchased = true
    }

    private func startTransactionUpdatesListener() {
        updatesTask = Task.detached { [weak self] in
            for await update in Transaction.updates {
                if case .verified(let transaction) = update,
                   transaction.productID == self?.productID {
                    await self?.setPremiumPurchased()
                }
            }
        }
    }
    
    deinit {
        updatesTask?.cancel()
    }
}
