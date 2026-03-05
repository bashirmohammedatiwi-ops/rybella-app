# Cosmatic Design System

## Brand
- **Name:** كوزماتيك (Cosmatic)
- **Positioning:** Premium luxury beauty, Iraqi market
- **Tagline:** جمالك فخامة (Your beauty, luxury)

## Colors (Primary Palette)
| Token        | Hex       | Usage                    |
|-------------|-----------|--------------------------|
| Pink        | `#F8E8EC` | Backgrounds, soft areas   |
| Pink Deep   | `#E8B4BC` | Borders, accents        |
| Pink Light  | `#FDF2F4` | Input borders            |
| Gold        | `#C9A962` | Primary actions, accents |
| Gold Light  | `#E8DCC8` | Gradients, secondary    |
| Gold Dark   | `#B89850` | Buttons gradient end     |
| Surface     | `#FEFEFE` | App background           |
| Card        | `#FFFFFF` | Cards, sheets            |
| Text Primary| `#2D2D2D` | Body text                |
| Text Secondary | `#6B6B6B` | Muted text            |

## Typography
- **Font:** Tajawal (Arabic-optimized)
- **Weights:** 400, 500, 600, 700, 800
- **Scale:** Display (32/28), Headline (22), Title (18/16), Body (16/14), Label (14)

## Spacing (8px base)
- space1: 8px
- space2: 16px
- space3: 24px
- space4: 32px
- space5: 40px
- space6: 48px

## Border Radius
- Small: 12px
- Medium: 16px
- Large: 24px

## Shadows
- Soft: `0 4px 20px rgba(201, 169, 98, 0.12)`
- Card: `0 4px 12px rgba(201, 169, 98, 0.12)`

## RTL
- All layouts are Right-to-Left (Arabic).
- Flutter: `Directionality(textDirection: TextDirection.rtl)` or locale `ar_IQ`.
- Web admin: `dir="rtl"` and `lang="ar"`.

## Currency
- Iraqi Dinar (IQD)
- Format: `XX,XXX د.ع` (e.g. 50,000 د.ع)

## Components
- Cards: white background, rounded medium, soft shadow
- Buttons: gold gradient primary, pink secondary
- Inputs: white fill, pink border, gold focus ring
