// warm-editorial theme — minimal client behavior:
//   1. Code block copy buttons.
//   2. TOC scroll-spy: highlight the heading currently in view.

(() => {
  // --- Copy buttons -------------------------------------------------------
  const copyButtons = document.querySelectorAll('.codeblock__copy');
  copyButtons.forEach((btn) => {
    btn.addEventListener('click', async () => {
      const codeEl = btn.closest('.codeblock')?.querySelector('.codeblock__body code, .codeblock__body pre');
      if (!codeEl) return;
      const text = codeEl.innerText;
      try {
        await navigator.clipboard.writeText(text);
      } catch {
        const ta = document.createElement('textarea');
        ta.value = text;
        document.body.appendChild(ta);
        ta.select();
        try { document.execCommand('copy'); } finally { document.body.removeChild(ta); }
      }
      const label = btn.querySelector('span');
      const original = label?.textContent ?? 'Copy';
      if (label) label.textContent = 'Copied';
      btn.style.color = 'var(--accent-teal)';
      setTimeout(() => {
        if (label) label.textContent = original;
        btn.style.color = '';
      }, 1200);
    });
  });

  // --- TOC scroll-spy -----------------------------------------------------
  const tocLinks = document.querySelectorAll('.toc a[href^="#"]');
  if (!tocLinks.length) return;

  const linkByHash = new Map();
  tocLinks.forEach((a) => {
    a.classList.add('toc__link');
    linkByHash.set(a.getAttribute('href'), a);
  });

  const headings = Array.from(linkByHash.keys())
    .map((href) => document.getElementById(decodeURIComponent(href.slice(1))))
    .filter(Boolean);

  if (!headings.length) return;

  let activeLink = null;
  const setActive = (link) => {
    if (activeLink === link) return;
    if (activeLink) activeLink.classList.remove('is-active');
    if (link) link.classList.add('is-active');
    activeLink = link;
  };

  const observer = new IntersectionObserver(
    (entries) => {
      const visible = entries
        .filter((e) => e.isIntersecting)
        .sort((a, b) => a.target.offsetTop - b.target.offsetTop);
      if (visible.length) {
        const first = visible[0];
        const link = linkByHash.get('#' + first.target.id);
        if (link) setActive(link);
      }
    },
    { rootMargin: '-72px 0px -65% 0px', threshold: [0, 1] }
  );

  headings.forEach((h) => observer.observe(h));
})();
