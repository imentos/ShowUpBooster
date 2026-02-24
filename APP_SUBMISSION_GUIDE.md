# ShowUpBooster App Submission Guide

Complete guide for submitting ShowUpBooster with App Clip to the App Store.

## Prerequisites

- ✅ Xcode 15+ installed
- ✅ Valid Apple Developer account ($99/year)
- ✅ App icon added to both targets
- ✅ GitHub Pages hosting configured
- ✅ AASA file accessible at https://imentos.github.io/ShowUpBooster/.well-known/apple-app-site-association
- ✅ Team ID: `2HQJC64KR8`
- ✅ Bundle ID: `rkuo.showupbooster` (main app)
- ✅ App Clip Bundle ID: `rkuo.showupbooster.Clip`

## Step 1: Prepare for Archive

### 1.1 Check Build Settings
1. Open `ShowUpBooster.xcodeproj` in Xcode
2. Select ShowUpBooster target → General
3. Verify:
   - **Display Name**: ShowUpBooster
   - **Bundle Identifier**: `rkuo.showupbooster`
   - **Version**: 1.0 (or your version)
   - **Build**: 1 (increment for each upload)
   - **Deployment Target**: iOS 16.0+
   - **Team**: Your Apple Developer Team

### 1.2 Check App Clip Settings
1. Select ShowUpBoosterClip target → General
2. Verify:
   - **Bundle Identifier**: `rkuo.showupbooster.Clip`
   - **Version**: Same as main app (1.0)
   - **Build**: Same as main app (1)
   - **Parent Application Bundle Identifier**: `rkuo.showupbooster`

### 1.3 Check Entitlements
Verify [ShowUpBoosterClip/ShowUpBoosterClip.entitlements](ShowUpBoosterClip/ShowUpBoosterClip.entitlements):
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>appclips:imentos.github.io</string>
</array>
<key>com.apple.developer.parent-application-identifiers</key>
<array>
    <string>$(AppIdentifierPrefix)rkuo.ShowUpBooster</string>
</array>
```

### 1.4 Clean Build
```bash
# In Xcode
# Shift + Command + K (Clean Build Folder)
```

## Step 2: Archive the App

### 2.1 Select Build Destination
1. In Xcode toolbar, click scheme dropdown
2. Select **"Any iOS Device (arm64)"**
   - Do NOT select a simulator
   - Don't need a physical device connected

### 2.2 Create Archive
1. Menu: **Product → Archive** (or `Ctrl + Cmd + A`)
2. Wait for build to complete (3-5 minutes)
3. Xcode Organizer window will open automatically

### 2.3 Troubleshooting Build Errors

**If you see signing errors:**
- Xcode → Settings → Accounts → Download Manual Profiles
- Refresh signing certificates in target settings

**If build fails:**
- Check [TESTFLIGHT_SETUP.md](TESTFLIGHT_SETUP.md) troubleshooting section
- Verify Team ID is correct in all targets
- Ensure signing certificates are valid

## Step 3: Upload to App Store Connect

### 3.1 Distribute Archive
1. In Organizer, select your archive
2. Click **"Distribute App"** button
3. Select **"App Store Connect"**
4. Click **"Next"**

### 3.2 Distribution Options
1. **Upload**: ✅ Selected
2. **App Thinning**: Automatic
3. **Rebuild from Bitcode**: ✅ (if available)
4. **Strip Swift symbols**: ✅ (reduces size)
5. **Upload your app's symbols**: ✅ (for crash reports)
6. Click **"Next"**

### 3.3 Re-sign (if needed)
1. **Automatically manage signing**: ✅ Recommended
2. Click **"Next"**

### 3.4 Review and Upload
1. Review archive contents
2. Verify both ShowUpBooster and ShowUpBoosterClip are included
3. Click **"Upload"**
4. Wait for upload to complete (5-15 minutes depending on size)

### 3.5 Export Compliance
After upload, you'll see "Export Compliance" questions:

**Question**: Does your app use encryption?
- **Answer**: Yes (for HTTPS communication)

**Question**: Is your app designed to use cryptography or does it contain encryption?
- **Answer**: No (you're only using standard HTTPS)

This is standard for apps that use HTTPS networking.

## Step 4: Configure App in App Store Connect

### 4.1 Access App Store Connect
1. Go to https://appstoreconnect.apple.com
2. Sign in with your Apple Developer account
3. Click **"My Apps"**

### 4.2 Create App (if first time)
If app doesn't exist yet:
1. Click **"+"** button → **"New App"**
2. **Platforms**: iOS
3. **Name**: ShowUpBooster
4. **Primary Language**: English (U.S.)
5. **Bundle ID**: Select `rkuo.showupbooster`
6. **SKU**: `showupbooster-001` (unique identifier)
7. **User Access**: Full Access
8. Click **"Create"**

### 4.3 Wait for Build Processing
1. Go to **TestFlight** tab
2. Wait for build to process (10-30 minutes)
3. Status will show: Processing → Ready to Submit
4. You'll receive email when ready

## Step 5: Configure App Clip Experience

**This is critical for URL invocation to work!**

### 5.1 Navigate to App Clip
1. In App Store Connect, select your app
2. In left sidebar, find **"App Clip"** section
3. Click **"App Clip"**

### 5.2 Add App Clip Experience
1. Click **"+"** or **"Add Experience"** button
2. Fill in details:

**URL Configuration:**
- **Experience URL**: `https://imentos.github.io/ShowUpBooster/event`
- **Enable URL Prefix**: ✅ **Important!**
  - This allows all URLs starting with this path to trigger the App Clip
  - Example URLs that will work:
    - `https://imentos.github.io/ShowUpBooster/event?title=Meeting&...`
    - `https://imentos.github.io/ShowUpBooster/event?title=Party&...`

**Card Configuration:**
- **Title**: "ShowUpBooster"
- **Subtitle**: "Confirm Your Attendance"
- **Action**: "Open" or "View"
- **Call to Action**: "Confirm Event"

**Header Image (Optional but Recommended):**
- **Size**: 3000 × 2000 pixels (3:2 aspect ratio)
- **Format**: PNG or JPEG
- **Max size**: 1 MB
- Should showcase: Your app icon + event confirmation preview
- Design tip: Use purple/blue gradient matching your icon

**Advanced Settings:**
- **Business Category**: Select "Productivity" or "Business Services"
- **Default Experience**: ✅ Enable (if this is your only experience)

### 5.3 Save and Submit
1. Click **"Save"**
2. The experience will be:
   - **In Review**: If app is pending review
   - **Ready for Review**: Submit for approval
3. App Clip Experiences typically review faster than full apps (1-2 days)

### 5.4 Create App Clip Card Image (Optional)

If you want to create a professional card image:

```bash
# Recommended dimensions
Width: 3000px
Height: 2000px
Aspect Ratio: 3:2

# Design elements to include:
- Your app icon (top left or center)
- Event confirmation imagery (calendar, checkmark)
- Purple/blue gradient background (matching icon)
- Text: "Confirm Your Event Attendance"
- Map preview or location pin
- Clean, minimal design
```

You can use:
- Figma
- Canva
- Photoshop
- AI image generators (ChatGPT, Midjourney, etc.)

## Step 6: TestFlight Testing

### 6.1 Add Internal Testers
1. Go to **TestFlight** tab
2. Click **"Internal Testing"** section
3. Click **"+"** → Add internal testers
4. Select testers from your team
5. They'll receive email invitation

**Internal Testers:**
- Can test immediately (no review needed)
- Up to 100 internal testers
- Can test for 90 days
- **Cannot test URL invocation** (only manual launch)

### 6.2 Add External Testers (for URL Testing)
1. Go to **External Testing** section
2. Create a new group: "Beta Testers"
3. Click **"Add Build"** → Select your build
4. Add testers via email addresses
5. Build must be reviewed by Apple (1-2 days)

**External Testers:**
- Public beta testers
- Up to 10,000 testers
- **Can test URL invocation** once App Clip Experience is approved
- Get App Clip card when clicking URLs

### 6.3 Testing URL Invocation

**After App Clip Experience is approved:**

1. Send test URL to external testers:
```
https://imientos.github.io/ShowUpBooster/event?title=Test%20Meeting&address=123%20Main%20St&dateTime=2026-03-01T14:00:00Z&lat=37.7749&lng=-122.4194
```

2. Testers should:
   - Open URL in Safari or Messages on iPhone
   - See App Clip card appear at top of screen
   - Tap "Open" button
   - App Clip launches with event details

3. Verify:
   - Event title displays correctly
   - Address shows on map
   - Coordinates loaded properly
   - "Confirm Attendance" button works
   - Notifications schedule properly

### 6.4 Test Notification Flow

Have testers verify:
1. Confirm attendance
2. Grant notification permission
3. Keep app in background
4. Kill app completely
5. Wait for test notification (use debug mode if needed)
6. Tap notification
7. Verify app relaunches with event details intact

## Step 7: App Store Submission

### 7.1 Complete App Information

**App Information:**
1. Go to **App Store** tab
2. Fill in required fields:

**Basic Info:**
- **Name**: ShowUpBooster
- **Subtitle**: "Never Miss an Event"
- **Privacy Policy URL**: (required - host on GitHub Pages)
- **Category**: Primary: Productivity, Secondary: Business
- **Content Rights**: You own or have rights to use

**Pricing:**
- **Price**: Free
- **Availability**: All territories (or select specific countries)

**App Privacy:**
- Click **"Edit"** → **"Get Started"**
- **Location**: Yes (for map display)
  - Purpose: "Show event location on map"
  - User control: Required
- **User Notifications**: Yes
  - Purpose: "Remind about upcoming events"
  - User control: Required

### 7.2 Prepare App Store Assets

**Screenshots (required):**
- **6.7" Display** (iPhone 15 Pro Max): 1290 × 2796px (3 required)
- **5.5" Display** (iPhone 8 Plus): 1242 × 2208px (3 required)

**Screenshot suggestions:**
1. Event detail screen with map
2. Confirmation success screen
3. Notification preview

**App Preview Video (optional):**
- 15-30 seconds
- Show: URL click → App Clip card → Event confirmation → Notification

**App Icon:**
- Already configured in Xcode ✅
- Will be automatically pulled from archive

**Description:**
```
ShowUpBooster makes event attendance confirmation instant and effortless with App Clips.

✨ Features:
• Instant event confirmation via App Clips - no download needed
• Smart reminders (24h, 2h, 30min before event)
• Interactive map with event location
• Running late or can't make it? Update your status easily
• Works even after app is closed

🚀 How it works:
1. Receive event link
2. Tap link to see instant App Clip card
3. Confirm your attendance
4. Get automatic reminders
5. Never miss an important event

Perfect for:
• Business meetings
• Social gatherings
• Professional events
• Team activities
• Any scheduled event

ShowUpBooster App Clips work instantly without downloads, keeping your phone storage free while ensuring you never miss important events.
```

**Keywords:**
```
event, confirmation, reminder, calendar, meeting, attendance, rsvp, notification, appointment, schedule
```

**Promotional Text (optional, can update without review):**
```
Try our App Clip instantly - no download needed! Just tap the event link.
```

### 7.3 Version Information

For version 1.0:
- **What's New**: "Initial release - Instant event confirmation with App Clips!"

### 7.4 Submit for Review

1. Select build from **Build** section
2. Review all information
3. **Export Compliance**: Already handled during upload ✅
4. Click **"Add for Review"**
5. Click **"Submit to App Review"**

**Review Times:**
- Typical: 1-3 days
- App Clips: Sometimes faster (24-48 hours)
- First submission: May take longer

## Step 8: After Approval

### 8.1 App Clip Experience Propagation
- After approval, wait 2-24 hours for Apple's CDN to propagate
- URLs will then trigger App Clip card globally
- Test in different regions if targeting international users

### 8.2 Monitor Usage
1. Go to **Analytics** in App Store Connect
2. Track:
   - App Clip invocations
   - Installations
   - User engagement
   - Crashes (should be zero with proper testing!)

### 8.3 Share Your App Clip

Create event URLs with this format:
```
https://imentos.github.io/ShowUpBooster/event?title={EVENT_TITLE}&address={ADDRESS}&dateTime={ISO8601_DATETIME}&lat={LATITUDE}&lng={LONGITUDE}
```

**Example URL:**
```
https://imentos.github.io/ShowUpBooster/event?title=Team%20Meeting&address=Apple%20Park,%20Cupertino&dateTime=2026-03-15T14:00:00Z&lat=37.3346&lng=-122.0090
```

**Share via:**
- Messages (best user experience)
- Email
- Calendar invites
- QR codes
- NFC tags
- Social media

## Troubleshooting

### Build Upload Issues

**"No architectures to compile for"**
- Make sure you selected "Any iOS Device (arm64)" not a simulator

**"Failed to verify target capabilities"**
- Check entitlements files match App Store Connect capabilities
- Verify associated domain is correctly configured

**"Archive not found in Organizer"**
- Ensure you used Product → Archive, not Product → Build
- Check scheme is set to Release configuration

### App Clip Experience Issues

**URL doesn't trigger App Clip card**
1. Wait 2-24 hours after approval for propagation
2. Verify AASA file is accessible: `curl https://imentos.github.io/ShowUpBooster/.well-known/apple-app-site-association`
3. Check App Clip Experience status in App Store Connect
4. Ensure "Enable URL Prefix" is checked
5. Test on real device (not simulator)

**App Clip card shows but doesn't open**
1. Check bundle IDs match exactly
2. Verify entitlements include correct domain
3. Ensure App Clip is included in archive
4. Check device iOS version (requires iOS 14+)

### Testing Issues

**TestFlight internal testers can't test URLs**
- This is expected - only external testers can test URL invocation
- Use Local Experiences for device testing before App Store approval

**Notifications not working**
1. Check notification permission granted
2. Verify NotificationManager is scheduling properly (check logs)
3. Ensure date/time is in the future
4. Test debug mode (5-tap icon for 10-second test notification)

### Review Rejection Issues

**Common rejection reasons:**
1. Missing privacy policy URL
2. Incomplete app privacy details
3. App Clip too large (must be < 50MB)
4. Crash on launch
5. Missing functionality described in description

## Next Steps After Live

### 1. Version Updates
When updating the app:
1. Increment build number (1 → 2 → 3...)
2. Update version number if major changes (1.0 → 1.1 → 2.0)
3. Archive and upload new build
4. Update "What's New" text
5. Submit for review

### 2. Feature Enhancements

**Potential additions:**
- Contact sharing (notify host when running late)
- Calendar integration
- Multiple event support
- Custom notification times
- Event history
- Share capability

### 3. Analytics and Monitoring

Track metrics:
- App Clip invocations vs installations
- Confirmation rate
- Notification engagement
- Crash-free rate
- User retention

### 4. Marketing

**Promote your App Clip:**
- Blog post about the app
- Product Hunt launch
- Reddit communities (r/iOSProgramming, r/AppClips)
- Twitter/X developer community
- LinkedIn developer network

## Resources

### Apple Documentation
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [App Clip Documentation](https://developer.apple.com/documentation/app_clips)
- [TestFlight Guide](https://developer.apple.com/testflight/)
- [Human Interface Guidelines - App Clips](https://developer.apple.com/design/human-interface-guidelines/app-clips)

### ShowUpBooster Documentation
- [README.md](README.md) - Project overview
- [TESTFLIGHT_SETUP.md](TESTFLIGHT_SETUP.md) - Detailed TestFlight setup
- [GITHUB_PAGES_SETUP.md](GITHUB_PAGES_SETUP.md) - GitHub Pages configuration

### Support
- GitHub Issues: https://github.com/imentos/ShowUpBooster/issues
- Apple Developer Forums: https://developer.apple.com/forums/
- Stack Overflow: Tag `app-clips` or `ios`

---

## Quick Checklist

Use this checklist before submission:

- [ ] App icon added to both targets
- [ ] Build version incremented
- [ ] Clean build successful
- [ ] Archive created
- [ ] App uploaded to App Store Connect
- [ ] Build processed successfully
- [ ] App information complete
- [ ] Privacy policy URL added
- [ ] App privacy details filled
- [ ] Screenshots uploaded (2 sizes)
- [ ] Description written
- [ ] Keywords added
- [ ] App Clip Experience configured
- [ ] URL prefix enabled
- [ ] TestFlight internal testing passed
- [ ] TestFlight external testing passed (if applicable)
- [ ] URL invocation tested
- [ ] Notifications tested
- [ ] Review submitted

---

**You're ready to submit! 🚀**

If you encounter any issues, check the troubleshooting section or consult the Apple documentation linked above.
