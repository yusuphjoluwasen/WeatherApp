import Foundation

struct WeatherResponse: Codable {
    let timelines: Timelines?
    let location: Location?
}

// MARK: - Location
struct Location: Codable {
    let lat, lon: Double?
    let name, type: String?
}

// MARK: - Timelines
struct Timelines: Codable {
    let minutely, hourly : [WeatherEntry]?
    let daily: [WeatherDailyEntry]?
}

// MARK: - WeatherEntry
struct WeatherEntry: Codable {
    let time: String?
    let values: WeatherValue?
}

// MARK: - WeatherDailyEntry
struct WeatherDailyEntry: Codable {
    let time: String?
    let values: WeatherDailyValue?
}

// MARK: - WeatherValue
struct WeatherValue: Codable {
    let cloudBase: Double?
    let cloudCeiling: Double?
    let cloudCover: Double?
    let dewPoint: Double?
    let freezingRainIntensity: Double?
    let humidity: Double?
    let precipitationProbability: Double?
    let pressureSurfaceLevel: Double?
    let rainIntensity: Double?
    let sleetIntensity: Double?
    let snowIntensity: Double?
    let temperature: Double?
    let temperatureApparent: Double?
    let uvHealthConcern: Double?
    let uvIndex: Double?
    let visibility: Double?
    let weatherCode: Int?
}

// MARK: - WeatherDailyValue
struct WeatherDailyValue: Codable {
    let cloudBaseAvg, cloudBaseMax, cloudBaseMin, cloudCeilingAvg: Double?
    let cloudCeilingMax: Double?
    let cloudCeilingMin: Double?
    let cloudCoverAvg, cloudCoverMax, cloudCoverMin, dewPointAvg: Double?
    let temperatureApparentAvg, temperatureApparentMax, temperatureApparentMin, temperatureAvg: Double?
    let temperatureMax, temperatureMin: Double?
    let uvHealthConcernAvg, uvHealthConcernMax, uvHealthConcernMin, uvIndexAvg: Int?
    let uvIndexMax, uvIndexMin: Int?
    let visibilityAvg, visibilityMax, visibilityMin: Double?
    let weatherCodeMax, weatherCodeMin: Int?
    let windDirectionAvg, windGustAvg, windGustMax, windGustMin: Double?
    let windSpeedAvg, windSpeedMax, windSpeedMin: Double?
}


/// Extension to map a WeatherResponse object to different domain models.
extension WeatherResponse {

    /// Converts the WeatherResponse into a Search object.
    ///
    /// This method extracts the first available minutely data and hourly forecast data
    /// from the WeatherResponse and maps them into a Search object.
    ///
    /// - Parameter cityName: The name of the city for the search.
    /// - Returns: A Search object containing the mapped data from WeatherResponse, or nil if required data is missing.
    func toSearch(with cityName: String) -> Search? {
        // Ensure the location data is available
        // Extract the first minutely data entry
        guard let minutelyData = self.timelines?.minutely?.first else {
            return nil
        }

        // Extract hourly forecast data and map to Forecast objects
        let hourlyForecasts: [Forecast] = self.timelines?.hourly?.prefix(6).compactMap { entry in
            guard let weatherCode = entry.values?.weatherCode,
                  let temperature = entry.values?.temperature,
                  let time = entry.time else {
                return nil
            }
            return Forecast(
                id: UUID(),
                weatherCode: weatherCode,
                temperature: String(format: "%.1f", temperature),
                time: time
            )
        } ?? []
      

        // Map the minutely data to a Search object
        let search = Search(
            id: UUID(),
            time: minutelyData.time ?? "",
            city: cityName,
            weatherCode: minutelyData.values?.weatherCode ?? 0,
            temperature: String(format: "%.1f", minutelyData.values?.temperature ?? 0),
            temperatureApparent: String(format: "%.1f", minutelyData.values?.temperatureApparent ?? 0),
            forecasts: hourlyForecasts
        )

        return search
    }

    /// Converts the WeatherResponse into a WeatherDetailDomainModel object.
    ///
    /// This method extracts the minutely, hourly, and daily forecast data
    /// from the WeatherResponse and maps them into a WeatherDetailDomainModel object.
    ///
    /// - Parameter location: The name of the location for the weather details.
    /// - Returns: A WeatherDetailDomainModel object containing the mapped data from WeatherResponse.
    func toWeatherDetailDomainModel(location: String) -> WeatherDetailModel {
        let locationName = location.capitalized
        let minutelyData = self.timelines?.minutely?.first
        
        
        return WeatherDetailModel(
            id: UUID(),
            time: (minutelyData?.time?.formatDate(to: .fullDateWithTime)).toString,
            city: locationName,
            weatherCode: minutelyData?.values?.weatherCode ?? 0,
            temperature: String(format: "%.1f", minutelyData?.values?.temperature ?? 0).toCelcius,
            minutely: self.toMinutelyForecasts(),
            hourly: self.toHourlyForecasts(),
            daily: self.toDailyForecasts()
        )
    }

    /// Extracts and maps the minutely forecast data from the WeatherResponse.
    ///
    /// - Returns: An array of Forecast objects containing the minutely forecast data.
     func toMinutelyForecasts() -> [Forecast] {
        return self.timelines?.minutely?.prefix(10).compactMap { entry in
            let weatherCode = entry.values?.weatherCode ?? 0
            let temperature = entry.values?.temperature ?? 0.0
            let time = entry.time ?? ""
            return Forecast(
                id: UUID(),
                weatherCode: weatherCode,
                temperature: String(format: "%.1f", temperature).toCelcius,
                time: (time.formatDate(to: .hourMinute)).toString
            )
        } ?? []
    }

    /// Extracts and maps the hourly forecast data from the WeatherResponse.
    ///
    /// - Returns: An array of Forecast objects containing the hourly forecast data.
     func toHourlyForecasts() -> [Forecast] {
        return self.timelines?.hourly?.prefix(10).compactMap { entry in
            let weatherCode = entry.values?.weatherCode ?? 0
            let temperature = entry.values?.temperature ?? 0.0
            let time = entry.time.toString
            return Forecast(
                id: UUID(),
                weatherCode: weatherCode,
                temperature: String(format: "%.1f", temperature).toCelcius,
                time: (time.formatDate(to: .hour)).toString
            )
        } ?? []
    }

    /// Extracts and maps the daily forecast data from the WeatherResponse.
    ///
    /// - Returns: An array of DailyForecast objects containing the daily forecast data.
     func toDailyForecasts() -> [DailyForecast] {
        return self.timelines?.daily?.compactMap { entry in
            let weatherCode = entry.values?.weatherCodeMax ?? 0
            let temperatureMax = entry.values?.temperatureMax ?? 0.0
            let temperatureMin = entry.values?.temperatureMin ?? 0.0
            let time = entry.time ?? ""
            return DailyForecast(
                id: UUID(),
                time: (time.formatDate(to: .dayOfWeekShort)).toString,
                temperatureMax: String(format: "%.1f", temperatureMax).toCelcius,
                temperatureMin: String(format: "%.1f", temperatureMin).toCelcius,
                weatherCode: weatherCode
            )
        } ?? []
    }
}
