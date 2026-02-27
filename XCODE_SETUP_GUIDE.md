# ShowUpBooster - Xcode Setup Guide

## Overview
ShowUpBooster is an **App Clip** - a lightweight experience that doesn't require app installation. Files have been created and need to be added to your Xcode App Clip target to build successfully.

## Files Created

### Models
- `ShowUpBooster/Models/Event.swift` - Event data model with URL encoding

### Serviceshttps://imentos.github.io/ShowUpBooster/?title=Test&address=Cupertino&dateTime=2026-03-01T14:00:00Z
- `ShowUpBooster/Services/NotificationManager.swift` - Notification permission and reminder scheduling

### ViewModels
- `ShowUpBooster/ViewModels/EventViewModel.swift` - Event confirmation logic

### Views
- `ShowUpBooster/Views/EventDetailView.swift` - Main event confirmation screen
- `ShowUpBooster/Views/ConfirmationSuccessView.swift` - Success views after confirmation

### App
- `ShowUpBooster/ShowUpBoosterApp.swift` - Updated with URL handling

### Testing
- `generate_test_link.sh` - Test URL generator script

## Setup Steps

### 1. Open Xcode Project
```bash
cd /Users/I818292/Documents/Funs/ShowUpBooster
open ShowUpBooster.xcodeproj
```

### 2. Create App Clip Target

Since ShowUpBooster is designed as an App Clip, you need to create an App Clip target:

1. In Xcode, select your project in the Project Navigator
2. Click the "+" button at the bottom of the targets list (or File → New → Target)
3. Select **iOS → App Clip**
4. Click "Next"
5. Set:
   - **Product Name**: `ShowUpBoosterClip`
   - **Team**: Your development team
   - **Organization Identifier**: `com.yourcompany` (or your preference)
   - **Bundle Identifier**: Will auto-generate as `com.yourcompany.ShowUpBooster.Clip`
   - **Language**: Swift
   - **Interface**: SwiftUI
6. Click "Finish"
7. When prompted "Activate ShowUpBoosterClip scheme?", click **Activate**

Xcode will create:
- A new App Clip target named "ShowUpBoosterClip"
- A folder with `ContentView.swift` and an App file
- Automatically link it to the main app

### 3. Add Files to App Clip Target

### 3. Add Files to App Clip Target

#### Option A: Add All at Once (Recommended)
1. In Xcode, right-click on the `ShowUpBoosterClip` group (blue folder icon, NOT the main app)
2. Select "Add Files to ShowUpBooster..."
3. Navigate to and select these folders:
   - `ShowUpBooster/Models`
   - `ShowUpBooster/Services`
   - `ShowUpBooster/ViewModels`
   - `ShowUpBooster/Views`
4. **Important**: 
   - Do NOT check "Copy items if needed" (files already exist)
   - Select target **"ShowUpBoosterClip"** (the App Clip target)
   - Uncheck the main app target if selected
5. Click "Add"

#### Option B: Add Individual Files
For each file:
1. Right-click the `ShowUpBoosterClip` group
2. Select "Add Files to ShowUpBooster..."
3. Navigate to the file
4. Do NOT check "Copy items if needed"
5. Select target "ShowUpBoosterClip"
6. Click "Add"

### 4. Replace App Clip's Default Files

The App Clip wizard created default files. Replace them with our implementation:

1. **Delete** the auto-generated `ContentView.swift` in ShowUpBoosterClip folder (right-click → Delete → Move to Trash)
2. **Open** `ShowUpBoosterClipApp.swift` (the auto-generated app file)
3. **Replace its contents** with the code from our `ShowUpBoosterApp.swift`:

```bash
# In terminal, copy the content:
cat ShowUpBooster/ShowUpBoosterApp.swift
```

Then paste into `ShowUpBoosterClipApp.swift`, but keep the struct name as `ShowUpBoosterClipApp`.

Or manually:
- Change `import SwiftUI` section to include `import Combine`
- Add the `AppState` class
- Add `handleIncomingURL` method
- Add `PlaceholderView`
- Update the body to use conditional rendering with `Group` and `.onOpenURL()`

### 5. Verify Files Are in App Clip Target
### 5. Verify Files Are in App Clip Target
1. Select a file in Project Navigator (e.g., `Event.swift`)
2. Open File Inspector (⌥⌘1)
3. Under "Target Membership", ensure **only** "ShowUpBoosterClip" is checked
4. The main app target should NOT be checked (App Clip is standalone)

### 6. Configure App Clip Info.plist

The App Clip has its own Info.plist. Configure it:

#### A. URL Scheme (for testing only - does NOT invoke App Clip)

**⚠️ Important**: Custom URL schemes do NOT invoke App Clips. They only work when the app is already running.

Use case: Testing URL parameter parsing when App Clip is already open in simulator.

1. Select `ShowUpBoosterClip` target
2. Go to "Info" tab
3. Expand "URL Types" (or add it if not present)
4. Click "+" to add a new URL Type
5. Set:
   - **Identifier**: `com.showupbooster.event`
   - **URL Schemes**: `showupbooster`
   - **Role**: Editor

**For actual App Clip invocation, you need Universal Links (Step B below).**

#### B. Associated Domains (for Universal Links - required for App Clip invocation)

To actually invoke the App Clip, configure Universal Links:

1. Select `ShowUpBoosterClip` target
2. Go to "Signing & Capabilities" tab
3. Click "+ Capability"
4. Add "**Associated Domains**"
5. Under "Domains", click "+"
6. Add: `appclips:example.com` (replace with your domain when you have one)

**For development**: Use `example.com` as a placeholder. For production, replace with your actual domain.

**Example domains**:
- Development: `appclips:example.com`
- Production: `appclips:showupbooster.app`

#### C. Privacy Description
1. In the same Info tab, find "Custom iOS Target Properties"
2. Add new entry:
   - **Key**: `NSUserNotificationsUsageDescription`
   - **Value**: `ShowUpBooster needs permission to send you reminders before your events so you don't miss them.`

#### D. Parent Application Identifiers (Required for App Clips)
This is usually auto-configured, but verify:
1. Look for `NSAppClip` dictionary
2. Under it, should be `NSAppClipRequestEphemeralUserNotification` set to `YES`

### 7. Configure Signing & Capabilities

#### App Clip Target:
1. Select `ShowUpBoosterClip` target
2. Go to "Signing & Capabilities" tab
3. Set your Development Team
4. Verify Bundle ID ends with `.Clip`
5. Optional: Add "Push Notifications" capability

### 8. Build & Run the App Clip

1. Select the **ShowUpBoosterClip** scheme (not the main app)
2. Select a simulator (iOS 16.0+)
3. Press ⌘R to build and run
4. You should see the PlaceholderView (since no URL opened yet)

**Important**: App Clips have a 50MB size limit. Check your app size:
- Product → Archive → Distribute → Development → Export
- Check the `.app` bundle size
- Current implementation should be well under 10MB

## Testing the App Clip

### ⚠️ IMPORTANT: URL Schemes vs Universal Links

**Custom URL schemes (`showupbooster://`) do NOT invoke App Clips!**

- **Custom URL schemes** (`showupbooster://`) - Only work when the app is ALREADY installed/running
- **Universal Links** (`https://`) - Required to invoke App Clips from scratch

This means:
- ✅ `showupbooster://` works for testing URL parameter parsing when App Clip is already running
- ❌ `showupbooster://` will NOT launch the App Clip from the home screen
- ✅ `https://showupbooster.app/?...` will invoke the App Clip (requires setup)

### Option 1: Test Running App Clip (Quick)

**When App Clip is already running in simulator:**

1. **Launch the App Clip** first (⌘R with ShowUpBoosterClip scheme)
2. **Send a URL** to test parameter parsing:
   ```bash
   xcrun simctl openurl booted "showupbooster://event?title=Test%20Event&location=Here&dateTime=2026-03-01T14:00:00Z"
   ```
3. The App Clip receives the URL and displays the event

**This is useful for**: Testing URL parameter parsing, debugging the event display, quick iteration

**This does NOT test**: Actual App Clip invocation (that requires Universal Links)

### Option 2: Test App Clip Invocation (Local Experiences)

To test actual App Clip invocation in Xcode (without a real domain):

#### A. App Clip Invocation URL (Easiest - Recommended)

This is the simplest way to test your App Clip:

1. Select the **ShowUpBoosterClip** scheme in Xcode toolbar
2. Go to **Product → Scheme → Edit Scheme...**
3. Select **Run** in the left sidebar
4. Go to **Options** tab
5. Scroll down to **"App Clip Invocation"** section
6. In the **URL** field, enter:
   ```
   https://example.com/event?title=Test%20Event&location=Test%20Location&dateTime=2026-03-01T14:00:00Z
   ```
7. Click "Close"
8. Run the App Clip (⌘R)

**What happens:**
- App Clip launches as if someone scanned a QR code with this URL
- Your `.onOpenURL()` handler receives the URL
- Event details display automatically
- Perfect simulation of real-world App Clip invocation!

**Testing different events:**
- Just change the URL parameters in the scheme settings
- No code changes needed
- Instant iteration

#### B. Environment Variable (Alternative)

#### B. Environment Variable (Alternative)

If you prefer using environment variables:

1. In Xcode, go to **Product → Scheme → Edit Scheme...**
2. Select **Run** in the left sidebar
3. Go to **Arguments** tab
4. Under "Environment Variables", click "+"
5. Add:
   - **Name**: `_XCAppClipURL`
   - **Value**: `https://example.com/event?title=Test&location=Here&dateTime=2026-03-01T14:00:00Z`
6. Click "Close"
7. Run the App Clip (⌘R)

Same result as Option A, just a different configuration method.

#### C. Local App Clip Experience (Most Realistic)

1. **Run the App Clip** (⌘R with ShowUpBoosterClip scheme)
2. **Stop the App Clip** (⌘.)
3. **In Xcode**: Product → Scheme → Edit Scheme → Run → Options
4. Check "**Register local App Clip experience**"
5. Set URL: `https://example.com/event`
6. Close and run again (⌘R)

Now you can test App Clip invocation from Safari in simulator:
```
Open Safari in simulator → Go to: https://example.com/event?params...
```

### Option 3: Production Setup (Universal Links)

For real App Clip invocation (production or real testing):

See the "Production Setup" section below for:
- Domain registration
- AASA file hosting
- App Store Connect configuration

### Generate Test URLs

The included script generates test URLs:

```bash
cd /Users/I818292/Documents/Funs/ShowUpBooster
./generate_test_link.sh
```

**Note**: The script generates `showupbooster://` URLs for testing parameter parsing when the App Clip is already running. This does NOT test actual App Clip invocation. See testing options above for proper App Clip invocation testing.

### Test the Full Confirmation Flow

1. Tap "Confirm & Remind Me"
2. Grant notification permission when prompted
3. See the confirmation success screen
4. Verify 3 reminders are shown
5. Check the status changes to "Confirmed!"

## Troubleshooting

### Files Not Compiling
- **Issue**: "Cannot find type 'Event' in scope"
- **Solution**: Files not added to App Clip target. Follow Step 5 above to verify target membership.

### URL Not Opening App Clip
- **Issue**: URL doesn't launch the App Clip
- **Solution**: 
  1. **Custom URL schemes don't invoke App Clips** - they only work when app is already running
  2. For actual App Clip invocation, use option 2 or 3 in "Testing the App Clip" section above
  3. For testing: Use Xcode's local App Clip experience (Product → Scheme → Edit Scheme → Run → Options)
  4. For production: Set up Universal Links with a real domain

### Notifications Not Scheduling
- **Issue**: No reminders scheduled
- **Solution**: 
  1. Check notification permission granted (Settings → Notifications → ShowUpBoosterClip)
  2. App Clips can request ephemeral notification permissions - should work first time

### Build Errors
1. Clean build folder: ⇧⌘K
2. Rebuild: ⌘B
3. Check all files are in **App Clip target** (not main app)
4. Verify you're building the `ShowUpBoosterClip` scheme

### App Clip Size Too Large
- **Issue**: App Clip exceeds 50MB limit
- **Solution**: 
  1. Remove unused assets
  2. Use on-demand resources
  3. Current implementation should be ~5-10MB - well under limit

## Project Structure (After Setup)

```
ShowUpBooster/
├── ShowUpBooster/ (Main app - optional, can be minimal)
│   ├── ShowUpBoosterApp.swift
│   └── ContentView.swift
├── ShowUpBoosterClip/ (App Clip - primary target)
│   ├── ShowUpBoosterClipApp.swift (updated with our code)
│   ├── Models/ (linked from ShowUpBooster/Models/)
│   │   └── Event.swift ✅
│   ├── Services/ (linked from ShowUpBooster/Services/)
│   │   └── NotificationManager.swift ✅
│   ├── ViewModels/ (linked from ShowUpBooster/ViewModels/)
│   │   └── EventViewModel.swift ✅
│   └── Views/ (linked from ShowUpBooster/Views/)
│       ├── EventDetailView.swift ✅
│       └── ConfirmationSuccessView.swift ✅
└── generate_test_link.sh ✅
```

**Note**: Files are not duplicated - they're the same files shared between targets through Xcode's target membership feature.

## Next Steps

After basic setup is complete:

### Immediate
1. **Test URL handling**: Generate test links and verify URL parsing works
2. **Test confirmation flow**: Tap button, grant permission, verify reminders
3. **Test edge cases**: Past events, missing parameters, denied permissions

### Production Setup
4. **Register App Clip Experience** with Apple:
   - Go to App Store Connect
   - Create App Clip experience
   - Associate with your domain (e.g., `showupbooster.app`)
   - Set invocation URL pattern

5. **Set up Universal Links** for production:
   - Register domain: `showupbooster.app` (or your domain)
   - Host AASA file at `https://showupbooster.app/.well-known/apple-app-site-association`
   - Update App Clip to handle both `showupbooster://` and `https://` URLs

6. **Configure App Clip Card**:
   - Header image (3000x2000px)
   - Title and subtitle
   - Action button text ("Open" by default)

7. **QR Code & NFC Tags**:
   - Generate QR codes linking to: `https://showupbooster.app/?params...`
   - Program NFC tags with same URLs
   - Test with iPhone Camera app

### Enhancement
8. **Add Main App** features (optional):
   - Event history
   - Recurring events
   - Custom reminder preferences
   - Host dashboard
   - Analytics

9. **Optimize Performance**:
   - App Clip launch time < 2 seconds
   - Reduce bundle size further
   - Lazy load heavy resources

10. **Localization**: Add Spanish, Chinese, Japanese translations

## Optional: Main App Setup

The App Clip is the primary experience. The main app is optional and can provide additional features for users who want to install it.

### When to Build a Main App:
- Users who want to see event history
- Users with recurring events
- Hosts who want to track confirmations
- Advanced features like analytics

### Converting App Clip Users:
Show an "Install Full App" prompt after:
- 3 successful confirmations
- First attended event
- User expresses interest in history

### Main App Features (Ideas):
- **Event History**: See all past confirmations
- **Recurring Events**: Weekly meetings, monthly appointments
- **Calendar Integration**: Sync with iOS Calendar
- **Host Mode**: Create events, track RSVPs
- **Custom Reminders**: Set your own reminder times
- **Analytics**: No-show rates, attendance trends
- **Widgets**: Upcoming events on home screen

For now, focus on the **App Clip** - it's the core value proposition.

## Questions?

If you encounter issues:
1. Check this guide first
2. Verify all files are added to the **App Clip target** (not main app)
3. Make sure you're running the `ShowUpBoosterClip` scheme
4. Clean and rebuild (⇧⌘K then ⌘B)
5. Check Xcode console for error messages

**Key Points to Remember**:
- ShowUpBooster is an **App Clip first** - instant access without installation
- Files must be added to the `ShowUpBoosterClip` target
- App Clips have a 50MB size limit (current implementation is ~5-10MB)
- **IMPORTANT**: Custom URL schemes (`showupbooster://`) do NOT invoke App Clips
  - They only work when the app is already running
  - Use for testing parameter parsing only
- **For App Clip invocation**: Use Universal Links (`https://`) with Associated Domains
  - Development: Use Xcode's local App Clip experiences
  - Production: Requires real domain + AASA file + App Store Connect setup
- The main app is optional and can be added later for advanced features
