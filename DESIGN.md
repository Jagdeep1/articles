---
name: Technical Editorial
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#bbc9cd'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#859397'
  outline-variant: '#3c494c'
  surface-tint: '#2fd9f4'
  primary: '#8aebff'
  on-primary: '#00363e'
  primary-container: '#22d3ee'
  on-primary-container: '#005763'
  inverse-primary: '#006877'
  secondary: '#4edea3'
  on-secondary: '#003824'
  secondary-container: '#00a572'
  on-secondary-container: '#00311f'
  tertiary: '#dad9ff'
  on-tertiary: '#1000a9'
  tertiary-container: '#babbff'
  on-tertiary-container: '#3838c6'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#a2eeff'
  primary-fixed-dim: '#2fd9f4'
  on-primary-fixed: '#001f25'
  on-primary-fixed-variant: '#004e5a'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#e1e0ff'
  tertiary-fixed-dim: '#c0c1ff'
  on-tertiary-fixed: '#07006c'
  on-tertiary-fixed-variant: '#2f2ebe'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
typography:
  headline-xl:
    fontFamily: Space Grotesk
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 24px
    fontWeight: '500'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Newsreader
    fontSize: 20px
    fontWeight: '400'
    lineHeight: '1.7'
  body-md:
    fontFamily: Newsreader
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: '1.4'
    letterSpacing: 0.02em
  code-sm:
    fontFamily: Space Grotesk
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 12px
  md: 24px
  lg: 48px
  xl: 80px
  container-max: 800px
  gutter: 24px
---

## Brand & Style

The design system is engineered for deep focus and technical authority. It targets a developer-centric audience that values information density paired with aesthetic clarity. The personality is intellectual, precise, and forward-leaning, evoking the feeling of a premium digital terminal.

The style is a fusion of **Minimalism** and **Modern Technical** aesthetics. It prioritizes content hierarchy through generous whitespace and sharp typographic contrast. Visual interest is generated not through decorative elements, but through the precise execution of functional components—subtle borders, intentional monochromatic layering, and high-energy accent colors that signify interactivity and code logic. The emotional response is one of calm, professional immersion.

## Colors

This design system utilizes a high-contrast dark palette designed to reduce eye strain during long-form reading. The foundation is built on "Obsidian" (#0f172a) for primary backgrounds and "Charcoal" (#1e293b) for elevated surfaces like cards or code blocks.

The accent palette is vibrant and purposeful. Cyan is the primary interactive color, used for links and primary actions, providing a sharp "glow" against the dark base. Emerald is reserved for success states and specific syntax highlighting within code blocks. Tertiary Indigo provides subtle depth for secondary metadata. Borders should remain low-contrast, using a muted slate to define structure without breaking the visual flow.

## Typography

Typography is the core of this design system. It employs a deliberate "Technical vs. Literary" contrast:

1.  **Headlines:** Space Grotesk provides a sharp, geometric, and futuristic feel. It should be set with tight letter-spacing to emphasize its technical precision.
2.  **Body Text:** Newsreader is utilized for article content. As a serif with excellent legibility, it facilitates effortless reading of complex, long-form technical documentation.
3.  **UI & Labels:** Inter is used for navigation, buttons, and metadata to maintain a clean, utilitarian interface.

Maintain a vertical rhythm by using a 1.6x to 1.7x line-height for the body text to ensure the "generous whitespace" philosophy is upheld within the content blocks themselves.

## Layout & Spacing

The layout philosophy centers on a **Fixed Grid** optimized for readability. The primary reading container is constrained to 800px and centered, preventing line lengths from becoming too wide for the serif body text. 

A strict 8px spacing scale governs the rhythm. Use "xl" (80px) padding for section breaks to create a minimalist, airy atmosphere. Sidebars and auxiliary information should be treated as secondary layers, appearing only when necessary to keep the focus on the central narrative. Gutters are fixed at 24px to ensure distinct separation between content and navigation elements.

## Elevation & Depth

Hierarchy in this design system is achieved through **Tonal Layers** and **Low-Contrast Outlines**. Rather than using traditional shadows, which can feel muddy on deep charcoal backgrounds, depth is conveyed by shifting the background color:

*   **Level 0 (Background):** Obsidian (#0f172a).
*   **Level 1 (Cards/Code):** Charcoal (#1e293b).
*   **Level 2 (Popovers/Tooltips):** A slightly lighter slate with a subtle 1px border.

Subtle borders (#334155) are preferred over shadows to define the edges of components. When a shadow is necessary for extreme elevation (e.g., a floating modal), use a high-spread, low-opacity shadow tinted with the primary Cyan color to create a "bloom" effect rather than a dark drop shadow.

## Shapes

The design system uses a "Soft" (0.25rem) roundedness level. This choice balances the sharp, technical nature of the typography with a modern, approachable UI feel. 

Buttons and input fields should strictly adhere to the 4px (0.25rem) radius. Larger containers, such as featured image wrappers or code block blocks, can scale up to 8px (0.5rem) to maintain visual proportion. The goal is to avoid the "boxy" look of early technical sites while steering clear of the overly bubbly appearance of consumer social apps.

## Components

*   **Buttons:** Primary buttons should be solid Cyan with dark text for maximum visibility. Secondary buttons use a "Ghost" style: a subtle slate border that shifts to Cyan on hover.
*   **Code Blocks:** These are the centerpiece. Use the "Charcoal" surface with a 1px border. Syntax highlighting should prioritize Emerald and Cyan. Include a "Copy" label using the Inter font in the top-right corner.
*   **Chips/Tags:** Small, pill-shaped elements with a background color only 5% lighter than the obsidian base, featuring Indigo or Cyan text.
*   **Inputs:** Minimalist bottom-border only or a fully enclosed subtle border. On focus, the border transitions to a 1px solid Cyan stroke.
*   **Cards:** Use for article previews. No shadows; instead, use a 1px border that brightens slightly on hover to indicate interactivity.
*   **Inline Links:** Cyan text with a dotted underline that transitions to a solid underline on hover.