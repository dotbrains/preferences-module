# nix-darwin adapter for terminal.sh, mirrored 1:1.
#
# The shell script writes to both the com.apple.terminal and
# com.apple.Terminal spellings; on macOS these resolve to the same
# preference domain, so a single canonical domain is used here.

{ ... }:

{
  system.defaults.CustomUserPreferences."com.apple.terminal" = {
    # Focus follows mouse for Terminal windows (the script writes the
    # string "true", mirrored exactly)
    FocusFollowsMouse = "true";

    # Prevent other applications from reading keyboard input
    SecureKeyboardEntry = true;

    # Hide line marks
    ShowLineMarks = 0;

    # Only use UTF-8 (encoding 4)
    StringEncodings = [ 4 ];
  };
}
