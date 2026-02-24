//
//  Event.swift
//  ShowUpBooster
//
//  Event model for attendance confirmation
//

import Foundation

struct Event: Identifiable, Codable {
    let id: UUID
    let title: String
    let address: String
    let dateTime: Date
    let hostName: String?
    let hostContact: String?
    let eventType: EventType?
    let additionalNotes: String?
    let latitude: Double?
    let longitude: Double?
    
    enum EventType: String, Codable {
        case openHouse = "Open House"
        case appointment = "Appointment"
        case showing = "Property Showing"
        case reservation = "Reservation"
        case meeting = "Meeting"
        case other = "Event"
    }
    
    init(
        id: UUID = UUID(),
        title: String,
        address: String,
        dateTime: Date,
        hostName: String? = nil,
        hostContact: String? = nil,
        eventType: EventType? = nil,
        additionalNotes: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.title = title
        self.address = address
        self.dateTime = dateTime
        self.hostName = hostName
        self.hostContact = hostContact
        self.eventType = eventType
        self.additionalNotes = additionalNotes
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Formatted Getters
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: dateTime)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
    
    var formattedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
    
    var timeUntilEvent: String {
        let now = Date()
        let interval = dateTime.timeIntervalSince(now)
        
        if interval < 0 {
            return "Event has passed"
        }
        
        let hours = Int(interval / 3600)
        let days = hours / 24
        
        if days > 0 {
            return days == 1 ? "Tomorrow" : "In \(days) days"
        } else if hours > 0 {
            return "In \(hours) hour\(hours == 1 ? "" : "s")"
        } else {
            let minutes = Int(interval / 60)
            return "In \(minutes) minute\(minutes == 1 ? "" : "s")"
        }
    }
    
    var isUpcoming: Bool {
        dateTime > Date()
    }
    
    // MARK: - URL Parameter Encoding/Decoding
    
    /// Convert event to URL query parameters
    func toURLParameters() -> [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "title", value: title),
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "datetime", value: ISO8601DateFormatter().string(from: dateTime))
        ]
        
        if let hostName = hostName {
            items.append(URLQueryItem(name: "host", value: hostName))
        }
        
        if let hostContact = hostContact {
            items.append(URLQueryItem(name: "contact", value: hostContact))
        }
        
        if let eventType = eventType {
            items.append(URLQueryItem(name: "type", value: eventType.rawValue))
        }
        
        if let notes = additionalNotes {
            items.append(URLQueryItem(name: "notes", value: notes))
        }
        
        if let latitude = latitude {
            items.append(URLQueryItem(name: "lat", value: String(latitude)))
        }
        
        if let longitude = longitude {
            items.append(URLQueryItem(name: "lng", value: String(longitude)))
        }
        
        return items
    }
    
    /// Parse event from URL
    static func fromURL(_ url: URL) -> Event? {
        print("🔍 Parsing URL: \(url.absoluteString)")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            print("❌ Failed to parse URL components")
            return nil
        }
        
        print("📋 Query items: \(queryItems)")
        
        let params = Dictionary(uniqueKeysWithValues: queryItems.compactMap { item in
            item.value.map { (item.name, $0) }
        })
        
        // Support both formats: dateTime and datetime, location and address
        guard let title = params["title"],
              let address = params["address"] ?? params["location"],
              let datetimeString = params["dateTime"] ?? params["datetime"],
              let dateTime = ISO8601DateFormatter().date(from: datetimeString) else {
            print("❌ Missing required parameters. Found: \(params.keys.joined(separator: ", "))")
            return nil
        }
        
        // Support both hostName and host
        let hostName = params["hostName"] ?? params["host"]
        
        // Support both hostContact and contact
        let hostContact = params["hostContact"] ?? params["contact"]
        
        // Support both eventType and type
        let eventType = (params["eventType"] ?? params["type"]).flatMap { EventType(rawValue: $0) }
        
        // Support both additionalNotes and notes
        let notes = params["additionalNotes"] ?? params["notes"]
        
        // Optional latitude and longitude
        let latitude = params["latitude"].flatMap { Double($0) } ?? params["lat"].flatMap { Double($0) }
        let longitude = params["longitude"].flatMap { Double($0) } ?? params["lng"].flatMap { Double($0) } ?? params["lon"].flatMap { Double($0) }
        
        let event = Event(
            title: title,
            address: address,
            dateTime: dateTime,
            hostName: hostName,
            hostContact: hostContact,
            eventType: eventType,
            additionalNotes: notes,
            latitude: latitude,
            longitude: longitude
        )
        
        print("✅ Successfully parsed event: \(event.title)")
        return event
    }
    
    // MARK: - Sample Data
    
    static let sample = Event(
        title: "Modern Villa Open House",
        address: "123 Oak Street, San Francisco, CA 94102",
        dateTime: Date().addingTimeInterval(7200), // 2 hours from now
        hostName: "Sarah Johnson",
        hostContact: "+1 (555) 123-4567",
        eventType: .openHouse,
        additionalNotes: "Free parking available. Please bring ID."
    )
    
    static let sample2 = Event(
        title: "Dental Appointment",
        address: "Bay Area Dental, 456 Market St #200",
        dateTime: Date().addingTimeInterval(86400), // Tomorrow
        hostName: "Dr. Michael Chen",
        hostContact: "+1 (555) 987-6543",
        eventType: .appointment
    )
}
