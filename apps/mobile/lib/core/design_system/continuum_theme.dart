import '../../ui/shadcn/shared/theme/theme.dart';
import '../../ui/shadcn/shared/theme/color_scheme.dart';
import 'continuum_tokens.dart';

ThemeData buildContinuumTheme() {
  return ThemeData.dark(
    colorScheme: ColorSchemes.darkDefaultColor.copyWith(
      background: () => ContinuumColorTokens.bgSurface,
      foreground: () => ContinuumColorTokens.textPrimary,
      card: () => ContinuumColorTokens.bgElevated,
      cardForeground: () => ContinuumColorTokens.textPrimary,
      popover: () => ContinuumColorTokens.bgOverlay,
      popoverForeground: () => ContinuumColorTokens.textPrimary,
      primary: () => ContinuumColorTokens.accent,
      primaryForeground: () => ContinuumColorTokens.accentForeground,
      secondary: () => ContinuumColorTokens.bgOverlay,
      secondaryForeground: () => ContinuumColorTokens.textPrimary,
      muted: () => ContinuumColorTokens.bgOverlay,
      mutedForeground: () => ContinuumColorTokens.mutedText,
      accent: () => ContinuumColorTokens.accent,
      accentForeground: () => ContinuumColorTokens.accentForeground,
      destructive: () => ContinuumColorTokens.danger,
      destructiveForeground: () => ContinuumColorTokens.textPrimary,
      border: () => ContinuumColorTokens.border,
      input: () => ContinuumColorTokens.bgOverlay,
      ring: () => ContinuumColorTokens.accent,
      chart1: () => ContinuumColorTokens.accent,
      chart2: () => ContinuumColorTokens.success,
      chart3: () => ContinuumColorTokens.warning,
      chart4: () => ContinuumColorTokens.danger,
      chart5: () => ContinuumColorTokens.mono,
      sidebar: () => ContinuumColorTokens.bgElevated,
      sidebarForeground: () => ContinuumColorTokens.textPrimary,
      sidebarPrimary: () => ContinuumColorTokens.accent,
      sidebarPrimaryForeground: () => ContinuumColorTokens.accentForeground,
      sidebarAccent: () => ContinuumColorTokens.bgOverlay,
      sidebarAccentForeground: () => ContinuumColorTokens.textPrimary,
      sidebarBorder: () => ContinuumColorTokens.border,
      sidebarRing: () => ContinuumColorTokens.accent,
    ),
  );
}
