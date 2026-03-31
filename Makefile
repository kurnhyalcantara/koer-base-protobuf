.PHONY: generate clean deps check

SERVICES = user-service auth-service product-service

# Install standard protocol buffer dependencies
deps:
	@echo "Installing Go protocol buffer plugins..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@echo "Dependencies installed."

# Generate code for all services
generate:
	@echo "Generating protobuf files..."
	chmod +x scripts/generate.sh
	./scripts/generate.sh $(SERVICES)

# Clean all generated files
clean:
	@echo "Cleaning gen directory..."
	rm -rf gen/go/*

check:
	@echo "Formatting go files and verifying module..."
	go mod tidy
	go build ./...
