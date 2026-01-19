#!/bin/bash

# Fabrika - Mobile App Factory CLI
# Orchestrates AI agents to build iOS apps

set -e

FACTORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$FACTORY_DIR/.factory/agents"
HANDOFFS_DIR="$FACTORY_DIR/.factory/handoffs"
PROJECTS_DIR="$FACTORY_DIR/projects"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Print colored output
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}🏭  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

print_step() {
    echo -e "${MAGENTA}▸ $1${NC}"
}

# Initialize factory structure if needed
init_factory() {
    mkdir -p "$HANDOFFS_DIR"
    mkdir -p "$PROJECTS_DIR"
    print_success "Factory structure initialized"
}

# Print usage
usage() {
    cat <<EOF
${CYAN}Fabrika - Mobile App Factory${NC}

${YELLOW}Usage:${NC} factory.sh <command> [options]

${YELLOW}Commands:${NC}
    ${GREEN}start <idea>${NC}        Start full factory pipeline with project idea
    ${GREEN}clone <url>${NC}         Clone app from App Store URL with modern design
    ${GREEN}app_analyzer${NC}        Run Phase 0: App Analysis (for cloning)
    ${GREEN}pm_lead${NC}            Run Phase 1: Product Marketing (Research)
    ${GREEN}ui_engineer${NC}        Run Phase 2: UI Engineering (Design)
    ${GREEN}swift_dev${NC}          Run Phase 3: Swift Development (Build)
    ${GREEN}qa_audit${NC}           Run Phase 4: QA & Audit (Testing)
    ${GREEN}aso_expert${NC}         Run Phase 5: ASO (Delivery)
    ${GREEN}status${NC}             Show current factory status
    ${GREEN}list${NC}               List all projects
    ${GREEN}help${NC}               Show this help

${YELLOW}Options:${NC}
    ${CYAN}--local${NC}             Create project in fabrika/projects/ (default)
    ${CYAN}--repo <path>${NC}       Create separate git repository at path
    ${CYAN}--existing${NC}          Work with existing project in current directory
    ${CYAN}--project <name>${NC}    Specify existing project name
    ${CYAN}--input <text>${NC}      Provide input for agent
    ${CYAN}--url <url>${NC}         App Store URL for cloning/analysis

${YELLOW}Examples:${NC}
    ${GREEN}# Create local project${NC}
    ./factory.sh start "Meditation app like Calm" --local

    ${GREEN}# Clone existing app from App Store${NC}
    ./factory.sh clone "https://apps.apple.com/us/app/calm/id571800810" --local

    ${GREEN}# Analyze app without building (Phase 0 only)${NC}
    ./factory.sh app_analyzer --url "https://apps.apple.com/app/headspace/id493145008"

    ${GREEN}# Create separate repository${NC}
    ./factory.sh start "Fitness tracker" --repo /home/user/FitnessApp

    ${GREEN}# Run specific phase${NC}
    ./factory.sh pm_lead --input "Recipe sharing app"

    ${GREEN}# Work with existing project${NC}
    cd /path/to/existing/project
    /path/to/fabrika/factory.sh swift_dev --existing

    ${GREEN}# List all projects${NC}
    ./factory.sh list

EOF
}

# Run specific agent
run_agent() {
    local agent_name=$1
    local agent_file="$AGENTS_DIR/${agent_name}.md"

    if [ ! -f "$agent_file" ]; then
        print_error "Agent file not found: $agent_file"
        exit 1
    fi

    print_header "Invoking Agent: $agent_name"
    print_info "Agent file: $agent_file"
    echo ""

    # Check if Claude Code is available
    if ! command -v claude &> /dev/null; then
        print_error "Claude Code CLI not found"
        print_info "Please install Claude Code: https://claude.ai/code"
        exit 1
    fi

    # Invoke Claude Code with agent file
    print_step "Starting Claude Code with agent $agent_name..."
    echo ""
    claude code --agent "$agent_file"

    echo ""
    print_success "Agent $agent_name completed"
}

# Run agent with specific context/input
run_agent_with_context() {
    local agent_name=$1
    local context=$2
    local agent_file="$AGENTS_DIR/${agent_name}.md"

    if [ ! -f "$agent_file" ]; then
        print_error "Agent file not found: $agent_file"
        exit 1
    fi

    print_header "Invoking Agent: $agent_name"
    print_info "Agent file: $agent_file"
    print_info "Context: $context"
    echo ""

    # Check if Claude Code is available
    if ! command -v claude &> /dev/null; then
        print_error "Claude Code CLI not found"
        print_info "Please install Claude Code: https://claude.ai/code"
        exit 1
    fi

    # Invoke Claude Code with agent file and context
    print_step "Starting Claude Code with agent $agent_name..."
    echo ""

    # Create a temporary prompt that includes both the agent file and the context
    local temp_prompt=$(mktemp)
    echo "Context: $context" > "$temp_prompt"
    echo "" >> "$temp_prompt"
    echo "Please follow the instructions in the agent file." >> "$temp_prompt"

    claude code --agent "$agent_file" --prompt "$(cat $temp_prompt)"
    rm "$temp_prompt"

    echo ""
    print_success "Agent $agent_name completed"
}

# Show status
show_status() {
    print_header "Factory Status"

    if [ -d "$PROJECTS_DIR" ] && [ "$(ls -A $PROJECTS_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}Local Projects:${NC}"
        ls -1 "$PROJECTS_DIR" | while read project; do
            echo -e "  ${GREEN}▸${NC} $project"
        done
    else
        print_info "No local projects yet"
    fi

    echo ""
    echo -e "${YELLOW}Agents Available:${NC}"
    ls -1 "$AGENTS_DIR" | sed 's/.md//' | while read agent; do
        echo -e "  ${CYAN}▸${NC} $agent"
    done

    echo ""
    if [ -d "$HANDOFFS_DIR" ] && [ "$(ls -A $HANDOFFS_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}Recent Handoffs:${NC}"
        ls -1t "$HANDOFFS_DIR" | head -5 | while read handoff; do
            echo -e "  ${MAGENTA}▸${NC} $handoff"
        done
    fi
}

# List projects
list_projects() {
    print_header "Projects List"

    if [ -d "$PROJECTS_DIR" ] && [ "$(ls -A $PROJECTS_DIR 2>/dev/null)" ]; then
        local count=0
        ls -1 "$PROJECTS_DIR" | while read project; do
            count=$((count + 1))
            echo -e "${GREEN}$count.${NC} ${CYAN}$project${NC}"
            if [ -f "$PROJECTS_DIR/$project/backlog.md" ]; then
                echo -e "   ${YELLOW}└─${NC} backlog.md exists"
            fi
            if [ -f "$PROJECTS_DIR/$project/design_system.md" ]; then
                echo -e "   ${YELLOW}└─${NC} design_system.md exists"
            fi
            if [ -d "$PROJECTS_DIR/$project"/*.xcodeproj 2>/dev/null ]; then
                echo -e "   ${YELLOW}└─${NC} Xcode project exists"
            fi
            echo ""
        done
    else
        print_info "No projects found"
        echo ""
        print_info "Create a project with: ./factory.sh start \"Your app idea\""
    fi
}

# Main command router
case "${1:-}" in
    start)
        init_factory

        if [ -z "$2" ]; then
            print_error "Please provide project idea"
            echo ""
            echo "Usage: ./factory.sh start \"Your app idea\" [--local|--repo <path>]"
            exit 1
        fi

        PROJECT_IDEA="$2"

        print_header "Starting Fabrika Mobile App Factory"
        echo -e "${YELLOW}Project Idea:${NC} $PROJECT_IDEA"
        echo ""
        print_info "This will run all 5 phases sequentially:"
        echo -e "  ${CYAN}Phase 1:${NC} pm_lead (Research)"
        echo -e "  ${CYAN}Phase 2:${NC} ui_engineer (Design)"
        echo -e "  ${CYAN}Phase 3:${NC} swift_dev (Build)"
        echo -e "  ${CYAN}Phase 4:${NC} qa_audit (Testing)"
        echo -e "  ${CYAN}Phase 5:${NC} aso_expert (Delivery)"
        echo ""

        read -p "$(echo -e ${YELLOW}Continue? \(y/N\) ${NC})" -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Phase 1
            print_step "Starting Phase 1: Research (pm_lead)"
            run_agent "pm_lead"

            echo ""
            print_success "Phase 1 complete: backlog.md created"
            echo ""
            print_info "Review backlog.md before continuing to Phase 2"
            read -p "$(echo -e ${YELLOW}Continue to Phase 2? \(y/N\) ${NC})" -n 1 -r
            echo

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Phase 2
                print_step "Starting Phase 2: Design (ui_engineer)"
                run_agent "ui_engineer"

                echo ""
                print_success "Phase 2 complete: design_system.md created"
                echo ""
                print_info "Review design_system.md before continuing to Phase 3"
                read -p "$(echo -e ${YELLOW}Continue to Phase 3? \(y/N\) ${NC})" -n 1 -r
                echo

                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    # Phase 3
                    print_step "Starting Phase 3: Build (swift_dev)"
                    run_agent "swift_dev"

                    echo ""
                    print_success "Phase 3 complete: Xcode project created"
                    echo ""
                    print_info "Review Xcode project before continuing to Phase 4"
                    read -p "$(echo -e ${YELLOW}Continue to Phase 4? \(y/N\) ${NC})" -n 1 -r
                    echo

                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        # Phase 4
                        print_step "Starting Phase 4: Hard Audit (qa_audit)"
                        run_agent "qa_audit"

                        echo ""
                        print_success "Phase 4 complete: Tests and audits done"
                        echo ""
                        print_info "Review test reports before continuing to Phase 5"
                        read -p "$(echo -e ${YELLOW}Continue to Phase 5? \(y/N\) ${NC})" -n 1 -r
                        echo

                        if [[ $REPLY =~ ^[Yy]$ ]]; then
                            # Phase 5
                            print_step "Starting Phase 5: Delivery (aso_expert)"
                            run_agent "aso_expert"

                            echo ""
                            print_header "🎉 Factory Complete!"
                            echo ""
                            print_success "All 5 phases completed successfully!"
                            echo ""
                            echo -e "${GREEN}✓${NC} Phase 1 (pm_lead): Requirements defined"
                            echo -e "${GREEN}✓${NC} Phase 2 (ui_engineer): Design system created"
                            echo -e "${GREEN}✓${NC} Phase 3 (swift_dev): App implemented"
                            echo -e "${GREEN}✓${NC} Phase 4 (qa_audit): Quality assured"
                            echo -e "${GREEN}✓${NC} Phase 5 (aso_expert): App Store ready"
                            echo ""
                            print_info "Ready for App Store submission! 🚀"
                            echo ""
                        fi
                    fi
                fi
            fi
        fi
        ;;

    clone)
        init_factory

        if [ -z "$2" ]; then
            print_error "Please provide App Store URL"
            echo ""
            echo "Usage: ./factory.sh clone \"<app-store-url>\" [--local|--repo <path>]"
            echo ""
            echo "Example:"
            echo "  ./factory.sh clone \"https://apps.apple.com/us/app/calm/id571800810\" --local"
            exit 1
        fi

        APP_STORE_URL="$2"

        print_header "Cloning App from App Store"
        echo -e "${YELLOW}App Store URL:${NC} $APP_STORE_URL"
        echo ""
        print_info "This will run a 6-phase pipeline:"
        echo -e "  ${CYAN}Phase 0:${NC} app_analyzer (App Analysis)"
        echo -e "  ${CYAN}Phase 1:${NC} pm_lead (Research based on analysis)"
        echo -e "  ${CYAN}Phase 2:${NC} ui_engineer (Modern iOS Design)"
        echo -e "  ${CYAN}Phase 3:${NC} swift_dev (Build)"
        echo -e "  ${CYAN}Phase 4:${NC} qa_audit (Testing)"
        echo -e "  ${CYAN}Phase 5:${NC} aso_expert (Delivery)"
        echo ""

        read -p "$(echo -e ${YELLOW}Continue? \(y/N\) ${NC})" -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Phase 0: App Analysis
            print_step "Starting Phase 0: App Analysis (app_analyzer)"
            run_agent_with_context "app_analyzer" "Analyze this App Store URL: $APP_STORE_URL"

            echo ""
            print_success "Phase 0 complete: app_analysis.md created"
            echo ""
            print_info "Review app_analysis.md before continuing to Phase 1"
            read -p "$(echo -e ${YELLOW}Continue to Phase 1? \(y/N\) ${NC})" -n 1 -r
            echo

            if [[ $REPLY =~ ^[Yy]$ ]]; then
                # Phase 1: pm_lead (now has app_analysis.md to work with)
                print_step "Starting Phase 1: Research (pm_lead) using app_analysis.md"
                run_agent "pm_lead"

                echo ""
                print_success "Phase 1 complete: backlog.md created"
                echo ""
                print_info "Review backlog.md before continuing to Phase 2"
                read -p "$(echo -e ${YELLOW}Continue to Phase 2? \(y/N\) ${NC})" -n 1 -r
                echo

                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    # Phase 2: ui_engineer (with differentiation instructions)
                    print_step "Starting Phase 2: Modern Design (ui_engineer)"
                    run_agent "ui_engineer"

                    echo ""
                    print_success "Phase 2 complete: design_system.md created with modern iOS design"
                    echo ""
                    print_info "Review design_system.md before continuing to Phase 3"
                    read -p "$(echo -e ${YELLOW}Continue to Phase 3? \(y/N\) ${NC})" -n 1 -r
                    echo

                    if [[ $REPLY =~ ^[Yy]$ ]]; then
                        # Phase 3: swift_dev
                        print_step "Starting Phase 3: Build (swift_dev)"
                        run_agent "swift_dev"

                        echo ""
                        print_success "Phase 3 complete: Xcode project created"
                        echo ""
                        print_info "Review Xcode project before continuing to Phase 4"
                        read -p "$(echo -e ${YELLOW}Continue to Phase 4? \(y/N\) ${NC})" -n 1 -r
                        echo

                        if [[ $REPLY =~ ^[Yy]$ ]]; then
                            # Phase 4: qa_audit
                            print_step "Starting Phase 4: Hard Audit (qa_audit)"
                            run_agent "qa_audit"

                            echo ""
                            print_success "Phase 4 complete: Tests and audits done"
                            echo ""
                            print_info "Review test reports before continuing to Phase 5"
                            read -p "$(echo -e ${YELLOW}Continue to Phase 5? \(y/N\) ${NC})" -n 1 -r
                            echo

                            if [[ $REPLY =~ ^[Yy]$ ]]; then
                                # Phase 5: aso_expert
                                print_step "Starting Phase 5: Delivery (aso_expert)"
                                run_agent "aso_expert"

                                echo ""
                                print_header "🎉 App Clone Complete!"
                                echo ""
                                print_success "All 6 phases completed successfully!"
                                echo ""
                                echo -e "${GREEN}✓${NC} Phase 0 (app_analyzer): Original app analyzed"
                                echo -e "${GREEN}✓${NC} Phase 1 (pm_lead): Requirements defined"
                                echo -e "${GREEN}✓${NC} Phase 2 (ui_engineer): Modern design created"
                                echo -e "${GREEN}✓${NC} Phase 3 (swift_dev): App implemented"
                                echo -e "${GREEN}✓${NC} Phase 4 (qa_audit): Quality assured"
                                echo -e "${GREEN}✓${NC} Phase 5 (aso_expert): App Store ready"
                                echo ""
                                print_info "Your modern clone is ready for App Store submission! 🚀"
                                echo ""
                            fi
                        fi
                    fi
                fi
            fi
        fi
        ;;

    app_analyzer)
        init_factory

        # Parse --url option
        if [ "$2" = "--url" ] && [ -n "$3" ]; then
            APP_STORE_URL="$3"
        else
            print_error "Please provide App Store URL"
            echo ""
            echo "Usage: ./factory.sh app_analyzer --url \"<app-store-url>\""
            echo ""
            echo "Example:"
            echo "  ./factory.sh app_analyzer --url \"https://apps.apple.com/us/app/calm/id571800810\""
            exit 1
        fi

        print_header "Analyzing App from App Store"
        echo -e "${YELLOW}App Store URL:${NC} $APP_STORE_URL"
        echo ""
        print_info "This will analyze the app from multiple sources:"
        echo -e "  ${CYAN}▸${NC} App Store listing (screenshots, reviews, description)"
        echo -e "  ${CYAN}▸${NC} YouTube reviews and tutorials"
        echo -e "  ${CYAN}▸${NC} Articles and blog posts"
        echo -e "  ${CYAN}▸${NC} Reddit discussions"
        echo ""

        read -p "$(echo -e ${YELLOW}Continue? \(y/N\) ${NC})" -n 1 -r
        echo

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            run_agent_with_context "app_analyzer" "Analyze this App Store URL: $APP_STORE_URL"

            echo ""
            print_success "Analysis complete: app_analysis.md created"
            echo ""
            print_info "You can now run: ./factory.sh pm_lead"
            print_info "The pm_lead agent will use app_analysis.md to create the backlog"
        fi
        ;;

    pm_lead|ui_engineer|swift_dev|qa_audit|aso_expert)
        init_factory
        run_agent "$1"
        ;;

    status)
        show_status
        ;;

    list)
        list_projects
        ;;

    help|--help|-h|"")
        usage
        ;;

    *)
        print_error "Unknown command: $1"
        echo ""
        usage
        exit 1
        ;;
esac
