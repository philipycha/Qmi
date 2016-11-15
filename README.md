# Qmi
Midterm Project for Lighthouse Labs (built in < 1 Week)
By Philip, Tevin, Dan, and Shaun

Written in Objective-C

Qmi is an iOS application built to reduce tedious wait times at restaurants
With Qmi a user can queue check the queue at nearby Qmi supported restaurants and enter the queue remotely to reduce wasted time at the restaurnat

Qmi has a remote database built with Parse which stores information about customers and restaurants as well as the queues for restaurants. In addition the Parse server sends push notifications to users when requested by the application.


The application has two main interfaces:

- The Current Queue page shows a restaurants current queue and allows them to change it as necessary; informing the server if a notification needs to be sent to the user (their position in line changed, they were removed frome queue, etc)

- The Map View shows nearby restaurants, highlighting ones which support Qmi. When selected Qmi restaurants show the current queue size and a star rating for the restaurant. A user can queue themseleves at a selected restaurant which updates the queue and sends a notification the restaurant queued at. While a user is queued at a restaurant a floating menu pops up showing their position in the queue and an option to leave the queue.

CocoaPods:
-Google Maps
-Google Places
-Parse
