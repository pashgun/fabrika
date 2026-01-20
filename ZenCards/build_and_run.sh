#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Functions
print_header() {
    echo -e "${BLUE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}→ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# 1. Check prerequisites
check_xcode() {
    if ! command -v xcodebuild &> /dev/null; then
        print_error "Xcode not found"
        echo ""
        echo "Please install Xcode from the App Store:"
        echo "https://apps.apple.com/app/xcode/id497799835"
        exit 1
    fi

    XCODE_VERSION=$(xcodebuild -version | head -1)
    print_success "Xcode found: $XCODE_VERSION"
}

check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found"
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed"
    else
        print_success "Homebrew found"
    fi
}

check_xcodegen() {
    if ! command -v xcodegen &> /dev/null; then
        print_step "Installing xcodegen..."
        brew install xcodegen
        print_success "xcodegen installed"
    else
        print_success "xcodegen ready"
    fi
}

# 2. Generate Xcode project
generate_project() {
    print_step "Generating Xcode project from project.yml..."

    if [ ! -f "project.yml" ]; then
        print_error "project.yml not found"
        exit 1
    fi

    xcodegen generate

    if [ -f "ZenCards.xcodeproj/project.pbxproj" ]; then
        print_success "ZenCards.xcodeproj created"
    else
        print_error "Failed to generate Xcode project"
        exit 1
    fi
}

# 3. Resolve SPM dependencies
resolve_deps() {
    print_step "Resolving Swift Package dependencies (FSRS)..."

    xcodebuild \
        -resolvePackageDependencies \
        -project ZenCards.xcodeproj \
        -scheme ZenCards \
        2>&1 | grep -v "^$" || true

    print_success "FSRS package resolved"
}

# 4. Build project
build_project() {
    print_step "Building ZenCards (app + widget)..."
    echo ""

    xcodebuild \
        -project ZenCards.xcodeproj \
        -scheme ZenCards \
        -sdk iphonesimulator \
        -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
        -configuration Debug \
        build \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        2>&1 | xcbeautify || xcodebuild \
        -project ZenCards.xcodeproj \
        -scheme ZenCards \
        -sdk iphonesimulator \
        -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
        -configuration Debug \
        build \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO

    echo ""
    print_success "Build successful"
}

# 5. Boot simulator
boot_simulator() {
    print_step "Starting iOS Simulator (iPhone 15 Pro)..."

    # Find iPhone 15 Pro
    DEVICE_ID=$(xcrun simctl list devices | grep "iPhone 15 Pro" | grep -v "unavailable" | head -1 | grep -oE '[0-9A-F-]{36}')

    if [ -z "$DEVICE_ID" ]; then
        print_error "iPhone 15 Pro simulator not found"
        echo ""
        echo "Available simulators:"
        xcrun simctl list devices | grep "iPhone" | grep -v "unavailable"
        echo ""
        echo "To add iPhone 15 Pro:"
        echo "1. Open Xcode"
        echo "2. Window → Devices and Simulators"
        echo "3. Click + button"
        echo "4. Select iPhone 15 Pro"
        exit 1
    fi

    # Boot simulator if not already booted
    xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true

    # Open Simulator app
    open -a Simulator

    # Wait for simulator to fully boot
    print_step "Waiting for simulator to boot..."
    MAX_WAIT=60
    WAITED=0
    while [ $WAITED -lt $MAX_WAIT ]; do
        if xcrun simctl bootstatus "$DEVICE_ID" 2>/dev/null | grep -q "Boot status: Booted"; then
            break
        fi
        sleep 1
        WAITED=$((WAITED + 1))
    done

    if [ $WAITED -ge $MAX_WAIT ]; then
        print_error "Simulator failed to boot within ${MAX_WAIT}s"
        exit 1
    fi

    print_success "Simulator ready (UDID: ${DEVICE_ID:0:8}...)"
}

# 6. Install and launch app
install_and_run() {
    print_step "Installing ZenCards on simulator..."

    # Find built .app bundle
    APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -name "ZenCards.app" -type d | head -1)

    if [ -z "$APP_PATH" ]; then
        print_error "ZenCards.app not found in DerivedData"
        echo ""
        echo "Build artifacts location:"
        echo "~/Library/Developer/Xcode/DerivedData/"
        exit 1
    fi

    DEVICE_ID=$(xcrun simctl list devices | grep "iPhone 15 Pro" | grep -v "unavailable" | head -1 | grep -oE '[0-9A-F-]{36}')

    # Install app
    xcrun simctl install "$DEVICE_ID" "$APP_PATH"
    print_success "App installed"

    # Launch app
    print_step "Launching ZenCards..."
    xcrun simctl launch "$DEVICE_ID" com.zencards.app

    echo ""
    print_header "✨ ZenCards is running! ✨"
    echo ""
    echo "📱 Check your iOS Simulator"
    echo "🎯 App should open with 3 sample decks:"
    echo "   • Spanish (8 cards)"
    echo "   • Swift Basics (4 cards)"
    echo "   • World Capitals (4 cards)"
    echo ""
    echo "🧪 Test features:"
    echo "   • Flip cards (tap to flip)"
    echo "   • Rate cards (Again/Hard/Easy)"
    echo "   • Create new decks and cards"
    echo "   • Test TTS pronunciation"
    echo ""
    echo "🎨 Test widget:"
    echo "   1. Long press on Home Screen"
    echo "   2. Tap + button (top left)"
    echo "   3. Search 'ZenCards'"
    echo "   4. Add Medium or Large widget"
    echo "   5. Tap Hard/Easy buttons on widget"
    echo ""
    echo "📝 To rebuild:"
    echo "   ./build_and_run.sh"
    echo ""
    echo "🔧 To open in Xcode:"
    echo "   open ZenCards.xcodeproj"
    echo ""
}

# Main execution
main() {
    print_header "ZenCards Build & Run"

    echo "Step 1/6: Checking prerequisites..."
    check_xcode
    check_homebrew
    check_xcodegen
    echo ""

    echo "Step 2/6: Generating Xcode project..."
    generate_project
    echo ""

    echo "Step 3/6: Resolving dependencies..."
    resolve_deps
    echo ""

    echo "Step 4/6: Building project..."
    build_project
    echo ""

    echo "Step 5/6: Starting simulator..."
    boot_simulator
    echo ""

    echo "Step 6/6: Installing and launching..."
    install_and_run
}

# Run main
main "$@"
