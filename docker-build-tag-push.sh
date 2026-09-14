#!/bin/bash
set -e

# Default values
NAMESPACE=""
VERSION=""
IMAGE_NAME=""
BUILD_ARGS=()
NO_CACHE=false

# Function to show usage
show_usage() {
    echo "Usage: docker-push [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -n, --name <name>        Image name (Required)"
    echo "  -v, --version <tag>      Image version tag (Required)"
    echo "  --ns, --namespace <ns>   Namespace (Required)"
    echo "  --arg <key=value>        Build argument (Can be used multiple times)"
    echo "  --no-cache               Disable Docker build cache (Default: false)"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Example:"
    echo "  docker-push --name myapp --version v1.0.0 --ns mynamespace --arg ENV=prod"
    echo "  docker-push --name myapp --version v1.0.0 --ns mynamespace --no-cache"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--name)
            IMAGE_NAME="$2"
            shift 2
            ;;
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        --ns|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        --arg|--build-arg)
            BUILD_ARGS+=("--build-arg" "$2")
            shift 2
            ;;
        --no-cache)
            NO_CACHE=true
            shift
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            echo "❌ Unknown argument: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate required arguments
if [ -z "$IMAGE_NAME" ] || [ -z "$VERSION" ] || [ -z "$NAMESPACE" ]; then
    echo "❌ Error: Image name, version, and namespace are required."
    show_usage
    exit 1
fi

FULL_IMAGE_NAME="$NAMESPACE/$IMAGE_NAME:$VERSION"
LOCAL_IMAGE_TAG="$IMAGE_NAME:$VERSION"

echo "🚀 Starting deployment for $FULL_IMAGE_NAME"
echo "----------------------------------------"

TOTAL_START_TIME=$(date +%s)

format_time() {
    local T=$1
    local M=$((T/60))
    local S=$((T%60))
    if [ $M -gt 0 ]; then
        echo "${M}m ${S}s"
    else
        echo "${S}s"
    fi
}

# Step 1: Build
echo "🔨 Step 1: Building Docker image..."
STEP1_START_TIME=$(date +%s)
# Construct build command with array expansion for build args
cmd=(docker build)
if [ "$NO_CACHE" = true ]; then
    cmd+=("--no-cache")
fi
if [ ${#BUILD_ARGS[@]} -gt 0 ]; then
    cmd+=("${BUILD_ARGS[@]}")
fi
cmd+=(-t "$LOCAL_IMAGE_TAG" .)

# Execute build
"${cmd[@]}"
STEP1_END_TIME=$(date +%s)
STEP1_DURATION=$((STEP1_END_TIME - STEP1_START_TIME))
echo "✅ Docker image built successfully."
echo ""

# Step 2: Tag
echo "🏷️  Step 2: Tagging image..."
STEP2_START_TIME=$(date +%s)
docker tag "$LOCAL_IMAGE_TAG" "$FULL_IMAGE_NAME"
STEP2_END_TIME=$(date +%s)
STEP2_DURATION=$((STEP2_END_TIME - STEP2_START_TIME))
echo "✅ Image tagged as $FULL_IMAGE_NAME"
echo ""

# Step 3: Push
echo "📤 Step 3: Pushing to registry..."
STEP3_START_TIME=$(date +%s)
docker push "$FULL_IMAGE_NAME"
STEP3_END_TIME=$(date +%s)
STEP3_DURATION=$((STEP3_END_TIME - STEP3_START_TIME))
echo "✅ Image pushed successfully."
echo ""

TOTAL_END_TIME=$(date +%s)
TOTAL_DURATION=$((TOTAL_END_TIME - TOTAL_START_TIME))

echo "🎉 Deployment completed successfully!"
echo "----------------------------------------"
echo "⏱️  Execution Time Summary:"
echo "   - Step 1 (Build): $(format_time $STEP1_DURATION)"
echo "   - Step 2 (Tag)  : $(format_time $STEP2_DURATION)"
echo "   - Step 3 (Push) : $(format_time $STEP3_DURATION)"
echo "   - Total Time    : $(format_time $TOTAL_DURATION)"
echo "----------------------------------------"