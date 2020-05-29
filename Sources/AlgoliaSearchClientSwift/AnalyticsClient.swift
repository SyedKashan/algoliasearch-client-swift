//
//  AnalyticsClient.swift
//  
//
//  Created by Vladislav Fitc on 28/05/2020.
//

import Foundation

public struct AnalyticsClient: Credentials {

  let transport: Transport
  let operationLauncher: OperationLauncher

  public var applicationID: ApplicationID {
    return transport.applicationID
  }

  public var apiKey: APIKey {
    return transport.apiKey
  }

  public init(appID: ApplicationID, apiKey: APIKey, region: Region? = nil) {

    let configuration = AnalyticsConfiguration(applicationID: appID, apiKey: apiKey)
    let sessionConfiguration: URLSessionConfiguration = .default
    sessionConfiguration.httpAdditionalHeaders = configuration.defaultHeaders

    let session = URLSession(configuration: sessionConfiguration)
    let retryStrategy = AlgoliaRetryStrategy(configuration: configuration)

    let queue = OperationQueue()
    queue.qualityOfService = .userInitiated
    let operationLauncher = OperationLauncher(queue: queue)

    let httpTransport = HttpTransport(requester: session, configuration: configuration, retryStrategy: retryStrategy, credentials: configuration, operationLauncher: operationLauncher)
    self.init(transport: httpTransport, operationLauncher: operationLauncher)

  }

  init(transport: Transport, operationLauncher: OperationLauncher) {
    self.transport = transport
    self.operationLauncher = operationLauncher
  }

}

extension AnalyticsClient {
  
  func execute<Output: Codable & Task & IndexNameContainer>(_ command: AlgoliaCommand, completion: @escaping ResultTaskCallback<Output>) -> Operation & TransportTask {
    transport.execute(command, transform: WaitableWrapper.wrap(credentials: self), completion: completion)
  }

  func execute<Output: Codable & Task & IndexNameContainer>(_ command: AlgoliaCommand) throws -> WaitableWrapper<Output> {
    try transport.execute(command, transform: WaitableWrapper.wrap(credentials: self))
  }
  
}

public extension AnalyticsClient {
  
  //MARK: - Add AB test
  
  /**
   Create an ABTest.
   You can set an ABTest on two different indices with different settings, or on the same index with different
   search parameters by providing a Variant.customSearchParameters setting on one of the ABTest.variantA ABTest.variantB.

   - Parameter abTest: The definition of the ABTest.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func addABTest(_ abTest: ABTest,
                                    requestOptions: RequestOptions? = nil,
                                    completion: @escaping ResultTaskCallback<ABTestCreation>) -> Operation {
    let command = Command.ABTest.Add(abTest: abTest, requestOptions: requestOptions)
    return execute(command, completion: completion)
  }
  
  /**
   Create an ABTest.
   You can set an ABTest on two different indices with different settings, or on the same index with different
   search parameters by providing a Variant.customSearchParameters setting on one of the ABTest.variantA ABTest.variantB.

   - Parameter abTest: The definition of the ABTest.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: ABTestCreation  object
   */
  @discardableResult func addABTest(_ abTest: ABTest,
                                    requestOptions: RequestOptions? = nil) throws -> WaitableWrapper<ABTestCreation> {
    let command = Command.ABTest.Add(abTest: abTest, requestOptions: requestOptions)
    return try execute(command)
  }
  
  //MARK: - Get AB test
  
  /**
   Get an ABTest information and results.
   
   - Parameter abTestID: The ABTestID that was sent back in the response of the .addABTest method.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func getABTest(withID abTestID: ABTestID,
                                    requestOptions: RequestOptions? = nil,
                                    completion: @escaping ResultCallback<ABTestResponse>) -> Operation {
    let command = Command.ABTest.Get(abTestID: abTestID, requestOptions: requestOptions)
    return transport.execute(command, completion: completion)
  }
  
  /**
   Get an ABTest information and results.
   
   - Parameter abTestID: The ABTestID that was sent back in the response of the .addABTest method.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: ABTestResponse  object
   */
  @discardableResult func getABTest(withID abTestID: ABTestID,
                                    requestOptions: RequestOptions? = nil) throws -> ABTestResponse {
    let command = Command.ABTest.Get(abTestID: abTestID, requestOptions: requestOptions)
    return try transport.execute(command)
  }
  
  //MARK: - Stop AB test
  
  /**
   Stop an ABTest.
   
   Marks the ABTest as stopped.
   At this point, the test is over and cannot be restarted.
   Additionally, your application is back to normal: index A will perform as usual, receiving 100% of all search requests.
   Note that stopping is different from deleting: When you stop a test, all associated metadata and metrics are stored and remain accessible.
   
   - Parameter abTestID: The ABTestID that was sent back in the response of the .addABTest method.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func stopABTest(withID abTestID: ABTestID,
                                     requestOptions: RequestOptions? = nil,
                                     completion: @escaping ResultTaskCallback<ABTestRevision>) -> Operation {
    let command = Command.ABTest.Stop(abTestID: abTestID, requestOptions: requestOptions)
    return execute(command, completion: completion)
  }
  
  /**
   Stop an ABTest.
   
   Marks the ABTest as stopped.
   At this point, the test is over and cannot be restarted.
   Additionally, your application is back to normal: index A will perform as usual, receiving 100% of all search requests.
   Note that stopping is different from deleting: When you stop a test, all associated metadata and metrics are stored and remain accessible.

   - Parameter abTestID: The ABTestID that was sent back in the response of the .addABTest method.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: ABTestRevision  object
   */
  @discardableResult func stopABTest(withID abTestID: ABTestID,
                                     requestOptions: RequestOptions? = nil) throws -> WaitableWrapper<ABTestRevision> {
    let command = Command.ABTest.Stop(abTestID: abTestID, requestOptions: requestOptions)
    return try execute(command)
  }
  
  //MARK: - Delete AB test
  
  /**
   Delete an ABTest.
   
   Deletes the ABTest from your application and removes all associated metadata & metrics.
   You will therefore no longer be able to view or access the results.
   Note that deleting a test is different from stopping: When you delete a test, all associated metadata and metrics are deleted.

   - Parameter abTestID: The ABTestID that was sent back in the response of the .addABTest method.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func deleteABTest(withID abTestID: ABTestID,
                                       requestOptions: RequestOptions? = nil,
                                       completion: @escaping ResultTaskCallback<ABTestDeletion>) -> Operation {
    let command = Command.ABTest.Delete(abTestID: abTestID, requestOptions: requestOptions)
    return execute(command, completion: completion)
  }
  
  /**
   Delete an ABTest.
   
   Deletes the ABTest from your application and removes all associated metadata & metrics.
   You will therefore no longer be able to view or access the results.
   Note that deleting a test is different from stopping: When you delete a test, all associated metadata and metrics are deleted.

   - Parameter abTestID: The ABTestID that was sent back in the response of the .addABTest method.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: ABTestDeletion  object
   */
  @discardableResult func deleteABTest(withID abTestID: ABTestID,
                                       requestOptions: RequestOptions? = nil) throws -> WaitableWrapper<ABTestDeletion> {
    let command = Command.ABTest.Delete(abTestID: abTestID, requestOptions: requestOptions)
    return try execute(command)
  }
  
  //MARK: - List AB tests
  
  /**
   List ABTest information and results.

   - Parameter page: Specify the first entry to retrieve (0-based, 0 is the most recent entry).
   - Parameter hitsPerPage: Specify the maximum number of entries to retrieve starting at the page.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Parameter completion: Result completion
   - Returns: Launched asynchronous operation
   */
  @discardableResult func listABTests(page: Int?,
                                      hitsPerPage: Int?,
                                      requestOptions: RequestOptions? = nil,
                                      completion: @escaping ResultCallback<ABTestsResponse>) -> Operation {
    let command = Command.ABTest.List(page: page, hitsPerPage: hitsPerPage, requestOptions: requestOptions)
    return transport.execute(command, completion: completion)
  }
  
  /**
   List ABTest information and results.

   - Parameter page: Specify the first entry to retrieve (0-based, 0 is the most recent entry).
   - Parameter hitsPerPage: Specify the maximum number of entries to retrieve starting at the page.
   - Parameter requestOptions: Configure request locally with RequestOptions
   - Returns: ABTestsResponse  object
   */
  @discardableResult func listABTests(page: Int?,
                                      hitsPerPage: Int?,
                                      requestOptions: RequestOptions? = nil) throws -> ABTestsResponse {
    let command = Command.ABTest.List(page: page, hitsPerPage: hitsPerPage, requestOptions: requestOptions)
    return try transport.execute(command)
  }
  
}
