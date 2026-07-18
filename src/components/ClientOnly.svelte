<script>
	import { onMount } from "svelte";

	let {
		children,
		label = "Loading interactive visualization…",
		minHeight = "680px"
	} = $props();
	let mounted = $state(false);

	onMount(() => {
		mounted = true;
	});
</script>

{#if mounted}
	{@render children?.()}
{:else}
	<div class="loading-placeholder" style:--min-height={minHeight} role="status">
		{label}
	</div>
{/if}

<style>
	.loading-placeholder {
		display: grid;
		min-height: var(--min-height);
		place-items: center;
		padding: 24px;
		color: #666;
		background: #f7f7f7;
		font: 500 14px/1.4 "Inter", sans-serif;
		text-align: center;
	}
</style>
