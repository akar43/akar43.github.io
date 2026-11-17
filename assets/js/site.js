// Abstract/BibTeX toggles, copy buttons, and paused thumbnails for reduced-motion users.
document.addEventListener('click', e => {
  const toggle = e.target.closest('[aria-controls]');
  if (toggle) {
    const panel = document.getElementById(toggle.getAttribute('aria-controls'));
    const open = toggle.getAttribute('aria-expanded') !== 'true';
    toggle.setAttribute('aria-expanded', open);
    panel.hidden = !open;
    return;
  }
  const btn = e.target.closest('.copy');
  if (!btn) return;
  const text = btn.parentElement.querySelector('pre').textContent;
  navigator.clipboard.writeText(text).then(() => {
    btn.textContent = 'Copied';
    setTimeout(() => (btn.textContent = 'Copy'), 1500);
  });
});

if (matchMedia('(prefers-reduced-motion: reduce)').matches) {
  document.querySelectorAll('video[autoplay]').forEach(v => { v.removeAttribute('autoplay'); v.pause(); });
}
