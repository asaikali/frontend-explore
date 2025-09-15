## 📌 Note: Why Tailwind is in `dependencies` (and whether you should move it)

After installing Tailwind you’ll see:

```json
"dependencies": {
  "tailwindcss": "^4.1.13",
  "@tailwindcss/vite": "^4.1.13"
}
```

### Why Tailwind puts itself in `dependencies`
- Tailwind and its Vite plugin run **only at build time** (they generate CSS; they don’t ship JS to the browser).
- Some hosting/build environments install **only `dependencies`** during deploy-time builds. Keeping Tailwind here avoids “Tailwind not installed → CSS not built” surprises.

### Will this make my production bundle bigger?
**No.**
- Your browser bundle contains the **generated CSS**, not the Tailwind/Vite plugin packages.
- Whether Tailwind is in `dependencies` or `devDependencies` has **no effect** on the JS/CSS shipped to users.

### Are there downsides to keeping it in `dependencies`?
- You’ll install Tailwind packages in environments where you **only wanted runtime deps** (e.g., a production container that serves static files).
- That can mean:
    - Slightly larger `node_modules` at deploy time
    - Longer install times in minimal production images
    - More packages for security scanners to review (even though they’re build-time only)

### I’m not deploying to Vercel/Netlify/etc. Should I care?
If your CI/CD **does install dev deps during the build** (typical for most pipelines), you can safely move both to **`devDependencies`**:

```bash
npm install -D tailwindcss @tailwindcss/vite
```

This keeps runtime installs lean and matches the reality that Tailwind is a build tool.

### Practical recommendations
- **Local dev / custom CI (common case):** Put `tailwindcss` and `@tailwindcss/vite` in **`devDependencies`**.
- **One-step “build-on-deploy” hosts that skip dev deps:** Keep them in **`dependencies`** to avoid missing-build issues.
- **Docker tip:** Use a multi-stage build:
    - **Builder stage:** install dev deps, run `vite build` (Tailwind runs here).
    - **Runner stage:** copy the built `dist/` only; no Node/Tailwind needed at runtime.

**TL;DR:** Moving Tailwind to `devDependencies` won’t bloat your bundle (it never ships). It only affects where/when the package is installed. Choose based on your deploy/build environment.
```
