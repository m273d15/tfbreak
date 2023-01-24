build:
	go mod tidy
	go build

test: go-test opa-test

go-test:
	go test -v ./...

opa-test:
	opa test --explain full .

fmt:
	go fmt ./...
