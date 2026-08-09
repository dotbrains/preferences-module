# nix-darwin adapter for the Apple app preference scripts in this
# directory. Each setting mirrors its shell-script counterpart 1:1; the
# scripts remain the rcm-mode implementation.
#
# Requires nix-darwin 25.05+ (`system.primaryUser` must be set by the
# blueprint).
#
# Sources:
#   finder.sh, safari.sh, app_store.sh, activity_monitor.sh,
#   messages.sh, mail.sh, maps.sh, photos.sh, textedit.sh
#
# Caveat (safari.sh): Safari is sandboxed on modern macOS, so writing
# com.apple.Safari preferences requires the process performing the
# write (the terminal running darwin-rebuild) to have Full Disk Access,
# exactly as the shell script does today.

{ config, ... }:

{
  imports = [ ./terminal/nix-darwin.nix ];

  system.defaults = {
    # finder.sh (typed options)
    finder = {
      NewWindowTarget = "Documents";
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      AppleShowAllExtensions = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
      FXDefaultSearchScope = "SCcf";
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "clmv";
    };

    # finder.sh (spring loading lives in NSGlobalDomain)
    NSGlobalDomain = {
      "com.apple.springing.enabled" = true;
      "com.apple.springing.delay" = 0.1;
    };

    CustomUserPreferences = {
      # finder.sh (keys without typed nix-darwin options)
      "com.apple.finder" = {
        QLEnableTextSelection = true;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
      };

      # activity_monitor.sh (values mirrored exactly; ShowCategory 0 is
      # the script's legacy "All Processes" value, which the typed
      # nix-darwin option does not accept)
      "com.apple.ActivityMonitor" = {
        OpenMainWindow = true;
        ShowCategory = 0;
      };

      # safari.sh
      "com.apple.Safari" = {
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
        SendDoNotTrackHTTPHeader = true;
        AutoOpenSafeDownloads = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
        IncludeDevelopMenu = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        FindOnPageMatchesWordStartsOnly = false;
        HomePage = "about:blank";
        IncludeInternalDebugMenu = true;
        ShowFavoritesBar = false;
        ShowSidebarInTopSites = false;
        WebKitTabToLinksPreferenceKey = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
        ShowFullURLInSmartSearchField = true;
        WebKitDeveloperExtras = true;
        AutoFillFromAddressBook = false;
        AutoFillPasswords = false;
        AutoFillCreditCardData = false;
        AutoFillMiscellaneousForms = false;
        WebContinuousSpellCheckingEnabled = true;
        WebAutomaticSpellingCorrectionEnabled = false;
        WarnAboutFraudulentWebsites = true;
        WebKitJavaScriptCanOpenWindowsAutomatically = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
        WebKitJavaEnabled = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
        WebKitPluginsEnabled = false;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled" = false;
        InstallExtensionUpdatesAutomatically = true;
      };

      # app_store.sh
      "com.apple.commerce" = {
        AutoUpdate = true;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        AutomaticDownload = 1;
        CriticalUpdateInstall = 1;
      };

      # messages.sh (the script uses dict-add for the same two keys)
      "com.apple.messageshelper.MessageController" = {
        SOInputLineSettings = {
          automaticQuoteSubstitutionEnabled = false;
          continuousSpellCheckingEnabled = false;
        };
      };

      # mail.sh
      "com.apple.mail" = {
        AddressesIncludeNameOnPasteboard = false;
      };

      # maps.sh
      "com.apple.Maps" = {
        LastClosedWindowViewOptions = {
          localizeLabels = 1;
          mapType = 11;
          trafficEnabled = 0;
        };
      };

      # textedit.sh
      "com.apple.TextEdit" = {
        PlainTextEncoding = 4;
        PlainTextEncodingForWrite = 4;
        RichText = 0;
      };
    };
  };

  # Imperative leftovers without a declarative equivalent.
  system.activationScripts.postActivation.text = ''
    primaryUser=${config.system.primaryUser}
    primaryHome=$(dscl . -read /Users/"$primaryUser" NFSHomeDirectory | awk '{print $2}')

    # photos.sh: disable Image Capture hot-plug for the current host
    # (per-host domains are not reachable through CustomUserPreferences)
    sudo -u "$primaryUser" defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

    # finder.sh: snap-to-grid and icon size live in nested plist
    # dictionaries, which `defaults write` (and therefore
    # CustomUserPreferences) cannot address without clobbering sibling
    # keys, so PlistBuddy edits them surgically.
    finderPlist="$primaryHome/Library/Preferences/com.apple.finder.plist"
    plistbuddy() {
      /usr/libexec/PlistBuddy -c "Add $1 $2 $3" "$finderPlist" 2>/dev/null ||
        /usr/libexec/PlistBuddy -c "Set $1 $3" "$finderPlist"
    }
    plistbuddy ":DesktopViewSettings:IconViewSettings:arrangeBy" string grid
    plistbuddy ":FK_StandardViewSettings:IconViewSettings:arrangeBy" string grid
    plistbuddy ":StandardViewSettings:IconViewSettings:arrangeBy" string grid
    plistbuddy ":DesktopViewSettings:IconViewSettings:iconSize" integer 64
    plistbuddy ":FK_StandardViewSettings:IconViewSettings:iconSize" integer 64
    plistbuddy ":StandardViewSettings:IconViewSettings:iconSize" integer 64

    # finder.sh: show the ~/Library folder
    chflags nohidden "$primaryHome/Library" || true

    # finder.sh: preferences are cached since Mavericks, so cfprefsd
    # must be restarted for the PlistBuddy edits to stick
    killall cfprefsd >/dev/null 2>&1 || true
    killall Finder >/dev/null 2>&1 || true
  '';
}
