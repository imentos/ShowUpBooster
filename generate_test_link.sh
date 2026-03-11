#!/bin/bash

# ShowUpBooster Test URL Generator
# Generates test links with event parameters

echo "🎯 ShowUpBooster Test URL Generator"
echo "===================================="
echo ""

# Preset events menu
echo "Choose a test event:"
echo "1) Open House"
echo "2) Dental Appointment"
echo "3) Job Interview"
echo "4) Restaurant Reservation"
echo "5) Custom Event"
echo ""

read -p "Enter choice (1-5): " choice

case $choice in
    1)
        title="Modern Villa Open House"
        location="123 Maple Street, San Francisco, CA"
        # Set to 3 days from now at 2pm
        datetime=$(date -u -v+3d -v2H -v0M -v0S +"%Y-%m-%dT%H:%M:%SZ")
        hostName="Sarah Johnson"
        hostContact="realestate@example.com"
        eventType="openHouse"
        notes="Beautiful 3-bed, 2-bath home with modern finishes"
        ;;
    2)
        title="Dental Cleaning Appointment"
        location="Bright Smile Dental, 456 Oak Avenue"
        # Set to 2 days from now at 10am
        datetime=$(date -u -v+2d -v10H -v0M -v0S +"%Y-%m-%dT%H:%M:%SZ")
        hostName="Dr. Emily Chen"
        hostContact="555-0123"
        eventType="appointment"
        notes="Bring insurance card. Arrive 10 minutes early."
        ;;
    3)
        title="Software Engineer Interview"
        location="Tech Corp HQ, 789 Innovation Drive"
        # Set to 5 days from now at 9:30am
        datetime=$(date -u -v+5d -v9H -v30M -v0S +"%Y-%m-%dT%H:%M:%SZ")
        hostName="Alex Martinez"
        hostContact="hr@techcorp.com"
        eventType="meeting"
        notes="Panel interview - bring portfolio and resume copies"
        ;;
    4)
        title="Dinner Reservation at Le Jardin"
        location="Le Jardin Restaurant, Downtown"
        # Set to 1 day from now at 7pm
        datetime=$(date -u -v+1d -v19H -v0M -v0S +"%Y-%m-%dT%H:%M:%SZ")
        hostName="Le Jardin"
        hostContact="555-DINE"
        eventType="reservation"
        notes="Table for 4, outdoor seating"
        ;;
    5)
        echo ""
        echo "Enter event details:"
        read -p "Title: " title
        read -p "Location: " location
        
        echo "When is the event?"
        read -p "Days from now: " days_from_now
        read -p "Hour (0-23): " hour
        read -p "Minute (0-59): " minute
        
        datetime=$(date -u -v+${days_from_now}d -v${hour}H -v${minute}M -v0S +"%Y-%m-%dT%H:%M:%SZ")
        
        read -p "Host name: " hostName
        read -p "Host contact: " hostContact
        
        echo "Event type:"
        echo "1) openHouse"
        echo "2) appointment"
        echo "3) showing"
        echo "4) reservation"
        echo "5) meeting"
        echo "6) other"
        read -p "Choose (1-6): " type_choice
        
        case $type_choice in
            1) eventType="openHouse";;
            2) eventType="appointment";;
            3) eventType="showing";;
            4) eventType="reservation";;
            5) eventType="meeting";;
            6) eventType="other";;
            *) eventType="other";;
        esac
        
        read -p "Additional notes (optional): " notes
        ;;
    *)
        echo "Invalid choice, using default Open House event"
        title="Modern Villa Open House"
        location="123 Maple Street, San Francisco, CA"
        datetime=$(date -u -v+3d -v14H -v0M -v0S +"%Y-%m-%dT%H:%M:%SZ")
        hostName="Sarah Johnson"
        hostContact="realestate@example.com"
        eventType="openHouse"
        notes="Beautiful 3-bed, 2-bath home with modern finishes"
        ;;
esac

echo ""
echo "📋 Event Details:"
echo "  Title: $title"
echo "  Location: $location"
echo "  Date/Time: $datetime"
echo "  Host: $hostName ($hostContact)"
echo "  Type: $eventType"
echo "  Notes: $notes"
echo ""

# URL encode function
urlencode() {
    python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))"
}

# Encode parameters
title_encoded=$(urlencode "$title")
location_encoded=$(urlencode "$location")
datetime_encoded=$(urlencode "$datetime")
hostName_encoded=$(urlencode "$hostName")
hostContact_encoded=$(urlencode "$hostContact")
eventType_encoded=$(urlencode "$eventType")
notes_encoded=$(urlencode "$notes")

# Build URL
scheme="showupbooster"
base_url="${scheme}://"

url="${base_url}?title=${title_encoded}&location=${location_encoded}&dateTime=${datetime_encoded}&hostName=${hostName_encoded}&hostContact=${hostContact_encoded}&eventType=${eventType_encoded}"

# Add notes if not empty
if [ -n "$notes" ]; then
    url="${url}&additionalNotes=${notes_encoded}"
fi

echo "🔗 Generated URL:"
echo "$url"
echo ""

# Save to file
echo "$url" > showupbooster_test_link.txt
echo "💾 URL saved to: showupbooster_test_link.txt"
echo ""

# Test options
echo "Test options:"
echo "1) Open in simulator"
echo "2) Generate QR code"
echo "3) Copy to clipboard"
echo "4) All of the above"
echo "5) Done"
echo ""

read -p "Choose (1-5): " test_choice

case $test_choice in
    1|4)
        echo ""
        echo "📱 Opening URL in simulator..."
        xcrun simctl openurl booted "$url"
        echo "✅ URL sent to simulator"
        
        if [ "$test_choice" == "1" ]; then
            echo ""
            echo "Done! ✨"
            exit 0
        fi
        ;;&
    2|4)
        echo ""
        echo "📷 Generating QR code..."
        
        # Check if qrencode is installed
        if command -v qrencode > /dev/null; then
            qrencode -o showupbooster_qr.png "$url"
            echo "✅ QR code saved to: showupbooster_qr.png"
            open showupbooster_qr.png
        else
            echo "⚠️  qrencode not installed. Install with: brew install qrencode"
        fi
        
        if [ "$test_choice" == "2" ]; then
            echo ""
            echo "Done! ✨"
            exit 0
        fi
        ;;&
    3|4)
        echo ""
        echo "📋 Copying URL to clipboard..."
        echo -n "$url" | pbcopy
        echo "✅ URL copied to clipboard"
        
        if [ "$test_choice" == "3" ]; then
            echo ""
            echo "Done! ✨"
            exit 0
        fi
        ;;&
    4)
        echo ""
        echo "Done! ✨"
        exit 0
        ;;
    5)
        echo ""
        echo "Done! ✨"
        exit 0
        ;;
    *)
        echo "Invalid choice"
        ;;
esac

echo ""
echo "Done! ✨"
