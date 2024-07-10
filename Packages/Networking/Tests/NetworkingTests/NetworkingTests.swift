import XCTest
@testable import Networking

final class NetworkingTests: XCTestCase {
    
    /// Mock EndPointType for testing
    struct MockEndPoint: EndPointType {
        var baseurl: String = "https://api.example.com"
        var path: String = "/test"
        var params: [String : String]? = ["key": "value"]
        var method: HTTPMethod = .get
    }
    
    /// Testing valid response
    func testValidResponse() async throws {
        let jsonString = "{\"message\": \"success\"}"
        let data = jsonString.data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: "https://api.example.com/test")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        let network = MockNetwork(data: data, urlResponse: urlResponse, error: nil)
        
        do {
            let response: [String: String] = try await network.call(request: MockEndPoint())
            XCTAssertEqual(response["message"], "success")
        } catch {
            XCTFail("Expected valid response but got error: \(error)")
        }
    }
    
    /// Testing invalid URL
    func testInvalidURL() async throws {
        struct InvalidEndPoint: EndPointType {
            var baseurl: String = "invalid_url"
            var path: String = "/test"
            var params: [String : String]? = ["key": "value"]
            var method: HTTPMethod = .get
        }
        
        let network = MockNetwork(error: NetworkServiceError.invalidURL)
        
        do {
            let _: [String: String] = try await network.call(request: InvalidEndPoint())
            XCTFail("Expected error but got valid response")
        } catch let error as NetworkServiceError {
            XCTAssertEqual(error, .invalidURL)
        } catch {
            XCTFail("Expected NetworkServiceError but got different error: \(error)")
        }
    }
    
    /// Test invalid response code
    func testInvalidResponseCode() async throws {
        let jsonString = "{\"message\": \"error\"}"
        let data = jsonString.data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: "https://api.example.com/test")!,
                                          statusCode: 404,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        let network = MockNetwork(data: data, urlResponse: urlResponse, error: nil)
        
        do {
            let _: [String: String] = try await network.call(request: MockEndPoint())
            XCTFail("Expected error but got valid response")
        } catch let error as NetworkServiceError {
            XCTAssertEqual(error, .genericError("Something went wrong"))
        } catch {
            XCTFail("Expected NetworkServiceError but got different error: \(error)")
        }
    }
    
    /// Test decoding error
    func testDecodingError() async throws {
        let jsonString = "{\"message\": \"success\"}"  // This should cause a decoding error
        let data = jsonString.data(using: .utf8)
        let urlResponse = HTTPURLResponse(url: URL(string: "https://api.example.com/test")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        
        let network = MockNetwork(data: data, urlResponse: urlResponse, error: nil)
        
        struct Response: Codable {
            let nonExistentField: String
        }
        
        do {
            let _: Response = try await network.call(request: MockEndPoint())
            XCTFail("Expected decoding error but got valid response")
        } catch let error as NetworkServiceError {
            switch error {
            case .decodingError(let message):
                XCTAssertTrue(message.contains("The data couldn’t be "))
            default:
                XCTFail("Expected decodingError but got different error: \(error)")
            }
        } catch {
            XCTFail("Expected NetworkServiceError but got different error: \(error)")
        }
    }
}
