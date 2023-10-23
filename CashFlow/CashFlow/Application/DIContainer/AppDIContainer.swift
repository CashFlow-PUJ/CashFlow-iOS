//
//  AppDIContainer.swift
//  CashFlow
//
//  Created by Cristóbal Castrillón Balcázar on 22/10/23.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // TODO: Check if doing this is alright?
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
