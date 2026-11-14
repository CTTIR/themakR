const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const script = fs.readFileSync(process.argv[2], 'utf8');

for (const failure of ['none', 'missing', 'access', 'read', 'write', 'invalid']) {
  const events = {};
  const root = { attributes: {}, setAttribute(name, value) { this.attributes[name] = value; } };
  const buttons = ['light', 'dark', 'auto'].map(theme => ({
    textContent: theme,
    attributes: { 'data-bs-theme-value': theme },
    icon: { classList: { value: `icon-${theme}` } },
    classList: { toggle() {} },
    getAttribute(name) { return this.attributes[name]; },
    setAttribute(name, value) { this.attributes[name] = String(value); },
    querySelector() { return this.icon; },
    addEventListener(name, callback) { this[name] = callback; }
  }));
  const switcher = {
    attributes: {}, icon: { classList: { value: '' } }, focused: false,
    setAttribute(name, value) { this.attributes[name] = value; },
    querySelector() { return this.icon; }, focus() { this.focused = true; }
  };
  const media = { matches: true, addEventListener(name, callback) { this[name] = callback; } };
  let stored = failure === 'invalid' ? 'unknown-theme' : 'dark';
  const context = {
    document: { documentElement: root,
      querySelectorAll() { return buttons; }, querySelector() { return switcher; } },
    window: { matchMedia() { return media; }, addEventListener(name, callback) { events[name] = callback; } }
  };
  if (failure === 'access') {
    Object.defineProperty(context, 'localStorage', { get() { throw new Error('storage access denied'); } });
  } else if (failure !== 'missing') {
    context.localStorage = {
      getItem() { if (failure === 'read') throw new Error('storage read denied'); return stored; },
      setItem(key, value) { if (failure === 'write') throw new Error('storage write denied'); stored = value; }
    };
  }
  vm.runInNewContext(script, context, { filename: process.argv[2] });
  events.DOMContentLoaded();
  assert.equal(root.attributes['data-bs-theme'], 'dark', `${failure}: initial preference`);
  assert.equal(switcher.attributes['aria-label'], 'dark', `${failure}: initial label`);
  buttons[0].click();
  assert.equal(root.attributes['data-bs-theme'], 'light', `${failure}: explicit light`);
  assert.equal(switcher.attributes['aria-label'], 'light', `${failure}: updated label`);
  assert.equal(buttons[0].attributes['aria-pressed'], 'true');
  assert.equal(buttons[1].attributes['aria-pressed'], 'false');
  assert.equal(switcher.focused, true, `${failure}: focus restored`);
  media.matches = false; media.change();
  assert.equal(root.attributes['data-bs-theme'], 'light');
  buttons[2].click();
  media.matches = true; media.change();
  assert.equal(root.attributes['data-bs-theme'], 'dark', `${failure}: auto follows dark`);
  media.matches = false; media.change();
  assert.equal(root.attributes['data-bs-theme'], 'light', `${failure}: auto follows light`);
  assert.equal(switcher.attributes['aria-label'], 'auto');
  buttons[1].click(); media.change();
  assert.equal(root.attributes['data-bs-theme'], 'dark', `${failure}: explicit dark retained`);
}
console.log('Theme controls retain selection, labels, focus and auto mode without storage.');
