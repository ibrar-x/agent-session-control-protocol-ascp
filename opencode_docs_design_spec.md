# OpenCode Documentation - Design Spec Analysis

> Extracted from https://opencode.ai/docs on 2026-04-26

---

## 1. Overall Layout & Page Structure

| Property | Value |
|----------|-------|
| **Page max-width** | 1185px |
| **Body background** | `#131010` |
| **Body text color** | `#b8b2b2` |
| **Font family** | `"IBM Plex Mono", ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace` |
| **Base font size** | 14px |
| **Base line height** | ~1.6875 (23.625px) |
| **Layout type** | 3-column fixed layout |

### Column Breakdown

| Column | Position | Width | Notes |
|--------|----------|-------|-------|
| **Left Sidebar** | Fixed, left: 0, top: 64px | 300px | Navigation menu |
| **Main Content** | Static, left: 300px | ~652.5px | Article content |
| **Right Sidebar (TOC)** | Fixed, left: ~952.5px, top: 64px | ~232.5px | "On this page" |

---

## 2. Header / Top Bar

| Property | Value |
|----------|-------|
| **Position** | Fixed |
| **Width** | 1185px (full page width) |
| **Height** | 64px |
| **Background** | `#131010` |
| **Border bottom** | 1px solid `#555962` |
| **Z-index** | High (above content) |

### Header Elements

| Element | Color | Size | Weight | Notes |
|---------|-------|------|--------|-------|
| **Logo** | `#f2eded` | 20px | 600 | Text-decoration: none |
| **Social icons** (GitHub/Discord) | `#f2eded` | - | - | SVG icons |

---

## 3. Search Component

### Search Trigger Button (Header)

| Property | Value |
|----------|-------|
| **Background** | Transparent (`rgba(0,0,0,0)`) |
| **Border** | 1px solid `#3d3838` |
| **Border radius** | 4px |
| **Padding** | 6px 12px |
| **Color** | `#a3a6ae` |
| **Width** | ~111px |
| **Height** | 36px |
| **Display** | Flex |
| **Align items** | Center |
| **Gap** | 12px |
| **Font** | IBM Plex Mono, 14px |

**Contents:**
- Magnifying glass icon (14x14px, color `#a3a6ae`)
- "Search" text
- ⌘K keyboard shortcut badge

### Search Modal / Dialog

| Property | Value |
|----------|-------|
| **Background** | `#131010` |
| **Border** | 1px solid `#555962` |
| **Border radius** | 0px |
| **Width** | 640px |
| **Box shadow** | Multi-layer subtle dark shadow |
| **Position** | Fixed |

### Search Input (Inside Modal)

| Property | Value |
|----------|-------|
| **Background** | `#17181c` |
| **Color** | `#ffffff` |
| **Border** | 1px solid `#3369ff` (blue focus state) |
| **Border radius** | 8px |
| **Height** | ~51px |
| **Padding** | 0px 56px 0px 43.2px |
| **Font size** | 16.8px |
| **Font family** | IBM Plex Mono |

---

## 4. Sidebar (Left Navigation)

### Sidebar Pane

| Property | Value |
|----------|-------|
| **Position** | Fixed |
| **Top** | 64px (below header) |
| **Left** | 0px |
| **Width** | 300px |
| **Height** | 701px (viewport minus header) |
| **Background** | `#131010` |
| **Border right** | 1px solid `#3d3838` |
| **Overflow** | Auto |
| **Z-index** | 5 |

### Sidebar Content Area

| Property | Value |
|----------|-------|
| **Padding** | 24px 0px |
| **Display** | Flex |
| **Flex direction** | Column |
| **Gap** | 16px |

### Sidebar Links (Level 1)

| Property | Value |
|----------|-------|
| **Color** | `#f2eded` |
| **Font size** | 14px |
| **Font weight** | 400 |
| **Padding** | 4px 24px |
| **Text decoration** | None |

### Active Sidebar Link

| Property | Value |
|----------|-------|
| **Color** | `#f2eded` |
| **Background** | `#1b1818` |
| **Font weight** | 600 |
| **Border left** | 2px solid `#f2eded` |
| **Padding** | 4px 24px |

### Sidebar Group Headers (Collapsible)

Examples: "Usage", "Configure", "Develop"

| Property | Value |
|----------|-------|
| **Color** | `#b8b2b2` |
| **Font size** | 14px |
| **Font weight** | 400 |
| **Padding** | 0px 24px |
| **Display** | Flex |
| **Cursor** | Pointer |
| **List style** | Inside none disclosure-open |

### Sidebar Nested Links (Level 2)

| Property | Value |
|----------|-------|
| **Color** | `#f2eded` |
| **Font size** | 14px |
| **Padding** | 4px 24px |

### Sidebar Icons
- Contains 11 SVG icons total
- Disclosure triangles are native browser details/summary markers

---

## 5. Content Area Typography

### Headings

| Level | Size | Weight | Color | Margin Top | Margin Bottom | Line Height |
|-------|------|--------|-------|------------|---------------|-------------|
| **H1** | 26px | 500 | `#f2eded` | 0 | 0 | 31.2px |
| **H2** | 14px | 400 | `#f2eded` | 0 | 0 | - |
| **H4** | 16px | 500 | `#f2eded` | 54px | 0 | - |

### Body Text

| Element | Size | Line Height | Color | Margin Bottom |
|---------|------|-------------|-------|---------------|
| **Paragraph** | 14px | 21px | `#b8b2b2` | 0px |
| **Strong/Bold** | 14px | - | `#b8b2b2` | - |
| **Bold weight** | 500 | - | - | - |

### Links

| Property | Value |
|----------|-------|
| **Color** | `#f2eded` |
| **Text decoration** | Underline |
| **Font weight** | 400 |

### Inline Code

| Property | Value |
|----------|-------|
| **Color** | `#b8b2b2` |
| **Background** | Transparent |
| **Padding** | 0px |
| **Border radius** | 0px |
| **Font family** | ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace |
| **Font size** | 14px |

### Lists

| Property | Value |
|----------|-------|
| **List style type** | None |
| **Padding left** | 0px |
| **Margin bottom** | 0px |

### Horizontal Rule / Separator

| Property | Value |
|----------|-------|
| **Border top** | None (`0px none`) |
| **Margin** | 54px 0px 0px |
| **Background** | Transparent |

---

## 6. Code Blocks

### Container (`<figure>`)

| Property | Value |
|----------|-------|
| **Background** | `#1b1818` |
| **Border radius** | 1px |
| **Border** | None |
| **Margin** | 22px 0px 0px |
| **Overflow** | Visible |

### Preformatted Block (`<pre>`)

| Property | Value |
|----------|-------|
| **Background** | Transparent (inherits from figure) |
| **Color** | `#b8b2b2` |
| **Padding** | 0px |
| **Border radius** | 0px 0px 1px 1px |
| **Font family** | Monospace |
| **Font size** | 14.4px |
| **Line height** | 23.76px |
| **Overflow** | Auto |
| **Tab size** | 8 |

### Code Block Title / Figcaption

| Property | Value |
|----------|-------|
| **Background** | Transparent |
| **Color** | `#b8b2b2` |
| **Padding** | 4px 0px 5px |
| **Font size** | 14.4px |
| **Border bottom** | 1px solid `#555962` |

### Copy Button

| Property | Value |
|----------|-------|
| **Background** | `#131010` |
| **Color** | `#ffffff` |
| **Width** | 32px |
| **Height** | 32px |
| **Border** | None |
| **Border radius** | 0px |
| **Padding** | 0px |

### Expressive Code Theme Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `--ec-codeBg` | `#24292e` | Code background (GitHub dark) |
| `--ec-codeFg` | `#e1e4e8` | Code foreground |
| `--ec-frm-edBg` | `#24292e` | Editor background |
| `--ec-frm-trmBg` | `#1f2428` | Terminal background |
| `--ec-frm-edTabBarBg` | `#1f2428` | Tab bar background |
| `--ec-frm-edActTabBg` | `#24292e` | Active tab background |
| `--ec-brdCol` | `#1b1f23` | Border color |
| `--ec-frm-trmTtbBg` | `#24292e` | Terminal title bar bg |
| `--ec-frm-trmTtbFg` | `#e1e4e8` | Terminal title bar fg |
| `--ec-focusBrd` | `#005cc5` | Focus border |
| `--ec-codeSelBg` | `#3392ff44` | Selection background |

---

## 7. Syntax Highlighting Theme

**Theme:** GitHub Dark (via Expressive Code / Shiki)

Colors are applied via inline CSS custom properties (`--0` for light theme, `--1` for dark theme).

| Token Type | Dark Color | Light Color | Examples |
|------------|------------|-------------|----------|
| **Keywords** | `#f97583` | `#BF3441` | `import`, `from`, `const`, `await`, `try`, `catch`, `if`, `for`, `of`, `as`, `===` |
| **Functions/Methods** | `#b392f0` | `#6F42C1` | `npm`, `createOpencode`, `log`, `get`, `prompt`, `health`, `subscribe` |
| **Strings** | `#9ecbff` | `#032F62` | `"@opencode-ai/sdk"`, `"127.0.0.1"`, `"Hello!"` |
| **Variables/Identifiers** | `#79b8ff` | `#005CC5` | `client`, `opencode`, `result`, `session`, `config` |
| **Numbers** | `#79b8ff` | `#005CC5` | `4096`, `20`, `5000` |
| **Comments** | `#99a0a6` | `#6A737D` | `// Access the structured output` |
| **Special keywords** | `#ffab70` | - | `default` |
| **Default text** | `#e1e4e8` | `#24292E` | Spaces, punctuation, braces |

---

## 8. Tables

| Property | Value |
|----------|-------|
| **Width** | 556.5px (content width) |
| **Border collapse** | Separate |
| **Margin bottom** | 0px |

### Table Header (`<th>`)

| Property | Value |
|----------|-------|
| **Background** | Transparent |
| **Color** | `#ffffff` |
| **Padding** | 0px 16px 8px 0px |
| **Border bottom** | 1px solid `#555962` |
| **Font weight** | 600 |
| **Text align** | Left |
| **Font size** | 13px |

### Table Cell (`<td>`)

| Property | Value |
|----------|-------|
| **Padding** | 8px 16px 8px 0px |
| **Border bottom** | 1px solid `#23262f` |
| **Color** | `#b8b2b2` |
| **Font size** | 14px |

### Table Row (`<tr>`)
- **No zebra striping** (alternating rows have transparent background)
- **No border-top/border-bottom** on rows themselves

---

## 9. Callouts / Asides / Alerts

Built with Starlight's aside component. No border-radius, no left border.

### Note Aside

| Property | Value |
|----------|-------|
| **Background** | `#171d4f` |
| **Color** | `#ffffff` |
| **Padding** | 15px 16px 14px |
| **Border radius** | 0px |
| **Icon color** | `#bdc3ff` |

### Tip Aside

| Property | Value |
|----------|-------|
| **Background** | `#40224e` |
| **Color** | `#ffffff` |
| **Padding** | 15px 16px 14px |
| **Border radius** | 0px |
| **Icon color** | `#ebccfa` |

### Caution Aside

| Property | Value |
|----------|-------|
| **Background** | `#4e4022` |
| **Color** | `#ffffff` |
| **Padding** | 15px 16px 14px |
| **Border radius** | 0px |
| **Icon color** | `#f9e8c3` |

### Blockquotes

| Property | Value |
|----------|-------|
| **Background** | Transparent |
| **Border left** | 2px solid `#23262f` |
| **Padding** | 0px 0px 0px 16px |
| **Margin** | 22px 0px 30px |
| **Color** | `#b8b2b2` |

---

## 10. Tabs

### Tab List

| Property | Value |
|----------|-------|
| **Orientation** | Horizontal |
| **Border bottom** | None visible |

### Individual Tab

| Property | Value |
|----------|-------|
| **Color** | `#f2eded` |
| **Background** | Transparent |
| **Padding** | 0px 20px 6px |
| **Font size** | 13px |
| **Border** | None |
| **Border radius** | 0px |

### Selected Tab

| Property | Value |
|----------|-------|
| **Color** | `#f2eded` |
| **Background** | Transparent |
| **Border bottom** | 2px solid `#f2eded` |
| **Font weight** | 600 |

---

## 11. Table of Contents (Right Sidebar)

### TOC Container

| Property | Value |
|----------|-------|
| **Position** | Fixed |
| **Left** | ~952.5px |
| **Top** | 64px |
| **Width** | ~232.5px |
| **Background** | Transparent |
| **Border left** | None |

### TOC Heading ("On this page")

| Property | Value |
|----------|-------|
| **Font size** | 13px |
| **Color** | `#b8b2b2` |
| **Font weight** | 400 |
| **Margin bottom** | - |

### TOC Links

| Property | Value |
|----------|-------|
| **Color** | `#b8b2b2` |
| **Font size** | 13px |
| **Padding** | 8px 16px |
| **Text decoration** | None |

### Nested TOC Links (H2 subsections)
- Same styling as level 1 but indented

---

## 12. Color Palette Summary

### Background Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Page BG** | `#131010` | Body, header, sidebar pane, copy button |
| **Card/Surface** | `#1b1818` | Code block figure, active sidebar link |
| **Code BG** | `#24292e` | Expressive Code editor background |
| **Terminal BG** | `#1f2428` | Expressive Code terminal frame |
| **Search Input** | `#17181c` | Search modal input field |
| **Note Aside** | `#171d4f` | Note callout background |
| **Tip Aside** | `#40224e` | Tip callout background |
| **Caution Aside** | `#4e4022` | Caution callout background |

### Text Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Primary text** | `#b8b2b2` | Body paragraphs, sidebar groups, figcaption |
| **Headings/Links** | `#f2eded` | H1-H4, sidebar links, active states, logo |
| **Muted text** | `#a3a6ae` | Search button text, placeholder text |
| **White** | `#ffffff` | Table headers, aside text, search input text |
| **Code default** | `#e1e4e8` | Code block default text |

### Border Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Subtle border** | `#3d3838` | Search button border, sidebar border-right |
| **Medium border** | `#555962` | Header border-bottom, figcaption border-bottom, table header border |
| **Dark border** | `#23262f` | Table cell borders, blockquote border-left |
| **Focus blue** | `#3369ff` | Search input focus border |
| **Code border** | `#1b1f23` | Expressive Code frame borders |

### Syntax Colors

| Name | Hex | Usage |
|------|-----|-------|
| **Keyword red** | `#f97583` | Keywords |
| **Function purple** | `#b392f0` | Function names |
| **String blue** | `#9ecbff` | Strings |
| **Variable cyan** | `#79b8ff` | Variables, numbers |
| **Comment gray** | `#99a0a6` | Comments |
| **Special orange** | `#ffab70` | Special keywords |

---

## 13. Spacing Summary

| Element | Key Spacing |
|---------|-------------|
| **Header height** | 64px |
| **Sidebar width** | 300px |
| **Sidebar content padding** | 24px 0px |
| **Sidebar link padding** | 4px 24px |
| **Main content left offset** | 300px |
| **Main content width** | ~652.5px |
| **Right sidebar width** | ~232.5px |
| **Paragraph line height** | 21px |
| **Code block margin top** | 22px |
| **H4 margin top** | 54px |
| **HR margin top** | 54px |
| **Blockquote margin** | 22px 0px 30px |
| **Aside padding** | 15px 16px 14px |
| **Search button padding** | 6px 12px |
| **Search modal width** | 640px |

---

## 14. Key Design Characteristics

1. **Monospace-first**: The entire site uses IBM Plex Mono as the primary font, giving it a terminal/editor aesthetic.
2. **High contrast dark theme**: Very dark backgrounds (`#131010`) with muted but readable text (`#b8b2b2`).
3. **Sharp corners**: Minimal border-radius throughout (0px-4px max). Code blocks have 1px radius. Search input has 8px.
4. **No gradients**: Flat colors only.
5. **Subtle borders**: Separators use low-contrast borders (`#3d3838`, `#555962`) rather than shadows.
6. **GitHub dark syntax theme**: Expressive Code with Shiki using GitHub's dark color palette.
7. **Starlight-based**: Built on Astro Starlight documentation framework with custom theming.
8. **Fixed 3-column layout**: Sidebar, content, and TOC are all fixed width.
9. **Minimalist callouts**: No rounded corners, no left borders, just solid background color blocks.
10. **Native disclosure triangles**: Sidebar groups use native `<details>`/`<summary>` elements.
