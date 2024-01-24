# Build stage
FROM golang:1.18-alpine AS build

WORKDIR /app

COPY go.mod go.sum main.go ./

RUN go build -o demo-app main.go

# Run stage
FROM alpine:latest

WORKDIR /app

COPY --from=build /app/demo-app .

CMD ["./demo-app"]
