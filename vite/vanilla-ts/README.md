# Vanilla TypeScript + Vite

This project explores how Vite works with **TypeScript** in a plain (non-framework) setup.

---

## 🚀 Dev, Build, and Preview

Vite provides three key commands for the project workflow:

### `npm run dev`
- Starts the **development server**.  
- Features:
  - On-demand compilation (ES modules served directly).  
  - **HMR (Hot Module Replacement)** for instant feedback.  
- Uses **esbuild** to transpile `.ts` → `.js` on the fly.  
- ⚡ Very fast, but **skips type checking**.  

### `npm run build`
- Runs the **production build**.  
- In this project, it’s defined as:
  ```sh
  tsc && vite build
  ```
1. **`tsc`** → runs the TypeScript compiler in type-checking mode.
    - Ensures the codebase has no type errors.
    - Usually configured with `noEmit` so it doesn’t output JS.
2. **`vite build`** → bundles and optimizes code for production.

### `npm run preview`
- Serves the `dist/` folder using a static server.
- Lets you verify the production bundle locally.
- **Requires `npm run build` first** (otherwise `dist/` will be empty or stale).

---

## 🧠 TypeScript Workflow

- **IDE (Language Server)**
    - Provides type errors, autocomplete, and diagnostics as you type.
    - Runs independently of Vite.

- **Dev Server (`npm run dev`)**
    - Uses esbuild to transpile quickly.
    - **Ignores type errors** → your app still runs even if types are wrong.
    - Great for speed, not for correctness.

- **Build (`npm run build`)**
    - Runs `tsc` first to enforce type safety.
    - Build fails if there are type errors.
    - Guarantees correctness before shipping.

---

## ✅ Summary

- `dev` = fast iteration, HMR, no type checks.
- `build` = enforce type safety (`tsc`), then bundle for production.
- `preview` = test the optimized output from `dist/`.

👉 During development, type errors show up in the **IDE**, but **only the build step enforces them**.


```text
IDE / TS Language Server (type errors as you type)
        │
        ▼
npm run dev (Vite dev server, esbuild transpile, no type checks)
        │
        ▼
Browser (runs app with HMR, even if types are wrong)

npm run build
   ├─ tsc (type checking, build fails if errors)
   └─ vite build (bundle + optimize)
        │
        ▼
dist/ (production output)

npm run preview (serves dist/ locally for testing)
```

## 🆚 Vanilla JS vs Vanilla TS

| Aspect              | Vanilla JS project                    | Vanilla TS project                             |
|---------------------|---------------------------------------|-----------------------------------------------|
| `npm run dev`       | `vite` → serves JS with HMR           | `vite` → transpiles TS with esbuild (no type checks) |
| `npm run build`     | `vite build` → bundles for prod       | `tsc && vite build` → type-check + bundle      |
| `npm run preview`   | `vite preview` → serve dist/          | `vite preview` → serve dist/                   |
| Type errors in dev  | N/A (no types)                        | Shown in IDE only (not enforced by dev server) |
| Type errors in build| N/A                                   | Enforced by `tsc` before bundling              |

👉 The **only real difference**:
- **Vanilla JS** relies purely on Vite.
- **Vanilla TS** adds **TypeScript type-checking at build time** (`tsc && vite build`).

## 🛠 TypeScript Tools in Vite

It helps to separate the roles of each tool:

### `tsc` (TypeScript Compiler)
- Official TypeScript compiler.
- By default: type checks + transpiles TS → JS.
- In Vite projects, often run with `"noEmit": true` → **only type checks**, no JS output.
- Used during `npm run build` to enforce type safety.

### esbuild
- Ultra-fast transpiler used by Vite under the hood.
- Transpiles `.ts` → `.js` instantly, strips out type annotations.
- **Does not type check**.
- Used during `npm run dev` and also as part of the build pipeline.

### vite build
- Uses esbuild to transpile, then Rollup (or Rolldown) to bundle and optimize.
- Produces the final `dist/` output.
- **Assumes type checking was already done** by `tsc`.

---

### ✅ Summary Table

| Tool       | Role in Vite projects                          |
|------------|-----------------------------------------------|
| `tsc`      | Type checker (noEmit mode, ensures correctness) |
| esbuild    | Fast transpiler (TS → JS, no type checks)       |
| vite build | Full production bundling/optimization           |

👉 Mental model:
- **esbuild** = super fast compiler that ignores types.
- **tsc** = slow but strict type checker.
- **vite build** = the packaging step that assumes code is already valid.

## 📄 Who Uses `tsconfig.json`

`tsconfig.json` is a **TypeScript config file**.  
It belongs to the TypeScript ecosystem, not Vite itself — but multiple tools consume it:

1. **TypeScript Compiler (`tsc`)**
    - Reads `tsconfig.json` when you run `tsc`.
    - Enforces type checking during build (`tsc && vite build`).

2. **IDE / TypeScript Language Server**
    - Uses the same config for autocomplete, intellisense, and inline type errors as you code.

3. **Vite (indirectly, via esbuild + plugins)**
    - Uses some settings (`moduleResolution: "bundler"`, `target`, `lib`) to stay aligned with how TypeScript resolves modules.
    - But Vite itself doesn’t enforce types — it relies on `tsc` and the IDE for that.

```text
             ┌──────────────┐
             │ tsconfig.json│
             └──────┬───────┘
                    │
     ┌──────────────┼──────────────┐
     ▼              ▼              ▼
 TypeScript      IDE / TS        Vite (esbuild)
 Compiler (tsc)  Language        + plugins
                 Server
     │              │              │
 Type checks   Inline errors   Fast TS->JS
 in build      + autocomplete  transpile (no type checks)
```
## 📄 JSON Files at the Project Root

This project has a few key JSON files at the root. Each plays a different role:

### `package.json`
- Defines the project metadata (name, version, private flag).
- Declares **dependencies** and **devDependencies**.
- Provides **npm scripts** (`dev`, `build`, `preview`).
- Acts as the entry point for npm/yarn/pnpm to know how to run and manage the project.

### `tsconfig.json`
- Configuration file for the **TypeScript compiler (`tsc`)** and the **TypeScript language server** used by your IDE.
- Controls:
    - Language features (`target`, `lib`).
    - Module resolution (`module`, `moduleResolution`).
    - Type-checking strictness (`strict`, `noUnusedLocals`, etc.).
- Important: with `"noEmit": true`, it is used only for **type checking**, not for generating JS.

### `package-lock.json` (not shown in your listing yet, but will appear after `npm install`)
- Auto-generated file that locks the exact versions of installed dependencies.
- Ensures reproducible installs across environments.
- Should always be committed to version control.

---

In frontend toolchains, these JSON files are **“owned” by one tool**, but they’re often **read or partially respected by other tools** so everything works together. Let’s break it down:

## 📦 `package.json`

**Owner:**
- The **Node.js + npm ecosystem**.
- It’s the canonical file for describing a Node project (dependencies, scripts, metadata).

**Primary role:**
- Defines dependencies (`dependencies`, `devDependencies`).
- Defines project scripts (`npm run dev`, `npm run build`).
- Declares module type (`"type": "module"` = ESM vs CommonJS).
- Used by npm/yarn/pnpm to install packages.

**Used by others:**
- **Vite** → runs `npm run dev`, `npm run build`, `npm run preview` (defined here).
- **Bundlers (Rollup, Webpack, esbuild, Vite)** → sometimes read `"type"` and `"exports"` fields to resolve modules correctly.
- **IDE/Language servers** → can pick up `"type": "module"` to understand import/export syntax.
- **Other tools (Jest, ESLint, Prettier, etc.)** → often look at `package.json` for configuration or script hooks.

👉 Mental model: **owned by npm, but read by nearly everyone in the toolchain**.

---

## 📄 `tsconfig.json`

**Owner:**
- The **TypeScript compiler (`tsc`)** and the **TypeScript language server**.

**Primary role:**
- Defines how TypeScript files are parsed and type-checked.
- Includes compiler options (target, libs, strictness).
- Defines project structure (`include`, `exclude`, `references`).

**Used by others:**
- **IDE (VS Code, JetBrains, etc.)** → powers autocomplete, diagnostics, inline errors.
- **Vite (via esbuild + plugins)** → reads some fields (`target`, `moduleResolution`, `paths`) to align bundler behavior with TypeScript expectations.
- **Test runners (Vitest, Jest, etc.)** → sometimes respect `paths` mappings or module resolution rules.

👉 Mental model: **owned by TypeScript, but other tools “peek at it” so your development experience stays consistent**.

---

## ✅ Summary Table

| File           | Owned by                | Primary role                         | Also read by… |
|----------------|--------------------------|--------------------------------------|---------------|
| `package.json` | npm / Node.js ecosystem | Project metadata, deps, scripts       | Vite, bundlers, IDEs, linters, test runners |
| `tsconfig.json`| TypeScript compiler     | Type-checking + language settings     | IDEs, Vite, test runners |

---

## 🧠 Takeaway
- In frontend, **ownership** = which tool defines the schema and enforces correctness.
- **Usage** = which other tools consume parts of the config to stay consistent.
- This cross-usage is why configs can feel “magical”: tools collaborate by respecting each other’s config files.

Got it 👍 — let’s distill this down to the **few essentials you actually need as a backend dev** so you don’t drown in frontend config details.


## 🧾 Key Things to Know: TypeScript + Vite Config

### 1. **Two Config Files Matter**
- **`package.json`**
    - Owned by npm.
    - Defines dependencies and scripts (`dev`, `build`, `preview`).
    - Think of it like your `pom.xml` (Maven) or `build.gradle` in backend land.

- **`tsconfig.json`**
    - Owned by TypeScript.
    - Defines how TypeScript type checks your code.
    - Vite mostly ignores it, except for things like module resolution.
    - Think of it like your `javac` compiler flags.

👉 That’s it. Those are the two root configs you’ll touch the most.

---

### 2. **Vite’s Job**
- **Dev mode (`npm run dev`)** → super fast server, hot reload, no type checks.
- **Build mode (`npm run build`)** → type check first (`tsc`), then bundle optimized output.
- **Preview (`npm run preview`)** → serve production bundle locally.

👉 Think of Vite as **Spring Boot Devtools + Maven package** rolled into one.

---

### 3. **TypeScript’s Job**
- **IDE checks** → you see type errors live in your editor.
- **Build gate** → `tsc` runs during build, fails if type errors remain.
- **No emit** → TS doesn’t generate JS, because Vite/esbuild already does that faster.

👉 TypeScript here = **strict linter + safety net**, not the transpiler.

---

### 4. **Don’t Sweat the Extra Configs**
- You may see `tsconfig.node.json`, `tsconfig.app.json`, etc. → those are **conventions**, not new tools.
- They’re just ways of splitting one big `tsconfig.json` into smaller targeted configs.
- For now, you can treat them like “sub-modules” of one config.

---

### 5. **Plugins Matter Later**
- Vite has a plugin system (like Spring Boot starters).
- E.g. `@vitejs/plugin-vue`, `@vitejs/plugin-react`.
- They teach Vite how to handle framework-specific files.
- For plain TS/JS, you don’t need to think about them yet.

---

## ✅ Mental Model (Backend-Friendly)

- **package.json** = build.gradle/pom.xml
- **tsconfig.json** = javac flags (type checking only)
- **vite dev** = `mvn spring-boot:run` (fast hot reload, no strict checks)
- **vite build** = `mvn package` (strict type checks + optimized bundle)
- **vite preview** = run the packaged WAR locally (test before deploy)

---

👉 With just those 5 points, you’ll be productive without getting lost in frontend toolchain details.
