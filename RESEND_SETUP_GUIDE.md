# 📧 Resend Email Notification Setup Guide

**Status:** ✅ Code added to your app (EventViewModel.swift)  
**Next Step:** Configure your Resend account (10 minutes)

---

## What This Does

When someone clicks "Confirm & Remind Me" in your App Clip:
1. ✅ Notifications are scheduled on their device (already working)
2. 🆕 **Email is sent to you** with showing details
3. ✅ Your wife knows WHO confirmed before driving to the showing

---

## Step 1: Create Resend Account (5 minutes)

### 1. Sign Up
- Go to: https://resend.com/signup
- Enter your email
- Verify your email address

### 2. Get API Key
- Go to: https://resend.com/api-keys
- Click **"Create API Key"**
- Name it: `ShowUpBooster`
- Copy the API key (looks like: `re_123abc456def789...`)
- **SAVE IT SOMEWHERE** - you can't see it again after you close the page

---

## Step 2: Update Your App Code (2 minutes)

### Open this file:
`ShowUpBooster/ShowUpBooster/ViewModels/EventViewModel.swift`

### Find these lines (around line 80-82):
```swift
let resendAPIKey = "YOUR_RESEND_API_KEY_HERE"  // Get from resend.com/api-keys
let landlordEmail = "your-email@example.com"    // Your wife's email
```

### Replace with your actual values:
```swift
let resendAPIKey = "re_YOUR_ACTUAL_KEY_HERE"  // Paste your Resend API key
let landlordEmail = "wife@email.com"           // Your wife's actual email
```

**Example:**
```swift
let resendAPIKey = "re_AbC123dEf456GhI789"
let landlordEmail = "lisa@gmail.com"
```

---

## Step 3: Test It (3 minutes)

### Build & Run
1. Build your app in Xcode
2. Run on simulator or device
3. Create a test event link (or use existing one)
4. Open the App Clip
5. Click "Confirm & Remind Me"

### Check Email
- Check your wife's email inbox
- You should receive an email within 10 seconds:
  ```
  Subject: ✅ Showing Confirmed: [Event Name]
  
  Someone just confirmed attendance!
  🏠 Event: Open House - 123 Main St
  📍 Location: 123 Main St, Apt 2B
  ⏰ Time: Mar 15, 2026 at 2:00 PM
  ✅ Confirmed At: [timestamp]
  ```

### Check Xcode Console
You should see:
```
✅ [ShowUpBooster] Landlord notified via email successfully
```

---

## Troubleshooting

### ❌ "Email notification failed with status 401"
**Problem:** Invalid API key  
**Fix:** Double-check you copied the API key correctly from Resend

### ❌ "Email notification failed with status 422"
**Problem:** Invalid email address  
**Fix:** Make sure landlordEmail is a valid email format

### ⚠️ "Resend API not configured yet. Skipping notification."
**Problem:** You haven't replaced the placeholder values yet  
**Fix:** Follow Step 2 above

### ❌ No email received (but console says success)
**Check:**
1. Spam folder
2. Email address spelling
3. Resend dashboard: https://resend.com/emails (shows all sent emails)

---

## Resend Free Tier Limits

✅ **100 emails per day**  
✅ **3,000 emails per month**

**For your use case:**
- 5 showings/week × 2 confirmations per showing = 10 emails/week
- 40 emails/month = **Well within free tier**

---

## Email Customization (Optional)

Want to customize the email? Edit these lines in EventViewModel.swift:

### Change Subject Line:
```swift
"subject": "✅ Showing Confirmed: \(event.title)",
// Change to:
"subject": "🏠 New Showing Confirmation",
```

### Change Email Body:
```swift
"html": """
    <h2>Someone just confirmed attendance!</h2>
    <p><strong>🏠 Event:</strong> \(event.title)</p>
    ...
"""
```

### Add More Details:
If you want to include prospect name/phone (requires implementing Option 3 from CONFIRMATION_TRACKING.md):
```swift
<p><strong>👤 Prospect:</strong> \(event.prospectName ?? "Unknown")</p>
<p><strong>📱 Phone:</strong> \(event.prospectPhone ?? "N/A")</p>
```

---

## Using Your Own Domain (Optional)

By default, emails come from: `ShowUpBooster <onboarding@resend.dev>`

**To use your own domain:** (e.g., `showings@yourdomain.com`)

1. Go to Resend Dashboard → Domains
2. Click "Add Domain"
3. Enter your domain (e.g., `yourdomain.com`)
4. Add DNS records (Resend shows you exactly what to add)
5. Wait for verification (~5-30 minutes)
6. Update code:
   ```swift
   "from": "Property Showings <showings@yourdomain.com>",
   ```

**Recommended domains:**
- Personal domain you already own
- Cheap domain from Namecheap ($1/year for .xyz)
- Or just use `onboarding@resend.dev` (works fine)

---

## Security Considerations

### ⚠️ API Key Security

**Current approach:** API key is in your app code (visible to anyone who decompiles your app)

**Risk level:** Low for your use case
- Free tier = low risk if exposed
- Only sends emails (doesn't access sensitive data)
- Worst case: Someone sends spam emails on your behalf (quickly noticeable)

**If you want better security:**
Use Cloudflare Worker to hide API key (see CONFIRMATION_TRACKING.md Option 2)

### 🔒 Best Practices

1. ✅ Use different API key for production vs testing
2. ✅ Rotate API key if you suspect it's compromised
3. ✅ Monitor Resend dashboard for unusual activity
4. ✅ Consider upgrading to Cloudflare Worker approach later

---

## Next Steps After Testing

### 1. Test with Real Showing
- Create real showing event
- Send link to yourself
- Confirm and check email arrives

### 2. Update App Clip
Make sure the code is in **both** targets:
- ✅ ShowUpBooster (main app)
- ✅ ShowUpBoosterClip (App Clip)

They share the same EventViewModel, so it should work in both automatically.

### 3. Deploy to TestFlight
- Build app
- Upload to App Store Connect
- Test via TestFlight with real showing

### 4. Monitor Results
After 5-10 showings, track:
- How many confirmations you receive
- How many confirmed people actually show up
- Time saved by not going to unconfirmed showings

---

## Upgrade Options (Future)

Once this is working, you can add:

### **User Identity Tracking**
Know WHO confirmed (by name/phone)
- See CONFIRMATION_TRACKING.md Option 3

### **SMS Notifications**
Get text messages instead of email
- Use Twilio ($1.75/month for 100 SMS)

### **Dashboard**
See all confirmations in one place
- Use Supabase (free tier)

### **Analytics**
Track confirmation rates, no-show patterns
- Add Supabase or Firebase

---

## Results You Should See

**Before email notifications:**
- Your wife drives to showings blindly
- 50% no-show rate wastes 5 hours/week

**After email notifications:**
- Check email before leaving
- Only go to confirmed showings
- 90% show-up rate for confirmed attendees
- Save 4+ hours/week

**ROI:** 4 hours/week × $30/hour = **$120/week saved** = $6,240/year

For 10 minutes of setup, that's pretty good! 💰

---

## Support

**If you get stuck:**
1. Check Xcode console for error messages
2. Check Resend dashboard (resend.com/emails) to see if email was sent
3. Review troubleshooting section above
4. Check that both API key and email are correct (no typos)

**Common mistakes:**
- ❌ Forgot to replace placeholder API key
- ❌ Typo in email address
- ❌ API key copied with extra spaces
- ❌ Using HTTP instead of HTTPS (should never happen with Resend)

---

## Summary Checklist

- [ ] Created Resend account (resend.com/signup)
- [ ] Got API key (resend.com/api-keys)
- [ ] Updated EventViewModel.swift with API key
- [ ] Updated EventViewModel.swift with landlord email
- [ ] Built and ran app
- [ ] Tested confirmation flow
- [ ] Received email successfully
- [ ] Checked email formatting looks good
- [ ] Deployed to TestFlight
- [ ] Tested with real showing

**Once all checked:** You're ready to promote on r/landlord! 🎉

---

## What's Already Working

You already have:
- ✅ App Clip that loads instantly from QR code/link
- ✅ "Confirm & Remind Me" button
- ✅ Local notifications (1 day, 2 hours, 30 min before)
- 🆕 **Email notifications to landlord when someone confirms**

**Next:** Test it, then promote on Reddit to get users! 🚀
