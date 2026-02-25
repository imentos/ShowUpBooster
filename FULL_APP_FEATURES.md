# ShowUpBooster Full App - Event Link Generator

## Overview

The ShowUpBooster full app allows event hosts to create and share invitation links that recipients can open as App Clips for instant attendance confirmation.

## Features

### 1. Create Event Invitations
- **Event Details Form**:
  - Event title
  - Event type (Meeting, Appointment, Open House, etc.)
  - Event address
  - Date & time picker (future dates only)
  - Host information (optional)
  - Additional notes (optional)

### 2. Location Search
- **Automatic Geocoding**:
  - Tap "Find Location Coordinates" to search for the address
  - Uses Apple Maps to find latitude/longitude
  - Required for showing event location on map in App Clip
  - Coordinates displayed after successful search

### 3. Link Generation
- **One-Tap URL Creation**:
  - Generates shareable URL with all event details
  - Format: `https://imentos.github.io/ShowUpBooster/?title=...&address=...&dateTime=...&lat=...&lng=...`
  - URL encodes all parameters automatically
  - ISO8601 datetime format for universal compatibility

### 4. Share & Copy
- **Multiple Sharing Options**:
  - **Copy Link**: Copies URL to clipboard
  - **Share**: Opens iOS share sheet for:
    - Messages (best experience - App Clip card appears)
    - Email
    - WhatsApp/Telegram
    - Social media
    - Any app that accepts URLs

### 5. Event History
- **Automatic Saving**:
  - All generated events saved locally
  - Sorted by creation date (newest first)
  - Shows event status (Upcoming vs Past)
  - Quick access to copy/share links again
  - Swipe to delete old events

### 6. Settings
- **Default Host Information**:
  - Set your name and contact once
  - Auto-fills when creating new events
  - Saves time for frequent event creators
  
- **App Information**:
  - Version number
  - Links to privacy policy
  - Links to support/FAQ
  - How It Works guide

## User Flow

```
1. Host opens ShowUpBooster full app
   ↓
2. Fills in event details
   ↓
3. Taps "Find Location Coordinates"
   ↓
4. Taps "Generate Invitation Link"
   ↓
5. Shares link via Messages/Email
   ↓
6. Recipient taps link on iPhone
   ↓
7. App Clip card appears instantly
   ↓
8. Recipient confirms attendance
   ↓
9. Automatic reminders scheduled (24h, 2h, 30min before)
```

## Technical Implementation

### URL Structure

```
https://imentos.github.io/ShowUpBooster/
  ?title=Team%20Meeting
  &address=Apple%20Park%2C%20Cupertino
  &dateTime=2026-03-15T14:00:00Z
  &lat=37.3346
  &lng=-122.0090
  &host=Sarah%20Johnson
  &contact=sarah%40example.com
  &type=Meeting
  &notes=Bring%20your%20laptop
```

### Required Parameters
- `title`: Event name
- `address`: Event location
- `dateTime`: ISO8601 format (e.g., `2026-03-15T14:00:00Z`)
- `lat`: Latitude (required for map)
- `lng`: Longitude (required for map)

### Optional Parameters
- `host`: Host name
- `contact`: Host email/phone
- `type`: Event type (Meeting, Appointment, etc.)
- `notes`: Additional information

### Data Storage

**Local Storage (UserDefaults)**:
- Saved events: Stored as JSON data
- Default host name: String
- Default host contact: String

**No Cloud Sync**: All data stays on device for privacy

### Location Search

Uses `MKLocalSearch` to geocode addresses:
```swift
let searchRequest = MKLocalSearch.Request()
searchRequest.naturalLanguageQuery = eventAddress

let search = MKLocalSearch(request: searchRequest)
search.start { response, error in
    // Returns CLLocationCoordinate2D
}
```

## UI Components

### Tab Navigation
1. **Create Event** (plus.circle.fill)
   - Primary screen for creating invitations
   - Form-based interface
   - Real-time validation

2. **My Events** (list.bullet)
   - History of created events
   - Quick share/copy actions
   - Swipe to delete

3. **Settings** (gear)
   - Default host info
   - App information
   - Help & support

### Color Scheme
- **Accent Color**: Purple (matches app icon)
- **Secondary**: Blue (for links and highlights)
- **Form Style**: iOS system form

## Integration with App Clip

The full app generates URLs that trigger the ShowUpBooster App Clip:

1. **URL Recognition**:
   - AASA file validates domain
   - App Clip Experience configured for URL prefix
   - Apple shows App Clip card on Safari/Messages

2. **Parameter Passing**:
   - App Clip extracts query parameters
   - Populates event details automatically
   - Shows map with coordinates
   - Schedules notifications

3. **No App Required**:
   - Recipients don't need full app
   - App Clip works instantly
   - < 50MB download
   - Clears after 30 days if unused

## Best Practices for Hosts

### Creating Events
✅ **DO**:
- Use descriptive event titles
- Provide complete addresses
- Always find location coordinates
- Test the link before sharing
- Share via Messages for best experience

❌ **DON'T**:
- Use special characters in titles (keep it simple)
- Skip finding coordinates (map won't work)
- Create events for past dates
- Share links for sensitive events publicly

### Sharing Links
📱 **Best Channels**:
1. **Messages**: App Clip card appears automatically
2. **Email**: Works well, includes rich preview
3. **Calendar invites**: Add URL to event description
4. **QR codes**: Generate from URL for physical signage

⚠️ **Avoid**:
- Social media posts (anyone can see)
- Public forums
- Group chats with strangers

## Privacy & Security

### Host Privacy
- No account required
- No data uploaded to servers
- All data stays on device
- Can delete history anytime

### Recipient Privacy
- No personal data collected from recipients
- App Clip doesn't track users
- Notifications stored locally only
- No analytics or tracking

### URL Security
- URLs contain event details (not personal data)
- No authentication required
- Anyone with URL can view event details
- Consider this when sharing sensitive events

## Future Enhancements

Potential features for future versions:

- [ ] Calendar integration (export to iOS Calendar)
- [ ] Custom branding (upload logo for App Clip card)
- [ ] RSVP tracking (see who confirmed)
- [ ] Multiple events from CSV
- [ ] Templates for recurring events
- [ ] Notification delivery confirmation
- [ ] Event capacity limits
- [ ] Custom reminder times
- [ ] Integration with Zoom/Teams for virtual events
- [ ] QR code generation in-app

## Troubleshooting

### "Location search failed"
**Solution**: Check internet connection, verify address is valid

### "Generated URL doesn't trigger App Clip"
**Solution**: Wait 2-24 hours after App Store approval for CDN propagation

### "Recipients don't see App Clip card"
**Solution**: 
- Verify they're using iPhone (iOS 14+)
- Ask them to open in Safari or Messages
- Check App Clip Experience is approved in App Store Connect

### "Event coordinates not accurate"
**Solution**: 
- Try more specific address (include city, state, ZIP)
- Use full street address instead of building names
- Manually verify coordinates after search

## Support

For questions or issues:
- **Support Page**: https://imentos.github.io/ShowUpBooster/support.html
- **GitHub Issues**: https://github.com/imentos/ShowUpBooster/issues
- **Email**: [Your support email]

---

**Built with SwiftUI • iOS 16.0+ • App Clips • MapKit • UserNotifications**
