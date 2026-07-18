<script>
	let {
		title = "",
		description = "",
		author = "",
		siteName = title,
		url = "",
		image = "",
		imageAlt = "",
		imageType = "image/jpeg",
		imageWidth = 1200,
		imageHeight = 630,
		keywords = "",
		preloadFont = []
	} = $props();
</script>

<svelte:head>
	<!-- Standard page and search-engine metadata. -->
	<title>{title}</title>
	<meta name="description" content={description} />
	{#if author}<meta name="author" content={author} />{/if}
	{#if keywords}<meta name="news_keywords" content={keywords} />{/if}

	<!-- Open Graph powers link previews on Facebook, LinkedIn, and many messaging apps. -->
	<meta property="og:title" content={title} />
	<meta property="og:site_name" content={siteName} />
	<meta property="og:url" content={url} />
	<meta property="og:description" content={description} />
	<meta property="og:type" content="article" />
	<meta property="og:locale" content="en_US" />
	{#if image}
		<meta property="og:image" content={image} />
		<meta property="og:image:secure_url" content={image} />
		<meta property="og:image:type" content={imageType} />
		<meta property="og:image:width" content={imageWidth} />
		<meta property="og:image:height" content={imageHeight} />
		<meta property="og:image:alt" content={imageAlt || title} />
	{/if}

	<!-- X continues to use the legacy twitter:* metadata names for link cards. -->
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content={title} />
	<meta name="twitter:description" content={description} />
	{#if image}
		<meta name="twitter:image" content={image} />
		<meta name="twitter:image:alt" content={imageAlt || title} />
	{/if}

	<meta name="robots" content="max-image-preview:large" />

	{#if url}<link rel="canonical" href={url} />{/if}

	{#each preloadFont as href}
		<link rel="preload" {href} as="font" type="font/woff2" crossorigin />
	{/each}
</svelte:head>
