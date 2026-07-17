<script>
	import { base } from "$app/paths";
	import AffectedPopulationGrowingMap from "$components/dataviz/AffectedPopulationGrowingMap.svelte";
	import InternalDisplacementSmallMultiples from "$components/dataviz/InternalDisplacementSmallMultiples.svelte";
	import PacificEmissionsNestedSquares from "$components/dataviz/PacificEmissionsNestedSquares.svelte";
	import RemainingChapters from "$components/RemainingChapters.svelte";
	import ShareStory from "$components/ShareStory.svelte";
	import { onMount } from "svelte";
	let introduction;
	let player;
	let isMuted = $state(true);
	let isPlaying = $state(true);
	let currentTime = $state(13);
	let activeSection = $state("introduction");

	onMount(() => {
		const sections = [
			"introduction",
			"chapter-one",
			"chapter-two",
			"chapter-three",
			"chapter-four",
			"chapter-five",
			"methodology-credits"
		]
			.map((id) => document.getElementById(id))
			.filter(Boolean);
		const observer = new IntersectionObserver(
			(entries) => {
				for (const entry of entries) {
					if (entry.isIntersecting) activeSection = entry.target.id;
				}
			},
			{ rootMargin: "-35% 0px -55% 0px" }
		);
		sections.forEach((section) => observer.observe(section));

		function handlePlayerMessage(event) {
			if (event.origin !== "https://www.youtube.com") return;
			try {
				const message =
					typeof event.data === "string" ? JSON.parse(event.data) : event.data;
				const info = message?.info;
				if (!info) return;
				if (Number.isFinite(info.currentTime)) currentTime = info.currentTime;
				if (Number.isFinite(info.playerState))
					isPlaying = info.playerState === 1;
				if (typeof info.muted === "boolean") isMuted = info.muted;
			} catch {
				// Ignore unrelated window messages that are not JSON.
			}
		}

		window.addEventListener("message", handlePlayerMessage);
		player?.contentWindow?.postMessage(
			JSON.stringify({ event: "listening" }),
			"https://www.youtube.com"
		);

		return () => {
			observer.disconnect();
			window.removeEventListener("message", handlePlayerMessage);
		};
	});

	function sendPlayerCommand(func, args = []) {
		player?.contentWindow?.postMessage(
			JSON.stringify({ event: "command", func, args }),
			"https://www.youtube.com"
		);
	}

	function togglePlayback() {
		sendPlayerCommand(isPlaying ? "pauseVideo" : "playVideo");
		isPlaying = !isPlaying;
	}

	function seekBy(seconds) {
		currentTime = Math.max(0, currentTime + seconds);
		sendPlayerCommand("seekTo", [currentTime, true]);
	}

	function toggleMute() {
		sendPlayerCommand(isMuted ? "unMute" : "mute");
		isMuted = !isMuted;
	}

	function skipVideo() {
		sendPlayerCommand("pauseVideo");
		isPlaying = false;
		introduction?.scrollIntoView({ behavior: "smooth", block: "start" });
	}
</script>

<svelte:head>
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link
		rel="preconnect"
		href="https://fonts.gstatic.com"
		crossorigin="anonymous"
	/>
	<link
		href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:ital,wght@0,500;0,600;1,500&display=swap"
		rel="stylesheet"
	/>
</svelte:head>

<section
	class="film"
	aria-label="Film about the relocation of Vunidogoloa, Fiji"
>
	<div class="video-wrap">
		<iframe
			bind:this={player}
			src="https://www.youtube.com/embed/rU0IuuZR9Jg?start=13&autoplay=1&mute=1&controls=0&cc_load_policy=1&rel=0&playsinline=1&enablejsapi=1&loop=0&disablekb=1&fs=0&iv_load_policy=3&modestbranding=1"
			title="The relocation of Vunidogoloa, Fiji"
			allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
			allowfullscreen
		></iframe>
	</div>

	<div class="video-controls" aria-label="Video playback controls">
		<button
			type="button"
			onclick={togglePlayback}
			aria-label={isPlaying ? "Pause film" : "Play film"}
			title={isPlaying ? "Pause" : "Play"}
		>
			<span class="play-icon" aria-hidden="true">{isPlaying ? "Ⅱ" : "▶"}</span>
		</button>
		<button
			type="button"
			onclick={() => seekBy(-10)}
			aria-label="Rewind film 10 seconds"
			title="Rewind 10 seconds"
		>
			<span aria-hidden="true">↶</span><span class="seconds">10</span>
		</button>
		<button
			type="button"
			onclick={() => seekBy(10)}
			aria-label="Forward film 10 seconds"
			title="Forward 10 seconds"
		>
			<span class="seconds">10</span><span aria-hidden="true">↷</span>
		</button>
		<button
			type="button"
			onclick={toggleMute}
			aria-label={isMuted ? "Unmute film" : "Mute film"}
			title={isMuted ? "Unmute" : "Mute"}
		>
			<span aria-hidden="true">{isMuted ? "Muted" : "Sound"}</span>
		</button>
		<button
			class="skip-control"
			type="button"
			onclick={skipVideo}
			aria-label="Skip film and continue to the story"
		>
			Skip video <span aria-hidden="true">↓</span>
		</button>
	</div>
</section>

<div class="video-caption">
	<p>
		In 2014, Vunidogoloa became the first climate-relocated village in Fiji.
		They relocated to higher ground after rising sea levels made their original
		coastal location uninhabitable. The move improved housing and access to
		schools and nearby services. Credit: <a
			href="https://www.youtube.com/watch?v=rU0IuuZR9Jg"
			target="_blank"
			rel="noreferrer">GIZ Pacific</a
		>.
	</p>
</div>

<div class="story-shell">
	<nav class="story-nav" aria-label="Story sections">
		<a
			href="#introduction"
			class:active={activeSection === "introduction"}
			aria-current={activeSection === "introduction" ? "location" : undefined}
			><span>Home</span><strong>Where we are</strong></a
		>
		<a
			href="#chapter-one"
			class:active={activeSection === "chapter-one"}
			aria-current={activeSection === "chapter-one" ? "location" : undefined}
			><span>Chapter 1</span><strong>A Crisis Measured in Millions</strong></a
		>
		<a
			href="#chapter-two"
			class:active={activeSection === "chapter-two"}
			aria-current={activeSection === "chapter-two" ? "location" : undefined}
			><span>Chapter 2</span><strong>What Forces People to Leave?</strong></a
		>
		<a
			href="#chapter-three"
			class:active={activeSection === "chapter-three"}
			aria-current={activeSection === "chapter-three" ? "location" : undefined}
			><span>Chapter 3</span><strong>When Disasters Don’t End</strong></a
		>
		<a
			href="#chapter-four"
			class:active={activeSection === "chapter-four"}
			aria-current={activeSection === "chapter-four" ? "location" : undefined}
			><span>Chapter 4</span><strong>What Happens After Disasters?</strong></a
		>
		<a
			href="#chapter-five"
			class:active={activeSection === "chapter-five"}
			aria-current={activeSection === "chapter-five" ? "location" : undefined}
			><span>Chapter 5</span><strong>Fighting Back</strong></a
		>
		<a
			href="#methodology-credits"
			class:active={activeSection === "methodology-credits"}
			aria-current={activeSection === "methodology-credits"
				? "location"
				: undefined}
			><span>Endnotes</span><strong>Methodology & Credits</strong></a
		>
	</nav>

	<div class="story-sections">
		<section
			class="title-card"
			id="introduction"
			bind:this={introduction}
			aria-labelledby="story-title"
		>
			<h1 id="story-title"><em>When Home Moves</em></h1>
			<p class="subtitle">
				From climate disaster and displacement to resilience: a journey across
				the Pacific.
			</p>
			<p class="byline">
				By <a
					href="https://www.linkedin.com/in/elhamali"
					target="_blank"
					rel="noreferrer">Elham Ali</a
				>
			</p>

			<div class="prose">
				<p>Stay or leave? Many of us hope we never have to decide.</p>

				<p>
					When floods rise or seas breach the shore, families have minutes to
					decide what to save and what to leave behind. Some return to ruins;
					others find their homes erased.
				</p>

				<p>Across the Pacific, this is the new reality.</p>

				<p>
					Climate disasters are redrawing the map of the region, forcing
					communities inland, through repeat disasters, toward the agonizing
					choice: cling to ancestral soil or leave it behind.
				</p>

				<p>When home is no longer safe, where do you go?</p>
			</div>
		</section>
		<section class="chapter-one" aria-labelledby="chapter-one-title">
			<header class="chapter-heading" id="chapter-one">
				<p>Chapter 1</p>
				<h2 id="chapter-one-title"><em>A crisis measured in millions</em></h2>
			</header>

			<div class="chapter-copy">
				<p>
					The Pacific contributes <a
						href="https://www.amnestyusa.org/reports/navigating-injustice-climate-displacement-from-the-pacific-islands-of-tuvalu-and-kiribati-to-aotearoa-new-zealand/"
						target="_blank"
						rel="noreferrer">almost nothing</a
					> to the climate crisis, yet bears its harshest brunt.
				</p>
				<p>
					Low-lying nations like Kiribati and Tuvalu emit less than 0.003% and
					0.0002% of global greenhouse gases — fractions compared to New
					Zealand's emissions, which were approximately 777 and 3,498 times
					higher, respectively.
				</p>
			</div>

			<PacificEmissionsNestedSquares />

			<div class="chapter-copy">
				<p>
					As rising seas, extreme flooding, and rapid coastal erosion ravage the
					region, the human toll is staggering. Between 2008 and 2025, climate
					and geophysical disasters affected over 2.5 million people across the
					Pacific.
				</p>
				<p>
					Fiji endured the region’s highest cumulative impact, with 1,240,734
					people affected per the <a
						href="https://pacificdata.org/"
						target="_blank"
						rel="noreferrer">Pacific Data Hub</a
					>. In 2016, the historic Category 5 Cyclone Winston — alongside two
					other storms — impacted roughly 60% of the nation's population.
				</p>
			</div>

			<AffectedPopulationGrowingMap />

			<div class="chapter-copy">
				<p>
					The crisis is chronic, not a series of isolated disasters. Between
					2008 and 2025, the <a
						href="https://www.internal-displacement.org/"
						target="_blank"
						rel="noreferrer">Internal Displacement Monitoring Centre</a
					> (IDMC) recorded 247 events that triggered nearly one million internal
					displacements across the Pacific. Internal displacement refers to the forced
					movement of people within the country they live in.
				</p>
				<details class="definition-note">
					<summary>
						<span
							>A note about how different organizations define a disaster</span
						>
						<span class="definition-note-icon" aria-hidden="true"></span>
					</summary>
					<div class="definition-note-content">
						<p>
							There is a debate over how to define a “disaster.” The
							<a
								href="https://www.internal-displacement.org/database/displacement-data/"
								target="_blank"
								rel="noreferrer">Internal Displacement Monitoring Centre</a
							>
							(IDMC) does not automatically count people displaced by weather disasters
							as “climate-displaced,” as they view the link to climate change as scientifically
							complex. In contrast, the
							<a
								href="https://belonging.berkeley.edu/climatedisplacement/climate-displacement-and-resilience-database"
								target="_blank"
								rel="noreferrer">Othering &amp; Belonging Institute</a
							>
							(OBI) argues that these disasters are deeply tied to climate change
							and its role in worsening displacement. To better highlight this connection,
							this essay adopts the OBI’s approach of classifying weather-related
							disasters as climate-driven events.
						</p>
					</div>
				</details>
			</div>
			<InternalDisplacementSmallMultiples />

			<div class="chapter-copy chapter-close">
				<p>
					The threat is escalating: extreme weather puts at least 50,000 Pacific
					Islanders <a
						href="https://www.internal-displacement.org/project-spotlights/pacific-disasters/"
						target="_blank"
						rel="noreferrer">at risk</a
					>
					of losing their homes annually, with the vast majority remaining
					within national borders as
					<a
						href="https://www.internal-displacement.org/internal-displacement/"
						target="_blank"
						rel="noreferrer">internally displaced persons</a
					>
					(IDPs).
				</p>
			</div>
		</section>
		<RemainingChapters />
		<ShareStory />
	</div>
</div>

<div class="challenge-mark">
	<a
		href="https://pacificdatavizchallenge.org/"
		target="_blank"
		rel="noreferrer"
		aria-label="Visit the Pacific Dataviz Challenge 2026 website"
	>
		<img src={`${base}/images/logo.ico`} alt="Pacific Dataviz Challenge" />
	</a>
</div>

<footer class="site-footer">
	<p>
		Written &amp; developed by <a
			href="https://www.linkedin.com/in/elhamali"
			target="_blank"
			rel="noreferrer">Elham Y. Ali</a
		>
	</p>
	<p>
		Made with <span class="heart" role="img" aria-label="love">♥</span> for the
		<a
			href="https://pacificdatavizchallenge.org/"
			target="_blank"
			rel="noreferrer">Pacific Dataviz Challenge 2026</a
		>
	</p>
</footer>

<style>
	:global(html) {
		scroll-behavior: smooth;
	}
	:global(body) {
		background: #fff;
		color: #000;
	}
	:global(button),
	:global(a) {
		font-family: "Inter", sans-serif;
	}

	.film {
		position: relative;
		display: grid;
		place-items: center;
		min-height: 100svh;
		padding: 0;
		background: #000;
	}

	.video-wrap {
		position: absolute;
		inset: 0;
		background: #000;
		overflow: hidden;
	}

	.video-wrap iframe {
		display: block;
		width: 100%;
		height: 100%;
		border: 0;
		transform: scale(1.01);
		pointer-events: none;
	}

	.video-controls {
		position: absolute;
		z-index: 3;
		right: clamp(18px, 3vw, 44px);
		bottom: clamp(18px, 3vw, 34px);
		display: flex;
		align-items: stretch;
		padding: 4px;
		color: #fff;
		background: rgba(0, 0, 0, 0.76);
		border: 1px solid rgba(255, 255, 255, 0.55);
		backdrop-filter: blur(8px);
	}

	.video-controls button {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 2px;
		min-width: 42px;
		min-height: 42px;
		padding: 0 10px;
		border: 0;
		border-right: 1px solid rgba(255, 255, 255, 0.28);
		border-radius: 0;
		color: #fff;
		background: transparent;
		font:
			600 11px/1 "Inter",
			sans-serif;
		letter-spacing: 0.08em;
		text-transform: uppercase;
		cursor: pointer;
	}

	.video-controls button:last-child {
		border-right: 0;
	}
	.video-controls button:hover,
	.video-controls button:focus-visible {
		color: #000;
		background: #fff;
		outline: none;
	}
	.video-controls button:focus-visible {
		box-shadow: inset 0 0 0 2px #135ae1;
	}
	.video-controls .play-icon {
		font-size: 15px;
		line-height: 1;
	}
	.video-controls .seconds {
		font-size: 10px;
	}
	.video-controls .skip-control {
		padding-inline: 13px;
	}

	.video-caption {
		margin: 0 auto;
		padding: 12px clamp(20px, 4vw, 48px) 0;
	}

	.video-caption p {
		margin: 0;
		color: #4a4a4a;
		font:
			400 12px/1.45 "Inter",
			sans-serif;
	}

	.video-caption a {
		color: #057dbc;
	}

	.story-shell {
		display: grid;
		grid-template-columns: clamp(130px, 17vw, 230px) minmax(0, 1fr);
		max-width: 1600px;
		margin: 0 auto;
	}

	.story-nav {
		position: sticky;
		top: 24px;
		align-self: start;
		display: grid;
		gap: 0;
		margin-top: clamp(84px, 12vw, 180px);
		padding-left: clamp(18px, 3vw, 48px);
		z-index: 5;
	}

	.story-nav a {
		position: relative;
		display: grid;
		gap: 7px;
		padding: 12px 16px 22px 20px;
		border-left: 1px solid #bdbdbd;
		color: #767676;
		text-decoration: none;
	}

	.story-nav a::before {
		content: "";
		position: absolute;
		left: -4px;
		top: 15px;
		width: 7px;
		height: 7px;
		background: #fff;
		border: 1px solid #000;
		border-radius: 50%;
	}

	.story-nav a:hover,
	.story-nav a:focus-visible {
		color: #000;
		outline: none;
	}
	.story-nav a.active {
		color: #000;
	}
	.story-nav a.active::before {
		background: #000;
	}
	.story-nav span {
		font:
			700 10px/1 "Inter",
			sans-serif;
		letter-spacing: 0.14em;
		text-transform: uppercase;
	}
	.story-nav strong {
		max-width: 150px;
		font:
			500 12px/1.35 "Inter",
			sans-serif;
	}

	.story-sections {
		min-width: 0;
	}

	.prose {
		width: min(100%, 980px);
		margin: clamp(72px, 9vw, 118px) 0 0;
	}

	.prose p {
		max-width: 760px;
		margin: 0 0 2.1em;
		font:
			400 clamp(18px, 1.5vw, 21px)/1.62 "Inter",
			sans-serif;
		letter-spacing: -0.012em;
	}

	.title-card {
		display: flex;
		flex-direction: column;
		justify-content: center;
		padding: clamp(96px, 12vw, 192px) clamp(24px, 8vw, 128px)
			clamp(70px, 9vw, 120px);
	}

	.chapter-heading > p {
		margin: 0 0 28px;
		font:
			700 11px/1 "Inter",
			sans-serif;
		letter-spacing: 0.18em;
		text-transform: uppercase;
	}

	.title-card h1 {
		max-width: 1050px;
		margin: 0;
		font:
			500 clamp(58px, 8vw, 120px)/0.9 "Playfair Display",
			serif;
		letter-spacing: -0.055em;
	}

	.title-card h1 em {
		font-weight: 500;
	}
	.subtitle {
		max-width: 800px;
		margin: 42px 0 0;
		font:
			500 clamp(20px, 2.1vw, 30px)/1.3 "Inter",
			sans-serif;
		letter-spacing: -0.025em;
	}
	.byline {
		margin: 42px 0 0;
		font:
			700 13px/1 "Inter",
			sans-serif;
	}

	.chapter-one {
		padding: clamp(70px, 9vw, 120px) clamp(24px, 8vw, 128px);
	}
	.chapter-heading {
		width: min(100%, 980px);
		margin: 0 0 clamp(64px, 9vw, 110px);
	}
	.chapter-heading {
		scroll-margin-top: 24px;
	}
	.chapter-heading h2 {
		margin: 0;
		font:
			500 clamp(46px, 6.5vw, 92px)/0.95 "Playfair Display",
			serif;
		letter-spacing: -0.05em;
	}
	.chapter-heading h2 em {
		font-weight: 500;
	}
	.chapter-copy {
		width: min(100%, 980px);
		margin: 0;
	}
	.chapter-copy p {
		max-width: 760px;
		margin: 0 0 2em;
		font:
			400 clamp(18px, 1.5vw, 21px)/1.62 "Inter",
			sans-serif;
		letter-spacing: -0.012em;
	}
	.chapter-copy a {
		color: #057dbc;
		text-underline-offset: 3px;
	}
	.definition-note {
		max-width: 760px;
		margin: -0.25em 0 clamp(44px, 6vw, 72px);
		border-top: 1px solid #b8b8b8;
		border-bottom: 1px solid #b8b8b8;
	}
	.definition-note summary {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 24px;
		padding: 20px 0;
		font:
			700 clamp(15px, 1.25vw, 17px)/1.35 "Inter",
			sans-serif;
		letter-spacing: -0.01em;
		cursor: pointer;
		list-style: none;
	}
	.definition-note summary::-webkit-details-marker {
		display: none;
	}
	.definition-note summary:focus-visible {
		outline: 2px solid #135ae1;
		outline-offset: 5px;
	}
	.definition-note-icon {
		position: relative;
		flex: 0 0 22px;
		width: 22px;
		height: 22px;
	}
	.definition-note-icon::before,
	.definition-note-icon::after {
		position: absolute;
		top: 50%;
		left: 50%;
		width: 14px;
		height: 1.5px;
		content: "";
		background: currentColor;
		transform: translate(-50%, -50%);
		transition: transform 180ms ease;
	}
	.definition-note-icon::after {
		transform: translate(-50%, -50%) rotate(90deg);
	}
	.definition-note[open] .definition-note-icon::after {
		transform: translate(-50%, -50%) rotate(0deg);
	}
	.definition-note-content {
		padding: 0 0 24px;
	}
	.chapter-copy .definition-note-content p {
		margin: 0;
		font-size: clamp(15px, 1.15vw, 17px);
		line-height: 1.65;
	}

	.chapter-close {
		padding-bottom: clamp(50px, 8vw, 110px);
	}

	.site-footer {
		display: flex;
		justify-content: space-between;
		gap: 28px;
		padding: 30px clamp(20px, 5vw, 72px);
		color: #fff;
		background: #000;
		font:
			500 12px/1.5 "Inter",
			sans-serif;
		letter-spacing: 0.01em;
	}

	.site-footer p {
		margin: 0;
	}
	.site-footer a {
		color: inherit;
		text-decoration: underline;
		text-decoration-thickness: 1px;
		text-underline-offset: 4px;
	}
	.site-footer a:hover,
	.site-footer a:focus-visible {
		color: #9edfe3;
		text-decoration-thickness: 2px;
		outline: none;
	}

	.challenge-mark {
		display: grid;
		place-items: center;
		padding: clamp(16px, 2.5vw, 28px) 24px;
		background: #fff;
	}

	.challenge-mark a {
		display: block;
	}
	.challenge-mark a:focus-visible {
		outline: 2px solid #000;
		outline-offset: 8px;
	}
	.challenge-mark img {
		display: block;
		width: clamp(64px, 7vw, 96px);
		height: auto;
	}

	@media (max-width: 700px) {
		.film {
			min-height: 100svh;
		}
		.video-wrap {
			inset: 0;
		}
		.video-controls {
			right: 12px;
			bottom: 12px;
			left: 12px;
			justify-content: center;
		}
		.video-controls button {
			flex: 1 1 auto;
			min-width: 0;
			padding-inline: 7px;
		}
		.video-controls .skip-control {
			flex-grow: 1.35;
			padding-inline: 8px;
		}
		.video-caption {
			padding-inline: 16px;
		}
		.story-shell {
			display: block;
		}
		.story-nav {
			top: 0;
			display: flex;
			margin: 0;
			padding: 0 12px;
			background: rgba(255, 255, 255, 0.96);
			border-bottom: 1px solid #000;
			overflow-x: auto;
		}
		.story-nav a {
			flex: 0 0 auto;
			padding: 12px 18px;
			border-left: 0;
		}
		.story-nav a::before {
			display: none;
		}
		.story-nav strong {
			max-width: none;
		}
		.title-card,
		.chapter-one {
			padding-inline: 20px;
		}
		.title-card {
			padding-top: 72px;
		}
		.chapter-heading {
			scroll-margin-top: 88px;
		}
		.site-footer {
			display: grid;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		:global(html) {
			scroll-behavior: auto;
		}
	}
</style>
