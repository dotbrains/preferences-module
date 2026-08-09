# nix-darwin adapter for the macOS system preference scripts in this
# directory. Each setting mirrors its shell-script counterpart 1:1; the
# script remains the rcm-mode implementation and this module is the
# declarative equivalent for nix / hybrid provisioning.
#
# Requires nix-darwin 25.05+ (`system.primaryUser` must be set by the
# blueprint so user-scoped defaults and the activation snippets below
# know which account to target).
#
# Sources:
#   dock.sh, keyboard.sh, trackpad.sh, screen.sh, dashboard.sh,
#   language_and_region.sh, ui_and_ux.sh, security.sh
#
# spotlight.sh is intentionally not represented: it is disabled in
# macos.sh because writing /.Spotlight-V100/VolumeConfiguration fails on
# modern macOS.

{ config, ... }:

{
  system.defaults = {
    # dock.sh
    dock = {
      tilesize = 30;
      expose-animation-duration = 0.15;
      showhidden = true;
    };

    # keyboard.sh, ui_and_ux.sh, language_and_region.sh
    NSGlobalDomain = {
      # keyboard.sh
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 20;
      KeyRepeat = 1;
      # keyboard.sh and language_and_region.sh set the same key
      NSAutomaticSpellingCorrectionEnabled = false;

      # ui_and_ux.sh
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      PMPrintingExpandedStateForPrint = true;
      NSDocumentSaveNewDocumentsToCloud = false;

      # language_and_region.sh
      AppleMeasurementUnits = "Inches";
    };

    # trackpad.sh (typed options cover com.apple.AppleMultitouchTrackpad)
    trackpad = {
      FirstClickThreshold = 0;
      ActuationStrength = 0;
      TrackpadRightClick = true;
    };

    # screen.sh
    screencapture = {
      location = "/Users/${config.system.primaryUser}/Downloads";
      type = "png";
      disable-shadow = true;
    };

    CustomUserPreferences = {
      # trackpad.sh (keys without typed nix-darwin options)
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadCornerSecondaryClick = 2;
      };
      "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
        TrackpadRightClick = true;
      };
      NSGlobalDomain = {
        # trackpad.sh
        ContextMenuGesture = 1;
        # language_and_region.sh
        AppleLanguages = [ "en_US" ];
      };

      # dashboard.sh
      "com.apple.dashboard" = {
        mcx-disabled = true;
      };

      # ui_and_ux.sh
      "com.apple.print.PrintingPrefs" = {
        "Quit When Finished" = true;
      };
      "com.apple.systemuiserver" = {
        menuExtras = [
          "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
          "/System/Library/CoreServices/Menu Extras/AirPort.menu"
          "/System/Library/CoreServices/Menu Extras/Battery.menu"
          "/System/Library/CoreServices/Menu Extras/Clock.menu"
        ];
      };
    };
  };

  # security.sh: use Touch ID to authenticate sudo commands.
  # nix-darwin manages /etc/pam.d/sudo_local directly.
  security.pam.services.sudo_local.touchIdAuth = true;

  # ui_and_ux.sh: imperative leftovers that have no declarative
  # equivalent. The host name mirrors the script's dynamic
  # "Nicholas-<model>" naming, which cannot be computed at Nix
  # evaluation time.
  system.activationScripts.postActivation.text = ''
    # ui_and_ux.sh: host name derived from the hardware model
    model=$(system_profiler SPHardwareDataType | grep "Model Name" | awk -F": " '{print $2}')
    HOST_NAME="Nicholas-$model"
    ESCAPED_HOST_NAME="''${HOST_NAME//[^a-zA-Z0-9-]/}"
    defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$ESCAPED_HOST_NAME"
    scutil --set ComputerName "$ESCAPED_HOST_NAME"
    scutil --set HostName "$ESCAPED_HOST_NAME"
    scutil --set LocalHostName "$ESCAPED_HOST_NAME"

    # ui_and_ux.sh: restart automatically if the computer freezes
    systemsetup -setrestartfreeze on >/dev/null 2>&1 || true

    # ui_and_ux.sh: ByHost menu bar preferences (per-host domains are
    # not reachable through CustomUserPreferences)
    primaryUser=${config.system.primaryUser}
    primaryHome=$(dscl . -read /Users/"$primaryUser" NFSHomeDirectory | awk '{print $2}')
    for domain in "$primaryHome"/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
      [ -e "$domain" ] || continue
      sudo -u "$primaryUser" defaults write "$domain" dontAutoLoad -array \
        '/System/Library/CoreServices/Menu Extras/TimeMachine.menu' \
        '/System/Library/CoreServices/Menu Extras/Volume.menu'
    done

    killall SystemUIServer >/dev/null 2>&1 || true
  '';
}
