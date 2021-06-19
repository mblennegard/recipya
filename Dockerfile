# STAGE 1: prepare
FROM golang AS prepare

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /source 

COPY go.mod .
COPY go.sum .
RUN go mod download

RUN apt-get update 
RUN apt-get install -y nodejs npm
RUN npm install -g yarn
RUN yarn global add @vue/cli
RUN apt-get clean

# STAGE 2: build
FROM prepare as build

COPY . .

RUN go build -o main .
RUN cd /source/web/app && yarn build

WORKDIR /dist 

RUN cp /source/main .  

# STAGE 3: run
FROM scratch as run

COPY --from=build /dist/main /
COPY --from=build /source/web/app/dist /dist
COPY --from=build /source/dist/config.yaml /

EXPOSE 3001

ENTRYPOINT ["/main", "serve"]
