import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    lazy var entryLogDIContainer: EntryLogDIContainer = makeEntryLogDIContainer()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: appConfiguration.apiBaseURL)!
        )
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers
    func makeEntryLogDIContainer() -> EntryLogDIContainer {
        let dependencies = EntryLogDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService
        )
        return EntryLogDIContainer(dependencies: dependencies)
    }
}
