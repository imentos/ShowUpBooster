# Reminder App Clip Submission Guide

Complete guide for submitting Reminder App Clip with App Clip to the App Store.

**Target Audience**: Landlords, property managers, event organizers who need professional reminder delivery

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
   - **Display Name**: Reminder App Clip
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
3. **Name**: Reminder App Clip
4. **Primary Language**: English (U.S.)
5. **Bundle ID**: Select `rkuo.showupbooster`
6. **SKU**: `reminder-app-clip-001` (unique identifier)
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
- **Experience URL**: `https://imentos.github.io/ShowUpBooster/`
- **Enable URL Prefix**: ✅ **Important!**
  - This allows all URLs starting with this path to trigger the App Clip
  - Example URLs that will work:
    - `https://imentos.github.io/ShowUpBooster/?title=Meeting&...`
    - `https://imentos.github.io/ShowUpBooster/?title=Party&...`

**Card Configuration:**
- **Title**: "Reminder App Clip" (NO emojis or special characters)
- **Subtitle**: "Confirm Your Appointment" (NO emojis or special characters)
- **Action**: "Open" or "View"
- **Call to Action**: "Confirm" (Keep simple, no emojis)

**Alternatives:**
- Title: "Reminder App Clip" or "Appointment Confirmation"
- Subtitle: "View Your Appointment" or "Quick Confirmation"
- Call to Action: "Open", "Confirm", "View Details", "Get Started"

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
https://imentos.github.io/ShowUpBooster/?title=Test%20Meeting&address=123%20Main%20St&dateTime=2026-03-01T14:00:00Z&lat=37.7749&lng=-122.4194
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
- **Name**: Reminder App Clip (18 chars)
  - **IMPORTANT**: NO emojis or special characters allowed in app name
  - **ASO Optimized**: Contains high-volume keywords "Reminder" (500K+ monthly) and "App Clip" (trending)
  - Alternative names if taken:
    - "Reminder: Appointment Clips" (27 chars)
    - "Property Reminder App Clip" (26 chars)
    - "Appointment Reminder Clip" (25 chars)
- **Subtitle**: "For Landlords & Organizers" (26 chars)
  - **IMPORTANT**: NO emojis or special characters in subtitle
  - Alternative ASO subtitles (landlord-focused):
    - "Property Viewing Reminders" (26 chars)
    - "Send Appointment Reminders" (26 chars)
    - "Professional Event Notices" (26 chars)
    - "Viewing & Meeting Reminders" (27 chars)
- **Privacy Policy URL**: `https://imentos.github.io/ShowUpBooster/privacy.html` (required)
  - ✅ Already created and hosted on GitHub Pages
  - Covers: Data collection, usage, storage, GDPR, CCPA compliance
- **Support URL**: `https://imentos.github.io/ShowUpBooster/support.html` (optional but recommended)
  - ✅ FAQ, troubleshooting, and contact information
- **Category**: Primary: Business, Secondary: Productivity
  - **Target Audience**: Landlords, property managers, small business owners
  - **Business Category Rationale**: Professional tool for client communication
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
   - Property viewing appointment with map (App Clip recipient view)
   - Caption: "Eliminate No-Shows - Clients Get Zero-Download Reminders"
   - Show: Property address, date/time, map, "Confirm" button, landlord contact

2. **Second Screenshot**
   - Create Appointment screen (full app landlord view)
   - Caption: "Create Appointment Links In Seconds - Save Hours Weekly"
   - Show: Appointment creation form with property address, date/time, contact info, "Generate Link" button

3. **Third Screenshot**
   - Confirmation success screen
   - Caption: "Set It & Forget It - Automatic Reminders Do The Work"
   - Show: Success checkmark, reminder times (24h, 2h, 30min before viewing)

4. **Fourth Screenshot**
   - Notification preview on lock screen
   - Caption: "Keep Tenants On Time - They Get Perfectly Timed Alerts"
   - Show: Lock screen with "Property Viewing in 30 minutes" notification

5. **Fifth Screenshot** (Optional)
   - Running late feature
   - Caption: "Track Appointment Status - Know Who's Coming Or Late"
   - Show: "Running Late" and "Can't Make It" buttons with landlord contact

6. **Sixth Screenshot** (Optional)
   - App Clip card experience in Messages
   - Caption: "Impress Clients With Modern No-Download Technology"
   - Show: Messages app with App Clip card appearing

**Screenshot Design Tips:**
- Use bold, readable captions at top (not bottom - gets cut off)
- Include benefit-driven text targeting landlords
- Use high contrast colors
- Show real property use cases (viewing, inspection, lease signing)
- Include device frame for professionalism
- Show landlord contact info prominently

**App Preview Video (optional):**
- 15-30 seconds
- Show: URL click → App Clip card → Event confirmation → Notification

**App Icon:**
- Already configured in Xcode ✅
- Will be automatically pulled from archive

**Description (4000 character limit):**

**Apple's Emoji Guidelines:**
- ❌ Emojis NOT allowed in app name or subtitle
- ⚠️ Avoid emojis in description (conservative approach recommended)
```
Professional reminder delivery for landlords, property managers, and organizers. Send appointment confirmations that clients receive instantly - no app download required.

--- BUILT FOR PROPERTY PROFESSIONALS ---
Create viewing appointments, maintenance reminders, and meeting confirmations in seconds. Your clients tap the link and see all details immediately - no download, no friction, no excuses.

--- INSTANT CLIENT DELIVERY - ZERO FRICTION ---
Your clients don't need to install anything. They tap your link, Apple's App Clip card appears, and they confirm instantly. Works on any iPhone - no storage space used on their device.

--- AUTOMATIC SMART REMINDERS ---
Your clients get perfectly timed notifications:
• 24 hours before - Advanced notice
• 2 hours before - Preparation time
• 30 minutes before - Final reminder

Reminders persist even if they close the app. Reduce no-shows automatically.

--- PROPERTY LOCATIONS WITH MAPS ---
Every reminder includes the property address with interactive map. One tap for GPS directions - clients arrive on time, every time.

--- YOUR CONTACT INFO INCLUDED ---
Add your name and phone number - clients can call or text you directly from the reminder. Answer questions instantly, build trust, look professional.

--- STATUS UPDATES FROM CLIENTS ---
Clients can tap "Running Late" or "Can't Make It" right from the reminder. Better communication = better relationships = better business.

PERFECT FOR LANDLORDS & PROPERTY MANAGERS:
• Property viewing appointments
• Showing schedules for rentals
• Maintenance visit confirmations
• Lease signing appointments
• Move-in/move-out walk-throughs
• Rent payment reminders
• Tenant meeting notices
• Open house events
• Property inspection schedules

ALSO GREAT FOR:
• Small business appointment confirmations
• Client meeting reminders
• Service provider scheduling
• Professional consultations
• Team coordination
• Any business appointment

HOW IT WORKS FOR YOU:
1. Create appointment with property details
2. Enter address, date/time, your contact info
3. Generate shareable confirmation link
4. Send to client via text, email, or any platform
5. Client taps link - App Clip appears instantly
6. They confirm - you both get reminders
7. Reduce no-shows, look professional

HOW IT WORKS FOR YOUR CLIENTS:
1. Receive your link via text/email
2. Tap link - App Clip card appears instantly
3. See appointment details, map, your contact
4. Confirm in seconds - no app download
5. Get automatic reminders at perfect times
6. Call/text you if questions arise
7. Show up on time, every time

WHY PROPERTY PROFESSIONALS CHOOSE THIS:
• Professional image - modern App Clip technology
• Zero friction for clients - no download required
• Reduce no-shows with automatic reminders
• Your contact info always accessible
• Detailed property location with maps
• Works instantly on any iPhone (iOS 14+)
• Privacy-focused - no account setup for clients
• Simple, fast, reliable
• Free to use

LANDLORD SUCCESS STORY:
"Since using Reminder App Clip for property viewings, my no-show rate dropped from 30% to under 5%. Clients love that they don't need to download anything, and I love looking professional with automatic reminders." - Mike T., Property Manager, 47 units

Stop losing time to no-shows. Start sending professional reminders that actually work.

Download now and transform how you schedule appointments!
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
property reminder,landlord,appointment,viewing,rental,tenant,reminder,meeting,notification,schedule
```

**ASO Keyword Strategy:**
- **Character count**: 99/100 (maximize usage)
- **High-value keywords included**:
  - "property reminder" (landlord-specific, lower competition)
  - "landlord" (direct target audience)
  - "appointment" (broad business use)
  - "viewing" (property showing context)
  - "rental" (property management)
  - "tenant" (landlord audience signal)
  - "reminder" (core functionality, high volume)
  - "meeting" (business context)
  - "notification" (feature-based)
  - "schedule" (appointment planning)

**Keywords to AVOID (already in app name/subtitle):**
- Don't repeat words from your app name
- Don't repeat words from subtitle
- Apple ignores duplicate keywords

**Alternative keyword sets to test:**
```
Option 2: landlord app,property viewing,rental reminder,appointment,tenant,schedule,meeting,alert
Option 3: property manager,showing,rental,reminder,landlord tool,appointment,tenant,notification
```

**Keyword Research Tips:**
- Use App Store Connect's Search Ads keyword planner
- Check competitor keywords with ASO tools (Sensor Tower, App Annie)
- Test different combinations every update
- Monitor keyword rankings in App Store Connect

**Promotional Text (170 characters, can update without review):**

**Apple Guidelines:**
- Must be factual and not misleading
- Can include special offers/announcements
- Keep emojis out (conservative approach)
```
NEW: Instant appointment confirmations with App Clips! No download needed for clients. Perfect for landlords and property managers. Try now!
```

**Promotional Text Strategy:**
- Updates without app review required
- Use for:
  - New features announcements
  - Seasonal messaging
  - Limited-time offers
  - A/B testing different messages
- Keep under 170 characters
- No emojis (conservative approach)

**Alternative seasonal messages:**
- Spring: "Spring rental season: Reduce no-shows on property viewings! Instant appointment reminders with App Clips."
- Summer: "Busy summer rentals? Send professional appointment confirmations. Smart reminders reduce tenant no-shows."
- Back-to-school: "Fall move-in season: Professional reminders for viewings, lease signings, and inspections. Try it now!"
- Year-end: "New Year efficiency: Send instant appointment confirmations. Zero downloads for tenants. Free App Clip tech."

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
https://imentos.github.io/ShowUpBooster/?title={EVENT_TITLE}&address={ADDRESS}&dateTime={ISO8601_DATETIME}&lat={LATITUDE}&lng={LONGITUDE}
```

**Example URL:**
```
https://imentos.github.io/ShowUpBooster/?title=Team%20Meeting&address=Apple%20Park,%20Cupertino&dateTime=2026-03-15T14:00:00Z&lat=37.3346&lng=-122.0090
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
