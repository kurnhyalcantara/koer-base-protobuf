.PHONY: generate clean deps check lint format

# Install standard protocol buffer dependencies
deps:
	@echo "Installing Go protocol buffer plugins..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	@echo "Dependencies installed. Ensure you have 'buf' installed system-wide (e.g., brew install buf)."

# Generate code using Buf
generate:
	@echo "Generating protobuf files with Buf..."
	buf generate

# Format proto files
format:
	@echo "Formatting proto files..."
	buf format -w

# Lint proto files
lint:
	@echo "Linting proto files..."
	buf lint

# Clean all generated files
clean:
	@echo "Cleaning gen directory..."
	rm -rf gen/go/*

check:
	@echo "Formatting go files and verifying module..."
	go mod tidy
	go build ./...
