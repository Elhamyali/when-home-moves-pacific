<script>
	let { title, type = "Visualization" } = $props();
</script>

<div class="placeholder" role="img" aria-label={`${type} placeholder: ${title}`}>
	<span>{type} forthcoming</span>
	<strong>{title}</strong>
</div>

<style>
	.placeholder { display:grid; place-content:center; gap:14px; min-height:clamp(340px,55vw,680px); margin:clamp(70px,10vw,140px) 0; padding:30px; border:1px solid #bdbdbd; background:#f5f5f5; text-align:center; }
	span { font:700 10px/1 "Inter",sans-serif; letter-spacing:.17em; text-transform:uppercase; }
	strong { font:500 clamp(26px,3vw,42px)/1.15 "Playfair Display",serif; }
</style>
