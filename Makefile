PHONY: github

github:
	rm -rf docs
	cp -r build docs
	touch docs/.nojekyll
	git add -A
	git commit -m "update github pages"
	git push

protect:
	cd build && npx staticrypt --short index.html -p $(shell grep PASSWORD .env | cut -d '=' -f2) -d .

staging: 
	npm run build
	make github
