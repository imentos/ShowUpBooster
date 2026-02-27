# App Clip Testing Quick Reference

## ⚠️ Critical Understanding

**Custom URL schemes do NOT invoke App Clips!**

- ❌ `showupbooster://` - Does NOT launch App Clip
- ✅ `https://imentos.github.io/ShowUpBooster/?...` - Launches App Clip
- ✅ QR code with https:// URL - Launches App Clip
- ✅ NFC tag with https:// URL - Launches App Clip

## Why This Matters

**URL Schemes** (`myapp://`):
- Only work for **installed apps**
- Do NOT trigger App Clip invocation
- iOS doesn't know which app to open until it's installed

**Universal Links** (`https://`):
- Tell iOS "this domain is associated with this App Clip"
- iOS can download and launch the App Clip
- This is how App Clips are meant to be discovered

## Three Ways to Test App Clips

### Method 1: Quick Parameter Testing (Already Running)

**Use when**: Testing URL parameter parsing, debugging UI with different event data

**Steps**:
1. Run App Clip in Xcode (⌘R with ShowUpBoosterClip scheme)
2. App Clip shows PlaceholderView
3. Send URL from terminal:
```bash
xcrun simctl openurl booted "showupbooster://event?title=Test&location=Here&dateTime=2026-03-01T14:00:00Z"
```
4. App Clip receives URL and displays event

**What this tests**: ✅ URL parsing, ✅ Event display, ✅ Confirmation flow  
**What this doesn't test**: ❌ App Clip invocation (already running)

### Method 2: Local App Clip Experience (Xcode)

**Use when**: Testing real App Clip invocation flow without a domain

**Steps**:

#### Option A: App Clip Invocation URL (Easiest - Recommended)
1. Select **ShowUpBoosterClip** scheme in Xcode
2. Product → Scheme → Edit Scheme
3. Select **Run** → **Options** tab
4. Scroll down to **App Clip Invocation** section
5. Set **URL**: `https://imentos.github.io/ShowUpBooster/?title=Test%20Event&location=Test%20Location&dateTime=2026-03-01T14:00:00Z`
6. Click "Close"
7. Run (⌘R)

The App Clip launches as if invoked by that URL - exactly like scanning a QR code!

**Pro tip**: Change this URL anytime to test different events without editing code.

#### Option B: Environment Variable (Alternative)
1. Product → Scheme → Edit Scheme
2. Run → Arguments tab
3. Add Environment Variable:
   - Name: `_XCAppClipURL`
   - Value: `https://imentos.github.io/ShowUpBooster/?title=Test&location=Here&dateTime=2026-03-01T14:00:00Z`
4. Run (⌘R)
5. App Clip launches with that URL

#### Option C: Local Experience (Advanced)
1. Product → Scheme → Edit Scheme
2. Run → Options tab
3. Check "Register local App Clip experience"
4. Set URL: `https://imentos.github.io/ShowUpBooster/`
5. Close and Run (⌘R)
6. Open Safari in simulator
7. Navigate to: `https://imentos.github.io/ShowUpBooster/?title=Test&location=Here&dateTime=2026-03-01T14:00:00Z`
8. App Clip invokes

**What this tests**: ✅ App Clip invocation, ✅ URL parsing, ✅ Full flow  
**What this doesn't test**: ❌ Real-world discovery (QR codes, NFC, location-based)

### Method 3: Production Setup (Real Domain)

**Use when**: Final testing before launch, testing QR codes/NFC

**Requirements**:
- Registered domain (e.g., `imentos.github.io`)
- HTTPS server to host AASA file
- App Store Connect configuration

**Steps**:
1. Register domain
2. Create AASA file:
```json
{
  "appclips": {
    "apps": ["2HQJC64KR8.rkuo.ShowUpBooster.Clip"]
  }
}
```
3. Host at: `https://imentos.github.io/.well-known/apple-app-site-association`
4. Add Associated Domain to App Clip: `appclips:imentos.github.io`
5. Create App Clip Experience in App Store Connect
6. Test with real URLs, QR codes, NFC

**What this tests**: ✅ Everything (real-world scenario)

## Quick Commands

### Test URL Parsing (Already Running)
```bash
# Open House
xcrun simctl openurl booted "showupbooster://?title=Open%20House&location=123%20Main%20St&dateTime=2026-03-10T14:00:00Z&eventType=openHouse"

# Appointment
xcrun simctl openurl booted "showupbooster://?title=Dentist&location=Dental%20Office&dateTime=2026-02-25T10:00:00Z&eventType=appointment"

# Quick Test (1 hour from now)
xcrun simctl openurl booted "showupbooster://?title=Test&location=Here&dateTime=$(date -u -v+1H +"%Y-%m-%dT%H:%M:%SZ")"
```

### Generate Test URL
```bash
cd /Users/I818292/Documents/Funs/ShowUpBooster
./generate_test_link.sh
```

### Check Running Simulators
```bash
xcrun simctl list devices | grep Booted
```

### Reset Simulator (Clean State)
```bash
xcrun simctl erase all
```

## Common Issues

### "Nothing happens when I click the link"
**Problem**: Using `showupbooster://` expecting App Clip invocation  
**Solution**: Use Method 2 (Local Experience) or Method 3 (Real Domain)

### "Main app opens instead of App Clip"
**Problem**: Both have same URL scheme, main app is installed  
**Solution**: 
1. Delete main app from simulator
2. Only run App Clip scheme
3. Or use different URL schemes for each

### "App Clip already running, URL not working"
**Problem**: App Clip may not be handling URL correctly  
**Solution**: Check Xcode console for logs:
```
📱 ShowUpBooster received URL: ...
✅ Successfully parsed event: ...
```

### "Universal Link not invoking App Clip"
**Problem**: Associated Domains or AASA file not configured  
**Solution**:
1. Check Associated Domains capability added
2. Verify AASA file is accessible (curl it)
3. Check App Store Connect configuration
4. Try uninstalling and reinstalling

## Debugging Tips

### Check if URL is received
Add to `ShowUpBoosterClipApp.swift`:
```swift
.onOpenURL { url in
    print("🔴 DEBUG: Received URL: \(url.absoluteString)")
    handleIncomingURL(url)
}
```

### Check URL parsing
Add to `Event.swift`:
```swift
static func fromURL(_ url: URL) -> Event? {
    print("🔴 DEBUG: Parsing URL: \(url.absoluteString)")
    // ... existing code
    print("🔴 DEBUG: Parsed title: \(title)")
    // ... rest of parsing
}
```

### Check notification scheduling
Add to `confirmAttendance()`:
```swift
print("🔴 DEBUG: Event datetime: \(event.dateTime)")
print("🔴 DEBUG: Scheduling reminders...")
try await notificationManager.scheduleReminders(for: event)
print("🔴 DEBUG: Reminders scheduled successfully")
```

## Best Development Workflow

**During Development** (iterating on UI/logic):
1. Use Method 1 (Already Running)
2. Run App Clip once (⌘R)
3. Keep changing URL parameters from terminal
4. Fast iteration, no rebuilds needed

**Before Committing** (testing full flow):
1. Use Method 2 (Local Experience)
2. Test App Clip invocation
3. Verify full confirmation flow
4. Test edge cases (past events, no permissions, etc.)

**Before Release** (production testing):
1. Use Method 3 (Real Domain)
2. Test QR code scanning
3. Test NFC tag reading
4. Test location-based invocation (if configured)
5. Test on multiple devices

## References

- [Apple: Testing App Clips](https://developer.apple.com/documentation/app_clips/testing_your_app_clip_s_launch_experience)
- [Apple: App Clip URL Schemes](https://developer.apple.com/documentation/app_clips/creating_an_app_clip_with_xcode)
- [QuickRent Project](../QuickRent) - Similar App Clip implementation

---

**Remember**: App Clips are about discovery without installation. Universal Links (https://) are the only way to achieve this. Custom URL schemes are just for convenience when the app is already running.
