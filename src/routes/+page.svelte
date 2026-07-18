<script>
	import PageMetadata from "$components/PageMetadata.svelte";
	import Index from "$components/Index.svelte";
	const title = "When Home Moves";
	const siteName = "When Home Moves";
	const author = "Elham Ali";
	const description =
		"From climate disaster and displacement to resilience: a journey across the Pacific.";
	const url = "https://www.elhamyali.com/when-home-moves-pacific/";
	const image = `${url}assets/dataviz/good-practices/fiji-planned-relocation-guidelines.jpg`;
	const imageAlt =
		"A woman and child walking through the Wailea settlement in Fiji.";
	const imageWidth = 1920;
	const imageHeight = 1080;
	const keywords = "Pacific, climate change, displacement, Fiji, Vunidogoloa";
	const preloadFont = [];
</script>

<PageMetadata
	{title}
	{siteName}
	{author}
	{description}
	{url}
	{image}
	{imageAlt}
	{imageWidth}
	{imageHeight}
	{preloadFont}
	{keywords}
/>
<Index />
