# ShowUpBooster - Quick Testing Guide

## Quick Start

### 1. Generate Test URL (Interactive)
```bash
cd /Users/I818292/Documents/Funs/ShowUpBooster
./generate_test_link.sh
```

Choose from preset events and automatically open in simulator.

### 2. Quick Manual Test URLs

#### Open House (3 days from now)
```bash
xcrun simctl openurl booted "showupbooster://event?title=Modern%20Villa%20Open%20House&location=123%20Maple%20Street%2C%20San%20Francisco&dateTime=2026-02-26T14:00:00Z&hostName=Sarah%20Johnson&hostContact=sarah@realestate.com&eventType=openHouse&additionalNotes=3bed%202bath"
```

#### Dental Appointment (tomorrow)
```bash
xcrun simctl openurl booted "showupbooster://event?title=Dental%20Cleaning&location=Bright%20Smile%20Dental&dateTime=2026-02-24T10:00:00Z&hostName=Dr.%20Chen&hostContact=555-0123&eventType=appointment"
```

#### Quick Test (1 hour from now)
```bash
xcrun simctl openurl booted "showupbooster://event?title=Quick%20Test%20Event&location=Test%20Location&dateTime=$(date -u -v+1H +"%Y-%m-%dT%H:%M:%SZ")&eventType=meeting"
```

## Test Flow

### Full Confirmation Flow
1. ✅ Generate/open test URL
2. ✅ App opens with event details
3. ✅ Tap "Confirm & Remind Me"
4. ✅ Grant notification permission
5. ✅ See success screen with 3 reminders
6. ✅ Return to event screen
7. ✅ Verify "Confirmed!" status badge

### Test Status Updates
After confirming, test these actions:

**Running Late:**
- Tap "Running Late" button
- Status updates to "Running Late"
- (Future: Host gets notification)

**Cancel Attendance:**
- Tap "Can't Make It" button
- Reminders cancelled
- Status updates to "Declined"

### Test Edge Cases

**Past Event:**
```bash
xcrun simctl openurl booted "showupbooster://event?title=Past%20Event&location=Somewhere&dateTime=2026-01-01T10:00:00Z"
```
Expected: Button disabled, "Event has passed" message

**Missing Required Parameters:**
```bash
xcrun simctl openurl booted "showupbooster://event?title=No%20Location%20Event"
```
Expected: App shows placeholder or error

**Denied Notification Permission:**
1. Open Settings → Notifications → ShowUpBooster
2. Disable notifications
3. Try confirming event
Expected: Error message explaining reminders won't work

## Check Scheduled Notifications

### In Simulator
Unfortunately, there's no easy way to see pending notifications in simulator. You can:

1. Check Xcode console for "✅ Scheduled reminder" logs
2. Advance simulator time to trigger notifications:
   - This requires advanced simulator manipulation
3. Trust the logs and test on real device

### On Real Device
1. Settings → Notifications → ShowUpBooster
2. See "Recent Notifications" (after they fire)
3. Or use Console app on Mac to see system logs

## Quick Commands

### Open Simulator
```bash
open -a Simulator
```

### Boot Specific Device
```bash
xcrun simctl boot "iPhone 15 Pro"
open -a Simulator
```

### List All Simulators
```bash
xcrun simctl list devices
```

### Uninstall App from Simulator
```bash
xcrun simctl uninstall booted com.showupbooster.ShowUpBooster
```

### Reset All Simulators (Nuclear Option)
```bash
xcrun simctl erase all
```

## Debugging

### View App Logs in Xcode
1. ⌘R to run app
2. Open Debug Console (⇧⌘C)
3. Look for ShowUpBooster log statements:
   - `📱 ShowUpBooster received URL:`
   - `✅ Successfully parsed event:`
   - `🔔 Requesting notification permission...`
   - `✅ Scheduled reminder:`

### Check Notification Center State
```swift
// Add temporary code to EventViewModel
Task {
    let center = UNUserNotificationCenter.current()
    let pending = await center.pendingNotificationRequests()
    print("📋 Pending notifications: \(pending.count)")
    for request in pending {
        print("  - \(request.identifier)")
    }
}
```

### Monitor URL Handling
Look for these logs in Xcode console:
```
📱 ShowUpBooster received URL: showupbooster://event?...
✅ Successfully parsed event: Modern Villa Open House
```

If you see:
```
❌ Failed to parse event from URL
```
Check URL parameter formatting.

## Testing Checklist

### Basic Functionality
- [ ] App launches from URL
- [ ] Event details display correctly
- [ ] Date/time formatted properly
- [ ] Location shown
- [ ] Host info displayed
- [ ] Event type icon correct

### Confirmation Flow
- [ ] Button enabled for future events
- [ ] Button disabled for past events
- [ ] Loading state shows during async operation
- [ ] Permission request appears (first time)
- [ ] Success screen shows after grant
- [ ] Confirmed badge appears
- [ ] All 3 reminders listed

### Error Handling
- [ ] Missing parameters handled gracefully
- [ ] Invalid date format caught
- [ ] Permission denial doesn't crash
- [ ] Network/system errors shown to user

### UI/UX
- [ ] Dark mode looks good
- [ ] Large text accessibility works
- [ ] VoiceOver reads properly
- [ ] Animations smooth
- [ ] Colors match design
- [ ] SF Symbols display correctly

### Status Updates
- [ ] "Running Late" changes status
- [ ] "Can't Make It" updates correctly
- [ ] Status icons show properly
- [ ] Status colors match state

## Performance Testing

### Launch Time
Target: < 2 seconds from URL to visible UI

```bash
# Time the launch manually or use:
time xcrun simctl openurl booted "showupbooster://event?..."
```

### Confirmation Time
Target: < 1 second from tap to success screen (excluding permission prompt)

### Memory Usage
Should be < 50MB throughout session.

## QR Code Testing

### Generate QR Code
```bash
# Install qrencode if needed
brew install qrencode

# Run test script and choose QR option
./generate_test_link.sh
# Select option 2: Generate QR code
```

### Test QR Scanning
1. Open Camera app on iPhone
2. Point at QR code on screen
3. Tap notification banner
4. App Clip should launch (need App Clip setup first)

## Automated Testing (Future)

### UI Tests to Add
- Launch from URL test
- Confirmation flow test
- Permission handling test
- Status update tests
- Error state tests

### Example UI Test
```swift
func testEventConfirmationFlow() {
    let app = XCUIApplication()
    
    // Launch with URL
    app.launchEnvironment = ["testURL": "showupbooster://event?..."]
    app.launch()
    
    // Verify event details
    XCTAssertTrue(app.staticTexts["Modern Villa Open House"].exists)
    
    // Tap confirm button
    app.buttons["Confirm & Remind Me"].tap()
    
    // Handle permission if needed
    addUIInterruptionMonitor(withDescription: "Notifications") { alert in
        alert.buttons["Allow"].tap()
        return true
    }
    
    // Verify success
    XCTAssertTrue(app.staticTexts["You're All Set!"].exists)
}
```

## Tips & Tricks

### Rapid Testing
Create a bash script with your favorite test URLs:

```bash
#!/bin/bash
# quick_test.sh

case $1 in
    1) url="showupbooster://event?title=Test1&..." ;;
    2) url="showupbooster://event?title=Test2&..." ;;
    3) url="showupbooster://event?title=Test3&..." ;;
esac

xcrun simctl openurl booted "$url"
```

Usage: `./quick_test.sh 1`

### Reset Notification Permissions
```bash
# Reset all simulator privacy settings
xcrun simctl privacy booted reset all com.showupbooster.ShowUpBooster
```

### Capture Screenshots
```bash
xcrun simctl io booted screenshot screenshot.png
```

### Record Video
```bash
xcrun simctl io booted recordVideo --codec=h264 demo.mp4
# Press Ctrl+C to stop
```

## Troubleshooting

### URL Not Opening App
**Check:**
1. URL scheme configured in Xcode (Info → URL Types)
2. Bundle identifier matches
3. Simulator/device restarted after changes
4. App installed on device

**Fix:**
```bash
# Reinstall app
xcrun simctl uninstall booted com.showupbooster.ShowUpBooster
# Then build & run again in Xcode
```

### Notifications Not Scheduling
**Check:**
1. Permission granted (Settings → Notifications → ShowUpBooster)
2. Event is in the future (can't schedule past notifications)
3. Check Xcode console for error logs

**Debug:**
```swift
// Add to confirmAttendance() in EventViewModel
print("📅 Scheduling reminders for: \(event.dateTime)")
print("⏰ Day before: \(event.dateTime.addingTimeInterval(-24*60*60))")
print("⏰ Two hours: \(event.dateTime.addingTimeInterval(-2*60*60))")
print("⏰ Thirty min: \(event.dateTime.addingTimeInterval(-30*60))")
```

### App Crashes on Launch
**Check:**
1. All files added to Xcode target
2. No typos in URL parameter parsing
3. Info.plist has notification usage description

**Fix:**
- Check Xcode console for exception details
- Add breakpoint in `handleIncomingURL()`
- Step through URL parsing

## Next Steps

After basic testing works:
1. Test on real device (better notification testing)
2. Set up App Clip target
3. Configure Universal Links
4. Create App Clip experiences
5. Add analytics
6. A/B test UI variations
7. Beta test with real users

---

For full setup instructions, see [XCODE_SETUP_GUIDE.md](XCODE_SETUP_GUIDE.md)

For architecture details, see [README.md](README.md)
