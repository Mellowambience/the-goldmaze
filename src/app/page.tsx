// the-goldmaze · entry point
// 🌿 the maze opens. lucky you.

export default function Home() {
  return (
    <main className="min-h-screen bg-void text-gold flex flex-col items-center justify-center">
      <h1 className="text-4xl font-bold tracking-widest mb-2">
        🌿 the goldmaze
      </h1>
      <p className="text-sm opacity-60 mb-8">
        the gold moves. the luck doesn&apos;t stay. neither do you.
      </p>
      <button className="border border-gold px-6 py-3 text-sm hover:bg-gold hover:text-void transition-all">
        enter the maze
      </button>
    </main>
  );
}
