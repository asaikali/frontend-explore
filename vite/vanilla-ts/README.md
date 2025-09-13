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


```mermaid
flowchart TD
    A[IDE / TS Language Server] -->|Type errors shown inline| Dev[Dev Server (vite)]
    Dev -->|Transpile via esbuild<br/>no type checks| Browser[Browser + HMR]
    Dev -->|On save| B[Build]
    B[Build (tsc && vite build)] -->|Type checked + bundled| Dist[dist/]
    Dist --> Preview[Preview Server (vite preview)]
    Preview --> User[Test production build locally]
```

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
