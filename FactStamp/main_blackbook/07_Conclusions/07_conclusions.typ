= Conclusion

== Conclusion

The FactStamp project was developed to help people check suspicious WhatsApp forwards quickly and share a sourced correction. The system lets users submit claims as text or screenshots, blocks duplicate claims, sends new claims to community verifiers, and settles a verdict only after three independent verifications. A weighted confidence score based on agreement, verifier reputation, and source quality makes each verdict more reliable than a simple vote, and the result can be shared on WhatsApp as a PNG card. With its public dashboard, admin console, and server-side security rules, FactStamp meets its main objectives and provides a working, community-driven way to fight misinformation.

#pagebreak()
== Limitations of the system

- OCR reads only English text, so Hindi and other regional-language forwards must be typed manually.
- In-browser OCR is less accurate on blurry or low-quality screenshots.
- There is no direct WhatsApp integration; users must upload screenshots or paste text themselves.
- While the community is small, a group of fake accounts could outvote honest verifiers.
- Source quality is based on a fixed list of domains, so some credible sources are rated low.
- Overdue claims are settled only when an administrator runs consensus expiry.
- Most testing was manual; only the security rules have an automated test script.
- Each screenshot is limited to about 900 KB because images are stored in Firestore.
- Duplicate detection checks only the 200 most recent claims.

#pagebreak()
== Future scope of the project

- OCR support for Hindi and other Indian languages.
- A community-maintained list of trusted sources.
- Automatic settlement of overdue claims on a schedule.
- A public verifier leaderboard that does not expose private profile data.
- An appeal process for CONTESTED claims.
- Automated tests for duplicate detection and confidence scoring.
- A WhatsApp chatbot so users can forward messages directly to FactStamp.
- A mobile app with push notifications.
- Support for Telegram and SMS forwards.
