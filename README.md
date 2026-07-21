# When Home Moves

Code and data for an interactive visual essay examining displacement from climate disasters across Pacific Island countries and territories.

**[Read the visual essay](https://www.elhamyali.com/when-home-moves-pacific/)**

## Data

The processed data used by the visualizations is stored in [`src/data`](src/data). Sources include the Pacific Data Hub, the Internal Displacement Monitoring Centre, the World Bank, Climate Watch, and other organizations credited within the essay.

The supporting analysis is available in the [`when-home-moves-pacific-data-analysis`](https://github.com/Elhamyali/when-home-moves-pacific-data-analysis) repository.

Third-party datasets, photographs, reporting, and other source material remain subject to their original licenses and attribution requirements.

## Development

This project requires Node.js 22.22 or later.

```bash
npm install
npm run dev
```

## Build and deployment

Create a production build with:

```bash
npm run build
```

The static site is generated in `build/`. Pushes to `main` trigger the GitHub Actions workflow in `.github/workflows/deploy-pages.yml`, which builds and deploys the site to GitHub Pages.

## Credits

Created by [Elham Ali](https://www.elhamyali.com/). Original reporting, project information, analysis, editorial approach, visual design, and styles are by Elham Ali and should be credited when reused or adapted.

Built with SvelteKit using [The Pudding's open-source Svelte starter template](https://github.com/the-pudding/svelte-starter).

Additional data, reporting, image, and technical credits are provided within the visual essay.

## License

The original code in this repository is available under the [MIT License](LICENSE). The copyright and license notice must be retained in copies or substantial portions of the software.

The MIT License does not override the licenses or attribution requirements of third-party material used by the project.
