# ShowUpBooster

> An iOS App Clip that reduces no-shows through frictionless event confirmation and smart reminders.

## Overview

ShowUpBooster is a lightweight App Clip solution designed to increase attendance at events, appointments, and showings. Users can confirm their attendance with a single tap - no app installation required. The system then schedules intelligent reminders to keep the event top-of-mind.

## Key Features

### 🚀 Instant Access
- **No app installation required** - App Clip opens instantly from QR code or link
- **10-second flow** - From scan to confirmation
- **Pre-filled event details** - All information passed via URL parameters

### 📱 One-Tap Confirmation
- Single "Confirm & Remind Me" button
- Automatic notification permission request
- Immediate visual feedback

### ⏰ Smart Reminders
Three-tier reminder system:
- **1 day before** - "Tomorrow: [Event]" - Plan your schedule
- **2 hours before** - "In 2 Hours: [Event]" - Time to get ready
- **30 minutes before** - "Soon: [Event]" - Heads up, starting soon

### 📊 Event Types Supported
- Open Houses (real estate showings)
- Appointments (medical, professional)
- Property Showings
- Restaurant Reservations
- Meetings
- General Events

### 💎 User Experience
- Clean, modern SwiftUI interface
- Status tracking (Confirmed, Running Late, Cancelled)
- Celebration screen after confirmation
- Accessible design with SF Symbols
- Adaptive to iOS Dark Mode

## Technical Architecture

### Tech Stack
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **iOS Version**: 16.0+
- **Notifications**: UserNotifications framework
- **URL Handling**: Universal Links + Custom URL Scheme

### Project Structure

```
ShowUpBooster/
├── Models/
│   └── Event.swift                 # Event data model with URL encoding
├── Services/
│   └── NotificationManager.swift   # Notification permission & scheduling
├── ViewModels/
│   └── EventViewModel.swift        # Confirmation logic & state management
├── Views/
│   ├── EventDetailView.swift       # Main confirmation screen
│   └── ConfirmationSuccessView.swift # Success screens
└── ShowUpBoosterApp.swift          # App entry with URL handling
```

### Key Components

#### Event Model (`Event.swift`)
- Codable struct with URL parameter support
- Properties: title, location, dateTime, host info, event type, notes
- Methods:
  - `toURLParameters()` - Generates query items for URL
  - `fromURL()` - Parses event from incoming URL
  - Computed properties for formatted display

#### NotificationManager (`NotificationManager.swift`)
- Singleton service for notification management
- Handles permission requests
- Schedules notifications using `UNUserNotificationCenter`
- Calendar-based triggers for precise timing
- Error handling with custom `NotificationError` enum

#### EventViewModel (`EventViewModel.swift`)
- ObservableObject for event state
- Manages attendance status (pending → confirmed → late/cancelled)
- Coordinates between UI and NotificationManager
- Provides UI helper properties (button text, status messages, icons)

#### EventDetailView (`EventDetailView.swift`)
- Main user interface
- Displays event information with icons
- Large, accessible confirmation button
- Conditional rendering based on confirmation state
- Secondary actions (running late, cancel)

## URL Schemes & Invocation

### ⚠️ Important: App Clip Invocation

**App Clips can only be invoked by Universal Links (https://), not custom URL schemes!**

ShowUpBooster supports two URL types:

#### 1. Universal Links (Production - Invokes App Clip)
```
https://showupbooster.app/?title=...&location=...&dateTime=...
```

**Use for**:
- ✅ App Clip invocation from QR codes
- ✅ App Clip invocation from NFC tags
- ✅ App Clip invocation from links in Safari, Messages, etc.
- ✅ Production deployment

**Requires**: Domain registration, AASA file, Associated Domains capability

#### 2. Custom URL Scheme (Development - Already Running Only)
```
showupbooster://?title=...&location=...&dateTime=...
```

**Use for**:
- ✅ Testing URL parameter parsing when App Clip is already running
- ✅ Quick development iteration
- ❌ **Does NOT invoke App Clip from cold start**

**See**: [APP_CLIP_TESTING_QUICK_REFERENCE.md](APP_CLIP_TESTING_QUICK_REFERENCE.md) for detailed testing strategies

### URL Parameters

#### Required
- `title` - Event name
- `location` - Event address/location
- `dateTime` - ISO 8601 format (UTC): `YYYY-MM-DDTHH:MM:SSZ`

### Optional Parameters
- `hostName` - Name of event host
- `hostContact` - Email or phone number
- `eventType` - One of: `openHouse`, `appointment`, `showing`, `reservation`, `meeting`, `other`
- `additionalNotes` - Any extra information

### Example URL
```
showupbooster://?title=Modern%20Villa%20Open%20House&location=123%20Maple%20Street&dateTime=2026-03-01T14:00:00Z&hostName=Sarah%20Johnson&hostContact=sarah@realestate.com&eventType=openHouse&additionalNotes=3bed%202bath
```

## Setup & Installation

### Prerequisites
- Xcode 15.0+
- iOS Simulator or device with iOS 16.0+
- macOS with command line tools

### Quick Start

```bash
# Open the project
cd /Users/I818292/Documents/Funs/ShowUpBooster
open ShowUpBooster.xcodeproj
```

Then follow these steps:

1. **Create App Clip Target**: File → New → Target → App Clip (name it `ShowUpBoosterClip`)
2. **Add Files to App Clip**: Add Models, Services, ViewModels, and Views folders to the App Clip target
3. **Configure Invocation URL**: Product → Scheme → Edit Scheme → Options → Set App Clip Invocation URL
4. **Add Privacy Description**: Add notification usage description to Info.plist
5. **Build & Run**: Select `ShowUpBoosterClip` scheme and press ⌘R

**Quick Testing**: See [QUICK_START_TESTING.md](QUICK_START_TESTING.md) for 30-second testing guide

**Detailed Setup**: See [XCODE_SETUP_GUIDE.md](XCODE_SETUP_GUIDE.md) for complete step-by-step instructions

**⚠️ Important**: ShowUpBooster is designed as an **App Clip**, not a traditional app. Create the App Clip target first before adding files.

## Testing

### Generate Test URLs

Use the included test script:

```bash
cd /Users/I818292/Documents/Funs/ShowUpBooster
./generate_test_link.sh
```

The script provides:
- **Preset events** - Open House, Dental Appointment, Interview, Dinner
- **Custom events** - Enter your own details
- **Automatic URL encoding**
- **Simulator testing** - Opens URL directly in running simulator
- **QR code generation** - Requires `qrencode` (`brew install qrencode`)
- **Clipboard copy** - Easy sharing

### Manual Testing

```bash
# Open a test URL
xcrun simctl openurl booted "showupbooster://?title=Test%20Event&location=Office&dateTime=2026-03-10T15:00:00Z"
```

### Test Checklist

- [ ] URL parsing works correctly
- [ ] Event details display properly
- [ ] Confirmation button triggers permission request
- [ ] Permission grant/deny handled gracefully
- [ ] Reminders schedule successfully
- [ ] Confirmation screen appears
- [ ] Status changes to "Confirmed"
- [ ] "Running Late" updates status
- [ ] "Can't Make It" cancels reminders
- [ ] Past events show disabled state
- [ ] Error states display clearly

## User Flow

### Happy Path
1. **User scans QR code** or taps link
2. **App Clip opens** - < 2 seconds
3. **Event details display** - Pre-filled from URL
4. **User taps "Confirm & Remind Me"**
5. **Permission prompt appears** (first time only)
6. **User grants notifications**
7. **Reminders schedule** - 3 notifications set
8. **Success screen shows** - Celebration with reminder list
9. **User taps "Got It!"** - Returns to event screen
10. **Confirmed badge visible** - Status tracking

### Alternative Paths
- **Permission denied**: Show message explaining reminders won't work
- **Past event**: Button disabled, "Event has passed" message
- **Running late**: Update status, notify host (future feature)
- **Cancel**: Remove reminders, mark declined

## Implementation Details

### Notification Scheduling
Uses `UNCalendarNotificationTrigger` for precise timing:

```swift
// Example: Schedule reminder 2 hours before
let eventDate = event.dateTime
let twoHoursBefore = eventDate.addingTimeInterval(-2 * 60 * 60)

let calendar = Calendar.current
let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: twoHoursBefore)

let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
```

### URL Parameter Parsing
Robust parsing with error handling:

```swift
static func fromURL(_ url: URL) -> Event? {
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
          let queryItems = components.queryItems else {
        return nil
    }
    
    // Extract required parameters
    guard let title = param("title"),
          let location = param("location"),
          let dateTimeString = param("dateTime"),
          let dateTime = ISO8601DateFormatter().date(from: dateTimeString) else {
        return nil
    }
    
    // Create event with parsed data
    return Event(...)
}
```

### State Management
Uses SwiftUI's `@StateObject` and `@Published`:

```swift
@MainActor
class EventViewModel: ObservableObject {
    @Published var event: Event
    @Published var isConfirmed = false
    @Published var isLoading = false
    @Published var attendanceStatus: AttendanceStatus = .pending
    
    func confirmAttendance() async {
        isLoading = true
        // Request permission, schedule reminders
        isConfirmed = true
        isLoading = false
    }
}
```

## Future Enhancements

### Short-term (v1.1)
- [ ] **Host notifications** - Notify hosts when guests run late/cancel
- [ ] **Calendar integration** - Add to native Calendar app
- [ ] **Location services** - Show map, directions to event
- [ ] **Weather integration** - Show forecast for event day
- [ ] **Share feature** - Forward event to others

### Medium-term (v1.5)
- [ ] **App Clip experiences** - Register with Apple
- [ ] **Universal Links** - `https://showupbooster.app/...`
- [ ] **Full app** - History, preferences, recurring events
- [ ] **Analytics** - Track confirmation rates, no-show reduction
- [ ] **Localization** - Spanish, Chinese, Japanese support

### Long-term (v2.0)
- [ ] **Backend service** - Track RSVPs across users
- [ ] **Host dashboard** - See all guest confirmations
- [ ] **SMS/Email fallback** - For users without iOS
- [ ] **Check-in feature** - Verify arrival at event
- [ ] **Gamification** - Rewards for consistent attendance

## App Clip Architecture

ShowUpBooster is **App Clip-first** - designed for instant access without installation.

### App Clip Specifications
- **Size limit**: < 50MB (current implementation: ~5-10MB)
- **Launch time**: < 2 seconds (target: < 1 second)
- **Invocation methods**: 
  - QR codes (primary distribution)
  - NFC tags
  - Safari App Banners
  - Messages links
  - Location-based suggestions

### Optional: Full App Conversion
The full app is optional. Consider showing "Install Full App" prompts after:
- 3 event confirmations
- First successful attendance
- User requests event history

### Feature Comparison
**App Clip (Primary Experience)**:
- ✅ Single event confirmation
- ✅ Smart reminder scheduling (3-tier system)
- ✅ Status updates (running late, cancel)
- ✅ Instant access, no installation
- ✅ < 10 second confirmation flow

**Full App (Optional)**:
- Event history
- Recurring events
- Custom reminder preferences
- Host dashboard (create events, track RSVPs)
- Analytics and insights
- Widgets

**Recommendation**: Focus on perfecting the App Clip experience first. Only build the full app if users demonstrate demand for advanced features.

## Business Model

### Target Users
1. **Real estate agents** - Open house no-shows cost time
2. **Medical offices** - Appointment no-shows waste resources
3. **Service providers** - Consultations, estimates, tours
4. **Event organizers** - Meetups, workshops, showings
5. **Restaurants** - Reservation confirmations

### Value Proposition
- **Reduce no-shows by 30-50%** (industry average with reminders)
- **Zero friction** - No app install required
- **Professional appearance** - Branded confirmation flow
- **Automatic follow-up** - Reminders handle themselves

### Monetization (Future)
- **Free tier**: Basic confirmation + standard reminders
- **Pro tier** ($9.99/mo): Custom branding, host dashboard, analytics
- **Enterprise**: API access, CRM integration, white-label

## Analytics & Metrics

### Key Metrics to Track
- **Conversion rate**: QR scan → confirmation
- **Permission grant rate**: Confirmation → notification permission
- **No-show reduction**: Before vs after ShowUpBooster
- **Time to confirm**: Link open → button tap
- **Late notifications**: Users marking themselves late
- **Cancellation rate**: Events cancelled in advance

### Success Criteria
- 80%+ conversion rate (scan to confirm)
- 70%+ notification permission grant rate
- 40%+ reduction in no-shows
- < 5 seconds average time to confirm
- 4.5+ star rating in App Store

## Support & Contributing

### Getting Help
- Check [XCODE_SETUP_GUIDE.md](XCODE_SETUP_GUIDE.md) for setup issues
- Review this README for architecture questions
- Check Xcode console for runtime errors

### Common Issues

**Q: Files not compiling?**
A: Files exist on disk but aren't added to App Clip target. See [XCODE_SETUP_GUIDE.md](XCODE_SETUP_GUIDE.md).

**Q: URL not opening App Clip?**
A: **Custom URL schemes (`showupbooster://`) do NOT invoke App Clips!** They only work when the app is already running. For actual App Clip invocation:
- Development: Use Xcode's local App Clip experience (see [APP_CLIP_TESTING_QUICK_REFERENCE.md](APP_CLIP_TESTING_QUICK_REFERENCE.md))
- Production: Use Universal Links (`https://`) with a real domain

**Q: Notifications not appearing?**
A: Check permission granted in Settings → Notifications → ShowUpBoosterClip.

**Q: Event date formatting wrong?**
A: Ensure dateTime is ISO 8601 UTC format: `YYYY-MM-DDTHH:MM:SSZ`.

## License

This project is proprietary and confidential.

## Contact

For questions or support, please contact the development team.

---

**Built with ❤️ using Swift and SwiftUI**

*Reducing no-shows, one tap at a time.*
