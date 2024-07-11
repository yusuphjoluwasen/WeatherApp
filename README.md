# WeatherApp

## Note
The application is built using
- Swift
- Swift UI
- iOS 17.4
- Xcode 15.3
- async await
- TCA Architecture


## To Run The Application
- Variable **TOKEN** needs to be added as an environment variable in the **run scheme** of the application
- This is done to avoid storing the authentication token in the code. The method is also considered safe in terms of security.

### Below is an illustration of a sample token:
<img width="400" alt="Screenshot 2024-07-10 at 22 51 39" src="https://github.com/yusuphjoluwasen/WeatherApp/assets/25069943/d5a4d95c-8794-4996-b8ce-bc124e2cc6a1">

## Description
- The App provides a search functionality, which takes a location and provides weather information. Search history is persisted in the database. It includes a detail view that shows full weather details and offers the option to load historical forecasts. The location entered into the text field is debounced using a timer to minimize API calls. The location input is also trimmed for empty spaces and newlines.
- It contains two reducers (`Search History` and `Weather Detail`), both containing states, actions and dependencies to manage the activities of the view.
- The TCA macros, e.g., `@Reducer`, `@ObservableState`, are used in the reducer.
- I used `@DependencyClient` from the TCA library for dependency injection, e.g., to inject the `WeatherClient` service that provides an abstraction to make network calls into the reducer. It is also used for `SearchDataManagerClient`, which provides an abstraction for Core Data. This ensures the reducers can be fully unit tested with mocks.
- Unit tests are written for both reducers.
- The Network and Utility modules are created as independent modules using swift package manager

### Assumptions
- An assumption was made about the option of loading historical forecasts. I added a button that, when clicked, fetches previous weather data from the API.

### Improvements
- To create the `Data Layer` and `WeatherService` modules as independent modules using Swift Package Manager to optimize the application's efficiency.


