// Abstract/BibTeX toggles, copy buttons, and teaser videos that load and play only while on screen.
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

// Reduced motion: posters only. Otherwise attach the source near the viewport and play while visible.
if (!matchMedia('(prefers-reduced-motion: reduce)').matches && 'IntersectionObserver' in window) {
  const io = new IntersectionObserver(entries => {
    for (const { target: v, isIntersecting } of entries) {
      if (isIntersecting) {
        if (!v.src) v.src = v.dataset.src;
        v.play().catch(() => {});
      } else if (!v.paused) {
        v.pause();
      }
    }
  }, { rootMargin: '200px 0px' });
  document.querySelectorAll('video[data-src]').forEach(v => io.observe(v));
}
