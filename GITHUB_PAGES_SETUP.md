# GitHub Pages Setup for ShowUpBooster

## Step 1: Get Your Apple Team ID

You need this for the AASA file.

1. Go to: https://developer.apple.com/account
2. Click on **Membership** in the sidebar
3. Copy your **Team ID** (10 characters, e.g., `A1B2C3D4E5`)

## Step 2: Update AASA File

Edit `docs/.well-known/apple-app-site-association`:

Replace `TEAMID` with your actual Team ID:
```json
{
  "appclips": {
    "apps": [
      "YOUR_TEAM_ID.rkuo.showupbooster.Clip"
    ]
  }
}
```

## Step 3: Create GitHub Repository

### Option A: GitHub.com (Web Interface)

1. Go to: https://github.com/new
2. **Repository name**: `showupbooster`
3. **Visibility**: Public (required for GitHub Pages)
4. **DO NOT** initialize with README, .gitignore, or license
5. Click **Create repository**

### Option B: GitHub CLI (if installed)

```bash
cd /Users/I818292/Documents/Funs/ShowUpBooster
gh repo create showupbooster --public --source=. --remote=origin
```

## Step 4: Initialize Git and Push

```bash
cd /Users/I818292/Documents/Funs/ShowUpBooster

# Initialize git
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit - ShowUpBooster App Clip"

# Add remote (replace YOUR-USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR-USERNAME/showupbooster.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 5: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages** (in sidebar)
3. **Source**: Deploy from a branch
4. **Branch**: Select `main` and `/docs` folder
5. Click **Save**

⏱ GitHub Pages deployment takes 1-2 minutes.

## Step 6: Verify AASA File

After deployment completes, check:

```bash
curl -i https://YOUR-USERNAME.github.io/showupbooster/.well-known/apple-app-site-association
```

Should return:
- **Status**: `200 OK`
- **Content-Type**: `application/json` (ideally, but varies)
- **Body**: Your AASA JSON

## Step 7: Update Xcode Associated Domains

1. Open `ShowUpBooster.xcodeproj` in Xcode
2. Select **ShowUpBooster** target
3. **Signing & Capabilities** tab
4. Under **Associated Domains**:
   - Remove: `appclips:showupbooster.app`
   - Add: `appclips:YOUR-USERNAME.github.io`

5. Select **ShowUpBoosterClip** target
6. **Signing & Capabilities** tab
7. Under **Associated Domains**:
   - Remove: `appclips:showupbooster.app`
   - Add: `appclips:YOUR-USERNAME.github.io`

## Step 8: Update NotificationManager URLs

Edit `ShowUpBooster/Services/NotificationManager.swift`:

Find:
```swift
components.host = "showupbooster.app"
```

Replace with:
```swift
components.host = "YOUR-USERNAME.github.io"
components.path = "/ShowUpBooster/"
```

## Step 9: Test Locally

Update Xcode scheme environment variable:

1. Product → Scheme → Edit Scheme
2. Run → Arguments → Environment Variables
3. Update `_XCAppClipURL`:

```
https://YOUR-USERNAME.github.io/ShowUpBooster/?title=Test&address=Cupertino&datetime=2026-03-01T19:00:00Z&lat=37.3346&lng=-122.009
```

Run in simulator (⌘R) and verify it works!

## Step 10: Test on Real Device

### Option A: Local Experience (Recommended for Testing)

On your iPhone:
1. **Settings** → **Developer** → **Local Experiences**
2. Tap **+**
3. **URL Prefix**: `https://YOUR-USERNAME.github.io/ShowUpBooster`
4. **Bundle ID**: `rkuo.showupbooster.Clip`
5. Save

Now open Safari and visit:
```
https://YOUR-USERNAME.github.io/ShowUpBooster/?title=Test&address=Cupertino&datetime=2026-03-01T19:00:00Z&lat=37.3346&lng=-122.009
```

App Clip should launch!

### Option B: After App Store Connect (Production)

After uploading to TestFlight and configuring App Clip Experience in App Store Connect, URLs will work automatically without Local Experience setup.

## Your GitHub Pages URLs

**Landing Page**:
```
https://YOUR-USERNAME.github.io/ShowUpBooster
```

**Event URL Format**:
```
https://YOUR-USERNAME.github.io/ShowUpBooster/?title=...&address=...&datetime=...&lat=...&lng=...
```

**AASA File**:
```
https://YOUR-USERNAME.github.io/ShowUpBooster/.well-known/apple-app-site-association
```

## Troubleshooting

### ❌ 404 Not Found on GitHub Pages
- Wait 2-5 minutes after enabling Pages
- Check Settings → Pages shows "Your site is live at..."
- Verify `/docs` folder selected as source

### ❌ AASA File Returns 404
- Ensure `.well-known` folder is in `/docs`
- Check file has no extension (not `.json`)
- File should be named exactly: `apple-app-site-association`

### ❌ App Clip Doesn't Launch
- Verify AASA file is accessible (curl test)
- Check Team ID is correct in AASA file
- Use Local Experience for testing
- Ensure Associated Domains added in Xcode
- App Clip might require TestFlight/App Store for full functionality

### ❌ Git Push Fails
- Make sure you replaced YOUR-USERNAME with actual username
- Check you have write access to repository
- Try authenticating with GitHub token or SSH

## Custom Domain (Optional)

Want a custom domain like `showupbooster.com` instead of GitHub username?

1. Buy domain (Namecheap, Porkbun, etc.)
2. In repository Settings → Pages → Custom domain
3. Enter: `showupbooster.com`
4. Configure DNS:
   - Add CNAME record: `www` → `YOUR-USERNAME.github.io`
   - Add A records for apex domain to GitHub IPs
5. Wait for DNS propagation (5-60 minutes)
6. Update Xcode Associated Domains to new domain

## Next Steps

After GitHub Pages is working:

1. ✅ Test URLs work from Safari on iPhone
2. ✅ Archive and upload to TestFlight
3. ✅ Configure App Clip Experience in App Store Connect
4. ✅ Test with internal testers
5. ✅ Submit to App Store

---

**Need help?** Check the main [TESTFLIGHT_SETUP.md](./TESTFLIGHT_SETUP.md) guide.
