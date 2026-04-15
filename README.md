# 📈 Stock Market Portfolio Tracker
### SAP ABAP Cloud · RAP Unmanaged Model

> **Register No:** 22IT018 &nbsp;|&nbsp; **Student:** DEEPAK S &nbsp;|&nbsp; **Mentor:** Ajayan C &nbsp;|&nbsp; **Package:** `ZMK_RAP_STCK`

---

## 📌 Project Overview

A full-stack SAP Fiori Elements application built on **ABAP RESTful Application Programming (RAP) — Unmanaged** model that allows users to manage stock market investment portfolios. Users can create portfolios, track individual stock holdings, monitor purchase vs. current prices, and manage portfolio status — all with draft-enabled OData V4 UI.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│           SAP Fiori Elements UI             │
└──────────────────┬──────────────────────────┘
                   │ OData V4
┌──────────────────▼──────────────────────────┐
│  Service Binding     ZCIT_STCK_BIND         │
│  Service Definition  ZCIT_STCK_UI           │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  Consumption Views  (Projection Layer)      │
│  ZCIT_STCK_C    Header Consumption View     │
│  ZCIT_STCK_H_C  Item Consumption View       │
│  Metadata Ext:  ZCIT_STCK_C / ZCIT_STCK_H_C│
│  Projection BDef: ZCIT_STCK_C              │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  Interface Views  (Business Object Layer)   │
│  ZCIT_STCK_I    Root Interface View         │
│  ZCIT_STCK_H_I  Child Interface View        │
│  Behavior Def:  ZCIT_STCK_I (Unmanaged)    │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  Implementation Classes                     │
│  ZCL_STCK_UTIL  Transactional Buffer        │
│  ZBP_STCK_HDR   Header Handler              │
│  ZBP_STCK_ITM   Item Handler                │
│  ZBP_STCK_I     Saver Class                 │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│  Database Tables                            │
│  ZMK_STCK_H   Portfolio Header              │
│  ZMK_STCK_I   Portfolio Item               │
│  ZCIT_STCK_HD Draft Table (Header)          │
│  ZCIT_STCK_ID Draft Table (Item)            │
└─────────────────────────────────────────────┘
```

---

## 📁 File Structure

```
ZMK_RAP_STCK/
│
├── 📂 Database Tables
│   ├── ZMK_STCK_H          → Portfolio Header Table
│   ├── ZMK_STCK_I          → Portfolio Item Table
│   ├── ZCIT_STCK_HD        → Draft Table (Header)
│   └── ZCIT_STCK_ID        → Draft Table (Item)
│
├── 📂 Core Data Services
│   ├── 📂 Interface Views (BO Layer)
│   │   ├── ZCIT_STCK_I     → Root Interface View (Header)
│   │   └── ZCIT_STCK_H_I   → Child Interface View (Item)
│   │
│   ├── 📂 Consumption Views (Projection Layer)
│   │   ├── ZCIT_STCK_C     → Header Consumption View
│   │   └── ZCIT_STCK_H_C   → Item Consumption View
│   │
│   ├── 📂 Metadata Extensions
│   │   ├── ZCIT_STCK_C     → Header UI Labels & Layout
│   │   └── ZCIT_STCK_H_C   → Item UI Labels & Layout
│   │
│   ├── 📂 Behavior Definitions
│   │   ├── ZCIT_STCK_I     → Unmanaged BDef (Root)
│   │   └── ZCIT_STCK_C     → Projection BDef
│   │
│   └── 📂 Service Layer
│       ├── ZCIT_STCK_UI    → Service Definition
│       └── ZCIT_STCK_BIND  → Service Binding (OData V4-UI)
│
└── 📂 Source Code Library (ABAP Classes)
    ├── ZCL_STCK_UTIL       → Buffer Utility (Singleton)
    ├── ZBP_STCK_HDR        → Header Handler Class
    ├── ZBP_STCK_ITM        → Item Handler Class
    └── ZBP_STCK_I          → Saver Class
```

---

## 🏷️ Naming Convention

> Pattern: `ZCIT_STCK_<suffix>` — all names ≤ **16 characters**

| Object Name      | Type                  | Chars | Description                    |
|------------------|-----------------------|-------|--------------------------------|
| `ZMK_STCK_H`     | Database Table        | 10    | Portfolio Header               |
| `ZMK_STCK_I`     | Database Table        | 10    | Portfolio Item (Holdings)      |
| `ZCIT_STCK_I`    | Root View Entity      | 11    | Header Interface View          |
| `ZCIT_STCK_H_I`  | View Entity           | 13    | Item Interface View            |
| `ZCIT_STCK_C`    | Root View Entity      | 11    | Header Consumption View        |
| `ZCIT_STCK_H_C`  | View Entity           | 13    | Item Consumption View          |
| `ZCIT_STCK_HD`   | Draft Table           | 12    | Header Draft Storage           |
| `ZCIT_STCK_ID`   | Draft Table           | 12    | Item Draft Storage             |
| `ZCL_STCK_UTIL`  | ABAP Class            | 13    | Transactional Buffer Singleton |
| `ZBP_STCK_HDR`   | Behavior Impl. Class  | 12    | Header Handler Logic           |
| `ZBP_STCK_ITM`   | Behavior Impl. Class  | 12    | Item Handler Logic             |
| `ZBP_STCK_I`     | Behavior Impl. Class  | 10    | Saver Class                    |
| `ZCIT_STCK_UI`   | Service Definition    | 12    | OData Service Exposure         |
| `ZCIT_STCK_BIND` | Service Binding       | 14    | OData V4-UI Endpoint           |

---

## 🚀 Setup & Activation Order

> ⚠️ Follow this exact order to avoid dependency errors.

```
Phase 1 — Database Tables
  1. ZMK_STCK_H          (Activate individually)
  2. ZMK_STCK_I          (Activate individually)

Phase 2 — Interface Views
  3. ZCIT_STCK_I  +  ZCIT_STCK_H_I   ← Activate TOGETHER (Ctrl+Shift+F3)

Phase 3 — Consumption Views
  4. ZCIT_STCK_C  +  ZCIT_STCK_H_C   ← Activate TOGETHER (Ctrl+Shift+F3)

Phase 4 — Metadata Extensions
  5. ZCIT_STCK_C   (Metadata Extension)
  6. ZCIT_STCK_H_C (Metadata Extension)

Phase 5 — Implementation
  7. ZCL_STCK_UTIL       (Utility class — activate first)
  8. ZCIT_STCK_I         (Behavior Definition — save only, don't activate yet)
  9. ZCIT_STCK_HD        (Draft table — create via Quick Fix Ctrl+1)
 10. ZCIT_STCK_ID        (Draft table — create via Quick Fix Ctrl+1)
 11. ZCIT_STCK_I         (Behavior Definition — activate now)
 12. ZBP_STCK_HDR        (Header Handler — generate via Quick Fix, add code, activate)
 13. ZBP_STCK_ITM        (Item Handler — generate via Quick Fix, add code, activate)
 14. ZBP_STCK_I          (Saver Class — generate via Quick Fix, add code, activate)

Phase 6 — Projection
 15. ZCIT_STCK_C         (Projection Behavior Definition)

Phase 7 — Service Layer
 16. ZCIT_STCK_UI        (Service Definition)
 17. ZCIT_STCK_BIND      (Service Binding → Publish/Activate → Preview)
```

---

## ✅ Features

- **Create Portfolio** — header record with investor info, currency, and status
- **Add Stock Holdings** — line items under each portfolio with quantity, prices, and sector
- **Update Holdings** — edit current price, quantity, or status
- **Delete Holdings** — removes individual stock rows
- **Delete Portfolio** — cascades and removes all holdings underneath
- **Draft Handling** — full draft/activate/discard lifecycle via `with draft` in BDef
- **OData V4** — standard Fiori Elements List Report + Object Page layout
- **Buffer Pattern** — in-memory transactional buffer (`ZCL_STCK_UTIL`) separates modify and save phases cleanly

---

## 🗂️ Data Model

### ZMK_STCK_H — Portfolio Header
| Field             | Type        | Description                    |
|-------------------|-------------|--------------------------------|
| `portfolioid`     | CHAR(10) 🔑 | Portfolio ID (Primary Key)     |
| `portfolioname`   | CHAR(60)    | Portfolio display name         |
| `investorid`      | CHAR(12)    | Investor identifier            |
| `investorname`    | CHAR(60)    | Investor full name             |
| `basecurrency`    | CUKY        | Base currency key              |
| `totalinvested`   | CURR(15,2)  | Total capital invested         |
| `currentvalue`    | CURR(15,2)  | Current portfolio value        |
| `portfoliostatus` | CHAR(1)     | A=Active I=Inactive C=Closed   |
| `createdon`       | DATS        | Creation date                  |

### ZMK_STCK_I — Portfolio Items (Holdings)
| Field           | Type        | Description                    |
|-----------------|-------------|--------------------------------|
| `portfolioid`   | CHAR(10) 🔑 | Foreign Key → ZMK_STCK_H       |
| `stocksymbol`   | CHAR(10) 🔑 | Stock ticker symbol (PK)       |
| `stockname`     | CHAR(60)    | Full company name              |
| `exchange`      | CHAR(10)    | Exchange (NSE / BSE / NYSE)    |
| `sector`        | CHAR(20)    | Industry sector                |
| `quantity`      | QUAN(13,3)  | Number of shares held          |
| `purchaseprice` | CURR(13,2)  | Price at time of purchase      |
| `currentprice`  | CURR(13,2)  | Current market price           |
| `currency`      | CUKY        | Currency key                   |
| `purchasedate`  | DATS        | Date of purchase               |
| `holdingstatus` | CHAR(1)     | H=Holding S=Sold W=Watchlist   |

---

## 🔧 Troubleshooting

| Problem | Fix |
|---------|-----|
| Red underline on view entity | Activate both interface views together with `Ctrl+Shift+F3` |
| Draft table doesn't exist | Double-click draft table name in BDef → Quick Fix (`Ctrl+1`) |
| Class `zbp_stck_xxx` not found | Quick Fix (`Ctrl+1`) on class name in BDef → auto-generate |
| BDef won't activate | Create both draft tables first, then activate BDef |
| Publish button greyed out | Click **Activate** — some cloud systems use Activate instead |
| No data in Fiori preview | Click **Go** in the search bar to trigger initial load |
| Duplicate key error | Portfolio ID already exists — use a different ID |

---

## 👤 Author

| Field | Value |
|-------|-------|
| Name | DEEPAK S |
| Register No | 22IT018 |
| Package | ZMK_RAP_STCK |
| Mentor | Ajayan C |
| System | SAP BTP ABAP Cloud |
| Model | RAP Unmanaged |
| OData Version | V4 - UI |

---
