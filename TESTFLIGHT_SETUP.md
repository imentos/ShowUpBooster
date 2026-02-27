# TestFlight Setup Guide for ShowUpBooster App Clip

## Prerequisites

✅ Apple Developer Program membership ($99/year)
✅ Bundle IDs registered in Apple Developer Portal
✅ App Store Connect app created

---

## Step 1: Configure Bundle Identifiers

### In Xcode:

1. **Main App Target** (ShowUpBooster):
   - Bundle ID: `rkuo.showupbooster` (or your actual bundle ID)
   - Version: `1.0`
   - Build: `1` (increment for each upload)

2. **App Clip Target** (ShowUpBoosterClip):
   - Bundle ID: `rkuo.showupbooster.Clip` (MUST end with `.Clip`)
   - Version: Same as main app (`1.0`)
   - Build: Same as main app (`1`)

⚠️ **Important**: App Clip bundle ID MUST start with parent app's bundle ID.

---

## Step 2: Register Bundle IDs (Developer Portal)

Go to: https://developer.apple.com/account/resources/identifiers/list

### Create Main App Bundle ID:
1. Click `+` → Select "App IDs" → Continue
2. Description: `ShowUpBooster`
3. Bundle ID: `rkuo.showupbooster` (Explicit)
4. Capabilities: Enable **App Clips**
5. Click Continue → Register

### Create App Clip Bundle ID:
1. Click `+` → Select "App IDs" → Continue
2. Description: `ShowUpBooster Clip`
3. Bundle ID: `rkuo.showupbooster.Clip` (Explicit)
4. ⚠️ Make sure this is under "App Clip" section
5. Click Continue → Register

---

## Step 3: Create App Store Connect App

Go to: https://appstoreconnect.apple.com/apps

1. Click `+` → New App
2. **Platforms**: iOS
3. **Name**: ShowUpBooster (user-facing name)
4. **Primary Language**: English (U.S.)
5. **Bundle ID**: Select `rkuo.showupbooster`
6. **SKU**: `showupbooster-001` (any unique identifier)
7. Click **Create**

---

## Step 4: Configure App in Xcode

### Set Signing & Capabilities:

#### Main App Target (ShowUpBooster):
1. Select ShowUpBooster target
2. **Signing & Capabilities** tab
3. **Automatically manage signing**: ✅ Checked
4. **Team**: Select your Apple Developer Team
5. Click `+ Capability` → Add **Associated Domains**
6. Add domain: `appclips:showupbooster.app` (or your domain)

#### App Clip Target (ShowUpBoosterClip):
1. Select ShowUpBoosterClip target
2. **Signing & Capabilities** tab
3. **Automatically manage signing**: ✅ Checked
4. **Team**: Select your Apple Developer Team
5. Click `+ Capability` → Add **Associated Domains**
6. Add domain: `appclips:showupbooster.app`
7. **On Demand Install Capable**: Should already be enabled (App Clip identifier)

### Set Deployment Target:
- Both targets: **iOS 16.0** or higher

---

## Step 5: Archive the App

### Clean Build Folder:
```bash
# In Xcode: Product → Clean Build Folder (⇧⌘K)
```

### Select Device:
- In Xcode toolbar: Select **Any iOS Device (arm64)**
- NOT simulator!

### Archive:
1. **Product** → **Archive** (or ⌃⌘A)
2. Wait for build to complete (may take 3-5 minutes)
3. Organizer window opens automatically

---

## Step 6: Upload to App Store Connect

### In Organizer (Archives tab):

1. Select your archive
2. Click **Distribute App**
3. Choose: **App Store Connect**
4. Click **Next**
5. Choose: **Upload**
6. Click **Next**
7. **Distribution Options**:
   - App Thinning: None
   - Rebuild from Bitcode: No
   - Strip Swift symbols: Yes (optional)
   - Upload your app's symbols: Yes (recommended)
8. Click **Next**
9. **Automatically manage signing**: Yes
10. Click **Next**
11. Review app info
12. Click **Upload**

⏱ Upload takes 5-15 minutes depending on internet speed.

---

## Step 7: Wait for Processing

Go to: https://appstoreconnect.apple.com/apps → Your App → TestFlight

**Processing Status:**
- ⏳ **Processing**: Apple is processing your build (10-30 minutes)
- ⚠️ **Processing Failed**: Check email for issues
- ✅ **Ready to Submit**: Build is ready!

Common processing issues:
- Missing export compliance
- Missing App Clip metadata
- Invalid provisioning profile

---

## Step 8: Export Compliance

If your app uses encryption (HTTPS/TLS):

1. In App Store Connect → TestFlight → Select Build
2. **Export Compliance**: Manage
3. Answer questions:
   - Uses encryption? → **Yes** (App uses HTTPS)
   - Uses exempt encryption? → **Yes** (Standard HTTPS only)
   - Cryptography registration? → **No**
4. Save

---

## Step 9: Add Test Information

### In TestFlight:

1. **Test Information** (required):
   - Beta App Description: "Event confirmation App Clip with reminders"
   - Feedback Email: your-email@example.com
   - What to Test: "Test event confirmation and notification reminders"

2. **App Clip Information**:
   - You'll need to set up an App Clip Experience (see Step 10)

---

## Step 10: Create App Clip Experience

1. Go to App Store Connect → Your App → **App Clips**
2. Click **+** to add App Clip Experience
3. **URL**: `https://showupbooster.app/`
4. **Action**: "View Event" or "Open"
5. **Title**: "Confirm Attendance"
6. **Subtitle**: "Quick RSVP for events"
7. Upload App Clip Card Image (1800x1200px)
8. Select languages
9. Save

⚠️ **Note**: For testing, you can use a placeholder domain, but for production you'll need:
- Real domain ownership
- AASA file hosted at `https://showupbooster.app/.well-known/apple-app-site-association`

---

## Step 11: Add Internal Testers

1. **TestFlight** → **Internal Testing**
2. Click **+** next to "TESTERS"
3. Select yourself and team members (up to 100)
4. Click **Add**
5. Each tester receives email invitation

---

## Step 12: Test the Build

### Test URL Options:

#### Option 1: TestFlight App
Install TestFlight app on iPhone, accept invitation, install ShowUpBooster.

#### Option 2: Test with URL (in Notes/Messages):
```
https://showupbooster.app/?title=Team%20Lunch&address=Apple%20Park,%20Cupertino&datetime=2026-03-01T19:00:00Z&lat=37.3346&lng=-122.009
```

⚠️ **Known Issue in TestFlight**: 
- App Clip experiences may not work until app is approved
- For full testing, use Local Experience option in Settings → Developer

#### Option 3: Local Experience (on test device):
1. Settings → Developer → Local Experiences
2. Register URL: `https://showupbooster.app/`
3. App Clip: Select ShowUpBooster Clip
4. Test by opening URL in Safari or Messages

---

## Step 13: Update Build (for future versions)

When you make changes:

1. **Increment Build Number**:
   - Xcode → Select both targets
   - Increment Build to `2`, `3`, etc.
   - Keep Version at `1.0` (until major release)

2. **Clean → Archive → Upload**
   - ⇧⌘K → Archive → Upload
   - New build appears after processing

---

## Common Issues & Solutions

### ❌ "No accounts with App Store Connect access"
- Solution: Sign in with Apple ID in Xcode → Preferences → Accounts

### ❌ "Failed to register bundle identifier"
- Solution: Check Bundle ID doesn't already exist in Developer Portal

### ❌ "Bundle identifier differs from App Clip"
- Solution: App Clip bundle ID must start with parent app bundle ID

### ❌ "No provisioning profiles found"
- Solution: Ensure "Automatically manage signing" is enabled

### ❌ "ITMS-90206: Invalid Bundle"
- Solution: Ensure App Clip target includes required Info.plist keys

### ❌ App Clip doesn't launch from URL
- Solution: 
  - Check AASA file is properly hosted
  - Use Local Experience for testing
  - Wait for App Store Connect approval

---

## Next Steps After TestFlight

1. **Beta Testing**: Gather feedback from testers
2. **Fix Bugs**: Iterate based on feedback
3. **Prepare Screenshots**: 6.7", 6.5", 5.5" (required for App Store)
4. **Write App Description**: Marketing copy for App Store listing
5. **Set Pricing**: Free or paid
6. **Submit for Review**: TestFlight → App Store submission

---

## Quick Reference Commands

```bash
# Open Xcode workspace
cd /Users/I818292/Documents/Funs/ShowUpBooster
open ShowUpBooster.xcodeproj

# Test URL in simulator (development only)
xcrun simctl openurl booted "https://example.com/?title=Test&address=Cupertino&datetime=2026-03-01T19:00:00Z&lat=37.3346&lng=-122.009"

# Generate sample test URL
echo "https://showupbooster.app/?title=Team%20Meeting&address=Apple%20Park&datetime=$(date -u -v+3H +"%Y-%m-%dT%H:00:00Z")&lat=37.3346&lng=-122.009"
```

---

## App Clip Card Image Requirements

For App Store Connect App Clip Experience:

- **Size**: 1800 × 1200 pixels
- **Format**: PNG or JPEG
- **Safe Area**: Keep important content in center 1600 × 1000px
- **Content**: 
  - App name/logo
  - Clear call-to-action
  - Event-related imagery
  - High quality, no gradients

Example content:
- ShowUpBooster logo
- "Confirm Your Attendance"
- Calendar icon
- "Quick RSVP in Seconds"

---

## Testing Checklist

Before submitting to App Store:

- [ ] App launches successfully
- [ ] Event URL parsing works
- [ ] Map displays with coordinates
- [ ] Notification permissions requested
- [ ] Notifications scheduled correctly
- [ ] Notification tap re-opens App Clip
- [ ] App Clip works when completely killed
- [ ] Copy confirmation works
- [ ] All UI elements display properly
- [ ] No crashes or errors
- [ ] Tested on multiple iOS versions (16.0+)
- [ ] Tested on different screen sizes

---

## Support Resources

- **App Store Connect**: https://appstoreconnect.apple.com
- **Developer Portal**: https://developer.apple.com/account
- **App Clips Documentation**: https://developer.apple.com/app-clips/
- **TestFlight Guide**: https://developer.apple.com/testflight/

---

**Ready to start?** Follow Step 1 above!
