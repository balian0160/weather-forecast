//
//  ForecastTab.swift
//  WeatherForecast
//
//  Created by Tom Brhel on 26.09.2022.
//

import SwiftUI

struct ActivityIndicator: View {
    
    @State var degress = 0.0
    
    var body: some View {
        Circle()
            .trim(from: 0.0, to: 0.6)
            .stroke(Color("gradientEndColor"), lineWidth: 10.0)
            .frame(width: 120, height: 120)
            .rotationEffect(Angle(degrees: degress))
            .onAppear(perform: { self.start() })
    }
    
    func start() {
        _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation {
                self.degress += 10.0
            }
            if self.degress == 360.0 {
                self.degress = 0.0
            }
        }
    }
}

struct ForecastTab: View {
    
    @EnvironmentObject var weatherManager: WeatherManager
    @ObservedObject var monitor = NetworkMonitor()
    
    let dayOfWeek = Date().dayNumberOfWeek()
    
    var body: some View {
        
        if !monitor.isConnected {
            NoConnectionView()
        } else {
            NavigationView {
                
                if weatherManager.weatherDataAvailable {
                    VStack {
                        HStack {
                            Spacer()
                              TableView()
                            Spacer()
                        }
                    }.navigationTitle("Forecast")
                        .font(.system(size: 22, weight: .bold))
                } else {
                    if !weatherManager.locationAuthorized {
                        Text("Search for data")
                    } else {
                        VStack {
                            ActivityIndicator()
                                .padding()
                            Text("Trying to get forecast data")
                                .font(.system(size: 20, weight: .regular))
                        }
                    }
                }
            }
        }
        
    }
}

struct ForecastTab_Previews: PreviewProvider {
    static var previews: some View {
        ForecastTab()
            .environmentObject(WeatherManager())
    }
}

struct TableView: UIViewRepresentable {
    
    @EnvironmentObject var weatherManager: WeatherManager
    
    func makeCoordinator() -> Coordinator {
        // pass @EnvironmentObject to coordinator
        Coordinator(weatherManager: weatherManager)
    }
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "reusableCell")
        tableView.rowHeight = 80
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        // update coordinator properties before tableview reload
        context.coordinator.updateCoordinator()
        uiView.reloadData()
    }
    
    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var weatherManagerCoordinator: WeatherManager
        var forecastList: [ForecastWeatherModel]
        var forecastOffset: Int
        let daysOfWeek: [String] = ["Sunday", "Moday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        var unitsString: String
        let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        
        let screenWidth = UIScreen.main.bounds.size.width
       
        init(weatherManager: WeatherManager) {
            self.forecastList = weatherManager.forecastList
            self.forecastOffset = weatherManager.forecastOffset
            self.weatherManagerCoordinator = weatherManager
            self.unitsString = " °C"
        }
        
        // update coordinator properties from @EnvironmentObject
        func updateCoordinator() {
            self.forecastList = weatherManagerCoordinator.forecastList
            self.forecastOffset = weatherManagerCoordinator.forecastOffset
            self.unitsString = weatherManagerCoordinator.unitsStringUI
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if forecastList.isEmpty {
                return 0
            } else {
                var numberOfRows: Int = 0
                
                switch section {
                case 0:
                    numberOfRows = forecastOffset
                case 1:
                    numberOfRows = 8
                case 2:
                    numberOfRows = 8
                case 3:
                    numberOfRows = 8
                case 4:
                    numberOfRows = (8 - forecastOffset)
                default:
                    numberOfRows = 8
                }
                return numberOfRows
            }
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 5    // forecast for 5 days ahead
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 100))
            
            let dayLabelLeft = UILabel(frame: CGRect(x: 15, y: 5, width: 200, height: 20))
            dayLabelLeft.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            
            let dateLabelRight: UILabel
            
            if screenWidth == 320 {
                dateLabelRight = UILabel(frame: CGRect(x: 95, y: 5, width: 200, height: 20))
                dateLabelRight.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                dateLabelRight.textColor = UIColor(named: "labelColor")
                dateLabelRight.textAlignment = .right
            } else {
                dateLabelRight = UILabel(frame: CGRect(x: 150, y: 5, width: 200, height: 20))
                dateLabelRight.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                dateLabelRight.textColor = UIColor(named: "labelColor")
                dateLabelRight.textAlignment = .right
            }
            
            let date = Date().nextFiveDays(dayIndex: section) ?? Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, d MMM"
            let next5DaysDateString = dateFormatter.string(from: date)
            
            var today = Date().dayNumberOfWeek() ?? 0
            today -= 1 // index of array starts from 0
            let dayIndex = (today + section) % 7 // wrap index if exceeds 7 days in array
            
            
            if section == 0 {
                dayLabelLeft.text = "Today"
            } else if section == 1 {
                dayLabelLeft.text = "Tomorrow"
            } else {
                dayLabelLeft.text = daysOfWeek[dayIndex]
            }
            
            dateLabelRight.text = next5DaysDateString
            
            headerView.addSubview(dayLabelLeft)
            headerView.addSubview(dateLabelRight)
            
            return headerView
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell", for: indexPath) as? Cell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            
            
            switch indexPath.section {
            case 0:
                let index = indexPath.row
                cell.imageViewCell.image = UIImage(systemName: forecastList[index].conditionName, withConfiguration: largeConfiguration)
                cell.timeLabel.text = forecastList[index].timeString
                cell.predictionLabel.text = forecastList[index].weatherOutputText
                cell.tempLabel.text = forecastList[index].temperatureString + unitsString
                
            case 1:
                let index = indexPath.row + forecastOffset
                cell.imageViewCell.image = UIImage(systemName: forecastList[index].conditionName, withConfiguration: largeConfiguration)
                cell.timeLabel.text = forecastList[index].timeString
                cell.predictionLabel.text = forecastList[index].weatherOutputText
                cell.tempLabel.text = forecastList[index].temperatureString + unitsString
                
            case 2:
                let index = indexPath.row + forecastOffset + 8
                cell.imageViewCell.image = UIImage(systemName: forecastList[index].conditionName, withConfiguration: largeConfiguration)
                cell.timeLabel.text = forecastList[index].timeString
                cell.predictionLabel.text = forecastList[index].weatherOutputText
                cell.tempLabel.text = forecastList[index].temperatureString + unitsString
                
            case 3:
                let index = indexPath.row + forecastOffset + 16
                cell.imageViewCell.image = UIImage(systemName: forecastList[index].conditionName, withConfiguration: largeConfiguration)
                cell.timeLabel.text = forecastList[index].timeString
                cell.predictionLabel.text = forecastList[index].weatherOutputText
                cell.tempLabel.text = forecastList[index].temperatureString + unitsString
                
            case 4:
                let index = indexPath.row + forecastOffset + 24
                cell.imageViewCell.image = UIImage(systemName: forecastList[index].conditionName, withConfiguration: largeConfiguration)
                cell.timeLabel.text = forecastList[index].timeString
                cell.predictionLabel.text = forecastList[index].weatherOutputText
                cell.tempLabel.text = forecastList[index].temperatureString + unitsString
            default:
                fatalError("Cell is not loaded")
            }
    
            return cell
        }
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        // returns 1 - 7 int, with 1 being a Sunday
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func nextFiveDays(dayIndex: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: dayIndex, to: Date())
    }
}
