# Vue Basic + Vite

This project builds on the **vanilla-ts + Vite** setup but adds **Vue 3**.  
The main differences are how **Vue Single File Components (SFCs)** are handled and how **TypeScript integrates more deeply**.

---

## 🆕 New Concepts vs. Vanilla TS

### 1. Vue Single File Components (SFCs)
- Vue components live in `.vue` files with three sections:
    - `<template>` → declarative HTML-like markup.
    - `<script setup>` → TypeScript/JavaScript logic for the component.
    - `<style>` → optional scoped or global CSS.
- Vite alone does not understand `.vue` files.  
  That’s why this project includes:
    - **`vue`** → the runtime framework.
    - **`@vitejs/plugin-vue`** → the Vite plugin that compiles `.vue` files into JS modules, handles `<script setup>`, and wires up hot reload for components.

👉 In short: `.vue` = component packaging format; `@vitejs/plugin-vue` teaches Vite how to process them.

---

### 2. TypeScript in Vue
Vanilla TS projects only need `tsc`. Vue projects add extra tooling:

- **`vue-tsc`**
    - A TypeScript checker that understands `.vue` files and template expressions.
    - Example: if you reference a prop incorrectly in a template, `vue-tsc` catches it, while `tsc` would miss it.
    - That’s why the build script uses:
      ```sh
      vue-tsc -b && vite build
      ```
      → type check both `.ts` and `.vue` before bundling.

- **`@vue/tsconfig`**
    - Provides sensible `tsconfig` presets for Vue projects.
    - Instead of writing all compiler options yourself, you can `extends` these presets in `tsconfig.json`, `tsconfig.app.json`, or `tsconfig.node.json`.

👉 In short: Vue extends TypeScript’s ecosystem so that **both script and template code are type-checked**.

---

## 📄 Extra Config Files

Compared to vanilla-ts, you’ll see more `tsconfig` files:

- **`tsconfig.json`** → base config (shared settings).
- **`tsconfig.app.json`** → config for application code (`src/`).
- **`tsconfig.node.json`** → config for Node-related files (like `vite.config.ts`).

This split keeps concerns clear:
- App code uses DOM libs + Vue presets.
- Node config uses Node.js libs and different module resolution.

---

## ✅ Summary

- `vue` = framework runtime.
- `@vitejs/plugin-vue` = lets Vite compile `.vue` Single File Components.
- `vue-tsc` = Vue-aware type checker (templates + scripts).
- `@vue/tsconfig` = official base configs for TypeScript in Vue projects.
- Multiple `tsconfig.*.json` files = separation between **app code** and **Node tooling**.

👉 The big leap from vanilla-ts is that **TypeScript now checks both your component scripts and your Vue templates**, and Vite relies on a plugin to compile `.vue` files.

## 🆚 Vanilla TS vs Vue Basic

| Aspect                  | Vanilla TS project                          | Vue Basic project                                   |
|--------------------------|---------------------------------------------|-----------------------------------------------------|
| Framework runtime        | None (just TS + Vite)                      | `vue` (Vue 3 framework)                             |
| Component format         | `.ts` + `.html` separately                  | `.vue` Single File Components (template + script + style) |
| Extra Vite support       | Not needed                                  | `@vitejs/plugin-vue` to compile `.vue` files        |
| TypeScript checking      | `tsc` (noEmit, scripts only)                | `vue-tsc` (checks `.ts` **and** `.vue` templates)   |
| TS config presets        | Manual `tsconfig.json`                      | Extends `@vue/tsconfig` for sensible defaults       |
| tsconfig structure       | Single file (`tsconfig.json`)               | Multiple configs: base + `tsconfig.app.json` + `tsconfig.node.json` |
| Build script             | `tsc && vite build`                        | `vue-tsc -b && vite build`                         |

👉 The **new things in Vue projects** are:
- The **`.vue` component format**.
- Vite needs **a plugin** to understand `.vue` files.
- TypeScript checking extends into **templates** with `vue-tsc`.
- Configs are often split into multiple `tsconfig.*.json` files.  

## 🧩 Why multiple `tsconfig` files (and what each is for)

Vue projects split TypeScript config by **runtime** so the right libs/types are used in the right places:

- **Root `tsconfig.json` (project references)**
  - Acts as a **map**, not a real config.
  - Points to the two sub-configs:
    - `tsconfig.app.json` → browser app code
    - `tsconfig.node.json` → node/tooling code
  - Lets IDEs and `vue-tsc` load both “sub-projects” cleanly.

- **`tsconfig.app.json` (browser / Vue app)**
  - Extends Vue’s DOM preset (`@vue/tsconfig/tsconfig.dom.json`) so you get **DOM types** and Vue-friendly defaults.
  - **Includes**: `src/**/*.ts`, `src/**/*.tsx`, `src/**/*.vue` (so both scripts **and templates** are type-checked).
  - Works with **`vue-tsc`** to type-check template expressions (props, emits, v-for/v-if bindings), which plain `tsc` can’t see.

- **`tsconfig.node.json` (Node / tooling)**
  - Targets **Node-side files** such as `vite.config.ts`.
  - Uses modern ES targets and “bundler” resolution so TypeScript resolves modules like Vite/Rollup do.
  - **No DOM libs** (because this code runs in Node, not the browser).
  - `noEmit: true`: only type-check — Vite/esbuild handles transpiling.

**Why the split?**  
Browser code and Node tooling have **different environments** (DOM vs Node). Splitting configs avoids type conflicts, keeps each context strict and clean, and speeds up incremental checks.

```
Root tsconfig.json
├─ tsconfig.app.json   (browser: DOM + Vue + .vue files)
└─ tsconfig.node.json  (node: tooling like vite.config.ts)
```

---

## ⚙️ The new `vite.config.ts` (what’s new vs vanilla-ts)

```ts
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
})
```

- **What it is:** Vite’s project configuration file (TypeScript-flavored).
- **Why it’s new here:** Vue uses **Single File Components** (`.vue`). Vite doesn’t understand `.vue` by default — you must add the **Vue plugin**.
- **`@vitejs/plugin-vue`:**
    - Compiles `<template>` into render functions.
    - Supports `<script setup>` and scoped CSS.
    - Wires **fast HMR** for component updates.
- **Relation to `tsconfig.node.json`:**
    - Since `vite.config.ts` runs in **Node**, it’s type-checked under the **Node** config (no DOM, bundler-style resolution).
    - Keeps Node typings separate from your browser app typings.

**Build flow reminder (Vue + TS):**
- **Dev:** `vite` → fast server + HMR; esbuild transpiles TS (no type checks).
- **Type-check:** `vue-tsc -b` → checks `.ts` **and** `.vue` templates.
- **Build:** `vite build` → bundles/optimizes for production.
```
