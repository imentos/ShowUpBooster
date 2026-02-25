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
- **Title**: "ShowUpBooster" (NO emojis or special characters)
- **Subtitle**: "Confirm Your Attendance" (NO emojis or special characters)
- **Action**: "Open" or "View"
- **Call to Action**: "Confirm Event" (Keep simple, no emojis)

**Alternatives:**
- Title: "ShowUpBooster" or "Event Confirmation"
- Subtitle: "Never Miss an Event" or "Quick Event RSVP"
- Call to Action: "Open", "Confirm", "View Event", "Get Started"

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
https://imentos.github.io/ShowUpBooster/event?title=Test%20Meeting&address=123%20Main%20St&dateTime=2026-03-01T14:00:00Z&lat=37.7749&lng=-122.4194
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
- **Name**: ShowUpBooster (30 char limit)
  - **IMPORTANT**: NO emojis or special characters allowed in app name
  - Alternative ASO names (all emoji-free):
    - "Event Reminder & RSVP" (22 chars, keyword-rich)
    - "ShowUp: Event Confirmations" (27 chars)
    - "Event RSVP & Reminders" (23 chars)
- **Subtitle**: "Never Miss an Event" (30 char limit)
  - **IMPORTANT**: NO emojis or special characters in subtitle
  - Alternative ASO subtitles (all emoji-free):
    - "Instant Event RSVP & Reminders" (31 chars - needs trim)
    - "Quick Event Confirm & Alerts" (29 chars)
    - "Smart Meeting Reminder App" (27 chars)
    - "Event RSVP with Smart Alerts" (29 chars)
- **Privacy Policy URL**: `https://imentos.github.io/ShowUpBooster/privacy.html` (required)
  - ✅ Already created and hosted on GitHub Pages
  - Covers: Data collection, usage, storage, GDPR, CCPA compliance
- **Support URL**: `https://imentos.github.io/ShowUpBooster/support.html` (optional but recommended)
  - ✅ FAQ, troubleshooting, and contact information
- **Category**: Primary: Productivity, Secondary: Business
  - ASO Tip: Consider "Social Networking" as secondary for broader reach
- **Content Rights**: You own or have rights to use

**Character Restrictions for Name/Subtitle:**
- ❌ NO emojis
- ❌ NO trademark symbols (™, ®, ©)  
- ❌ NO special characters (!?#$%^&*)
- ❌ NO excessive punctuation
- ✅ Letters, numbers, spaces OK
- ✅ Basic punctuation (: - &) OK
- ✅ Ampersand (&) OK

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
- **6.7" Display** (iPhone 15 Pro Max): 1290 × 2796px (3-10 screenshots)
- **5.5" Display** (iPhone 8 Plus): 1242 × 2208px (3-10 screenshots)

**ASO-Optimized Screenshot Strategy:**

1. **First Screenshot** (Most Important - 80% see only this one)
   - Event detail screen with map (App Clip recipient view)
   - Caption: "Save Time & Never Flake - Confirm in Seconds"
   - Show: Clear event details, map, "Confirm" button

2. **Second Screenshot**
   - Create Event screen (full app host view)
   - Caption: "Be The Organized Friend - Create Events Instantly"
   - Show: Event creation form with title, address, date/time, "Generate Link" button

3. **Third Screenshot**
   - Confirmation success screen
   - Caption: "Look Reliable & Organized - Never Forget Events"
   - Show: Success checkmark, reminder times (24h, 2h, 30min)

4. **Fourth Screenshot**
   - Notification preview
   - Caption: "Protect Your Reputation - Always Arrive On Time"
   - Show: Lock screen with notification

5. **Fifth Screenshot** (Optional)
   - Running late feature
   - Caption: "Reduce Awkward Moments - Update Status Instantly"
   - Show: "Running Late" and "Can't Make It" buttons

6. **Sixth Screenshot** (Optional)
   - App Clip card experience
   - Caption: "Zero Phone Storage - Start Using Immediately"
   - Show: Safari with App Clip card appearing

**Screenshot Design Tips:**
- Use bold, readable captions at top (not bottom - gets cut off)
- Include benefit-driven text, not just feature names
- Use high contrast colors
- Show real use cases (meeting, party, appointment)
- Include device frame for professionalism

**App Preview Video (optional):**
- 15-30 seconds
- Show: URL click → App Clip card → Event confirmation → Notification

**App Icon:**
- Already configured in Xcode ✅
- Will be automatically pulled from archive

**Description (4000 character limit):**

**Apple's Emoji Guidelines:**
- ✅ Emojis ARE allowed in descriptions (commonly used and accepted)
- ❌ Emojis NOT allowed in app name or subtitle
- ⚠️ Avoid excessive use (1 emoji per section is fine)
- ⚠️ Don't use emojis to replace words entirely

**Option 1: With Emojis (Recommended - Higher Engagement)**
```
Never miss an event again! ShowUpBooster delivers instant event confirmation and smart reminders without downloading a full app. Perfect for meetings, parties, appointments, and any scheduled event.

⚡ INSTANT EVENT RSVP - NO DOWNLOAD REQUIRED
Confirm your attendance in seconds with App Clips. Just tap the event link and respond immediately - no app installation needed. Save phone storage while staying organized.

🔔 SMART AUTOMATIC REMINDERS
Get perfectly timed notifications:
• 24 hours before - Plan ahead
• 2 hours before - Prepare to leave  
• 30 minutes before - Time to go!

Notifications work even after closing the app. Never forget important commitments.

📍 INTERACTIVE LOCATION MAPS
See exactly where to go with built-in maps showing event addresses. One tap for directions to your destination.

⏰ RUNNING LATE? UPDATE EASILY
Honest communication made simple:
• Tap "Running Late" to mark your status
• Select "Can't Make It" if plans change
• Keep everyone informed with one tap

PERFECT FOR:
• Business meetings and conference calls
• Social gatherings and dinner parties
• Professional networking events  
• Team activities and group projects
• Doctor appointments and interviews
• Family celebrations and reunions
• Any scheduled commitment

HOW IT WORKS:
1. Receive event invitation link
2. Tap link - App Clip card appears instantly
3. Confirm attendance in seconds
4. Receive automatic smart reminders
5. Show up on time, every time

WHY SHOWUPBOOSTER?
• No app download required - uses Apple App Clips
• Zero storage space used on your device
• Privacy-focused - no account needed
• Works offline after initial confirmation
• Crystal clear event details
• Reliable notification system
• Simple, beautiful interface
• Free to use

Stop missing important events. Start showing up reliably with ShowUpBooster's instant confirmation system.

Download now to host events and share confirmation links easily!
```

**Option 2: No Emojis (Apple-Safe Alternative)**
```
Never miss an event again! ShowUpBooster delivers instant event confirmation and smart reminders without downloading a full app. Perfect for meetings, parties, appointments, and any scheduled event.

--- INSTANT EVENT RSVP - NO DOWNLOAD REQUIRED ---
Confirm your attendance in seconds with App Clips. Just tap the event link and respond immediately - no app installation needed. Save phone storage while staying organized.

--- SMART AUTOMATIC REMINDERS ---
Get perfectly timed notifications:
• 24 hours before - Plan ahead
• 2 hours before - Prepare to leave
• 30 minutes before - Time to go!

Notifications work even after closing the app. Never forget important commitments.

--- INTERACTIVE LOCATION MAPS ---
See exactly where to go with built-in maps showing event addresses. One tap for directions to your destination.

--- RUNNING LATE? UPDATE EASILY ---
Honest communication made simple:
• Tap "Running Late" to mark your status
• Select "Can't Make It" if plans change  
• Keep everyone informed with one tap

PERFECT FOR:
• Business meetings and conference calls
• Social gatherings and dinner parties
• Professional networking events
• Team activities and group projects
• Doctor appointments and interviews
• Family celebrations and reunions
• Any scheduled commitment

HOW IT WORKS:
1. Receive event invitation link
2. Tap link - App Clip card appears instantly
3. Confirm attendance in seconds
4. Receive automatic smart reminders
5. Show up on time, every time

WHY SHOWUPBOOSTER?
• No app download required - uses Apple App Clips
• Zero storage space used on your device
• Privacy-focused - no account needed
• Works offline after initial confirmation
• Crystal clear event details
• Reliable notification system
• Simple, beautiful interface
• Free to use

Stop missing important events. Start showing up reliably with ShowUpBooster's instant confirmation system.

Download now to host events and share confirmation links easily!
```

**ASO Description Strategy:**
- First 2-3 lines are critical (visible without "more" expansion)
- Keywords front-loaded: "event," "confirmation," "reminders," "RSVP"
- Benefit-driven language
- Emojis optional (see options above - both work)
- Call-to-action at the end
- Natural keyword repetition without stuffing

**What Apple ACTUALLY Restricts:**
- ❌ Emojis in app NAME (not allowed)
- ❌ Emojis in SUBTITLE (not allowed)
- ❌ Trademark symbols (™, ®, ©) unless you own them
- ❌ Excessive punctuation (!!!, ???, ...)
- ❌ All caps text (except short section headers)
- ❌ Misleading claims or fake reviews
- ❌ Reference to other platforms (Android, etc.)
- ❌ Pricing info in description (if price changes)
- ✅ Emojis in description ARE allowed (common practice)
- ✅ Bullet points and formatting ARE allowed
- ✅ Call-to-action IS allowed

**Keywords (100 characters max, no spaces after commas):**
```
event reminder,rsvp,meeting,calendar,attendance,confirm,notification,appointment,invite,alert
```

**ASO Keyword Strategy:**
- **Character count**: 99/100 (maximize usage)
- **High-value keywords included**:
  - "event reminder" (high volume, medium competition)
  - "rsvp" (specific intent, lower competition)
  - "meeting" (broad reach)
  - "calendar" (related search)
  - "attendance" (unique positioning)
  - "confirm" (action-based)
  - "notification" (feature-based)
  - "appointment" (alternate use case)
  - "invite" (discovery keyword)
  - "alert" (alternate for reminder)

**Keywords to AVOID (already in app name/subtitle):**
- Don't repeat words from your app name
- Don't repeat words from subtitle
- Apple ignores duplicate keywords

**Alternative keyword sets to test:**
```
Option 2: meeting alert,event,rsvp,attendance tracker,reminder,schedule,calendar,invite,confirm
Option 3: rsvp app,event planner,meeting reminder,attendance,schedule,calendar invite,alert,time
```

**Keyword Research Tips:**
- Use App Store Connect's Search Ads keyword planner
- Check competitor keywords with ASO tools (Sensor Tower, App Annie)
- Test different combinations every update
- Monitor keyword rankings in App Store Connect

**Promotional Text (170 characters, can update without review):**

**Apple Guidelines:**
- Emojis allowed but use sparingly
- Must be factual and not misleading
- Can include special offers/announcements

**Option 1: With Emoji**
```
NEW: Instant event confirmations with App Clips! No download needed - just tap any event link. Perfect for busy schedules. Try it now!
```

**Option 2: No Emoji (Ultra-Conservative)**
```
NEW: Instant event confirmations with App Clips! No download needed - just tap any event link. Perfect for busy schedules. Try now!
```

**Promotional Text Strategy:**
- Updates without app review required
- Use for:
  - New features announcements
  - Seasonal messaging
  - Limited-time offers
  - A/B testing different messages
- Include emoji sparingly (optional)
- Include call-to-action
- Keep under 170 characters

**Alternative seasonal messages (no emojis):**
- Winter: "Holiday season special: Never miss a party! Instant event RSVP with App Clips - no download required."
- Summer: "Summer events made easy! Tap event links for instant RSVP. Smart reminders keep you on schedule."
- Back-to-school: "Organize your busy schedule! Instant meeting confirmations and smart reminders. Try it now!"
- Year-end: "New Year productivity boost! Quick event confirmations with zero storage. Free App Clip technology."

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
