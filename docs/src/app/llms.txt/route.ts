import { llms } from 'fumadocs-core/source';

import { canonicalizeLLMLinks, source } from '@/lib/source';

export const revalidate = false;

export async function GET() {
  return new Response(canonicalizeLLMLinks(await llms(source).index()));
}
