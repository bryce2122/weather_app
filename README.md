# Weather Forecast Application
A Rails-based application that provides up-to-date weather forecasts using the OpenWeatherMap API. This application showcases the power of Rails 7 with features like Stimulus and Turbo-frames to offer a dynamic user experience without the need for full-page reloads.

## Features
* Search Weather by Location: Enter a location and get a detailed weather forecast.
* Dynamic Updates with Turbo-frames & Stimulus: Seamlessly update parts of the page without full-page refreshes, giving a faster user experience.
* No Database Configuration: Simplified setup with no database required.
* Prerequisites: Ruby version: 3.1.0, Rails version: 7.1.1

## Installation and Setup
* Clone the Repository:
* git clone https://github.com/bryce2122/weather_app.git
* cd weather_app

## Install Dependencies:
 * bundle install

## Setting up the OpenWeatherMap API Key:
* Obtain your API key from OpenWeatherMap. Once you have your key, add it to your Rails application's credentials:
* EDITOR="code --wait" rails credentials:edit
* Then, add the following inside the credentials file:
open_weather_map: api_key: YOUR_API_KEY. Replace YOUR_API_KEY with the key you obtained from OpenWeatherMap.

## Starting the Server:
* rails server
* Visit http://localhost:3000 in your browser to access the application.

# Dependencies
## Below is a brief overview of some of the notable dependencies:

* sprockets-rails: The original asset pipeline for Rails.
* puma: A high-performance web server.
* importmap-rails: Enables the use of JavaScript with ESM import maps.
* turbo-rails: Provides SPA-like page acceleration.
* stimulus-rails: A modest JavaScript framework that integrates seamlessly with Turbo.

## Contributing
* Fork the project from here.
* Create a new branch (git checkout -b new-feature).
* Make your changes.
* Commit your changes (git commit -am 'Added a new feature').
* Push to the branch (git push origin new-feature).
* Create a new Pull Request.
