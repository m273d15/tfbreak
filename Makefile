version := 0.1.0
bin_name := tfbreak
build:
	go mod tidy
	go build -o $(bin_name)-$(version)

build-linux:
	env GOARCH=amd64 GOOS=linux go build -ldflags="-s -w" -o $(bin_name)-linux-amd64-$(version)

test: go-test opa-test

go-test:
	go test -v ./...

opa-test:
	opa test --explain full .

fmt:
	go fmt ./...
