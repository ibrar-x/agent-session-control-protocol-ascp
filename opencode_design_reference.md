# OpenCode.ai UI Design Reference Document

## Overview
A comprehensive design analysis of [OpenCode.ai](https://opencode.ai/) homepage. The website features a dark, developer-focused aesthetic with a monospace-centric typography system, minimal visual chrome, and a terminal-inspired design language.

**Screenshot:** `opencode_fullpage.png` (full-page capture included)

---

## 1. Color Scheme

### Primary Background Colors
| Token | Value | Usage |
|-------|-------|-------|
| `--color-bg` | `#0c0c0e` | Page/html background - near-black with slight blue undertone |
| `--color-bg-surface` | `#161618` | Surface/elevated backgrounds |
| `--color-bg-elevated` | `#1c1c1f` | Elevated card/container backgrounds |
| Main Container | `#131010` | Primary content container background (warm dark) |

### Text Colors
| Token | Value | Usage |
|-------|-------|-------|
| `--color-text` | `#ffffff` | Primary text (headings, important content) |
| Primary Heading | `#f2edec` | H1, H3 headings - warm off-white |
| `--color-text-secondary` | `#c7c7cc` | Secondary text |
| `--color-text-muted` | `#a1a1a6` | Muted/tertiary text |
| Body/Meta | `#b8b2b2` | Body paragraphs, nav items - warm gray |
| `--color-text-disabled` | `#68686f` | Disabled text |
| Dark Text | `#131010` | Text on light buttons |
| Accent Text | `#7f7a7a` | Special labels, inactive states |
| Star/Badge | `#716b6a` | GitHub star counts, metadata |

### Accent Colors
| Token | Value | Usage |
|-------|-------|-------|
| `--color-primary` | `#007aff` | Primary blue accent (iOS-style) |
| `--color-primary-hover` | `#0056b3` | Primary hover state |
| `--color-primary-active` | `#004085` | Primary active state |
| `--color-success` | `#30d158` | Success states |
| `--color-warning` | `#ff9f0a` | Warning states |
| `--color-danger` | `#ff453a` | Error/danger states |

### Border Colors
| Token | Value | Usage |
|-------|-------|-------|
| `--color-border` | `#38383a` | Standard borders |
| `--color-surface-border` | `#38383a` | Surface borders |
| `--color-border-muted` | `#2c2c2e` | Subtle/divider borders |
| Warm Border | `#3d3838` | Footer divider, warm-toned borders |

### Gradients
**No gradients detected** - The design relies entirely on flat, solid colors with no linear or radial gradients. This reinforces the minimal, terminal-like aesthetic.

---

## 2. Typography

### Font Family
**Primary Font:** `"Berkeley Mono", "IBM Plex Mono", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace`

The entire site uses a **monospace font stack** as the primary typeface, creating a developer-terminal aesthetic. Berkeley Mono is the preferred font, with IBM Plex Mono as the primary fallback.

### Font Sizes
| Element | Size | Usage |
|---------|------|-------|
| H1 (Hero) | `38px` | Main hero heading |
| H3 (Section) | `16px` | Section headings |
| Body | `16px` | Paragraphs, navigation, buttons |
| Small/Label | `14px` | Smaller text elements |

### Font Weights
| Weight | Usage |
|--------|-------|
| `400` (Regular) | Body text, navigation links |
| `500` (Medium) | Button text, emphasized labels |
| `700` (Bold) | Headings (H1, H3) |

### Line Heights
| Element | Value |
|---------|-------|
| H1 | `57px` (1.5x) |
| H3 | `24px` (1.5x) |
| Body | `32px` (2x for hero subtitle) |

### Letter Spacing
- Default: `normal` across all elements
- No custom letter-spacing detected

---

## 3. Layout System

### Container System
| Property | Value |
|----------|-------|
| Max Width | `1200px` |
| Margin | `0 auto` (centered) |
| Padding Bottom | `80px` |

### Section Padding Patterns
| Section Type | Padding |
|--------------|---------|
| Navigation/Header | `24px 80px` |
| Hero Section | `96px 80px` |
| Content Sections | `64px 80px` |
| Full-width Sections | `0px` |

### Spacing Scale (Gaps)
| Value | Usage |
|-------|-------|
| `8px` | Tight spacing, icon gaps |
| `9.6px` | Nav item spacing |
| `10px` | Small gaps |
| `12px` | Tab spacing |
| `16px` | Standard component gaps |
| `24px` | Medium section gaps |
| `32px` | Large section gaps |
| `40px` | Feature gaps |
| `64px` | Major section spacing |

### Layout Method
- **Primary Layout:** Flexbox (40 flex containers detected)
- **Grid:** Not used (0 grid containers detected)
- **Direction:** Primarily `row` for horizontal layouts, `column` for content stacking

---

## 4. Navigation / Header

### Header Bar
| Property | Value |
|----------|-------|
| Background | `#131010` (warm dark) |
| Height | `80px` |
| Padding | `24px 80px` |
| Display | `flex` |
| Justify Content | `space-between` |
| Align Items | `center` |

### Logo
- **Type:** SVG inline image
- **Height:** `34px`
- **Colors:** Uses `#4b4646` (dark gray) and `#b7b1b1` (light gray) in SVG paths
- **Width:** Auto (responsive)

### Navigation Links
| Property | Value |
|----------|-------|
| Color | `#b8b2b2` (default) |
| Hover Color | `#f2edec` (warm white) |
| Font Size | `16px` |
| Font Weight | `400` |
| Text Decoration | `none` (default) |

**Navigation Items:**
- GitHub [140K]
- Docs
- Zen
- Go
- Enterprise
- Download (special styling)

### Download Button (Nav)
| Property | Value |
|----------|-------|
| Background | `#f2edec` (warm white) |
| Text Color | `#131010` (dark) |
| Padding | `8px 16px 8px 10px` |
| Border Radius | `4px` |
| Font Weight | `500` |
| Includes | Download icon + text |

### Mobile Menu Toggle
- **Type:** `<button>` with class `nav-toggle`
- **Text:** "Open menu"
- **Hidden on desktop**, visible on mobile

---

## 5. Hero Section

### Structure
The hero section is divided into two parts:
1. **Text Content Area** (left/top)
2. **Video Demo Area** (right/bottom)

### Announcement Banner
- **Label:** "New"
- **Text:** "Desktop app available in beta on macOS, Windows, and Linux."
- **CTA:** "Download now" link

### Hero Heading
| Property | Value |
|----------|-------|
| Text | "The open source AI coding agent" |
| Font Size | `38px` |
| Font Weight | `700` |
| Color | `#f2edec` |
| Line Height | `57px` |
| Margin Bottom | `8px` |

### Hero Subtitle
| Property | Value |
|----------|-------|
| Text | "Free models included or connect any model from any provider, including Claude, GPT, Gemini and more." |
| Font Size | `16px` |
| Color | `#b8b2b2` |
| Line Height | `32px` |

### Install Tabs Section
**Container:**
- Class: `tabs`
- Display: `block`
- Height: `125px`

**Tab Buttons:**
| Property | Active | Inactive |
|----------|--------|----------|
| Text Color | `#f2edec` | `#7f7a7a` |
| Padding | `16px 0px` | `16px 0px` |
| Border Bottom | Present (implied) | None |
| Cursor | `pointer` | `pointer` |

**Available Tabs:** curl, npm, bun, brew, paru

**Code Display Block:**
| Property | Value |
|----------|-------|
| Text | `curl -fsSL https://opencode.ai/install \| bash` |
| Background | Transparent |
| Padding | `8px 16px 8px 8px` |
| Border Radius | `4px` |
| Font Family | Monospace stack |
| Color | `#b8b2b2` |
| Copy Button | Icon included |

### Hero Video
| Property | Value |
|----------|-------|
| Type | HTML5 `<video>` |
| Source | `/_build/assets/opencode-min-CiEsORKQ.mp4` |
| Width | `1078px` |
| Height | `606.375px` |
| Object Fit | `cover` |
| Autoplay | Yes |
| Loop | Yes |
| Muted | Yes |
| Plays Inline | Yes |
| Poster | `/_build/assets/opencode-poster-CbUiDHgA.png` |

---

## 6. Interactive Elements

### Buttons

**Primary Solid Button (Light)**
```css
background-color: #f2edec;
color: #131010;
padding: 8px 12px 8px 20px;
border-radius: 4px;
font-weight: 500;
text-decoration: none;
```
Used for: "Read docs", main CTAs

**Primary Solid Button (Dark)**
```css
background-color: #131010;
color: #f2edec;
padding: 8px 12px 8px 20px;
border-radius: 4px;
font-weight: 500;
text-decoration: none;
```
Used for: "Learn about Zen"

**Nav Button (Filled)**
```css
background-color: #f2edec;
color: #131010;
padding: 8px 16px 8px 10px;
border-radius: 4px;
font-weight: 500;
```
Used for: "Download" in nav

**Text Link Button**
```css
background-color: transparent;
color: #f2edec;
font-weight: 500;
padding: 0px;
text-decoration: none;
cursor: pointer;
```
Used for: FAQ accordion triggers

**Ghost/Icon Button**
```css
background-color: transparent;
color: #242424;
padding: 8px 16px 8px 8px;
border-radius: 4px;
```
Used for: Code copy button

### Links

**Default Link**
```css
color: #f2edec;
text-decoration: none;
```

**Active/Current Link**
```css
color: #f2edec;
text-decoration: underline 1px;
```

**Muted Link**
```css
color: #7f7a7a;
text-decoration: none;
```

**Footer Link**
```css
color: #f2edec;
text-decoration: underline;
```

### FAQ Accordion
- **Trigger:** `<button>` with `expandable` attribute
- **Icon:** SVG chevron (16x16px)
- **Font Weight:** `500`
- **Color:** `#f2edec`
- **Items:** 8 questions total

### Tabs
- **Type:** ARIA `tablist` with `tab` roles
- **Orientation:** Horizontal
- **Active State:** Underline + `#f2edec` color
- **Inactive State:** `#7f7a7a` color
- **Transition:** Color change on selection

### Form Elements (Newsletter)
- **Input:** Email textbox with standard dark styling
- **Button:** "Subscribe" 
- **Label:** Hidden (placeholder-based)

---

## 7. Cards & Content Containers

### Feature List Items
```css
/* List item structure */
list-style: none;
display: flex;
gap: 12px;
```

**Bullet Indicator:**
```css
color: #716b6a;
content: "[*]";
font-family: monospace;
```

**Feature Title (Strong):**
```css
font-weight: 700;
color: #f2edec;
```

**Feature Description:**
```css
color: #b8b2b2;
font-size: 16px;
```

### Stats Cards
Three stat blocks with:
- Icon/Illustration (SVG)
- Figure label ("Fig 1.", "Fig 2.", "Fig 3.")
- Large number in bold (`140K`, `850`, `6.5M`)
- Description label ("GitHub Stars", "Contributors", "Monthly Devs")

### Section Headers
```css
h3 {
  font-size: 16px;
  font-weight: 700;
  color: #f2edec;
  line-height: 24px;
}
```

---

## 8. Footer

### Footer Layout
| Property | Value |
|----------|-------|
| Background | Transparent |
| Border Top | `1px solid #3d3838` |
| Color | `#b8b2b2` |
| Padding | `0px` |

### Footer Links
- GitHub [140K]
- Docs
- Changelog
- Discord
- X (Twitter)

### Bottom Bar
- Copyright: "© 2026"
- Company: "Anomaly" (linked)
- Legal: Brand, Privacy, Terms
- Language Selector: English dropdown

---

## 9. Overall Aesthetic

### Design Philosophy
- **Developer-First:** Terminal-inspired monospace typography throughout
- **Minimalist:** No gradients, no shadows, no blur effects, no glassmorphism
- **Dark Mode Only:** Single dark theme with no light mode toggle
- **Flat Design:** Zero box-shadows detected, zero backdrop filters
- **Content-Focused:** Minimal UI chrome, content takes center stage

### Visual Characteristics
| Feature | Status | Details |
|---------|--------|---------|
| Dark Mode | ✅ Only mode | `#0c0c0e` background |
| Light Mode | ❌ Not available | - |
| Glassmorphism | ❌ Not used | No backdrop-filter |
| Shadows | ❌ Not used | No box-shadows |
| Gradients | ❌ Not used | All flat colors |
| Blur Effects | ❌ Not used | No filter: blur() |
| Border Radius | Minimal | `4px` for buttons only |
| Animations | Subtle | Video autoplay, hover color transitions |

### Mood & Tone
- **Professional:** Clean, structured, technical
- **Trustworthy:** Open source focus, privacy emphasis
- **Developer-Centric:** Terminal aesthetic, code-first presentation
- **Modern Minimal:** iOS-inspired color tokens with warm dark palette

### Brand Colors in Logo
The OpenCode logo SVG uses:
- `#cfcecd` / `#4b4646` (light variant)
- `#f1ecec` / `#211e1e` (dark variant)
- `#b7b1b1` / `#656363` (alternate)

These warm grays reinforce the overall warm-dark color palette.

---

## 10. CSS Custom Properties Summary

```css
:root {
  --color-white: #ffffff;
  --color-black: #000000;
  --color-bg: #0c0c0e;
  --color-bg-surface: #161618;
  --color-bg-elevated: #1c1c1f;
  --color-text: #ffffff;
  --color-text-secondary: #c7c7cc;
  --color-text-muted: #a1a1a6;
  --color-text-disabled: #68686f;
  --color-border: #38383a;
  --color-border-muted: #2c2c2e;
  --color-surface: #161618;
  --color-surface-border: #38383a;
  --color-surface-hover: #1c1c1f;
  --color-primary: #007aff;
  --color-primary-hover: #0056b3;
  --color-primary-active: #004085;
  --color-primary-text: #ffffff;
  --color-accent: #007aff;
  --color-accent-hover: #0056b3;
  --color-accent-active: #004085;
  --color-success: #30d158;
  --color-warning: #ff9f0a;
  --color-warning-hover: #cc7f08;
  --color-warning-active: #995f06;
  --color-warning-text: #000000;
  --color-danger: #ff453a;
  --color-danger-hover: #d70015;
  --color-danger-active: #a50011;
  --color-danger-text: #ffffff;
}
```

---

## 11. Responsive Considerations

### Mobile Menu
- Nav toggle button: `nav-toggle` class
- Text: "Open menu"
- Hidden on desktop viewport

### Container Behavior
- Main container: `max-width: none` but `width: 1200px`
- Section padding: `80px` horizontal on desktop
- Likely reduces to `20-24px` on mobile (inferred)

---

## 12. Assets & Media

### Logo
- **Type:** Inline SVG
- **Dimensions:** 234x42 viewBox
- **Height Displayed:** 34px
- **Colors:** Warm grays (`#4b4646`, `#b7b1b1`, `#f1ecec`)

### Icons
- **Type:** Inline SVGs
- **Common Sizes:** 16x16px, 18x18px, 24x24px
- **Color:** Inherits from text color
- **Usage:** Navigation arrows, download icons, social icons, accordion chevrons

### Video
- **Format:** MP4 with poster fallback
- **Dimensions:** 1078x606 (16:9 ratio)
- **Behavior:** Autoplay, muted, loop

---

## Key Design Takeaways

1. **Monospace Everything:** The commitment to Berkeley Mono/IBM Plex Mono creates a unique developer-centric identity
2. **Warm Dark Palette:** Unlike typical blue-tinted dark modes, OpenCode uses warm grays (`#b8b2b2`, `#f2edec`) that are easier on the eyes
3. **Zero Chrome:** No shadows, no gradients, no glassmorphism - the content speaks for itself
4. **Terminal Aesthetic:** Code blocks, command-line install instructions, and `[*]` bullet points reinforce the CLI origin
5. **iOS Color Tokens:** The CSS variables follow Apple's color naming conventions (`--color-bg`, `--color-surface`, etc.)
6. **Flat Hierarchy:** Heavy use of `font-weight` and `color` rather than cards, shadows, or borders to create visual hierarchy
7. **Content Density:** Generous whitespace (`80px` section padding) with focused content areas

---

*Document generated from live analysis of https://opencode.ai/ on April 26, 2026*
