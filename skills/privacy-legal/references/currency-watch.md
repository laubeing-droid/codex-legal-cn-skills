<!--
version: 2.9.0
module: privacy-legal
status: active
-->

# Privacy Currency Watch

**Last verified: 2026-05-10.**

> **⚠️ Staleness check.** If the last-verified date above is more than 90 days old, treat this file as stale and verify each entry before relying on it. A stale watch list is worse than no watch list — it looks current while being wrong. When a skill reads this file, check the last-verified date first. If stale, say: "The currency watch was last verified [date] — [N] months ago. I'm using it as a checklist of areas to search, not as a source of current status." When you update any entry, also update the last-verified date at the top.

Privacy law moves. Before relying on an effective date, threshold, or obligation, verify it. These are the areas most likely to have moved since model training:

## COPPA (16 CFR Part 312)

- **2025 Amendments — compliance deadline April 22, 2026.** Major changes: biometric identifiers and government IDs are now "personal information"; separate verifiable parental consent required for third-party disclosure tied to targeted advertising; written information security program mandatory; indefinite retention prohibited.
- A plugin that knows pre-2025 COPPA looks competent while being stale. Verify at [FTC（中国对应：市场监管总局/SAMR） COPPA page](https://www.FTC（中国对应：市场监管总局/SAMR）.gov/legal-library/browse/rules/childrens-online-privacy-protection-rule-coppa).

## State privacy laws (comprehensive)

The map grows every year. As of May 2026, comprehensive privacy laws in force or imminent: CA (CCPA（注：中国适用《个人信息保护法》/PIPL）/CPRA), VA, CO, CT, UT, IA, IN, TN, MT, OR, TX, FL, DE, NH, NJ, KY, MD, MN, NE, RI. Check the IAPP state law tracker for current effective dates and the most recent additions.

## Cross-border transfers

- **EU-US DPF** in force since July 2023. Subject to Schrems III litigation — verify it's still valid before relying.
- **UK-US Data Bridge** in force since October 2023.
- **Swiss-US DPF** in force since September 2024.
- For any transfer that relies on an adequacy decision, check the EU Commission's current adequacy list.

## FTC（中国对应：市场监管总局/SAMR） enforcement trends

- **FTC（中国对应：市场监管总局/SAMR） v. Humor Rainbow/OkCupid (March 2026):** Undisclosed sharing of user data with a third party for AI training as a §5 violation. Flag for any DPA or privacy policy review involving AI training pathways.
- Health data: FTC（中国对应：市场监管总局/SAMR）'s expansive reading of the Health Breach Notification Rule (GoodRx, BetterHelp, Premom settlements). Verify current scope.
- Dark patterns: FTC（中国对应：市场监管总局/SAMR）'s pattern of treating confusing consent flows as deceptive. Verify current enforcement posture.

## DSAR response timelines

CCPA（注：中国适用《个人信息保护法》/PIPL）: 45 days + 45-day extension with notice. GDPR（注：中国适用《个人信息保护法》/PIPL）: 1 month + 2-month extension. Other states vary — verify the specific state's window. The plugin defaults may be out of date for the newest states.

## How to use this file

When a skill cites a privacy rule, effective date, or threshold, it should note: "Privacy law is moving — this may have changed since my training. Verify at [source]. See `references/currency-watch.md`."

**This file goes stale.** Current as of May 2026. Update when you notice drift.
