.ONESHELL:

TAILWIND=pnpm dlx tailwindcss --jit -m --purge="./templates/**/*.gohtml"

build-api:
	go build -o dist/recipya cmd/web/*.go
	cp -R static dist/static
	cp -R templates dist
	cp -R migrations dist

build-css:
	 ${TAILWIND} -o dist/static/css/tailwind.css 

watch: 
	${TAILWIND} -o static/css/tailwind.css -w
	
run:
	go run cmd/web/*.go

build: build-api build-css
