import Foundation
import OSLog
import SwiftData

@ModelActor
actor SwiftDataRatesCache: RatesCache {
    func rates(on day: Date) -> CachedRates? {
        row(on: day)?.cachedRates
    }

    func latest() -> CachedRates? {
        first(FetchDescriptor(
            predicate: #Predicate { $0.latestFetchedAt != nil },
            sortBy: [SortDescriptor(\.latestFetchedAt, order: .reverse)]
        ))?.cachedRates
    }

    func save(_ cached: CachedRates) throws {
        if let existing = row(on: cached.rates.day) {
            existing.update(with: cached)
        } else {
            modelContext.insert(CachedDay(cached))
        }
        do {
            try modelContext.save()
        } catch {
            Logger.storage.error("Failed to save cached rates: \(error, privacy: .public)")
            throw AppError.storage
        }
    }

    private func row(on day: Date) -> CachedDay? {
        first(FetchDescriptor(predicate: #Predicate { $0.day == day }))
    }

    private func first(_ descriptor: FetchDescriptor<CachedDay>) -> CachedDay? {
        var descriptor = descriptor
        descriptor.fetchLimit = 1
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            Logger.storage.error("Failed to read cached rates: \(error, privacy: .public)")
            return nil
        }
    }
}

extension SwiftDataRatesCache {
    init(isStoredInMemoryOnly: Bool) throws {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        self.init(modelContainer: try ModelContainer(for: CachedDay.self, configurations: configuration))
    }

    static func onDiskOrInMemory() -> SwiftDataRatesCache {
        do {
            return try SwiftDataRatesCache(isStoredInMemoryOnly: false)
        } catch {
            Logger.storage.error("Failed to open the rates store, using memory: \(error, privacy: .public)")
        }
        do {
            return try SwiftDataRatesCache(isStoredInMemoryOnly: true)
        } catch {
            preconditionFailure("Failed to create an in-memory rates store: \(error)")
        }
    }
}
