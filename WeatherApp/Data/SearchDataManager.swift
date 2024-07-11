import ComposableArchitecture
import Utilities
import CoreData


/// `SearchDataManagerClient`: A dependency client for managing city search data.
///
/// This client provides methods for fetching city search data and saving or updating search data from core data.
/// The dependency client macro ensure It can be used in both live and test environments
///
@DependencyClient
struct SearchDataManagerClient {
    /// Fetches city searches from the data store.
     ///
     /// - Returns: An array of `Search` objects.
     /// - Throws: An error if the fetch request fails.
     var fetchCitySearches: () throws -> [Search]
     
     /// Saves or updates a search entry in the data store.
     ///
     /// - Parameter search: The `Search` object to be saved or updated.
     /// - Throws: An error if the save or update operation fails.
     var saveOrUpdateSearch: (_ search: Search) throws -> Void
}

/// Provides a test implementation  of `SearchDataManagerClient`  for unit tests and preview
extension SearchDataManagerClient: TestDependencyKey {
    
    static let previewValue = Self(
        fetchCitySearches: {
            return [.mock]
        },
        saveOrUpdateSearch: { _ in
            
        }
    )
    
    static let testValue = Self(
        fetchCitySearches: {
            return [.mock]
        },
        saveOrUpdateSearch: { _ in
        }
    )
}

extension DependencyValues {
    var searchDataManager: SearchDataManagerClient {
        get { self[SearchDataManagerClient.self] }
        set { self[SearchDataManagerClient.self] = newValue }
    }
}

/// Provides the live implementation of `SearchDataManagerClient` for the application.
extension SearchDataManagerClient: DependencyKey {
    
    static let liveValue = Self(
        fetchCitySearches: {
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<SearchEntity> = SearchEntity.fetchRequest()
            request.sortDescriptors = [ NSSortDescriptor(key: "time", ascending: false)]
            let citySearches = try context.fetch(request)
            let searches = citySearches.map { citySearch in
                Search(
                    id: citySearch.id ?? UUID(),
                    time: (citySearch.time?.formatDate(to: .fullDateWithTime)).toString,
                    city: citySearch.city.toString,
                    weatherCode: Int(citySearch.weatherCode),
                    temperature: (citySearch.temperature?.toCelcius).toString,
                    temperatureApparent: (citySearch.temperatureApparent?.toCelcius).toString,
                    forecasts: {
                        let forecastEntities = (citySearch.relationship?.allObjects as? [ForecastEntity]) ?? []
                        let sortDescriptor = NSSortDescriptor(key: "time", ascending: true)
                        let sortedForecasts = (forecastEntities as NSArray).sortedArray(using: [sortDescriptor]) as? [ForecastEntity]
                        return sortedForecasts?.map { forecastEntity in
                            Forecast(
                                id: forecastEntity.id ?? UUID(),
                                weatherCode: Int(forecastEntity.weatherCode),
                                temperature: (forecastEntity.temperature?.toCelcius).toString,
                                time: (forecastEntity.time?.formatDate(to: .hour)).toString
                            )
                        } ?? []
                    }()
                )
            }
            return searches
        },
        saveOrUpdateSearch: { search in
            let context = CoreDataManager.shared.context
            let request: NSFetchRequest<SearchEntity> = SearchEntity.fetchRequest()
            request.predicate = NSPredicate(format: "city == %@", search.city)
            
            let results = try context.fetch(request)
            let citySearch: SearchEntity
            if let existingCity = results.first {
                citySearch = existingCity
            } else {
                citySearch = SearchEntity(context: context)
                citySearch.id = search.id
                citySearch.city = search.city
            }
            
            citySearch.weatherCode = Int32(search.weatherCode)
            citySearch.temperature = search.temperature
            citySearch.temperatureApparent = search.temperatureApparent
            citySearch.time = search.time.toDate()
            citySearch.relationship = NSSet(array: search.forecasts.map { forecast in
                let forecastEntity = ForecastEntity(context: context)
                forecastEntity.id = forecast.id
                forecastEntity.weatherCode = Int32(forecast.weatherCode)
                forecastEntity.temperature = forecast.temperature
                forecastEntity.time = forecast.time.toDate()
                return forecastEntity
            })
        
            try context.save()
        }
    )
}
