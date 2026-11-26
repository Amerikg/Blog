const postModules = import.meta.glob('../pages/posts/*.md', { eager: true });

export const allPosts = Object.values(postModules)
  .sort((a, b) => new Date(b.frontmatter.pubDate).getTime() - new Date(a.frontmatter.pubDate).getTime());

export const allYears = [...new Set(
  allPosts.map((post) => new Date(post.frontmatter.pubDate).getUTCFullYear())
)].sort((a, b) => b - a);

export const allTags = [...new Set(allPosts.flatMap((post) => post.frontmatter.tags ?? []))]
  .sort((a, b) => a.localeCompare(b, 'es'));
