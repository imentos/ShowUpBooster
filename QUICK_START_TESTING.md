# Quick Start: Test App Clip in 30 Seconds

## Step 1: Select App Clip Scheme
In Xcode toolbar (top left):
- Click the scheme dropdown (next to the Stop button)
- Select **"ShowUpBoosterClip"** (not "ShowUpBooster")

## Step 2: Configure Invocation URL
1. **Product** menu → **Scheme** → **Edit Scheme...**
2. Click **Run** on the left
3. Click **Options** tab (top)
4. Scroll to bottom → **App Clip Invocation** section
5. In the **URL** field, paste:
```
https://example.com/?title=Open%20House&location=123%20Main%20St&dateTime=2026-03-10T14:00:00Z&hostName=Sarah&hostContact=sarah@example.com&eventType=openHouse
```
6. Click **Close**

## Step 3: Run
Press **⌘R** (or click the Play button)

## What Happens
✨ App Clip launches showing the Open House event!
- Event title: "Open House"
- Location: "123 Main St"
- Date/time displayed
- "Confirm & Remind Me" button ready

## Test Different Events
Want to test a different event? Just:
1. **Product → Scheme → Edit Scheme**
2. Change the URL parameters:
   - `title=Dentist%20Appointment`
   - `location=Dental%20Office`
   - `dateTime=2026-02-25T10:00:00Z`
   - `eventType=appointment`
3. Run again (⌘R)

No code changes! Instant iteration!

## Common URLs to Test

### Dental Appointment (Tomorrow 10am)
```
https://example.com/?title=Dental%20Cleaning&location=Bright%20Smile%20Dental&dateTime=2026-02-24T10:00:00Z&hostName=Dr.%20Chen&hostContact=555-0123&eventType=appointment
```

### Job Interview (Next Week 9:30am)
```
https://example.com/?title=Software%20Engineer%20Interview&location=Tech%20Corp%20HQ&dateTime=2026-03-03T09:30:00Z&hostName=Alex%20Martinez&hostContact=hr@techcorp.com&eventType=meeting&additionalNotes=Bring%20portfolio
```

### Dinner Reservation (Tonight 7pm)
```
https://example.com/?title=Dinner%20at%20Le%20Jardin&location=Downtown&dateTime=2026-02-23T19:00:00Z&hostName=Le%20Jardin&hostContact=555-DINE&eventType=reservation&additionalNotes=Table%20for%204
```

### Past Event (Should Show Disabled)
```
https://example.com/?title=Past%20Event&location=Old%20Place&dateTime=2020-01-01T10:00:00Z&eventType=other
```

## Troubleshooting

### "No URL appears in the field"
- Make sure you're editing the **ShowUpBoosterClip** scheme (not ShowUpBooster)
- The field might be hidden - scroll down in Options tab

### "App launches but ignores the URL"
- Check your `.onOpenURL()` handler in ShowUpBoosterClipApp.swift
- Look for console logs: `📱 ShowUpBooster received URL:`

### "App crashes on launch"
- Check that Event.fromURL() can parse the URL
- Verify dateTime is in ISO 8601 format: `YYYY-MM-DDTHH:MM:SSZ`
- Look at Xcode console for error messages

## Where This is in Xcode

```
Main Menu
└─ Product
   └─ Scheme
      └─ Edit Scheme...
         └─ Run (left sidebar)
            └─ Options (tab)
               └─ [Scroll Down]
                  └─ App Clip Invocation
                     └─ URL: [paste here]
```

## Next: Test Confirmation Flow

Once the event displays:
1. ✅ Tap "Confirm & Remind Me"
2. ✅ Grant notification permission (if prompted)
3. ✅ See success screen with 3 reminders
4. ✅ Verify status changes to "Confirmed!"

---

**Pro Tip**: Save commonly used URLs in a text file for easy copy/paste during testing!

**Remember**: This simulates scanning a QR code. For testing the actual QR code scanning experience, see [XCODE_SETUP_GUIDE.md](XCODE_SETUP_GUIDE.md) "Production Setup" section.
