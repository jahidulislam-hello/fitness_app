# Subscription Navigation Flow

## Complete Navigation Implementation

### 1. **Subscription Package Screen** (`subscription_packages_screen.dart`)

#### Navigation Flows:

**A. Monthly Plan Selection:**
- User taps **"Monthly"** box (US$ 12.99/mo)
- Action: `controller.selectPlan(0)` + Navigate to `/subscription-card`
- Destination: Choose Your Card Screen

**B. 3 Month Plan Selection:**
- User taps **"3 month"** box (US$ 9.74/mo)
- Action: `controller.selectPlan(1)` + Navigate to `/subscription-card`
- Destination: Choose Your Card Screen

**C. Start Free Trial:**
- User taps **"START 5 DAY FREE TRAIL"** button
- Action: Navigate to `/home` (removes all previous routes)
- Destination: Main App Home/Navbar

**D. Redeem Code:**
- User taps **"Redeem Code"** text
- Action: Navigate to `/subscription-code`
- Destination: Subscription Code Screen

---

### 2. **Choose Your Card Screen** (`subscription_card_screen.dart`)

**Card Payment Flow:**
- User enters card details
- User taps **"Pay now"** button
- Action: Navigate to `/subscription-buy`
- Destination: Subscription Buy Screen (Success)

---

### 3. **Subscription Code Screen** (`subscription_code_screen.dart`)

**Redeem Code Flow:**
- User enters promo/redeem code
- User submits code
- Action: Validate code → Navigate to success or error

---

### 4. **Subscription Buy Screen** (`subscription_buy_screen.dart`)

**Final Success Screen:**
- Shows subscription confirmation
- Payment details
- Next steps

---

## Required Routes Configuration

Add these routes to your `goroutes.dart` or routing file:

```dart
'/subscription-packages': (context) => ProfileSubscriptionScreen(),
'/subscription-card': (context) => ChooseYourCardScreen(),
'/subscription-code': (context) => SubscriptionCodeScreen(),
'/subscription-buy': (context) => SubscriptionBuyScreen(),
'/home': (context) => YourHomeScreen(), // Your main navbar/home
```

---

## Navigation Flow Diagram

```
┌─────────────────────────────────────┐
│   Subscription Packages Screen      │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       │               │
       ▼               ▼
┌──────────┐    ┌─────────────┐
│ Monthly  │    │  3 Month    │
│  Plan    │    │   Plan      │
└────┬─────┘    └─────┬───────┘
     │                │
     └────────┬───────┘
              │
              ▼
    ┌─────────────────────┐
    │ Choose Card Screen  │
    └──────────┬──────────┘
               │
               ▼
      ┌────────────────┐
      │   Pay Now      │
      └────────┬───────┘
               │
               ▼
    ┌──────────────────────┐
    │ Subscription Success │
    └──────────────────────┘


┌─────────────────────────────────────┐
│   Subscription Packages Screen      │
└──────────────┬──────────────────────┘
               │
        ┌──────┴──────┐
        │             │
        ▼             ▼
┌──────────────┐  ┌────────────┐
│ Free Trial   │  │ Redeem     │
│   Button     │  │   Code     │
└──────┬───────┘  └─────┬──────┘
       │                │
       ▼                ▼
┌──────────────┐  ┌────────────────┐
│   Home/      │  │  Code Entry    │
│   Navbar     │  │    Screen      │
└──────────────┘  └────────────────┘
```

---

## Implementation Summary

### ✅ Completed:

1. **Monthly/3 Month Plans** → Navigate to Card Screen ✓
2. **Free Trial Button** → Navigate to Home ✓
3. **Redeem Code** → Navigate to Code Screen ✓
4. **Pay Now Button** → Navigate to Success Screen ✓

### Files Modified:

1. `subscription_packages_screen.dart` - Added navigation logic
2. `subscription_card_screen.dart` - Updated Pay Now button

### Navigation Methods Used:

- `Navigator.pushNamed()` - For card, code screens
- `Navigator.pushNamedAndRemoveUntil()` - For home (clears stack)

---

## Testing Checklist

- [ ] Tap Monthly plan → Goes to Card Screen
- [ ] Tap 3 Month plan → Goes to Card Screen
- [ ] Tap "START 5 DAY FREE TRAIL" → Goes to Home
- [ ] Tap "Redeem Code" → Goes to Code Screen
- [ ] On Card Screen, tap "Pay now" → Goes to Success Screen
- [ ] Back button works on all screens
- [ ] Selected plan (0 or 1) is maintained throughout flow

---

## Notes:

- Make sure all routes are registered in your routing configuration
- The `/home` route should point to your main navbar/home screen
- Free trial button clears the navigation stack so users can't go back
- All other navigations allow back navigation

