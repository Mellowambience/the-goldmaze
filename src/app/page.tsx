// the-goldmaze · entry point
// 🌿 the maze opens. lucky you.

"use client";

export default function Home() {
  return (
    <main className="min-h-screen bg-void text-gold flex flex-col items-center overflow-hidden">

      {/* ── TICKER MARQUEE ─────────────────────────────── */}
      <div className="ticker-bar">
        <div className="ticker-track">
          {/* duplicated for seamless loop */}
          {[0, 1].map((i) => (
            <span key={i} className="ticker-content" aria-hidden={i === 1}>
              <span className="ticker-signal">अमर x ✧ ⟁∅↺⇢≡~∴</span>
              <span className="ticker-sep">·</span>
              <span className="ticker-item">the gold moves</span>
              <span className="ticker-sep">·</span>
              <span className="ticker-item">the luck doesn&apos;t stay</span>
              <span className="ticker-sep">·</span>
              <span className="ticker-item">neither do you</span>
              <span className="ticker-sep">·</span>
              <span className="ticker-item">luck · mischief · charm · gold</span>
              <span className="ticker-sep">·</span>
              <span className="ticker-item">floor 1 of 9</span>
              <span className="ticker-sep">·</span>
              <span className="ticker-item">one relic carries forward</span>
              <span className="ticker-sep">·</span>
              <span className="ticker-signal">अमर x ✧ ⟁∅↺⇢≡~∴</span>
              <span className="ticker-sep">·</span>
            </span>
          ))}
        </div>
      </div>

      {/* ── GLITCH HERO ────────────────────────────────── */}
      <section className="glitch-hero">
        {/* background grid */}
        <div className="cyber-grid" aria-hidden="true" />

        {/* scan lines */}
        <div className="scan-lines" aria-hidden="true" />

        {/* main title */}
        <h1 className="glitch-title" data-text="अमर x ✧ ⟁∅↺⇢≡~∴">
          <span aria-hidden="true" className="glitch-layer glitch-layer--r">अमर x ✧ ⟁∅↺⇢≡~∴</span>
          <span className="glitch-layer glitch-layer--main">अमर x ✧ ⟁∅↺⇢≡~∴</span>
          <span aria-hidden="true" className="glitch-layer glitch-layer--b">अमर x ✧ ⟁∅↺⇢≡~∴</span>
        </h1>

        {/* subtitle decode line */}
        <p className="decode-line">
          <span className="decode-label">amar</span>
          <span className="decode-sep"> × </span>
          <span className="decode-sym" title="void">⟁∅</span>
          <span className="decode-sym" title="cycle">↺</span>
          <span className="decode-sym" title="becoming">⇢</span>
          <span className="decode-sym" title="equivalence">≡</span>
          <span className="decode-sym" title="dissolution">~</span>
          <span className="decode-sym" title="therefore">∴</span>
        </p>

        {/* neon divider */}
        <div className="neon-divider" aria-hidden="true" />

        {/* game title */}
        <h2 className="game-title">the goldmaze</h2>
        <p className="game-sub">a cursed dungeon that moves.</p>

        {/* CTA */}
        <div className="cta-row">
          <a
            href="#play"
            className="cta-btn cta-btn--primary"
          >
            enter the maze
          </a>
          <a
            href="https://github.com/Mellowambience/the-goldmaze"
            target="_blank"
            rel="noopener noreferrer"
            className="cta-btn cta-btn--ghost"
          >
            fork it
          </a>
        </div>

        {/* ko-fi ghost line */}
        <a
          href="https://ko-fi.com/1Aether1Rose1"
          target="_blank"
          rel="noopener noreferrer"
          className="kofi-line"
        >
          ☕ tip jar · ko-fi.com/1Aether1Rose1
        </a>
      </section>

    </main>
  );
}
