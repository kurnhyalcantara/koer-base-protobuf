#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Default directories
PROTO_DIR="proto"
GEN_GO_DIR="gen/go"

# Usage check
if [ "$#" -eq 0 ]; then
  echo "Error: No service names provided."
  echo "Usage: $0 <service-name> [<service-name>...]"
  echo "Example: $0 user-service auth-service product-service"
  exit 1
fi

SERVICES=("$@")

echo "Starting code generation..."

# Ensure base generation directory exists
mkdir -p "$GEN_GO_DIR"

for SERVICE in "${SERVICES[@]}"; do
  # Determine path
  service_proto_dir="$PROTO_DIR/$SERVICE"
  
  if [ ! -d "$service_proto_dir" ]; then
    echo "Error: Service directory '$service_proto_dir' not found."
    exit 1
  fi

  # Find all .proto files for the given service
  PROTO_FILES=$(find "$service_proto_dir" -name "*.proto")

  if [ -z "$PROTO_FILES" ]; then
    echo "Error: No .proto files found for service '$SERVICE'."
    exit 1
  fi

  # Clean existing generated files for this specific service
  service_gen_dir="$GEN_GO_DIR/$SERVICE"
  if [ -d "$service_gen_dir" ]; then
    echo "Cleaning previous generated files for $SERVICE ($service_gen_dir)..."
    rm -rf "$service_gen_dir"
  fi

  echo "Compiling proto files for $SERVICE..."

  # Run protoc
  protoc \
    --proto_path="$PROTO_DIR" \
    --go_out="$GEN_GO_DIR" \
    --go_opt=paths=source_relative \
    --go-grpc_out="$GEN_GO_DIR" \
    --go-grpc_opt=paths=source_relative \
    $PROTO_FILES

  echo "Successfully generated Go code for $SERVICE."
  echo "----------------------------------------"
done

echo "✅ All specified services generated successfully."
