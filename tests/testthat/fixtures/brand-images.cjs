const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync(process.argv[2], 'utf8');

function exercise(darkAvailable) {
  let theme = 'light';
  let observer;
  const owner = {getAttribute: () => theme};
  const navbar = {
    src: 'https://cttir.github.io/example/reference/figures/logo.svg',
    closest: () => owner,
    getAttribute: () => '../reference/figures/logo-dark.svg'
  };
  const heading = {src: 'https://cttir.github.io/example/logo.svg', closest: () => owner};
  const picture = {media: '(prefers-color-scheme: dark)', closest: () => owner};
  const document = {
    readyState: 'complete',
    baseURI: 'https://cttir.github.io/example/articles/guide.html',
    documentElement: {},
    querySelectorAll(selector) {
      if (selector.startsWith('picture.')) return [picture];
      if (selector.startsWith('img.themakr')) return [navbar];
      if (selector === '.page-header > img.logo') return [heading];
      return [];
    }
  };
  class Image {
    set src(value) { darkAvailable ? this.onload() : this.onerror(); }
  }
  class MutationObserver {
    constructor(callback) { observer = callback; }
    observe() {}
  }
  vm.runInNewContext(source, {document, Image, MutationObserver, URL,
    window: {location: {origin: 'https://cttir.github.io'},
      matchMedia: () => ({matches: false, addEventListener() {}})}});
  assert.equal(navbar.src, 'https://cttir.github.io/example/reference/figures/logo.svg');
  assert.equal(heading.src, 'https://cttir.github.io/example/logo.svg');
  theme = 'dark'; observer();
  assert.equal(picture.media, 'all');
  if (darkAvailable) {
    assert.equal(navbar.src, 'https://cttir.github.io/example/reference/figures/logo-dark.svg');
    assert.equal(heading.src, navbar.src);
  } else {
    assert.equal(navbar.src, 'https://cttir.github.io/example/reference/figures/logo.svg');
    assert.equal(heading.src, 'https://cttir.github.io/example/logo.svg');
  }
  theme = 'light'; observer();
  assert.equal(picture.media, 'not all');
  assert.equal(navbar.src, 'https://cttir.github.io/example/reference/figures/logo.svg');
  assert.equal(heading.src, 'https://cttir.github.io/example/logo.svg');
}
exercise(true);
exercise(false);
console.log('Named logo colour modes and missing-dark fallback passed.');
