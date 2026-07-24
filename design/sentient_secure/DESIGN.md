---
name: Sentient Secure
colors:
  surface: '#fcf8fa'
  surface-dim: '#dcd9db'
  surface-bright: '#fcf8fa'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f6f3f5'
  surface-container: '#f0edef'
  surface-container-high: '#eae7e9'
  surface-container-highest: '#e4e2e4'
  on-surface: '#1b1b1d'
  on-surface-variant: '#45464d'
  inverse-surface: '#303032'
  inverse-on-surface: '#f3f0f2'
  outline: '#76777d'
  outline-variant: '#c6c6cd'
  surface-tint: '#565e74'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#131b2e'
  on-primary-container: '#7c839b'
  inverse-primary: '#bec6e0'
  secondary: '#5c5e68'
  on-secondary: '#ffffff'
  secondary-container: '#dedfeb'
  on-secondary-container: '#60626c'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#271901'
  on-tertiary-container: '#98805d'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#e1e2ed'
  secondary-fixed-dim: '#c4c6d1'
  on-secondary-fixed: '#191b24'
  on-secondary-fixed-variant: '#444650'
  tertiary-fixed: '#fcdeb5'
  tertiary-fixed-dim: '#dec29a'
  on-tertiary-fixed: '#271901'
  on-tertiary-fixed-variant: '#574425'
  background: '#fcf8fa'
  on-background: '#1b1b1d'
  surface-variant: '#e4e2e4'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  button-text:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-max: 1280px
  gutter: 1.5rem
  margin-mobile: 1rem
  stack-sm: 0.5rem
  stack-md: 1rem
  stack-lg: 2rem
---

## Brand & Style

The design system is anchored in a dual-persona philosophy: **Guardian** and **Oracle**. It balances the stoic, reliable nature of local-first privacy with the expansive, fluid intelligence of cloud-based processing. The target audience includes professionals and privacy-conscious power users who require high-performance AI without compromising data integrity.

The aesthetic follows a **Corporate / Modern** style with a heavy emphasis on **Tonal Layering**. It prioritizes clarity, systematic organization, and high readability. Visual cues like iconography and color shifts provide immediate feedback on the state of data processing (On-Device vs. Cloud), ensuring the user always feels in control and informed.

## Colors

The color palette is functionally mapped to the application's processing states.

- **Primary (Deep Navy/Slate):** Used for structural elements, primary text, and navigation to establish a foundation of security and stability.
- **Secondary - Local (Emerald Green):** Indicates "Safe/On-Device" processing. This color should be used for status indicators, toggle states, and borders when the AI is working locally.
- **Secondary - Cloud (Tech Indigo):** Indicates "Intelligence/API" connection. This color highlights features requiring external processing, signaling enhanced capability.
- **Background:** A "Clean White" (#FFFFFF) base for primary content areas, with a "Cool Grey" (#F1F5F9) for secondary surfaces to create subtle contrast without visual noise.

## Typography

The typography system utilizes **Inter** for its exceptional readability in UI contexts. It is supported by **JetBrains Mono** for technical labels and status indicators to emphasize the "intelligence" and "data" aspects of the product.

- **Headlines:** Use a tighter letter spacing and bold weights to project authority.
- **Body:** Standardized at 16px for optimal reading of long-form AI responses.
- **Labels:** Use JetBrains Mono in all-caps for metadata, such as "LOCAL" or "ENCRYPTED," to differentiate system info from user content.
- **Multi-language:** Inter provides excellent glyph support for English, Russian, and Uzbek (Latin/Cyrillic), ensuring a consistent look across all locales.

## Layout & Spacing

This design system uses a **Fluid Grid** with fixed maximum widths for readability.

- **Desktop:** 12-column grid, 24px gutters, max-width 1280px. Chat interfaces should be centered with a max-width of 800px to maintain line-length ergonomics.
- **Tablet:** 8-column grid, 20px gutters.
- **Mobile:** 4-column grid, 16px gutters.
- **Rhythm:** An 8px linear scale is used for all internal component padding and spacing. Vertical stack spacing should double between major sections (8px -> 16px -> 32px).

## Elevation & Depth

Hierarchy is established through **Tonal Layers** and **Ambient Shadows**.

- **Level 0 (Base):** The main background color (#F8FAFC).
- **Level 1 (Cards/Surface):** White (#FFFFFF) with a very soft, diffused shadow (0px 4px 12px rgba(15, 23, 42, 0.05)).
- **Level 2 (Modals/Popovers):** White (#FFFFFF) with a more defined shadow (0px 12px 32px rgba(15, 23, 42, 0.1)).
- **Interactive Depth:** Buttons and cards should use a subtle 1px border (#E2E8F0) in their resting state. On hover, the shadow intensity increases slightly while the border color transitions toward the primary or secondary color depending on the context.

## Shapes

The shape language is approachable yet professional, utilizing generous radii to soften the "technical" nature of AI.

- **Standard Elements:** 8px (0.5rem) for input fields and small buttons.
- **Cards & Containers:** 16px (1rem) for most content blocks.
- **Large Featured Cards:** 24px (1.5rem) for main dashboard elements or onboarding steps.
- **Full Rounding:** Pill shapes are reserved for status tags (e.g., "Privacy Mode") and toggle switches.

## Components

- **Buttons:**
  - **Primary:** Deep Navy background, white text. High-contrast.
  - **Status-Specific:** Emerald for "Secure Action," Indigo for "Enhance with Cloud."
- **Status Chips:** Small, pill-shaped indicators at the top of the chat or in the header. Use icons: a **Shield** for "On-Device" and a **Cloud** for "Web API."
- **Cards:** White background, 16px corner radius, 1px subtle border. No heavy shadows unless the card is being dragged or hovered.
- **Input Fields:** Large, 16px rounded corners. The focus state should change border color based on the current mode (Green for local, Indigo for cloud).
- **Lists:** Clean rows with 12px vertical padding. Use `body-sm` for secondary descriptions.
- **Toggle/Switch:** Use a physical-inspired "thumb" with a 2px inset shadow for a tactile feel.
- **AI Response Bubbles:** Use a slight off-white or light-grey background to distinguish AI responses from the clean white app background.