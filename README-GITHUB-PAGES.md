# Publish to GitHub Pages

This folder is a complete static GitHub Pages site. It contains no backend or upload endpoint.

1. Create a new GitHub repository.
2. Upload the contents of this folder to the repository root, including `index.html`, `image-resizer.html`, and `.nojekyll`.
3. In the repository, open **Settings** > **Pages**.
4. Under **Build and deployment**, select **Deploy from a branch**.
5. Select the `main` branch and the `/(root)` folder, then save.
6. GitHub will display the HTTPS site address after deployment.

## Privacy design

- The image tool is static HTML, CSS, and JavaScript only.
- It has no `fetch`, XHR, WebSocket, form upload, analytics, or third-party resources.
- Its Content Security Policy sets `connect-src 'none'`, preventing browser network connections from the tool.
- Input images are processed in the browser and cleared from page memory after output download begins.

GitHub Pages serves the page through HTTPS. This removes the need to run a local server, but the page source is publicly visible unless the repository is private and your GitHub Pages plan supports private publishing.
