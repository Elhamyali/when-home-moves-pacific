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
			Weather disasters, not geophysical ones, drive displacement movements in
			the Pacific.
		</p>
		<p>
			The chart below traces those events from hazard to disaster to
			displacement. Each ribbon represents recorded movements of displacement
			following a disaster. Wider ribbons indicate larger numbers of
			displacements.
		</p>
	</div>
	<ClimateDisplacementSankey />
	<div class="copy">
		<p>
			As the strongest tropical cyclone ever recorded in the Southern
			Hemisphere, the first-ever Category 5 storm Winston struck Fiji in 2016.
			It <a
				href="https://www.ucl.ac.uk/mathematical-physical-sciences/blogs/2026/feb/how-cyclone-winston-affected-people-and-what-we-learnt-it"
				target="_blank"
				rel="noreferrer">affected</a
			> approximately 62% of Fiji's total population, destroyed tens of thousands
			of homes, triggering 62,000 internal displacement movements, and cost the nation
			one-third of its annual economic output.
		</p>
		<p>
			As the first Category 5 tropical cyclone ever recorded in the Southern
			Hemisphere and the second strongest to make landfall anywhere on Earth,
			Winston <a
				href="https://www.ucl.ac.uk/mathematical-physical-sciences/blogs/2026/feb/how-cyclone-winston-affected-people-and-what-we-learnt-it"
				target="_blank"
				rel="noreferrer">affected</a
			> 62% of Fiji’s population. It led to 62,000 internal displacement movements
			and cost the nation one-third of its annual GDP.
		</p>
	</div>
	<DisplacementEventDotBars />
	<div class="copy">
		<p>
			Traditional homes in rural and maritime areas, built primarily from wood
			and corrugated iron, proved no match for its Category 5 winds that
			exceeded 280 km/h.
		</p>
		<p>
			Compounding this vulnerability, the vast majority of rural residents <a
				href="https://www.ucl.ac.uk/mathematical-physical-sciences/blogs/2026/feb/how-cyclone-winston-affected-people-and-what-we-learnt-it"
				target="_blank"
				rel="noreferrer">lacked</a
			> any form of property or crop insurance, leaving them dependent on external
			aid.
		</p>
		<p>
			Four years later, Tropical Cyclone Harold struck Fiji, Vanuatu, and Tonga,
			causing an additional 10,000 displacements and complicating recovery
			efforts while communities struggled under the restrictions and economic
			strains of the COVID-19 pandemic.
		</p>
	</div>
	<CycloneHaroldBeforeAfter />
</section>

<section class="chapter" aria-labelledby="chapter-three-title">
	<header id="chapter-three">
		<p>Chapter 3</p>
		<h2 id="chapter-three-title"><em>When Disasters Don’t End</em></h2>
		built
	</header>
	<div class="copy">
		<p>
			Displacement from climate disasters in the Pacific is not a single,
			isolated event but a chronic, recurring cycle that resets national
			development.
		</p>
		<p>
			From 2016 to 2021, Pacific nations endured 13 extreme weather events,
			including three regional record-breakers. Globally, the gap between
			billion-dollar disasters has <a
				href="https://www.wri.org/insights/climate-adaptation-investment-case"
				target="_blank"
				rel="noreferrer">shrunk</a
			> from an average of 82 days (1980s) to 19 days (2020s), per Council Fire and
			the World Resources Institute. This leaves communities with no time to rebuild
			before the next strike.
		</p>
		<p>
			Papua New Guinea leads the region with 81 displacement events over 15
			years. It <a
				href="https://crisisresponse.iom.int/response/papua-new-guinea-crisis-response-plan-2024"
				target="_blank"
				rel="noreferrer">ranks</a
			>
			16th globally for disaster risk on the
			<a
				href="https://drmkc.jrc.ec.europa.eu/inform-index"
				target="_blank"
				rel="noreferrer">INFORM Risk Index</a
			>, vulnerable to floods, droughts, and cyclones.
		</p>
	</div>
	<PacificDisplacementBubbleMap />
	<div class="copy">
		<p>
			Lacking a systemic cushion, it <a
				href="https://www.cfe-dmha.org/LinkClick.aspx?fileticket=zIfiG4v6fM4%3D&portalid=0"
				target="_blank"
				rel="noreferrer">ranks</a
			> 10th globally for severe lack of coping capacity. When disasters hit, neither
			residents nor the national government has the fiscal reserves to rebuild. Between
			2008 and 2022, 54 major disasters led to over 282,000 internal displacements.
		</p>
	</div>
</section>

<section class="chapter" aria-labelledby="chapter-four-title">
	<header id="chapter-four">
		<p>Chapter 4</p>
		<h2 id="chapter-four-title"><em>What Happens After Disasters?</em></h2>
	</header>
	<div class="copy">
		<h3>Legacy of environmental hazards</h3>
		<p>
			Climate disasters not only destroy homes and public infrastructure, but
			also expose buried toxic legacies, most visibly in the Marshall Islands.
		</p>
		<p>
			Between 1946 and 1958, the U.S. military <a
				href="https://www.latimes.com/projects/marshall-islands-nuclear-testing-sea-level-rise/"
				target="_blank"
				rel="noreferrer">detonated</a
			>
			67 nuclear weapons here, including the 15-megaton "Castle Bravo" blast — 1,000
			times more powerful than the bomb dropped on Hiroshima and Nagasaki combined.
			The explosion blanketed
			<a
				href="https://nukedivestmentscotland.org/wp-content/uploads/2020/08/nwce-report-final-1.pdf"
				target="_blank"
				rel="noreferrer">11,000 square kilometers</a
			> in radioactive fallout, rendering islands uninhabitable and displacing indigenous
			populations.
		</p>
		<p>
			Later, the U.S. military <a
				href="https://marshallislands.llnl.gov/ccc/Hamilton_LLNL-TR-648143_final.pdf"
				target="_blank"
				rel="noreferrer">bulldozed</a
			> 90,000 cubic meters of contaminated soil into the Runit Dome crater, capping
			it with an 18-inch-thick concrete dome. To save time and expense, the bottom
			of the crater was never lined with concrete.
		</p>
	</div>
	<RunitDomeFigure />
	<div class="copy">
		<p>
			As sea levels rise, high tides flush radioactive plutonium through the
			unlined crater and into the North Equatorial Current, where it has been <a
				href="https://climate.law.columbia.edu/sites/climate.law.columbia.edu/files/content/docs/Michael%20Gerrard/Gerrard-2015-06-Americas-Forgotten-Nuclear-Waste-Dump-in-the-Pacific.pdf"
				target="_blank"
				rel="noreferrer">detected</a
			> over 2,800 miles away.
		</p>
		<p>
			With typhoons threatening to breach the concrete cap, Runit Dome is a
			ticking nuclear-climate time bomb and an environmental injustice
			threatening a new wave of displacement.
		</p>
		<p>
			Climate disasters compounding with fragile infrastructure, compromised
			freshwater, and contaminated ecosystems make recovery far more complex
			than rebuilding homes alone.
		</p>
		<h3>Economic loss</h3>
		<p>
			Climate disasters cripple regional economies. For example, Fiji recorded
			approximately $374M USD in direct losses in 2016 from Cyclones Winston,
			Xena, and a tropical depression.
		</p>
		<p>
			In 2020, Tropical Cyclone Harold hit after border closures had already
			devastated the tourism sector — the lifeblood of the Fijian economy —
			causing a 20% contraction in Fiji's GDP. This represents “<a
				href="https://pmc.ncbi.nlm.nih.gov/articles/PMC10171413/"
				target="_blank"
				rel="noreferrer">cascading vulnerabilities</a
			>,” where a subsequent disaster strikes a population with already depleted
			defenses.
		</p>
	</div>
	<EconomicLossAffectedPopulation />
	<div class="copy">
		<p>
			To rebuild critical infrastructure like roads and hospitals after such
			shocks, low-lying island nations must borrow massive sums relative to
			their small economies, trapping them in a debt loop.
		</p>
		<p>
			As global aid <a
				href="https://pacificaidmap.lowyinstitute.org/analysis/2025/key-findings/"
				target="_blank"
				rel="noreferrer">contracts</a
			>
			by 16% due to deep U.S. and U.K. funding cuts, Pacific nations are forced to
			<a
				href="https://www.youtube.com/watch?v=zrmQit14c-A"
				target="_blank"
				rel="noreferrer">spend</a
			> 30% of their national budgets on climate adaptation, such as constructing
			seawalls, building embankments, and desalinating water.
		</p>
		<h3>Tuberculosis incidence</h3>
		<p>Displacement triggers a dangerous public health feedback loop.</p>
		<p>
			In the Pacific, 90% of people live within five kilometers of a coastline
			and over a quarter within one kilometer. In South Tarawa, Kiribati, <a
				href="https://nso.gov.ki/population/kiribati-census-atlas-2022/"
				target="_blank"
				rel="noreferrer">over 60,000 residents</a
			>
			are crammed into a 15-square-kilometer strip of land. Households average more
			than seven people, and it is
			<a
				href="https://www.amnestyusa.org/wp-content/uploads/2025/10/Navigating-Injustice-Climate-Displacement-from-the-Pacific-Islands-of-Tuvalu-and-Kiribati-to-Aotearoa-New-Zealand.pdf"
				target="_blank"
				rel="noreferrer">common</a
			> for 15 to 40 people to share tiny, two-room traditional dwellings.
		</p>
		<p>
			Fleeing sinking outer islands for centralized urban refuges creates
			extreme crowding and makes airborne diseases like Tuberculosis (TB)
			rampant.
		</p>
		<p>
			In 2023, the Marshall Islands recorded the region's highest TB rate (692
			per 100,000 people), a 723% surge since 2000. Kiribati and Tuvalu follow,
			exceeding the regional median of 48 per 100,000 people, based on Pacific
			Data Hub findings.
		</p>
	</div>
	<TBIncidenceHistory />
	<div class="copy">
		<h3>Unsafe drinking water</h3>
		<p>
			Floods and droughts leave communities without safe water by contaminating
			or depleting supplies. Low-lying coral atolls lack rivers. So, they rely
			on fragile rainwater harvesting and underground freshwater lenses that
			rising seas and King tides poison via saltwater intrusion.
		</p>
		<p>
			Papua New Guinea has the region's lowest water security, with nearly half
			the population lacking safe access as of 2022. The Solomon Islands saw
			safe water access plummet by approximately 12 percentage points, from 79%
			in 2000 to 67% in 2021. In Kiribati, unsafe water fuels disease,
			contributing to the region's <a
				href="https://childfundalliance.org/"
				target="_blank"
				rel="noreferrer">highest</a
			> infant mortality rate.
		</p>
	</div>
	<DrinkingWaterSlopeChart />
	<div class="copy">
		<h3>Undernourishment</h3>
		<p>
			Climate disasters and saltwater intrusion destroy traditional crops and
			ruin agricultural soil, increasing reliance on low-nutrient, imported
			processed canned goods, like canned spam.
		</p>
		<p>
			As of 2023, the Food and Agriculture Organization of the United Nations
			(FAO) estimates 29% of Papua New Guinea’s population is undernourished.
			During the 2015–2016 El Niño, severe drought triggered famine, impacting
			1.3 million people and leaving 480,000 in critical shortage. Meanwhile,
			undernourishment rates in the Solomon Islands nearly doubled to 20% by
			2023.
		</p>
	</div>
	<UndernourishmentSlopeChart />
	<div class="copy">
		<p>
			This dietary shift sparked a metabolic crisis: 82% of adults are
			overweight or obese, 33% have hypertension, and 40% have high cholesterol.
			Because diabetes and obesity compromise immune systems, they <a
				href="https://pubmed.ncbi.nlm.nih.gov/39177079/"
				target="_blank"
				rel="noreferrer">increase</a
			> susceptibility to active Tuberculosis.
		</p>
	</div>
</section>

<section class="chapter" aria-labelledby="chapter-five-title">
	<header id="chapter-five">
		<p>Chapter 5</p>
		<h2 id="chapter-five-title"><em>Fighting Back</em></h2>
	</header>
	<div class="copy">
		<p>For many, leaving home is a last resort.</p>
		<p>
			Yet, communities fight for their needs within a legal vacuum. The 1951
			Refugee Convention <a
				href="https://www.elr.info/sites/default/files/article/2020/06/50.10540.pdf"
				target="_blank"
				rel="noreferrer">does not recognize</a
			>
			climate displacement as grounds for refugee status, while strict immigration
			barriers like New Zealand’s
			<a
				href="https://www.immigration.govt.nz/opsmanual/"
				target="_blank"
				rel="noreferrer">Acceptable Standard of Health</a
			> (ASH) rules offer no sanctuary. Under ASH, applicants are rejected if they
			place a high demand on health services, with mandatory medical waiver denials
			for those with certain tuberculosis conditions.
		</p>
		<p>
			Across the Pacific, governments, Indigenous leaders, and communities are
			investing in proactive measures like restoring mangrove forests and coral
			reefs and upgrading early warning systems to preempt displacement. They
			are guided by a <a
				href="https://pacificresiliencepartnership.org/framework-resilient-development-pacific/"
				target="_blank"
				rel="noreferrer">principle</a
			> that climate resilience and adaptation succeed only when it is community-led
			to protect culture, livelihoods, and vital connection to place.
		</p>
	</div>
	<GoodPracticesCardGrid />
	<div class="copy">
		<p>
			Fiji leads in planned climate relocation with its 130-page blueprint, the
			<a
				href="https://fijiclimatechangeportal.gov.fj/ppss/standard-operating-procedures-for-planned-relocation-in-the-republic-of-fiji/"
				target="_blank"
				rel="noreferrer"
				>Standard Operating Procedures (SOP) for Planned Relocations</a
			>. The SOP mandates exhausting all engineering solutions — like river
			dredging, raising homes, and building seawalls — before approving any
			move.
		</p>
		<p>
			Foundational rules stemmed from mixed results in early relocations. In
			2014, Vunidogoloa became Fiji's first climate-relocated village, moving
			140 residents two kilometers inland. Though safe, they lost proximity to
			ancestral burial grounds and fishing reefs. Because only male leaders were
			consulted, the new homes lacked kitchens.
		</p>
		<p>
			Tukuraki was devastated by a 2012 landslide that buried half the village
			and killed four people. Before relocating to a resilient site in 2017,
			survivors endured makeshift tents and caves as Cyclones Evan (2013) and
			Winston (2016) destroyed temporary infrastructure. However, a lack of
			formal financial contracts caused social friction, as Tukuraki's modern
			amenities surpassed those of the host community.
		</p>
		<p>
			These early lessons prompted Fiji to mandate 90% community consent for
			relocations. Currently, six villages have moved, and nearly <a
				href="https://mecc.gov.fj/information-sharing-session-on-climate-relocation-of-communities-croc-trust-fund/"
				target="_blank"
				rel="noreferrer">50 Fijian villages</a
			> face potential relocation.
		</p>
		<p>
			Relocation is expensive. The cost of physically moving Nabavatu village in
			Fiji alone exceeded $2.5 million USD. Over 460 people have been forced to
			live in temporary disaster tents for over five years.
		</p>
		<p>
			Fiji established the world's first legislated national <a
				href="https://climate-laws.org/document/climate-relocation-of-communities-trust-fund-act-2019-an-act-to-establish-a-trust-fund-for-the-planned-relocation-of-communities-in-fiji-that-are-adversely-affected-by-climate-change-act-no-21-of-2019_24e5"
				target="_blank"
				rel="noreferrer"
				>Climate Relocation of Communities (CROC) Trust Fund Act</a
			>
			dedicated to planned climate relocation in 2019, funded locally through a 3%
			contribution from Fiji's Environmental and Climate Adaptation Levy (ECAL) on
			the tourism sector and luxury goods. Likewise, the
			<a
				href="https://www.dfat.gov.au/geo/pacific/development-assistance/climate-change-and-resilience"
				target="_blank"
				rel="noreferrer">Pacific Resilience Facility</a
			> (PRF) is a Pacific-owned, grant-based regional fund designed to bypass the
			rigid, slow, and bureaucratic administrative hurdles of massive global financial
			institutions.
		</p>
		<p>
			Investing in climate adaptation solutions is high-yield. The <a
				href="https://www.wri.org/research/climate-adaptation-investment-case"
				target="_blank"
				rel="noreferrer">World Resources Institute</a
			> (WRI) estimated that for every $1 UDS spent returns $10.50 USD in net economic
			benefits over a 10-year horizon. This proactive model unlocks daily commercial,
			social, and environmental gains that far exceed the value of avoided losses
			alone. This includes, but is not limited to, local job creation, agricultural
			productivity, and ecosystem health. The investment pays off continuously, even
			if a disaster never strikes.
		</p>
	</div>
	<footer class="notes" id="methodology-credits">
		<section>
			<h3><em>Methodology & Data</em></h3>
			<p>
				I built this essay with D3.js and Svelte. The code is available on <a
					href="https://github.com/Elhamyali/when-home-moves-pacific"
					target="_blank"
					rel="noreferrer">GitHub</a
				>.
			</p>
			<p>
				I used R (v4.6.1) to analyze historical datasets on climate disasters,
				disaster-related internal displacement, population impacts, public
				health, and economic losses from the Pacific Data Hub and the Internal
				Displacement Monitoring Centre (IDMC). All datasets and analysis code
				are available on <a
					href="https://github.com/Elhamyali/when-home-moves-pacific-data-analysis"
					target="_blank"
					rel="noreferrer">GitHub</a
				>.
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
				>, which helped me bring this interactive essay to life.
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
			600 clamp(20px, 2.5vw, 30px) / 1.2 "Inter",
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
		font-family: "Playfair Display", serif;
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
