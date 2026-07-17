<figure class="runit-dome">
	<img
		src="/assets/dataviz/runit-dome/runit-dome-marshall-islands.png"
		alt="Aerial view of the circular concrete Runit Dome on Runit Island in the Marshall Islands, surrounded by vegetation and the Pacific Ocean"
	/>
	<figcaption>
		The Runit Dome (“The Tomb”) in the Marshall Islands contains over 120,000
		tonnes of radioactive waste from U.S. Cold War nuclear tests. Built in 1979
		over an unlined crater, rising seas and porous coral are now causing it to
		crack and leach into the Pacific. Credit: <a
			href="https://www.wagingpeace.org/runit-dome-cracks-marshall-islands-nuclear-waste/"
			target="_blank"
			rel="noreferrer">Nuclear Age Peace Foundation</a
		>.
	</figcaption>
</figure>

<style>
	.runit-dome {
		width: min(100%, 980px);
		margin: clamp(64px, 8vw, 104px) auto clamp(42px, 5vw, 68px);
		font-family: "Inter", sans-serif;
	}
	img {
		display: block;
		width: 100%;
		height: auto;
	}
	figcaption {
		margin: 10px 0 0;
		color: #4a4a4a;
		font:
			400 12px/1.45 "Inter",
			sans-serif;
	}
	figcaption a {
		color: #057dbc;
		text-underline-offset: 3px;
	}
	@media (max-width: 700px) {
		.runit-dome {
			width: calc(100% + 40px);
			margin-left: -20px;
		}
		figcaption {
			padding-inline: 20px;
		}
	}
</style>
