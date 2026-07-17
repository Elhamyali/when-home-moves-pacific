<script>
	import VizPlaceholder from "$components/VizPlaceholder.svelte";
	import ClimateDisplacementSankey from "$components/dataviz/ClimateDisplacementSankey.svelte";
	import CycloneHaroldBeforeAfter from "$components/dataviz/CycloneHaroldBeforeAfter.svelte";
	import RunitDomeFigure from "$components/dataviz/RunitDomeFigure.svelte";
	import DisplacementEventDotBars from "$components/dataviz/DisplacementEventDotBars.svelte";
	import PacificDisplacementBubbleMap from "$components/dataviz/PacificDisplacementBubbleMap.svelte";
	import GoodPracticesCardGrid from "$components/dataviz/GoodPracticesCardGrid.svelte";
	import EconomicLossAffectedPopulation from "$components/dataviz/EconomicLossAffectedPopulation.svelte";
	import TBIncidenceHistory from "$components/dataviz/TBIncidenceHistory.svelte";
	import DrinkingWaterSlopeChart from "$components/dataviz/DrinkingWaterSlopeChart.svelte";
	import UndernourishmentSlopeChart from "$components/dataviz/UndernourishmentSlopeChart.svelte";
</script>

<section class="chapter" aria-labelledby="chapter-two-title">
	<header id="chapter-two">
		<p>Chapter 2</p>
		<h2 id="chapter-two-title"><em>What Forces People to Leave?</em></h2>
	</header>
	<div class="copy">
		<p>
			The overwhelming driver of Pacific displacement is weather-related
			disasters rather than geophysical ones.
		</p>
	</div>
	<ClimateDisplacementSankey />
	<div class="copy">
		<p>
			In February 2016, Tropical Cyclone Winston was the most powerful cyclone
			ever recorded in the Southern Hemisphere, the first-ever Category 5 storm
			to strike Fiji, and the second strongest storm to make landfall anywhere
			on Earth, with sustained wind speeds exceeding 280 km/h.
		</p>
		<p>
			In a matter of days, it affected approximately 62% of Fiji's total
			population, according to a <a
				href="https://www.ucl.ac.uk/mathematical-physical-sciences/blogs/2026/feb/how-cyclone-winston-affected-people-and-what-we-learnt-it"
				target="_blank"
				rel="noreferrer">study</a
			> published by the UCL Faculty of Mathematical & Physical Sciences. It also
			triggered 62,000 internal displacement movements.
		</p>
	</div>
	<DisplacementEventDotBars />
	<div class="copy">
		<p>
			The physical damage to infrastructure was severe because traditional homes
			in rural and maritime areas are typically constructed from wood and
			corrugated iron. These materials proved incapable of withstanding Category
			5 forces. Compounding this vulnerability, the vast majority of rural
			residents lacked any form of property or crop insurance, leaving them
			entirely dependent on external aid.
		</p>
		<p>
			Just four years later, Tropical Cyclone Harold (2020) struck Fiji,
			Vanuatu, and Tonga, displacing over 10,000 people and complicating
			recovery efforts as communities struggled under the restrictions and
			economic strains of the COVID-19 pandemic.
		</p>
	</div>
	<CycloneHaroldBeforeAfter />
	<div class="copy">
		<p>
			Gradual climate degradation can merge with historical geostrategic
			exploitation to create existential threats just as terrifying as a
			Category 5 cyclone. In the Marshall Islands, slow-onset sea-level rise is
			structurally fused with the toxic legacy of U.S. nuclear weapons testing.
		</p>
		<p>
			Between 1946 and 1958, the United States <a
				href="https://www.latimes.com/projects/marshall-islands-nuclear-testing-sea-level-rise/"
				target="_blank"
				rel="noreferrer">detonated</a
			>
			67 nuclear weapons across Bikini and Enewetak Atolls. This included the infamous
			1954 “Castle Bravo” thermonuclear blast—a 15-megaton explosion 1,000 times more
			powerful than the bomb dropped on Hiroshima and Nagasaki combined. Bravo blanketed
			<a
				href="https://nukedivestmentscotland.org/wp-content/uploads/2020/08/nwce-report-final-1.pdf"
				target="_blank"
				rel="noreferrer">11,000 square kilometers</a
			> in lethal radioactive fallout, rendering entire islands uninhabitable and
			forcing the displacement of indigenous populations.
		</p>
	</div>
	<RunitDomeFigure />
	<div class="copy">
		<p>
			To contain the resulting radioactive debris, the U.S. military <a
				href="https://marshallislands.llnl.gov/ccc/Hamilton_LLNL-TR-648143_final.pdf"
				target="_blank"
				rel="noreferrer">bulldozed</a
			> 90,000 cubic meters of contaminated soil into an atomic blast crater on Runit
			Island, capping it with an 18-inch-thick concrete dome. To save time and expense,
			the bottom of the crater was never lined with concrete.
		</p>
		<p>
			Today, as sea levels rise, high tides wash directly through the unlined
			bottom of the crater, flushing radioactive Plutonium-239 and uranium
			straight into Enewetak's lagoon and the North Equatorial Current, with
			Marshall Islands plutonium <a
				href="https://climate.law.columbia.edu/sites/climate.law.columbia.edu/files/content/docs/Michael%20Gerrard/Gerrard-2015-06-Americas-Forgotten-Nuclear-Waste-Dump-in-the-Pacific.pdf"
				target="_blank"
				rel="noreferrer">detected</a
			> over 2,800 miles away. With severe typhoons threatening to breach the cracked
			concrete cap entirely, the Runit Dome stands as a ticking nuclear-climate time
			bomb—and an environmental injustice threatening to trigger a second wave of
			displacement.
		</p>
	</div>
</section>

<section class="chapter" aria-labelledby="chapter-three-title">
	<header id="chapter-three">
		<p>Chapter 3</p>
		<h2 id="chapter-three-title"><em>When Disaster Doesn't End</em></h2>
	</header>
	<div class="copy">
		<p>
			Displacement from climate disasters in the Pacific is not a single,
			isolated event; it is a chronic, recurring cycle that continually resets
			national development.
		</p>
		<p>
			Papua New Guinea leads the region with 81 distinct displacement events
			spanned across 15 separate years. The nation <a
				href="https://crisisresponse.iom.int/response/papua-new-guinea-crisis-response-plan-2024"
				target="_blank"
				rel="noreferrer">ranks</a
			>
			16th out of 191 countries globally for overall disaster risk on the
			<a
				href="https://drmkc.jrc.ec.europa.eu/inform-index"
				target="_blank"
				rel="noreferrer">INFORM Risk Index</a
			>, prone to multiple natural hazards, such as floods, droughts, and
			cyclones.
		</p>
	</div>
	<PacificDisplacementBubbleMap />
	<div class="copy">
		<p>
			Papua New Guinea lacks the systemic cushion to withstand these blows, <a
				href="https://www.cfe-dmha.org/LinkClick.aspx?fileticket=zIfiG4v6fM4%3D&portalid=0"
				target="_blank"
				rel="noreferrer">ranking</a
			> 10th globally for its severe lack of coping capacity. When disasters hit,
			both individual citizens and the national government lack the fiscal reserves
			required to build back resiliently. Between 2008 and 2022, the country was battered
			by 54 reported major disaster events, generating over 282,000 internal displacements.
		</p>
		<p>
			In the short period between 2016 and 2021, Pacific nations endured 13
			extreme weather events, three of which were the worst on record in
			regional history. Globally, the average gap between billion-dollar
			disasters has shrunk from 82 days in the 1980s to just 19 days in the
			2020s, as reported by Council Fire and the <a
				href="https://www.wri.org/insights/climate-adaptation-investment-case"
				target="_blank"
				rel="noreferrer">World Resources Institute (2025)</a
			>. This leaves communities with virtually no time to rebuild before the
			next strike.
		</p>
	</div>
</section>

<section class="chapter" aria-labelledby="chapter-four-title">
	<header id="chapter-four">
		<p>Chapter 4</p>
		<h2 id="chapter-four-title"><em>What Happens After People Leave?</em></h2>
	</header>
	<div class="copy">
		<p>
			Displacement and forced migration from climate disasters compound a
			cascade of socio-economic and health vulnerabilities.
		</p>
		<h3>Economic toll</h3>
		<p>
			Climate disasters inflict severe financial damage that cripples regional
			economies. Fiji reported around $374M in direct disaster economic loss for
			2016 — the year Cyclones Winston and Xena and a December tropical
			depression were the dominant disasters — in the UNISDR/Sendai Framework
			country-year data analyzed. The Fijian government <a
				href="https://belonging.berkeley.edu/climatedisplacement/case-studies/fiji#footnote17_bp44d9n"
				target="_blank"
				rel="noreferrer">estimated</a
			> that the impact of Cyclone Winston amounted to $900 million USD, more than
			20% of the country's GDP.
		</p>
	</div>
	<EconomicLossAffectedPopulation />
	<div class="copy">
		<p>
			During Tropical Cyclone Harold (2020), border closures had already
			decimated the tourism industry—the lifeblood of the Fijian economy—causing
			a 20% contraction in Fiji's GDP. Climate scientists call these “<a
				href="https://pmc.ncbi.nlm.nih.gov/articles/PMC10171413/"
				target="_blank"
				rel="noreferrer">cascading vulnerabilities</a
			>” — where a second disaster strikes a population whose defenses are
			already depleted.
		</p>
		<p>
			This precarity is mirrored across the region: Vanuatu's 2018 dual volcanic
			and earthquake crisis caused a sudden direct economic loss of $64,500,000,
			while Tonga's 2014 Cyclone Ian displaced 5,300 people and generated an
			instant loss of $18,560,063.
		</p>
	</div>
	<div class="copy">
		<p>
			Pacific Island nations are currently forced to expend up to <a
				href="https://www.youtube.com/watch?v=zrmQit14c-A"
				target="_blank"
				rel="noreferrer">30% of their entire national budgets</a
			> solely on climate adaptation, such as constructing seawalls, building embankments,
			and desalinating water. Low-lying island nations must borrow massive sums relative
			to their small economies to build vital roads, bridges, schools, and hospitals.
			When a disaster strikes, it dismantles that investment, trapping the nation
			in an inescapable debt loop.
		</p>
		<p>
			A global retreat in aid worsens this financial precarity. <a
				href="https://pacificaidmap.lowyinstitute.org/analysis/2025/key-findings/"
				target="_blank"
				rel="noreferrer">Findings</a
			> from the Lowy Institute Pacific Aid Map indicate that total official development
			finance to the Pacific has contracted by 16%, driven by deep funding cuts from
			traditional Western donors. The United Kingdom slashed global aid by 40%, while
			the United States implemented an estimated $60 billion cut to international
			development programs.
		</p>
		<h3>TB incidence</h3>
		<p>
			In the Pacific, 90% of the population lives within five kilometers of a
			coastline and more than a quarter resides within a single kilometer.
		</p>
		<p>
			Forced to abandon sinking outer islands, communities are pushed into
			centralized urban refuges. In South Tarawa (Kiribati), over <a
				href="https://nso.gov.ki/population/kiribati-census-atlas-2022/"
				target="_blank"
				rel="noreferrer">60,000 people</a
			>
			are crammed into a tiny 15-square-kilometer strip of land. Households average
			more than 7 people, and it is
			<a
				href="https://www.amnestyusa.org/wp-content/uploads/2025/10/Navigating-Injustice-Climate-Displacement-from-the-Pacific-Islands-of-Tuvalu-and-Kiribati-to-Aotearoa-New-Zealand.pdf"
				target="_blank"
				rel="noreferrer">common</a
			> for 15 to 40 people to live squashed together in tiny, two-room traditional
			dwellings. This extreme density facilitates the rapid spread of airborne infectious
			diseases, like Tuberculosis (TB).
		</p>
		<p>
			Pacific Data Hub findings reveal that the Marshall Islands has the highest
			TB rate in the region at 692 per 100,000 people in 2023—representing an
			alarming 723.8% long-run surge from its rate of 84 in 2000. Kiribati
			follows at 533 per 100,000 (+50.1% since 2000), and Tuvalu stands at 296
			per 100,000, both all massively exceeding the regional median of 48.0 per
			100,000.
		</p>
	</div>
	<TBIncidenceHistory />
	<div class="copy">
		<h3>Unsafe drinking water</h3>
		<p>
			Low-lying coral atolls have no rivers; they rely on thin underground
			freshwater lenses and rainwater harvesting. Rising sea levels and King
			tides cause severe coastal erosion and saltwater intrusion, poisoning
			fragile underground freshwater resources.
		</p>
		<p>
			Analysis from Pacific Data Hub on safe drinking water reveals that Papua
			New Guinea has the lowest safely managed water access in the region, with
			nearly half the population relying on unsafe water as of 2022.
		</p>
		<p>
			The Solomon Islands shows a devastating 11.23 percentage point long-run
			decline in safe water access (falling from 78.68% in 2000 to 67.45% in
			2021). In Kiribati, the 24.31% unsafe-water gap drives high waterborne
			disease outbreaks, directly causing Kiribati to suffer from the <a
				href="https://childfundalliance.org/"
				target="_blank"
				rel="noreferrer">highest infant mortality rates</a
			> in the Pacific.
		</p>
	</div>
	<DrinkingWaterSlopeChart />
	<div class="copy">
		<h3>Undernourishment</h3>
		<p>
			Saltwater intrusion and E. coli saturation poison agricultural soil,
			making it impossible to cultivate traditional crops like taro, banana, and
			breadfruit. Stripped of subsistence agriculture, displaced communities
			rely on expensive, imported, low-nutrient, and highly processed canned
			foods like canned spam. This transition has triggered an undernourishment
			epidemic.
		</p>
		<p>
			FAO estimates that approximately 28.7% of Papua New Guinea’s population
			had habitual dietary energy consumption below minimum requirements, as of
			2023.
		</p>
		<p>
			The nation exhibits severe exposure to intense heatwaves, exemplified by
			the massive 2015–2016 El Niño event. The resulting severe drought
			triggered a catastrophic famine impacting 1.3 million people, leaving
			480,000 citizens in a state of critical food shortage. The Solomon Islands
			witnessed its undernourishment rates nearly double, spiking from 11.2% to
			20.0%, as of 2023.
		</p>
	</div>
	<UndernourishmentSlopeChart />
	<div class="copy">
		<p>
			This dietary shift has triggered a metabolic crisis: 82% of Pacific adults
			are overweight or obese, 33% suffer from hypertension, and up to 40% live
			with high cholesterol. Crucially, resulting metabolic diseases like
			diabetes compromise immune systems, completing the tragic biological loop
			by drastically increasing susceptibility to active Tuberculosis.
		</p>
	</div>
</section>

<section class="chapter" aria-labelledby="chapter-five-title">
	<header id="chapter-five">
		<p>Chapter 5</p>
		<h2 id="chapter-five-title"><em>Fighting Back</em></h2>
	</header>
	<div class="copy">
		<p>
			Amidst relentless environmental shocks, Pacific Island communities are
			fighting for their land.
		</p>
		<p>
			They do so despite an international legal vacuum: the 1951 Refugee
			Convention <a
				href="https://www.elr.info/sites/default/files/article/2020/06/50.10540.pdf"
				target="_blank"
				rel="noreferrer">does not recognize</a
			> environmental or climate-induced displacement as valid grounds for refugee
			status, and strict, unceasing immigration frameworks, notably New Zealand's
			Acceptable Standard of Health (ASH) rules offer no sanctuary. Under ASH, resident
			visa applicants are rejected if they are deemed to place a high demand on health
			services, and immigration instructions dictate that medical waivers will not
			be granted to anyone who has or has had different forms of tuberculosis under
			certain conditions.
		</p>
		<p>
			The Internal Displacement Monitoring Centre (IDMC) tracks these local
			strategies. Across the region, communities are deploying localized,
			nature-based, and structural frameworks to secure their territory on their
			own terms.
		</p>
	</div>
	<GoodPracticesCardGrid />
	<div class="copy">
		<p>
			Fiji is a pioneer, establishing a comprehensive 130-page blueprint, the <a
				href="https://fijiclimatechangeportal.gov.fj/ppss/standard-operating-procedures-for-planned-relocation-in-the-republic-of-fiji/"
				target="_blank"
				rel="noreferrer"
				><em>Standard Operating Procedures (SOP) for Planned Relocations</em></a
			>, to govern how to move endangered populations. Relocation is treated as
			a strict measure of last resort; the government must exhaust all
			engineering adaptation options (dredging rivers, raising homes on stilts,
			building seawalls) before approving a move.
		</p>
		<p>
			Mixed results of early relocations informed the SOP's foundational rules.
			In 2014, Vunidogoloa became the first climate-relocated village in Fiji.
			About 140 residents moved two kilometers inland. While safe, they faced
			severe “loss of adjacency” to their ancestral burial grounds, and had to
			travel much further to access their traditional fishing reefs. Because
			only male leaders were consulted, the newly built homes completely lacked
			kitchens.
		</p>
		<p>
			Tukuraki was devastated by a 2012 landslide that buried 50% of the village
			and killed a family of four. While survivors lived in makeshift tents,
			their temporary infrastructure was flattened again by Cyclone Evan (2013)
			and Cyclone Winston (2016), forcing them to seek shelter in caves before
			finally relocating to a resilient site in 2017. However, the absence of
			formal financial contracts sparked social friction, as the modern
			amenities provided to Tukuraki exceeded the living standards of the host
			community.
		</p>
		<p>
			To rectify these blunders, Fiji's updated SOP mandates an unprecedented
			90% consent threshold across every single demographic group — including
			men, women, the elderly, youth, LGBTQ+ residents, and disabled residents.
			At present, close to 50 Fijian villages are earmarked for potential
			relocation, with six already moved.
		</p>
		<p>
			Moving entire communities is an immense financial challenge. In the
			pending relocation of Nabavatu village, 85 families (over 460 people) have
			been forced to live in temporary disaster tents for over five years. The
			cost of physically moving Nabavatu alone exceeds $2.5 million USD.
		</p>
		<p>
			To address this, Fiji launched the world's first legislated national trust
			fund dedicated to planned relocation: the <a
				href="https://climate-laws.org/document/climate-relocation-of-communities-trust-fund-act-2019-an-act-to-establish-a-trust-fund-for-the-planned-relocation-of-communities-in-fiji-that-are-adversely-affected-by-climate-change-act-no-21-of-2019_24e5"
				target="_blank"
				rel="noreferrer"
				>Climate Relocation of Communities (CROC) Trust Fund Act</a
			> 2019, funded locally through a 3% contribution from Fiji's Environmental and
			Climate Adaptation Levy (ECAL) on the tourism sector and luxury goods, and supplemented
			by bilateral partners like New Zealand (which provided an initial NZ$2 million).
		</p>
		<p>
			At a regional scale, this ingenuity has scaled into <a
				href="https://www.dfat.gov.au/geo/pacific/development-assistance/climate-change-and-resilience"
				target="_blank"
				rel="noreferrer">The Pacific Resilience Facility</a
			> (PRF)—a Pacific-owned, grant-based regional fund designed to bypass the rigid,
			slow, and bureaucratic administrative hurdles of massive global financial institutions.
		</p>
		<p>
			<a
				href="https://www.wri.org/research/climate-adaptation-investment-case"
				target="_blank"
				rel="noreferrer">Research</a
			> from the World Resources Institute (WRI) and Council Fire proves that funding
			these Pacific-led frameworks is a remarkably high-yield investment. WRI's research
			highlights that every $1 invested in climate adaptation yields $10.50 in net
			economic benefits over a 10-year horizon.
		</p>
		<p>
			Proactive disaster risk management projects also yield an average 36%
			return on investment. This triple-dividend model works because the
			commercial, social, and environmental gains unlocked on a daily basis —
			such as local job creation, agricultural productivity, and ecosystem
			health—far exceed the value of avoided losses alone. The investment pays
			off continuously, even if a disaster never strikes.
		</p>
	</div>
	<footer class="notes" id="methodology-credits">
		<section>
			<h3><em>Methodology & Data</em></h3>
			<p>
				I built this story with D3.js and Svelte. The full open-source codebase
				will be available on GitHub.
			</p>
			<p>
				I used R (v4.6.1) to analyze historical datasets on climate disasters,
				disaster-related internal displacement, population impacts, public
				health, and economic losses from the Pacific Data Hub and the Internal
				Displacement Monitoring Centre (IDMC). All datasets, data-processing
				scripts, and analysis code will be available on GitHub.
			</p>
		</section>
		<section>
			<h3><em>Acknowledgement</em></h3>
			<p>
				I'm grateful to Yan Holtz for his excellent <a
					href="https://www.react-graph-gallery.com/react-d3-dataviz-course"
					target="_blank"
					rel="noreferrer">React + D3.js course</a
				>, which inspired me to learn D3 and ultimately participate in the 2026
				Pacific Data Viz Challenge.
			</p>
			<p>
				Special thanks to The Pudding for their open-source <a
					href="https://github.com/the-pudding/svelte-starter"
					target="_blank"
					rel="noreferrer">Svelte starter template</a
				>
				and the Office for National Statistics (ONS) for their
				<a
					href="https://github.com/ONSvisual/svelte-components/"
					target="_blank"
					rel="noreferrer">Svelte components library</a
				>, which helped bring this interactive story to life.
			</p>
		</section>
	</footer>
</section>

<style>
	.chapter {
		position: relative;
		padding: clamp(64px, 8vw, 112px) clamp(24px, 8vw, 128px);
	}
	.chapter:last-of-type {
		padding-bottom: clamp(28px, 4vw, 54px);
	}
	.chapter::before {
		content: "";
		display: block;
		width: 54px;
		height: 1px;
		margin: 0 0 clamp(42px, 5vw, 68px);
		background: #000;
	}
	header,
	.copy,
	.notes {
		width: min(100%, 980px);
		margin-inline: 0;
	}
	header {
		margin-bottom: clamp(48px, 6vw, 78px);
		scroll-margin-top: 24px;
	}
	header > p {
		margin: 0 0 28px;
		font:
			700 11px/1 "Inter",
			sans-serif;
		letter-spacing: 0.18em;
		text-transform: uppercase;
	}
	h2 {
		margin: 0;
		font:
			500 clamp(46px, 6.5vw, 92px)/0.95 "Playfair Display",
			serif;
		letter-spacing: -0.05em;
	}
	h2 em {
		font-weight: 500;
	}
	.copy p {
		max-width: 760px;
		margin: 0 0 2em;
		font:
			400 clamp(18px, 1.5vw, 21px)/1.62 "Inter",
			sans-serif;
		letter-spacing: -0.012em;
	}
	.copy h3,
	.notes h3 {
		max-width: 760px;
		margin: clamp(70px, 10vw, 130px) 0 28px;
		font:
			600 clamp(30px, 4vw, 54px)/1.1 "Playfair Display",
			serif;
	}
	a {
		color: #057dbc;
		text-underline-offset: 3px;
	}
	.notes {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: clamp(40px, 7vw, 100px);
		margin-top: clamp(100px, 14vw, 190px);
		padding-top: 50px;
		border-top: 1px solid #000;
	}
	.notes h3 {
		margin-top: 0;
	}
	.notes p {
		font:
			400 16px/1.6 "Inter",
			sans-serif;
	}

	@media (max-width: 700px) {
		.chapter {
			padding-inline: 20px;
		}
		.chapter > header {
			scroll-margin-top: 88px;
		}
		.notes {
			grid-template-columns: 1fr;
		}
	}
</style>
