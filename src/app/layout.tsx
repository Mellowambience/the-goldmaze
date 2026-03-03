import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'the goldmaze',
  description: 'the gold moves. the luck doesn\'t stay. neither do you.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
