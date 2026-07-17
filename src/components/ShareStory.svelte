<script>
	import { Link, Mail } from "@lucide/svelte";
	import { onMount } from "svelte";

	const storyTitle = "When Home Moves";
	const storyDescription =
		"From climate disaster and displacement to resilience: a journey across the Pacific.";
	const storyUrl = "http://www.elhamyali.com/pacific-climate-displacement/";
	let copied = $state(false);
	let resetCopyStatus;

	onMount(() => {
		return () => clearTimeout(resetCopyStatus);
	});

	const encodedUrl = $derived(encodeURIComponent(storyUrl));
	const encodedTitle = $derived(encodeURIComponent(storyTitle));
	const emailSubject = $derived(encodeURIComponent(`Read: ${storyTitle}`));
	const emailBody = $derived(
		encodeURIComponent(`${storyDescription}\n\n${storyUrl}`)
	);

	async function copyLink() {
		if (!storyUrl) return;

		try {
			await navigator.clipboard.writeText(storyUrl);
		} catch {
			const textArea = document.createElement("textarea");
			textArea.value = storyUrl;
			textArea.style.position = "fixed";
			textArea.style.opacity = "0";
			document.body.appendChild(textArea);
			textArea.select();
			document.execCommand("copy");
			textArea.remove();
		}

		copied = true;
		clearTimeout(resetCopyStatus);
		resetCopyStatus = setTimeout(() => (copied = false), 2000);
	}
</script>

<aside class="share-story" aria-labelledby="share-story-title">
	<h2 id="share-story-title">Share this story</h2>
	<div class="share-links">
		<a
			href={`https://www.linkedin.com/sharing/share-offsite/?url=${encodedUrl}`}
			target="_blank"
			rel="noreferrer"
			aria-label="Share this story on LinkedIn"
		>
			<svg class="share-icon" viewBox="0 0 24 24" aria-hidden="true">
				<path d="M5.4 8.8H2.1V19h3.3V8.8ZM3.75 3.7A1.92 1.92 0 1 0 3.75 7.55a1.92 1.92 0 0 0 0-3.85ZM19.9 13.15c0-3.08-1.64-4.51-3.83-4.51a3.77 3.77 0 0 0-3.4 1.87V8.8H9.36V19h3.31v-5.06c0-1.33.25-2.63 1.91-2.63 1.64 0 1.66 1.53 1.66 2.72V19h3.32l.34-5.85Z" />
			</svg>
			<span>LinkedIn</span>
		</a>
		<a
			href={`https://www.facebook.com/sharer/sharer.php?u=${encodedUrl}`}
			target="_blank"
			rel="noreferrer"
			aria-label="Share this story on Facebook"
		>
			<svg class="share-icon" viewBox="0 0 24 24" aria-hidden="true">
				<path d="M13.7 20v-7h2.35l.35-2.73h-2.7V8.53c0-.79.22-1.33 1.36-1.33h1.45V4.77c-.25-.03-1.11-.11-2.12-.11-2.09 0-3.52 1.28-3.52 3.62v1.99H8.5V13h2.37v7h2.83Z" />
			</svg>
			<span>Facebook</span>
		</a>
		<a
			href={`mailto:?subject=${emailSubject}&body=${emailBody}`}
			aria-label="Share this story by email"
		>
			<Mail class="share-icon" size={17} strokeWidth={1.8} aria-hidden="true" />
			<span>Email</span>
		</a>
		<button type="button" onclick={copyLink} aria-label="Copy story link">
			<Link
				class="share-icon copy-link-icon"
				size={15}
				strokeWidth={1.8}
				aria-hidden="true"
			/>
			<span>{copied ? "Copied!" : "Copy link"}</span>
		</button>
	</div>
	<p class="copy-status" aria-live="polite">
		{copied ? "Story link copied to clipboard." : ""}
	</p>
</aside>

<style>
	.share-story {
		width: min(100%, 980px);
		padding: clamp(42px, 6vw, 72px) clamp(24px, 8vw, 128px)
			clamp(64px, 8vw, 100px);
	}

	h2 {
		margin: 0 0 20px;
		font: 600 clamp(18px, 1.6vw, 22px) / 1.2 "Inter", sans-serif;
		letter-spacing: -0.02em;
	}

	.share-links {
		display: flex;
		flex-wrap: wrap;
		gap: 10px;
	}

	a,
	button {
		display: inline-flex;
		align-items: center;
		gap: 8px;
		min-height: 42px;
		padding: 0 15px;
		border: 1px solid #000;
		border-radius: 0;
		color: #000;
		background: #fff;
		font: 600 13px/1 "Inter", sans-serif;
		text-decoration: none;
		cursor: pointer;
		transition:
			background 150ms ease,
			color 150ms ease;
	}

	.share-icon,
	:global(.share-icon) {
		flex: 0 0 17px;
		width: 17px;
		height: 17px;
	}

	.share-icon {
		fill: currentColor;
	}

	:global(.copy-link-icon) {
		flex-basis: 15px;
		width: 15px;
		height: 15px;
	}

	a:hover,
	a:focus-visible,
	button:hover,
	button:focus-visible {
		color: #fff;
		background: #000;
		outline: none;
	}

	a:focus-visible,
	button:focus-visible {
		box-shadow: 0 0 0 3px #fff, 0 0 0 5px #135ae1;
	}

	.copy-status {
		min-height: 1.2em;
		margin: 10px 0 0;
		font: 500 12px/1.2 "Inter", sans-serif;
	}

	@media (max-width: 700px) {
		.share-story {
			padding-inline: 20px;
		}

		a,
		button {
			padding-inline: 13px;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		a,
		button {
			transition: none;
		}
	}
</style>
