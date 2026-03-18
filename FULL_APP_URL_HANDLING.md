# Full App URL Handling

## Overview

Users who have downloaded the full ShowUpBooster app can now open invitation links and see the same confirmation screen as the App Clip! This provides a seamless experience whether someone uses the App Clip or the full app.

## What Changed

### 1. URL Handling in Full App
The full app now listens for incoming URLs just like the App Clip:
- **Universal Links** (`https://imentos.github.io/ShowUpBooster/?...`)

### 2. Dynamic Content View
When opened normally:
- Shows the standard tab interface (Create Event, My Events, Settings)

When opened via invitation link:
- Shows the EventDetailView with event details
- Allows attendance confirmation
- Includes a "Close" button to return to normal app interface

### 3. Associated Domain
Added `applinks:imentos.github.io` to entitlements so iOS knows the full app can handle these links.

## User Experience

### Scenario 1: New User Receives Invitation
1. User receives invitation link via Messages/Email
2. Taps the link
3. **App Clip** launches (no app installed yet)
4. User confirms attendance and gets reminders

### Scenario 2: Existing User Receives Invitation  
1. User with full app installed receives invitation link
2. Taps the link
3. **Full app** opens directly to EventDetailView
4. User confirms attendance and gets reminders
5. User can tap "Close" to return to normal app features

### Scenario 3: User Opens Full App Normally
1. User taps ShowUpBooster app icon
2. Normal tab interface appears
3. User can create events, view history, change settings

## Testing

### Test 1: Open Link in Full App

```bash
# With iOS Simulator running the FULL APP:
xcrun simctl openurl booted "https://imentos.github.io/ShowUpBooster/?title=Team%20Meeting&address=Apple%20Park&dateTime=2026-03-20T14:00:00Z&lat=37.3346&lng=-122.0090"
```

Expected result:
- Full app opens to EventDetailView
- Shows "Team Meeting" details
- "Close" button in navigation bar

### Test 2: Open Full App Normally

1. Tap app icon on home screen (or run from Xcode with full app scheme)
2. Expected: Shows tab interface with Create Event, My Events, Settings

### Test 3: Close Event View

1. Open link (Test 1)
2. Tap "Close" button in top-left
3. Expected: Returns to tab interface

### Test 4: Test from Real Device

1. Create an event in the full app
2. Copy the invitation link
3. Send to another device via Messages
4. Tap link on receiving device:
   - If they have full app: Opens in full app
   - If they don't: Shows App Clip card

## Technical Details

### AppState Management
```swift
@MainActor
class AppState: ObservableObject {
    @Published var currentEvent: Event? = nil
}
```

- Shared state between ShowUpBoosterApp and ContentView
- When `currentEvent` is set, ContentView shows EventDetailView
- When `currentEvent` is nil, ContentView shows normal tabs

### URL Handling
```swift
.onOpenURL { url in
    // Handles URL opening when app is already running
}

.onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
    // Handles universal links: https://imentos.github.io/...
}
}
```

Both handlers call `handleIncomingURL()` which:
1. Parses the URL using `Event.fromURL()`
2. Sets `appState.currentEvent` if valid
3. Triggers ContentView to show EventDetailView

### Event Parsing
The `Event.fromURL()` method supports both parameter formats:
- App Clip format: `dateTime`, `address`, `host`, `contact`, `notes`
- Alternative format: `datetime`, `location`, `hostName`, `hostContact`, `additionalNotes`

### Close Button Behavior
When user taps "Close":
```swift
Button("Close") {
    appState.currentEvent = nil
}
```

This clears the current event, causing ContentView to switch back to the tab interface.

## Benefits

1. **Unified Experience**: Same confirmation flow for App Clip and full app users
2. **Seamless Navigation**: Full app users can easily return to normal features
3. **Better Engagement**: Users who installed the full app get familiar experience
4. **Universal Link Support**: iOS automatically routes links to full app if installed

## Next Steps

### For Development
- Test both App Clip and full app with same URLs
- Verify associated domains work on real devices
- Test edge cases (malformed URLs, expired events)

### For App Store Submission
- Both App Clip and full app are now ready
- Unified experience meets App Store guidelines
- Users get consistent experience regardless of install status

### For Users
- Full app users can now:
  - Receive and confirm invitations ✅
  - Get automatic reminders ✅
  - Access full app features (create events, history) ✅
  - Switch between modes seamlessly ✅
