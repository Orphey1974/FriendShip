import React, { useState, useEffect } from 'react';
import './WeatherForecast.css';

const WeatherForecast = () => {
  const [forecasts, setForecasts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchWeatherData();
  }, []);

  const fetchWeatherData = async () => {
    try {
      setLoading(true);
      // Запрос к отдельному API проекту
      const response = await fetch('https://localhost:7099/weatherforecast');
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      const data = await response.json();
      setForecasts(data);
      setError(null);
    } catch (err) {
      console.error('Ошибка при получении данных о погоде:', err);
      setError('Не удалось загрузить данные о погоде');
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('ru-RU', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  if (loading) {
    return (
      <div className="weather-container">
        <h2>Прогноз погоды</h2>
        <div className="loading">Загрузка...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="weather-container">
        <h2>Прогноз погоды</h2>
        <div className="error">{error}</div>
        <button onClick={fetchWeatherData} className="retry-button">
          Попробовать снова
        </button>
      </div>
    );
  }

  return (
    <div className="weather-container">
      <h2>Прогноз погоды</h2>
      <p>Данные получены с отдельного API приложения</p>
      
      <div className="weather-grid">
        {forecasts.map((forecast, index) => (
          <div key={index} className="weather-card">
            <div className="weather-date">{formatDate(forecast.date)}</div>
            <div className="weather-temp">
              <span className="temp-c">{forecast.temperatureC}°C</span>
              <span className="temp-f">{forecast.temperatureF}°F</span>
            </div>
            <div className="weather-summary">{forecast.summary}</div>
          </div>
        ))}
      </div>
      
      <button onClick={fetchWeatherData} className="refresh-button">
        Обновить данные
      </button>
    </div>
  );
};

export default WeatherForecast;
