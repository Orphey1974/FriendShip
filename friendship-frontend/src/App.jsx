import WeatherForecast from './components/WeatherForecast'
import './App.css'

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <h1>FriendShip Frontend</h1>
        <p>Отдельное фронтенд приложение на Vite с запросами к API</p>
      </header>
      <main>
        <WeatherForecast />
      </main>
    </div>
  )
}

export default App
