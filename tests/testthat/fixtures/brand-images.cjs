const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync(process.argv[2], 'utf8');

const site = 'https://cttir.github.io/example/';

// Run the script against a page and return what it did to the images.
function load(page, darkAvailable) {
  let theme = 'light';
  let observer;
  const probes = [];
  const owner = {getAttribute: () => theme};
  const navbar = {
    src: new URL(page.lightSrc, page.base).href,
    closest: () => owner,
    getAttribute: name => name === 'src' ? page.lightSrc : page.darkSrc
  };
  const heading = {src: site + 'logo.svg', closest: () => owner};
  const picture = {media: '(prefers-color-scheme: dark)', closest: () => owner};
  const document = {
    readyState: 'complete',
    baseURI: page.base,
    documentElement: {},
    querySelectorAll(selector) {
      if (selector.startsWith('picture.')) return [picture];
      if (selector.startsWith('img.themakr')) return [navbar];
      if (selector === '.page-header > img.logo') return [heading];
      return [];
    }
  };
  class Image {
    set src(value) {
      probes.push(value);
      darkAvailable ? this.onload() : this.onerror();
    }
  }
  class MutationObserver {
    constructor(callback) { observer = callback; }
    observe() {}
  }
  vm.runInNewContext(source, {document, Image, MutationObserver, URL,
    window: {location: {origin: 'https://cttir.github.io'},
      matchMedia: () => ({matches: false, addEventListener() {}})}});
  return {navbar, heading, picture, probes,
    setTheme(value) { theme = value; observer(); }};
}

function exercise(darkAvailable) {
  const light = site + 'reference/figures/logo.svg';
  const dark = site + 'reference/figures/logo-dark.svg';
  const page = load({
    base: site + 'articles/guide.html',
    lightSrc: '../reference/figures/logo.svg',
    darkSrc: '../reference/figures/logo-dark.svg'
  }, darkAvailable);
  assert.deepEqual(page.probes, [dark]);
  assert.equal(page.navbar.src, light);
  assert.equal(page.heading.src, site + 'logo.svg');
  page.setTheme('dark');
  assert.equal(page.picture.media, 'all');
  if (darkAvailable) {
    assert.equal(page.navbar.src, dark);
    assert.equal(page.heading.src, page.navbar.src);
  } else {
    assert.equal(page.navbar.src, light);
    assert.equal(page.heading.src, site + 'logo.svg');
  }
  page.setTheme('light');
  assert.equal(page.picture.media, 'not all');
  assert.equal(page.navbar.src, light);
  assert.equal(page.heading.src, site + 'logo.svg');
}
exercise(true);
exercise(false);
console.log('Named logo colour modes and missing-dark fallback passed.');

// pkgdown writes absolute src values into 404.html but leaves the dark alias
// relative to the site root; the page itself is served at any depth.
for (const base of [site + 'missing.html', site + 'no/such/page.html']) {
  const page = load({
    base,
    lightSrc: site + 'logo.svg',
    darkSrc: 'reference/figures/logo-dark.svg'
  }, true);
  assert.deepEqual(page.probes, [site + 'reference/figures/logo-dark.svg']);
  page.setTheme('dark');
  assert.equal(page.navbar.src, site + 'reference/figures/logo-dark.svg');
  page.setTheme('light');
  assert.equal(page.navbar.src, site + 'logo.svg');
}
console.log('Dark logo resolves from the not-found page at any depth.');
