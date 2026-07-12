<script>
	import { onMount } from "svelte";
	let story;
	let progress = $state(0);
	onMount(() => {
		const update = () => {
			const distance = document.documentElement.scrollHeight - window.innerHeight;
			progress = distance > 0 ? Math.min(1, window.scrollY / distance) : 0;
		};
		update();
		window.addEventListener("scroll", update, { passive: true });
		return () => window.removeEventListener("scroll", update);
	});
	function skipVideo() { story?.scrollIntoView({ behavior: "smooth", block: "start" }); }
</script>

<svelte:head>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;1,500&display=swap" rel="stylesheet" />
</svelte:head>

<div class="reading-progress" aria-hidden="true" style={`transform: scaleX(${progress})`}></div>

<section class="film" aria-labelledby="film-title">
	<div class="film-media" aria-hidden="true">
		<iframe src="https://www.youtube.com/embed/rU0IuuZR9Jg?start=13&autoplay=1&mute=1&controls=0&loop=1&playlist=rU0IuuZR9Jg&modestbranding=1&playsinline=1" title="Vunidogoloa village relocation" allow="autoplay; encrypted-media; picture-in-picture"></iframe>
	</div>
	<div class="film-shade"></div>
	<header class="masthead">
		<a href="#story" class="wordmark" aria-label="Pacific climate displacement, go to story"><span>THE</span> PACIFIC</a>
		<span class="series">CLIMATE DISPLACEMENT</span>
	</header>
	<div class="film-copy">
		<p class="eyebrow">Vunidogoloa, Fiji</p>
		<h1 id="film-title">When home<br />has to move</h1>
		<p class="dek">A journey through climate displacement in the Pacific.</p>
	</div>
	<button class="skip" type="button" onclick={skipVideo}>Skip film <span aria-hidden="true">↓</span></button>
</section>

<article class="story" id="story" bind:this={story}>
	<div class="story-grid">
		<aside class="chapter" aria-hidden="true"><span>01</span><div></div><p>HOME</p></aside>
		<div class="prose">
			<p class="lead">Home is far more than a physical house. It is the papaya tree planted by a grandparent, the cemetery where generations rest, the shoreline where children learn to fish, and the neighbors who know the histories behind every doorway.</p>
			<div class="rule" aria-hidden="true"><span></span></div>
			<p>Today, climate change dictates where people can live. Pacific Island communities flee inland to escape storm surges, wrestle from the wreckage of repeated extreme weather events, and confront the agonizing choice to stay or abandon ancestral soil.</p>
			<p class="pivot">Some move once.<br /><em>Others move again and again.</em></p>
			<p>This story traces that journey — from climate disasters to displacement, through the cascading health and economic crises that follow, and finally to the Pacific innovators leading locally-led climate adaptation solutions.</p>
		</div>
	</div>
	<footer class="credit">
		<p>The Fijian village of Vunidogoloa relocated to higher ground after rising sea levels made its original coastal location uninhabitable.</p>
		<a href="https://www.youtube.com/watch?v=rU0IuuZR9Jg" target="_blank" rel="noreferrer">Film: GIZ Pacific ↗</a>
	</footer>
</article>

<style>
	:global(html) { scroll-behavior: smooth; }
	:global(body) { background: #fff; color: #000; }
	:global(button), :global(a) { font-family: "Inter", sans-serif; }
	.reading-progress { position: fixed; inset: 0 0 auto; z-index: 100; height: 3px; background: #fff; transform-origin: left center; mix-blend-mode: difference; pointer-events: none; }
	.film { position: relative; min-height: 100svh; overflow: hidden; color: #fff; background: #10100e; }
	.film-media { position: absolute; inset: -9%; }
	.film-media iframe { width: 100%; height: 100%; border: 0; pointer-events: none; transform: scale(1.22); }
	.film-shade { position: absolute; inset: 0; background: linear-gradient(90deg, rgba(0,0,0,.73), rgba(0,0,0,.15) 68%), linear-gradient(0deg, rgba(0,0,0,.55), transparent 45%); }
	.masthead { position: relative; z-index: 2; display: flex; justify-content: space-between; align-items: center; padding: 24px 32px; border-bottom: 1px solid rgba(255,255,255,.55); }
	.wordmark { color: inherit; text-decoration: none; font: 600 25px/1 "Playfair Display", serif; letter-spacing: -.04em; }
	.wordmark span { font: 600 8px/1 "Inter", sans-serif; letter-spacing: .08em; vertical-align: top; margin-right: 3px; }
	.series, .eyebrow { font: 600 11px/1.2 "Inter", sans-serif; letter-spacing: .19em; text-transform: uppercase; }
	.film-copy { position: absolute; z-index: 2; left: clamp(24px, 7vw, 112px); bottom: clamp(96px, 16vh, 180px); max-width: 920px; }
	.eyebrow { margin: 0 0 24px; }
	h1 { margin: 0; font: 500 clamp(64px, 10.5vw, 158px)/.82 "Playfair Display", serif; letter-spacing: -.055em; text-wrap: balance; }
	.dek { max-width: 510px; margin: 30px 0 0 8px; font: 400 clamp(16px, 1.5vw, 20px)/1.45 "Inter", sans-serif; }
	.skip { position: absolute; z-index: 3; right: 32px; bottom: 28px; padding: 12px 0; border: 0; border-bottom: 1px solid currentColor; color: #fff; background: transparent; font: 600 11px/1 "Inter", sans-serif; letter-spacing: .15em; text-transform: uppercase; cursor: pointer; border-radius: 0; }
	.skip span { margin-left: 16px; }
	.story { padding: clamp(72px, 12vw, 180px) clamp(24px, 7vw, 112px) 42px; }
	.story-grid { display: grid; grid-template-columns: minmax(90px, 1fr) minmax(0, 760px) minmax(90px, 1fr); }
	.prose { grid-column: 2; }
	.prose p { margin: 0 0 2.1em; font: 400 clamp(18px, 1.7vw, 23px)/1.62 "Inter", sans-serif; letter-spacing: -.012em; }
	.prose .lead { font: 500 clamp(34px, 4.2vw, 63px)/1.12 "Playfair Display", serif; letter-spacing: -.035em; }
	.rule { display: flex; align-items: center; gap: 16px; margin: 64px 0; }
	.rule::before { content: ""; width: 8px; height: 8px; background: #000; transform: rotate(45deg); }
	.rule span { height: 1px; flex: 1; background: #e0e0e0; }
	.prose .pivot { margin: 2.2em -18vw 2.2em -8vw; font: 500 clamp(44px, 7vw, 106px)/.98 "Playfair Display", serif; letter-spacing: -.045em; }
	.pivot em { font-weight: 500; }
	.chapter { grid-column: 1; grid-row: 1; display: flex; flex-direction: column; align-items: flex-start; padding-top: 12px; font: 600 10px/1 "Inter", sans-serif; letter-spacing: .18em; }
	.chapter div { width: 1px; height: 92px; margin: 16px 0; background: #000; }
	.chapter p { margin: 0; writing-mode: vertical-rl; }
	.credit { display: flex; justify-content: space-between; gap: 32px; max-width: 1200px; margin: 120px auto 0; padding-top: 20px; border-top: 1px solid #000; font: 500 11px/1.5 "Inter", sans-serif; letter-spacing: .02em; }
	.credit p { max-width: 630px; margin: 0; }
	.credit a { color: #057dbc; white-space: nowrap; }
	@media (max-width: 700px) {
		.masthead { padding: 20px; } .series { display: none; } .film-media { inset: -4% -75%; }
		.film-copy { left: 20px; right: 20px; } .dek { margin-left: 2px; } .skip { right: 20px; }
		.story { padding-inline: 20px; } .story-grid { grid-template-columns: 24px minmax(0, 1fr); gap: 18px; }
		.prose { grid-column: 2; } .chapter { grid-column: 1; } .prose .pivot { margin-inline: -38px -4px; }
		.credit { display: block; margin-top: 72px; } .credit a { display: inline-block; margin-top: 18px; }
	}
	@media (prefers-reduced-motion: reduce) { :global(html) { scroll-behavior: auto; } .film-media iframe { display: none; } }
</style>
