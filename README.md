# ios-github-action-demo
Learning GitHub action implementation with Fastlane


fastlane firebase_deploy config:dev
bundle exec fastlane firebase_deploy config:dev




APPLE_SIGNING_KEYCHAIN_PASSWORD => Kernel@0683
APPLE_SIGNING_CERTIFICATE_PASSWORD =>
APPLE_SIGNING_CERTIFICATE_BASE64 =>
openssl base64 -in "Clearly_Legal_[DEV]__Firebase.mobileprovision" | pbcopy

APPLE_SIGNING_PROVISION_PROFILE_BASE64 =>
openssl base64 -in "Certificates.p12" | pbcopy


FIREBASE_SERVICE_ACCOUNT_BASE64 =>
openssl base64 -in firebase_service_account.json | pbcopy

GH_ACCESS_TOKEN =>
GOOGLE_CHAT_WEBHOOK => 