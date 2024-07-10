import ComposableArchitecture
import Foundation
import CoreData

@DependencyClient
struct SearchDataManagerClient {
    var fetchCitySearches: () throws -> [Search]
    var saveOrUpdateSearch: (_ search: Search) throws -> Void
}

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
            // Mock test data
            return [.mock]
        },
        saveOrUpdateSearch: { _ in
            // Mock save operation
        }
    )
}

extension DependencyValues {
    var searchDataManager: SearchDataManagerClient {
        get { self[SearchDataManagerClient.self] }
        set { self[SearchDataManagerClient.self] = newValue }
    }
}

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
